package knou.lms.msg.web;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.facade.MsgSmsFacadeService;
import knou.lms.msg.vo.MsgSmsVO;
import knou.lms.user.CurrentUser;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

@Controller
public class MsgSmsController extends ControllerBase {

    @Resource(name = "msgSmsFacadeService")
    private MsgSmsFacadeService msgSmsFacadeService;

    private static final String CHNL_SMS = CommConst.MSG_CHNL_SMS;
    private static final String CHNL_LMS = CommConst.MSG_CHNL_LMS;

    private static final String LIST_TYPE_RCVN = "RCVN";


    /*****************************************************
     * 문자 발신 화면 공통 모델 구성
     * @param vo
     * @param userCtx
     * @param model
     * @throws Exception
     ******************************************************/
    private void prepareSndngCommonModel(MsgSmsVO vo, UserContext userCtx, ModelMap model) throws Exception {
        model.addAttribute("orgId", userCtx.getOrgId());

        EgovMap registInfo = msgSmsFacadeService.loadSndngRegistViewInfo(userCtx.getUserId());
        vo.setUserNm(StringUtil.nvl((String) registInfo.get("userNm")));
        vo.setSndngrPhnno(StringUtil.nvl((String) registInfo.get("userMblPhn")));

        model.addAttribute("filterOptions", msgSmsFacadeService.loadSndngRegistFilterOptions(userCtx));
        model.addAttribute("vo", vo);
    }

