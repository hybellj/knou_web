package knou.lms.clssts.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.map.ListOrderedMap;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SubjectInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.ValidationUtils;
import knou.lms.clssts.service.ClsStsService;
import knou.lms.clssts.vo.ClsAccessChartVO;
import knou.lms.clssts.vo.ClsActivityLogVO;
import knou.lms.clssts.vo.ClsAsmtSbmsnLogVO;
import knou.lms.clssts.vo.ClsChsiLrnVO;
import knou.lms.clssts.vo.ClsElemStatsVO;
import knou.lms.clssts.vo.ClsLrnLogVO;
import knou.lms.clssts.vo.ClsStdntInfoVO;
import knou.lms.clssts.vo.ClsStdntVO;
import knou.lms.clssts.vo.ClsVO;
import knou.lms.clssts.vo.ClsWkLrnVO;
import knou.lms.clssts.vo.ClsWkStsVO;
import knou.lms.clssts.vo.ClsWklyStatsVO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.lecture2.vo.LectureWknoScheduleVO;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.subject.service.SubjectFacadeService;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.subject.web.view.SubjectViewModel;
import knou.lms.user.CurrentUser;

/**
 * 수업현황 Controller
 * 화면ID : KNOU_MN_B0102060101, KNOU_MN_B0102060102
 */
@Controller
public class ClsStsController extends ControllerBase {

    private static final int DEFAULT_LIST_SCALE = 20;
    private static final int DEFAULT_PAGE_SCALE = 10;
    private static final int DEFAULT_LOG_LIST_SCALE = 10;
    private static final int DEFAULT_WK_CNT = 15;

    @Resource(name = "clsStsService")
    private ClsStsService clsService;

    @Resource(name = "subjectService")
    private SubjectService subjectService;

    @Resource(name = "subjectFacadeService")
    private SubjectFacadeService subjectFacadeService;

    @Resource(name = "semesterService")
    private SemesterService semesterService;

    /* ================================================================
       목록/검색 화면
       ================================================================ */

    /**
     * 수업현황 목록 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return clssts/clssts_list
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsListView.do")
    public String selectClsStsListView(ClsVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        String sessionOrgId = userCtx.getOrgId();

        model.addAttribute("orgId", sessionOrgId);
        model.addAttribute("authGrpCd", userCtx.getAuthrtCd());

        vo.setOrgId(sessionOrgId);
        applyListSearchDefaults(vo, userCtx, true);
        applyPagingDefaults(vo);

        ProcessResultVO<ClsVO> resultVO = clsService.selectClsListPaging(vo);

        model.addAttribute("smstrChrtList", clsService.selectClsTermList(vo));
        model.addAttribute("subjectList", clsService.selectClsSubjectList(vo));
        model.addAttribute("resultList", resultVO.getReturnList());
        model.addAttribute("pageInfo", resultVO.getPageInfo());
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("orgList", clsService.selectClsOrgList(vo));
        model.addAttribute("vo", vo);

        return "clssts/clssts_list";
    }

    /**
     * 수업현황 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsListPaging.do")
    @ResponseBody
    public ProcessResultVO<ClsVO> selectClsStsListPaging(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        applyListSearchDefaults(vo, userCtx, false);
        applyPagingDefaults(vo);

        ProcessResultVO<ClsVO> resultVO = clsService.selectClsListPaging(vo);
        if (resultVO.getResult() >= 0) {
            resultVO.setResultSuccess();
        } else {
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
    @RequestMapping(value = "/clssts/selectClsStsSubjectList.do")
    @ResponseBody
    public ProcessResultVO<ClsVO> selectClsStsSubjectList(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<ClsVO> resultVO = new ProcessResultVO<>();
        applyListSearchDefaults(vo, userCtx, false);
        resultVO.setReturnList(clsService.selectClsSubjectList(vo));
        resultVO.setResultSuccess();
        return resultVO;
    }

    /**
     * 교수 운영 기관 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<OrgInfoVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsOrgList.do")
    @ResponseBody
    public ProcessResultVO<OrgInfoVO> selectClsStsOrgList(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<OrgInfoVO> resultVO = new ProcessResultVO<>();
        applyListSearchDefaults(vo, userCtx, false);
        resultVO.setReturnList(clsService.selectClsOrgList(vo));
        resultVO.setResultSuccess();
        return resultVO;
    }

    /**
     * 교수 운영 학기 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<SmstrChrtVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsTermList.do")
    @ResponseBody
    public ProcessResultVO<SmstrChrtVO> selectClsStsTermList(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<SmstrChrtVO> resultVO = new ProcessResultVO<>();
        applyListSearchDefaults(vo, userCtx, false);
        resultVO.setReturnList(clsService.selectClsTermList(vo));
        resultVO.setResultSuccess();
        return resultVO;
    }

    /* ================================================================
       상세 화면
       ================================================================ */

    /**
     * 수업현황 상세 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return clssts/clssts_detail
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsDetailView.do")
    public String selectClsStsDetailView(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (ValidationUtils.isEmpty(vo.getSbjctId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        validateSbjctAccess(vo.getSbjctId(), userCtx, false);

        String sessionOrgId = userCtx.getOrgId();

        addEncParam("sbjctId", vo.getSbjctId());
        addEncParam("orgId", sessionOrgId);

        model.addAttribute("orgId", sessionOrgId);
        model.addAttribute("authGrpCd", userCtx.getAuthrtCd());
        model.addAttribute("sbjctId", vo.getSbjctId());
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));

        SubjectVO subjectVO = SubjectInfo.getSubjectInfo(request, vo.getSbjctId());
        model.addAttribute("sbjctnm", subjectVO == null ? "" : subjectVO.getSbjctnm());

        int wkCnt = resolveWkCnt(vo.getSbjctId(), sessionOrgId);
        model.addAttribute("wkCnt", wkCnt);

        return "clssts/clssts_detail";
    }

    /* ================================================================
       강의실 상세 화면
       ================================================================ */

