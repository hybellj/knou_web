package knou.lms.lesson.web;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.AjaxProcessException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.erp.service.ErpService;
import knou.lms.erp.vo.ErpLcdmsCntsVO;
import knou.lms.file.service.FileBoxInfoService;
import knou.lms.lesson.service.LessonCntsService;
import knou.lms.lesson.service.LessonProgService;
import knou.lms.lesson.service.LessonScheduleService;
import knou.lms.lesson.service.LessonService;
import knou.lms.lesson.service.LessonStudyMemoService;
import knou.lms.lesson.service.LessonStudyService;
import knou.lms.lesson.service.LessonTimeService;
import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.lesson.vo.LessonProgVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyMemoVO;
import knou.lms.lesson.vo.LessonStudyStateVO;
import knou.lms.lesson.vo.LessonTimeVO;
import knou.lms.lesson.vo.LessonVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.lesson.vo.LogLessonActnHstyVO;
import knou.lms.log2.user.service.LogUserActvService;
import knou.lms.log2.user.vo.LogUserActvVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Controller
@RequestMapping(value= {"/lesson/lessonHome","/lesson/lessonLect","/lesson/lessonPop","/lesson/lessonNone","/lesson/lessonOpen"})
public class LessonHomeController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(LessonHomeController.class);
    
    @Resource(name="lessonService")
    private LessonService lessonService;
    
