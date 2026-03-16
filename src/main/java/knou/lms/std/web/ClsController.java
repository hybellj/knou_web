package knou.lms.std.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.ExcelUtilPoi;
import knou.lms.std.service.ClsService;
import knou.lms.std.vo.*;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;
import org.apache.commons.collections.map.ListOrderedMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;


/**
 * 전체수업현황 Controller
 * 화면ID : KNOU_MN_B0102060101, KNOU_MN_B0102060102
 */
@Controller
@RequestMapping(value = "/cls")
public class ClsController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(ClsController.class);

    @Resource(name = "clsService")
    private ClsService clsService;

    @Resource(name = "termService")
    private TermService termService;

    @Resource(name = "usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;

    /*****************************************************
     * B0102060101 - 전체수업현황 목록 화면
     ******************************************************/
    @RequestMapping(value = "/selectClsListView.do")
    public String selectClsListView(ClsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String sessionOrgId = SessionInfo.getOrgId(request);

        model.addAttribute("orgId", sessionOrgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        vo.setOrgId(sessionOrgId);

        if ((vo.getSearchYr() == null || vo.getSearchYr().isEmpty())
                || (vo.getSearchSmstr() == null || vo.getSearchSmstr().isEmpty())) {
            TermVO termVO = new TermVO();
            termVO.setOrgId(sessionOrgId);
            termVO = termService.selectCurrentTerm(termVO);

            if (termVO != null) {
                if (vo.getSearchYr() == null || vo.getSearchYr().isEmpty()) {
                    vo.setSearchYr(termVO.getHaksaYear());
                }
                if (vo.getSearchSmstr() == null || vo.getSearchSmstr().isEmpty()) {
                    String haksaTerm = termVO.getHaksaTerm();
                    if ("20".equals(haksaTerm) || "21".equals(haksaTerm) || "2".equals(haksaTerm)) {
                        vo.setSearchSmstr("2");
                    } else {
                        vo.setSearchSmstr("1");
                    }
                }
            }
        }

        if (vo.getSearchYr() == null || vo.getSearchYr().isEmpty()) {
            vo.setSearchYr(String.valueOf(java.time.Year.now().getValue()));
        }
        if (vo.getSearchSmstr() == null || vo.getSearchSmstr().isEmpty()) {
            vo.setSearchSmstr("1");
        }

        if (vo.getPageIndex() < 1) vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(20);
        if (vo.getPageScale() <= 0) vo.setPageScale(10);
        int firstIndex = (vo.getPageIndex() - 1) * vo.getListScale();
        vo.setFirstIndex(firstIndex);
        vo.setLastIndex(firstIndex + vo.getListScale());

        ProcessResultVO<ClsVO> resultVO = clsService.selectClsListPaging(vo);

        UsrDeptCdVO deptVO = new UsrDeptCdVO();
        deptVO.setOrgId(sessionOrgId);

        model.addAttribute("deptList", usrDeptCdService.list(deptVO));
        model.addAttribute("subjectList", clsService.selectClsSubjectList(vo));
        model.addAttribute("resultList", resultVO.getReturnList());
        model.addAttribute("pageInfo", resultVO.getPageInfo());
        model.addAttribute("vo", vo);

        return "std/cls_list";
    }

    /*****************************************************
     * B0102060101 - 전체수업현황 목록 조회 (Ajax, 페이징)
     ******************************************************/
    @RequestMapping(value = "/selectClsListPaging.do")
    @ResponseBody
    public ProcessResultVO<ClsVO> selectClsListPaging(ClsVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        if (vo.getSearchYr() == null || vo.getSearchYr().isEmpty()) {
            vo.setSearchYr(String.valueOf(java.time.Year.now().getValue()));
        }
        if (vo.getSearchSmstr() == null || vo.getSearchSmstr().isEmpty()) {
            vo.setSearchSmstr("1");
        }

        if (vo.getPageIndex() < 1) vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(20);
        if (vo.getPageScale() <= 0) vo.setPageScale(10);
        int firstIndex = (vo.getPageIndex() - 1) * vo.getListScale();
        vo.setFirstIndex(firstIndex);
        vo.setLastIndex(firstIndex + vo.getListScale());

        LOGGER.debug("[CLS_PAGING] yr={}, smstr={}, deptId={}, kw={}, pageIndex={}, firstIndex={}, orgId={}",
                vo.getSearchYr(), vo.getSearchSmstr(), vo.getDeptId(), vo.getSearchKeyword(),
                vo.getPageIndex(), vo.getFirstIndex(), vo.getOrgId());

        try {
            resultVO = clsService.selectClsListPaging(vo);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectClsListPaging] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }

        return resultVO;
    }

    @RequestMapping(value = "/selectClsSubjectList.do")
    @ResponseBody
    public ProcessResultVO<ClsVO> selectClsSubjectList(ClsVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<ClsVO> resultVO = new ProcessResultVO<>();
        try {
            vo.setOrgId(SessionInfo.getOrgId(request));
            resultVO.setReturnList(clsService.selectClsSubjectList(vo));
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectClsSubjectList] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * B0102060101 - 과목 상세 단건 조회 (Ajax)
     ******************************************************/
    @RequestMapping(value = "/selectClsDetail.do")
    @ResponseBody
    public ProcessResultVO<ClsVO> selectClsDetail(ClsVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            ClsVO result = clsService.selectClsDetail(vo);
            resultVO.setReturnVO(result);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectClsDetail] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * B0102060102 - 수강생 주차별 학습현황 화면
     ******************************************************/
    @RequestMapping(value = "/selectClsStdntListView.do")
    public String selectClsStdntListView(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String sessionOrgId = SessionInfo.getOrgId(request);

        model.addAttribute("orgId", sessionOrgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        model.addAttribute("sbjctId", vo.getSbjctId());
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));

        return "std/cls_weekly";
    }

    /*****************************************************
     * B0102060102 - 수강생 주차별 학습현황 목록 조회 (Ajax, 페이징)
     ******************************************************/
    @RequestMapping(value = "/selectClsStdntListPaging.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectClsStdntListPaging(ClsStdntVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsStdntVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        if (vo.getPageIndex() < 1) vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(20);
        if (vo.getPageScale() <= 0) vo.setPageScale(10);

        try {
            // wkList 세팅은 ServiceImpl의 setDefaultWkList()에서 처리
            resultVO = clsService.selectClsStdntListPaging(vo);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectClsStdntListPaging] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * B0102060102 - 주차별 미학습자 비율 조회 (Ajax)
     ******************************************************/
    @RequestMapping(value = "/selectClsWklyStats.do")
    @ResponseBody
    public ProcessResultVO<ClsWklyStatsVO> selectClsWklyStats(ClsVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsWklyStatsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            List<ClsWklyStatsVO> list = clsService.selectClsWklyStats(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectClsWklyStats] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * B0102060102 - 특정 주차 미학습자 목록 조회 (Ajax)
     ******************************************************/
    @RequestMapping(value = "/selectClsNoStudyWeek.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectClsNoStudyWeek(ClsStdntVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsStdntVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            List<ClsStdntVO> list = clsService.selectClsNoStudyWeek(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectClsNoStudyWeek] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * 특정 주차 미학습자 팝업 화면을 조회한다.
     ******************************************************/
    @RequestMapping(value = "/selectNotLrnnPopupView.do")
    public String selectNotLrnnPopupView(ClsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("sbjctId", request.getParameter("sbjctId"));
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        model.addAttribute("wkNo", request.getParameter("wkNo"));
        return "std/popup/cls_notlrnn_popup";
    }

    /*****************************************************
     * 수강생 주차별 학습현황 팝업 화면을 조회한다.
     ******************************************************/
    @RequestMapping(value = "/selectStdntWkPopupView.do")
    public String selectStdntWkPopupView(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("sbjctId", request.getParameter("sbjctId"));
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        model.addAttribute("userId", request.getParameter("userId"));
        model.addAttribute("wkNo", request.getParameter("wkNo"));
        return "std/popup/cls_stdnt_weekly_popup";
    }

    /*****************************************************
     * 학습요소 제출/참여현황 팝업 화면을 조회한다.
     ******************************************************/
    @RequestMapping(value = "/selectStdntElemPopupView.do")
    public String selectStdntElemPopupView(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("sbjctId", request.getParameter("sbjctId"));
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        model.addAttribute("userId", request.getParameter("userId"));
        return "std/popup/cls_stdnt_element_popup";
    }

    /*****************************************************
     * B0102060102 - 수강생 주차별 학습현황 엑셀 다운로드
     ******************************************************/
    @RequestMapping(value = "/selectClsStdntListExcelDown.do")
    public String downExcelClsStdntList(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        vo.setOrgId(SessionInfo.getOrgId(request));

        // 엑셀 다운로드 시에도 wkList 반드시 세팅 (ServiceImpl을 거치지 않고 직접 호출하는 경우 대비)
        String wkNoParam = request.getParameter("wkNo");
        if (wkNoParam != null && !wkNoParam.trim().isEmpty()) {
            try {
                int parsedWkNo = Integer.parseInt(wkNoParam.trim());
                vo.setWkNo(parsedWkNo);
            } catch (Exception ignore) {}
        }
        if (vo.getWkList() == null || vo.getWkList().isEmpty()) {
            vo.setWkList(IntStream.rangeClosed(1, 15)
                    .boxed()
                    .collect(Collectors.toList()));
        }

        List<ClsStdntVO> list;
        if (vo.getWkNo() > 0) {
            // 특정 주차 미학습자 (wkList 불필요)
            list = clsService.selectClsNoStudyWeek(vo);
        } else {
            // 전체 수강생 주차별 (wkList 필요 → 이미 세팅됨)
            list = clsService.selectClsStdntList(vo);
        }

        String title = "주차별 학습현황";
        if (vo.getWkNo() > 0) {
            title = vo.getWkNo() + "주차 미학습자";
        }

        List<ListOrderedMap> newList = new ArrayList<>();
        for (ClsStdntVO item : list) {
            ListOrderedMap orderedMap = new ListOrderedMap();
            orderedMap.put("lineNo",   item.getLineNo());
            orderedMap.put("deptnm",   item.getDeptnm());
            orderedMap.put("stdntNo",  item.getStdntNo());
            orderedMap.put("usernm",   item.getUsernm());
            orderedMap.put("entyR",    item.getEntyR());
            orderedMap.put("scyr",     item.getScyr());
            orderedMap.put("wk1Sts",   item.getWk1Sts());
            orderedMap.put("wk2Sts",   item.getWk2Sts());
            orderedMap.put("wk3Sts",   item.getWk3Sts());
            orderedMap.put("wk4Sts",   item.getWk4Sts());
            orderedMap.put("wk5Sts",   item.getWk5Sts());
            orderedMap.put("wk6Sts",   item.getWk6Sts());
            orderedMap.put("wk7Sts",   item.getWk7Sts());
            orderedMap.put("wk8Sts",   item.getWk8Sts());
            orderedMap.put("wk9Sts",   item.getWk9Sts());
            orderedMap.put("wk10Sts",  item.getWk10Sts());
            orderedMap.put("wk11Sts",  item.getWk11Sts());
            orderedMap.put("wk12Sts",  item.getWk12Sts());
            orderedMap.put("wk13Sts",  item.getWk13Sts());
            orderedMap.put("wk14Sts",  item.getWk14Sts());
            orderedMap.put("wk15Sts",  item.getWk15Sts());
            orderedMap.put("atndCnt",  item.getAtndCnt());
            orderedMap.put("lateCnt",  item.getLateCnt());
            orderedMap.put("absnCnt",  item.getAbsnCnt());
            newList.add(orderedMap);
        }

        HashMap<String, Object> map = new HashMap<>();
        map.put("title",     title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list",      newList);
        map.put("ext",       ".xlsx(big)");

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String currentDate = sdf.format(new Date());

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + currentDate);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 학습요소 참여현황 목록 조회 (Ajax)
     ******************************************************/
    @RequestMapping(value = "/selectClsElemStats.do")
    @ResponseBody
    public ProcessResultVO<ClsElemStatsVO> selectClsElemStats(ClsElemStatsVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsElemStatsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            List<ClsElemStatsVO> list = clsService.selectClsElemStatsList(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectClsElemStats] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * 학습요소 참여현황 엑셀 다운로드
     ******************************************************/
    @RequestMapping(value = "/selectClsElemStatsExcelDown.do")
    public String selectClsElemStatsExcelDown(ClsElemStatsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            LOGGER.debug("[ElemExcel] sbjctId={}, keyword={}, orgId={}, excelGridLen={}",
                    vo.getSbjctId(),
                    vo.getKeyword(),
                    vo.getOrgId(),
                    (vo.getExcelGrid() == null ? 0 : vo.getExcelGrid().length())
            );

            // excelGrid 없으면 기본값 주입
            if (vo.getExcelGrid() == null || vo.getExcelGrid().trim().isEmpty()) {
                String defaultGrid =
                        "{\"colModel\":["
                                + "{\"label\":\"No\",\"name\":\"lineNo\",\"align\":\"center\",\"width\":\"3000\"},"
                                + "{\"label\":\"학과\",\"name\":\"deptnm\",\"align\":\"center\",\"width\":\"7000\"},"
                                + "{\"label\":\"학번\",\"name\":\"stdntNo\",\"align\":\"center\",\"width\":\"7000\"},"
                                + "{\"label\":\"이름\",\"name\":\"usernm\",\"align\":\"center\",\"width\":\"6000\"},"
                                + "{\"label\":\"Q&A(답변/등록)\",\"name\":\"qaText\",\"align\":\"center\",\"width\":\"6000\"},"
                                + "{\"label\":\"토론방(댓글수)\",\"name\":\"talkReplyCnt\",\"align\":\"center\",\"width\":\"4000\"},"
                                + "{\"label\":\"과제(제출/전체)\",\"name\":\"asmtText\",\"align\":\"center\",\"width\":\"6000\"},"
                                + "{\"label\":\"퀴즈(제출/전체)\",\"name\":\"quizText\",\"align\":\"center\",\"width\":\"6000\"},"
                                + "{\"label\":\"설문(제출/전체)\",\"name\":\"srvyText\",\"align\":\"center\",\"width\":\"6000\"},"
                                + "{\"label\":\"토론(제출/전체)\",\"name\":\"dsccText\",\"align\":\"center\",\"width\":\"6000\"},"
                                + "{\"label\":\"중간고사\",\"name\":\"midScore\",\"align\":\"center\",\"width\":\"4000\"},"
                                + "{\"label\":\"기말고사\",\"name\":\"finalScore\",\"align\":\"center\",\"width\":\"4000\"}"
                                + "]}";
                vo.setExcelGrid(defaultGrid);
            }

            List<ClsElemStatsVO> list = clsService.selectClsElemStatsListExcelDown(vo);

            String title = "학습요소참여현황";
            List<ListOrderedMap> newList = new ArrayList<>();

            for (ClsElemStatsVO item : list) {
                ListOrderedMap orderedMap = new ListOrderedMap();
                orderedMap.put("lineNo",       item.getLineNo());
                orderedMap.put("deptnm",       item.getDeptnm());
                orderedMap.put("stdntNo",      item.getStdntNo());
                orderedMap.put("usernm",       item.getUsernm());
                orderedMap.put("qaText",       item.getQaAnsCnt() + "/" + item.getQaRegCnt());
                orderedMap.put("talkReplyCnt", item.getTalkReplyCnt());
                orderedMap.put("asmtText",     item.getAsmtSbmsnCnt() + "/" + item.getAsmtTrgtCnt());
                orderedMap.put("quizText",     item.getQuizSbmsnCnt() + "/" + item.getQuizTrgtCnt());
                orderedMap.put("srvyText",     item.getSrvySbmsnCnt() + "/" + item.getSrvyTrgtCnt());
                orderedMap.put("dsccText",     item.getDsccSbmsnCnt() + "/" + item.getDsccTrgtCnt());
                orderedMap.put("midScore",     item.getMidScore());
                orderedMap.put("finalScore",   item.getFinalScore());
                newList.add(orderedMap);
            }

            HashMap<String, Object> map = new HashMap<>();
            map.put("title",     title);
            map.put("sheetName", title);
            map.put("excelGrid", vo.getExcelGrid());
            map.put("list",      newList);
            map.put("ext",       ".xlsx(big)");

            String currentDate = new SimpleDateFormat("yyyyMMdd").format(new Date());

            HashMap<String, Object> modelMap = new HashMap<>();
            modelMap.put("outFileName", title + "_" + currentDate);

            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

            model.addAllAttributes(modelMap);
            return "excelView";

        } catch (Exception e) {
            LOGGER.error("[ElemExcel] 엑셀 생성 실패", e);
            throw e;
        }
    }
    // ================================================================
    // 아래 메서드들을 기존 ClsController.java 에 추가하세요
    // ================================================================

    /*****************************************************
     * 수강생 상세정보 단건 조회 (Ajax)
     * 팝업: cls_stdnt_weekly_popup.jsp
     ******************************************************/
    @RequestMapping(value = "/selectClsStdntInfo.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntInfoVO> selectClsStdntInfo(ClsStdntInfoVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsStdntInfoVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            ClsStdntInfoVO result = clsService.selectClsStdntInfo(vo);
            resultVO.setReturnVO(result);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectClsStdntInfo] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * 강의실 접속현황 일별 차트 데이터 조회 (Ajax)
     * 팝업: cls_stdnt_weekly_popup.jsp
     ******************************************************/
    @RequestMapping(value = "/selectStdntAccessChart.do")
    @ResponseBody
    public ProcessResultVO<ClsAccessChartVO> selectStdntAccessChart(ClsAccessChartVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsAccessChartVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        // 조회 년월 기본값: 현재 년월
        if (vo.getYyyymm() == null || vo.getYyyymm().isEmpty()) {
            vo.setYyyymm(new SimpleDateFormat("yyyyMM").format(new Date()));
        }

        try {
            List<ClsAccessChartVO> list = clsService.selectStdntAccessChart(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectStdntAccessChart] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * 강의실 활동기록 목록 조회 (Ajax, 페이징)
     * 팝업: cls_stdnt_weekly_popup.jsp
     ******************************************************/
    @RequestMapping(value = "/selectStdntActivityLog.do")
    @ResponseBody
    public ProcessResultVO<ClsActivityLogVO> selectStdntActivityLog(ClsActivityLogVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsActivityLogVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        if (vo.getPageIndex() < 1)   vo.setPageIndex(1);
        if (vo.getListScale() <= 0)  vo.setListScale(10);
        if (vo.getPageScale() <= 0)  vo.setPageScale(10);

        try {
            resultVO = clsService.selectStdntActivityLogPaging(vo);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectStdntActivityLog] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * 강의실 활동기록 엑셀 다운로드
     * 팝업: cls_stdnt_weekly_popup.jsp
     ******************************************************/
    @RequestMapping(value = "/selectStdntActivityLogExcelDown.do")
    public String selectStdntActivityLogExcelDown(ClsActivityLogVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        vo.setOrgId(SessionInfo.getOrgId(request));

        if (vo.getExcelGrid() == null || vo.getExcelGrid().trim().isEmpty()) {
            String defaultGrid =
                    "{\"colModel\":["
                            + "{\"label\":\"No\",         \"name\":\"lineNo\",   \"align\":\"center\",\"width\":\"3000\"},"
                            + "{\"label\":\"일시\",        \"name\":\"actDttm\",  \"align\":\"center\",\"width\":\"8000\"},"
                            + "{\"label\":\"활동 내용\",   \"name\":\"actConts\", \"align\":\"left\",  \"width\":\"8000\"},"
                            + "{\"label\":\"접근 장비\",   \"name\":\"deviceNm\", \"align\":\"center\",\"width\":\"5000\"},"
                            + "{\"label\":\"IP\",          \"name\":\"ipAddr\",   \"align\":\"center\",\"width\":\"6000\"}"
                            + "]}";
            vo.setExcelGrid(defaultGrid);
        }

        List<ClsActivityLogVO> list = clsService.selectStdntActivityLogList(vo);

        String title = "강의실활동기록";
        List<ListOrderedMap> newList = new ArrayList<>();
        for (ClsActivityLogVO item : list) {
            ListOrderedMap om = new ListOrderedMap();
            om.put("lineNo",   item.getLineNo());
            om.put("actDttm",  item.getActDttm());
            om.put("actConts", item.getActConts());
            om.put("deviceNm", item.getDeviceNm());
            om.put("ipAddr",   item.getIpAddr());
            newList.add(om);
        }

        HashMap<String, Object> map = new HashMap<>();
        map.put("title",     title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list",      newList);
        map.put("ext",       ".xlsx(big)");

        String currentDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + currentDate);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

        model.addAllAttributes(modelMap);
        return "excelView";
    }

    /*****************************************************
     * 학습자 주차별 학습현황 팝업 View
     * URL: /cls/selectStdntWkDetailPopupView.do
     ******************************************************/
    @RequestMapping(value = "/selectStdntWkDetailPopupView.do")
    public String selectStdntWkDetailPopupView(ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("sbjctId",  request.getParameter("sbjctId"));
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        model.addAttribute("userId",   request.getParameter("userId"));
        model.addAttribute("wkNo",     request.getParameter("wkNo"));
        return "std/popup/cls_stdnt_wk_detail_popup";
    }

    /*****************************************************
     * 주차 학습 요약 + 차시 목록 + 3분 로그 조회 (Ajax)
     * URL: /cls/selectStdntWkLrnSummary.do
     ******************************************************/
    @RequestMapping(value = "/selectStdntWkLrnSummary.do")
    @ResponseBody
    public ProcessResultVO<ClsWkLrnVO> selectStdntWkLrnSummary(ClsWkLrnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<ClsWkLrnVO> resultVO = new ProcessResultVO<>();
        vo.setOrgId(SessionInfo.getOrgId(request));
        try {
            ClsWkLrnVO result = clsService.selectStdntWkLrnSummary(vo);

            // 차시 목록 조회
            List<ClsChsiLrnVO> chsiList = clsService.selectStdntChsiLrnList(vo);

            // 각 차시별 3분 로그 조회 후 세팅
            if (chsiList != null) {
                for (ClsChsiLrnVO chsi : chsiList) {
                    ClsLrnLogVO logParam = new ClsLrnLogVO();
                    logParam.setChsiSchdlId(chsi.getChsiSchdlId());
                    logParam.setUserId(vo.getUserId());
                    List<ClsLrnLogVO> logs = clsService.selectStdntLrnLog(logParam);
                    chsi.setLogList(logs);
                }
            }
            if (result != null) {
                result.setChsiList(chsiList);
            }
            resultVO.setReturnVO(result);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectStdntWkLrnSummary] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * 출석 처리 (Ajax)
     * URL: /cls/updateAtndlcProcess.do
     ******************************************************/
    @RequestMapping(value = "/updateAtndlcProcess.do")
    @ResponseBody
    public ProcessResultVO<Object> updateAtndlcProcess(ClsWkLrnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Object> resultVO = new ProcessResultVO<>();
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setRgtrId(SessionInfo.getUserId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));
        try {
            int cnt = clsService.updateAtndlcProcess(vo);
            if (cnt > 0) {
                resultVO.setResultSuccess();
                resultVO.setMessage("출석 처리가 완료되었습니다.");
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage("출석 처리에 실패하였습니다.");
            }
        } catch (Exception e) {
            LOGGER.error("[updateAtndlcProcess] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * 출석 처리 취소 (Ajax)
     * URL: /cls/updateAtndlcCancel.do
     ******************************************************/
    @RequestMapping(value = "/updateAtndlcCancel.do")
    @ResponseBody
    public ProcessResultVO<Object> updateAtndlcCancel(ClsWkLrnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Object> resultVO = new ProcessResultVO<>();
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));  // 수정자
        try {
            int cnt = clsService.updateAtndlcCancel(vo);
            if (cnt > 0) {
                resultVO.setResultSuccess();
                resultVO.setMessage("출석 처리가 취소되었습니다.");
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage("출석 처리 취소에 실패하였습니다.");
            }
        } catch (Exception e) {
            LOGGER.error("[updateAtndlcCancel] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * 학습자 학습요소 참여현황 제출 목록 조회 (Ajax)
     * URL: /cls/selectStdntElemSbmsnList.do
     ******************************************************/
    @RequestMapping(value = "/selectStdntElemSbmsnList.do")
    @ResponseBody
    public ProcessResultVO<ClsChsiLrnVO> selectStdntElemSbmsnList(ClsWkLrnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<ClsChsiLrnVO> resultVO = new ProcessResultVO<>();
        vo.setOrgId(SessionInfo.getOrgId(request));
        try {
            List<ClsChsiLrnVO> list = clsService.selectStdntElemSbmsnList(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectStdntElemSbmsnList] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * 과제 제출기록 조회 (Ajax)
     * URL: /cls/selectStdntAsmtSbmsnLog.do
     * 호출처: cls_stdnt_element_popup.jsp → loadSbmsnLog()
     ******************************************************/
    @RequestMapping(value = "/selectStdntElemSbmsnLog.do")
    @ResponseBody
    public ProcessResultVO<ClsAsmtSbmsnLogVO> selectStdntElemSbmsnLog(
            ClsAsmtSbmsnLogVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsAsmtSbmsnLogVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            List<ClsAsmtSbmsnLogVO> list = clsService.selectStdntElemSbmsnLog(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectStdntElemSbmsnLog] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }
}
