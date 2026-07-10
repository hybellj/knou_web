package knou.lms.lrnsts.web;

import java.text.SimpleDateFormat;
import java.time.Year;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.map.ListOrderedMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.ParamInfo;
import knou.framework.common.SubjectInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.lrnsts.service.LrnStsService;
import knou.lms.lrnsts.vo.LrnStsAccessChartVO;
import knou.lms.lrnsts.vo.LrnStsActivityLogVO;
import knou.lms.lrnsts.vo.LrnStsDetailVO;
import knou.lms.lrnsts.vo.LrnStsLrnLogVO;
import knou.lms.lrnsts.vo.LrnStsVO;
import knou.lms.lrnsts.vo.LrnStsWkLrnVO;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value = "/lrnsts")
public class LrnStsController extends ControllerBase {

    private static final int DEFAULT_LIST_SCALE = 20;
    private static final int DEFAULT_PAGE_SCALE = 10;
    private static final int DEFAULT_LOG_LIST_SCALE = 10;
    private static final int DEFAULT_WK_CNT = 15;

    @Resource(name = "lrnStsService")
    private LrnStsService lrnStsService;

    @Resource(name = "semesterService")
    private SemesterService semesterService;

    @Resource(name = "subjectService")
    private SubjectService subjectService;

    /* ================================================================
       목록
       ================================================================ */

    /**
     * 학습자 나의 학습현황 목록 화면
     *
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return lrnsts/lrnsts_list
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsListView.do")
    public String selectLrnStsListView(LrnStsVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        applyCurrentSemesterDefaults(vo, userCtx, request);

        if (vo.getPageIndex() < 1) vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(DEFAULT_LIST_SCALE);
        if (vo.getListScale() > 100) vo.setListScale(100);
        if (vo.getPageScale() <= 0) vo.setPageScale(DEFAULT_PAGE_SCALE);
        if (vo.getPageScale() > 20) vo.setPageScale(20);

        PaginationInfo pageInfo = new PaginationInfo();
        pageInfo.setCurrentPageNo(vo.getPageIndex());
        pageInfo.setRecordCountPerPage(vo.getListScale());
        pageInfo.setPageSize(vo.getPageScale());
        vo.setFirstIndex(pageInfo.getFirstRecordIndex());
        vo.setLastIndex(pageInfo.getLastRecordIndex());

        int totalCnt = lrnStsService.selectLrnStsListCnt(vo);
        pageInfo.setTotalRecordCount(totalCnt);
        List<LrnStsVO> resultList = totalCnt > 0 ? lrnStsService.selectLrnStsList(vo) : new ArrayList<>();

        LrnStsVO filterVO = new LrnStsVO();
        filterVO.setUserId(userCtx.getUserId());
        filterVO.setSearchYr(vo.getSearchYr());
        filterVO.setDgrsSmstrChrt(vo.getDgrsSmstrChrt());
        filterVO.setSearchOrgId(vo.getSearchOrgId());
        List<OrgInfoVO> orgList = lrnStsService.selectLrnStsOrgList(filterVO);
        List<SmstrChrtVO> smstrChrtList = lrnStsService.selectLrnStsSmstrChrtList(filterVO);

        model.addAttribute("orgId", userCtx.getOrgId());
        model.addAttribute("authGrpCd", userCtx.getAuthrtCd());
        model.addAttribute("userId", userCtx.getUserId());
        model.addAttribute("encParams", getEncParams());
        model.addAttribute("resultList", resultList);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("orgList", orgList);
        model.addAttribute("smstrChrtList", smstrChrtList);
        model.addAttribute("subjectList", lrnStsService.selectLrnStsSubjectList(vo));
        model.addAttribute("vo", vo);

        return "lrnsts/lrnsts_list";
    }

    /**
     * 학습자 나의 학습현황 목록 조회
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<LrnStsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsList.do")
    @ResponseBody
    public ProcessResultVO<LrnStsVO> selectLrnStsList(LrnStsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<LrnStsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        applyCurrentSemesterDefaults(vo, userCtx, request);

        if (vo.getPageIndex() < 1) vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(DEFAULT_LIST_SCALE);
        if (vo.getListScale() > 100) vo.setListScale(100);
        if (vo.getPageScale() <= 0) vo.setPageScale(DEFAULT_PAGE_SCALE);
        if (vo.getPageScale() > 20) vo.setPageScale(20);

        PaginationInfo pageInfo = new PaginationInfo();
        pageInfo.setCurrentPageNo(vo.getPageIndex());
        pageInfo.setRecordCountPerPage(vo.getListScale());
        pageInfo.setPageSize(vo.getPageScale());
        vo.setFirstIndex(pageInfo.getFirstRecordIndex());
        vo.setLastIndex(pageInfo.getLastRecordIndex());

        int totalCnt = lrnStsService.selectLrnStsListCnt(vo);
        pageInfo.setTotalRecordCount(totalCnt);
        List<LrnStsVO> resultList = totalCnt > 0 ? lrnStsService.selectLrnStsList(vo) : new ArrayList<>();

        resultVO.setReturnList(resultList);
        resultVO.setPageInfo(pageInfo);
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 학습현황 검색용 수강과목 목록 조회
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<LrnStsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsSubjectList.do")
    @ResponseBody
    public ProcessResultVO<LrnStsVO> selectLrnStsSubjectList(LrnStsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<LrnStsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        applyCurrentSemesterDefaults(vo, userCtx, request);

        resultVO.setReturnList(lrnStsService.selectLrnStsSubjectList(vo));
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 학습현황 검색용 학기 목록 조회
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<SmstrChrtVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsSmstrChrtList.do")
    @ResponseBody
    public ProcessResultVO<SmstrChrtVO> selectLrnStsSmstrChrtList(LrnStsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<SmstrChrtVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        applyCurrentSemesterDefaults(vo, userCtx, request);

        resultVO.setReturnList(lrnStsService.selectLrnStsSmstrChrtList(vo));
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /* ================================================================
       상세
       ================================================================ */