//    @Resource(name="lessonServicProgService")
    @Autowired
    private LessonProgService lessonServicProgService;
    
    @Resource(name="lessonCntsService")
    private LessonCntsService lessonCntsService;
    
    @Resource(name="lessonScheduleService")
    private LessonScheduleService lessonScheduleService;
    
    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    @Resource(name="logUserActvService")
    private LogUserActvService logUserActvService;

    @Resource(name="stdService")
    private StdService stdService;
    
    @Resource(name="crecrsService")
    private CrecrsService crecrsService;
    
    @Resource(name="lessonTimeService")
    private LessonTimeService lessonTimeService;
    
    @Resource(name="lessonStudyMemoService")
    private LessonStudyMemoService lessonStudyMemoService;
    
    @Resource(name="lessonStudyService")
    private LessonStudyService lessonStudyService;
    
    @Resource(name="fileBoxInfoService")
    private FileBoxInfoService fileBoxInfoService;
    
    @Resource(name="sysFileService")
    private SysFileService sysFileService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;
    
    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;
    
    @Resource(name="orgInfoService")
    private OrgInfoService orgInfoService;
    
    @Resource(name="termService")
    private TermService termService;
    
    @Resource(name="semesterService")
    private SemesterService semesterService;
    
    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;
    
    @Resource(name="erpService")
    private ErpService erpService;

    /*****************************************************
     * TODO 강의실 > 과목설정 > 접속정보
     * @param DefaultVO
     * @return
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profCntnInfoListView.do")
    public String profCntnInfoListView(DefaultVO defaultVO, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", SessionInfo.getCurCrsCreCd(request));
        model.addAttribute("sbjctnm", "--");

        return "lesson/lect/prof_cntn_info_list_view";
    }

    /*****************************************************
     * 강의실 활동 로그 조회 현황 목록 ajax (TB_LMS_LOG_USER_ACTV)
     * @param vo
     * @param request
     * @return ProcessResultVO<LogUserActvVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profLogUserActvList.do")
    @ResponseBody
    public ProcessResultVO<LogUserActvVO> profLogUserActvList(LogUserActvVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<LogUserActvVO> resultVO = new ProcessResultVO<>();

        try {
            resultVO = logUserActvService.selectLogUserActvList(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }

        return resultVO;
    }

    /***************************************************** 
     * 강의실 접속 현황 가져오기 ajax
     * @param vo 
     * @param model 
     * @param request 
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stdEnterStatusList.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> stdEnterStatusList(LessonCntsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            List<EgovMap> listStdEnterStatus = lessonCntsService.selectStdEnterStatusList(vo);
            
            resultVO.setReturnList(listStdEnterStatus);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 강의실 활동 기록 가져오기 ajax
     * @param vo 
     * @param model 
     * @param request 
     * @return ProcessResultVO<LogLessonActnHstyVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonActnHstyList.do")
    @ResponseBody
    public ProcessResultVO<LogLessonActnHstyVO> lessonActnHstyList(LogLessonActnHstyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LogLessonActnHstyVO> resultVO = new ProcessResultVO<>();
        
        try {
            resultVO = logLessonActnHstyService.listLessonActnHstyPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 강의실 활동 기록 엑셀 다운로드
     * @param vo 
     * @param model 
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonActnHstyExcelDown.do")
    public String lessonActnHstyExcelDown(LogLessonActnHstyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        // 조회조건 
        String[] searchValues = {getMessage("common.search.condition") + " : " + StringUtil.nvl(vo.getSearchValue())};
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        List<LogLessonActnHstyVO> list = logLessonActnHstyService.listLessonActnHsty(vo);
        
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map1 = new HashMap<>();
        map1.put("title", "강의실활동기록");
        map1.put("sheetName", "강의실활동기록");
        map1.put("searchValues", searchValues);
        map1.put("excelGrid", vo.getExcelGrid());
        map1.put("list", list);
     
        HashMap<String, Object> modelMap1 = new HashMap<>();
        modelMap1.put("outFileName", "강의실활동기록_"+date.format(today));
        modelMap1.put("sheetName", "강의실활동기록");
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap1.put("workbook", excelUtilPoi.simpleGrid(map1));
        model.addAllAttributes(modelMap1);
        
        return "excelView";
    }
    
    /***************************************************** 
     * 학습여부 목록 조회
     * @param vo 
     * @param model 
     * @param request
     * @return ProcessResultVO<LessonCntsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listLessonCntsViewYn.do")
    @ResponseBody
    public ProcessResultVO<LessonCntsVO> listSeqLessonCnts(LessonCntsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<LessonCntsVO> resultVO = new ProcessResultVO<>();
        
        String lessonTimeId = vo.getLessonTimeId();
        String stdNo = vo.getStdId();
        
        try {
            if(ValidationUtils.isEmpty(lessonTimeId) || ValidationUtils.isEmpty(stdNo)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AjaxProcessException(getMessage("common.system.error"));
            }
            
            List<LessonCntsVO> list = lessonService.listLessonCntsViewYn(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 주차 추가 팝업
     * @param vo
     * @param model
     * @param request
     * @return "lesson/popup/lesson_schedule_write_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lessonScheduleWritePop.do")
    public String lessonScheduleWritePop(LessonScheduleVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        
        if(!(menuType.contains("ADM") || menuType.contains("PROF"))) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }
        
        if(ValidationUtils.isEmpty(crsCreCd)) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        // 강의실 정보 조회
        CreCrsVO crsCreVO = new CreCrsVO();
        crsCreVO.setOrgId(orgId);
        crsCreVO.setCrsCreCd(crsCreCd);
        crsCreVO = crecrsService.select(crsCreVO);
        
        if(crsCreVO == null) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        if(ValidationUtils.isNotEmpty(lessonScheduleId)) {
            LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
            lessonScheduleVO.setCrsCreCd(crsCreCd);
            lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
            lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);
        
            if(lessonScheduleVO == null) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            model.addAttribute("lessonScheduleVO", lessonScheduleVO);
        }
        
        model.addAttribute("wekClsfGbnList", orgCodeService.selectOrgCodeList("WEK_CLSF_GBN"));
        model.addAttribute("crsCreVO", crsCreVO);
        model.addAttribute("vo", vo);
        
        return "lesson/popup/lesson_schedule_write_pop";
    }
    
    /***************************************************** 
     * 교시 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/insertLessonSchedule.do")
    @ResponseBody
    public ProcessResultVO<LessonScheduleVO> insertLessonSchedule(LessonScheduleVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<LessonScheduleVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        
        try {
            if(!(menuType.contains("ADM") || menuType.contains("PROF"))) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(crsCreCd)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            
            lessonScheduleService.insert(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 교시 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateLessonSchedule.do")
    @ResponseBody
    public ProcessResultVO<LessonScheduleVO> updateLessonSchedule(LessonScheduleVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<LessonScheduleVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        
        try {
            if(!(menuType.contains("ADM") || menuType.contains("PROF"))) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonScheduleId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            vo.setMdfrId(userId);
            
            lessonScheduleService.update(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 교시 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deleteLessonSchedule.do")
    @ResponseBody
    public ProcessResultVO<LessonScheduleVO> deleteLessonSchedule(LessonScheduleVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<LessonScheduleVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        
        try {
            if(!(menuType.contains("ADM") || menuType.contains("PROF"))) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonScheduleId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            vo.setMdfrId(userId);
            
            lessonScheduleService.delete(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 교시 추가 팝업
     * @param vo
     * @param model
     * @param request
     * @return "lesson/popup/lesson_time_write_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lessonTimeWritePop.do")
    public String lessonTimeWritePop(LessonTimeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        String lessonTimeId = vo.getLessonTimeId();
        
        if(!menuType.contains("PROF")) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }
        
        if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonScheduleId)) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        // 강의실 정보 조회
        CreCrsVO crsCreVO = new CreCrsVO();
        crsCreVO.setOrgId(orgId);
        crsCreVO.setCrsCreCd(crsCreCd);
        crsCreVO = crecrsService.select(crsCreVO);
        
        if(crsCreVO == null) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        // 주차 정보 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);
        
        if(lessonScheduleVO == null) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        // 등록
        if(ValidationUtils.isEmpty(lessonTimeId)) {
            // 등록할 교시 순서 정보 조회
            LessonTimeVO lessonTimeVO = new LessonTimeVO();
            lessonTimeVO.setLessonScheduleId(lessonScheduleId);
            int lessonTimeOrderMax = lessonTimeService.selectLessonTimeOrderMax(lessonTimeVO);
            model.addAttribute("lessonTimeOrderMax", lessonTimeOrderMax);
        } else {
            // 수정
            LessonTimeVO lessonTimeVO = new LessonTimeVO();
            lessonTimeVO.setLessonScheduleId(lessonScheduleId);
            lessonTimeVO.setLessonTimeId(lessonTimeId);
            lessonTimeVO = lessonTimeService.select(lessonTimeVO);
            
            if(lessonTimeVO == null) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            model.addAttribute("lessonTimeVO", lessonTimeVO);
        }
        
        model.addAttribute("crsCreVO", crsCreVO);
        model.addAttribute("lessonScheduleVO", lessonScheduleVO);
        model.addAttribute("vo", vo);
        
        return "lesson/popup/lesson_time_write_pop";
    }
    
    /***************************************************** 
     * 교시 정보 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonTimeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectLessonTime.do")
    @ResponseBody
    public ProcessResultVO<LessonTimeVO> selectLessonTime(LessonTimeVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonTimeVO> resultVO = new ProcessResultVO<>();
        try {
            LessonTimeVO lessonTimeVO = lessonTimeService.select(vo);
            
            resultVO.setReturnVO(lessonTimeVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 교시 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonTimeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/insertLessonTime.do")
    @ResponseBody
    public ProcessResultVO<LessonTimeVO> insertLessonTime(LessonTimeVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonTimeVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String userId = SessionInfo.getUserId(request);
        String lessonScheduleId = vo.getLessonScheduleId();
        
        try {
            if(!menuType.contains("PROF")) {
                throw new AccessDeniedException(getMessage("common.system.no_auth")); // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(lessonScheduleId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            vo.setRgtrId(userId);
            
            lessonTimeService.insert(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 교시 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonTimeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateLessonTime.do")
    @ResponseBody
    public ProcessResultVO<LessonTimeVO> updateLessonTime(LessonTimeVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonTimeVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String userId = SessionInfo.getUserId(request);
        String lessonTimeId = vo.getLessonTimeId();
        
        try {
            if(!menuType.contains("PROF")) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(lessonTimeId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            vo.setMdfrId(userId);
            
            lessonTimeService.update(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 교시 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonTimeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deleteLessonTime.do")
    @ResponseBody
    public ProcessResultVO<LessonTimeVO> deleteLessonTime(LessonTimeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonTimeVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String lessonTimeId = vo.getLessonTimeId();
        
        try {
            if(!menuType.contains("PROF")) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(lessonTimeId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            lessonTimeService.delete(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 교시 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonTimeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listLessonTime.do")
    @ResponseBody
    public ProcessResultVO<LessonTimeVO> listLessonTime(LessonTimeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonTimeVO> resultVO = new ProcessResultVO<>();
        try {
            List<LessonTimeVO> lessonTimeVO = lessonTimeService.list(vo);
            resultVO.setReturnList(lessonTimeVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 학습메모 페이지
     * @param vo
     * @param model
     * @param request
     * @return "lesson/lect/lesson_study_memo"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/lessonStudyMemo.do")
    public String lessonStudyMemoForm(LessonStudyMemoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd  = vo.getCrsCreCd();
        
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_LESSON, "학습메모 목록");
        
        vo.setCrsCreCd(crsCreCd);
        model.addAttribute("vo", vo);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        
        return "lesson/lect/lesson_study_memo";
    }
    
    /***************************************************** 
     * 학습메모 리스트
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonStudyMemoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonStudyMemoList.do")
    @ResponseBody
    public ProcessResultVO<LessonStudyMemoVO> lessonStudyMemoList(LessonStudyMemoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonStudyMemoVO> resultVO = new ProcessResultVO<>();
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setUserId(userId);
            resultVO = lessonStudyMemoService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 학습메모 정보
     * @param vo
     * @param model 
     * @param request 
     * @return ProcessResultVO<LessonStudyMemoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewLessonStudyMemo.do")
    @ResponseBody
    public ProcessResultVO<LessonStudyMemoVO> viewLessonStudyMemo(LessonStudyMemoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonStudyMemoVO> resultVO = new ProcessResultVO<>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            LessonStudyMemoVO memoVO = lessonStudyMemoService.select(vo);
            resultVO.setReturnVO(memoVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 학습메모 등록 팝업
     * @param vo
     * @param model
     * @param request
     * @return "lesson/popup/lesson_study_memo_write_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lessonStudyMemoWritePop.do")
    public String lessonStudyMemoWritePop(LessonStudyMemoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        model.addAttribute("vo", vo);
        
        return "lesson/popup/lesson_study_memo_write_pop";
    }
    
    /***************************************************** 
     * 학습메모 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeLessonStudyMemo.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> writeLessonStudyMemo(LessonStudyMemoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        try {
            vo.setUserId(userId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            StdVO stdVO = new StdVO();
            stdVO.setCrsCreCd(vo.getCrsCreCd());
            stdVO.setUserId(userId);
            stdVO.setOrgId(orgId);
            stdVO = stdService.selectStd(stdVO);
            vo.setStdId(StringUtil.nvl(stdVO.getStdId()));
            
            if(ValidationUtils.isEmpty(vo.getStudyMemoId())) {
                resultVO.setReturnVO(lessonStudyMemoService.insert(vo));
            } else {
                lessonStudyMemoService.update(vo);
                resultVO.setReturnVO(vo);
            }
            
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 학습메모 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editLessonStudyMemo.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editLessonStudyMemo(LessonStudyMemoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setMdfrId(userId);
            lessonStudyMemoService.update(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 학습메모 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonStudyMemoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deleteLessonStudyMemo.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> deleteLessonStudyMemo(LessonStudyMemoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            lessonStudyMemoService.delete(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 학습메모 정보 팝업
     * @param vo
     * @param model
     * @param request
     * @return "lesson/popup/lesson_study_memo_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lessonStudyMemoViewPop.do")
    public String lessonStudyMemoViewPop(LessonStudyMemoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        LessonStudyMemoVO memoVO = lessonStudyMemoService.select(vo);
        model.addAttribute("vo", memoVO);
        
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, vo.getCrsCreCd(), CommConst.ACTN_HSTY_LESSON, "학습메모 내용확인");
        
        return "lesson/popup/lesson_study_memo_view_pop";
    }
    
    /***************************************************** 
     * 출결관리 팝업
     * @param vo
     * @param model
     * @param request
     * @return "lesson/popup/attend_manage_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/attendManagePop.do")
    public String attendManagePop(LessonScheduleVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        
        if(!menuType.contains("PROF")) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }
        
        if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonScheduleId)) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        // 주차 정보 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        LessonScheduleVO lsvo = lessonScheduleService.select(lessonScheduleVO);
        lessonScheduleVO = lessonScheduleService.selectLessonScheduleAll(lessonScheduleVO);
        
        if(lessonScheduleVO == null) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        model.addAttribute("lessonScheduleVO", lessonScheduleVO);
        model.addAttribute("lsvo", lsvo);
        model.addAttribute("vo", vo);
        model.addAttribute("menuType", menuType);
        
        return "lesson/popup/attend_manage_pop";
    }
    
    /***************************************************** 
     * 출결관리 상세 팝업 (교시별)
     * @param vo
     * @param model
     * @param request
     * @return "lesson/popup/lesson_status_detail"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lessonStatusDetailPop.do")
    public String lessonStatusDetailPop(LessonVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String userId = vo.getUserId();
        String lessonScheduleId = vo.getLessonScheduleId();
        
        if(!menuType.contains("PROF")) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }
        
        if(ValidationUtils.isEmpty(userId) || ValidationUtils.isEmpty(lessonScheduleId)) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        // 강의실 정보 조회
        CreCrsVO crsCreVO = new CreCrsVO();
        crsCreVO.setOrgId(orgId);
        crsCreVO.setCrsCreCd(crsCreCd);
        crsCreVO = crecrsService.select(crsCreVO);
        
        if(crsCreVO == null) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        // 학생정보 조회
        StdVO stdVO = new StdVO();
        stdVO.setOrgId(orgId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setStdId(userId);
        stdVO = stdService.selectStudentInfo(stdVO);
        
        if(stdVO == null) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        LessonScheduleVO lsvo = new LessonScheduleVO();
        lsvo.setCrsCreCd(crsCreCd);
        List<LessonScheduleVO> lessonList = lessonScheduleService.list(lsvo);
        for(LessonScheduleVO lvo : lessonList) {
            if(lvo.getLessonScheduleOrder() == 14) {
                lsvo = lessonScheduleService.select(lvo);
            }
        }
        
        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
        model.addAttribute("scheduleVO", lsvo);
        model.addAttribute("crsCreVO", crsCreVO);
        model.addAttribute("stdVO", stdVO);
        model.addAttribute("vo", vo);
        model.addAttribute("menuType", menuType);
        model.addAttribute("deptCd", SessionInfo.getUserDeptId(request));
        
        return "lesson/popup/lesson_status_detail";
    }
    
    /***************************************************** 
     * 출결관리 상세 팝업 (영상별)
     * @param vo
     * @param model
     * @param request
     * @return "lesson/popup/lesson_status_video_detail_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lessonStatusVideoDetailPop.do")
    public String lessonStatusVideoDetailPop(LessonVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String userId = vo.getUserId();
        String lessonScheduleId = vo.getLessonScheduleId();
        
        if(!menuType.contains("PROF")) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }
        
        if(ValidationUtils.isEmpty(userId) || ValidationUtils.isEmpty(lessonScheduleId)) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        // 학생정보 조회
        StdVO stdVO = new StdVO();
        stdVO.setOrgId(orgId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(userId);
        stdVO = stdService.selectStudentInfo(stdVO);
        
        if(stdVO == null) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
       
        // 주차 정보 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);
        
        if(lessonScheduleVO == null) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        model.addAttribute("stdVO", stdVO);
        model.addAttribute("lessonScheduleVO", lessonScheduleVO);
        model.addAttribute("vo", vo);
        model.addAttribute("menuType", menuType);
        
        return "lesson/popup/lesson_status_video_detail_pop";
    }
    
    /***************************************************** 
     * 주차, 교시, 강의컨텐츠, (학습시간) 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectLessonScheduleAll.do")
    @ResponseBody
    public ProcessResultVO<LessonScheduleVO> selectLessonScheduleAll(LessonScheduleVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonScheduleVO> resultVO = new ProcessResultVO<>();
        
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        String stdNo = vo.getStdId();
        
        try {
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonScheduleId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            LessonScheduleVO lessonScheduleVO;
            
            if(ValidationUtils.isNotEmpty(stdNo)) {
                lessonScheduleVO = lessonScheduleService.selectLessonScheduleAllStd(vo);
            } else {
                lessonScheduleVO = lessonScheduleService.selectLessonScheduleAll(vo);
            }
            
            resultVO.setReturnVO(lessonScheduleVO);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 학습상태 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectLessonStudyState.do")
    @ResponseBody
    public ProcessResultVO<LessonStudyStateVO> selectLessonStudyState(LessonStudyStateVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonStudyStateVO> resultVO = new ProcessResultVO<>();
        
        String lessonScheduleId = vo.getLessonScheduleId();
        String stdNo = vo.getStdId();
        
        try {
            if(ValidationUtils.isEmpty(stdNo) || ValidationUtils.isEmpty(lessonScheduleId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            LessonStudyStateVO lessonScheduleVO = new LessonStudyStateVO();
            lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
            lessonScheduleVO.setStdId(stdNo);
            lessonScheduleVO = lessonStudyService.selectLessonStudyState(lessonScheduleVO);
            resultVO.setReturnVO(lessonScheduleVO);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다! 
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 강제 출석 처리
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/saveForcedAttend.do")
    @ResponseBody
    public ProcessResultVO<LessonStudyStateVO> saveForcedAttend(LessonStudyStateVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonStudyStateVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        String stdNo = vo.getStdId();
        String studyStatusCd = vo.getStudyStatusCd();
        String uploadPath = vo.getUploadPath();
        String uploadFiles = vo.getUploadFiles();
        
        try {
            if(!menuType.contains("PROF")) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(stdNo) || ValidationUtils.isEmpty(lessonScheduleId) || ValidationUtils.isEmpty(studyStatusCd)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            // 주차 정보 조회
            LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
            lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
            lessonScheduleVO.setCrsCreCd(crsCreCd);
            lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);
            
            if(lessonScheduleVO == null) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            // 주차 종료여부 체크
            /*
            String endDtYn = lessonScheduleVO.getEndDtYn();
            
            if(!"Y".equals(StringUtil.nvl(endDtYn))) {
                throw new AjaxProcessException(getMessage("lesson.error.forced.attend.period")); // 진행중인 주차는 출석처리를 할 수 없습니다.
            }
            */
            LessonStudyStateVO lessonStudyStateVO = new LessonStudyStateVO();
            lessonStudyStateVO.setOrgId(orgId);
            lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
            lessonStudyStateVO.setStdId(stdNo);
            lessonStudyStateVO.setCrsCreCd(crsCreCd);
            lessonStudyStateVO.setRgtrId(SessionInfo.getUserId(request));
            lessonStudyStateVO.setMdfrId(SessionInfo.getUserId(request));
            lessonStudyStateVO.setAttendReason(StringUtil.nvl(vo.getAttendReason()));
            lessonStudyStateVO.setStudyStatusCd(studyStatusCd);
            lessonStudyStateVO.setUploadPath(uploadPath);
            lessonStudyStateVO.setUploadFiles(uploadFiles);
            lessonStudyService.saveForcedAttend(request, lessonStudyStateVO);
            
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_LESSON, "학습메모 목록");
            
            resultVO.setResult(1);
        } catch (MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
            
            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("lesson.error.forced.attend")); // 출석처리 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요 
        
            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 강제 출석 처리  (일괄)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/saveForcedAttendBath.do")
    @ResponseBody
    public ProcessResultVO<LessonStudyStateVO> saveForcedAttendBath(LessonStudyStateVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonStudyStateVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        String stdNos = request.getParameter("stdNos");
        String attendReason = vo.getAttendReason();
        String studyStatusCd = vo.getStudyStatusCd();
        
        try {
            if(!menuType.contains("PROF")) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(stdNos) || ValidationUtils.isEmpty(lessonScheduleId) || ValidationUtils.isEmpty(studyStatusCd)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            // 주차 정보 조회
            LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
            lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
            lessonScheduleVO.setCrsCreCd(crsCreCd);
            lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);
            
            if(lessonScheduleVO == null) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            // 주차 종료여부 체크
            /*
            String endDtYn = lessonScheduleVO.getEndDtYn();
            
            if(!"Y".equals(StringUtil.nvl(endDtYn))) {
                throw new AjaxProcessException(getMessage("lesson.error.forced.attend.period")); // 진행중인 주차는 출석처리를 할 수 없습니다.
            }
            */
            
            LessonStudyStateVO lessonStudyStateVO = new LessonStudyStateVO();
            lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
            lessonStudyStateVO.setCrsCreCd(crsCreCd);
            lessonStudyStateVO.setRgtrId(SessionInfo.getUserId(request));
            lessonStudyStateVO.setMdfrId(SessionInfo.getUserId(request));
            lessonStudyStateVO.setSqlForeach(stdNos.split(","));
            lessonStudyStateVO.setAttendReason(attendReason);
            lessonStudyStateVO.setStudyStatusCd(studyStatusCd);
            lessonStudyService.saveForcedAttendBatch(request, lessonStudyStateVO);
          
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("lesson.error.forced.attend")); // 출석처리 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요 
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 강제 출석 처리 취소
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/cancelForcedAttend.do")
    @ResponseBody
    public ProcessResultVO<LessonStudyStateVO> cancelForcedAttend(LessonStudyStateVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonStudyStateVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        String stdNo = vo.getStdId();
        
        try {
            if(!menuType.contains("PROF")) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(stdNo) || ValidationUtils.isEmpty(lessonScheduleId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            LessonStudyStateVO lessonStudyStateVO = new LessonStudyStateVO();
            lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
            lessonStudyStateVO.setStdId(stdNo);
            lessonStudyStateVO.setCrsCreCd(crsCreCd);
            lessonStudyStateVO.setMdfrId(SessionInfo.getUserId(request));
            lessonStudyService.cancelForcedAttend(request, lessonStudyStateVO);
            
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("lesson.error.forced.attend.cancel")); // 출석처리취소 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요.
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 강제 출석 처리 취소 (일괄)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/cancelForcedAttendBath.do")
    @ResponseBody
    public ProcessResultVO<LessonStudyStateVO> cancelForcedAttendBath(LessonStudyStateVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonStudyStateVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        String stdNos = request.getParameter("stdNos");
        
        try {
            /*
            if(!menuType.contains("PROF")) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            */
            
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(stdNos) || ValidationUtils.isEmpty(lessonScheduleId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            LessonStudyStateVO lessonStudyStateVO = new LessonStudyStateVO();
            lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
            lessonStudyStateVO.setCrsCreCd(crsCreCd);
            lessonStudyStateVO.setMdfrId(SessionInfo.getUserId(request));
            lessonStudyStateVO.setSqlForeach(stdNos.split(","));
            lessonStudyService.cancelForcedAttendBath(request, lessonStudyStateVO);
            
            resultVO.setResult(1);
        } catch (MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("lesson.error.forced.attend.cancel")); // 출석처리취소 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요.
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 학습자료 추가 팝업
     * @param vo
     * @param model
     * @param request
     * @return "lesson/popup/lesson_cnts_write_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lessonCntsWritePop.do")
    public String lessonCntsWritePop(LessonCntsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        String lessonTimeId = vo.getLessonTimeId();
        String lessonCntsId = vo.getLessonCntsId();
        String cntsGbn = vo.getCntsGbn();
        
        if(!menuType.contains("PROF")) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }
        
        // 주차 정보 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);
        
        if(lessonScheduleVO == null) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        // 교시 정보 조회
        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setCrsCreCd(crsCreCd);
        lessonTimeVO.setLessonTimeId(lessonTimeId);
        lessonTimeVO = lessonTimeService.select(lessonTimeVO);
        
        if(lessonTimeVO == null) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        if(ValidationUtils.isEmpty(lessonCntsId)) {
            String stdyMethod = lessonTimeVO.getStdyMethod();
            
            // 교시 순차학습일 경우
            if("SEQ".equals(StringUtil.nvl(stdyMethod))) {
                LessonCntsVO lessonCntsVO = new LessonCntsVO();
                lessonCntsVO.setCrsCreCd(crsCreCd);
                lessonCntsVO.setLessonTimeId(lessonTimeId);
                int lessonCntsOrder = lessonCntsService.selectLessonCntsOrderMax(lessonCntsVO);
                
                vo.setLessonCntsOrder(lessonCntsOrder);
            }
            
            if ("VIDEO".equals(cntsGbn)) {
            	model.addAttribute("subtitLangList", orgCodeService.selectOrgCodeList("SUBTIT_LANG"));
            }
        } else {
            LessonCntsVO lessonCntsVO = new LessonCntsVO();
            lessonCntsVO.setCrsCreCd(crsCreCd);
            lessonCntsVO.setLessonCntsId(lessonCntsId);
            lessonCntsVO = lessonCntsService.select(lessonCntsVO);
            
            if(lessonCntsVO == null) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            cntsGbn = StringUtil.nvl(cntsGbn, lessonCntsVO.getCntsGbn());
            
            // 업로드한 파일 목록 조회
            if("VIDEO".equals(cntsGbn) || "PDF".equals(cntsGbn) || "FILE".equals(cntsGbn)) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("LECTURE");
                fileVO.setFileBindDataSn(lessonCntsVO.getLessonCntsId());
                
                List<FileVO> fileList = (List<FileVO>) sysFileService.list(fileVO).getReturnList();
                model.addAttribute("fileList", fileList);
                
                if ("VIDEO".equals(cntsGbn)) {
                	List<FileVO> subtitList1 = new ArrayList<>();
                	List<FileVO> subtitList2 = new ArrayList<>();
                	List<FileVO> subtitList3 = new ArrayList<>();
                	List<FileVO> scriptKoList = new ArrayList<>();
                	String langVal1 = "";
                	String langVal2 = "";
                	String langVal3 = "";
                	
                	if (!"".equals(StringUtil.nvl(lessonCntsVO.getSubtitKo()))) {
                		JSONArray titList = (JSONArray)JSONSerializer.toJSON(lessonCntsVO.getSubtitKo());
                		
                		for (int i=0; i<titList.size(); i++) {
                			JSONObject obj = (JSONObject)(titList.get(i));
                			fileVO = new FileVO();
                			
                			if (i == 0) {
                				fileVO.setFileNm(obj.getString("fileNm"));
                        		fileVO.setFileId(obj.getString("fileId"));
                        		fileVO.setFileSize(obj.getLong("fileSize"));
                        		subtitList1.add(fileVO);
                        		langVal1 = obj.getString("label")+":"+obj.getString("srclang");
                        		lessonCntsVO.setSubtit1(obj.toString());
                			}
                			else if (i == 1) {
                				fileVO.setFileNm(obj.getString("fileNm"));
                        		fileVO.setFileId(obj.getString("fileId"));
                        		fileVO.setFileSize(obj.getLong("fileSize"));
                        		subtitList2.add(fileVO);
                        		langVal2 = obj.getString("label")+":"+obj.getString("srclang");
                        		lessonCntsVO.setSubtit2(obj.toString());
                			}
                			else if (i == 2) {
                				fileVO.setFileNm(obj.getString("fileNm"));
                        		fileVO.setFileId(obj.getString("fileId"));
                        		fileVO.setFileSize(obj.getLong("fileSize"));
                        		subtitList3.add(fileVO);
                        		langVal3 = obj.getString("label")+":"+obj.getString("srclang");
                        		lessonCntsVO.setSubtit3(obj.toString());
                			}
                		}
                	}

                	if (!"".equals(StringUtil.nvl(lessonCntsVO.getScriptKo()))) {
                		fileVO = new FileVO();
                		JSONObject obj = (JSONObject)JSONSerializer.toJSON(lessonCntsVO.getScriptKo());
                		fileVO.setFileNm(obj.getString("fileNm"));
                		fileVO.setFileId(obj.getString("fileId"));
                		fileVO.setFileSize(obj.getLong("fileSize"));
                		scriptKoList.add(fileVO);
                	}
                	
                	model.addAttribute("subtitList1", subtitList1);
                	model.addAttribute("subtitList2", subtitList2);
                	model.addAttribute("subtitList3", subtitList3);
                	model.addAttribute("langVal1", langVal1);
                	model.addAttribute("langVal2", langVal2);
                	model.addAttribute("langVal3", langVal3);
                	model.addAttribute("scriptKoList", scriptKoList);
                	
                	model.addAttribute("subtitLangList", orgCodeService.selectOrgCodeList("SUBTIT_LANG"));
                }
            }
            
            model.addAttribute("lessonCntsVO", lessonCntsVO);
        }
        
        String uploadPath = "/lecture/" + crsCreCd + "/" + lessonScheduleId;
        
        if (cntsGbn.equals("VIDEO_LINK")) {
        	ErpLcdmsCntsVO cntsVO = new ErpLcdmsCntsVO();
        	cntsVO.setYear(vo.getYear());
        	cntsVO.setSemester(vo.getSemester());
        	cntsVO.setCourseCode(vo.getCourseCode());
        	List<ErpLcdmsCntsVO> cntsList = erpService.listLcdmsCnts(cntsVO);
        	model.addAttribute("cntsList", cntsList);
        }
        
        model.addAttribute("lessonScheduleVO", lessonScheduleVO);
        model.addAttribute("lessonTimeVO", lessonTimeVO);
        model.addAttribute("cntsGbn", cntsGbn);
        model.addAttribute("uploadPath", uploadPath);
        model.addAttribute("vo", vo);
        
        return "lesson/popup/lesson_cnts_write_pop";
    }
    
    /***************************************************** 
     * 강의컨텐츠 추가
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonCntsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/insertLessonCnts.do")
    @ResponseBody
    public ProcessResultVO<LessonCntsVO> insertLessonCnts(LessonCntsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonCntsVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        String lessonTimeId = vo.getLessonTimeId();
        String cntsGbn = vo.getCntsGbn();
        String prgrYn = vo.getPrgrYn();
        String videoTimeCalcMethod = vo.getVideoTimeCalcMethod();
        
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();
        
        try {
            if(!menuType.contains("PROF")) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonScheduleId) || ValidationUtils.isEmpty(lessonTimeId) || ValidationUtils.isEmpty(cntsGbn)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            
            resultVO = lessonCntsService.insert(vo);
        } catch (MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
            
            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("lesson.error.insert.lesson.cnts")); // 등록 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요.
        
            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 강의컨텐츠 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonCntsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateLessonCnts.do")
    @ResponseBody
    public ProcessResultVO<LessonCntsVO> updateLessonCnts(LessonCntsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonCntsVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        String lessonTimeId = vo.getLessonTimeId();
        String lessonCntsId = vo.getLessonCntsId();
        String cntsGbn = vo.getCntsGbn();
        
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();
        
        try {
            if(!menuType.contains("PROF")) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonScheduleId) || ValidationUtils.isEmpty(lessonTimeId) || ValidationUtils.isEmpty(lessonCntsId) || ValidationUtils.isEmpty(cntsGbn)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            vo.setOrgId(orgId);
            vo.setMdfrId(userId);
            
            resultVO = lessonCntsService.update(vo);
        } catch (MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
            
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("lesson.error.update.lesson.cnts")); // 수정 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요.
        
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 강의컨텐츠 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonCntsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deleteLessonCnts.do")
    @ResponseBody
    public ProcessResultVO<LessonCntsVO> deleteLessonCnts(LessonCntsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonCntsVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonCntsId = vo.getLessonCntsId();
        
        try {
            if(!menuType.contains("PROF")) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonCntsId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            vo.setOrgId(orgId);
            vo.setMdfrId(userId);
            
            lessonCntsService.delete(vo);
            
            resultVO.setResult(1);
        } catch (MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("lesson.error.delete.lesson.cnts")); // 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요.
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 학습 콘텐츠 학습자 수
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonCntsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/countLessonCntsStudyRecord.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> countLessonCntsStudyRecord(LessonCntsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonCntsId = vo.getLessonCntsId();
        
        try {
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonCntsId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            vo.setOrgId(orgId);
            
            int count = lessonCntsService.countLessonCntsStudyRecord(vo);
            
            DefaultVO defaultVO = new DefaultVO();
            defaultVO.setTotalCnt(count);
            
            resultVO.setReturnVO(defaultVO);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 강의 콘텐츠 다운로드 파일경로 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectLessonCntsFilePath.do")
    @ResponseBody
    public ProcessResultVO<FileVO> selectLessonCntsFilePath(LessonCntsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<FileVO> resultVO = new ProcessResultVO<>();
        
        String crsCreCd = vo.getCrsCreCd();
        String lessonCntsId = vo.getLessonCntsId();
        
        try {
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(lessonCntsId)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("LECTURE");
            fileVO.setFileBindDataSn(lessonCntsId);
            List<FileVO> fileList = (List<FileVO>) sysFileService.list(fileVO).getReturnList();
            
            if(fileList != null && fileList.size() > 0) {
                resultVO.setReturnVO(fileList.get(0));
            }
            
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("lesson.error.forced.attend")); // 출석처리 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요 
        }
        return resultVO;
    }
    
//    /***************************************************** 
//     * 교수 슬라이드 > 학습진도관리
//     * @param LessonVO
//     * @param model
//     * @param request
//     * @return "lesson/lesson_progress_manage"
//     * @throws Exception
//     ******************************************************/
//    @RequestMapping(value = {"/lessonProgressManage.do", "/profLrnPrgrtListView.do"})
//    public String profLrnPrgrtListView(LessonVO vo, ModelMap model, HttpServletRequest request) throws Exception {
//    	
//        String authrtGrpCd = SessionInfo.getAuthrtGrpcd(request);
//        String orgId = SessionInfo.getOrgId(request);
//        
//        if(!authrtGrpCd.contains("PROF")) {
//            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
//        }
//        
//        // 현재 학기기수 조회
//        SmstrChrtVO curSmstrChrtVO = new SmstrChrtVO();
//        curSmstrChrtVO.setOrgId(orgId);
//        curSmstrChrtVO = semesterService.selectCurrentSemester(curSmstrChrtVO);
//        model.addAttribute("curSmstrChrtVO", curSmstrChrtVO);
//        
//        // 조회기준연도에 개설된 학기기수 조회
//        model.addAttribute("smstrChrtList", semesterService.listSmstrChrtByDgrsYr(curSmstrChrtVO));
//        
//        // 기관 목록 조회
//        OrgInfoVO orgInfoVO = new OrgInfoVO();
//        orgInfoVO.setOrgId(orgId);
//        model.addAttribute("orgList", orgInfoService.list(orgInfoVO));
//        
//        // 학과 조회
//        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
//        usrDeptCdVO.setOrgId(orgId);
//        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));
//        
//        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
//        model.addAttribute("orgId", orgId);
//        
//        return "lesson/lesson_progress_manage";
//    }
    
//    /***************************************************** 
//     * 학습자 학습현황 목록 조회
//     * @param vo
//     * @param model
//     * @param request
//     * @return ProcessResultVO<LessonVO>
//     * @throws Exception
//     ******************************************************/
//    @GetMapping("/lessonProgressList.do")
//    @ResponseBody
//    public ProcessResultVO<EgovMap> lessonProgressList(SubjectOfferingVO vo, ModelMap model, HttpServletRequest request) throws Exception {
//    	
//        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
//        
//        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
//        String userId = SessionInfo.getUserId(request);
//        
//        try {
//            vo.setOrgId(orgId);
//            vo.setUserId(userId);
//            List<EgovMap> list = lessonService.listLessonProgress(vo);
//            
//            resultVO.setReturnList(list);
//            resultVO.setResultSuccess();
//        } catch(Exception e) {
//            LOGGER.debug("e: ", e);
//            resultVO.setResult(-1);
//            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
//        }
//        
//        return resultVO;
//    }
    
    /***************************************************** 
     * 학습진도관리 > 학습현황 엑셀 다운로드
     * @param lessonProgressExcelDown 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonProgressExcelDown.do")
    public String lessonProgressExcelDown(LessonVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        vo.setOrgId(orgId);
        vo.setUserId(userId);
        
        List<LessonVO> List = lessonService.listLessonProgressExcel(vo);
        
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", "학습현황");
        map.put("sheetName", "학습현황");
        map.put("excelGrid", vo.getExcelGrid());
		/* map.put("list", lessonService.listLessonProgress(vo)); */
        map.put("list", List);
        
        
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", "학습현황");
        
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
//    /***************************************************** 
//     * 교수 대시보드 > 학습진도관리 > 학과별 전체통계 팝업
//     * @param LessonVO
//     * @param model
//     * @param request
//     * @return "lesson/popup/lesson_progress_pop"
//     * @throws Exception
//     ******************************************************/
//    @RequestMapping(value = "/lessonProgressPop.do")
//    public String lessonProgressPop(LessonVO vo, Model model, HttpServletRequest request) throws Exception {
//        String menuType = SessionInfo.getAuthrtGrpcd(request);
//        
//        if(!menuType.contains("PROF")) {
//            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
//        }
//        
//        String orgId = SessionInfo.getOrgId(request);
//        model.addAttribute("orgId", orgId);
//        
//        // 현재 학기기수 조회
//        SmstrChrtVO curSmstrChrtVO = new SmstrChrtVO();
//        curSmstrChrtVO.setOrgId(orgId);
//        curSmstrChrtVO = semesterService.selectCurrentSemester(curSmstrChrtVO);
//        model.addAttribute("curSmstrChrtVO", curSmstrChrtVO);
//        
//        // 조회기준연도에 개설된 학기기수 조회
//        model.addAttribute("smstrChrtList", semesterService.listSmstrChrtByDgrsYr(curSmstrChrtVO));
//        
//        // 기관 목록 조회
//        OrgInfoVO orgInfoVO = new OrgInfoVO();
//        orgInfoVO.setOrgId(orgId);
//        model.addAttribute("orgList", orgInfoService.list(orgInfoVO));
//        
//        // 개설연도 목록
//        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
//        
//        return "lesson/popup/lesson_progress_popview";
//    }
    
//    /***************************************************** 
//     * 교수 대시보드 > 학습진도관리 > 학과별 전체통계 목록 조회
//     * @param LessonVO
//     * @param model
//     * @param request
//     * @return lesson_progress_pop.jsp
//     * @throws Exception
//     ******************************************************/
//    @RequestMapping(value = "/lrnPrgrtListByDept.do")
//    @ResponseBody
//    public ProcessResultVO<EgovMap> lrnPrgrtListByDept(LessonProgVO vo, HttpServletRequest request) throws Exception {
//    	
//    	ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
//    	
//    	String menuType = SessionInfo.getAuthrtGrpcd(request);
//    	
//    	if(!menuType.contains("PROF")) {
//    		throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
//    	}
//    	
//    	String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
//    	vo.setOrgId(orgId);
//    	
//    	try {
//			resultVO.setReturnList(lessonServicProgService.ListLrnPrgrtStatusByDept(vo));
//			resultVO.setResultSuccess();
//		} catch (Exception e) {
//			resultVO.setResultFailed(getCommonFailMessage());
//		}
//    	
//    	return resultVO;
//    }
    
    /***************************************************** 
     * 수업계획서 링크
     * @param CreCrsVO 
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonPlanPopUrl.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> lessonPlanPopUrl(CreCrsVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();
        
        try {
            vo = crecrsService.select(vo);
            // 수업계획서 링크정보
            String sCuriCls = vo.getDeclsNo().length() < 2 ? "0"+vo.getDeclsNo() : vo.getDeclsNo();
            String plnParam = "{\"sCuriNum\":\""+vo.getCrsCd()+"\",\"sCuriCls\":\""+sCuriCls+"\"}";
            String lsnPlanUrl = CommConst.LSNPLAN_POP_URL + new String((Base64.getEncoder()).encode(plnParam.getBytes()));
            vo.setGoUrl(lsnPlanUrl);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 강의구분별 주차 목록 조회
     * @param LectureWeekNoSchedleVO 
     * @return ProcessResultVO<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listLessonScheduleByGbn.do")
    @ResponseBody
    public ProcessResultVO<LessonScheduleVO> listLessonScheduleByGbn(LessonScheduleVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<LessonScheduleVO> resultVO = new ProcessResultVO<>();
        
        try {
            List<LessonScheduleVO> returnList = lessonScheduleService.listLessonScheduleByGbn(vo);
            resultVO.setReturnList(returnList);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 출석처리 사유 팝업
     * @param vo
     * @param model
     * @param request
     * @return "lesson/popup/attend_reason_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/stdyStateMemoPop.do")
    public String stdyStateMemoPop(LessonStudyStateVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        String stdNo = vo.getStdId();
        
        if(!menuType.contains("PROF")) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }
        
        if(ValidationUtils.isEmpty(lessonScheduleId) || ValidationUtils.isEmpty(stdNo)) {
            throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
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
        
        // 출석 상태 조회
        LessonStudyStateVO lessonStudyStateVO = new LessonStudyStateVO();
        lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
        lessonStudyStateVO.setStdId(stdNo);
        lessonStudyStateVO = lessonStudyService.selectLessonStudyState(lessonStudyStateVO);

        if(lessonStudyStateVO == null) {
            throw new AjaxProcessException(getMessage("lesson.error.save.attend.reason.no.study")); // 해당 주차에 학습기록이 존재하지 않아 메모를 작성할 수 없습니다.
        }
        
        lessonStudyStateVO = new LessonStudyStateVO();
        lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
        lessonStudyStateVO.setStdId(stdNo);
        lessonStudyStateVO = lessonStudyService.selectLessonStudyState(lessonStudyStateVO);
        
        // 첨부 파일 조회
        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("ATTEND");
        fileVO.setFileBindDataSn(lessonScheduleId + "_" + stdNo);
        ProcessResultVO<FileVO> resultVO = (ProcessResultVO<FileVO>) sysFileService.list(fileVO);
        List<FileVO> fileList = resultVO.getReturnList();
        
        model.addAttribute("vo", vo);
        model.addAttribute("lessonStudyStateVO", lessonStudyStateVO);
        model.addAttribute("stdVO", stdVO);
        model.addAttribute("fileList", fileList);
        
        return "lesson/popup/attend_reason_pop";
    }
    
    /***************************************************** 
     * 출석처리 사유 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editAttendReason.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> editAttendReason(LessonStudyStateVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String lessonScheduleId = vo.getLessonScheduleId();
        String stdNo = vo.getStdId();
        
        String uploadPath = vo.getUploadPath();
        String uploadFiles = vo.getUploadFiles();
        
        try {
            if(!menuType.contains("PROF")) {
                throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            }
            
            if(ValidationUtils.isEmpty(lessonScheduleId) || ValidationUtils.isEmpty(stdNo)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            vo.setMdfrId(userId);
            lessonStudyService.updateAttendReason(vo);
            resultVO.setResult(1);
        } catch (MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
            
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 강의컨텐츠 페이지 저장
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/saveLessonPage.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<FileVO> updateLessonPage(LessonCntsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<FileVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();
        
        try {
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(uploadPath)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            
            lessonCntsService.saveLessonPage(vo);
            
            resultVO.setResult(1);
        } catch(MediopiaDefineException | EgovBizException e) {
            LOGGER.debug("e: ", e);
            System.out.println("saveLessonPage Error ==========\n" + e);
            
            String errorMsg = e.getMessage();
            if(e.getMessage() != null) {
                errorMsg = "\n" + e.getMessage();
            }
            
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("lesson.error.save.cnts.file") + errorMsg); // 첨부파일 등록중 오류가 발생하였습니다.
            
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            System.out.println("saveLessonPage Error ==========\n" + e);
            
            String errorMsg = e.getMessage();
            if(e.getMessage() != null) {
                errorMsg = "\n" + e.getMessage();
            }
            
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("lesson.error.save.cnts.file") + errorMsg); // 첨부파일 등록중 오류가 발생하였습니다.
            
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
        }

        return resultVO;
    }
    
    /***************************************************** 
     * 학습 주차 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listLessonSchedule.do")
    @ResponseBody
    public ProcessResultVO<LessonScheduleVO> listLessonSchedule(LessonScheduleVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<LessonScheduleVO> resultVO = new ProcessResultVO<>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            List<LessonScheduleVO> scheduleList = lessonScheduleService.list(vo);
            resultVO.setReturnList(scheduleList);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 수강생별 학습기록 주차 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listStdLessonRecord.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listStdLessonRecord(LessonScheduleVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        try {
            if("".equals(StringUtil.nvl(vo.getStdId())) && !"".equals(StringUtil.nvl(vo.getCrsCreCd()))) {
                StdVO stdVO = new StdVO();
                stdVO.setCrsCreCd(vo.getCrsCreCd());
                stdVO.setUserId(vo.getUserId());
                stdVO = stdService.selectStd(stdVO);
                vo.setStdId(stdVO.getStdId());
            }
            List<EgovMap> listStdEnterStatus = lessonStudyService.listStdLessonRecord(vo);
            
            resultVO.setReturnList(listStdEnterStatus);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }
    
    /***************************************************** 
     * LCDMS 콘텐츠 가져오기 ajax
     * @param vo 
     * @param model 
     * @param request 
     * @return ProcessResultVO<ErpLcdmsCntsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonLcdmsCntsList.do")
    @ResponseBody
    public ProcessResultVO<ErpLcdmsCntsVO> lessonLcdmsCntsList(ErpLcdmsCntsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ErpLcdmsCntsVO> resultVO = new ProcessResultVO<>();
        
        try {
            resultVO.setReturnList(erpService.listLcdmsCnts(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
}