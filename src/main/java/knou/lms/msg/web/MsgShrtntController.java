package knou.lms.msg.web;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.facade.MsgShrtntFacadeService;
import knou.lms.msg.vo.MsgShrtntVO;
import knou.lms.msg.web.util.MsgAuthUtil;
import knou.lms.user.CurrentUser;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Controller
public class MsgShrtntController extends ControllerBase {

    @Resource(name = "msgShrtntFacadeService")
    private MsgShrtntFacadeService msgShrtntFacadeService;

    private static final String LIST_TYPE_RCVN = "RCVN";

    /*****************************************************
     * 쪽지 발신 화면 공통 모델 구성
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @throws Exception
     ******************************************************/
    private void prepareSndngCommonModel(MsgShrtntVO vo, UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("orgId", userCtx.getOrgId());
        model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_MSG));

        boolean hasSndngAuth = MsgAuthUtil.isAdmin(userCtx);
        EgovMap registInfo = msgShrtntFacadeService.loadSndngRegistViewInfo(vo.getMsgId(), userCtx.getUserId(), hasSndngAuth);
        if (!(boolean) registInfo.get("hasAuth")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        vo.setUserNm(StringUtil.nvl((String) registInfo.get("userNm")));
        if (registInfo.get("fileList") != null) {
            model.addAttribute("fileList", registInfo.get("fileList"));
        }

        model.addAttribute("filterOptions", msgShrtntFacadeService.loadSndngRegistFilterOptions(userCtx));
        model.addAttribute("vo", vo);
    }

    /*****************************************************
     * 쪽지 발신 수정 모드 모델 구성
     * @param vo
     * @param userCtx
     * @param model
     ******************************************************/
    private void prepareEditModeModel(MsgShrtntVO vo, UserContext userCtx, ModelMap model) {
        String msgId = vo.getMsgId();
        EgovMap editInfo = msgShrtntFacadeService.loadEditLinkInfo(msgId, userCtx);
        MsgShrtntVO original = (MsgShrtntVO) editInfo.get("original");
        if (original == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        boolean isEditActive = "Y".equals(original.getRsrvYn())
                && "Y".equals(original.getFullyPendingYn())
                && StringUtil.isNull(original.getRsrvSndngCnclDttm());
        if (!isEditActive) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        MsgShrtntVO trgVo = new MsgShrtntVO();
        trgVo.setMsgId(msgId);
        trgVo.setSndngrId(userCtx.getUserId());
        List<MsgShrtntVO> editRcvrList = msgShrtntFacadeService.selectMsgRcvTrgtrList(trgVo);

        String origSndngnm = StringUtil.nvl(original.getSndngnm());
        String userNm = StringUtil.nvl(vo.getUserNm());
        boolean isCustomSndngnm = !origSndngnm.isEmpty() && !origSndngnm.equals(userNm);

        msgShrtntFacadeService.applyOriginalToFilterOptions((EgovMap) model.get("filterOptions"), original);

        model.addAttribute("editInfo", editInfo);
        model.addAttribute("editRcvrList", editRcvrList);
        model.addAttribute("msgId", msgId);
        model.addAttribute("isCustomSndngnm", isCustomSndngnm);
        model.addAttribute("origSndngnm", origSndngnm);
    }

    /*****************************************************
     * 쪽지 발신 답장 모드 모델 구성
     * @param vo
     * @param userCtx
     * @param model
     * @throws Exception
     ******************************************************/
    private void prepareReplyModeModel(MsgShrtntVO vo, UserContext userCtx, ModelMap model) throws Exception {
        String replyId = vo.getReplyMsgShrtntSndngId();
        EgovMap replyInfo = msgShrtntFacadeService.loadReplyLinkInfo(replyId, userCtx);
        MsgShrtntVO original = (MsgShrtntVO) replyInfo.get("original");
        if (original == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        msgShrtntFacadeService.applyOriginalToFilterOptions((EgovMap) model.get("filterOptions"), original);

        model.addAttribute("replyInfo", replyInfo);
        model.addAttribute("replyMsgShrtntSndngId", replyId);
    }

    /*****************************************************
     * 교수 쪽지 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_shrtnt_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgShrtntListView.do")
    public String profMsgShrtntListView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgShrtntFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("msgId");
        delEncParam("msgShrtntSndngId");
        delEncParam("replyMsgShrtntSndngId");

        if (StringUtil.isNull(vo.getListType())) {
            delEncParam("orgId");
            vo.setOrgId(null);
        }

        vo.setUserId(userCtx.getUserId());

        EgovMap filterOptions = msgShrtntFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgShrtntFacadeService.selectProfSbjctOrgList(userCtx.getUserId()));

        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("vo", vo);

        return "msg/prof_msg_shrtnt_list_view";
    }

    /*****************************************************
     * 교수 쪽지 수신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_shrtnt_rcvn_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgShrtntRcvnSelectView.do")
    public String profMsgShrtntRcvnSelectView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgShrtntSndngId", vo.getMsgShrtntSndngId());
        model.addAttribute("msgShrtntSndngId", vo.getMsgShrtntSndngId());

        vo.setRcvrId(userCtx.getUserId());
        MsgShrtntVO detail = msgShrtntFacadeService.selectShrtntRcvnDtlWithFiles(vo);
        if (detail != null) {
            msgShrtntFacadeService.modifyShrtntReadDttm(vo);
        }
        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);

        return "msg/prof_msg_shrtnt_rcvn_select_view";
    }

    /*****************************************************
     * 교수 쪽지 발신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_shrtnt_sndng_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgShrtntSndngSelectView.do")
    public String profMsgShrtntSndngSelectView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgId", vo.getMsgId());
        model.addAttribute("msgId", vo.getMsgId());

        vo.setSndngrId(userCtx.getUserId());
        MsgShrtntVO detail = msgShrtntFacadeService.selectShrtntSndngDtlWithFiles(vo);

        boolean isActiveRsrv = detail != null
                && "Y".equals(detail.getRsrvYn())
                && StringUtil.isNull(detail.getRsrvSndngCnclDttm());
        boolean isFullyPending = detail != null
                && "Y".equals(detail.getFullyPendingYn());
        boolean isOwner = detail != null
                && userCtx.getUserId().equals(StringUtil.nvl(detail.getSndngrId()));
        boolean canModify = isActiveRsrv && isFullyPending && isOwner;
        boolean canRsrvCncl = isActiveRsrv && isOwner;

        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);
        model.addAttribute("canModify", canModify);
        model.addAttribute("canRsrvCncl", canRsrvCncl);

        return "msg/prof_msg_shrtnt_sndng_select_view";
    }

    /*****************************************************
     * 교수 쪽지 발신 등록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "msg/prof_msg_shrtnt_sndng_regist_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgShrtntSndngRegistView.do")
    public String profMsgShrtntSndngRegistView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        delEncParam("msgId");
        delEncParam("replyMsgShrtntSndngId");
        vo.setMsgId(null);
        vo.setReplyMsgShrtntSndngId(null);
        prepareSndngCommonModel(vo, userCtx, model, request);
        return "msg/prof_msg_shrtnt_sndng_regist_view";
    }

    /*****************************************************
     * 교수 쪽지 수정 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "msg/prof_msg_shrtnt_sndng_modify_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgShrtntSndngModifyView.do")
    public String profMsgShrtntSndngModifyView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (StringUtil.isNull(vo.getMsgId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        addEncParam("msgId", vo.getMsgId());
        delEncParam("replyMsgShrtntSndngId");
        vo.setReplyMsgShrtntSndngId(null);
        prepareSndngCommonModel(vo, userCtx, model, request);
        prepareEditModeModel(vo, userCtx, model);
        return "msg/prof_msg_shrtnt_sndng_modify_view";
    }

    /*****************************************************
     * 교수 쪽지 답장 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "msg/prof_msg_shrtnt_sndng_reply_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgShrtntSndngReplyView.do")
    public String profMsgShrtntSndngReplyView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (StringUtil.isNull(vo.getReplyMsgShrtntSndngId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        delEncParam("msgId");
        addEncParam("replyMsgShrtntSndngId", vo.getReplyMsgShrtntSndngId());
        vo.setMsgId(null);
        prepareSndngCommonModel(vo, userCtx, model, request);
        prepareReplyModeModel(vo, userCtx, model);
        return "msg/prof_msg_shrtnt_sndng_reply_view";
    }

    /*****************************************************
     * 관리자 쪽지 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_shrtnt_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgShrtntListView.do")
    public String admMsgShrtntListView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgShrtntFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("msgId");
        delEncParam("msgShrtntSndngId");
        delEncParam("replyMsgShrtntSndngId");

        if (StringUtil.isNull(vo.getListType())) {
            delEncParam("orgId");
            vo.setOrgId(null);
        }

        EgovMap filterOptions = msgShrtntFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgShrtntFacadeService.selectActiveOrgListByAuth(userCtx.getUserId(), true));
        model.addAttribute("filterOptions", filterOptions);

        model.addAttribute("vo", vo);

        return "msg/adm_msg_shrtnt_list_view";
    }

    /*****************************************************
     * 관리자 쪽지 수신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_shrtnt_rcvn_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgShrtntRcvnSelectView.do")
    public String admMsgShrtntRcvnSelectView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgShrtntSndngId", vo.getMsgShrtntSndngId());
        model.addAttribute("msgShrtntSndngId", vo.getMsgShrtntSndngId());

        vo.setRcvrId(userCtx.getUserId());
        MsgShrtntVO detail = msgShrtntFacadeService.selectShrtntRcvnDtlWithFiles(vo);
        if (detail != null) {
            msgShrtntFacadeService.modifyShrtntReadDttm(vo);
        }
        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);

        return "msg/adm_msg_shrtnt_rcvn_select_view";
    }

    /*****************************************************
     * 관리자 쪽지 발신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_shrtnt_sndng_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgShrtntSndngSelectView.do")
    public String admMsgShrtntSndngSelectView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgId", vo.getMsgId());
        model.addAttribute("msgId", vo.getMsgId());

        vo.setSndngrId(userCtx.getUserId());
        MsgShrtntVO detail = msgShrtntFacadeService.selectShrtntSndngDtlWithFiles(vo);

        boolean isActiveRsrv = detail != null
                && "Y".equals(detail.getRsrvYn())
                && StringUtil.isNull(detail.getRsrvSndngCnclDttm());
        boolean isFullyPending = detail != null
                && "Y".equals(detail.getFullyPendingYn());
        boolean isOwner = detail != null
                && userCtx.getUserId().equals(StringUtil.nvl(detail.getSndngrId()));
        boolean canModify = isActiveRsrv && isFullyPending && isOwner;
        boolean canRsrvCncl = isActiveRsrv && isOwner;

        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);
        model.addAttribute("canModify", canModify);
        model.addAttribute("canRsrvCncl", canRsrvCncl);

        return "msg/adm_msg_shrtnt_sndng_select_view";
    }

    /*****************************************************
     * 관리자 쪽지 발신 등록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "msg/adm_msg_shrtnt_sndng_regist_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgShrtntSndngRegistView.do")
    public String admMsgShrtntSndngRegistView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        delEncParam("msgId");
        delEncParam("replyMsgShrtntSndngId");
        vo.setMsgId(null);
        vo.setReplyMsgShrtntSndngId(null);
        prepareSndngCommonModel(vo, userCtx, model, request);
        return "msg/adm_msg_shrtnt_sndng_regist_view";
    }

    /*****************************************************
     * 관리자 쪽지 수정 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "msg/adm_msg_shrtnt_sndng_modify_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgShrtntSndngModifyView.do")
    public String admMsgShrtntSndngModifyView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (StringUtil.isNull(vo.getMsgId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        addEncParam("msgId", vo.getMsgId());
        delEncParam("replyMsgShrtntSndngId");
        vo.setReplyMsgShrtntSndngId(null);
        prepareSndngCommonModel(vo, userCtx, model, request);
        prepareEditModeModel(vo, userCtx, model);
        return "msg/adm_msg_shrtnt_sndng_modify_view";
    }

    /*****************************************************
     * 관리자 쪽지 답장 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "msg/adm_msg_shrtnt_sndng_reply_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgShrtntSndngReplyView.do")
    public String admMsgShrtntSndngReplyView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (StringUtil.isNull(vo.getReplyMsgShrtntSndngId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        delEncParam("msgId");
        addEncParam("replyMsgShrtntSndngId", vo.getReplyMsgShrtntSndngId());
        vo.setMsgId(null);
        prepareSndngCommonModel(vo, userCtx, model, request);
        prepareReplyModeModel(vo, userCtx, model);
        return "msg/adm_msg_shrtnt_sndng_reply_view";
    }

    /*****************************************************
     * 학생 쪽지 목록 화면 (수신 전용)
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/stdnt_msg_shrtnt_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/stdntMsgShrtntListView.do")
    public String stdntMsgShrtntListView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo.setListType(LIST_TYPE_RCVN);
        vo = msgShrtntFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("msgId");
        delEncParam("msgShrtntSndngId");
        delEncParam("replyMsgShrtntSndngId");

        vo.setUserId(userCtx.getUserId());

        EgovMap filterOptions = msgShrtntFacadeService.loadStdntFilterOptions(vo);
        filterOptions.put("orgList", msgShrtntFacadeService.selectActiveOrgListByAuth(userCtx.getUserId(), false));

        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("vo", vo);

        return "msg/stdnt_msg_shrtnt_list_view";
    }

    /*****************************************************
     * 학생 쪽지 수신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/stdnt_msg_shrtnt_rcvn_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/stdntMsgShrtntRcvnSelectView.do")
    public String stdntMsgShrtntRcvnSelectView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgShrtntSndngId", vo.getMsgShrtntSndngId());
        model.addAttribute("msgShrtntSndngId", vo.getMsgShrtntSndngId());

        vo.setRcvrId(userCtx.getUserId());
        MsgShrtntVO detail = msgShrtntFacadeService.selectShrtntRcvnDtlWithFiles(vo);
        if (detail != null) {
            msgShrtntFacadeService.modifyShrtntReadDttm(vo);
        }
        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);

        return "msg/stdnt_msg_shrtnt_rcvn_select_view";
    }

    /*****************************************************
     * 쪽지 수신 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgShrtntRcvnListAjax.do", "/admMsgShrtntRcvnListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntRcvnListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        vo.setRcvrId(userCtx.getUserId());

        resultVO = msgShrtntFacadeService.selectShrtntRcvnListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 쪽지 발신 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgShrtntSndngListAjax.do", "/admMsgShrtntSndngListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntSndngListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        vo.setSndngrId(userCtx.getUserId());

        resultVO = msgShrtntFacadeService.selectShrtntSndngListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 쪽지 수신 상세 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @RequestMapping({"/msgShrtntRcvnSelectAjax.do", "/admMsgShrtntRcvnSelectAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntRcvnSelectAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        vo.setRcvrId(userCtx.getUserId());

        MsgShrtntVO detail = msgShrtntFacadeService.selectShrtntRcvnDtlWithFiles(vo);
        resultVO.setReturnVO(detail);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 쪽지 발신 상세 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @RequestMapping({"/msgShrtntSndngSelectAjax.do", "/admMsgShrtntSndngSelectAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntSndngSelectAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        vo.setSndngrId(userCtx.getUserId());

        MsgShrtntVO detail = msgShrtntFacadeService.selectShrtntSndngDtlWithFiles(vo);
        resultVO.setReturnVO(detail);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 쪽지 발신 수신자 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgShrtntSndngRcvrListAjax.do", "/admMsgShrtntSndngRcvrListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntSndngRcvrListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        vo.setSndngrId(userCtx.getUserId());

        resultVO = msgShrtntFacadeService.selectShrtntSndngRcvrListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 쪽지 읽음 처리 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @RequestMapping({"/msgShrtntReadModifyAjax.do", "/admMsgShrtntReadModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntReadModifyAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        vo.setRcvrId(userCtx.getUserId());
        msgShrtntFacadeService.modifyShrtntReadDttm(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 쪽지 삭제 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @RequestMapping({"/msgShrtntDeleteAjax.do", "/admMsgShrtntDeleteAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntDeleteAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        String userId = userCtx.getUserId();

        if (LIST_TYPE_RCVN.equals(vo.getListType())) {
            vo.setRcvrId(userId);
            msgShrtntFacadeService.modifyShrtntRcvrDelyn(vo);
        } else {
            vo.setSndngrId(userId);
            msgShrtntFacadeService.modifyShrtntSndngrDelyn(vo);
        }
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 쪽지 수신거부 건수 AJAX 조회
     * @param vo
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgShrtntRcptnRjctCntSelectAjax.do", "/admMsgShrtntRcptnRjctCntSelectAjax.do"})
    @ResponseBody
    public ProcessResultVO<EgovMap> msgShrtntRcptnRjctCntSelectAjax(MsgShrtntVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        EgovMap rcptnRjctCnt = msgShrtntFacadeService.selectRcptnRjctCnt(vo.getRcvrListJson());
        resultVO.setReturnVO(rcptnRjctCnt);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 쪽지 발신 수신자 엑셀 다운로드
     * @param vo
     * @param userCtx
     * @param model
     * @return "excelView"
     ******************************************************/
    @RequestMapping({"/msgShrtntRcvrExcelList.do", "/admMsgShrtntRcvrExcelList.do"})
    public String msgShrtntRcvrExcelList(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model) {

        vo.setSndngrId(userCtx.getUserId());

        List<MsgShrtntVO> list = msgShrtntFacadeService.selectShrtntSndngRcvrExcelList(vo);

        String title = getMessage("msg.shrtnt.label.rcvrList");
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 쪽지 발신 등록 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgShrtntSndngRegistAjax.do", "/admMsgShrtntSndngRegistAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntSndngRegistAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        try {
            if (StringUtil.isNotNull(vo.getUpMsgShrtntSndngId())) {
                MsgShrtntVO verifyVo = new MsgShrtntVO();
                verifyVo.setMsgShrtntSndngId(vo.getUpMsgShrtntSndngId());
                verifyVo.setRcvrId(userCtx.getUserId());
                if (msgShrtntFacadeService.selectShrtntRcvnDtlWithFiles(verifyVo) == null) {
                    vo.setUpMsgShrtntSndngId(null);
                }
            }

            vo.setRgtrId(userCtx.getUserId());
            vo.setSndngrId(userCtx.getUserId());
            vo.setOrgId(userCtx.getOrgId());

            msgShrtntFacadeService.registShrtntSndngWithFiles(vo, uploadFiles, uploadPath);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            if (StringUtil.isNotNull(uploadFiles) && StringUtil.isNotNull(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
            throw e;
        }

        return resultVO;
    }

    /*****************************************************
     * 쪽지 발신 수정 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgShrtntSndngModifyAjax.do", "/admMsgShrtntSndngModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntSndngModifyAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        try {
            if (StringUtil.isNotNull(vo.getUpMsgShrtntSndngId())) {
                MsgShrtntVO verifyVo = new MsgShrtntVO();
                verifyVo.setMsgShrtntSndngId(vo.getUpMsgShrtntSndngId());
                verifyVo.setRcvrId(userCtx.getUserId());
                if (msgShrtntFacadeService.selectShrtntRcvnDtlWithFiles(verifyVo) == null) {
                    vo.setUpMsgShrtntSndngId(null);
                }
            }

            vo.setMdfrId(userCtx.getUserId());
            vo.setSndngrId(userCtx.getUserId());

            msgShrtntFacadeService.modifyShrtntSndngWithFiles(vo, uploadFiles, uploadPath, vo.getDelFileIds());
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            if (StringUtil.isNotNull(uploadFiles) && StringUtil.isNotNull(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
            throw e;
        }

        return resultVO;
    }

    /*****************************************************
     * 쪽지 예약 취소 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @RequestMapping({"/msgShrtntRsrvCnclModifyAjax.do", "/admMsgShrtntRsrvCnclModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntRsrvCnclModifyAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        String userId = userCtx.getUserId();
        vo.setMdfrId(userId);
        vo.setSndngrId(userId);
        int cnclCnt = msgShrtntFacadeService.modifyMsgRsrvCncl(vo);
        if (cnclCnt == 0) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.update"));
            return resultVO;
        }
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 수신 대상자 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgShrtntVO>
     ******************************************************/
    @RequestMapping({"/msgShrtntRcvTrgtrListAjax.do", "/admMsgShrtntRcvTrgtrListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntRcvTrgtrListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        vo.setSndngrId(userCtx.getUserId());

        List<MsgShrtntVO> list = msgShrtntFacadeService.selectMsgRcvTrgtrList(vo);
        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 수신자 엑셀 업로드 양식 다운로드
     * @param vo
     * @param model
     * @return "excelView"
     ******************************************************/
    @RequestMapping({"/msgShrtntRcvrTmpltDown.do", "/admMsgShrtntRcvrTmpltDown.do"})
    public String msgShrtntRcvrTmpltDown(MsgShrtntVO vo, ModelMap model) {
        XSSFWorkbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet(getMessage("msg.shrtnt.label.rcvrList"));

        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue(getMessage("msg.shrtnt.label.userId"));
        sheet.setColumnWidth(0, 6000);

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", getMessage("msg.shrtnt.label.rcvrUploadTmplt"));
        modelMap.put("sheetName", getMessage("msg.shrtnt.label.rcvrList"));
        modelMap.put("workbook", workbook);
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 수신자 엑셀 업로드 AJAX
     * @param vo
     * @param userCtx
     * @param excelFile
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgShrtntRcvrExcelUploadAjax.do", "/admMsgShrtntRcvrExcelUploadAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntRcvrExcelUploadAjax(
            MsgShrtntVO vo,
            @CurrentUser UserContext userCtx,
            @RequestParam("excelFile") MultipartFile excelFile) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        String orgId = userCtx.getOrgId();
        List<MsgShrtntVO> list = msgShrtntFacadeService.parseExcelAndSearchRcvr(excelFile.getInputStream(), orgId);
        if (list.isEmpty()) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("common.content.not_found"));
            return resultVO;
        }

        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }
}
