package knou.lms.statistics.web.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.lesson.web.LessonMgrController;
import knou.lms.org.service.OrgCodeService;
import knou.lms.statistics.facade.StatisticsFacadeService;
import knou.lms.statistics.service.StatisticsService;
import knou.lms.statistics.vo.StatisticsVO;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

//TODO: 추후 상위요청경로"/stats"로 모두 통일
@Controller
@RequestMapping(value = {"/statistics/statisticsMgr", "/stats"} )
public class StatisticsController extends ControllerBase {
	
	 private static final Logger LOGGER = LoggerFactory.getLogger(LessonMgrController.class);
	
	@Resource(name="statisticsFacadeService")
	private StatisticsFacadeService statisticsFacadeService;
	
//	ASIS ==============================
    
    @Resource(name="statisticsService")
    private StatisticsService statisticsService;
    
    @Resource(name= "termService")
    private TermService termService;
    
    @Resource(name= "usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;
    
    @Resource(name= "orgCodeService")
    private OrgCodeService orgCodeService;
    
    /**
     * 교수 대시보드 > 학습진도관리
     * 
     * @return learn_progress_list_view.jsp
     * @throws Exception
     */
    @RequestMapping("/profLrnPrgrtListView.do")
    public String profLrnPrgrtListView (HttpServletRequest request, Model model)throws Exception {
    	
    	UserContext userCtx = new UserContext( 	SessionInfo.getOrgId(request),
				SessionInfo.getUserId(request),
				SessionInfo.getAuthrtCd(request),
				SessionInfo.getAuthrtGrpcd(request),
				SessionInfo.getUserRprsId(request),
				SessionInfo.getLastLogin(request));
    	
//    	UserContext userCtx = (UserContext)request.getSession().getAttribute("USER_CONTEXT");
    	
    	if(!userCtx.getAuthrtGrpcd().equals("PROF")) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }
    	
    	// 조회필터옵션 세팅
    	EgovMap filterOptions = statisticsFacadeService.loadFilterOptions(userCtx);
    	model.addAttribute("filterOptions", filterOptions);
    	
    	return "statistics/learn_progress_list_view";
//    	return "statistics/learn_progress_list_view_backup";
    }
    
    /**
     * 전체/운영과목에 대한 수강생 수, 평균학습진도율을 조회한다.
     * 
     * @param sbjctYr		학위연도
     * @param smstrChrtId	학기기수아이디
     * @param orgId			기관아이디
     * @param deptId		학과부서아이디
     * @param sbjctOfrngId	과목개설아이디
     * @param searchKey		검색키 ("Y"/"")
     * @param searchFrom	출석율 하한 경계값
     * @param searchTo		출석율 상한 경계값
     * @return 전체/운영과목 수강생 수, 평균학습진도율
     * @throws Exception
     */
    @GetMapping("/LrnPrgrtStatusAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> LrnPrgrtStatsAjax (SubjectVO sbjctOfrngVO, HttpServletRequest request) throws Exception {
    	ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
    	
    	String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
    	
        try {
        	sbjctOfrngVO.setOrgId(orgId);
        	sbjctOfrngVO.setUserId(userId);
            
            EgovMap map = statisticsService.stdntlrnPrgrtStatusSelect(sbjctOfrngVO);
            resultVO.setReturnVO(map);
            resultVO.setResultSuccess();
            
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResultFailed(getCommonFailMessage()); // 에러가 발생했습니다!
        }
    	
    	return resultVO;
    }
    
    
    /***************************************************** 
     * 학습자의 학습진도 현황 목록 조회
     * @param sbjctYr		학위연도
     * @param smstrChrtId	학기기수아이디
     * @param orgId			기관아이디
     * @param deptId		학과부서아이디
     * @param sbjctOfrngId	과목개설아이디
     * @param searchKey		검색키 ("Y"/"")
     * @param searchFrom	출석율 하한 경계값
     * @param searchTo		출석율 상한 경계값
     * @return 학습자 학습진도 현황 목록
     * @throws Exception
     ******************************************************/
    @GetMapping("/lrnPrgrtStatusListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> lessonProgressList(SubjectVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            List<EgovMap> list = statisticsService.stdntLrnPrgrtList(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResultFailed(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 교수 대시보드 > 학습진도관리 > 학과별 전체통계 팝업
     * @return lesson_progress_pop.jsp
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lrnPrgrtListByDeptPopView.do")
    public String lessonProgressPop(HttpServletRequest request, Model model) throws Exception {
    	
    	UserContext userCtx = new UserContext( 	SessionInfo.getOrgId(request),
				SessionInfo.getUserId(request),
				SessionInfo.getAuthrtCd(request),
				SessionInfo.getAuthrtGrpcd(request),
				SessionInfo.getUserRprsId(request),
				SessionInfo.getLastLogin(request));
    	
//    	UserContext userCtx = (UserContext)request.getSession().getAttribute("USER_CONTEXT");
    	
    	if(!userCtx.getAuthrtGrpcd().equals("PROF")) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }
    	
    	// 조회필터옵션 세팅
    	EgovMap filterOptions = statisticsFacadeService.loadFilterOptions(userCtx);
    	model.addAttribute("filterOptions", filterOptions);
        
        
        return "statistics/learn_progress_dept_list_popview";
    }
    