    /**
     * 강의실 수업현황 상세 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return clssts/clssts_class_detail
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassDetailView.do")
    public String selectClsStsClassDetailView(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
//        String sbjctId = vo.getSbjctId() == null ? "SBJCT_OFRNG_ID2" : vo.getSbjctId();
//        vo.setSbjctId(sbjctId);

        if (ValidationUtils.isEmpty(vo.getSbjctId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        validateSbjctAccess(vo.getSbjctId(), userCtx, true);

        String sessionOrgId = userCtx.getOrgId();

        SubjectViewModel subjectVM = subjectFacadeService.getSubjectViewModel(userCtx, vo.getSbjctId());
        model.addAttribute("subjectVM", subjectVM);

        LectureWknoScheduleVO lctrWknoSchdlVO = subjectService.currLctrWknoSchdlSelect(vo.getSbjctId());
        model.addAttribute("lctrWknoSchdlVO", lctrWknoSchdlVO);

        EgovMap lctrWknoAtndcrt = null;
        if (lctrWknoSchdlVO != null && !ValidationUtils.isEmpty(lctrWknoSchdlVO.getLctrWknoSchdlId())) {
            lctrWknoAtndcrt = subjectService.lctrWknoAtndcrtSelect(vo.getSbjctId(), lctrWknoSchdlVO.getLctrWknoSchdlId());
        }
        model.addAttribute("lctrWknoAtndcrt", lctrWknoAtndcrt);

        int sbjctConnectStdCnt = subjectService.subjectConnectStdCntSelect(vo.getSbjctId());
        model.addAttribute("sbjctConnectStdCnt", sbjctConnectStdCnt);

        int sbjctTotalStdCnt = subjectService.subjectTotalStdCntSelect(vo.getSbjctId());
        model.addAttribute("sbjctTotalStdCnt", sbjctTotalStdCnt);

        List<EgovMap> stdntSubjectConnectList = subjectService.stdntSubjectConnectList(vo.getSbjctId());
        model.addAttribute("stdntSubjectConnectList", stdntSubjectConnectList);

        model.addAttribute("orgId", sessionOrgId);
        model.addAttribute("sbjctId", vo.getSbjctId());
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        model.addAttribute("sbjctnm", SubjectInfo.getSbjctnm(request, vo.getSbjctId()));

        addEncParam("sbjctId", vo.getSbjctId());
        addEncParam("orgId", sessionOrgId);

        int wkCnt = resolveWkCnt(vo.getSbjctId(), sessionOrgId);
        model.addAttribute("wkCnt", wkCnt);

        return "clssts/clssts_class_detail";
    }

    /* ================================================================
       팝업 화면
       ================================================================ */

    /**
     * 미학습자 팝업 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return clssts/popup/clssts_no_study_popup
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsNoStudyPopupView.do")
    public String selectClsStsNoStudyPopupView(ClsVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return openNoStudyPopupView(userCtx, model, request, false, "clssts/popup/clssts_no_study_popup");
    }

    /**
     * 학습자 주차별 학습현황 팝업 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return clssts/popup/clssts_stdnt_lrn_popup
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntWkPopupView.do")
    public String selectClsStsStdntWkPopupView(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return openStdntWkPopupView(userCtx, model, request, false, "clssts/popup/clssts_stdnt_lrn_popup");
    }

    /**
     * 학습자 주차별 학습기록 팝업 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return clssts/popup/clssts_stdnt_week_lrn_popup
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntWkDetailPopupView.do")
    public String selectClsStsStdntWkDetailPopupView(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return openStdntWkDetailPopupView(userCtx, model, request, false, "clssts/popup/clssts_stdnt_week_lrn_popup");
    }

    /**
     * 학습요소 참여현황 팝업 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return clssts/popup/clssts_stdnt_element_popup
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntElemPopupView.do")
    public String selectClsStsStdntElemPopupView(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return openStdntElemPopupView(userCtx, model, request, false, "clssts/popup/clssts_stdnt_element_popup");
    }

    /**
     * 강의실 미학습자 팝업 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return clssts/popup/clssts_class_no_study_popup
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassNoStudyPopupView.do")
    public String selectClsStsClassNoStudyPopupView(ClsVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return openNoStudyPopupView(userCtx, model, request, true, "clssts/popup/clssts_class_no_study_popup");
    }

    /**
     * 강의실 학습자 주차별 학습현황 팝업 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return clssts/popup/clssts_class_stdnt_lrn_popup
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntWkPopupView.do")
    public String selectClsStsClassStdntWkPopupView(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return openStdntWkPopupView(userCtx, model, request, true, "clssts/popup/clssts_class_stdnt_lrn_popup");
    }

    /**
     * 강의실 학습자 주차별 학습기록 팝업 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return clssts/popup/clssts_class_stdnt_week_lrn_popup
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntWkDetailPopupView.do")
    public String selectClsStsClassStdntWkDetailPopupView(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return openStdntWkDetailPopupView(userCtx, model, request, true, "clssts/popup/clssts_class_stdnt_week_lrn_popup");
    }

    /**
     * 강의실 학습요소 참여현황 팝업 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return clssts/popup/clssts_class_stdnt_element_popup
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntElemPopupView.do")
    public String selectClsStsClassStdntElemPopupView(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return openStdntElemPopupView(userCtx, model, request, true, "clssts/popup/clssts_class_stdnt_element_popup");
    }

    /* ================================================================
       상단 요약/목록/요소 통계 API
       ================================================================ */

    /**
     * 주차별 미학습자 비율 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsWklyStatsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsWklyStats.do")
    @ResponseBody
    public ProcessResultVO<ClsWklyStatsVO> selectClsStsWklyStats(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectWklyStats(vo, userCtx, false);
    }

    /**
     * 강의실 주차별 미학습자 비율 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsWklyStatsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassWklyStats.do")
    @ResponseBody
    public ProcessResultVO<ClsWklyStatsVO> selectClsStsClassWklyStats(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectWklyStats(vo, userCtx, true);
    }

    /**
     * 주차별 학습현황 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntListPaging.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectClsStsStdntListPaging(ClsStdntVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntListPaging(vo, userCtx, false);
    }

    /**
     * 강의실 주차별 학습현황 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntListPaging.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectClsStsClassStdntListPaging(ClsStdntVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntListPaging(vo, userCtx, true);
    }

    /**
     * 학습요소 참여현황 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsElemStatsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsElemStats.do")
    @ResponseBody
    public ProcessResultVO<ClsElemStatsVO> selectClsStsElemStats(ClsElemStatsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectElemStats(vo, userCtx, false);
    }

    /**
     * 강의실 학습요소 참여현황 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsElemStatsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassElemStats.do")
    @ResponseBody
    public ProcessResultVO<ClsElemStatsVO> selectClsStsClassElemStats(ClsElemStatsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectElemStats(vo, userCtx, true);
    }

    /* ================================================================
       미수강/엑셀 다운로드 API
       ================================================================ */

