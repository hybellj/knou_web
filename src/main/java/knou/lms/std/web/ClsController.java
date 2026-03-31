package knou.lms.std.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.ValidationUtils;
import knou.lms.std.service.ClsService;
import knou.lms.std.vo.*;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.org.service.OrgCodeService;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
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

    @Resource(name = "orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    /**
     * 전체수업현황 목록 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return std/cls_list
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsListView.do")
    public String selectClsListView(ClsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String sessionOrgId = SessionInfo.getOrgId(request);

        model.addAttribute("orgId", sessionOrgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        vo.setOrgId(sessionOrgId);

        if (vo.getSearchYr() == null || vo.getSearchYr().isEmpty()) {
            TermVO termVO = new TermVO();
            termVO.setOrgId(sessionOrgId);
            termVO = termService.selectCurrentTerm(termVO);

            if (termVO != null && termVO.getHaksaYear() != null && !termVO.getHaksaYear().isEmpty()) {
                vo.setSearchYr(termVO.getHaksaYear());
            }
        }

        if (vo.getSearchYr() == null || vo.getSearchYr().isEmpty()) {
            vo.setSearchYr(String.valueOf(java.time.Year.now().getValue()));
        }

        if (vo.getPageIndex() < 1) vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(20);
        if (vo.getPageScale() <= 0) vo.setPageScale(10);

        ProcessResultVO<ClsVO> resultVO = clsService.selectClsListPaging(vo);

        UsrDeptCdVO deptVO = new UsrDeptCdVO();
        deptVO.setOrgId(sessionOrgId);

        model.addAttribute("deptList", usrDeptCdService.list(deptVO));
        model.addAttribute("subjectList", clsService.selectClsSubjectList(vo));
        model.addAttribute("resultList", resultVO.getReturnList());
        model.addAttribute("pageInfo", resultVO.getPageInfo());
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));

        // 운영과목 기관 검색 드롭다운
        List<OrgInfoVO> orgList = orgInfoService.listActiveOrg();
        model.addAttribute("orgList", orgList);

        model.addAttribute("vo", vo);

        return "std/cls_list";
    }

    /**
     * 전체수업현황 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsListPaging.do")
    @ResponseBody
    public ProcessResultVO<ClsVO> selectClsListPaging(ClsVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        if (vo.getSearchYr() == null || vo.getSearchYr().isEmpty()) {
            vo.setSearchYr(String.valueOf(java.time.Year.now().getValue()));
        }

        if (vo.getPageIndex() < 1) vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(20);
        if (vo.getPageScale() <= 0) vo.setPageScale(10);

        try {
            resultVO = clsService.selectClsListPaging(vo);
            if (resultVO.getResult() >= 0) {
                resultVO.setResultSuccess();
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage(getCommonFailMessage());
            }
        } catch (Exception e) {
            LOGGER.error("[selectClsListPaging] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }

        return resultVO;
    }

    /**
     * 운영과목 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsVO>
     * @throws Exception
     */
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

    /**
     * 과목 상세 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsVO>
     * @throws Exception
     */
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

    /**
     * 주차별 수업현황 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return std/cls_weekly
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsStdntListView.do")
    public String selectClsStdntListView(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String sessionOrgId = SessionInfo.getOrgId(request);
        model.addAttribute("orgId", sessionOrgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("sbjctId", vo.getSbjctId());
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));

        int wkCnt = resolveWkCnt(vo.getSbjctId(), sessionOrgId);
        model.addAttribute("wkCnt", wkCnt);

        return "std/cls_weekly";
    }

    /**
     * 주차별 학습현황 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsStdntListPaging.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectClsStdntListPaging(ClsStdntVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsStdntVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        if (vo.getPageIndex() < 1) vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(20);
        if (vo.getPageScale() <= 0) vo.setPageScale(10);

        try {
            resultVO = clsService.selectClsStdntListPaging(vo);
            if (resultVO.getResult() >= 0) {
                resultVO.setResultSuccess();
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage(getCommonFailMessage());
            }
        } catch (Exception e) {
            LOGGER.error("[selectClsStdntListPaging] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }

        return resultVO;
    }

    /**
     * 주차별 학습현황 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsStdntListExcelDown.do")
    public String downExcelClsStdntList(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        vo.setOrgId(SessionInfo.getOrgId(request));
        int wkCnt = resolveWkCnt(vo.getSbjctId(), SessionInfo.getOrgId(request));

        if (vo.getWkList() == null || vo.getWkList().isEmpty()) {
            vo.setWkList(IntStream.rangeClosed(1, wkCnt).boxed().collect(Collectors.toList()));
        }

        List<ClsStdntVO> list = clsService.selectClsStdntList(vo);
        String title = "주차별 학습현황";

        List<ListOrderedMap> newList = new ArrayList<>();
        for (ClsStdntVO item : list) {
            ListOrderedMap orderedMap = new ListOrderedMap();
            orderedMap.put("lineNo", item.getLineNo());
            orderedMap.put("deptnm", item.getDeptnm());
            orderedMap.put("stdntNo", item.getStdntNo());
            orderedMap.put("usernm", item.getUsernm());
            orderedMap.put("entyR", item.getEntyR());
            orderedMap.put("scyr", item.getScyr());

            HashMap<Integer, String> wkMap = new HashMap<>();
            if (item.getWkStsList() != null) {
                for (ClsWkStsVO wkSts : item.getWkStsList()) {
                    wkMap.put(wkSts.getWkNo(), wkSts.getAtndSts());
                }
            }

            for (int w = 1; w <= wkCnt; w++) {
                String sts = wkMap.getOrDefault(w, "-");
                String stsText = "ATND".equals(sts) ? "○" : "LATE".equals(sts) ? "△" : "ABSNT".equals(sts) ? "X" : "-";
                orderedMap.put("wk" + w + "Sts", stsText);
            }
            orderedMap.put("atndCnt", item.getAtndCnt());
            orderedMap.put("lateCnt", item.getLateCnt());
            orderedMap.put("absnCnt", item.getAbsnCnt());
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
    }

    /**
     * 주차별 미학습자 비율 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsWklyStatsVO>
     * @throws Exception
     */
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

    /**
     * 주차별 미학습자 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     */
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

    /**
     * 학습요소 참여현황 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsElemStatsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsElemStats.do")
    @ResponseBody
    public ProcessResultVO<ClsElemStatsVO> selectClsElemStats(ClsElemStatsVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsElemStatsVO> resultVO = new ProcessResultVO<>();
        vo.setOrgId(SessionInfo.getOrgId(request));

        if (vo.getPageIndex() < 1)  vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(20);
        if (vo.getPageScale() <= 0) vo.setPageScale(10);

        try {
            resultVO = clsService.selectClsElemStatsListPaging(vo);
            if (resultVO.getResult() >= 0) {
                resultVO.setResultSuccess();
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage(getCommonFailMessage());
            }
        } catch (Exception e) {
            LOGGER.error("[selectClsElemStats] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 학습요소 참여현황 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsElemStatsExcelDown.do")
    public String selectClsElemStatsExcelDown(ClsElemStatsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
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
                orderedMap.put("midScore",
                        item.getMidLiveScore() != null ? item.getMidLiveScore()
                                : item.getMidAltScore() != null ? item.getMidAltScore()
                                : item.getMidEtcScore());
                orderedMap.put("finalScore",
                        item.getFinalLiveScore() != null ? item.getFinalLiveScore()
                                : item.getFinalAltScore() != null ? item.getFinalAltScore()
                                : item.getFinalEtcScore());
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
            LOGGER.error("[selectClsElemStatsExcelDown] 엑셀 생성 실패", e);
            throw e;
        }
    }

    /**
     * 미학습자 현황 팝업 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return std/popup/cls_notlrnn_popup
     * @throws Exception
     */
    @RequestMapping(value = "/selectNotLrnnPopupView.do")
    public String selectNotLrnnPopupView(ClsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("sbjctId", request.getParameter("sbjctId"));
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        model.addAttribute("wkNo", request.getParameter("wkNo"));
        return "std/popup/cls_notlrnn_popup";
    }

    /**
     * 미학습자 목록 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsNoStudyWeekExcelDown.do")
    public String downExcelClsNoStudyWeek(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        vo.setOrgId(SessionInfo.getOrgId(request));

        List<ClsStdntVO> list = clsService.selectClsNoStudyWeek(vo);

        String title = vo.getWkNo() + "주차 미학습자";

        List<ListOrderedMap> newList = new ArrayList<>();
        for (ClsStdntVO item : list) {
            ListOrderedMap orderedMap = new ListOrderedMap();
            orderedMap.put("lineNo",  item.getLineNo());
            orderedMap.put("deptnm",  item.getDeptnm());
            orderedMap.put("stdntNo", item.getStdntNo());
            orderedMap.put("usernm",  item.getUsernm());
            orderedMap.put("entyR",   item.getEntyR());
            orderedMap.put("scyr",    item.getScyr());
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
    }

    /**
     * 학습자 학습현황 팝업 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return std/popup/cls_stdnt_lrn_popup
     * @throws Exception
     */
    @RequestMapping(value = "/selectStdntWkPopupView.do")
    public String selectStdntWkPopupView(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String sbjctId = request.getParameter("sbjctId");
        int wkCnt = resolveWkCnt(sbjctId, SessionInfo.getOrgId(request));

        model.addAttribute("wkCnt", wkCnt);
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        model.addAttribute("userId", request.getParameter("userId"));
        model.addAttribute("wkNo", request.getParameter("wkNo"));

        return "std/popup/cls_stdnt_lrn_popup";
    }

    /**
     * 수강생 상세정보 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntInfoVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsStdntInfo.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntInfoVO> selectClsStdntInfo(ClsStdntInfoVO vo, HttpServletRequest request) throws
            Exception {

        ProcessResultVO<ClsStdntInfoVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

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

    /**
     * 학습자 주차별 학습현황 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsStdntWeeklyInfo.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectClsStdntWeeklyInfo(ClsStdntVO vo, HttpServletRequest request) throws
            Exception {

        ProcessResultVO<ClsStdntVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            ClsStdntVO result = clsService.selectClsStdntWeeklyInfo(vo);
            resultVO.setReturnVO(result);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectClsStdntWeeklyInfo] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }

        return resultVO;
    }

    /**
     * 강의실 접속현황 차트 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsAccessChartVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectStdntAccessChart.do")
    @ResponseBody
    public ProcessResultVO<ClsAccessChartVO> selectStdntAccessChart(ClsAccessChartVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsAccessChartVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

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

    /**
     * 강의실 활동기록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsActivityLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectStdntActivityLog.do")
    @ResponseBody
    public ProcessResultVO<ClsActivityLogVO> selectStdntActivityLog(ClsActivityLogVO vo, HttpServletRequest request)
            throws Exception {

        ProcessResultVO<ClsActivityLogVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        if (vo.getPageIndex() < 1)   vo.setPageIndex(1);
        if (vo.getListScale() <= 0)  vo.setListScale(10);
        if (vo.getPageScale() <= 0)  vo.setPageScale(10);

        try {
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            resultVO = clsService.selectStdntActivityLogPaging(vo);
            if (resultVO.getResult() >= 0) {
                resultVO.setResultSuccess();
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage(getCommonFailMessage());
            }
        } catch (Exception e) {
            LOGGER.error("[selectStdntActivityLog] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 강의실 활동기록 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/selectStdntActivityLogExcelDown.do")
    public String selectStdntActivityLogExcelDown(ClsActivityLogVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        vo.setOrgId(SessionInfo.getOrgId(request));

        validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

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

    /**
     * 학습자 주차별 학습기록 팝업 화면
     *
     * @param model
     * @param request
     * @return std/popup/cls_stdnt_week_lrn_popup
     * @throws Exception
     */
    @RequestMapping(value = "/selectStdntWkDetailPopupView.do")
    public String selectStdntWkDetailPopupView(ModelMap model, HttpServletRequest request) throws Exception {
        String sbjctId = request.getParameter("sbjctId");
        int wkCnt = resolveWkCnt(sbjctId, SessionInfo.getOrgId(request));

        model.addAttribute("wkCnt", wkCnt);
        model.addAttribute("sbjctId",  sbjctId);
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        model.addAttribute("userId",   request.getParameter("userId"));
        model.addAttribute("wkNo",     request.getParameter("wkNo"));

        return "std/popup/cls_stdnt_week_lrn_popup";
    }

    /**
     * 주차별 학습요약 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsWkLrnVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectStdntWkLrnSummary.do")
    @ResponseBody
    public ProcessResultVO<ClsWkLrnVO> selectStdntWkLrnSummary(ClsWkLrnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<ClsWkLrnVO> resultVO = new ProcessResultVO<>();
        vo.setOrgId(SessionInfo.getOrgId(request));
        try {
            validateClsWkAccess(vo, false);
            ClsWkLrnVO result = clsService.selectStdntWkLrnSummary(vo);

            List<ClsChsiLrnVO> chsiList = clsService.selectStdntChsiLrnList(vo);

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

    /**
     * 학습로그 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsLrnLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectStdntLrnLog.do")
    @ResponseBody
    public ProcessResultVO<ClsLrnLogVO> selectStdntLrnLog(ClsLrnLogVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsLrnLogVO> resultVO = new ProcessResultVO<>();
        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            ClsWkLrnVO accessVo = new ClsWkLrnVO();
            accessVo.setOrgId(SessionInfo.getOrgId(request));
            accessVo.setSbjctId(request.getParameter("sbjctId"));
            accessVo.setUserId(vo.getUserId());

            String wkNoStr = request.getParameter("wkNo");
            accessVo.setWkNo(ValidationUtils.isEmpty(wkNoStr) ? 0 : Integer.parseInt(wkNoStr));

            validateClsWkAccess(accessVo, false);

            List<ClsLrnLogVO> list = clsService.selectStdntLrnLog(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectStdntLrnLog] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 출석 처리
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<Object>
     * @throws Exception
     */
    @RequestMapping(value = "/updateAtndlcProcess.do")
    @ResponseBody
    public ProcessResultVO<Object> updateAtndlcProcess(ClsWkLrnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Object> resultVO = new ProcessResultVO<>();
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setRgtrId(SessionInfo.getUserId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));
        try {
            validateClsWkAccess(vo, true);
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

    /**
     * 출석 처리 취소
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<Object>
     * @throws Exception
     */
    @RequestMapping(value = "/updateAtndlcCancel.do")
    @ResponseBody
    public ProcessResultVO<Object> updateAtndlcCancel(ClsWkLrnVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Object> resultVO = new ProcessResultVO<>();
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));
        try {
            validateClsWkAccess(vo, true);
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

    /**
     * 학습요소 참여현황 팝업 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return std/popup/cls_stdnt_element_popup
     * @throws Exception
     */
    @RequestMapping(value = "/selectStdntElemPopupView.do")
    public String selectStdntElemPopupView(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("sbjctId", request.getParameter("sbjctId"));
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        model.addAttribute("userId", request.getParameter("userId"));
        return "std/popup/cls_stdnt_element_popup";
    }

    /**
     * 학습요소 제출 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsChsiLrnVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectStdntElemSbmsnList.do")
    @ResponseBody
    public ProcessResultVO<ClsChsiLrnVO> selectStdntElemSbmsnList(ClsWkLrnVO vo, HttpServletRequest request) throws
            Exception {
        ProcessResultVO<ClsChsiLrnVO> resultVO = new ProcessResultVO<>();
        vo.setOrgId(SessionInfo.getOrgId(request));
        try {
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

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

    /**
     * 학습요소 제출 이력 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsAsmtSbmsnLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectStdntElemSbmsnLog.do")
    @ResponseBody
    public ProcessResultVO<ClsAsmtSbmsnLogVO> selectStdntElemSbmsnLog(
            ClsAsmtSbmsnLogVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsAsmtSbmsnLogVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

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

    /**
     * 과목 주차 수 조회
     *
     * @param sbjctId
     * @param orgId
     * @return int
     * @throws Exception
     */
    private int resolveWkCnt(String sbjctId, String orgId) throws Exception {
        if (ValidationUtils.isEmpty(sbjctId)) {
            return 15;
        }

        ClsVO clsVO = new ClsVO();
        clsVO.setSbjctId(sbjctId);
        clsVO.setOrgId(orgId);

        ClsVO detail = clsService.selectClsDetail(clsVO);
        return (detail != null && detail.getWkCnt() > 0) ? detail.getWkCnt() : 15;
    }

    /**
     * 학습자 상세 조회 공통 접근 권한 검증
     * - sbjctId, userId 필수값 검증
     * - 해당 사용자가 해당 과목의 수강생인지 검증
     *
     * @param sbjctId
     * @param userId
     * @param orgId
     * @throws Exception
     */
    private void validateClsStdntAccess(String sbjctId, String userId, String orgId) throws Exception {
        if (ValidationUtils.isEmpty(sbjctId) || ValidationUtils.isEmpty(userId)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        ClsWkLrnVO accessVo = new ClsWkLrnVO();
        accessVo.setSbjctId(sbjctId);
        accessVo.setUserId(userId);
        accessVo.setOrgId(orgId);

        if (clsService.checkClsStdntAccessCnt(accessVo) <= 0) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
    }

    /**
     * 주차 학습 접근 권한 검증
     *
     * @param vo
     * @param requireSchdlId
     * @throws Exception
     */
    private void validateClsWkAccess(ClsWkLrnVO vo, boolean requireSchdlId) throws Exception {
        if (ValidationUtils.isEmpty(vo.getSbjctId())
                || ValidationUtils.isEmpty(vo.getUserId())
                || vo.getWkNo() <= 0) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        if (requireSchdlId && ValidationUtils.isEmpty(vo.getLctrWknoSchdlId())) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        if (clsService.checkClsStdntAccessCnt(vo) <= 0) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        if (clsService.checkClsWkSchdlAccessCnt(vo) <= 0) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
    }

}