    /**
     * 학습현황 상세 화면
     *
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return lrnsts/lrnsts_detail
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsDetailView.do")
    public String selectLrnStsDetailView(LrnStsDetailVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        String requestUserId = request.getParameter("userId");
        String sbjctId = request.getParameter("sbjctId");

        validateAccess(sbjctId, requestUserId, userCtx, null);

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        addEncParam("orgId", userCtx.getOrgId());
        addEncParam("sbjctId", sbjctId);
        addEncParam("userId", userCtx.getUserId());

        model.addAttribute("orgId", userCtx.getOrgId());
        model.addAttribute("authGrpCd", userCtx.getAuthrtCd());
        model.addAttribute("encParams", getEncParams());
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        SubjectVO subjectVO = SubjectInfo.getSubjectInfo(request, sbjctId);
        model.addAttribute("sbjctnm", subjectVO == null ? "" : subjectVO.getSbjctnm());
        model.addAttribute("userId", userCtx.getUserId());
        model.addAttribute("wkCnt", resolveWkCnt(sbjctId, userCtx.getUserId(), userCtx.getOrgId()));

        return "lrnsts/lrnsts_detail";
    }

    /**
     * 학습자 강의실 학습현황 상세 화면
     *
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return lrnsts/lrnsts_class_detail
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsClassDetailView.do")
    public String selectLrnStsClassDetailView(LrnStsDetailVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (ValidationUtils.isEmpty(request.getParameter("encParams"))) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        String sbjctId = vo.getSbjctId();
        String dvclasNo = vo.getDvclasNo();
        if (ValidationUtils.isEmpty(sbjctId)) {
            sbjctId = ParamInfo.getParamValue(request, "sbjctId");
        }
        if (ValidationUtils.isEmpty(dvclasNo)) {
            dvclasNo = ParamInfo.getParamValue(request, "dvclasNo");
        }

        validateAccess(sbjctId, null, userCtx, null);

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());
        vo.setSbjctId(sbjctId);

        addEncParam("orgId", userCtx.getOrgId());
        addEncParam("sbjctId", sbjctId);
        addEncParam("userId", userCtx.getUserId());

        model.addAttribute("orgId", userCtx.getOrgId());
        model.addAttribute("authGrpCd", userCtx.getAuthrtCd());
        model.addAttribute("encParams", getEncParams());
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("dvclasNo", dvclasNo);
        SubjectVO subjectVO = SubjectInfo.getSubjectInfo(request, sbjctId);
        model.addAttribute("sbjctnm", subjectVO == null ? "" : subjectVO.getSbjctnm());
        model.addAttribute("userId", userCtx.getUserId());
        model.addAttribute("wkCnt", resolveWkCnt(sbjctId, userCtx.getUserId(), userCtx.getOrgId()));
        model.addAttribute("viewMode", "classroom");

        return "lrnsts/lrnsts_class_detail";
    }

    /**
     * 학습현황 상세 상단 요약 정보 조회
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<LrnStsDetailVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsDetail.do")
    @ResponseBody
    public ProcessResultVO<LrnStsDetailVO> selectLrnStsDetail(LrnStsDetailVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<LrnStsDetailVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

        try {
            validateAccess(vo.getSbjctId(), vo.getUserId(), userCtx, null);
            vo.setUserId(userCtx.getUserId());

            resultVO.setReturnVO(lrnStsService.selectLrnStsDetail(vo));
            resultVO.setResultSuccess();
            resultVO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
            resultVO.setEncParams(getEncParams());
        }

        return resultVO;
    }

    /**
     * 주차별 출석 및 학습 상태 목록 조회
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<LrnStsDetailVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsWkStsList.do")
    @ResponseBody
    public ProcessResultVO<LrnStsDetailVO> selectLrnStsWkStsList(LrnStsDetailVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<LrnStsDetailVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

        try {
            validateAccess(vo.getSbjctId(), vo.getUserId(), userCtx, null);
            vo.setUserId(userCtx.getUserId());

            resultVO.setReturnList(lrnStsService.selectLrnStsWkStsList(vo));
            resultVO.setResultSuccess();
            resultVO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
            resultVO.setEncParams(getEncParams());
        }

        return resultVO;
    }

    /**
     * 접속현황 차트 데이터 조회
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<LrnStsAccessChartVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsAccessChartList.do")
    @ResponseBody
    public ProcessResultVO<LrnStsAccessChartVO> selectLrnStsAccessChartList(LrnStsAccessChartVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<LrnStsAccessChartVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        if (ValidationUtils.isEmpty(vo.getYyyymm())) {
            vo.setYyyymm(new SimpleDateFormat("yyyyMM").format(new Date()));
        }

        try {
            validateAccess(vo.getSbjctId(), request.getParameter("userId"), userCtx, null);
            resultVO.setReturnList(lrnStsService.selectLrnStsAccessChartList(vo));
            resultVO.setResultSuccess();
            resultVO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
            resultVO.setEncParams(getEncParams());
        }

        return resultVO;
    }

    /**
     * 강의실 활동기록 목록 조회
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<LrnStsActivityLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsActivityLogList.do")
    @ResponseBody
    public ProcessResultVO<LrnStsActivityLogVO> selectLrnStsActivityLogList(LrnStsActivityLogVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<LrnStsActivityLogVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        if (vo.getPageIndex() < 1) vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(DEFAULT_LOG_LIST_SCALE);
        if (vo.getListScale() > 100) vo.setListScale(100);
        if (vo.getPageScale() <= 0) vo.setPageScale(DEFAULT_PAGE_SCALE);
        if (vo.getPageScale() > 20) vo.setPageScale(20);

        try {
            validateAccess(vo.getSbjctId(), vo.getUserId(), userCtx, null);
            vo.setUserId(userCtx.getUserId());

            int totalCnt = lrnStsService.selectLrnStsActivityLogListCnt(vo);
            PaginationInfo pageInfo = new PaginationInfo();
            pageInfo.setCurrentPageNo(vo.getPageIndex());
            pageInfo.setRecordCountPerPage(vo.getListScale());
            pageInfo.setPageSize(vo.getPageScale());
            pageInfo.setTotalRecordCount(totalCnt);
            vo.setFirstIndex(pageInfo.getFirstRecordIndex());
            vo.setLastIndex(pageInfo.getLastRecordIndex());

            List<LrnStsActivityLogVO> resultList = totalCnt > 0
                ? lrnStsService.selectLrnStsActivityLogPaging(vo)
                : new ArrayList<>();

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(pageInfo);
            resultVO.setResultSuccess();
            resultVO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
            resultVO.setEncParams(getEncParams());
        }

        return resultVO;
    }

    /**
     * 강의실 활동기록 엑셀 다운로드
     *
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsActivityLogExcelDown.do")
    public String selectLrnStsActivityLogExcelDown(LrnStsActivityLogVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        vo.setOrgId(userCtx.getOrgId());
        validateAccess(vo.getSbjctId(), vo.getUserId(), userCtx, null);
        vo.setUserId(userCtx.getUserId());

        if (vo.getExcelGrid() == null || vo.getExcelGrid().trim().isEmpty()) {
            vo.setExcelGrid(
                "{\"colModel\":["
                    + "{\"label\":\"번호\",\"name\":\"lineNo\",\"align\":\"center\",\"width\":\"3000\"},"
                    + "{\"label\":\"일시\",\"name\":\"actDttm\",\"align\":\"center\",\"width\":\"8000\"},"
                    + "{\"label\":\"활동 내용\",\"name\":\"actConts\",\"align\":\"left\",\"width\":\"8000\"},"
                    + "{\"label\":\"접속기기\",\"name\":\"deviceNm\",\"align\":\"center\",\"width\":\"5000\"},"
                    + "{\"label\":\"IP\",\"name\":\"ipAddr\",\"align\":\"center\",\"width\":\"6000\"}"
                + "]}"
            );
        }

        List<LrnStsActivityLogVO> list = lrnStsService.selectLrnStsActivityLogList(vo);
        List<ListOrderedMap> newList = new ArrayList<>();
        for (LrnStsActivityLogVO item : list) {
            ListOrderedMap om = new ListOrderedMap();
            om.put("lineNo", item.getLineNo());
            om.put("actDttm", item.getActDttm());
            om.put("actConts", item.getActConts());
            om.put("deviceNm", item.getDeviceNm());
            om.put("ipAddr", item.getIpAddr());
            newList.add(om);
        }

        String title = "학습활동기록";
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", newList);
        map.put("ext", ".xlsx(big)");

        String currentDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + currentDate);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

        model.addAllAttributes(modelMap);
        return "excelView";
    }

    /* ================================================================
       주차 팝업
       ================================================================ */

