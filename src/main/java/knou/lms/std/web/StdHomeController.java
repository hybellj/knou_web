package knou.lms.std.web;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.map.ListOrderedMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.JsonUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.lesson.service.LessonCntsService;
import knou.lms.lesson.service.LessonScheduleService;
import knou.lms.lesson.service.LessonStudyService;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyStateVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;

@Controller
@RequestMapping(value= {"/std/stdHome","/std/stdLect","/std/stdPop"})
public class StdHomeController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(StdHomeController.class);
    
    @Resource(name="stdService")
    private StdService stdService;
    
    @Resource(name="crecrsService")
    private CrecrsService crecrsService;
    
    @Resource(name="lessonScheduleService")
    private LessonScheduleService lessonScheduleService;
    
    @Resource(name="lessonCntsService")
    private LessonCntsService lessonCntsService;
    
    @Resource(name="lessonStudyService")
    private LessonStudyService lessonStudyService;
    
    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;
    
    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;
    
    @Resource(name="sysFileService")
    private SysFileService sysFileService;
    
    /***************************************************** 
     * TODO 수강생 학습현황 팝업
     * @param StdVO 
     * @return "exam/exam_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stdLearningStatusPop.do")
    public String examListForm(StdVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);
        
        ProcessResultVO<StdVO> resultList = stdService.listPageing(vo);
        StdVO stdVO = resultList.getReturnList().get(0);
        request.setAttribute("stdVo", stdVO);
        
        return "std/popup/std_learning_status_pop";
    }

    //  수강생 목록
    @RequestMapping(value="/listStdJson.do")
    @ResponseBody
    public String listStdJson(StdVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        //-- 로그인이 안되어 있을 경우 로그인 페이지로
        // String orgId = UserBroker.getUserOrgId(request);
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String crsCreCd = request.getParameter("crsCreCd");
        
        int totalCount = 0;
        int listScale = vo.getListScale();
        
        if("0".equals(listScale) || listScale == 0) {
        	totalCount = stdService.count(vo);
        	vo.setListScale(totalCount);
        }
        vo.setOrgId(orgId);
        vo.setCrsCreCd(crsCreCd);
        ProcessResultVO<StdVO> stdList = stdService.stdList(vo);

        return JsonUtil.responseJson(response, stdList.getReturnList());
    }

    // 팀 구성이 안된 수강생 목록
    @RequestMapping(value="/listStd.do")
    @ResponseBody
    public ProcessResultVO<StdVO> listStd(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<>();
        
        int totalCount = 0;
        int listScale = vo.getListScale();
        
        try {
			if("0".equals(listScale) || listScale == 0) {
				totalCount = stdService.count(vo);
				vo.setListScale(totalCount);
			}
        	
            resultVO = stdService.stdList(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        
        request.setAttribute("stdVO", resultVO);
        
        return resultVO;
    }
    
    /***************************************************** 
     * 수강정보 > 수강생 정보 (학생)
     * @param vo
     * @param model
     * @param request
     * @return "std/lect/stu_student_list"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/Form/stuStudentList.do")
    public String stuStudentListForm(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String crsCreCd = vo.getCrsCreCd();
        
        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_COURSE_INFO, "수강생정보 확인");
        
        model.addAttribute("vo", vo);
        
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());
        
        return "std/lect/stu_student_list";
    }
    
    /***************************************************** 
     * 수강정보 > 수강생 정보 (교수)
     * @param vo
     * @param model
     * @param request
     * @return "std/lect/student_list"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/Form/studentList.do")
    public String studentListForm(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String crsCreCd = vo.getCrsCreCd();
        
        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 페이지 접근 권한 체크
        if(!menuType.contains("PROF")) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.select(creCrsVO);
        
        model.addAttribute("vo", vo);
        model.addAttribute("creCrsVO", creCrsVO);
        
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        
        return "std/lect/student_list";
    }

    /***************************************************** 
     * 수강생 목록 조회  (교수/학생)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listStudent.do")
    @ResponseBody
    public ProcessResultVO<StdVO> listStudent(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<>();
        
        String orgId  = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        
        vo.setOrgId(orgId);
        
        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            List<StdVO> list = stdService.listStudentInfo(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 수강생 정보 목록 엑셀 다운로드  (교수)
     * @param ExamStareVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelStudentList.do")
    public String excelStudentList(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = SessionInfo.getOrgId(request);
        String disablilityYn = vo.getDisablilityYn();
        String crsCreCd = vo.getCrsCreCd();
        
        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 페이지 접근 권한 체크
        if(!menuType.contains("PROF")) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        String[] searchValues = {getMessage("common.search.condition") + " : " + StringUtil.nvl(vo.getSearchValue())};
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        List<EgovMap> list = stdService.listStudentInfoExcel(vo);
        
        String title = getMessage("std.label.learner_info"); // 수강생정보
        
        if("Y".equals(StringUtil.nvl(disablilityYn))) {
            title = getMessage("std.label.dis_studend_info"); // 장애학생 현황
        }
        
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
     * 수강정보 > 출석/학습현황  (교수)
     * @param vo
     * @param model
     * @param request
     * @return "std/lect/attend_list"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/Form/attendList.do")
    public String attendListForm(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String tabCd = StringUtil.nvl(vo.getTabCd(), "1");
        
        vo.setOrgId(orgId);
        
        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 페이지 접근 권한 체크
        if(!menuType.contains("PROF")) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.select(creCrsVO);
        
        if("1".equals(tabCd)) {
            // 학습주차 조회
            LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
            lessonScheduleVO.setCrsCreCd(vo.getCrsCreCd());
            List<LessonScheduleVO> listLessonSchedule = lessonScheduleService.list(lessonScheduleVO);
            model.addAttribute("listLessonSchedule", listLessonSchedule);
        }
        
        model.addAttribute("vo", vo);
        model.addAttribute("creCrsVO", creCrsVO);
        
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        
        return "std/lect/attend_list";
    }
    
    /***************************************************** 
     * 수강정보 > 출석현황  (학생)
     * @param vo
     * @param model
     * @param request
     * @return "std/lect/stu_attend_list"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/Form/stuAttendList.do")
    public String stuAttendListForm(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String userId = SessionInfo.getUserId(request);
        
        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 페이지 접근 권한 체크
        if(!menuType.contains("USR")) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 강의실 수강생 정보 조회
        StdVO stdVO = new StdVO();
        stdVO.setOrgId(orgId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(userId);
        stdVO = stdService.selectStd(stdVO);
        
        if(stdVO == null) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_COURSE_INFO, "출석현황 확인");
        
        // 학습주차 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(vo.getCrsCreCd());
        List<LessonScheduleVO> listLessonSchedule = lessonScheduleService.list(lessonScheduleVO);
        model.addAttribute("listLessonSchedule", listLessonSchedule);
        
        String nowYear = DateTimeUtil.dateToString(new Date(), "yyyy");
        String nowMonth = DateTimeUtil.dateToString(new Date(), "M");
        
        model.addAttribute("nowYear", nowYear);
        model.addAttribute("nowMonth", nowMonth);
        
        model.addAttribute("stdVO", stdVO);
        model.addAttribute("vo", vo);
        
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());
        
        return "std/lect/stu_attend_list";
    }
    
    /***************************************************** 
     * 주차별 미학습자 비율  (교수)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/noAttendRateByWeek.do")
    @ResponseBody
    public ProcessResultVO<Map<String, Object>> noAttendRateByWeek(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<Map<String, Object>> resultVO = new ProcessResultVO<>();
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId  = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        
        vo.setOrgId(orgId);
        
        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            // 페이지 접근 권한 체크
            if(!menuType.contains("PROF")) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            Map<String, Object> noAttendRate = stdService.noAttendRateByWeek(vo);
            
            resultVO.setReturnVO(noAttendRate);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 강의실 출석현황  (교수/학생)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listStdAttend.do")
    @ResponseBody
    public ProcessResultVO<Map<String, Object>> listStdAttend(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<Map<String, Object>> resultVO = new ProcessResultVO<>();
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId  = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String userId = SessionInfo.getUserId(request);
        String stdNo = vo.getStdId();
        
        vo.setOrgId(orgId);
        
        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            // 페이지 접근 권한 체크
            if(menuType.contains("USR")) {
                if(ValidationUtils.isEmpty(stdNo)) {
                    // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                    throw new AccessDeniedException(getMessage("common.system.error"));
                } else {
                    vo.setUserId(userId);
                }
            }
            
            List<Map<String, Object>> list = stdService.listAttend(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 강의실 학생 출석현황 엑셀 다운로드  (교수)
     * @param ExamStareVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelStdAttendList.do")
    public String downExcelStdAttendList(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        
        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 페이지 접근 권한 체크
        if(!menuType.contains("PROF")) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        String[] searchValues = {getMessage("common.search.condition") + " : " + StringUtil.nvl(vo.getSearchValue())};
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        List<Map<String, Object>> list = stdService.listAttendExcel(vo);
        
        // simpleGrid casting 오류로 변환 실행
        List<ListOrderedMap> newList = new ArrayList<>();
        for (Map<String, Object> map : list) {
            ListOrderedMap listOrderedMap = new ListOrderedMap();
            
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                listOrderedMap.put(entry.getKey(), entry.getValue());
            }
            
            newList.add(listOrderedMap);
        }
        
        String title = getMessage("std.label.learner_status"); // 수강생 학습현황
        
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", newList);
     
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
     * 강의실 학습요소 참여현황 목록 (교수/학생)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listStdJoinStatus.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listStdJoinStatus(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId  = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String userId = SessionInfo.getUserId(request);
        String stdNo = vo.getStdId();
        
        vo.setOrgId(orgId);
        
        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            // 페이지 접근 권한 체크
            if(menuType.contains("USR")) {
                if(ValidationUtils.isEmpty(stdNo)) {
                    // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                    throw new AccessDeniedException(getMessage("common.system.error"));
                } else {
                    vo.setUserId(userId);
                    vo.setAuthrtGrpcd("USR");
                }
            }
            
            List<EgovMap> list = stdService.listStdJoinStatus(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 강의실 학습요소 참여현황 목록 엑셀 다운로드 (교수)
     * @param ExamStareVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelStdJoinStatus.do")
    public String downExcelStdJoinStatus(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        
        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 페이지 접근 권한 체크
        if(!menuType.contains("PROF")) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        String[] searchValues = {getMessage("common.search.condition") + " : " + StringUtil.nvl(vo.getSearchValue())};
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        List<EgovMap> list = stdService.listStdJoinStatus(vo);
        List<StdVO> listExc = new ArrayList<>();

        for (EgovMap egovMap : list) {
        	StdVO listInfo = new StdVO();
        	for (Field field : StdVO.class.getDeclaredFields()) {
        		field.setAccessible(true);
        		String fieldName = field.getName();
        		Object value = egovMap.get(fieldName);
        		
        		if (value != null) {
        			field.set(listInfo, value);
        		}
        	}
        	listExc.add(listInfo);
        }
        
        String title = getMessage("std.label.lesson_cnt_join_status"); // 학습요소 참여현황
        
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", listExc);
     
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
     * 수강생 학습현황 팝업 (관리자/교수)
     * @param vo
     * @param model
     * @param request
     * @return "std/popup/study_status_pop"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/studyStatusPop.do")
    public String studyStatusPopup(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String admYn = StringUtil.nvl(StringUtil.nvl(SessionInfo.getAdmYn(request)));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = "Y".equals(admYn) ? StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request)) : SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String stdNo = vo.getStdId();
        
        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(stdNo)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn) || menuType.contains("PROF"))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 강의실 정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setOrgId(orgId);
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.crsCreTopInfo(creCrsVO);
        
        if(creCrsVO == null) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 학습주차 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(vo.getCrsCreCd());
        List<LessonScheduleVO> listLessonSchedule = lessonScheduleService.list(lessonScheduleVO);
        model.addAttribute("listLessonSchedule", listLessonSchedule);
        
        String nowYear = DateTimeUtil.dateToString(new Date(), "yyyy");
        String nowMonth = DateTimeUtil.dateToString(new Date(), "M");
        
        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("orgId", orgId);
        model.addAttribute("nowYear", nowYear);
        model.addAttribute("nowMonth", nowMonth);
        model.addAttribute("vo", vo);
        
        return "std/popup/study_status_pop";
    }
    
    /***************************************************** 
     * 수강생 학습현황 > 이전, 다음 수강생 학습현황 정보  (관리자/교수)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/prevNextStdStudyStatusInfo.do")
    @ResponseBody
    public ProcessResultVO<Map<String, Object>> prevNextStdStudyStatusInfo(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<Map<String, Object>> resultVO = new ProcessResultVO<>();
        
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = "Y".equals(admYn) ? StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request)) : SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String stdNo = vo.getStdId();
        String disablilityYn = vo.getDisablilityYn();
      
        vo.setOrgId(orgId);
        
        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(stdNo)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            // 페이지 접근 권한 체크
            if(!("Y".equals(admYn) || menuType.contains("PROF"))) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }

            Map<String, Object> map = new HashMap<>();
            
            // 0. 강의실 정보
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(crsCreCd);
            creCrsVO = crecrsService.select(creCrsVO);
            
            // 1. 수강생 정보
            StdVO stdVO;
            
            stdVO = new StdVO();
            stdVO.setOrgId(orgId);
            stdVO.setCrsCreCd(crsCreCd);
            stdVO.setStdId(stdNo);
            stdVO.setDisablilityYn(disablilityYn);
            StdVO studentInfo = stdService.prevNextStudentInfo(stdVO);
            
            if (studentInfo.getPhtFileByte() != null && studentInfo.getPhtFileByte().length > 0) {
                String phtFile = "data:image/png;base64," + new String(Base64.getEncoder().encode(studentInfo.getPhtFileByte()));
               studentInfo.setPhtFile(phtFile);
            }
            
            map.put("studentInfo", studentInfo);
            
            // 2. 출석 정보
            stdVO = new StdVO();
            stdVO.setOrgId(orgId);
            stdVO.setCrsCreCd(crsCreCd);
            stdVO.setStdId(stdNo);
            if("3".equals(creCrsVO.getUnivGbn()) || "4".equals(creCrsVO.getUnivGbn())) {
                stdVO.setSearchAuditYn("Y");
            }
            Map<String, Object> attendInfo = stdService.listAttend(stdVO).get(0);
            map.put("attendInfo", attendInfo);
            
            if(("3".equals(creCrsVO.getUnivGbn()) || "4".equals(creCrsVO.getUnivGbn())) && "N".equals(studentInfo.getAuditYn())) {
                // 3. 학습요소 참여현황 정보
                stdVO = new StdVO();
                stdVO.setOrgId(orgId);
                stdVO.setCrsCreCd(crsCreCd);
                stdVO.setStdId(stdNo);
                EgovMap stdJoinStatusInfo = stdService.listStdJoinStatus(stdVO).get(0);
                map.put("stdJoinStatusInfo", stdJoinStatusInfo);
            }
            
            resultVO.setReturnVO(map);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 수강생 학습현황 > 수강생 정보  (교수/학생)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/studentInfo.do")
    @ResponseBody
    public ProcessResultVO<StdVO> studentInfo(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<>();
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId  = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String userId = SessionInfo.getUserId(request);
        String stdNo = vo.getStdId();
        
        vo.setOrgId(orgId);
        
        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(stdNo)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            if(menuType.contains("USR")) {
                vo.setUserId(userId);
            }
            
            StdVO stdVO = stdService.selectStudentInfo(vo);
            
            resultVO.setReturnVO(stdVO);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 주차 미학습자 목록 팝업  (교수)
     * @param vo
     * @param model
     * @param request
     * @return "std/popup/no_attend_list_pop"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/noAttentListWeekPop.do")
    public String noAttentListWeekPopup(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        
        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonScheduleId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 페이지 접근 권한 체크
        if(!menuType.contains("PROF")) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);
        
        model.addAttribute("lessonScheduleVO", lessonScheduleVO);
        model.addAttribute("vo", vo);
        
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        
        return "std/popup/no_attend_list_pop";
    }
    
    /***************************************************** 
     * 주차 미학습자 목록  (교수)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listNoStudyWeek.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listNoStudyWeek(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId  = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        
        vo.setOrgId(orgId);
        
        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonScheduleId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            // 페이지 접근 권한 체크
            if(!menuType.contains("PROF")) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            List<EgovMap> list = stdService.listNoStudyWeek(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 주차 미학습자 목록  (교수)
     * @param ExamStareVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelNoStudyWeek.do")
    public String downExcelNoAttendStdByWeek(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        
        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonScheduleId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 페이지 접근 권한 체크
        if(!menuType.contains("PROF")) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        //String[] searchValues = {getMessage("common.search.condition") + " : " + StringUtil.nvl(vo.getSearchValue())};
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        List<EgovMap> list = stdService.listNoStudyWeek(vo);
        
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);
        
        String title = lessonScheduleVO.getLessonScheduleOrder() + getMessage("std.label.nostudy_rate_list"); // 주차 미학습자 목록
        
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        //map.put("searchValues", searchValues);
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
     * 주차별 학습현황 상세 팝업  (교수/학생)
     * @param vo
     * @param model
     * @param request
     * @return "std/popup/study_status_week_pop"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/studyStatusByWeekPop.do")
    public String studyStatusByWeekPopup(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String stdNo = vo.getStdId();
        String lessonScheduleId = vo.getLessonScheduleId();
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String userId = SessionInfo.getUserId(request);
        String deptCd = StringUtil.nvl(SessionInfo.getUserDeptId(request));
        String seminarAttendAuthYn = "N";
        
        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(stdNo) || ValidationUtils.isEmpty(lessonScheduleId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 학생정보 조회
        StdVO stdVO = new StdVO();
        stdVO.setOrgId(orgId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setStdId(stdNo);
        stdVO = stdService.selectStudentInfo(stdVO);
        
        if(stdVO == null) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 학습주차 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(vo.getCrsCreCd());
        List<LessonScheduleVO> listLessonSchedule = lessonScheduleService.list(lessonScheduleVO);
        
        // 수업지원팀(20042), 교육플랫폼혁신팀(20134)
        if("20042".equals(deptCd) || "20134".equals(deptCd)) {
            seminarAttendAuthYn = "Y";
        } else {
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(crsCreCd);
            List<EgovMap> listCrecrsTchEgov = crecrsService.listCrecrsTchEgov(creCrsVO);
            
            if(listCrecrsTchEgov != null) {
                for(EgovMap map : listCrecrsTchEgov) {
                    if(userId.equals(StringUtil.nvl(map.get("userId")))) {
                        seminarAttendAuthYn = "Y";
                        break;
                    }
                }
            }
        }
        
        LessonStudyStateVO lessonStudyStateVO = new LessonStudyStateVO();
        lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
        lessonStudyStateVO.setStdId(stdNo);
        lessonStudyStateVO = lessonStudyService.selectLessonStudyState(lessonStudyStateVO);
        
        // 첨부 파일 조회
        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("ATTEND");
        fileVO.setFileBindDataSn(vo.getLessonScheduleId() + "_" + stdNo);
        ProcessResultVO<FileVO> resultVO = (ProcessResultVO<FileVO>) sysFileService.list(fileVO);
        List<FileVO> fileList = resultVO.getReturnList();
        
        model.addAttribute("stdVO", stdVO);
        model.addAttribute("lessonStudyStateVO", lessonStudyStateVO);
        model.addAttribute("fileList", fileList);
        model.addAttribute("listLessonSchedule", listLessonSchedule);
        model.addAttribute("menuType", menuType);
        model.addAttribute("vo", vo);
        model.addAttribute("userId", userId);
        model.addAttribute("deptCd", deptCd);
        model.addAttribute("seminarAttendAuthYn", seminarAttendAuthYn);
        
        return "std/popup/study_status_week_pop";
    }
    
    /***************************************************** 
     * 제출/참여 이력 팝업 (교수/학생)
     * @param vo
     * @param model
     * @param request
     * @return "std/popup/submit_join_history_pop"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/submitJoinHistoryPop.do")
    public String submitJoinHistoryPopup(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String crsCreCd = vo.getCrsCreCd();
        String stdNo = vo.getStdId();
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        
        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(stdNo)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        model.addAttribute("menuType", menuType);
        model.addAttribute("vo", vo);
        
        return "std/popup/submit_join_history_pop";
    }
    
    /***************************************************** 
     * 제출/참여 이력 목록 (교수/학생)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listSubmitHistory.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listSubmitHistory(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId  = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String stdNo = vo.getStdId();
        String searchKey = vo.getSearchKey();
        
        vo.setOrgId(orgId);
        
        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(stdNo) || ValidationUtils.isEmpty(searchKey)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            // 페이지 접근 권한 체크
            if(menuType.contains("USR")) {
                if(ValidationUtils.isEmpty(stdNo)) {
                    // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                    throw new AccessDeniedException(getMessage("common.system.error"));
                }
                
                vo.setAuthrtGrpcd("USR");
            }
            
            List<EgovMap> list = null;
            
            if("ASMNT".equals(searchKey)) {
                list = stdService.listSubmitHistoryAsmnt(vo);
            } else if("QUIZ".equals(searchKey)) {
                list = stdService.listSubmitHistoryQuiz(vo);
            } else if("RESCH".equals(searchKey)) {
                list = stdService.listSubmitHistoryResch(vo);
            } else if("FORUM".equals(searchKey)) {
                list = stdService.listSubmitHistoryForum(vo);
            }
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        }catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 주차 학생 출석현황
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listAttendByLessonSchedule.do")
    @ResponseBody
    public ProcessResultVO<StdVO> listAttendByLessonSchedule(StdVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        
        try {
            if(!menuType.contains("PROF")) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonScheduleId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            vo.setOrgId(orgId);
            
            List<StdVO> listAttend = stdService.listAttendByLessonSchedule(vo);
            
            resultVO.setReturnList(listAttend);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 주차 학생 출석현황 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/attendByLessonScheduleExcelDown.do")
    public String attendByLessonScheduleExcelDown(StdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        
        if(!menuType.contains("PROF")) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }
        
        if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonScheduleId)) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        // 조회조건 
        String[] searchValues = {getMessage("common.search.condition") + " : " + StringUtil.nvl(vo.getSearchValue())};
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        // 주차 정보 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);
        
        int lessonScheduleOrder = lessonScheduleVO.getLessonScheduleOrder();
        String[] args = {String.valueOf(lessonScheduleOrder)};
        
        String title = getMessage("std.label.attend_history_week", args); // 주차 출석내역
        
        vo.setOrgId(orgId);
        
        List<StdVO> listAttend = stdService.listAttendByLessonSchedule(vo);
        
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map1 = new HashMap<String, Object>();
        map1.put("title", title);
        map1.put("sheetName", title);
        map1.put("searchValues", searchValues);
        map1.put("excelGrid", vo.getExcelGrid());
        map1.put("list", listAttend);
     
        HashMap<String, Object> modelMap1 = new HashMap<String, Object>();
        modelMap1.put("outFileName", title + "_" +  date.format(today));
        modelMap1.put("sheetName", title);
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap1.put("workbook", excelUtilPoi.simpleGrid(map1));
        model.addAllAttributes(modelMap1);
        
        return "excelView";
    }
}
