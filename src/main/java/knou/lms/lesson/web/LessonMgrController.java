package knou.lms.lesson.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.lesson.service.LessonProgService;
import knou.lms.lesson.service.LessonService;
import knou.lms.lesson.service.LessonStudyService;
import knou.lms.lesson.vo.LessonProgVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyStateVO;
import knou.lms.lesson.vo.LessonVO;
import knou.lms.org.service.OrgCodeService;
import knou.lms.std.vo.StdVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

@Controller
@RequestMapping(value= {"/lesson/lessonMgr"})
public class LessonMgrController extends ControllerBase {
    
    private static final Logger LOGGER = LoggerFactory.getLogger(LessonMgrController.class);
    
    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;
    
    @Resource(name="termService")
    private TermService termService;
    
    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;
    
    @Resource(name="lessonService")
    private LessonService lessonService;
    
    @Resource(name="lessonProgService")
    private LessonProgService lessonProgService;
    
    @Resource(name="lessonStudyService")
    private LessonStudyService lessonStudyService;

    /***************************************************** 
     * 강의목록 현황 폼
     * @param LectureWeekNoSchedleVO
     * @return "lesson/mgr/lesson_list_status"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/lessonListStatus.do")
    public String lessonStudyMemoForm(LessonScheduleVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        model.addAttribute("termVO", termVO);
        model.addAttribute("haksaTermList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));
        
        model.addAttribute("vo", vo);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("isKnou", SessionInfo.isKnou(request));
        
        return "lesson/mgr/lesson_list_status";
    }
    
    /***************************************************** 
     * 학습진도관리 폼 페이지
     * @param LessonVO
     * @return "lesson/mgr/lesson_progress_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lessonProgressManage.do")
    public String lessonProgressForm(LessonVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
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
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));
        
        model.addAttribute("vo", vo);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        
        return "lesson/mgr/lesson_progress_manage";
    }
    
    /***************************************************** 
     * 학습진도관리 전체현황
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @GetMapping(value="/selectLessonProgressTotalStatus.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> selectLessonProgressTotalStatus(LessonProgVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            
            EgovMap map = lessonProgService.LrnPrgrtStatusSelect(vo);
            resultVO.setReturnVO(map);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    
    /***************************************************** 
     * 학습진도관리 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listLessonProgressStatus.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listLessonProgressStatus(LessonVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            List<EgovMap> list = lessonService.listLessonProgressStatusBatch(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 학습진도관리 목록 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelLessonProgressStatus.do")
    public String downExcelLessonProgressStatus(LessonVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        String haksaTermNm = request.getParameter("haksaTermNm");
        String univGbnNm = StringUtil.nvl(request.getParameter("univGbnNm"));
        String deptNm = StringUtil.nvl(request.getParameter("deptNm"));
        String crsNm = StringUtil.nvl(request.getParameter("crsNm"));
        String crsCreNm = StringUtil.nvl(request.getParameter("crsCreNm"));
        String searchFrom = StringUtil.nvl(vo.getSearchFrom());
        String searchTo = StringUtil.nvl(vo.getSearchTo());
        String searchText = StringUtil.nvl(vo.getSearchText());
        String lessonScheduleOrder = StringUtil.nvl(request.getParameter("lessonScheduleOrder"));
        
        if(!"".equals(searchText)) {
            searchText = getMessage("message.yes");
        }
        
        // 조회조건 
        String[] searchValues = {
              getMessage("common.year") + " : " + vo.getHaksaYear() // 학년도
            , getMessage("common.term") + " : " + haksaTermNm // 학기
            , getMessage("common.label.uni.type") + " : " + univGbnNm // 대학구분
            , getMessage("common.dept_name") + " : " + deptNm // 학과
            , getMessage("common.crs.cd") + " : " + crsNm // 학수번호
            , getMessage("lesson.label.crs.cre.nm") + " : " + crsCreNm // 과목명
            , getMessage("lesson.common.placeholder4") + " : " + StringUtil.nvl(vo.getSearchValue())
            , getMessage("common.week") + " : " + ("".equals(lessonScheduleOrder) ? getMessage("common.all") : lessonScheduleOrder) // 주차
            , getMessage("common.label.over") + " : " + searchFrom // 이상
            , getMessage("common.label.under") + " : " + searchTo // 미만
            , getMessage("lesson.label.non.learning.person") + " " + getMessage("common.all") + " : " + searchText
        };
        
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
                
        List<EgovMap> list = lessonService.listLessonProgressStatusBatch(vo);
        
        String title = getMessage("lesson.label.progress.title"); // 학습진도관리
      
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
     
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /***************************************************** 
     * 콘텐츠 사용 현황 폼
     * @param vo
     * @param model
     * @param request
     * @return "lesson/mgr/cntsusage_list"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/Form/listCntsUsage.do")
    public String cntsuageForm(LessonVO vo ,ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        if(!menuType.contains("ADM")) {
            // 사용권한이 없거나 로그아웃되었습니다. 다시 로그인하세요.
            throw new AccessDeniedException(getMessage("common.system.no_auth"));
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
        
        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "lesson/mgr/lesson_cnts_usage_list";
    }
    
    /***************************************************** 
     * 콘텐츠 현황 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listCntsUsage.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listCntsUsage(LessonVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            resultVO = lessonService.listCntsUsage(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 콘텐츠 현황 목록 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelCntsUsage.do")
    public String downExcelCntsUsage(LessonVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        vo.setPagingYn("N");
        
        List<EgovMap> list = lessonService.listCntsUsageExc(vo);
        
        // 조회조건 
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        String title = getMessage("lesson.label.lesson.cnts.status"); // 콘텐츠 현황
      
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
        map.put("ext", ".xlsx(big)");
        
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /***************************************************** 
     * 법정교육 학습상태 변경
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/saveLegalStudyStatus.do")
    @ResponseBody
    public ProcessResultVO<StdVO> saveLegalStudyStatus(@RequestBody List<LessonStudyStateVO> list ,ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<>();
        
        try {
            lessonStudyService.saveLegalStudyStatus(request, list);
            resultVO.setResult(1);
        } catch (EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
}