    /**
     * 주차별 학습현황 팝업 화면
     *
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return lrnsts/popup/lrnsts_stdnt_week_lrn_popup
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsWkDetailPopupView.do")
    public String selectLrnStsWkDetailPopupView(LrnStsWkLrnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        String requestUserId = request.getParameter("userId");
        String sbjctId = request.getParameter("sbjctId");
        String wkNoStr = request.getParameter("wkNo");

        if (ValidationUtils.isEmpty(wkNoStr)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        Integer wkNo;
        try {
            wkNo = Integer.parseInt(wkNoStr);
        } catch (NumberFormatException e) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        validateAccess(sbjctId, requestUserId, userCtx, wkNo);

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        addEncParam("orgId", userCtx.getOrgId());
        addEncParam("sbjctId", sbjctId);
        addEncParam("userId", userCtx.getUserId());
        addEncParam("wkNo", wkNo);

        model.addAttribute("orgId", userCtx.getOrgId());
        model.addAttribute("authGrpCd", userCtx.getAuthrtCd());
        model.addAttribute("encParams", getEncParams());
        model.addAttribute("wkCnt", resolveWkCnt(sbjctId, userCtx.getUserId(), userCtx.getOrgId()));
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        SubjectVO subjectVO = SubjectInfo.getSubjectInfo(request, sbjctId);
        model.addAttribute("sbjctnm", subjectVO == null ? "" : subjectVO.getSbjctnm());
        model.addAttribute("userId", userCtx.getUserId());
        model.addAttribute("wkNo", wkNo);

        return "lrnsts/popup/lrnsts_stdnt_week_lrn_popup";
    }

    /**
     * 주차별 학습현황 팝업 요약 정보 조회
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<LrnStsWkLrnVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsWkLrnSummary.do")
    @ResponseBody
    public ProcessResultVO<LrnStsWkLrnVO> selectLrnStsWkLrnSummary(LrnStsWkLrnVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<LrnStsWkLrnVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

        try {
            validateAccess(vo.getSbjctId(), vo.getUserId(), userCtx, vo.getWkNo());
            vo.setUserId(userCtx.getUserId());

            resultVO.setReturnVO(lrnStsService.selectLrnStsWkLrnSummary(vo));
            resultVO.setResultSuccess();
            resultVO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
            resultVO.setEncParams(getEncParams());
        }

        return resultVO;
    }

    /**
     * 주차별 학습현황 팝업 차시별 학습 로그 목록 조회
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<LrnStsLrnLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectLrnStsLrnLogList.do")
    @ResponseBody
    public ProcessResultVO<LrnStsLrnLogVO> selectLrnStsLrnLogList(LrnStsLrnLogVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<LrnStsLrnLogVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

        try {
            if (ValidationUtils.isEmpty(vo.getCntntsId()) || vo.getWkNo() <= 0) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            validateAccess(vo.getSbjctId(), vo.getUserId(), userCtx, vo.getWkNo());
            vo.setUserId(userCtx.getUserId());

            resultVO.setReturnList(lrnStsService.selectLrnStsLrnLogList(vo));
            resultVO.setResultSuccess();
            resultVO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
            resultVO.setEncParams(getEncParams());
        }

        return resultVO;
    }

    /**
     * 명시 검색값이 없을 때 현재년도만 기본값으로 적용한다.
     */
    private void applyCurrentSemesterDefaults(LrnStsVO vo, UserContext userCtx, HttpServletRequest request) throws Exception {
        SmstrChrtVO currentSemester = getCurrentSemester(userCtx.getOrgId());

        if (ValidationUtils.isEmpty(vo.getSearchYr())) {
            if (currentSemester != null && !ValidationUtils.isEmpty(currentSemester.getDgrsYr())) {
                vo.setSearchYr(currentSemester.getDgrsYr());
            } else {
                vo.setSearchYr(String.valueOf(Year.now().getValue()));
            }
        }
    }

