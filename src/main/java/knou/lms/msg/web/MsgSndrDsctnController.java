package knou.lms.msg.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgSndrDsctnService;
import knou.lms.msg.vo.MsgSndrDsctnVO;

@Controller
public class MsgSndrDsctnController extends ControllerBase {

    @Resource(name = "msgSndrDsctnService")
    private MsgSndrDsctnService msgSndrDsctnService;

    private static final int PAGE_SIZE = 10;

    private UserContext getUserContext(HttpServletRequest request) {
        return new UserContext(
                SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));
    }

    private boolean isAdmin(UserContext userCtx) {
        String authrtGrpcd = userCtx.getAuthrtGrpcd();
        return authrtGrpcd != null && authrtGrpcd.contains("ADM");
    }

    /**
     * 교수 발송내역관리 화면
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profMsgSndrDsctnListView.do")
    public String profMsgSndrDsctnListView(ModelMap model, HttpServletRequest request) throws Exception {
        UserContext userCtx = getUserContext(request);

        model.addAttribute("orgId", StringUtil.nvl(userCtx.getOrgId()));
        model.addAttribute("pageSize", PAGE_SIZE);

        return "msg2/prof_msg_sndr_dsctn_list_view";
    }

    /**
     * 관리자 발송내역관리 화면
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mngrMsgSndrDsctnListView.do")
    public String mngrMsgSndrDsctnListView(ModelMap model, HttpServletRequest request) throws Exception {
        UserContext userCtx = getUserContext(request);

        if (!isAdmin(userCtx)) {
            model.addAttribute("message", getCommonNoAuthMessage());
            return "common/error";
        }

        model.addAttribute("orgId", StringUtil.nvl(userCtx.getOrgId()));
        model.addAttribute("pageSize", PAGE_SIZE);

        return "msg2/mngr_msg_sndr_dsctn_list_view";
    }

    /**
     * 발송내역 목록 AJAX 조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgSndrDsctnMngListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnMngListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
            if (!authrtGrpcd.contains("ADM") && !authrtGrpcd.contains("PROF")) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
            vo.setListScale(vo.getListScale() > 0 ? vo.getListScale() : PAGE_SIZE);

            if (authrtGrpcd.contains("PROF") && !authrtGrpcd.contains("ADM")) {
                vo.setUserId(StringUtil.nvl(SessionInfo.getUserId(request)));
            }

            resultVO = msgSndrDsctnService.selectSndrDsctnListPage(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 발송내역 채널별 요약 AJAX 조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgSndrDsctnMngSummaryAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnMngSummaryAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
            if (!authrtGrpcd.contains("ADM") && !authrtGrpcd.contains("PROF")) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));

            if (authrtGrpcd.contains("PROF") && !authrtGrpcd.contains("ADM")) {
                vo.setUserId(StringUtil.nvl(SessionInfo.getUserId(request)));
            }

            MsgSndrDsctnVO summary = msgSndrDsctnService.selectSndrDsctnSummary(vo);
            resultVO.setReturnVO(summary);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 학사년도 목록 AJAX 조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgSndrDsctnMngYrListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnMngYrListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
            if (!authrtGrpcd.contains("ADM") && !authrtGrpcd.contains("PROF")) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));

            if (authrtGrpcd.contains("PROF") && !authrtGrpcd.contains("ADM")) {
                vo.setUserId(StringUtil.nvl(SessionInfo.getUserId(request)));
            }

            List<MsgSndrDsctnVO> list = msgSndrDsctnService.selectSndrDsctnYrList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 학기 목록 AJAX 조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgSndrDsctnMngSmstrListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> msgSndrDsctnMngSmstrListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
            if (!authrtGrpcd.contains("ADM") && !authrtGrpcd.contains("PROF")) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));

            if (authrtGrpcd.contains("PROF") && !authrtGrpcd.contains("ADM")) {
                vo.setUserId(StringUtil.nvl(SessionInfo.getUserId(request)));
            }

            List<EgovMap> list = msgSndrDsctnService.selectSndrDsctnSmstrList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 학과 목록 AJAX 조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgSndrDsctnMngDeptListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnMngDeptListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
            if (!authrtGrpcd.contains("ADM") && !authrtGrpcd.contains("PROF")) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));

            if (authrtGrpcd.contains("PROF") && !authrtGrpcd.contains("ADM")) {
                vo.setUserId(StringUtil.nvl(SessionInfo.getUserId(request)));
            }

            List<MsgSndrDsctnVO> list = msgSndrDsctnService.selectSndrDsctnDeptList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 운영과목 목록 AJAX 조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgSndrDsctnMngSbjctListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnMngSbjctListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
            if (!authrtGrpcd.contains("ADM") && !authrtGrpcd.contains("PROF")) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));

            if (authrtGrpcd.contains("PROF") && !authrtGrpcd.contains("ADM")) {
                vo.setUserId(StringUtil.nvl(SessionInfo.getUserId(request)));
            }

            List<MsgSndrDsctnVO> list = msgSndrDsctnService.selectSndrDsctnSbjctList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 발송내역 엑셀 다운로드 AJAX 조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgSndrDsctnMngExcelAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnMngExcelAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
            if (!authrtGrpcd.contains("ADM") && !authrtGrpcd.contains("PROF")) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));

            if (authrtGrpcd.contains("PROF") && !authrtGrpcd.contains("ADM")) {
                vo.setUserId(StringUtil.nvl(SessionInfo.getUserId(request)));
            }

            List<MsgSndrDsctnVO> list = msgSndrDsctnService.selectSndrDsctnExcelList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }
}
