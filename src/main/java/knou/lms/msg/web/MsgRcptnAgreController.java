package knou.lms.msg.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.facade.MsgRcptnAgreFacadeService;
import knou.lms.msg.vo.MsgRcptnAgreVO;
import knou.lms.org.vo.OrgInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Controller
public class MsgRcptnAgreController extends ControllerBase {

    @Resource(name = "msgRcptnAgreFacadeService")
    private MsgRcptnAgreFacadeService msgRcptnAgreFacadeService;

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
     * ADM 또는 PROF 권한 체크
     */
    private boolean checkAdmProfAuth(ProcessResultVO<?> resultVO, HttpServletRequest request) {
        String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        if (!authrtGrpcd.contains("ADM") && !authrtGrpcd.contains("PROF")) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return false;
        }
        return true;
    }

    /**
     * 교수 전용 검색 조건 적용 (profId만 설정)
     */
    private void applyProfFilter(MsgRcptnAgreVO vo, HttpServletRequest request) {
        String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        if (authrtGrpcd.contains("PROF") && !authrtGrpcd.contains("ADM")) {
            vo.setProfId(StringUtil.nvl(SessionInfo.getUserId(request)));
        }
    }

    /**
     * 교수 전용 검색 조건 적용 (orgId + profId 설정)
     */
    private void applyProfFilterWithOrg(MsgRcptnAgreVO vo, HttpServletRequest request) {
        String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        if (authrtGrpcd.contains("PROF") && !authrtGrpcd.contains("ADM")) {
            vo.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
            vo.setProfId(StringUtil.nvl(SessionInfo.getUserId(request)));
        }
    }

    /**
     * 교수 알림수신동의현황 화면
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profMsgRcptnAgreListView.do")
    public String profMsgRcptnAgreListView(ModelMap model, HttpServletRequest request) throws Exception {
        UserContext userCtx = getUserContext(request);

        model.addAttribute("orgId", StringUtil.nvl(userCtx.getOrgId()));
        model.addAttribute("pageSize", PAGE_SIZE);

        return "msg2/prof_msg_rcptn_agre_list";
    }

    /**
     * 관리자 알림수신동의현황 화면
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mngrMsgRcptnAgreListView.do")
    public String mngrMsgRcptnAgreListView(ModelMap model, HttpServletRequest request) throws Exception {
        UserContext userCtx = getUserContext(request);

        if (!isAdmin(userCtx)) {
            model.addAttribute("message", getCommonNoAuthMessage());
            return "common/error";
        }

        model.addAttribute("orgId", StringUtil.nvl(userCtx.getOrgId()));
        model.addAttribute("pageSize", PAGE_SIZE);

        return "msg2/mngr_msg_rcptn_agre_list";
    }

    /**
     * 기관 목록 AJAX 조회
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgRcptnAgreOrgListAjax.do")
    @ResponseBody
    public ProcessResultVO<OrgInfoVO> msgRcptnAgreOrgListAjax(HttpServletRequest request) throws Exception {
        ProcessResultVO<OrgInfoVO> resultVO = new ProcessResultVO<>();

        try {
            String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
            if (!authrtGrpcd.contains("ADM")) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            List<OrgInfoVO> list = msgRcptnAgreFacadeService.selectActiveOrgList();
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 알림수신동의 목록 AJAX 조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgRcptnAgreListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgRcptnAgreVO> msgRcptnAgreListAjax(MsgRcptnAgreVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgRcptnAgreVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            vo.setListScale(vo.getListScale() > 0 ? vo.getListScale() : PAGE_SIZE);
            applyProfFilterWithOrg(vo, request);

            resultVO = msgRcptnAgreFacadeService.selectRcptnAgreListPage(vo);
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
    @RequestMapping(value = "/msgRcptnAgreYrListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgRcptnAgreVO> msgRcptnAgreYrListAjax(MsgRcptnAgreVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgRcptnAgreVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applyProfFilter(vo, request);

            List<MsgRcptnAgreVO> list = msgRcptnAgreFacadeService.selectRcptnAgreYrList(vo);
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
    @RequestMapping(value = "/msgRcptnAgreSmstrListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> msgRcptnAgreSmstrListAjax(MsgRcptnAgreVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applyProfFilter(vo, request);

            List<EgovMap> list = msgRcptnAgreFacadeService.selectRcptnAgreSmstrList(vo);
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
    @RequestMapping(value = "/msgRcptnAgreDeptListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgRcptnAgreVO> msgRcptnAgreDeptListAjax(MsgRcptnAgreVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgRcptnAgreVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applyProfFilter(vo, request);

            List<MsgRcptnAgreVO> list = msgRcptnAgreFacadeService.selectRcptnAgreDeptList(vo);
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
    @RequestMapping(value = "/msgRcptnAgreSbjctListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgRcptnAgreVO> msgRcptnAgreSbjctListAjax(MsgRcptnAgreVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgRcptnAgreVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applyProfFilter(vo, request);

            List<MsgRcptnAgreVO> list = msgRcptnAgreFacadeService.selectRcptnAgreSbjctList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 알림수신동의 엑셀 다운로드 AJAX 조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgRcptnAgreExcelAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgRcptnAgreVO> msgRcptnAgreExcelAjax(MsgRcptnAgreVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgRcptnAgreVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applyProfFilterWithOrg(vo, request);

            List<MsgRcptnAgreVO> list = msgRcptnAgreFacadeService.selectRcptnAgreExcelList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 알림수신동의현황 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgRcptnAgreExcelDown.do")
    public String msgRcptnAgreExcelDown(MsgRcptnAgreVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        if (!authrtGrpcd.contains("ADM") && !authrtGrpcd.contains("PROF")) {
            throw new BadRequestUrlException(getCommonNoAuthMessage());
        }

        applyProfFilterWithOrg(vo, request);

        List<MsgRcptnAgreVO> list = msgRcptnAgreFacadeService.selectRcptnAgreExcelList(vo);

        String title = getMessage("msg.rcptnAgre.label.title");
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
}
