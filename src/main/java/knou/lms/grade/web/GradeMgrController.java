package knou.lms.grade.web;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.*;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.crs.service.CrsService;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.grade.service.GradeService;
import knou.lms.grade.vo.GradeStdScoreItemVO;
import knou.lms.grade.vo.GradeVO;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.score.service.ScoreOverallService;
import knou.lms.score.vo.ScoreOverallVO;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Controller
public class GradeMgrController extends ControllerBase {
    private static final Logger LOGGER = LoggerFactory.getLogger(GradeMgrController.class);

    @Autowired
    private CrsService crsService;

    @Autowired
    private GradeService gradeService;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;

    @Resource(name="termService")
    private TermService termService;

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="stdService")
    private StdService stdService;

    @Resource(name="scoreOverallService")
    private ScoreOverallService scoreOverallService;

    /*****************************************************
     * TODO 성적평가관리 > 성적평가 구분조회
     * @param GradeVO
     * @return "grade/mgr/grade_evl_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeEvlList.do")
    public String gradeEvlList(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));

        request.setAttribute("orgId", SessionInfo.getOrgId(request));
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "grade/mgr/grade_evl_list";
    }

    @RequestMapping(value="/grade/gradeMgr/selectTermList.do")
    @ResponseBody
    public ProcessResultVO<GradeVO> selectTermList(HttpServletRequest request, HttpServletResponse response, ModelMap model, GradeVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        return gradeService.selectTermList(vo);
    }

    @RequestMapping(value="/grade/gradeMgr/selectDeptList.do")
    @ResponseBody
    public ProcessResultVO<GradeVO> selectDeptList(HttpServletRequest request, HttpServletResponse response, ModelMap model, GradeVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        return gradeService.selectDeptList(vo);
    }

    @RequestMapping(value="/grade/gradeMgr/selectEvlList.do")
    @ResponseBody
    public ProcessResultVO<GradeVO> selectEvlList(HttpServletRequest request, HttpServletResponse response, ModelMap model, GradeVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        return gradeService.selectEvlList(vo);
    }

    @RequestMapping(value="/grade/gradeMgr/multiEvlList.do")
    @ResponseBody
    public ProcessResultVO<GradeVO> multiEvlList(GradeVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));
        return gradeService.multiEvlList(vo);
    }

    @RequestMapping(value="/grade/gradeMgr/selectEvlExcelDown.do")
    public String selectEvlExcelDown(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적평가구분조회");       // 성적평가구분조회
        map.put("sheetName", "성적평가구분조회");   // 성적평가구분조회
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", gradeService.selectEvlExcelList(vo));

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", "성적평가구분조회");    // 성적평가구분조회

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * TODO 성적평가관리 > 평가기준
     * @param GradeVO
     * @return "grade/mgr/grade_evl_standard_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeEvlStandardList.do")
    public String gradeEvlStandardList(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));

        request.setAttribute("orgId", SessionInfo.getOrgId(request));
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "grade/mgr/grade_evl_standard_list";
    }

    /*****************************************************
     * TODO 성적평가관리 > 평가기준 시행현황
     * @param GradeVO
     * @return "grade/mgr/grade_evl_standard_plan_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeEvlStandardPlanList.do")
    public String gradeEvlStandardPlanList(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        CreCrsVO vo1 = new CreCrsVO();

        vo1.setOrgId(SessionInfo.getOrgId(request));

        List<OrgCodeVO> orgList = crsService.selectOrgCodeList(vo1);

        model.addAttribute("orgList", orgList);
        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "grade/mgr/grade_evl_standard_plan_list";
    }

    /***************************************************** 
     * TODO 평가기준 시행현황 엑셀다운로드
     * @param GradeVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeEvlStandardPlanExcelDown.do")
    public String gradeEvlStandardPlanExcelDown(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        vo.setOrgId(SessionInfo.getOrgId(request));

        ProcessResultVO<EgovMap> resultList = gradeService.selectEvlStandardListByEgov(vo);

        String[] searchValues = {};

        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map1 = new HashMap<String, Object>();
        map1.put("title", messageSource.getMessage("crs.label.eval.criteria.plan", null, locale));          // 평가기준 시행현황
        map1.put("sheetName", messageSource.getMessage("crs.label.eval.criteria.plan", null, locale));      // 평가기준 시행현황
        map1.put("searchValues", searchValues);
        map1.put("excelGrid", vo.getExcelGrid());
        map1.put("list", resultList.getReturnList());

        HashMap<String, Object> modelMap1 = new HashMap<String, Object>();
        modelMap1.put("outFileName", messageSource.getMessage("crs.label.eval.criteria.plan", null, locale));  // 평가기준 시행현황
        modelMap1.put("sheetName", messageSource.getMessage("crs.label.eval.criteria.plan", null, locale));    // 평가기준 시행현황
        modelMap1.put("list", resultList.getReturnList());

        //엑셀화
        modelMap1.put("workbook", makeGradePlanExcel(map1, request));
        model.addAllAttributes(modelMap1);

        return "excelView";
    }

    @RequestMapping(value="/grade/gradeMgr/selectEvlStandardList.do")
    @ResponseBody
    public ProcessResultVO<GradeVO> selectEvlStandardList(HttpServletRequest request, HttpServletResponse response, ModelMap model, GradeVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        return gradeService.selectEvlStandardList(vo);
    }

    @RequestMapping(value="/grade/gradeMgr/selectStdScoreItemConfInfo.do")
    @ResponseBody
    public ProcessResultVO<GradeVO> selectStdScoreItemConfList(HttpServletRequest request, HttpServletResponse response, ModelMap model, GradeVO vo) throws Exception {
        return gradeService.selectStdScoreItemConfInfo(vo);
    }

    @RequestMapping(value="/grade/gradeMgr/gradeEvlRegPopup.do")
    public String gradeEvlRegPopup(GradeVO vo, Map commandMap, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("vo", vo);
        return "grade/mgr/grade_evl_reg_popup";
    }

    @RequestMapping(value="/grade/gradeMgr/selectEvlReg.do")
    @ResponseBody
    public ProcessResultVO<GradeStdScoreItemVO> selectEvlReg(HttpServletRequest request, HttpServletResponse response, ModelMap model, GradeVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        ProcessResultVO<GradeStdScoreItemVO> resultVo = gradeService.selectEvlReg(vo);
        return resultVo;
    }

    @RequestMapping(value="/grade/gradeMgr/multiEvlPopReg.do")
    @ResponseBody
    public ProcessResultVO<GradeStdScoreItemVO> multiEvlPopReg(GradeVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));
        ProcessResultVO<GradeStdScoreItemVO> resultVo = gradeService.multiEvlPopReg(vo);
        return resultVo;
    }

    @RequestMapping(value="/grade/gradeMgr/gradeAsmntList.do")
    public String gradeAsmntList(GradeVO vo, Map commandMap, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("vo", vo);
        return "grade/mgr/grade_evl_standard_asmnt";

    }

    @RequestMapping(value="/grade/gradeMgr/gradeForumList.do")
    public String gradeForumList(GradeVO vo, Map commandMap, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("vo", vo);
        return "grade/mgr/grade_evl_standard_forum";
    }

    @RequestMapping(value="/grade/gradeMgr/gradeExamList.do")
    public String gradeExamList(GradeVO vo, Map commandMap, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("vo", vo);
        return "grade/mgr/grade_evl_standard_exam";
    }

    @RequestMapping(value="/grade/gradeMgr/gradeQuizList.do")
    public String gradeQuizList(GradeVO vo, Map commandMap, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("vo", vo);
        return "grade/mgr/grade_evl_standard_quiz";
    }

    @RequestMapping(value="/grade/gradeMgr/gradeReconfirmList1.do")
    public String gradeReconfirmList1(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "grade/mgr/grade_reconfirm_list1";
    }

    @RequestMapping(value="/grade/gradeMgr/selectCreCrsList.do")
    @ResponseBody
    public ProcessResultVO<GradeVO> selectCreCrsList(HttpServletRequest request, HttpServletResponse response, ModelMap model, GradeVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        return gradeService.selectCreCrsList(vo);
    }

    @RequestMapping(value="/grade/gradeMgr/gradeReconfirmList2.do")
    public String gradeReconfirmList2(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "grade/mgr/grade_reconfirm_list2";
    }

    @RequestMapping(value="/grade/gradeMgr/gradeReconfirmList3.do")
    public String gradeReconfirmList3(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "grade/mgr/grade_reconfirm_list3";
    }

    @RequestMapping(value="/grade/gradeMgr/gradeLessonList.do")
    public String gradeLessonList(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));

        request.setAttribute("orgId", SessionInfo.getOrgId(request));
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "grade/mgr/grade_lesson_list";
    }

    @RequestMapping(value="/grade/gradeMgr/gradeStudent.do")
    public String gradeStudent(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        request.setAttribute("termVO", termVO);
        request.setAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        request.setAttribute("orgId", SessionInfo.getOrgId(request));
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "grade/mgr/grade_student";
    }

    /*****************************************************
     * TODO 성적평가관리 > 성적 입력 현황
     * @param GradeVO
     * @return "grade/mgr/grade_input_status_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeInputStatusList.do")
    public String gradeInputStatusList(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(SessionInfo.getOrgId(request));
        request.setAttribute("usrDeptCdList", usrDeptCdService.list(usrDeptCdVO));

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);

        request.setAttribute("termVO", termVO);
        request.setAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        request.setAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        request.setAttribute("orgId", SessionInfo.getOrgId(request));
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "grade/mgr/grade_input_status_list";
    }

    /*****************************************************
     * 성적평가관리 > 성적 입력 현황 > 과목 목록
     * @param GradeVO
     * @return ProcessResultVO<GradeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeInputCreCrsList.do")
    @ResponseBody
    public ProcessResultVO<GradeVO> gradeInputCreCrsList(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<GradeVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);

            if(!"".equals(StringUtil.nvl(vo.getCrsTypeCd()))) {
                String[] crsTypeCds = vo.getCrsTypeCd().split("\\,");
                vo.setCrsTypeCds(crsTypeCds);
            }
            List<GradeVO> resultList = gradeService.listCreCrsGradeStatus(vo);

            resultVO.setReturnList(resultList);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /***************************************************** 
     * 성적 입력 현황 과목 엑셀다운로드
     * @param GradeVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeCreCrsStatusExcelDown.do")
    public String gradeCreCrsStatusExcelDown(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = SessionInfo.getOrgId(request);

        vo.setOrgId(orgId);
        vo.setMdfrId(userId);
        vo.setRgtrId(userId);
        vo.setPagingYn("N");

        List<GradeVO> list = gradeService.listCreCrsGradeStatus(vo);

        String[] searchValues = {};

        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map1 = new HashMap<String, Object>();
        map1.put("title", messageSource.getMessage("common.subject.list", null, locale));  // 과목 목록
        map1.put("sheetName", messageSource.getMessage("common.subject.list", null, locale));   // 과목 목록
        map1.put("searchValues", searchValues);
        map1.put("excelGrid", vo.getExcelGrid());
        map1.put("list", list);

        HashMap<String, Object> modelMap1 = new HashMap<String, Object>();
        modelMap1.put("outFileName", messageSource.getMessage("common.subject.list", null, locale));  // 과목 목록
        modelMap1.put("sheetName", messageSource.getMessage("common.subject.list", null, locale));    // 과목 목록
        modelMap1.put("list", list);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap1.put("workbook", excelUtilPoi.simpleBigGrid(map1));
        model.addAllAttributes(modelMap1);

        return "excelView";
    }

    /*****************************************************
     * TODO 성적평가관리 > 성적 입력 현황 > 수강생 목록 / 성적처리 현황 팝업
     * @param GradeVO
     * @return "grade/mgr/grade_status_popup"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeStatusPopup.do")
    public String gradeStatusPopup(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);
        request.setAttribute("stdList", gradeService.listStdGradeStatus(vo));

        return "grade/mgr/grade_status_popup";
    }

    /***************************************************** 
     * TODO 성적 입력 현황 학습자 엑셀다운로드
     * @param GradeVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeStdStatusExcelDown.do")
    public String gradeStdStatusExcelDown(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setMdfrId(userId);
        vo.setRgtrId(userId);
        vo.setPagingYn("N");

        String[] searchValues = {};

        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map1 = new HashMap<String, Object>();
        map1.put("title", messageSource.getMessage("common.student.list", null, locale));  // 수강생 목록
        map1.put("sheetName", messageSource.getMessage("common.student.list", null, locale));   // 수강생 목록
        map1.put("searchValues", searchValues);
        map1.put("excelGrid", vo.getExcelGrid());
        map1.put("list", gradeService.listStdGradeStatus(vo));

        HashMap<String, Object> modelMap1 = new HashMap<String, Object>();
        modelMap1.put("outFileName", messageSource.getMessage("common.student.list", null, locale));  // 수강생 목록
        modelMap1.put("sheetName", messageSource.getMessage("common.student.list", null, locale));    // 수강생 목록
        modelMap1.put("list", gradeService.listStdGradeStatus(vo));

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap1.put("workbook", excelUtilPoi.simpleBigGrid(map1));
        model.addAllAttributes(modelMap1);

        return "excelView";
    }

    /*****************************************************
     * TODO 성적평가관리 > 성적 입력 현황 > 항목별 점수 팝업
     * @param GradeVO
     * @return "grade/mgr/grade_detail_popup"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeDetailPopup.do")
    public String gradeDetailPopup(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        StdVO stdVO = new StdVO();
        stdVO.setStdId(vo.getStdNo());
        stdVO = stdService.select(stdVO);
        request.setAttribute("stdVO", stdVO);

        ProcessResultVO<GradeVO> resultVO = gradeService.selectStdScoreItemConfInfo(vo);
        request.setAttribute("gradeVo", resultVO.getReturnVO());

        ScoreOverallVO sovo = new ScoreOverallVO();
        sovo.setCrsCreCd(vo.getCrsCreCd());
        sovo.setStdId(vo.getStdNo());
        sovo = scoreOverallService.selectStdDetailScore(sovo);
        request.setAttribute("sovo", sovo);

        return "grade/mgr/grade_detail_popup";
    }

    /*****************************************************
     * 성적평가관리 > 성적 입력 현황 > ViewLog 팝업
     * @param GradeVO
     * @return "grade/mgr/grade_view_log_popup"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeViewLogPopup.do")
    public String gradeViewLogPopup(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);

        return "grade/mgr/grade_view_log_popup";
    }

    /*****************************************************
     * TODO 성적평가관리 > 성적 입력
     * @param GradeVO
     * @return "grade/mgr/grade_input"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeInput.do")
    public String gradeInput(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(SessionInfo.getOrgId(request));
        
        request.setAttribute("usrDeptCdList", usrDeptCdService.list(usrDeptCdVO));

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);

        request.setAttribute("termVO", termVO);
        request.setAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        request.setAttribute("orgId", SessionInfo.getOrgId(request));
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        request.setAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "grade/mgr/grade_input";
    }

    /*****************************************************
     * TODO 성적평가관리 > 성적입력기간 예외처리
     * @param GradeVO
     * @return "grade/mgr/grade_input_exc"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeInputExc.do")
    public String gradeInputExc(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(SessionInfo.getOrgId(request));
        
        request.setAttribute("usrDeptCdList", usrDeptCdService.list(usrDeptCdVO));
        request.setAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        request.setAttribute("termVO", termVO);
        request.setAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        request.setAttribute("orgId", SessionInfo.getOrgId(request));
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "grade/mgr/grade_input_exc";
    }

    /*****************************************************
     * 성적평가관리 > 성적입력기간 예외처리 > 과목 목록
     * @param GradeVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeInputExcCrsCreList.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> gradeInputExcCrsCreList(GradeVO vo, HttpServletRequest request, ModelMap model) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);

            resultVO = gradeService.listGradeInputExc(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 성적평가관리 > 성적입력기간 예외처리 > 성적입력기간 저장
     * @param GradeVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/saveGradeInputExc.do")
    @ResponseBody
    public ProcessResultVO<GradeVO> saveGradeInputExc(HttpServletRequest request, HttpServletResponse response, ModelMap model, GradeVO vo) throws Exception {
        ProcessResultVO<GradeVO> resultVO = new ProcessResultVO<GradeVO>();
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            gradeService.saveGradeInputExc(vo);

            resultVO.setResult(1);
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다.
        }
        return resultVO;
    }

    /*****************************************************
     * TODO 성적평가관리 > 성적입력기간 예외처리 > 로그 팝업
     * @param GradeVO
     * @return "grade/mgr/popup/grade_input_exc_log_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeInputExcLogPopup.do")
    public String gradeInputExcLogPopup(GradeVO vo, Map commandMap, ModelMap model, HttpServletRequest request) throws Exception {
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(SessionInfo.getOrgId(request));
        
        request.setAttribute("usrDeptCdList", usrDeptCdService.list(usrDeptCdVO));
        request.setAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));
        request.setAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        request.setAttribute("orgId", StringUtil.nvl(SessionInfo.getOrgId(request)));
        request.setAttribute("vo", vo);

        return "grade/mgr/popup/grade_input_exc_log_pop";
    }

    /***************************************************** 
     * TODO 성적평가관리 > 성적입력기간 예외처리 > 과목 목록 엑셀다운로드
     * @param GradeVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/grade/gradeMgr/gradeInputExcCrsCreListExcelDown.do")
    public String gradeInputExcCrsCreListExcelDown(GradeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setPagingYn("N");

        ProcessResultVO<EgovMap> resultList = gradeService.listGradeInputExc(vo);

        /*
         * List<GradeVO> listExc = new ArrayList<>();
         *
         * for (EgovMap egovMap : resultList) { GradeVO listInfo = new GradeVO(); for
         * (Field field : GradeVO.class.getDeclaredFields()) {
         * field.setAccessible(true); String fieldName = field.getName(); Object value =
         * egovMap.get(fieldName); if (value != null) { field.set(listInfo, value); } }
         * listExc.add(listInfo); }
         */

        String[] searchValues = {};

        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map1 = new HashMap<String, Object>();
        map1.put("title", messageSource.getMessage("score.label.grade.input.date.exc", null, locale));          // 성적입력기간 예외처리
        map1.put("sheetName", messageSource.getMessage("score.label.grade.input.date.exc", null, locale));      // 성적입력기간 예외처리
        map1.put("searchValues", searchValues);
        map1.put("excelGrid", vo.getExcelGrid());
        map1.put("list", resultList.getReturnList());

        HashMap<String, Object> modelMap1 = new HashMap<String, Object>();
        modelMap1.put("outFileName", messageSource.getMessage("score.label.grade.input.date.exc", null, locale));  // 성적입력기간 예외처리
        modelMap1.put("sheetName", messageSource.getMessage("score.label.grade.input.date.exc", null, locale));    // 성적입력기간 예외처리
        modelMap1.put("list", resultList.getReturnList());

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap1.put("workbook", excelUtilPoi.simpleBigGrid(map1));
        model.addAllAttributes(modelMap1);

        return "excelView";
    }

    /***************************************************** 
     * TODO 평가기준 시행현황  엑셀 생성.
     * @param dataMap
     * @return workbook
     * @throws Exception
     ******************************************************/
    public Workbook makeGradePlanExcel(Map<String, Object> dataMap, HttpServletRequest request) throws Exception {
        String title = StringUtil.nvl(dataMap.get("title"));
        String sheetName = StringUtil.nvl(dataMap.get("sheetName"), "sheet1");
        String excelGrid = StringUtil.nvl(dataMap.get("excelGrid"));
        List<?> list = (List<?>) dataMap.get("list");

        Map<String, Object> excelGridMap = null;
        try {
            excelGridMap = (HashMap<String, Object>) JsonUtil.jsonToMap(excelGrid);
        } catch(Exception e) {
            e.printStackTrace();
        }

        List colModelList = (List) excelGridMap.get("colModel");

        String ext = StringUtil.nvl(dataMap.get("ext"));
        if(StringUtil.isNull(ext)) {
            ext = ".xlsx";
        }

        Workbook workbook = null;
        if(".xls".equals(ext)) {
            workbook = new HSSFWorkbook();
        } else if(".xlsx".equals(ext)) {
            workbook = new XSSFWorkbook();
        }

        Sheet worksheet = null;
        Row row = null;
        Cell cell = null;

        //타이틀 폰트 설정
        Font titleFont = workbook.createFont();
        titleFont.setFontHeight((short) (16 * 25)); //사이즈
        titleFont.setBold(true);
        titleFont.setFontName("맑은 고딕");

        //헤더 폰트 설정
        Font headerFont = workbook.createFont();
        headerFont.setFontHeight((short) (16 * 14)); //사이즈
        headerFont.setBold(true);
        headerFont.setFontName("맑은 고딕");

        //답변 폰트 설정(헤더가 아닌 나머지 row)
        Font rowFont = workbook.createFont();
        rowFont.setFontHeight((short) (16 * 14)); //사이즈
        rowFont.setBold(false);
        rowFont.setFontName("맑은 고딕");

        Font overFont = workbook.createFont();
        overFont.setFontHeight((short) (16 * 14)); //사이즈
        overFont.setBold(false);
        overFont.setColor(HSSFColor.HSSFColorPredefined.BLUE.getIndex());
        overFont.setFontName("맑은 고딕");

        Font nonFont = workbook.createFont();
        nonFont.setFontHeight((short) (16 * 14)); //사이즈
        nonFont.setBold(false);
        nonFont.setColor(HSSFColor.HSSFColorPredefined.RED.getIndex());
        nonFont.setFontName("맑은 고딕");

        // 타이틀 셀 스타일 및 폰트 설정
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setAlignment(HorizontalAlignment.LEFT);
        titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        titleStyle.setBorderRight(BorderStyle.NONE);
        titleStyle.setBorderLeft(BorderStyle.NONE);
        titleStyle.setBorderTop(BorderStyle.NONE);
        titleStyle.setBorderBottom(BorderStyle.NONE);
        titleStyle.setFont(titleFont);

        // 헤더 셀 스타일 및 폰트 설정
        HSSFCellStyle styleHeaderHSS = null;
        XSSFCellStyle styleHeaderXSS = null;
        if(workbook instanceof HSSFWorkbook) {
            styleHeaderHSS = (HSSFCellStyle) workbook.createCellStyle();
            styleHeaderHSS.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
            styleHeaderHSS.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
            styleHeaderHSS.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            styleHeaderHSS.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            styleHeaderHSS.setBorderRight(BorderStyle.THIN);
            styleHeaderHSS.setBorderLeft(BorderStyle.THIN);
            styleHeaderHSS.setBorderTop(BorderStyle.THIN);
            styleHeaderHSS.setBorderBottom(BorderStyle.THIN);
            styleHeaderHSS.setFont(headerFont);
        } else {
            styleHeaderXSS = (XSSFCellStyle) workbook.createCellStyle();
            styleHeaderXSS.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
            styleHeaderXSS.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
            styleHeaderXSS.setFillForegroundColor(new XSSFColor(new java.awt.Color(192, 192, 192)));
            styleHeaderXSS.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            styleHeaderXSS.setBorderRight(BorderStyle.THIN);
            styleHeaderXSS.setBorderLeft(BorderStyle.THIN);
            styleHeaderXSS.setBorderTop(BorderStyle.THIN);
            styleHeaderXSS.setBorderBottom(BorderStyle.THIN);
            styleHeaderXSS.setFont(headerFont);
        }

        // 답변  셀 스타일 및 폰트 설정
        CellStyle rowStyle = workbook.createCellStyle();
        rowStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        rowStyle.setBorderRight(BorderStyle.THIN);
        rowStyle.setBorderLeft(BorderStyle.THIN);
        rowStyle.setBorderTop(BorderStyle.THIN);
        rowStyle.setBorderBottom(BorderStyle.THIN);
        rowStyle.setAlignment(HorizontalAlignment.CENTER);

        CellStyle rowNonStyle = workbook.createCellStyle();
        rowNonStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        rowNonStyle.setBorderRight(BorderStyle.THIN);
        rowNonStyle.setBorderLeft(BorderStyle.THIN);
        rowNonStyle.setBorderTop(BorderStyle.THIN);
        rowNonStyle.setBorderBottom(BorderStyle.THIN);
        rowNonStyle.setAlignment(HorizontalAlignment.CENTER);
        rowNonStyle.setFont(nonFont);

        CellStyle rowOverStyle = workbook.createCellStyle();
        rowOverStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        rowOverStyle.setBorderRight(BorderStyle.THIN);
        rowOverStyle.setBorderLeft(BorderStyle.THIN);
        rowOverStyle.setBorderTop(BorderStyle.THIN);
        rowOverStyle.setBorderBottom(BorderStyle.THIN);
        rowOverStyle.setAlignment(HorizontalAlignment.CENTER);
        rowOverStyle.setFont(overFont);


        // 새로운 sheet를 생성한다.
        worksheet = workbook.createSheet(sheetName);
        if(colModelList != null) {
            for(int i = 0; i < colModelList.size(); i++) {
                HashMap<String, Object> columnInfo = (HashMap<String, Object>) colModelList.get(i);
                worksheet.setColumnWidth(i, Integer.parseInt(StringUtil.nvl(columnInfo.get("width"), "0")));
            }
        }

        // title
        int rowNum = -1;
        row = worksheet.createRow(++rowNum);
        row.createCell(0).setCellValue(title);
        row.getCell(0).setCellStyle(titleStyle);
        row = worksheet.createRow(++rowNum); // 빈 row

        //header
        row = worksheet.createRow(++rowNum);

        if(colModelList != null) {
            for(int i = 0; i < colModelList.size(); i++) {
                HashMap<String, Object> columnInfo = (HashMap<String, Object>) colModelList.get(i);
                row.createCell(i).setCellValue(StringUtil.nvl(columnInfo.get("label")));
                if(workbook instanceof HSSFWorkbook) {
                    row.getCell(i).setCellStyle(styleHeaderHSS);
                } else {
                    row.getCell(i).setCellStyle(styleHeaderXSS);
                }
            }
        }

        // 평가기준 시행현황
        if(list != null && !list.isEmpty() && list.size() > 0) {
            for(int i = 0; i < list.size(); i++) {
                row = worksheet.createRow(++rowNum);
                EgovMap gvo = (EgovMap) list.get(i);
                if(colModelList != null) {
                    for(int j = 0; j < colModelList.size(); j++) {
                        HashMap<String, Object> columnInfo = (HashMap<String, Object>) colModelList.get(j);
                        String cellValue = StringUtil.nvl(gvo.get(StringUtil.nvl(columnInfo.get("name"))));
                        if("".equals(cellValue)) cellValue = "-";
                        String columnNm = StringUtil.nvl(columnInfo.get("name"));
                        cell = row.createCell(j);
                        cell.setCellValue(cellValue);
                        if(columnNm.indexOf("Cnt") > -1) {
                            String name = StringUtil.nvl(columnNm.substring(0, columnNm.indexOf("Cnt")));
                            if("asmt".equals(name) && gvo.get(name + "ScoreRatio") == null) {
                                name = "assignment";
                            }

                            String ratioStr = StringUtil.nvl(gvo.get(name + "ScoreRatio"));

                            if("-".equals(ratioStr)) {
                                if(Integer.parseInt(cellValue) > 0) {
                                    cell.setCellStyle(rowOverStyle);
                                } else {
                                    cell.setCellStyle(rowStyle);
                                }
                            } else {
                                if(Integer.parseInt(cellValue) == 0) {
                                    cell.setCellStyle(rowNonStyle);
                                } else {
                                    cell.setCellStyle(rowStyle);
                                }
                            }
                        } else {
                            cell.setCellStyle(rowStyle);
                        }
                    }
                }
            }
        }

        return workbook;
    }

}