    /**
     * 주차별 학습현황 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntListExcelDown.do")
    public String selectClsStsStdntListExcelDown(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return downloadStdntListExcel(vo, userCtx, model, false);
    }

    /**
     * 강의실 주차별 학습현황 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntListExcelDown.do")
    public String selectClsStsClassStdntListExcelDown(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return downloadStdntListExcel(vo, userCtx, model, true);
    }

    /**
     * 주차별 미학습자 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsNoStudyWeek.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectClsStsNoStudyWeek(ClsStdntVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectNoStudyWeek(vo, userCtx, false);
    }

    /**
     * 강의실 주차별 미학습자 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassNoStudyWeek.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectClsStsClassNoStudyWeek(ClsStdntVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectNoStudyWeek(vo, userCtx, true);
    }

    /**
     * 주차별 미학습자 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsNoStudyWeekExcelDown.do")
    public String selectClsStsNoStudyWeekExcelDown(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return downloadNoStudyWeekExcel(vo, userCtx, model, request, false);
    }

    /**
     * 강의실 주차별 미학습자 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassNoStudyWeekExcelDown.do")
    public String selectClsStsClassNoStudyWeekExcelDown(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return downloadNoStudyWeekExcel(vo, userCtx, model, request, true);
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
    @RequestMapping(value = "/clssts/selectClsStsElemStatsExcelDown.do")
    public String selectClsStsElemStatsExcelDown(ClsElemStatsVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return downloadElemStatsExcel(vo, userCtx, model, false);
    }

    /**
     * 강의실 학습요소 참여현황 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassElemStatsExcelDown.do")
    public String selectClsStsClassElemStatsExcelDown(ClsElemStatsVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return downloadElemStatsExcel(vo, userCtx, model, true);
    }

    /* ================================================================
       상세 하위 데이터 API
       ================================================================ */

    /**
     * 과목 상세 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsDetail.do")
    @ResponseBody
    public ProcessResultVO<ClsVO> selectClsStsDetail(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectDetail(vo, userCtx, false);
    }

    /**
     * 강의실 과목 상세 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassDetail.do")
    @ResponseBody
    public ProcessResultVO<ClsVO> selectClsStsClassDetail(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectDetail(vo, userCtx, true);
    }

    /**
     * 수강생 상세 정보 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntInfoVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntInfo.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntInfoVO> selectClsStsStdntInfo(ClsStdntInfoVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntInfo(vo, userCtx, false);
    }

    /**
     * 강의실 수강생 상세 정보 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntInfoVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntInfo.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntInfoVO> selectClsStsClassStdntInfo(ClsStdntInfoVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntInfo(vo, userCtx, true);
    }

    /**
     * 학습자 주차별 출결 정보 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntWeeklyInfo.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectClsStsStdntWeeklyInfo(ClsStdntVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntWeeklyInfo(vo, userCtx, false);
    }

    /**
     * 강의실 학습자 주차별 출결 정보 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntWeeklyInfo.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectClsStsClassStdntWeeklyInfo(ClsStdntVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntWeeklyInfo(vo, userCtx, true);
    }

    /**
     * 수강생 접속현황 차트 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsAccessChartVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntAccessChart.do")
    @ResponseBody
    public ProcessResultVO<ClsAccessChartVO> selectClsStsStdntAccessChart(ClsAccessChartVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntAccessChart(vo, userCtx, false);
    }

    /**
     * 강의실 수강생 접속현황 차트 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsAccessChartVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntAccessChart.do")
    @ResponseBody
    public ProcessResultVO<ClsAccessChartVO> selectClsStsClassStdntAccessChart(ClsAccessChartVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntAccessChart(vo, userCtx, true);
    }

    /**
     * 강의실 활동기록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsActivityLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntActivityLog.do")
    @ResponseBody
    public ProcessResultVO<ClsActivityLogVO> selectClsStsStdntActivityLog(ClsActivityLogVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntActivityLog(vo, userCtx, false);
    }

    /**
     * 강의실 수강생 활동기록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsActivityLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntActivityLog.do")
    @ResponseBody
    public ProcessResultVO<ClsActivityLogVO> selectClsStsClassStdntActivityLog(ClsActivityLogVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntActivityLog(vo, userCtx, true);
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
    @RequestMapping(value = "/clssts/selectClsStsStdntActivityLogExcelDown.do")
    public String selectClsStsStdntActivityLogExcelDown(ClsActivityLogVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return downloadStdntActivityLogExcel(vo, userCtx, model, false);
    }

    /**
     * 강의실 수강생 활동기록 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntActivityLogExcelDown.do")
    public String selectClsStsClassStdntActivityLogExcelDown(ClsActivityLogVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return downloadStdntActivityLogExcel(vo, userCtx, model, true);
    }

    /* ================================================================
       주차 학습/출석 처리 API
       ================================================================ */

    /**
     * 주차별 학습요약 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsWkLrnVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntWkLrnSummary.do")
    @ResponseBody
    public ProcessResultVO<ClsWkLrnVO> selectClsStsStdntWkLrnSummary(ClsWkLrnVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntWkLrnSummary(vo, userCtx, false);
    }

    /**
     * 강의실 주차별 학습요약 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsWkLrnVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntWkLrnSummary.do")
    @ResponseBody
    public ProcessResultVO<ClsWkLrnVO> selectClsStsClassStdntWkLrnSummary(ClsWkLrnVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntWkLrnSummary(vo, userCtx, true);
    }

    /**
     * 학습로그 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsLrnLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntLrnLog.do")
    @ResponseBody
    public ProcessResultVO<ClsLrnLogVO> selectClsStsStdntLrnLog(ClsLrnLogVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntLrnLog(vo, userCtx, request, false);
    }

    /**
     * 강의실 학습로그 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsLrnLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntLrnLog.do")
    @ResponseBody
    public ProcessResultVO<ClsLrnLogVO> selectClsStsClassStdntLrnLog(ClsLrnLogVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntLrnLog(vo, userCtx, request, true);
    }

    /**
     * 출석 처리
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<Object>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/updateClsStsAtndlcProcess.do")
    @ResponseBody
    public ProcessResultVO<Object> updateClsStsAtndlcProcess(ClsWkLrnVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return updateAtndlc(vo, userCtx, false, false);
    }

    /**
     * 출석 처리 취소
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<Object>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/updateClsStsAtndlcCancel.do")
    @ResponseBody
    public ProcessResultVO<Object> updateClsStsAtndlcCancel(ClsWkLrnVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return updateAtndlc(vo, userCtx, false, true);
    }

    /**
     * 강의실 출석 처리
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<Object>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/updateClsStsClassAtndlcProcess.do")
    @ResponseBody
    public ProcessResultVO<Object> updateClsStsClassAtndlcProcess(ClsWkLrnVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return updateAtndlc(vo, userCtx, true, false);
    }

    /**
     * 강의실 출석 처리 취소
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<Object>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/updateClsStsClassAtndlcCancel.do")
    @ResponseBody
    public ProcessResultVO<Object> updateClsStsClassAtndlcCancel(ClsWkLrnVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return updateAtndlc(vo, userCtx, true, true);
    }

    /* ================================================================
       제출 이력 API
       ================================================================ */

