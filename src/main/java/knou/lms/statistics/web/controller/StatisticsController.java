package knou.lms.statistics.web.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.lesson.web.LessonMgrController;
import knou.lms.org.service.OrgCodeService;
import knou.lms.statistics.service.StatisticsService;
import knou.lms.statistics.vo.StatisticsVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

@Controller
@RequestMapping("/statistics")
@Deprecated // StatsContoller로 이전 요망
public class StatisticsController extends ControllerBase {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(LessonMgrController.class);
	
    @Resource(name="statisticsService")
    private StatisticsService statisticsService;
    
    @Resource(name= "termService")
    private TermService termService;
    
    @Resource(name= "usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;
    
    @Resource(name= "orgCodeService")
    private OrgCodeService orgCodeService;
    
    
    //	admLoginStatisticsListView.do
    //	로그인통계목록조회화면
  	@RequestMapping(value={"/admLoginStatisticsListView.do"})
	public	String	admLoginStatisticsListView() { // ModelMap model, @CurrentUser UserContext userCtx) {
      	return "statistics/login_statistics_list";    	
  	}
    
    //	admLoginStaticticsListPaging.do
  	@RequestMapping(value={"/admLoginStaticticsListPaging.do"})
  	@ResponseBody
	public	ResultDTO<Void>	admLoginStaticticsListPaging() { // ModelMap model, @CurrentUser UserContext userCtx) {
      	return new ResultDTO<Void>();
  	}
  	
    
    //	admLectureRoomCntnStatsListView.do
  	//	강의실접속통계목록조회화면
  	@RequestMapping(value={"/admLectureRoomCntnStatsListView.do"})
	public	String	admLectureRoomCntnStatsListView() { // ModelMap model, @CurrentUser UserContext userCtx) {
      	return "statistics/classroom_cntn_statistics_list";    	
  	}
  	
    //	admLectureRoomCntnStatsListPaging.do
  	@RequestMapping(value={"/admLectureRoomCntnStatsListPaging.do"})
  	@ResponseBody
	public	ResultDTO<Void>	admLectureRoomCntnStatsListPaging() { // ModelMap model, @CurrentUser UserContext userCtx) {
      	return new ResultDTO<Void>();
  	}
    
  	
    //	admMenuCntnStatsListView.do
  	//	메뉴접속통계목록조회화면
  	@RequestMapping(value={"/admMenuCntnStatsListView.do"})
	public	String	admMenuCntnStatsListView() { // ModelMap model, @CurrentUser UserContext userCtx) {
      	return "statistics/menu_cntn_statistics_list";    	
  	}
  	
    //	admMenuCntnStatsListPaging.do
  	@RequestMapping(value={"/admMenuCntnStatsListPaging.do"})
  	@ResponseBody
	public	ResultDTO<Void>	admMenuCntnStatsListPaging() { // ModelMap model, @CurrentUser UserContext userCtx) {
      	return new ResultDTO<Void>();
  	}  	
  	
  	
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