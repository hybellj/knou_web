package knou.lms.msg.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.facade.MsgSndrDsctnFacadeService;
import knou.lms.msg.vo.MsgSndrDsctnVO;
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
import java.util.Map;

@Controller
public class MsgSndrDsctnController extends ControllerBase {

    @Resource(name = "msgSndrDsctnFacadeService")
    private MsgSndrDsctnFacadeService msgSndrDsctnFacadeService;

    private static final int PAGE_SIZE = 10;

    private boolean isAdmin(HttpServletRequest request) {
        return StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request)).contains("ADM");
    }

    private boolean isProfessor(HttpServletRequest request) {
        return StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request)).contains("PROF");
    }

    private boolean checkAdmProfAuth(ProcessResultVO<?> resultVO, HttpServletRequest request) {
        if (!isAdmin(request) && !isProfessor(request)) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return false;
        }
        return true;
    }

    private void applySearchConstraints(MsgSndrDsctnVO vo, HttpServletRequest request) {
        vo.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        if (isProfessor(request) && !isAdmin(request)) {
            vo.setUserId(StringUtil.nvl(SessionInfo.getUserId(request)));
        }
    }

    /*****************************************************
     * 교수 발송내역관리 화면
     * @param model
     * @param request
     * @return "msg2/prof_msg_sndr_dsctn_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgSndrDsctnListView.do")
    public String profMsgSndrDsctnListView(ModelMap model, HttpServletRequest request) throws Exception {
        if (!isProfessor(request) && !isAdmin(request)) {
            model.addAttribute("message", getCommonNoAuthMessage());
            return "common/error";
        }

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        model.addAttribute("orgId", orgId);
        model.addAttribute("orgnm", StringUtil.nvl(msgSndrDsctnFacadeService.selectOrgNm(orgId)));
        model.addAttribute("pageSize", PAGE_SIZE);

        return "msg2/prof_msg_sndr_dsctn_list_view";
    }

    /*****************************************************
     * 관리자 발송내역관리 화면
     * @param model
     * @param request
     * @return "msg2/mngr_msg_sndr_dsctn_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/mngrMsgSndrDsctnListView.do")
    public String mngrMsgSndrDsctnListView(ModelMap model, HttpServletRequest request) throws Exception {
        if (!isAdmin(request)) {
            model.addAttribute("message", getCommonNoAuthMessage());
            return "common/error";
        }

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        model.addAttribute("orgId", StringUtil.nvl(SessionInfo.getOrgId(request)));
        model.addAttribute("orgnm", StringUtil.nvl(msgSndrDsctnFacadeService.selectOrgNm(orgId)));
        model.addAttribute("pageSize", PAGE_SIZE);

        return "msg2/mngr_msg_sndr_dsctn_list_view";
    }

    /*****************************************************
     * 발송내역 목록 AJAX 조회
     * @param vo
     * @param request
     * @return ProcessResultVO<MsgSndrDsctnVO>
     * @throws Exception
     ******************************************************/
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

            ProcessResultVO<MsgSndrDsctnVO> pageResult = msgSndrDsctnFacadeService.selectSndrDsctnListPage(vo);
            resultVO.setReturnList(pageResult.getReturnList());
            resultVO.setPageInfo(pageResult.getPageInfo());
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 발송내역 채널별 요약 AJAX 조회
     * @param vo
     * @param request
     * @return ProcessResultVO<MsgSndrDsctnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgSndrDsctnSmryAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnSmryAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applySearchConstraints(vo, request);

            MsgSndrDsctnVO smry = msgSndrDsctnFacadeService.selectSndrDsctnSmry(vo);
            resultVO.setReturnVO(smry);
            resultVO.setReturnSubVO(msgSndrDsctnFacadeService.selectSndngCostMap());
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 학사년도 목록 AJAX 조회
     * @param vo
     * @param request
     * @return ProcessResultVO<MsgSndrDsctnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgSndrDsctnYrListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnYrListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applySearchConstraints(vo, request);

            List<MsgSndrDsctnVO> list = msgSndrDsctnFacadeService.selectSndrDsctnYrList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 학기 목록 AJAX 조회
     * @param vo
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgSndrDsctnSmstrListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> msgSndrDsctnSmstrListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applySearchConstraints(vo, request);

            List<EgovMap> list = msgSndrDsctnFacadeService.selectSndrDsctnSmstrList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 학과 목록 AJAX 조회
     * @param vo
     * @param request
     * @return ProcessResultVO<MsgSndrDsctnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgSndrDsctnDeptListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnDeptListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applySearchConstraints(vo, request);

            List<MsgSndrDsctnVO> list = msgSndrDsctnFacadeService.selectSndrDsctnDeptList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 운영과목 목록 AJAX 조회
     * @param vo
     * @param request
     * @return ProcessResultVO<MsgSndrDsctnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgSndrDsctnSbjctListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnSbjctListAjax(MsgSndrDsctnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        try {
            if (!checkAdmProfAuth(resultVO, request)) {
                return resultVO;
            }

            applySearchConstraints(vo, request);

            List<MsgSndrDsctnVO> list = msgSndrDsctnFacadeService.selectSndrDsctnSbjctList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 발송내역 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgSndrDsctnExcelDown.do")
    public String msgSndrDsctnExcelDown(MsgSndrDsctnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        if (!isAdmin(request) && !isProfessor(request)) {
            throw new BadRequestUrlException(getCommonNoAuthMessage());
        }

        applySearchConstraints(vo, request);

        List<MsgSndrDsctnVO> list = msgSndrDsctnFacadeService.selectSndrDsctnExcelList(vo);

        String title = getMessage("msg.sndrDsctn.label.title");
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 발송비용금액 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgSndrDsctnSmryExcelDown.do")
    public String msgSndrDsctnSmryExcelDown(MsgSndrDsctnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        if (!isAdmin(request) && !isProfessor(request)) {
            throw new BadRequestUrlException(getCommonNoAuthMessage());
        }

        applySearchConstraints(vo, request);

        MsgSndrDsctnVO smry = msgSndrDsctnFacadeService.selectSndrDsctnSmry(vo);

        Map<String, String> labels = new HashMap<>();
        labels.put("totalSndCnt", getMessage("msg.sndrDsctn.label.totalSndCnt"));
        labels.put("totalSuccCnt", getMessage("msg.sndrDsctn.label.totalSuccCnt"));
        labels.put("totalFailCnt", getMessage("msg.sndrDsctn.label.totalFailCnt"));
        labels.put("sndCost", getMessage("msg.sndrDsctn.label.sndCost"));

        List<Map<String, Object>> list = msgSndrDsctnFacadeService.buildSmryExcelRows(smry, labels);

        String title = getMessage("msg.sndrDsctn.label.costTitle");
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

}
