package knou.lms.msg.web;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.facade.MsgAlimTalkFacadeService;
import knou.lms.msg.vo.MsgAlimTalkVO;
import knou.lms.msg.vo.MsgAlimTalkVO;
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
public class MsgAlimTalkController extends ControllerBase {

    @Resource(name = "msgAlimTalkFacadeService")
    private MsgAlimTalkFacadeService msgAlimTalkFacadeService;

    private static final String CHNL_ALIM_TALK = CommConst.MSG_CHNL_ALIM_TALK;

    private static final String LIST_TYPE_RCVN = "RCVN";

    /*****************************************************
     * 알림톡 발신 화면 공통 모델 구성
     * @param vo
     * @param userCtx
     * @param model
     * @throws Exception
     ******************************************************/
    private void prepareSndngCommonModel(MsgAlimTalkVO vo, UserContext userCtx, ModelMap model) throws Exception {
        model.addAttribute("orgId", userCtx.getOrgId());

        boolean hasSndngAuth = MsgAuthUtil.isAdmin(userCtx);
        EgovMap registInfo = msgAlimTalkFacadeService.loadSndngRegistViewInfo(vo.getMsgId(), userCtx.getUserId(), hasSndngAuth);
        if (!(boolean) registInfo.get("hasAuth")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        vo.setUserNm(StringUtil.nvl((String) registInfo.get("userNm")));
        vo.setSndngrPhnno(StringUtil.nvl((String) registInfo.get("userMblPhn")));

        model.addAttribute("filterOptions", msgAlimTalkFacadeService.loadSndngRegistFilterOptions(userCtx));
        model.addAttribute("vo", vo);
    }

    /*****************************************************
     * 알림톡 발신 수정 모드 모델 구성
     * @param vo
     * @param userCtx
     * @param model
     ******************************************************/
    private void prepareEditModeModel(MsgAlimTalkVO vo, UserContext userCtx, ModelMap model) {
        String msgId = vo.getMsgId();
        EgovMap editInfo = msgAlimTalkFacadeService.loadEditLinkInfo(msgId, userCtx);
        MsgAlimTalkVO original = (MsgAlimTalkVO) editInfo.get("original");
        if (original == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        boolean isEditActive = "Y".equals(original.getRsrvYn())
                && "Y".equals(original.getFullyPendingYn())
                && StringUtil.isNull(original.getRsrvSndngCnclDttm());
        if (!isEditActive) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        MsgAlimTalkVO trgVo = new MsgAlimTalkVO();
        trgVo.setMsgId(msgId);
        trgVo.setMblSndngTycd(CHNL_ALIM_TALK);
        trgVo.setSndngrId(userCtx.getUserId());
        List<MsgAlimTalkVO> editRcvrList = msgAlimTalkFacadeService.selectMsgRcvTrgtrList(trgVo);

        String origSndngnm = StringUtil.nvl(original.getSndngnm());
        String userNm = StringUtil.nvl(vo.getUserNm());
        boolean isCustomSndngnm = !origSndngnm.isEmpty() && !origSndngnm.equals(userNm);

        msgAlimTalkFacadeService.applyOriginalToFilterOptions((EgovMap) model.get("filterOptions"), original);

        model.addAttribute("editInfo", editInfo);
        model.addAttribute("editRcvrList", editRcvrList);
        model.addAttribute("msgId", msgId);
        model.addAttribute("isCustomSndngnm", isCustomSndngnm);
        model.addAttribute("origSndngnm", origSndngnm);
    }

    /*****************************************************
     * 교수 알림톡 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_alim_talk_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgAlimTalkListView.do")
    public String profMsgAlimTalkListView(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgAlimTalkFacadeService.loadListViewInfo(vo);

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

        EgovMap filterOptions = msgAlimTalkFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgAlimTalkFacadeService.selectProfSbjctOrgList(userCtx.getUserId()));

        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("vo", vo);

        return "msg/prof_msg_alim_talk_list_view";
    }

    /*****************************************************
     * 교수 알림톡 수신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_alim_talk_rcvn_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgAlimTalkRcvnSelectView.do")
    public String profMsgAlimTalkRcvnSelectView(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgMblSndngId", vo.getMsgMblSndngId());
        model.addAttribute("msgMblSndngId", vo.getMsgMblSndngId());

        vo.setMblSndngTycd(CHNL_ALIM_TALK);
        vo.setRcvrId(userCtx.getUserId());
        MsgAlimTalkVO detail = msgAlimTalkFacadeService.selectAlimTalkRcvnDtl(vo);
        if (detail != null) {
            msgAlimTalkFacadeService.modifyAlimTalkReadDttm(vo);
        }
        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);

        return "msg/prof_msg_alim_talk_rcvn_select_view";
    }

    /*****************************************************
     * 교수 알림톡 발신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_alim_talk_sndng_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgAlimTalkSndngSelectView.do")
    public String profMsgAlimTalkSndngSelectView(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgId", vo.getMsgId());
        model.addAttribute("msgId", vo.getMsgId());

        vo.setMblSndngTycd(CHNL_ALIM_TALK);
        vo.setSndngrId(userCtx.getUserId());
        MsgAlimTalkVO detail = msgAlimTalkFacadeService.selectAlimTalkSndngDtl(vo);

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

        return "msg/prof_msg_alim_talk_sndng_select_view";
    }

    /*****************************************************
     * 교수 알림톡 발신 등록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_alim_talk_sndng_regist_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgAlimTalkSndngRegistView.do")
    public String profMsgAlimTalkSndngRegistView(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        delEncParam("msgId");
        vo.setMsgId(null);
        prepareSndngCommonModel(vo, userCtx, model);
        return "msg/prof_msg_alim_talk_sndng_regist_view";
    }

    /*****************************************************
     * 교수 알림톡 수정 화면 (예약 대기건)
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_alim_talk_sndng_modify_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgAlimTalkSndngModifyView.do")
    public String profMsgAlimTalkSndngModifyView(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        if (StringUtil.isNull(vo.getMsgId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        addEncParam("msgId", vo.getMsgId());
        prepareSndngCommonModel(vo, userCtx, model);
        prepareEditModeModel(vo, userCtx, model);
        return "msg/prof_msg_alim_talk_sndng_modify_view";
    }

    /*****************************************************
     * 관리자 알림톡 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_alim_talk_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgAlimTalkListView.do")
    public String admMsgAlimTalkListView(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgAlimTalkFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("msgId");
        delEncParam("msgMblSndngId");

        if (StringUtil.isNull(vo.getListType())) {
            delEncParam("orgId");
            vo.setOrgId(null);
        }

        EgovMap filterOptions = msgAlimTalkFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgAlimTalkFacadeService.selectActiveOrgListByAuth(userCtx.getUserId(), true));

        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("vo", vo);

        return "msg/adm_msg_alim_talk_list_view";
    }

    /*****************************************************
     * 관리자 알림톡 수신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_alim_talk_rcvn_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgAlimTalkRcvnSelectView.do")
    public String admMsgAlimTalkRcvnSelectView(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgMblSndngId", vo.getMsgMblSndngId());
        model.addAttribute("msgMblSndngId", vo.getMsgMblSndngId());

        vo.setMblSndngTycd(CHNL_ALIM_TALK);
        vo.setRcvrId(userCtx.getUserId());
        MsgAlimTalkVO detail = msgAlimTalkFacadeService.selectAlimTalkRcvnDtl(vo);
        if (detail != null) {
            msgAlimTalkFacadeService.modifyAlimTalkReadDttm(vo);
        }
        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);

        return "msg/adm_msg_alim_talk_rcvn_select_view";
    }

    /*****************************************************
     * 관리자 푸시 발신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_alim_talk_sndng_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgAlimTalkSndngSelectView.do")
    public String admMsgAlimTalkSndngSelectView(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgId", vo.getMsgId());
        model.addAttribute("msgId", vo.getMsgId());

        vo.setMblSndngTycd(CHNL_ALIM_TALK);
        vo.setSndngrId(userCtx.getUserId());
        MsgAlimTalkVO detail = msgAlimTalkFacadeService.selectAlimTalkSndngDtl(vo);

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

        return "msg/adm_msg_alim_talk_sndng_select_view";
    }

    /*****************************************************
     * 관리자 푸시 발신 등록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_alim_talk_sndng_regist_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgAlimTalkSndngRegistView.do")
    public String admMsgAlimTalkSndngRegistView(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        delEncParam("msgId");
        vo.setMsgId(null);
        prepareSndngCommonModel(vo, userCtx, model);
        return "msg/adm_msg_alim_talk_sndng_regist_view";
    }

    /*****************************************************
     * 관리자 푸시 수정 화면 (예약 대기건)
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_alim_talk_sndng_modify_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgAlimTalkSndngModifyView.do")
    public String admMsgAlimTalkSndngModifyView(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        if (StringUtil.isNull(vo.getMsgId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        addEncParam("msgId", vo.getMsgId());
        prepareSndngCommonModel(vo, userCtx, model);
        prepareEditModeModel(vo, userCtx, model);
        return "msg/adm_msg_alim_talk_sndng_modify_view";
    }

    /*****************************************************
     * 학생 푸시 목록 화면 (수신 전용)
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/stdnt_msg_alim_talk_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/stdntMsgAlimTalkListView.do")
    public String stdntMsgAlimTalkListView(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo.setListType(LIST_TYPE_RCVN);
        vo = msgAlimTalkFacadeService.loadListViewInfo(vo);

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

        EgovMap filterOptions = msgAlimTalkFacadeService.loadStdntFilterOptions(vo);
        filterOptions.put("orgList", msgAlimTalkFacadeService.selectActiveOrgListByAuth(userCtx.getUserId(), false));

        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("vo", vo);

        return "msg/stdnt_msg_alim_talk_list_view";
    }

    /*****************************************************
     * 학생 푸시 수신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/stdnt_msg_alim_talk_rcvn_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/stdntMsgAlimTalkRcvnSelectView.do")
    public String stdntMsgAlimTalkRcvnSelectView(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgMblSndngId", vo.getMsgMblSndngId());
        model.addAttribute("msgMblSndngId", vo.getMsgMblSndngId());

        vo.setMblSndngTycd(CHNL_ALIM_TALK);
        vo.setRcvrId(userCtx.getUserId());
        MsgAlimTalkVO detail = msgAlimTalkFacadeService.selectAlimTalkRcvnDtl(vo);
        if (detail != null) {
            msgAlimTalkFacadeService.modifyAlimTalkReadDttm(vo);
        }
        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);

        return "msg/stdnt_msg_alim_talk_rcvn_select_view";
    }

    /*****************************************************
     * 알림톡 수신 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgAlimTalkVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgAlimTalkRcvnListAjax.do", "/admMsgAlimTalkRcvnListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgAlimTalkVO> msgAlimTalkRcvnListAjax(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgAlimTalkVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        vo.setMblSndngTycd(CHNL_ALIM_TALK);
        vo.setRcvrId(userCtx.getUserId());

        resultVO = msgAlimTalkFacadeService.selectAlimTalkRcvnListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 알림톡 발신 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgAlimTalkVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgAlimTalkSndngListAjax.do", "/admMsgAlimTalkSndngListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgAlimTalkVO> msgAlimTalkSndngListAjax(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgAlimTalkVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_ALIM_TALK);
        vo.setSndngrId(userCtx.getUserId());

        resultVO = msgAlimTalkFacadeService.selectAlimTalkSndngListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 알림톡 발신 수신자 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgAlimTalkVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgAlimTalkSndngRcvrListAjax.do", "/admMsgAlimTalkSndngRcvrListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgAlimTalkVO> msgAlimTalkSndngRcvrListAjax(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgAlimTalkVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_ALIM_TALK);
        vo.setSndngrId(userCtx.getUserId());

        resultVO = msgAlimTalkFacadeService.selectAlimTalkSndngRcvrListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 알림톡 발신 등록 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgAlimTalkVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgAlimTalkSndngRegistAjax.do", "/admMsgAlimTalkSndngRegistAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgAlimTalkVO> msgAlimTalkSndngRegistAjax(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgAlimTalkVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_ALIM_TALK);
        vo.setRgtrId(userCtx.getUserId());
        vo.setSndngrId(userCtx.getUserId());
        vo.setOrgId(userCtx.getOrgId());

        msgAlimTalkFacadeService.registAlimTalkSndng(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 알림톡 발신 수정 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgAlimTalkVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgAlimTalkSndngModifyAjax.do", "/admMsgAlimTalkSndngModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgAlimTalkVO> msgAlimTalkSndngModifyAjax(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgAlimTalkVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_ALIM_TALK);
        vo.setMdfrId(userCtx.getUserId());
        vo.setSndngrId(userCtx.getUserId());

        msgAlimTalkFacadeService.modifyAlimTalkSndng(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 알림톡 예약 취소 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgAlimTalkVO>
     ******************************************************/
    @RequestMapping({"/msgAlimTalkRsrvCnclModifyAjax.do", "/admMsgAlimTalkRsrvCnclModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgAlimTalkVO> msgAlimTalkRsrvCnclModifyAjax(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgAlimTalkVO> resultVO = new ProcessResultVO<>();

        String userId = userCtx.getUserId();
        vo.setMblSndngTycd(CHNL_ALIM_TALK);
        vo.setMdfrId(userId);
        vo.setSndngrId(userId);
        int cnclCnt = msgAlimTalkFacadeService.modifyMsgRsrvCncl(vo);
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
     * 알림톡 읽음 처리 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgAlimTalkVO>
     ******************************************************/
    @RequestMapping({"/msgAlimTalkReadModifyAjax.do", "/admMsgAlimTalkReadModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgAlimTalkVO> msgAlimTalkReadModifyAjax(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgAlimTalkVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        vo.setRcvrId(userCtx.getUserId());
        msgAlimTalkFacadeService.modifyAlimTalkReadDttm(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 알림톡 삭제 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgAlimTalkVO>
     ******************************************************/
    @RequestMapping({"/msgAlimTalkDeleteAjax.do", "/admMsgAlimTalkDeleteAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgAlimTalkVO> msgAlimTalkDeleteAjax(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgAlimTalkVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(userCtx.getUserId())) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        String userId = userCtx.getUserId();
        vo.setMblSndngTycd(CHNL_ALIM_TALK);

        if (LIST_TYPE_RCVN.equals(vo.getListType())) {
            vo.setRcvrId(userId);
            msgAlimTalkFacadeService.modifyAlimTalkRcvrDelyn(vo);
        } else {
            vo.setSndngrId(userId);
            msgAlimTalkFacadeService.modifyAlimTalkSndngrDelyn(vo);
        }
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 알림톡 발신 수신 대상자 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgAlimTalkVO>
     ******************************************************/
    @RequestMapping({"/msgAlimTalkRcvTrgtrListAjax.do", "/admMsgAlimTalkRcvTrgtrListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgAlimTalkVO> msgAlimTalkRcvTrgtrListAjax(MsgAlimTalkVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgAlimTalkVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_ALIM_TALK);
        vo.setSndngrId(userCtx.getUserId());

        List<MsgAlimTalkVO> list = msgAlimTalkFacadeService.selectMsgRcvTrgtrList(vo);
        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

}
