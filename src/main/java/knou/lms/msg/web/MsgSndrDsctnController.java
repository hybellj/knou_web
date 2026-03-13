package knou.lms.msg.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
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
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.ExcelUtilPoi;
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
     * 공통 검색 조건 적용 (orgId 설정 + 교수일 경우 userId 설정)
     */
    private void applySearchConstraints(MsgSndrDsctnVO vo, HttpServletRequest request) {
        vo.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        if (authrtGrpcd.contains("PROF") && !authrtGrpcd.contains("ADM")) {
            vo.setUserId(StringUtil.nvl(SessionInfo.getUserId(request)));
        }
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
    @RequestMapping(value = "/msgSndrDsctnListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            vo.setListScale(vo.getListScale() > 0 ? vo.getListScale() : PAGE_SIZE);
            applySearchConstraints(vo, request);

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
    @RequestMapping(value = "/msgSndrDsctnSmryAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnSmryAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applySearchConstraints(vo, request);

            MsgSndrDsctnVO smry = msgSndrDsctnService.selectSndrDsctnSmry(vo);
            resultVO.setReturnVO(smry);
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
    @RequestMapping(value = "/msgSndrDsctnYrListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnYrListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applySearchConstraints(vo, request);

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
    @RequestMapping(value = "/msgSndrDsctnSmstrListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> msgSndrDsctnSmstrListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applySearchConstraints(vo, request);

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
    @RequestMapping(value = "/msgSndrDsctnDeptListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnDeptListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applySearchConstraints(vo, request);

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
    @RequestMapping(value = "/msgSndrDsctnSbjctListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnSbjctListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applySearchConstraints(vo, request);

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
    @RequestMapping(value = "/msgSndrDsctnExcelAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnExcelAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applySearchConstraints(vo, request);

            List<MsgSndrDsctnVO> list = msgSndrDsctnService.selectSndrDsctnExcelList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 발송내역 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgSndrDsctnExcelDown.do")
    public String msgSndrDsctnExcelDown(MsgSndrDsctnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        if (!authrtGrpcd.contains("ADM") && !authrtGrpcd.contains("PROF")) {
            throw new BadRequestUrlException(getCommonNoAuthMessage());
        }

        applySearchConstraints(vo, request);

        List<MsgSndrDsctnVO> list = msgSndrDsctnService.selectSndrDsctnExcelList(vo);

        String title = getMessage("msg.sndrDsctn.label.title");
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

    /**
     * 발송비용금액 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgSndrDsctnSmryExcelDown.do")
    public String msgSndrDsctnSmryExcelDown(MsgSndrDsctnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        if (!authrtGrpcd.contains("ADM") && !authrtGrpcd.contains("PROF")) {
            throw new BadRequestUrlException(getCommonNoAuthMessage());
        }

        applySearchConstraints(vo, request);

        MsgSndrDsctnVO smry = msgSndrDsctnService.selectSndrDsctnSmry(vo);

        List<HashMap<String, Object>> list = new ArrayList<>();

        HashMap<String, Object> row1 = new HashMap<>();
        row1.put("sndngGbn", getMessage("msg.sndrDsctn.label.totalSndCnt"));
        row1.put("push", String.valueOf(smry.getPushTotalCnt()));
        row1.put("shrtnt", String.valueOf(smry.getShrtntTotalCnt()));
        row1.put("eml", String.valueOf(smry.getEmlTotalCnt()));
        row1.put("alimTalk", String.valueOf(smry.getAlimtalkTotalCnt()));
        row1.put("sms", String.valueOf(smry.getSmsTotalCnt()));
        row1.put("lms", String.valueOf(smry.getLmsTotalCnt()));
        list.add(row1);

        HashMap<String, Object> row2 = new HashMap<>();
        row2.put("sndngGbn", getMessage("msg.sndrDsctn.label.totalSuccCnt"));
        row2.put("push", String.valueOf(smry.getPushSuccCnt()));
        row2.put("shrtnt", String.valueOf(smry.getShrtntSuccCnt()));
        row2.put("eml", String.valueOf(smry.getEmlSuccCnt()));
        row2.put("alimTalk", String.valueOf(smry.getAlimtalkSuccCnt()));
        row2.put("sms", String.valueOf(smry.getSmsSuccCnt()));
        row2.put("lms", String.valueOf(smry.getLmsSuccCnt()));
        list.add(row2);

        HashMap<String, Object> row3 = new HashMap<>();
        row3.put("sndngGbn", getMessage("msg.sndrDsctn.label.totalFailCnt"));
        row3.put("push", String.valueOf(smry.getPushFailCnt()));
        row3.put("shrtnt", String.valueOf(smry.getShrtntFailCnt()));
        row3.put("eml", String.valueOf(smry.getEmlFailCnt()));
        row3.put("alimTalk", String.valueOf(smry.getAlimtalkFailCnt()));
        row3.put("sms", String.valueOf(smry.getSmsFailCnt()));
        row3.put("lms", String.valueOf(smry.getLmsFailCnt()));
        list.add(row3);

        String title = getMessage("msg.sndrDsctn.label.costTitle");
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