    /***************************************************** 
     * 학과별 학습진도율 목록 조회
     * @param orgId		기관아이디
     * @param sbjctYr	학위연도
     * @param smstrChrtId 학기기수 아이디
     * @return 학과별 학습진도율 목록
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lrnPrgrtListByDeptAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> lrnPrgrtListByDept(SubjectVO vo, HttpServletRequest request) throws Exception {
    	
    	ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
    	
    	String authurtGrpcd = SessionInfo.getAuthrtGrpcd(request);
    	
    	if(!authurtGrpcd.equals("PROF")) {
    		throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
    	}
    	
    	String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
    	vo.setOrgId(orgId);
    	
    	try {
			resultVO.setReturnList(statisticsService.listLrnPrgrtStatusByDept(vo));
			resultVO.setResultSuccess();
		} catch (Exception e) {
			resultVO.setResultFailed(getCommonFailMessage());
		}
    	
    	return resultVO;
    }
    
    
    
    
    
    
    
    
    
    
//    아래로 ASIS =================================================
    
    
    /*****************************************************
     * 학습자별 콘텐츠 수강통계 페이지
     * @param StatisticsVO
     * @return "statistics/content_Statistics_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/contentStatistics.do")
    public String contentStatistics(StatisticsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }

        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        model.addAttribute("termVO", termVO);
        model.addAttribute("haksaTermList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));
        
        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(orgId);
        model.addAttribute("deptCdList", usrDeptCdService.list(usrDeptCdVO));
        model.addAttribute("vo", vo);
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "statistics/content_statistics_list";
    }
    
    /***************************************************** 
     * 학습자별 콘텐츠 수강통계 목록 (전체, 주차별, 과목별)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<StatisticsVO>
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/listContentStatistics.do")
    @ResponseBody
    public ProcessResultVO<StatisticsVO> listContentStatistics(StatisticsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<StatisticsVO> resultVO = new ProcessResultVO<StatisticsVO>();
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String searchGubun = vo.getSearchGubun();

        try {
            if(!menuType.contains("ADM")) {
                throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
            }
            
            if(ValidationUtils.isEmpty(searchGubun)) {
                throw new AccessDeniedException(getMessage("system.fail.badrequest.nomethod")); // 잘못된 요청으로 오류가 발생하였습니다.
            }
            
            vo.setOrgId(orgId);
            
            if("ALL".equals(searchGubun)) {
                resultVO = statisticsService.listContentStatisticsAll(vo);
            } else if("WEEK".equals(searchGubun)) {
                resultVO = statisticsService.listContentStatisticsByWeek(vo);
            } else if("COURSE".equals(searchGubun)) {
                resultVO = statisticsService.listContentStatisticsByCourse(vo);
            }
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 학습자별 콘텐츠 수강통계 엑셀 (전체, 주차별, 과목별)
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelContentStatistics.do")
    public String downExcelLessonStatusByStd(StatisticsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String searchGubun = vo.getSearchGubun();
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }
        
        if(ValidationUtils.isEmpty(searchGubun)) {
            throw new AccessDeniedException(getMessage("system.fail.badrequest.nomethod")); // 잘못된 요청으로 오류가 발생하였습니다.
        }
        
        vo.setOrgId(orgId);
        
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        ProcessResultVO<StatisticsVO> processResultVO = null;
        
        String title = "학습자별 콘텐츠수강통계";
        
        if("ALL".equals(searchGubun)) {
            processResultVO = statisticsService.listContentStatisticsAll(vo);
        } else if("WEEK".equals(searchGubun)) {
            processResultVO = statisticsService.listContentStatisticsByWeek(vo);
            title = "학습자별 콘텐츠수강통계 (주차별)";
        } else if("COURSE".equals(searchGubun)) {
            processResultVO = statisticsService.listContentStatisticsByCourse(vo);
            title = "학습자별 콘텐츠수강통계 (과목별)";
        }
        
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", processResultVO.getReturnList());
        if(processResultVO.getReturnList().size() > 1000) {
            map.put("ext", ".xlsx(big)");
        }
     
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /*****************************************************
     * 학습자별 학습활동 수강통계 페이지
     * @param StatisticsVO
     * @return "statistics/learn_statistics_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/learnStatistics.do")
    public String learnStatistics(StatisticsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }

        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        model.addAttribute("termVO", termVO);
        model.addAttribute("haksaTermList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(orgId);
        model.addAttribute("deptCdList", usrDeptCdService.list(usrDeptCdVO));
        model.addAttribute("vo", vo);
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "statistics/learn_statistics_list";
    }
    
    /*****************************************************
     * 강의실 활동기록 수강통계 페이지
     * @param StatisticsVO
     * @return "statistics/classroom_statistics_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/classroomStatistics.do")
    public String classroomStatistics(StatisticsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }

        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        model.addAttribute("termVO", termVO);
        model.addAttribute("haksaTermList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(orgId);
        model.addAttribute("deptCdList", usrDeptCdService.list(usrDeptCdVO));
        model.addAttribute("vo", vo);
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "statistics/classroom_statistics_list";
    }

}