    /*****************************************************
     * 문자 발신 수정 모드 모델 구성
     * @param vo
     * @param userCtx
     * @param model
     ******************************************************/
    private void prepareEditModeModel(MsgSmsVO vo, UserContext userCtx, ModelMap model) {
        String msgId = vo.getMsgId();
        EgovMap editInfo = msgSmsFacadeService.loadEditLinkInfo(msgId, userCtx);
        MsgSmsVO original = (MsgSmsVO) editInfo.get("original");
        if (original == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        boolean isEditActive = "Y".equals(original.getRsrvYn())
                && "Y".equals(original.getFullyPendingYn())
                && StringUtil.isNull(original.getRsrvSndngCnclDttm());
        if (!isEditActive) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        MsgSmsVO trgVo = new MsgSmsVO();
        trgVo.setMsgId(msgId);
        trgVo.setMblSndngTycd(CHNL_SMS);
        trgVo.setSndngrId(userCtx.getUserId());
        List<MsgSmsVO> editRcvrList = msgSmsFacadeService.selectMsgRcvTrgtrList(trgVo);

        String origSndngnm = StringUtil.nvl(original.getSndngnm());
        String userNm = StringUtil.nvl(vo.getUserNm());
        boolean isCustomSndngnm = !origSndngnm.isEmpty() && !origSndngnm.equals(userNm);

        msgSmsFacadeService.applyOriginalToFilterOptions((EgovMap) model.get("filterOptions"), original);

        model.addAttribute("editInfo", editInfo);
        model.addAttribute("editRcvrList", editRcvrList);
        model.addAttribute("msgId", msgId);
        model.addAttribute("isCustomSndngnm", isCustomSndngnm);
        model.addAttribute("origSndngnm", origSndngnm);
    }

    /*****************************************************
     * 발신 채널코드 정규화 (본문 byte 길이 기준 SMS/LMS 판정)
     * 작성 화면에서 hidden 필드로 전달된 mblSndngTycd 값을 검증한다.
     * @param vo
     ******************************************************/
    private void normalizeChnl(MsgSmsVO vo) {
        if (!CHNL_LMS.equals(vo.getMblSndngTycd())) {
            vo.setMblSndngTycd(CHNL_SMS);
        }
    }

    /*****************************************************
     * 관리자 문자 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_sms_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsListView.do")
    public String admMsgSmsListView(MsgSmsVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgSmsFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("msgId");
        delEncParam("msgMblSndngId");

        if (StringUtil.isNull(vo.getListType())) {
            delEncParam("orgId");
            vo.setOrgId(null);
        }

        EgovMap filterOptions = msgSmsFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgSmsFacadeService.selectActiveOrgListByAuth(userCtx.getUserId(), true));

        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("vo", vo);

        return "msg/adm_msg_sms_list_view";
    }

    /*****************************************************
     * 관리자 문자 수신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_sms_rcvn_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsRcvnSelectView.do")
    public String admMsgSmsRcvnSelectView(MsgSmsVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgMblSndngId", vo.getMsgMblSndngId());
        model.addAttribute("msgMblSndngId", vo.getMsgMblSndngId());

        vo.setMblSndngTycd(CHNL_SMS);
        vo.setRcvrId(userCtx.getUserId());
        MsgSmsVO detail = msgSmsFacadeService.selectSmsRcvnDtl(vo);
        if (detail != null) {
            msgSmsFacadeService.modifySmsReadDttm(vo);
        }
        model.addAttribute("detail", detail);
        model.addAttribute("vo", vo);

        return "msg/adm_msg_sms_rcvn_select_view";
    }

    /*****************************************************
     * 관리자 문자 발신 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_sms_sndng_select_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsSndngSelectView.do")
    public String admMsgSmsSndngSelectView(MsgSmsVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        addEncParam("msgId", vo.getMsgId());
        model.addAttribute("msgId", vo.getMsgId());

        vo.setMblSndngTycd(CHNL_SMS);
        vo.setSndngrId(userCtx.getUserId());
        MsgSmsVO detail = msgSmsFacadeService.selectSmsSndngDtl(vo);

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

        return "msg/adm_msg_sms_sndng_select_view";
    }

    /*****************************************************
     * 관리자 문자 발신 등록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_sms_sndng_regist_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsSndngRegistView.do")
    public String admMsgSmsSndngRegistView(MsgSmsVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        delEncParam("msgId");
        vo.setMsgId(null);
        prepareSndngCommonModel(vo, userCtx, model);
        return "msg/adm_msg_sms_sndng_regist_view";
    }

    /*****************************************************
     * 관리자 문자 수정 화면 (예약 대기건)
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_sms_sndng_modify_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsSndngModifyView.do")
    public String admMsgSmsSndngModifyView(MsgSmsVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        if (StringUtil.isNull(vo.getMsgId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        addEncParam("msgId", vo.getMsgId());
        prepareSndngCommonModel(vo, userCtx, model);
        prepareEditModeModel(vo, userCtx, model);
        return "msg/adm_msg_sms_sndng_modify_view";
    }

    /*****************************************************
     * 문자 수신 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSmsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsRcvnListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSmsVO> msgSmsRcvnListAjax(MsgSmsVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgSmsVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_SMS);
        vo.setRcvrId(userCtx.getUserId());

        resultVO = msgSmsFacadeService.selectSmsRcvnListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 문자 발신 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSmsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsSndngListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSmsVO> msgSmsSndngListAjax(MsgSmsVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgSmsVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_SMS);
        vo.setSndngrId(userCtx.getUserId());

        resultVO = msgSmsFacadeService.selectSmsSndngListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 문자 발신 수신자 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSmsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsSndngRcvrListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSmsVO> msgSmsSndngRcvrListAjax(MsgSmsVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgSmsVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_SMS);

        resultVO = msgSmsFacadeService.selectSmsSndngRcvrListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 문자 발신 등록 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsSndngRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSmsVO> msgSmsSndngRegistAjax(MsgSmsVO vo, @CurrentUser UserContext userCtx) throws Exception {
        normalizeChnl(vo);
        vo.setRgtrId(userCtx.getUserId());
        vo.setSndngrId(userCtx.getUserId());
        vo.setOrgId(userCtx.getOrgId());

        ProcessResultVO<MsgSmsVO> resultVO = msgSmsFacadeService.registSmsSndng(vo);
        if (!StringUtil.isNull(vo.getRsrvSndngSdttm()) && StringUtil.isNull(resultVO.getMessage())) {
            resultVO.setMessage(getMessage("msg.sms.msg.rsrvSndng"));
        }
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 문자 발신 수정 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsSndngModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSmsVO> msgSmsSndngModifyAjax(MsgSmsVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgSmsVO> resultVO = new ProcessResultVO<>();

        normalizeChnl(vo);
        vo.setMdfrId(userCtx.getUserId());
        vo.setSndngrId(userCtx.getUserId());

        msgSmsFacadeService.modifySmsSndng(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 문자 예약 취소 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsRsrvCnclModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSmsVO> msgSmsRsrvCnclModifyAjax(MsgSmsVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgSmsVO> resultVO = new ProcessResultVO<>();

        String userId = userCtx.getUserId();
        vo.setMblSndngTycd(CHNL_SMS);
        vo.setMdfrId(userId);
        vo.setSndngrId(userId);
        int cnclCnt = msgSmsFacadeService.modifyMsgRsrvCncl(vo);
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
     * 문자 읽음 처리 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsReadModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSmsVO> msgSmsReadModifyAjax(MsgSmsVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgSmsVO> resultVO = new ProcessResultVO<>();

        vo.setRcvrId(userCtx.getUserId());
        msgSmsFacadeService.modifySmsReadDttm(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 문자 삭제 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSmsVO> msgSmsDeleteAjax(MsgSmsVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgSmsVO> resultVO = new ProcessResultVO<>();

        String userId = userCtx.getUserId();
        vo.setMblSndngTycd(CHNL_SMS);

        if (LIST_TYPE_RCVN.equals(vo.getListType())) {
            vo.setRcvrId(userId);
            msgSmsFacadeService.modifySmsRcvrDelyn(vo);
        } else {
            vo.setSndngrId(userId);
            msgSmsFacadeService.modifySmsSndngrDelyn(vo);
        }
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 문자 발신 수신 대상자 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @RequestMapping(value = "/admMsgSmsRcvTrgtrListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSmsVO> msgSmsRcvTrgtrListAjax(MsgSmsVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgSmsVO> resultVO = new ProcessResultVO<>();

        vo.setMblSndngTycd(CHNL_SMS);
        vo.setSndngrId(userCtx.getUserId());

        List<MsgSmsVO> list = msgSmsFacadeService.selectMsgRcvTrgtrList(vo);
        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

}