    private SmstrChrtVO getCurrentSemester(String orgId) throws Exception {
        SmstrChrtVO searchVO = new SmstrChrtVO();
        searchVO.setOrgId(orgId);
        return semesterService.selectCurrentSemester(searchVO);
    }

    /**
     * 과목 전체 주차 수 조회
     */
    private int resolveWkCnt(String sbjctId, String userId, String orgId) throws Exception {
        if (ValidationUtils.isEmpty(sbjctId) || ValidationUtils.isEmpty(userId)) {
            return DEFAULT_WK_CNT;
        }

        LrnStsDetailVO detailVO = new LrnStsDetailVO();
        detailVO.setSbjctId(sbjctId);
        detailVO.setUserId(userId);
        detailVO.setOrgId(orgId);

        LrnStsDetailVO detail = lrnStsService.selectLrnStsDetail(detailVO);
        return (detail != null && detail.getWkCnt() > 0) ? detail.getWkCnt() : DEFAULT_WK_CNT;
    }

    /**
     * 본인 화면 접근 여부와 필수 파라미터 공통 검증
     *
     * @param sbjctId
     * @param requestUserId
     * @param userCtx
     * @param wkNo
     * @throws Exception
     */
    private void validateAccess(String sbjctId, String requestUserId, UserContext userCtx, Integer wkNo) throws Exception {
        if (ValidationUtils.isEmpty(sbjctId)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        if (userCtx == null || ValidationUtils.isEmpty(userCtx.getUserId())) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        if (!ValidationUtils.isEmpty(requestUserId) && !userCtx.getUserId().equals(requestUserId)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        if (ValidationUtils.isEmpty(subjectService.subjectByStdntAuthSelect(sbjctId, userCtx.getUserId()))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        if (wkNo != null && wkNo <= 0) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
    }

}
