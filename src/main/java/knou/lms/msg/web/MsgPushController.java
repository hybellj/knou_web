package knou.lms.msg.web;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.facade.MsgPushFacadeService;
import knou.lms.msg.vo.MsgPushVO;
import knou.lms.msg.web.util.MsgAuthUtil;
import knou.lms.user.CurrentUser;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

@Controller
public class MsgPushController extends ControllerBase {

    @Resource(name = "msgPushFacadeService")
    private MsgPushFacadeService msgPushFacadeService;

    private static final String CHNL_PUSH = CommConst.MSG_CHNL_PUSH;

    private static final String LIST_TYPE_RCVN = "RCVN";

    /*****************************************************
     * 푸시 발신 화면 공통 모델 구성
     * @param vo
     * @param userCtx
     * @param model
     * @throws Exception
     ******************************************************/
    private void prepareSndngCommonModel(MsgPushVO vo, UserContext userCtx, ModelMap model) throws Exception {
        model.addAttribute("orgId", userCtx.getOrgId());

        boolean hasSndngAuth = MsgAuthUtil.isAdmin(userCtx);
        EgovMap registInfo = msgPushFacadeService.loadSndngRegistViewInfo(vo.getMsgId(), userCtx.getUserId(), hasSndngAuth);
        if (!(boolean) registInfo.get("hasAuth")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        vo.setUserNm(StringUtil.nvl((String) registInfo.get("userNm")));
        vo.setSndngrPhnno(StringUtil.nvl((String) registInfo.get("userMblPhn")));

        model.addAttribute("filterOptions", msgPushFacadeService.loadSndngRegistFilterOptions(userCtx));
        model.addAttribute("vo", vo);
    }

    /*****************************************************
     * 푸시 발신 수정 모드 모델 구성
     * @param vo
     * @param userCtx
     * @param model
     ******************************************************/
    private void prepareEditModeModel(MsgPushVO vo, UserContext userCtx, ModelMap model) {
        String msgId = vo.getMsgId();
        EgovMap editInfo = msgPushFacadeService.loadEditLinkInfo(msgId, userCtx);
        MsgPushVO original = (MsgPushVO) editInfo.get("original");
        if (original == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        boolean isEditActive = "Y".equals(original.getRsrvYn())
                && "Y".equals(original.getFullyPendingYn())
                && StringUtil.isNull(original.getRsrvSndngCnclDttm());
        if (!isEditActive) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        MsgPushVO trgVo = new MsgPushVO();
        trgVo.setMsgId(msgId);
        trgVo.setMblSndngTycd(CHNL_PUSH);
        trgVo.setSndngrId(userCtx.getUserId());
        List<MsgPushVO> editRcvrList = msgPushFacadeService.selectMsgRcvTrgtrList(trgVo);

        String origSndngnm = StringUtil.nvl(original.getSndngnm());
        String userNm = StringUtil.nvl(vo.getUserNm());
        boolean isCustomSndngnm = !origSndngnm.isEmpty() && !origSndngnm.equals(userNm);

        msgPushFacadeService.applyOriginalToFilterOptions((EgovMap) model.get("filterOptions"), original);

        model.addAttribute("editInfo", editInfo);
        model.addAttribute("editRcvrList", editRcvrList);
        model.addAttribute("msgId", msgId);
        model.addAttribute("isCustomSndngnm", isCustomSndngnm);
        model.addAttribute("origSndngnm", origSndngnm);
    }

    /*****************************************************
     * 교수 푸시 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_push_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgPushListView.do")
    public String profMsgPushListView(MsgPushVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgPushFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("msgId");
        delEncParam("msgMblSndngId");

        if (StringUtil.isNull(vo.getListType())) {
            delEncParam("orgId");
            vo.setOrgId(null);
        }

        vo.setUserId(userCtx.getUserId());

        EgovMap filterOptions = msgPushFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgPushFacadeService.selectProfSbjctOrgList(userCtx.getUserId()));

        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("vo", vo);

        return "msg/prof_msg_push_list_view";
    }

    /*****************************************************
     * 교수 푸시 수신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_push_rcvn_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgPushRcvnSelectView.do")
    public String profMsgPushRcvnSelectView(MsgPushVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgMblSndngId", vo.getMsgMblSndngId());
        model.addAttribute("msgMblSndngId", vo.getMsgMblSndngId());

        vo.setMblSndngTycd(CHNL_PUSH);
        vo.setRcvrId(userCtx.getUserId());
        MsgPushVO detail = msgPushFacadeService.selectPushRcvnDtl(vo);
        if (detail != null) {
            msgPushFacadeService.modifyPushReadDttm(vo);
        }
        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);

        return "msg/prof_msg_push_rcvn_select_view";
    }

    /*****************************************************
     * 교수 푸시 발신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_push_sndng_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgPushSndngSelectView.do")
    public String profMsgPushSndngSelectView(MsgPushVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgId", vo.getMsgId());
        model.addAttribute("msgId", vo.getMsgId());

        vo.setMblSndngTycd(CHNL_PUSH);
        vo.setSndngrId(userCtx.getUserId());
        MsgPushVO detail = msgPushFacadeService.selectPushSndngDtl(vo);

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

        return "msg/prof_msg_push_sndng_select_view";
    }

    /*****************************************************
     * 교수 푸시 발신 등록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_push_sndng_regist_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgPushSndngRegistView.do")
    public String profMsgPushSndngRegistView(MsgPushVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        delEncParam("msgId");
        vo.setMsgId(null);
        prepareSndngCommonModel(vo, userCtx, model);
        return "msg/prof_msg_push_sndng_regist_view";
    }

    /*****************************************************
     * 교수 푸시 수정 화면 (예약 대기건)
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_push_sndng_modify_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgPushSndngModifyView.do")
    public String profMsgPushSndngModifyView(MsgPushVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        if (StringUtil.isNull(vo.getMsgId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        addEncParam("msgId", vo.getMsgId());
        prepareSndngCommonModel(vo, userCtx, model);
        prepareEditModeModel(vo, userCtx, model);
        return "msg/prof_msg_push_sndng_modify_view";
    }

    /*****************************************************
     * 관리자 푸시 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_push_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgPushListView.do")
    public String admMsgPushListView(MsgPushVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgPushFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("msgId");
        delEncParam("msgMblSndngId");

        if (StringUtil.isNull(vo.getListType())) {
            delEncParam("orgId");
            vo.setOrgId(null);
        }

        EgovMap filterOptions = msgPushFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgPushFacadeService.selectActiveOrgListByAuth(userCtx.getUserId(), true));

        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("vo", vo);

        return "msg/adm_msg_push_list_view";
    }

    /*****************************************************
     * 관리자 푸시 수신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_push_rcvn_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgPushRcvnSelectView.do")
    public String admMsgPushRcvnSelectView(MsgPushVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgMblSndngId", vo.getMsgMblSndngId());
        model.addAttribute("msgMblSndngId", vo.getMsgMblSndngId());

        vo.setMblSndngTycd(CHNL_PUSH);
        vo.setRcvrId(userCtx.getUserId());
        MsgPushVO detail = msgPushFacadeService.selectPushRcvnDtl(vo);
        if (detail != null) {
            msgPushFacadeService.modifyPushReadDttm(vo);
        }
        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);

        return "msg/adm_msg_push_rcvn_select_view";
    }

    /*****************************************************
     * 관리자 푸시 발신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_push_sndng_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgPushSndngSelectView.do")
    public String admMsgPushSndngSelectView(MsgPushVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgId", vo.getMsgId());
        model.addAttribute("msgId", vo.getMsgId());

        vo.setMblSndngTycd(CHNL_PUSH);
        vo.setSndngrId(userCtx.getUserId());
        MsgPushVO detail = msgPushFacadeService.selectPushSndngDtl(vo);

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

        return "msg/adm_msg_push_sndng_select_view";
    }

    /*****************************************************
     * 관리자 푸시 발신 등록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_push_sndng_regist_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgPushSndngRegistView.do")
    public String admMsgPushSndngRegistView(MsgPushVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        delEncParam("msgId");
        vo.setMsgId(null);
        prepareSndngCommonModel(vo, userCtx, model);
        return "msg/adm_msg_push_sndng_regist_view";
    }

    /*****************************************************
     * 관리자 푸시 수정 화면 (예약 대기건)
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_push_sndng_modify_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgPushSndngModifyView.do")
    public String admMsgPushSndngModifyView(MsgPushVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        if (StringUtil.isNull(vo.getMsgId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        addEncParam("msgId", vo.getMsgId());
        prepareSndngCommonModel(vo, userCtx, model);
        prepareEditModeModel(vo, userCtx, model);
        return "msg/adm_msg_push_sndng_modify_view";
    }

    /*****************************************************
     * 학생 푸시 목록 화면 (수신 전용)
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/stdnt_msg_push_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/stdntMsgPushListView.do")
    public String stdntMsgPushListView(MsgPushVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo.setListType(LIST_TYPE_RCVN);
        vo = msgPushFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("msgId");
        delEncParam("msgMblSndngId");

        vo.setUserId(userCtx.getUserId());

        EgovMap filterOptions = msgPushFacadeService.loadStdntFilterOptions(vo);
        filterOptions.put("orgList", msgPushFacadeService.selectActiveOrgListByAuth(userCtx.getUserId(), false));

        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("vo", vo);

        return "msg/stdnt_msg_push_list_view";
    }

    /*****************************************************
     * 학생 푸시 수신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/stdnt_msg_push_rcvn_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/stdntMsgPushRcvnSelectView.do")
    public String stdntMsgPushRcvnSelectView(MsgPushVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgMblSndngId", vo.getMsgMblSndngId());
        model.addAttribute("msgMblSndngId", vo.getMsgMblSndngId());

        vo.setMblSndngTycd(CHNL_PUSH);
        vo.setRcvrId(userCtx.getUserId());
        MsgPushVO detail = msgPushFacadeService.selectPushRcvnDtl(vo);
        if (detail != null) {
            msgPushFacadeService.modifyPushReadDttm(vo);
        }
        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);

        return "msg/stdnt_msg_push_rcvn_select_view";
    }

    /*****************************************************
     * 푸시 수신 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgPushVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgPushRcvnListAjax.do", "/admMsgPushRcvnListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgPushVO> msgPushRcvnListAjax(MsgPushVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgPushVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        vo.setMblSndngTycd(CHNL_PUSH);
        vo.setRcvrId(userCtx.getUserId());

        resultVO = msgPushFacadeService.selectPushRcvnListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 푸시 발신 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgPushVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgPushSndngListAjax.do", "/admMsgPushSndngListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgPushVO> msgPushSndngListAjax(MsgPushVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgPushVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_PUSH);
        vo.setSndngrId(userCtx.getUserId());

        resultVO = msgPushFacadeService.selectPushSndngListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 푸시 발신 수신자 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgPushVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgPushSndngRcvrListAjax.do", "/admMsgPushSndngRcvrListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgPushVO> msgPushSndngRcvrListAjax(MsgPushVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgPushVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_PUSH);
        vo.setSndngrId(userCtx.getUserId());

        resultVO = msgPushFacadeService.selectPushSndngRcvrListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 푸시 발신 등록 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgPushVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgPushSndngRegistAjax.do", "/admMsgPushSndngRegistAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgPushVO> msgPushSndngRegistAjax(MsgPushVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgPushVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_PUSH);
        vo.setRgtrId(userCtx.getUserId());
        vo.setSndngrId(userCtx.getUserId());
        vo.setOrgId(userCtx.getOrgId());

        msgPushFacadeService.registPushSndng(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 푸시 발신 수정 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgPushVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgPushSndngModifyAjax.do", "/admMsgPushSndngModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgPushVO> msgPushSndngModifyAjax(MsgPushVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgPushVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_PUSH);
        vo.setMdfrId(userCtx.getUserId());
        vo.setSndngrId(userCtx.getUserId());

        msgPushFacadeService.modifyPushSndng(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 푸시 예약 취소 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgPushVO>
     ******************************************************/
    @RequestMapping({"/msgPushRsrvCnclModifyAjax.do", "/admMsgPushRsrvCnclModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgPushVO> msgPushRsrvCnclModifyAjax(MsgPushVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgPushVO> resultVO = new ProcessResultVO<>();

        String userId = userCtx.getUserId();
        vo.setMblSndngTycd(CHNL_PUSH);
        vo.setMdfrId(userId);
        vo.setSndngrId(userId);
        int cnclCnt = msgPushFacadeService.modifyMsgRsrvCncl(vo);
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
     * 푸시 읽음 처리 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgPushVO>
     ******************************************************/
    @RequestMapping({"/msgPushReadModifyAjax.do", "/admMsgPushReadModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgPushVO> msgPushReadModifyAjax(MsgPushVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgPushVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        vo.setRcvrId(userCtx.getUserId());
        msgPushFacadeService.modifyPushReadDttm(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 푸시 삭제 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgPushVO>
     ******************************************************/
    @RequestMapping({"/msgPushDeleteAjax.do", "/admMsgPushDeleteAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgPushVO> msgPushDeleteAjax(MsgPushVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgPushVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        String userId = userCtx.getUserId();
        vo.setMblSndngTycd(CHNL_PUSH);

        if (LIST_TYPE_RCVN.equals(vo.getListType())) {
            vo.setRcvrId(userId);
            msgPushFacadeService.modifyPushRcvrDelyn(vo);
        } else {
            vo.setSndngrId(userId);
            msgPushFacadeService.modifyPushSndngrDelyn(vo);
        }
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 푸시 발신 수신 대상자 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgPushVO>
     ******************************************************/
    @RequestMapping({"/msgPushRcvTrgtrListAjax.do", "/admMsgPushRcvTrgtrListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgPushVO> msgPushRcvTrgtrListAjax(MsgPushVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgPushVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_PUSH);
        vo.setSndngrId(userCtx.getUserId());

        List<MsgPushVO> list = msgPushFacadeService.selectMsgRcvTrgtrList(vo);
        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

}
