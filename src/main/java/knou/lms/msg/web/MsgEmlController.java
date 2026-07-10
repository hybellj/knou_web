package knou.lms.msg.web;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.FileUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.facade.MsgEmlFacadeService;
import knou.lms.msg.vo.MsgEmlVO;
import knou.lms.msg.web.util.MsgAuthUtil;
import knou.lms.user.CurrentUser;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class MsgEmlController extends ControllerBase {

    @Resource(name = "msgEmlFacadeService")
    private MsgEmlFacadeService msgEmlFacadeService;

    private static final String LIST_TYPE_RCVN = "RCVN";

    /*****************************************************
     * 이메일 발신 화면 공통 모델 구성
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @throws Exception
     ******************************************************/
    private void prepareSndngCommonModel(MsgEmlVO vo, UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("orgId", userCtx.getOrgId());
        model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_MSG));

        boolean hasSndngAuth = MsgAuthUtil.isAdmin(userCtx);
        EgovMap registInfo = msgEmlFacadeService.loadSndngRegistViewInfo(vo.getMsgId(), userCtx.getUserId(), hasSndngAuth);
        if (!(boolean) registInfo.get("hasAuth")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        vo.setUserNm(StringUtil.nvl((String) registInfo.get("userNm")));
        vo.setSndngrEml(StringUtil.nvl((String) registInfo.get("userEml")));
        if (registInfo.get("fileList") != null) {
            model.addAttribute("fileList", registInfo.get("fileList"));
        }

        model.addAttribute("filterOptions", msgEmlFacadeService.loadSndngRegistFilterOptions(userCtx));
        model.addAttribute("vo", vo);
    }

    /*****************************************************
     * 이메일 발신 수정 모드 모델 구성
     * @param vo
     * @param userCtx
     * @param model
     ******************************************************/
    private void prepareEditModeModel(MsgEmlVO vo, UserContext userCtx, ModelMap model) {
        String msgId = vo.getMsgId();
        EgovMap editInfo = msgEmlFacadeService.loadEditLinkInfo(msgId, userCtx);
        MsgEmlVO original = (MsgEmlVO) editInfo.get("original");
        if (original == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        boolean isEditActive = "Y".equals(original.getRsrvYn())
                && "Y".equals(original.getFullyPendingYn())
                && StringUtil.isNull(original.getRsrvSndngCnclDttm());
        if (!isEditActive) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        MsgEmlVO trgVo = new MsgEmlVO();
        trgVo.setMsgId(msgId);
        trgVo.setSndngrId(userCtx.getUserId());
        List<MsgEmlVO> editRcvrList = msgEmlFacadeService.selectMsgRcvTrgtrList(trgVo);

        String origSndngnm = StringUtil.nvl(original.getSndngnm());
        String userNm = StringUtil.nvl(vo.getUserNm());
        boolean isCustomSndngnm = !origSndngnm.isEmpty() && !origSndngnm.equals(userNm);

        msgEmlFacadeService.applyOriginalToFilterOptions((EgovMap) model.get("filterOptions"), original);

        model.addAttribute("editInfo", editInfo);
        model.addAttribute("editRcvrList", editRcvrList);
        model.addAttribute("msgId", msgId);
        model.addAttribute("isCustomSndngnm", isCustomSndngnm);
        model.addAttribute("origSndngnm", origSndngnm);
    }

    /*****************************************************
     * 이메일 발신 답장 모드 모델 구성
     * @param vo
     * @param userCtx
     * @param model
     * @throws Exception
     ******************************************************/
    private void prepareReplyModeModel(MsgEmlVO vo, UserContext userCtx, ModelMap model) throws Exception {
        String replyId = vo.getReplyMsgEmlSndngId();
        EgovMap replyInfo = msgEmlFacadeService.loadReplyLinkInfo(replyId, userCtx);
        MsgEmlVO original = (MsgEmlVO) replyInfo.get("original");
        if (original == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        msgEmlFacadeService.applyOriginalToFilterOptions((EgovMap) model.get("filterOptions"), original);

        model.addAttribute("replyInfo", replyInfo);
        model.addAttribute("replyMsgEmlSndngId", replyId);
    }

    /*****************************************************
     * 교수 이메일 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_eml_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgEmlListView.do")
    public String profMsgEmlListView(MsgEmlVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgEmlFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("msgId");
        delEncParam("msgEmlSndngId");
        delEncParam("replyMsgEmlSndngId");

        if (StringUtil.isNull(vo.getListType())) {
            delEncParam("orgId");
            vo.setOrgId(null);
        }

        vo.setUserId(userCtx.getUserId());

        EgovMap filterOptions = msgEmlFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgEmlFacadeService.selectProfSbjctOrgList(userCtx.getUserId()));

        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("vo", vo);

        return "msg/prof_msg_eml_list_view";
    }

    /*****************************************************
     * 교수 이메일 수신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_eml_rcvn_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgEmlRcvnSelectView.do")
    public String profMsgEmlRcvnSelectView(MsgEmlVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgEmlSndngId", vo.getMsgEmlSndngId());
        model.addAttribute("msgEmlSndngId", vo.getMsgEmlSndngId());

        vo.setRcvrId(userCtx.getUserId());
        MsgEmlVO detail = msgEmlFacadeService.selectEmlRcvnDtlWithFiles(vo);
        if (detail != null) {
            msgEmlFacadeService.modifyEmlReadDttm(vo);
        }
        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);

        return "msg/prof_msg_eml_rcvn_select_view";
    }

    /*****************************************************
     * 교수 이메일 발신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_eml_sndng_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgEmlSndngSelectView.do")
    public String profMsgEmlSndngSelectView(MsgEmlVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgId", vo.getMsgId());
        model.addAttribute("msgId", vo.getMsgId());

        vo.setSndngrId(userCtx.getUserId());
        MsgEmlVO detail = msgEmlFacadeService.selectEmlSndngDtlWithFiles(vo);

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

        return "msg/prof_msg_eml_sndng_select_view";
    }

    /*****************************************************
     * 교수 이메일 발신 등록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "msg/prof_msg_eml_sndng_regist_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgEmlSndngRegistView.do")
    public String profMsgEmlSndngRegistView(MsgEmlVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        delEncParam("msgId");
        delEncParam("replyMsgEmlSndngId");
        vo.setMsgId(null);
        vo.setReplyMsgEmlSndngId(null);
        prepareSndngCommonModel(vo, userCtx, model, request);
        return "msg/prof_msg_eml_sndng_regist_view";
    }

    /*****************************************************
     * 교수 이메일 수정 화면 (예약 대기건)
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "msg/prof_msg_eml_sndng_modify_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgEmlSndngModifyView.do")
    public String profMsgEmlSndngModifyView(MsgEmlVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (StringUtil.isNull(vo.getMsgId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        addEncParam("msgId", vo.getMsgId());
        delEncParam("replyMsgEmlSndngId");
        vo.setReplyMsgEmlSndngId(null);
        prepareSndngCommonModel(vo, userCtx, model, request);
        prepareEditModeModel(vo, userCtx, model);
        return "msg/prof_msg_eml_sndng_modify_view";
    }

    /*****************************************************
     * 교수 이메일 답장 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "msg/prof_msg_eml_sndng_reply_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgEmlSndngReplyView.do")
    public String profMsgEmlSndngReplyView(MsgEmlVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (StringUtil.isNull(vo.getReplyMsgEmlSndngId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        delEncParam("msgId");
        addEncParam("replyMsgEmlSndngId", vo.getReplyMsgEmlSndngId());
        vo.setMsgId(null);
        prepareSndngCommonModel(vo, userCtx, model, request);
        prepareReplyModeModel(vo, userCtx, model);
        return "msg/prof_msg_eml_sndng_reply_view";
    }

    /*****************************************************
     * 관리자 이메일 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_eml_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgEmlListView.do")
    public String admMsgEmlListView(MsgEmlVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgEmlFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("msgId");
        delEncParam("msgEmlSndngId");
        delEncParam("replyMsgEmlSndngId");

        if (StringUtil.isNull(vo.getListType())) {
            delEncParam("orgId");
            vo.setOrgId(null);
        }

        EgovMap filterOptions = msgEmlFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgEmlFacadeService.selectActiveOrgListByAuth(userCtx.getUserId(), true));

        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("vo", vo);

        return "msg/adm_msg_eml_list_view";
    }

    /*****************************************************
     * 관리자 이메일 수신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_eml_rcvn_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgEmlRcvnSelectView.do")
    public String admMsgEmlRcvnSelectView(MsgEmlVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgEmlSndngId", vo.getMsgEmlSndngId());
        model.addAttribute("msgEmlSndngId", vo.getMsgEmlSndngId());

        vo.setRcvrId(userCtx.getUserId());
        MsgEmlVO detail = msgEmlFacadeService.selectEmlRcvnDtlWithFiles(vo);
        if (detail != null) {
            msgEmlFacadeService.modifyEmlReadDttm(vo);
        }
        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);

        return "msg/adm_msg_eml_rcvn_select_view";
    }

    /*****************************************************
     * 관리자 이메일 발신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_eml_sndng_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgEmlSndngSelectView.do")
    public String admMsgEmlSndngSelectView(MsgEmlVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgId", vo.getMsgId());
        model.addAttribute("msgId", vo.getMsgId());

        vo.setSndngrId(userCtx.getUserId());
        MsgEmlVO detail = msgEmlFacadeService.selectEmlSndngDtlWithFiles(vo);

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

        return "msg/adm_msg_eml_sndng_select_view";
    }

    /*****************************************************
     * 관리자 이메일 발신 등록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "msg/adm_msg_eml_sndng_regist_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgEmlSndngRegistView.do")
    public String admMsgEmlSndngRegistView(MsgEmlVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        delEncParam("msgId");
        delEncParam("replyMsgEmlSndngId");
        vo.setMsgId(null);
        vo.setReplyMsgEmlSndngId(null);
        prepareSndngCommonModel(vo, userCtx, model, request);
        return "msg/adm_msg_eml_sndng_regist_view";
    }

    /*****************************************************
     * 관리자 이메일 수정 화면 (예약 대기건)
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "msg/adm_msg_eml_sndng_modify_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgEmlSndngModifyView.do")
    public String admMsgEmlSndngModifyView(MsgEmlVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (StringUtil.isNull(vo.getMsgId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        addEncParam("msgId", vo.getMsgId());
        delEncParam("replyMsgEmlSndngId");
        vo.setReplyMsgEmlSndngId(null);
        prepareSndngCommonModel(vo, userCtx, model, request);
        prepareEditModeModel(vo, userCtx, model);
        return "msg/adm_msg_eml_sndng_modify_view";
    }

    /*****************************************************
     * 관리자 이메일 답장 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return "msg/adm_msg_eml_sndng_reply_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgEmlSndngReplyView.do")
    public String admMsgEmlSndngReplyView(MsgEmlVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (StringUtil.isNull(vo.getReplyMsgEmlSndngId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        delEncParam("msgId");
        addEncParam("replyMsgEmlSndngId", vo.getReplyMsgEmlSndngId());
        vo.setMsgId(null);
        prepareSndngCommonModel(vo, userCtx, model, request);
        prepareReplyModeModel(vo, userCtx, model);
        return "msg/adm_msg_eml_sndng_reply_view";
    }

    /*****************************************************
     * 이메일 수신 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgEmlVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgEmlRcvnListAjax.do", "/admMsgEmlRcvnListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgEmlVO> msgEmlRcvnListAjax(MsgEmlVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgEmlVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        vo.setRcvrId(userCtx.getUserId());

        resultVO = msgEmlFacadeService.selectEmlRcvnListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 이메일 발신 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgEmlVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgEmlSndngListAjax.do", "/admMsgEmlSndngListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgEmlVO> msgEmlSndngListAjax(MsgEmlVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgEmlVO> resultVO = new ProcessResultVO<>();

        vo.setSndngrId(userCtx.getUserId());

        resultVO = msgEmlFacadeService.selectEmlSndngListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 이메일 발신 수신자 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgEmlVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgEmlSndngRcvrListAjax.do", "/admMsgEmlSndngRcvrListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgEmlVO> msgEmlSndngRcvrListAjax(MsgEmlVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgEmlVO> resultVO = new ProcessResultVO<>();

        vo.setSndngrId(userCtx.getUserId());

        resultVO = msgEmlFacadeService.selectEmlSndngRcvrListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 이메일 발신 등록 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgEmlVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgEmlSndngRegistAjax.do", "/admMsgEmlSndngRegistAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgEmlVO> msgEmlSndngRegistAjax(MsgEmlVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgEmlVO> resultVO = new ProcessResultVO<>();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        try {
            if (StringUtil.isNotNull(vo.getBfrMsgEmlSndngId())) {
                MsgEmlVO verifyVo = new MsgEmlVO();
                verifyVo.setMsgEmlSndngId(vo.getBfrMsgEmlSndngId());
                verifyVo.setRcvrId(userCtx.getUserId());
                if (msgEmlFacadeService.selectEmlRcvnDtlWithFiles(verifyVo) == null) {
                    vo.setBfrMsgEmlSndngId(null);
                }
            }

            vo.setRgtrId(userCtx.getUserId());
            vo.setSndngrId(userCtx.getUserId());
            vo.setOrgId(userCtx.getOrgId());

            msgEmlFacadeService.registEmlSndngWithFiles(vo, uploadFiles, uploadPath);
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
     * 이메일 발신 수정 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgEmlVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgEmlSndngModifyAjax.do", "/admMsgEmlSndngModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgEmlVO> msgEmlSndngModifyAjax(MsgEmlVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgEmlVO> resultVO = new ProcessResultVO<>();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        try {
            vo.setMdfrId(userCtx.getUserId());
            vo.setSndngrId(userCtx.getUserId());

            msgEmlFacadeService.modifyEmlSndngWithFiles(vo, uploadFiles, uploadPath, vo.getDelFileIds());
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
     * 이메일 예약 취소 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgEmlVO>
     ******************************************************/
    @RequestMapping({"/msgEmlRsrvCnclModifyAjax.do", "/admMsgEmlRsrvCnclModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgEmlVO> msgEmlRsrvCnclModifyAjax(MsgEmlVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgEmlVO> resultVO = new ProcessResultVO<>();

        String userId = userCtx.getUserId();
        vo.setMdfrId(userId);
        vo.setSndngrId(userId);
        int cnclCnt = msgEmlFacadeService.modifyMsgRsrvCncl(vo);
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
     * 이메일 읽음 처리 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgEmlVO>
     ******************************************************/
    @RequestMapping({"/msgEmlReadModifyAjax.do", "/admMsgEmlReadModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgEmlVO> msgEmlReadModifyAjax(MsgEmlVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgEmlVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        vo.setRcvrId(userCtx.getUserId());
        msgEmlFacadeService.modifyEmlReadDttm(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 이메일 삭제 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgEmlVO>
     ******************************************************/
    @RequestMapping({"/msgEmlDeleteAjax.do", "/admMsgEmlDeleteAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgEmlVO> msgEmlDeleteAjax(MsgEmlVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgEmlVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        String userId = userCtx.getUserId();

        if (LIST_TYPE_RCVN.equals(vo.getListType())) {
            vo.setRcvrId(userId);
            msgEmlFacadeService.modifyEmlRcvrDelyn(vo);
        } else {
            vo.setSndngrId(userId);
            msgEmlFacadeService.modifyEmlSndngrDelyn(vo);
        }
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 이메일 발신 수신 대상자 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgEmlVO>
     ******************************************************/
    @RequestMapping({"/msgEmlRcvTrgtrListAjax.do", "/admMsgEmlRcvTrgtrListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgEmlVO> msgEmlRcvTrgtrListAjax(MsgEmlVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgEmlVO> resultVO = new ProcessResultVO<>();

        vo.setSndngrId(userCtx.getUserId());
        List<MsgEmlVO> list = msgEmlFacadeService.selectMsgRcvTrgtrList(vo);
        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

}