    /**
     * 학습요소 제출/참여 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsChsiLrnVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntElemSbmsnList.do")
    @ResponseBody
    public ProcessResultVO<ClsChsiLrnVO> selectClsStsStdntElemSbmsnList(ClsWkLrnVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntElemSbmsnList(vo, userCtx, false);
    }

    /**
     * 강의실 학습요소 제출/참여 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsChsiLrnVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntElemSbmsnList.do")
    @ResponseBody
    public ProcessResultVO<ClsChsiLrnVO> selectClsStsClassStdntElemSbmsnList(ClsWkLrnVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntElemSbmsnList(vo, userCtx, true);
    }

    /**
     * 학습요소 제출/참여 이력 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsAsmtSbmsnLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsStdntElemSbmsnLog.do")
    @ResponseBody
    public ProcessResultVO<ClsAsmtSbmsnLogVO> selectClsStsStdntElemSbmsnLog(ClsAsmtSbmsnLogVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntElemSbmsnLog(vo, userCtx, false);
    }

    /**
     * 강의실 학습요소 제출/참여 이력 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsAsmtSbmsnLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/clssts/selectClsStsClassStdntElemSbmsnLog.do")
    @ResponseBody
    public ProcessResultVO<ClsAsmtSbmsnLogVO> selectClsStsClassStdntElemSbmsnLog(ClsAsmtSbmsnLogVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return selectStdntElemSbmsnLog(vo, userCtx, true);
    }

    /* ================================================================
       공통 조회/엑셀 구현
       ================================================================ */

