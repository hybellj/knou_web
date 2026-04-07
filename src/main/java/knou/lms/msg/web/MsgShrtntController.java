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
import knou.lms.org.vo.OrgInfoVO;
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

    private static final int PAGE_SIZE = 10;
    private static final String LIST_TYPE_RCVN = "RCVN";

    private String handleSndngRegistView(MsgShrtntVO vo, UserContext userCtx, ModelMap model, HttpServletRequest request, boolean requireAdmin, String jspPath) throws Exception {
        if (requireAdmin && !MsgAuthUtil.isAdmin(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        if (!requireAdmin && !MsgAuthUtil.isProfessor(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        String msgId = vo.getMsgId();

        if (StringUtil.isNotNull(msgId)) {
            addEncParam("msgId", msgId);
        } else {
            delEncParam("msgId");
        }
        if (StringUtil.isNotNull(vo.getReplyMsgShrtntSndngId())) {
            addEncParam("replyMsgShrtntSndngId", vo.getReplyMsgShrtntSndngId());
        } else {
            delEncParam("replyMsgShrtntSndngId");
        }

        model.addAttribute("msgId", msgId);
        model.addAttribute("replyMsgShrtntSndngId", vo.getReplyMsgShrtntSndngId());
        model.addAttribute("orgId", userCtx.getOrgId());
        model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_MSG));

        boolean hasSndngAuth = "Y".equals(MsgAuthUtil.getShrtntSndngAuth(userCtx, userCtx.getUserId()));
        EgovMap registInfo = msgShrtntFacadeService.loadSndngRegistViewInfo(msgId, userCtx.getUserId(), hasSndngAuth);
        if (!(boolean) registInfo.get("hasAuth")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        vo.setUserNm(StringUtil.nvl((String) registInfo.get("userNm")));
        if (registInfo.get("fileList") != null) {
            model.addAttribute("fileList", registInfo.get("fileList"));
        }

        model.addAttribute("vo", vo);

        return jspPath;
    }

    // ========== View 메서드 ==========

    /*****************************************************
     * 교수 쪽지 목록 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/prof_msg_shrtnt_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgShrtntListView.do")
    public String profMsgShrtntListView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (!MsgAuthUtil.isProfessor(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        vo = msgShrtntFacadeService.loadListViewInfo(vo, MsgAuthUtil.isAdmin(userCtx));

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        vo.setListScale(PAGE_SIZE);
        setEncParamsToVO(vo);

        boolean isAdmin = MsgAuthUtil.isAdmin(userCtx);

        EgovMap filterOptions = msgShrtntFacadeService.loadFilterOptions(vo, isAdmin);
        if (!isAdmin) {
            filterOptions.put("orgList", msgShrtntFacadeService.selectActiveOrgListByAuth(userCtx.getOrgId(), false));
        }

        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("vo", vo);
        model.addAttribute("isAdmin", isAdmin);

        return "msg2/prof_msg_shrtnt_list";
    }

    /*****************************************************
     * 관리자 쪽지 목록 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/mngr_msg_shrtnt_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/mngrMsgShrtntListView.do")
    public String mngrMsgShrtntListView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (!MsgAuthUtil.isAdmin(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        vo = msgShrtntFacadeService.loadListViewInfo(vo, true);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        vo.setListScale(PAGE_SIZE);
        setEncParamsToVO(vo);

        EgovMap filterOptions = msgShrtntFacadeService.loadFilterOptions(vo, true);
        model.addAttribute("filterOptions", filterOptions);

        model.addAttribute("vo", vo);
        model.addAttribute("isAdmin", true);

        return "msg2/mngr_msg_shrtnt_list";
    }

    /*****************************************************
     * 교수 쪽지 수신 상세 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/prof_msg_shrtnt_rcvn_detail"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgShrtntRcvnDetailView.do")
    public String profMsgShrtntRcvnDetailView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (!MsgAuthUtil.isProfessor(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        addEncParam("msgShrtntSndngId", vo.getMsgShrtntSndngId());
        model.addAttribute("msgShrtntSndngId", vo.getMsgShrtntSndngId());
        model.addAttribute("vo", vo);

        return "msg2/prof_msg_shrtnt_rcvn_detail";
    }

    /*****************************************************
     * 관리자 쪽지 수신 상세 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/mngr_msg_shrtnt_rcvn_detail"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/mngrMsgShrtntRcvnDetailView.do")
    public String mngrMsgShrtntRcvnDetailView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (!MsgAuthUtil.isAdmin(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        addEncParam("msgShrtntSndngId", vo.getMsgShrtntSndngId());
        model.addAttribute("msgShrtntSndngId", vo.getMsgShrtntSndngId());
        model.addAttribute("vo", vo);

        return "msg2/mngr_msg_shrtnt_rcvn_detail";
    }

    /*****************************************************
     * 교수 쪽지 발신 상세 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/prof_msg_shrtnt_sndng_detail"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgShrtntSndngDetailView.do")
    public String profMsgShrtntSndngDetailView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (!MsgAuthUtil.isProfessor(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        addEncParam("msgId", vo.getMsgId());
        model.addAttribute("msgId", vo.getMsgId());
        model.addAttribute("vo", vo);

        return "msg2/prof_msg_shrtnt_sndng_detail";
    }

    /*****************************************************
     * 관리자 쪽지 발신 상세 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/mngr_msg_shrtnt_sndng_detail"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/mngrMsgShrtntSndngDetailView.do")
    public String mngrMsgShrtntSndngDetailView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (!MsgAuthUtil.isAdmin(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        addEncParam("msgId", vo.getMsgId());
        model.addAttribute("msgId", vo.getMsgId());
        model.addAttribute("vo", vo);

        return "msg2/mngr_msg_shrtnt_sndng_detail";
    }

    /*****************************************************
     * 교수 쪽지 발신하기 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/prof_msg_shrtnt_sndng_regist"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgShrtntSndngRegistView.do")
    public String profMsgShrtntSndngRegistView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return handleSndngRegistView(vo, userCtx, model, request, false, "msg2/prof_msg_shrtnt_sndng_regist");
    }

    /*****************************************************
     * 관리자 쪽지 발신하기 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/mngr_msg_shrtnt_sndng_regist"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/mngrMsgShrtntSndngRegistView.do")
    public String mngrMsgShrtntSndngRegistView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return handleSndngRegistView(vo, userCtx, model, request, true, "msg2/mngr_msg_shrtnt_sndng_regist");
    }

    /*****************************************************
     * 받는 사람 검색 팝업 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/msg_shrtnt_rcvr_popup"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntRcvrPopupView.do")
    public String msgShrtntRcvrPopupView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        model.addAttribute("orgId", userCtx.getOrgId());
        model.addAttribute("vo", vo);

        return "msg2/msg_shrtnt_rcvr_popup";
    }

    /*****************************************************
     * 메시지 불러오기 팝업 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/msg_shrtnt_tmplt_popup"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntTmpltPopupView.do")
    public String msgShrtntTmpltPopupView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        model.addAttribute("vo", vo);

        return "msg2/msg_shrtnt_tmplt_popup";
    }

    /*****************************************************
     * 템플릿에 저장 팝업 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/msg_shrtnt_tmplt_save_popup"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntTmpltSavePopupView.do")
    public String msgShrtntTmpltSavePopupView(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        model.addAttribute("vo", vo);

        return "msg2/msg_shrtnt_tmplt_save_popup";
    }

    // ========== AJAX 메서드 ==========

    /*****************************************************
     * 기관 목록 AJAX 조회
     * @param vo
     * @return ProcessResultVO<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntOrgListAjax.do")
    @ResponseBody
    public ProcessResultVO<OrgInfoVO> msgShrtntOrgListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<OrgInfoVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            List<OrgInfoVO> list = msgShrtntFacadeService.selectActiveOrgListByAuth(userCtx.getOrgId(), MsgAuthUtil.isAdmin(userCtx));
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 쪽지 수신 목록 AJAX 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntRcvnListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntRcvnListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (StringUtil.isNull(userCtx.getUserId())) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setListScale(vo.getListScale() > 0 ? vo.getListScale() : PAGE_SIZE);
            vo.setRcvrId(userCtx.getUserId());
            MsgAuthUtil.applyProfConstraints(vo, userCtx);

            resultVO = msgShrtntFacadeService.selectShrtntRcvnListPage(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 쪽지 발신 목록 AJAX 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntSndngListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntSndngListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setListScale(vo.getListScale() > 0 ? vo.getListScale() : PAGE_SIZE);
            MsgAuthUtil.applyProfConstraints(vo, userCtx);
            vo.setSndngrId(userCtx.getUserId());

            resultVO = msgShrtntFacadeService.selectShrtntSndngListPage(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 쪽지 수신 상세 AJAX 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntRcvnDetailAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntRcvnDetailAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (StringUtil.isNull(userCtx.getUserId())) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setRcvrId(userCtx.getUserId());

            MsgShrtntVO detail = msgShrtntFacadeService.selectShrtntRcvnDetailWithFiles(vo);
            resultVO.setReturnVO(detail);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 쪽지 발신 상세 AJAX 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntSndngDetailAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntSndngDetailAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            if (!MsgAuthUtil.isAdmin(userCtx)) {
                vo.setSndngrId(userCtx.getUserId());
            }

            MsgShrtntVO detail = msgShrtntFacadeService.selectShrtntSndngDetailWithFiles(vo);
            resultVO.setReturnVO(detail);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 쪽지 발신 수신자 목록 AJAX 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntSndngRcvrListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntSndngRcvrListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            if (!MsgAuthUtil.isAdmin(userCtx)) {
                vo.setSndngrId(userCtx.getUserId());
            }

            vo.setListScale(vo.getListScale() > 0 ? vo.getListScale() : PAGE_SIZE);

            resultVO = msgShrtntFacadeService.selectShrtntSndngRcvrListPage(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 쪽지 읽음 처리 AJAX
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntReadAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntReadAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (StringUtil.isNull(userCtx.getUserId())) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setRcvrId(userCtx.getUserId());
            msgShrtntFacadeService.updateShrtntReadDttm(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.update"));
        }

        return resultVO;
    }

    /*****************************************************
     * 쪽지 삭제 AJAX (수신/발신 구분)
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntDeleteAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (StringUtil.isNull(userCtx.getUserId())) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            String userId = userCtx.getUserId();

            if (LIST_TYPE_RCVN.equals(vo.getListType())) {
                vo.setRcvrId(userId);
                msgShrtntFacadeService.updateShrtntRcvrDelyn(vo);
            } else {
                vo.setSndngrId(userId);
                msgShrtntFacadeService.updateShrtntSndngrDelyn(vo);
            }
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.delete"));
        }

        return resultVO;
    }

    /*****************************************************
     * 학사년도 목록 AJAX 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntYrListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntYrListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            MsgAuthUtil.applyProfConstraints(vo, userCtx);

            List<MsgShrtntVO> list = msgShrtntFacadeService.selectShrtntYrList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 학기 목록 AJAX 조회
     * @param vo
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntSmstrListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> msgShrtntSmstrListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            MsgAuthUtil.applyProfConstraints(vo, userCtx);

            List<EgovMap> list = msgShrtntFacadeService.selectShrtntSmstrList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 학과 목록 AJAX 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntDeptListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntDeptListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            if ("POPUP".equals(vo.getGubun())) {
                if (!MsgAuthUtil.isAdmin(userCtx) || StringUtil.isNull(vo.getOrgId())) {
                    vo.setOrgId(userCtx.getOrgId());
                }
            } else {
                MsgAuthUtil.applyProfConstraints(vo, userCtx);
            }

            List<MsgShrtntVO> list = msgShrtntFacadeService.selectShrtntDeptList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 운영과목 목록 AJAX 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntSbjctListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntSbjctListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            if ("POPUP".equals(vo.getGubun())) {
                if (!MsgAuthUtil.isAdmin(userCtx) || StringUtil.isNull(vo.getOrgId())) {
                    vo.setOrgId(userCtx.getOrgId());
                }
            } else {
                MsgAuthUtil.applyProfConstraints(vo, userCtx);
            }

            List<MsgShrtntVO> list = msgShrtntFacadeService.selectShrtntSbjctList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 쪽지 발신 수신자 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/downExcelMsgShrtntRcvr.do")
    public String downExcelMsgShrtntRcvr(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {

        if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        if (!MsgAuthUtil.isAdmin(userCtx)) {
            vo.setSndngrId(userCtx.getUserId());
        }

        try {
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
        } catch (Exception e) {
            throw new Exception(getMessage("fail.common.select"));
        }

        return "excelView";
    }

    /*****************************************************
     * 쪽지 발신 등록 AJAX
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntSndngRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntSndngRegistAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setRgtrId(userCtx.getUserId());
            vo.setSndngrId(userCtx.getUserId());
            vo.setOrgId(userCtx.getOrgId());

            msgShrtntFacadeService.registShrtntSndngWithFiles(vo, uploadFiles, uploadPath);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.insert"));
            if (StringUtil.isNotNull(uploadFiles) && StringUtil.isNotNull(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }

        return resultVO;
    }

    /*****************************************************
     * 쪽지 발신 수정 AJAX
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntSndngModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntSndngModifyAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setMdfrId(userCtx.getUserId());
            vo.setSndngrId(userCtx.getUserId());

            msgShrtntFacadeService.modifyShrtntSndngWithFiles(vo, uploadFiles, uploadPath, vo.getDelFileIds());
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.update"));
            if (StringUtil.isNotNull(uploadFiles) && StringUtil.isNotNull(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }

        return resultVO;
    }

    /*****************************************************
     * 쪽지 예약 취소 AJAX
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntRsrvCnclAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntRsrvCnclAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            String userId = userCtx.getUserId();
            vo.setMdfrId(userId);
            if (!MsgAuthUtil.isAdmin(userCtx)) {
                vo.setSndngrId(userId);
            }
            msgShrtntFacadeService.updateMsgRsrvCncl(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.update"));
        }

        return resultVO;
    }

    /*****************************************************
     * 받는 사람 검색 AJAX
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntRcvrSearchAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntRcvrSearchAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            if ("POPUP".equals(vo.getGubun())) {
                if (!MsgAuthUtil.isAdmin(userCtx) || StringUtil.isNull(vo.getOrgId())) {
                    vo.setOrgId(userCtx.getOrgId());
                }
            } else {
                MsgAuthUtil.applyProfConstraints(vo, userCtx);
            }
            if (MsgAuthUtil.isAdmin(userCtx)) {
                vo.setAdminYn("Y");
            }
            vo.setSndngrId(userCtx.getUserId());
            vo.setListScale(vo.getListScale() > 0 ? vo.getListScale() : PAGE_SIZE);

            resultVO = msgShrtntFacadeService.selectShrtntRcvrSearchListPage(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 수신 대상자 목록 AJAX 조회 (수정 폼용)
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntRcvTrgtrListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntRcvTrgtrListAjax(MsgShrtntVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            if (!MsgAuthUtil.isAdmin(userCtx)) {
                vo.setSndngrId(userCtx.getUserId());
            }

            List<MsgShrtntVO> list = msgShrtntFacadeService.selectMsgRcvTrgtrList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 수신자 엑셀 업로드 양식 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/downExcelMsgShrtntRcvrTmplt.do")
    public String downExcelMsgShrtntRcvrTmplt(MsgShrtntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {

        if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

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
     * @param excelFile
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgShrtntRcvrExcelUploadAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgShrtntVO> msgShrtntRcvrExcelUploadAjax(
            @RequestParam("excelFile") MultipartFile excelFile,
            MsgShrtntVO vo,
            @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgShrtntVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

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
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }
}