    private ProcessResultVO<ClsWklyStatsVO> selectWklyStats(ClsVO vo, UserContext userCtx, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsWklyStatsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

        try {
            if (ValidationUtils.isEmpty(vo.getSbjctId())) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);

            List<ClsWklyStatsVO> list = clsService.selectClsWklyStats(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
            resultVO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private ProcessResultVO<ClsStdntVO> selectStdntListPaging(ClsStdntVO vo, UserContext userCtx, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsStdntVO> resultVO = new ProcessResultVO<>();

        applyStdntListPagingDefaults(vo, userCtx);

        try {
            if (ValidationUtils.isEmpty(vo.getSbjctId())) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);

            resultVO = clsService.selectClsStdntListPaging(vo);
            if (resultVO.getResult() >= 0) {
                resultVO.setResultSuccess();
                resultVO.setEncParams(getEncParams());
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage(getCommonFailMessage());
            }
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private ProcessResultVO<ClsElemStatsVO> selectElemStats(ClsElemStatsVO vo, UserContext userCtx, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsElemStatsVO> resultVO = new ProcessResultVO<>();

        applyElemStatsPagingDefaults(vo, userCtx);

        try {
            if (ValidationUtils.isEmpty(vo.getSbjctId())) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);

            resultVO = clsService.selectClsElemStatsListPaging(vo);
            if (resultVO.getResult() >= 0) {
                resultVO.setResultSuccess();
                resultVO.setEncParams(getEncParams());
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage(getCommonFailMessage());
            }
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private String downloadStdntListExcel(ClsStdntVO vo, UserContext userCtx, ModelMap model, boolean classroomMode) throws Exception {
        if (ValidationUtils.isEmpty(vo.getSbjctId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);

        vo.setOrgId(userCtx.getOrgId());
        int wkCnt = resolveWkCnt(vo.getSbjctId(), userCtx.getOrgId());

        if (vo.getWkList() == null || vo.getWkList().isEmpty()) {
            vo.setWkList(IntStream.rangeClosed(1, wkCnt).boxed().collect(Collectors.toList()));
        }

        List<ClsStdntVO> list = clsService.selectClsStdntList(vo);
        List<ListOrderedMap> excelList = new ArrayList<>();
        for (ClsStdntVO item : list) {
            ListOrderedMap row = new ListOrderedMap();
            row.put("lineNo", item.getLineNo());
            row.put("deptnm", item.getDeptnm());
            row.put("userId", item.getUserId());
            row.put("stdntNo", item.getStdntNo());
            row.put("usernm", item.getUsernm());
            row.put("entyR", item.getEntyR());
            row.put("scyr", item.getScyr());

            HashMap<Integer, String> wkMap = new HashMap<>();
            if (item.getWkStsList() != null) {
                for (ClsWkStsVO wkSts : item.getWkStsList()) {
                    wkMap.put(wkSts.getWkNo(), wkSts.getAtndSts());
                }
            }

            for (int w = 1; w <= wkCnt; w++) {
                row.put("wk" + w + "Sts", getAttendanceStatusText(wkMap.getOrDefault(w, "-")));
            }

            row.put("atndCnt", item.getAtndCnt());
            row.put("lateCnt", item.getLateCnt());
            row.put("absnCnt", item.getAbsnCnt());
            excelList.add(row);
        }

        return buildExcelView(model, "주차별 학습현황", vo.getExcelGrid(), excelList);
    }

    private ProcessResultVO<ClsStdntVO> selectNoStudyWeek(ClsStdntVO vo, UserContext userCtx, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsStdntVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

        try {
            if (ValidationUtils.isEmpty(vo.getSbjctId()) || vo.getWkNo() <= 0) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);

            List<ClsStdntVO> list = clsService.selectClsNoStudyWeek(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private String downloadNoStudyWeekExcel(ClsStdntVO vo, UserContext userCtx, ModelMap model, HttpServletRequest request, boolean classroomMode) throws Exception {
        String dvclasNo = request.getParameter("dvclasNo");

        if (ValidationUtils.isEmpty(vo.getSbjctId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        if (vo.getWkNo() <= 0) {
            vo.setWkNo(parsePositiveInt(request.getParameter("wkNo")));
        }

        if (vo.getWkNo() <= 0) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);
        vo.setOrgId(userCtx.getOrgId());

        List<ClsStdntVO> list = clsService.selectClsNoStudyWeek(vo);
        List<ListOrderedMap> excelList = new ArrayList<>();
        for (ClsStdntVO item : list) {
            ListOrderedMap row = new ListOrderedMap();
            row.put("lineNo", item.getLineNo());
            row.put("deptnm", item.getDeptnm());
            row.put("sbjctnm", buildSubjectName(vo.getSbjctnm(), dvclasNo));
            row.put("userId", item.getUserId());
            row.put("stdntNo", item.getStdntNo());
            row.put("usernm", item.getUsernm());
            row.put("prgrt", item.getPrgrt());
            excelList.add(row);
        }

        return buildExcelView(model, vo.getWkNo() + "주차 미학습자 현황", vo.getExcelGrid(), excelList);
    }

    private String downloadElemStatsExcel(ClsElemStatsVO vo, UserContext userCtx, ModelMap model, boolean classroomMode) throws Exception {
        if (ValidationUtils.isEmpty(vo.getSbjctId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);
        vo.setOrgId(userCtx.getOrgId());
        ensureElemExcelGrid(vo);

        List<ClsElemStatsVO> list = clsService.selectClsElemStatsListExcelDown(vo);
        List<ListOrderedMap> excelList = new ArrayList<>();

        for (ClsElemStatsVO item : list) {
            ListOrderedMap row = new ListOrderedMap();
            row.put("lineNo", item.getLineNo());
            row.put("deptnm", item.getDeptnm());
            row.put("userId", item.getUserId());
            row.put("stdntNo", item.getStdntNo());
            row.put("usernm", item.getUsernm());
            row.put("qaText", item.getQaAnsCnt() + "/" + item.getQaRegCnt());
            row.put("talkReplyCnt", item.getTalkReplyCnt());
            row.put("asmtText", item.getAsmtSbmsnCnt() + "/" + item.getAsmtTrgtCnt());
            row.put("quizText", item.getQuizSbmsnCnt() + "/" + item.getQuizTrgtCnt());
            row.put("srvyText", item.getSrvySbmsnCnt() + "/" + item.getSrvyTrgtCnt());
            row.put("dscsText", item.getDscsSbmsnCnt() + "/" + item.getDscsTrgtCnt());
            row.put("midScore", item.getMidLiveScore() != null ? item.getMidLiveScore()
                    : item.getMidAltScore() != null ? item.getMidAltScore()
                    : item.getMidEtcScore());
            row.put("finalScore", item.getFinalLiveScore() != null ? item.getFinalLiveScore()
                    : item.getFinalAltScore() != null ? item.getFinalAltScore()
                    : item.getFinalEtcScore());
            excelList.add(row);
        }

        return buildExcelView(model, "학습요소참여현황", vo.getExcelGrid(), excelList);
    }

    /* ================================================================
       상세 하위 공통 구현
       ================================================================ */

    private ProcessResultVO<ClsVO> selectDetail(ClsVO vo, UserContext userCtx, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        try {
            if (ValidationUtils.isEmpty(vo.getSbjctId())) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);

            ClsVO result = clsService.selectClsDetail(vo);
            resultVO.setReturnVO(result);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private ProcessResultVO<ClsStdntInfoVO> selectStdntInfo(ClsStdntInfoVO vo, UserContext userCtx, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsStdntInfoVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

        try {
            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            ClsStdntInfoVO result = clsService.selectClsStdntInfo(vo);
            resultVO.setReturnVO(result);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private ProcessResultVO<ClsStdntVO> selectStdntWeeklyInfo(ClsStdntVO vo, UserContext userCtx, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsStdntVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

        try {
            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            ClsStdntVO result = clsService.selectClsStdntWeeklyInfo(vo);
            resultVO.setReturnVO(result);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private ProcessResultVO<ClsAccessChartVO> selectStdntAccessChart(ClsAccessChartVO vo, UserContext userCtx, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsAccessChartVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        if (ValidationUtils.isEmpty(vo.getYyyymm())) {
            vo.setYyyymm(new SimpleDateFormat("yyyyMM").format(new Date()));
        }

        try {
            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            List<ClsAccessChartVO> list = clsService.selectStdntAccessChart(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private ProcessResultVO<ClsActivityLogVO> selectStdntActivityLog(ClsActivityLogVO vo, UserContext userCtx, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsActivityLogVO> resultVO = new ProcessResultVO<>();

        applyActivityLogPagingDefaults(vo, userCtx);

        try {
            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            resultVO = clsService.selectStdntActivityLogPaging(vo);
            if (resultVO.getResult() >= 0) {
                resultVO.setResultSuccess();
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage(getCommonFailMessage());
            }
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private String downloadStdntActivityLogExcel(ClsActivityLogVO vo, UserContext userCtx, ModelMap model, boolean classroomMode) throws Exception {
        vo.setOrgId(userCtx.getOrgId());

        validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);
        validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());
        ensureActivityLogExcelGrid(vo);

        List<ClsActivityLogVO> list = clsService.selectStdntActivityLogList(vo);
        List<ListOrderedMap> excelList = new ArrayList<>();
        for (ClsActivityLogVO item : list) {
            ListOrderedMap row = new ListOrderedMap();
            row.put("lineNo", item.getLineNo());
            row.put("actDttm", item.getActDttm());
            row.put("actConts", item.getActConts());
            row.put("deviceNm", item.getDeviceNm());
            row.put("ipAddr", item.getIpAddr());
            excelList.add(row);
        }

        return buildExcelView(model, "강의실활동기록", vo.getExcelGrid(), excelList);
    }

    /* ================================================================
       주차 학습/출석/제출 이력 공통 구현
       ================================================================ */

    private ProcessResultVO<ClsWkLrnVO> selectStdntWkLrnSummary(ClsWkLrnVO vo, UserContext userCtx, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsWkLrnVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

        try {
            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);
            validateClsWkAccess(vo, false);

            ClsWkLrnVO result = clsService.selectStdntWkLrnSummary(vo);
            List<ClsChsiLrnVO> chsiList = clsService.selectStdntChsiLrnList(vo);

            if (result != null) {
                result.setChsiList(chsiList);
            }

            resultVO.setReturnVO(result);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private ProcessResultVO<ClsLrnLogVO> selectStdntLrnLog(ClsLrnLogVO vo, UserContext userCtx, HttpServletRequest request, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsLrnLogVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

        try {
            ClsWkLrnVO accessVo = new ClsWkLrnVO();
            accessVo.setOrgId(userCtx.getOrgId());
            accessVo.setSbjctId(trim(request.getParameter("sbjctId")));
            accessVo.setUserId(vo.getUserId());
            accessVo.setWkNo(parsePositiveInt(request.getParameter("wkNo")));

            validateSbjctAccess(accessVo.getSbjctId(), userCtx, classroomMode);
            validateClsWkAccess(accessVo, false);

            vo.setSbjctId(accessVo.getSbjctId());
            vo.setWkNo(accessVo.getWkNo());

            List<ClsLrnLogVO> list = clsService.selectStdntLrnLog(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private ProcessResultVO<Object> updateAtndlc(ClsWkLrnVO vo, UserContext userCtx, boolean classroomMode, boolean cancel) throws Exception {
        ProcessResultVO<Object> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        vo.setMdfrId(userCtx.getUserId());
        if (!cancel) {
            vo.setRgtrId(userCtx.getUserId());
        }

        try {
            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);
            validateClsWkAccess(vo, true);

            int cnt = cancel ? clsService.updateAtndlcCancel(vo) : clsService.updateAtndlcProcess(vo);
            if (cnt > 0) {
                resultVO.setResultSuccess();
                resultVO.setMessage(cancel ? "출석 처리가 취소되었습니다." : "출석 처리가 완료되었습니다.");
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage(cancel ? "출석 처리 취소가 실패하였습니다." : "출석 처리가 실패하였습니다.");
            }
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private ProcessResultVO<ClsChsiLrnVO> selectStdntElemSbmsnList(ClsWkLrnVO vo, UserContext userCtx, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsChsiLrnVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

        try {
            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            List<ClsChsiLrnVO> list = clsService.selectStdntElemSbmsnList(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    private ProcessResultVO<ClsAsmtSbmsnLogVO> selectStdntElemSbmsnLog(ClsAsmtSbmsnLogVO vo, UserContext userCtx, boolean classroomMode) throws Exception {
        ProcessResultVO<ClsAsmtSbmsnLogVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

        try {
            validateSbjctAccess(vo.getSbjctId(), userCtx, classroomMode);
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            List<ClsAsmtSbmsnLogVO> list = clsService.selectStdntElemSbmsnLog(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    /* ================================================================
       팝업 화면 공통 모델 구성
       ================================================================ */

    private String openNoStudyPopupView(UserContext userCtx, ModelMap model, HttpServletRequest request, boolean classroomMode, String viewName) throws Exception {
        String sbjctId = requireRequestParam(request, "sbjctId");
        String dvclasNo = getRequestParam(request, "dvclasNo");
        int wkNo = requirePositiveIntParam(request, "wkNo");

        validateSbjctAccess(sbjctId, userCtx, classroomMode);

        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("dvclasNo", dvclasNo);
        model.addAttribute("wkNo", wkNo);
        model.addAttribute("sbjctnm", SubjectInfo.getSbjctnm(request, sbjctId));

        return viewName;
    }

    private String openStdntWkPopupView(UserContext userCtx, ModelMap model, HttpServletRequest request, boolean classroomMode, String viewName) throws Exception {
        String sbjctId = requireRequestParam(request, "sbjctId");
        String dvclasNo = getRequestParam(request, "dvclasNo");
        String userId = requireRequestParam(request, "userId");
        Integer wkNo = getOptionalPositiveIntParam(request, "wkNo");

        validateSbjctAccess(sbjctId, userCtx, classroomMode);

        int wkCnt = resolveWkCnt(sbjctId, userCtx.getOrgId());

        model.addAttribute("wkCnt", wkCnt);
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("dvclasNo", dvclasNo);
        model.addAttribute("userId", userId);
        model.addAttribute("wkNo", wkNo);

        return viewName;
    }

    private String openStdntWkDetailPopupView(UserContext userCtx, ModelMap model, HttpServletRequest request, boolean classroomMode, String viewName) throws Exception {
        String sbjctId = requireRequestParam(request, "sbjctId");
        String dvclasNo = getRequestParam(request, "dvclasNo");
        String userId = requireRequestParam(request, "userId");
        int wkNo = requirePositiveIntParam(request, "wkNo");

        validateSbjctAccess(sbjctId, userCtx, classroomMode);
        int wkCnt = resolveWkCnt(sbjctId, userCtx.getOrgId());

        model.addAttribute("wkCnt", wkCnt);
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("dvclasNo", dvclasNo);
        model.addAttribute("sbjctnm", SubjectInfo.getSbjctnm(request, sbjctId));
        model.addAttribute("userId", userId);
        model.addAttribute("wkNo", wkNo);

        return viewName;
    }

    private String openStdntElemPopupView(UserContext userCtx, ModelMap model, HttpServletRequest request, boolean classroomMode, String viewName) throws Exception {
        String sbjctId = requireRequestParam(request, "sbjctId");
        String dvclasNo = getRequestParam(request, "dvclasNo");
        String userId = requireRequestParam(request, "userId");

        validateSbjctAccess(sbjctId, userCtx, classroomMode);

        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("dvclasNo", dvclasNo);
        model.addAttribute("userId", userId);

        return viewName;
    }

    /* ================================================================
       기본값/검색 공통 유틸
       ================================================================ */

    private void applyStdntListPagingDefaults(ClsStdntVO vo, UserContext userCtx) {
        vo.setOrgId(userCtx.getOrgId());
        applyPagingDefaults(vo);
    }

    private void applyElemStatsPagingDefaults(ClsElemStatsVO vo, UserContext userCtx) {
        vo.setOrgId(userCtx.getOrgId());
        applyPagingDefaults(vo);
    }

    private void applyActivityLogPagingDefaults(ClsActivityLogVO vo, UserContext userCtx) {
        vo.setOrgId(userCtx.getOrgId());
        applyPagingDefaults(vo);
    }

    private void applyPagingDefaults(ClsStdntVO vo) {
        if (vo.getPageIndex() < 1) {
            vo.setPageIndex(1);
        }
        if (vo.getListScale() <= 0) {
            vo.setListScale(DEFAULT_LIST_SCALE);
        }
        if (vo.getListScale() > 100) {
            vo.setListScale(100);
        }
        if (vo.getPageScale() <= 0) {
            vo.setPageScale(DEFAULT_PAGE_SCALE);
        }
        if (vo.getPageScale() > 20) {
            vo.setPageScale(20);
        }
    }

    private void applyPagingDefaults(ClsVO vo) {
        if (vo.getPageIndex() < 1) {
            vo.setPageIndex(1);
        }
        if (vo.getListScale() <= 0) {
            vo.setListScale(DEFAULT_LIST_SCALE);
        }
        if (vo.getListScale() > 100) {
            vo.setListScale(100);
        }
        if (vo.getPageScale() <= 0) {
            vo.setPageScale(DEFAULT_PAGE_SCALE);
        }
        if (vo.getPageScale() > 20) {
            vo.setPageScale(20);
        }
    }

    private void applyListSearchDefaults(ClsVO vo, UserContext userCtx, boolean defaultCurrentTerm) throws Exception {
        if (userCtx == null) {
            return;
        }

        vo.setUserId(userCtx.getUserId());

        SmstrChrtVO currentSemester = getCurrentSemester(userCtx.getOrgId());
        if (ValidationUtils.isEmpty(vo.getSearchYr())) {
            if (currentSemester != null && !ValidationUtils.isEmpty(currentSemester.getDgrsYr())) {
                vo.setSearchYr(currentSemester.getDgrsYr());
            } else {
                vo.setSearchYr(String.valueOf(java.time.Year.now().getValue()));
            }
        }

        if (defaultCurrentTerm
                && ValidationUtils.isEmpty(vo.getSearchSmstrCd())
                && currentSemester != null
                && vo.getSearchYr().equals(currentSemester.getDgrsYr())) {
            vo.setSearchSmstrCd(currentSemester.getDgrsSmstrChrt());
        }
    }

    private SmstrChrtVO getCurrentSemester(String orgId) throws Exception {
        SmstrChrtVO searchVO = new SmstrChrtVO();
        searchVO.setOrgId(orgId);
        return semesterService.selectCurrentSemester(searchVO);
    }

    private void applyPagingDefaults(ClsElemStatsVO vo) {
        if (vo.getPageIndex() < 1) {
            vo.setPageIndex(1);
        }
        if (vo.getListScale() <= 0) {
            vo.setListScale(DEFAULT_LIST_SCALE);
        }
        if (vo.getListScale() > 100) {
            vo.setListScale(100);
        }
        if (vo.getPageScale() <= 0) {
            vo.setPageScale(DEFAULT_PAGE_SCALE);
        }
        if (vo.getPageScale() > 20) {
            vo.setPageScale(20);
        }
    }

    private void applyPagingDefaults(ClsActivityLogVO vo) {
        if (vo.getPageIndex() < 1) {
            vo.setPageIndex(1);
        }
        if (vo.getListScale() <= 0) {
            vo.setListScale(DEFAULT_LOG_LIST_SCALE);
        }
        if (vo.getListScale() > 100) {
            vo.setListScale(100);
        }
        if (vo.getPageScale() <= 0) {
            vo.setPageScale(DEFAULT_PAGE_SCALE);
        }
        if (vo.getPageScale() > 20) {
            vo.setPageScale(20);
        }
    }

    // 주차 정보가 없거나 조회되지 않으면 기본 주차 수를 사용한다.
    private int resolveWkCnt(String sbjctId, String orgId) throws Exception {
        if (ValidationUtils.isEmpty(sbjctId)) {
            return DEFAULT_WK_CNT;
        }

        ClsVO clsVO = new ClsVO();
        clsVO.setSbjctId(sbjctId);
        clsVO.setOrgId(orgId);

        ClsVO detail = clsService.selectClsDetail(clsVO);
        return detail != null && detail.getWkCnt() > 0 ? detail.getWkCnt() : DEFAULT_WK_CNT;
    }

    /* ================================================================
       권한 검증 공통 유틸
       ================================================================ */

    private void validateClsStdntAccess(String sbjctId, String userId, String orgId) throws Exception {
        if (ValidationUtils.isEmpty(sbjctId) || ValidationUtils.isEmpty(userId)) {
            throwNoAuth();
        }

        ClsWkLrnVO accessVo = new ClsWkLrnVO();
        accessVo.setSbjctId(sbjctId);
        accessVo.setUserId(userId);
        accessVo.setOrgId(orgId);

        if (clsService.checkClsStdntAccessCnt(accessVo) <= 0) {
            throwNoAuth();
        }
    }

    // 학생의 주차 학습/출석 처리 대상에 대한 접근 가능 여부를 검증한다.
    private void validateClsWkAccess(ClsWkLrnVO vo, boolean requireSchdlId) throws Exception {
        if (ValidationUtils.isEmpty(vo.getSbjctId()) || ValidationUtils.isEmpty(vo.getUserId()) || vo.getWkNo() <= 0) {
            throwNoAuth();
        }

        if (requireSchdlId && ValidationUtils.isEmpty(vo.getLctrWknoSchdlId())) {
            throwNoAuth();
        }

        if (clsService.checkClsStdntAccessCnt(vo) <= 0) {
            throwNoAuth();
        }

        if (!ValidationUtils.isEmpty(vo.getLctrWknoSchdlId()) && clsService.checkClsWkSchdlAccessCnt(vo) <= 0) {
            throwNoAuth();
        }
    }

    // 메뉴 컨텍스트에 따라 일반 화면 또는 강의실 화면 권한 검증으로 분기한다.
    private void validateSbjctAccess(String sbjctId, UserContext userCtx, boolean classroomMode) throws Exception {
        if (classroomMode) {
            validateCrsClsSbjctAccess(sbjctId, userCtx);
        } else {
            validateClsSbjctAccess(sbjctId, userCtx);
        }
    }

    // 일반 수업현황 접근 권한을 검증한다.
    private void validateClsSbjctAccess(String sbjctId, UserContext userCtx) throws Exception {
        validateSbjctAccessArgs(sbjctId, userCtx);
        if (!hasProfessorSubjectAuthority(sbjctId, userCtx)) {
            throwNoAuth();
        }
    }

    // 강의실 수업현황 접근 권한을 검증한다.
    private void validateCrsClsSbjctAccess(String sbjctId, UserContext userCtx) throws Exception {
        validateSbjctAccessArgs(sbjctId, userCtx);
        if (!hasProfessorSubjectAuthority(sbjctId, userCtx)) {
            throwNoAuth();
        }
    }

    private boolean hasProfessorSubjectAuthority(String sbjctId, UserContext userCtx) {
        SubjectDTO sbjctDto = new SubjectDTO();
        sbjctDto.setSbjctId(sbjctId);
        sbjctDto.setProfIds(
            userCtx.getProfIds() == null || userCtx.getProfIds().isEmpty()
                ? Collections.singletonList(userCtx.getUserId())
                : userCtx.getProfIds()
        );
        return subjectService.hasSubjectAuthority(sbjctDto);
    }

    private void validateSbjctAccessArgs(String sbjctId, UserContext userCtx) throws AccessDeniedException {
        if (ValidationUtils.isEmpty(sbjctId) || userCtx == null || ValidationUtils.isEmpty(userCtx.getUserId())) {
            throwNoAuth();
        }
    }

    private void throwNoAuth() throws AccessDeniedException {
        throw new AccessDeniedException(getCommonNoAuthMessage());
    }

    /* ================================================================
       엑셀/출력 공통 유틸
       ================================================================ */

    private String buildExcelView(ModelMap model, String title, String excelGrid, List<ListOrderedMap> list) throws Exception {
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", excelGrid);
        map.put("list", list);
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
       엑셀 그리드 공통 유틸
       ================================================================ */

    private void ensureElemExcelGrid(ClsElemStatsVO vo) {
        if (vo.getExcelGrid() != null && !vo.getExcelGrid().trim().isEmpty()) {
            return;
        }

        vo.setExcelGrid(
                "{\"colModel\":["
                        + "{\"label\":\"No\",\"name\":\"lineNo\",\"align\":\"center\",\"width\":\"3000\"},"
                        + "{\"label\":\"학과\",\"name\":\"deptnm\",\"align\":\"center\",\"width\":\"7000\"},"
                        + "{\"label\":\"대표아이디\",\"name\":\"userId\",\"align\":\"center\",\"width\":\"7000\"},"
                        + "{\"label\":\"학번\",\"name\":\"stdntNo\",\"align\":\"center\",\"width\":\"7000\"},"
                        + "{\"label\":\"이름\",\"name\":\"usernm\",\"align\":\"center\",\"width\":\"6000\"},"
                        + "{\"label\":\"Q&A(답변/등록)\",\"name\":\"qaText\",\"align\":\"center\",\"width\":\"6000\"},"
                        + "{\"label\":\"토론방(댓글수)\",\"name\":\"talkReplyCnt\",\"align\":\"center\",\"width\":\"4000\"},"
                        + "{\"label\":\"과제(제출/전체)\",\"name\":\"asmtText\",\"align\":\"center\",\"width\":\"6000\"},"
                        + "{\"label\":\"퀴즈(제출/전체)\",\"name\":\"quizText\",\"align\":\"center\",\"width\":\"6000\"},"
                        + "{\"label\":\"설문(제출/전체)\",\"name\":\"srvyText\",\"align\":\"center\",\"width\":\"6000\"},"
                        + "{\"label\":\"토론(제출/전체)\",\"name\":\"dscsText\",\"align\":\"center\",\"width\":\"6000\"},"
                        + "{\"label\":\"중간고사\",\"name\":\"midScore\",\"align\":\"center\",\"width\":\"4000\"},"
                        + "{\"label\":\"기말고사\",\"name\":\"finalScore\",\"align\":\"center\",\"width\":\"4000\"}"
                        + "]}"
        );
    }

    private void ensureActivityLogExcelGrid(ClsActivityLogVO vo) {
        if (vo.getExcelGrid() != null && !vo.getExcelGrid().trim().isEmpty()) {
            return;
        }

        vo.setExcelGrid(
                "{\"colModel\":["
                        + "{\"label\":\"No\",\"name\":\"lineNo\",\"align\":\"center\",\"width\":\"3000\"},"
                        + "{\"label\":\"일시\",\"name\":\"actDttm\",\"align\":\"center\",\"width\":\"8000\"},"
                        + "{\"label\":\"활동 내용\",\"name\":\"actConts\",\"align\":\"left\",\"width\":\"8000\"},"
                        + "{\"label\":\"접근 장비\",\"name\":\"deviceNm\",\"align\":\"center\",\"width\":\"5000\"},"
                        + "{\"label\":\"IP\",\"name\":\"ipAddr\",\"align\":\"center\",\"width\":\"6000\"}"
                        + "]}"
        );
    }

    private String getAttendanceStatusText(String status) {
        if ("ATND".equals(status)) {
            return "\u25CB";
        }
        if ("LATE".equals(status)) {
            return "\u25B3";
        }
        if ("ABSNT".equals(status)) {
            return "X";
        }
        if ("NOTSTARTED".equals(status) || "STUDY".equals(status)) {
            return "미학습";
        }
        return "-";
    }

    private String buildSubjectName(String sbjctnm, String dvclasNo) {
        StringBuilder builder = new StringBuilder();
        if (!ValidationUtils.isEmpty(sbjctnm)) {
            builder.append(sbjctnm);
        }
        if (!ValidationUtils.isEmpty(dvclasNo)) {
            if (builder.length() > 0) {
                builder.append(' ');
            }
            builder.append(dvclasNo).append("반");
        }
        return builder.toString();
    }

    /* ================================================================
       파라미터 공통 유틸
       ================================================================ */

    private String getRequestParam(HttpServletRequest request, String name) {
        return trim(request.getParameter(name));
    }

    private String requireRequestParam(HttpServletRequest request, String name) throws BadRequestUrlException {
        String value = getRequestParam(request, name);
        if (ValidationUtils.isEmpty(value)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        return value;
    }

    private Integer getOptionalPositiveIntParam(HttpServletRequest request, String name) throws BadRequestUrlException {
        String value = getRequestParam(request, name);
        return ValidationUtils.isEmpty(value) ? null : parsePositiveInt(value);
    }

    private int requirePositiveIntParam(HttpServletRequest request, String name) throws BadRequestUrlException {
        return parsePositiveInt(requireRequestParam(request, name));
    }

    private int parsePositiveInt(String value) throws BadRequestUrlException {
        String trimmed = trim(value);
        if (ValidationUtils.isEmpty(trimmed)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        try {
            int parsed = Integer.parseInt(trimmed);
            if (parsed <= 0) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            return parsed;
        } catch (NumberFormatException e) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
