package knou.lms.score.web;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.SecureUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.erp.service.ErpService;
import knou.lms.erp.util.ErpUtil;
import knou.lms.erp.vo.ErpScoreTestVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.score.service.ScoreOverallService;
import knou.lms.score.vo.ScoreOverallScoreCalVO;
import knou.lms.score.vo.ScoreOverallVO;
import knou.lms.sys.service.SysJobSchService;
import knou.lms.sys.vo.SysJobSchVO;


@Controller
public class ScoreOverallController  extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(ScoreOverallController.class);

    @Autowired
    private ScoreOverallService scoreOverallService;


    @Resource(name = "messageSource")
    private MessageSource messageSource;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    @Resource(name="sysJobSchService")
    private SysJobSchService sysJobSchService;

    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name="termService")
    private TermService termService;
    
    @Resource(name="sysFileService")
    private SysFileService sysFileService;
    
    @Resource(name="erpService")
    private ErpService erpService;
    
    // 강의실 홈 종합성적 메인페이지
    @RequestMapping(value="/score/scoreOverall/scoreOverallMainList.do")
    public String scoreOverallProfMain(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        SysJobSchVO sysJobSchVO = null;
        String calendarCtgr = "";
        String haksaYear = "2024";
        String haksaTerm = "20";

        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        String url = "";

        if(SessionInfo.getAuthrtGrpcd(request).contains("PROF")) {
            model.addAttribute("TUT_YN", SessionInfo.getAuthrtCd(request).contains("TUT") ? "Y" : "N");

            url = "score/overall/score_overall_prof_main";
            
            model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        } else if(SessionInfo.getAuthrtGrpcd(request).contains("USR"))  {
            sysJobSchVO = new SysJobSchVO();
            calendarCtgr = "00210210";//성적조회기간
            sysJobSchVO.setOrgId(orgId);
            sysJobSchVO.setUseYn("Y");
            sysJobSchVO.setCalendarCtgr(calendarCtgr);
            sysJobSchVO.setHaksaYear(haksaYear);
            sysJobSchVO.setHaksaTerm(haksaTerm);
            sysJobSchVO = sysJobSchService.select(sysJobSchVO);
            model.addAttribute("sysJobSchVO", sysJobSchVO);

            SysJobSchVO sysJobSchSearchVO = new SysJobSchVO();
            sysJobSchSearchVO.setOrgId(orgId);
            sysJobSchSearchVO.setUseYn("Y");
            sysJobSchSearchVO.setHaksaYear(haksaYear);
            sysJobSchSearchVO.setHaksaTerm(haksaTerm);
            // 00190501: 중간강의평가일정, 00190505: 기말강의평가일정
            sysJobSchSearchVO.setSqlForeach(new String[]{"00190501", "00190505"});
            List<SysJobSchVO> jobSchList = sysJobSchService.list(sysJobSchSearchVO);
            Map<String, SysJobSchVO> jobSchMap = new HashMap<>();
            for(SysJobSchVO sysJobSchVO2 : jobSchList) {
                jobSchMap.put(sysJobSchVO2.getCalendarCtgr(), sysJobSchVO2);
            }
            
            String lectEvalYn = "N";
            boolean isMidLectEvalPeriod = false;
            boolean isFinalLectEvalPeriod = false;
            String langApiHeader = SecureUtil.encodeAesCbc(DateTimeUtil.getCurrentString() + SessionInfo.getUserId(request), null, CommConst.ERP_API_KEY);
            
            // 중간강의평가일정
            sysJobSchVO = jobSchMap.get("00190505");
            
            if(sysJobSchVO != null && "Y".equals(StringUtil.nvl(sysJobSchVO.getSysjobSchdlPeriodYn()))) {
                isMidLectEvalPeriod = true;
            }
            
            // 기말강의평가일정
            sysJobSchVO = jobSchMap.get("00190501");
            
            if(sysJobSchVO != null && "Y".equals(StringUtil.nvl(sysJobSchVO.getSysjobSchdlPeriodYn()))) {
                isFinalLectEvalPeriod = true;
            }
            
            if(isMidLectEvalPeriod || isFinalLectEvalPeriod) {
                lectEvalYn = "Y";
            }
            
            model.addAttribute("lectEvalYn", lectEvalYn);
            model.addAttribute("langApiHeader", langApiHeader);
            model.addAttribute("lectEvalUrl", ErpUtil.getStuLectEvalUrl(haksaYear, haksaTerm, SessionInfo.getUserId(request)));
            model.addAttribute("haksaYear", haksaYear);
            model.addAttribute("haksaTerm", haksaTerm);
            
            url = "score/overall/score_overall_std_main";
        }
 
        model.addAttribute("sUserId", SessionInfo.getUserId(request));
        model.addAttribute("vo", vo);
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return url;
    }

    //종합평가학생 성적조회
    @RequestMapping(value="/score/scoreOverall/selectScoreOverallStd.do")
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectScoreOverallStd(ScoreOverallVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        
        try {
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 강의실 정보를 찾을 수 없거나 비정상적인 접근입니다. 웹브라우저를 다시 시작하여 접속하세요. 오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.not.found.course.error"));
            }
            
            vo.setUserId(userId);
            
            ScoreOverallVO scoreOverallVO = scoreOverallService.selectScoreOverallStd(vo);
            resultVO.setReturnVO(scoreOverallVO);
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

    //종합평가학생 성적조회
    @RequestMapping(value="/score/scoreOverall/chartScoreList.do")
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> chartScoreList(ScoreOverallVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setUserId(userId);
            
            List<ScoreOverallVO> list = scoreOverallService.chartScoreList(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //종합평가학생 성적조회
    @RequestMapping(value="/score/scoreOverall/selectStdScore.do")
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectStdScore(ScoreOverallVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setUserId(userId);
            
            ScoreOverallVO scoreOverallVO = scoreOverallService.selectStdScore(vo);
            
            resultVO.setReturnVO(scoreOverallVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    @RequestMapping(value="/score/scoreOverallLect/Form/scoreOverallMain.do")
    public String scoreOverallMainForm(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        vo.setUserId(SessionInfo.getUserId(request));

        String openYn = scoreOverallService.selectOverallScoreOpenYn(vo);
        String url = "";

        if(SessionInfo.getAuthrtGrpcd(request).contains("PROF")) {
            TermVO termVO = new TermVO();
            termVO.setOrgId(SessionInfo.getOrgId(request));
            termVO = termService.selectCurrentTerm(termVO);
            
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsVO = crecrsService.select(creCrsVO);
            
            url = "score/overall/score_overall_list";

            model.addAttribute("termVO", termVO);
            model.addAttribute("creCrsVO", creCrsVO);
            model.addAttribute("TUT_YN", SessionInfo.getAuthrtCd(request).contains("TUT") ? "Y" : "N");
            model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        } else if(SessionInfo.getAuthrtGrpcd(request).contains("USR"))  {
            url = "score/overall/score_overall_std_list";
            
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsVO = crecrsService.select(creCrsVO);
            
            String creYear = creCrsVO.getCreYear();
            String creTerm = creCrsVO.getCreTerm();
            
            // 강의평가 일정 체크
            String lectEvalYn = "N";
            String langApiHeader = SecureUtil.encodeAesCbc(DateTimeUtil.getCurrentString() + SessionInfo.getUserId(request), null, CommConst.ERP_API_KEY);
            
            if(SessionInfo.isKnou(request)) {
                SysJobSchVO sysJobSchSearchVO = new SysJobSchVO();
                sysJobSchSearchVO.setOrgId(orgId);
                sysJobSchSearchVO.setUseYn("Y");
                sysJobSchSearchVO.setHaksaYear(creYear);
                sysJobSchSearchVO.setHaksaTerm(creTerm);
                // 00190501: 중간강의평가일정, 00190505: 기말강의평가일정
                sysJobSchSearchVO.setSqlForeach(new String[]{"00190501", "00190505"});
                List<SysJobSchVO> jobSchList = sysJobSchService.list(sysJobSchSearchVO);
                Map<String, SysJobSchVO> jobSchMap = new HashMap<>();
                for(SysJobSchVO sysJobSchVO2 : jobSchList) {
                    jobSchMap.put(sysJobSchVO2.getCalendarCtgr(), sysJobSchVO2);
                }
                
                boolean isMidLectEvalPeriod = false;
                boolean isFinalLectEvalPeriod = false;
                
                // 중간강의평가일정
                SysJobSchVO sysJobSchVO = jobSchMap.get("00190505");
                
                if(sysJobSchVO != null && "Y".equals(StringUtil.nvl(sysJobSchVO.getSysjobSchdlPeriodYn()))) {
                    isMidLectEvalPeriod = true;
                }
                
                // 기말강의평가일정
                sysJobSchVO = jobSchMap.get("00190501");
                
                if(sysJobSchVO != null && "Y".equals(StringUtil.nvl(sysJobSchVO.getSysjobSchdlPeriodYn()))) {
                    isFinalLectEvalPeriod = true;
                }
                
                if(isMidLectEvalPeriod || isFinalLectEvalPeriod) {
                    lectEvalYn = "Y";
                }
            }
            
            model.addAttribute("lectEvalYn", lectEvalYn);
            model.addAttribute("langApiHeader", langApiHeader);
            model.addAttribute("lectEvalUrl", ErpUtil.getStuLectEvalUrl(creYear, creTerm, SessionInfo.getUserId(request)));

            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, vo.getCrsCreCd(), CommConst.ACTN_HSTY_SCORE_OVERALL, "성적조회");
        }

        /*
        String scoreOverAllYn = sysJobSch[0];
        String scoreObjtYn = sysJobSch[1];
        */
        String scoreOverAllYn = "1";
        String scoreObjtYn = "1";


        model.addAttribute("sCrsCreCd", vo.getCrsCreCd());
        model.addAttribute("sUserId", SessionInfo.getUserId(request));

        model.addAttribute("scoreOverAllYn", scoreOverAllYn);
        model.addAttribute("scoreObjtYn", scoreObjtYn);
        model.addAttribute("vo", vo);
        model.addAttribute("openYn", openYn);
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        return url;
    }
    
    // 성적조회
    @RequestMapping(value="/score/scoreOverall/selectStdCourseScore.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> selectStdCourseScore(ScoreOverallVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            
            ScoreOverallVO stdInfo = null;
            List<ScoreOverallVO> chartScoreList = null;
            ScoreOverallVO avgScoreInfo = null;
            
            TermVO termVO = new TermVO();
            termVO.setOrgId(orgId);
            termVO = termService.selectCurrentTerm(termVO);
            
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsVO = crecrsService.select(creCrsVO);
            
            String creYear = creCrsVO.getCreYear();
            String creTerm = creCrsVO.getCreTerm();
            
            String scoreSearchYn = "Y";
            
            // 업무일정 체크
            SysJobSchVO sysJobSchVO = new SysJobSchVO();
            sysJobSchVO.setOrgId(orgId);
            sysJobSchVO.setUseYn("Y");
            sysJobSchVO.setCalendarCtgr("00210210"); //성적조회기간
            sysJobSchVO.setHaksaYear(creYear);
            sysJobSchVO.setHaksaTerm(creTerm);
            sysJobSchVO = sysJobSchService.select(sysJobSchVO);
            
            if(sysJobSchVO == null || creYear.equals(termVO.getHaksaYear()) && creTerm.equals(termVO.getHaksaTerm()) && !"Y".equals(StringUtil.nvl(sysJobSchVO.getSysjobSchdlStartYn()))) {
                scoreSearchYn = "N";
            }
            
            if(!"Y".equals(StringUtil.nvl(sysJobSchVO.getSysjobSchdlStartYn()))) {
                scoreSearchYn = "N";
            }
            
            if("Y".equals(scoreSearchYn)) {
                stdInfo = scoreOverallService.selectScoreOverallStd(vo);
                avgScoreInfo = scoreOverallService.selectStdScore(vo);
                chartScoreList = scoreOverallService.chartScoreList(vo);
            }
            
            EgovMap egovMap = new EgovMap();
            egovMap.put("stdInfo", stdInfo);
            egovMap.put("chartScoreList", chartScoreList);
            egovMap.put("avgScoreInfo", avgScoreInfo);
        
            resultVO.setReturnVO(egovMap);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    @RequestMapping(value="/score/scoreOverallLect/Form/scoreOverallObjtMain.do")
    public String scoreOverallObjtMainForm(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        String openYn = scoreOverallService.selectOverallScoreOpenYn(vo);
        String url = "";
        
        // 현재 학기조회
        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        
        // 과목정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.select(creCrsVO);
        
        if(SessionInfo.getAuthrtGrpcd(request).contains("PROF")) {
            url = "score/overall/score_overall_objt_list";
        } else if(SessionInfo.getAuthrtGrpcd(request).contains("USR"))  {
            url = "score/overall/score_overall_std_objt_list";

            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, vo.getCrsCreCd(), CommConst.ACTN_HSTY_SCORE_OVERALL, "성적재확인신청 목록");
        }

        /*
        String scoreOverAllYn = sysJobSch[0];
        String scoreObjtYn = sysJobSch[1];
        */
        String scoreOverAllYn = "1";
        String scoreObjtYn = "1";


        model.addAttribute("sCrsCreCd", vo.getCrsCreCd());
        model.addAttribute("sUserId", SessionInfo.getUserId(request));

        model.addAttribute("scoreOverAllYn", scoreOverAllYn);
        model.addAttribute("scoreObjtYn", scoreObjtYn);
        model.addAttribute("vo", vo);
        model.addAttribute("openYn", openYn);
        model.addAttribute("termVO", termVO);
        model.addAttribute("creCrsVO", creCrsVO);

        model.addAttribute("classUserType", SessionInfo.getClassUserType(request));
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        return url;
    }

    @RequestMapping(value="/score/scoreOverall/selectScoreOverAllExcelDown.do")
    public String selectCreCrsExcelDown(ScoreOverallVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        
        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        vo.setOrgId(SessionInfo.getOrgId(request));
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.select(creCrsVO);
        
        String crsCreNm = creCrsVO.getCrsCreNm();
        String declsNo = creCrsVO.getDeclsNo();
        
        String title = "종합성적처리_" + crsCreNm + "_" + declsNo;
        
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", scoreOverallService.selectOverallExcelList(vo));

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    //종합평가 시 결시원 및 미평가 인원조회
    @RequestMapping(value="/score/scoreOverall/selectAbsentInfo.do")
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectAbsentInfo(ScoreOverallVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            ScoreOverallVO scoreOverallVO = scoreOverallService.selectExamAbsentCnt(vo);
            
            resultVO.setReturnVO(scoreOverallVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    // 환산 상태 조회
    @RequestMapping(value="/score/scoreOverall/selectBtnStatus.do")
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectBtnStatus(ScoreOverallVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            ScoreOverallVO scoreOverallVO = scoreOverallService.selectBtnStatus(vo);
            
            resultVO.setReturnVO(scoreOverallVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //일괄평가 시 주의사항 팝업
    @RequestMapping(value="/score/scoreOverall/scoreOverallEvlWarningPopup.do")
    public String scoreOverallEvlWarningPopup(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ScoreOverallVO curDate = scoreOverallService.selectCurDateFmt();
        model.addAttribute("curDateFmt", curDate.getCurDateFmt());
        return "score/overall/score_overall_evl_warning_popup";
    }

    //종합평가 리스트 조회
    @RequestMapping(value="/score/scoreOverall/selectOverallList.do")
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectOverallList(ScoreOverallVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            resultVO = scoreOverallService.selectOverallList(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //종합평가 성적환산상태 변경
    @RequestMapping(value="/score/scoreOverall/updateOverallScoreStatus.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> updateOverallScoreStatus(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            
            scoreOverallService.updateOverallScoreStatus(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //종합평가 리스트 저장
    @RequestMapping(value="/score/scoreOverall/saveOverallList.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> saveOverallList(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            
            scoreOverallService.saveOverallList(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }


    //종합평가 시 과목 평가 구분 조회
    @RequestMapping(value="/score/scoreOverall/selectCreCrsEval.do")
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectCreCrsEval(ScoreOverallVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            ScoreOverallVO scoreOverallVO = new ScoreOverallVO();
            scoreOverallVO.setScoreEvalType(scoreOverallService.selectCreCrsEval(vo));
       
            resultVO.setReturnVO(scoreOverallVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    // 상대평가 성적환산 팝업
    @RequestMapping(value="/score/scoreOverall/scoreOverallScoreCalRelativePopup.do")
    public String scoreOverallScoreCalRelativePopup(ScoreOverallScoreCalVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        
        vo.setOrgId(SessionInfo.getOrgId(request));
        ScoreOverallScoreCalVO resultVO = scoreOverallService.selectScoreRelConf(vo);
        ScoreOverallScoreCalVO resultRelVO = scoreOverallService.selectScoreRel(vo);
        int mustFCnt = scoreOverallService.selectScoreMustF(vo);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.select(creCrsVO);
        
        model.addAttribute("vo", vo);
        model.addAttribute("resultVO", resultVO);
        model.addAttribute("resultRelVO", resultRelVO);
        model.addAttribute("mustFCnt", mustFCnt);
        model.addAttribute("creCrsVO", creCrsVO);
        
        return "score/overall/score_overall_score_cal_relative_popup";
    }
    
    // 개설과정평가비율 조회 
    @RequestMapping(value="/score/scoreOverall/selectScoreRel.do")
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectScoreRel(ScoreOverallScoreCalVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            resultVO.setReturnVO(scoreOverallService.selectScoreRel(vo));
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    // 절대평가 성적환산 팝업
    @RequestMapping(value="/score/scoreOverall/scoreOverallScoreCalAbsolutePopup.do")
    public String scoreOverallScoreCalAbsolutePopup(ScoreOverallScoreCalVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.select(creCrsVO);
        
        model.addAttribute("vo", vo);
        model.addAttribute("creCrsVO", creCrsVO);
        return "score/overall/score_overall_score_cal_absolute_popup";
    }

    // PF 성적환산 팝업
    @RequestMapping(value="/score/scoreOverall/scoreOverallScoreCalPfPopup.do")
    public String scoreOverallScoreCalPfPopup(ScoreOverallScoreCalVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        model.addAttribute("vo", vo);
        return "score/overall/score_overall_score_cal_pf_popup";
    }

    // 성적등급 재조회
    @RequestMapping(value="/score/scoreOverall/selectModGrade.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectModGrade(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        try {
            ScoreOverallVO scoreOverallVO = scoreOverallService.selectModGrade(vo);
            resultVO.setReturnVO(scoreOverallVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //종합평가 상대평가 기준정보 저장 후 성적환산
    @RequestMapping(value="/score/scoreOverall/saveRelativeScoreConvert.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> saveRelativeScoreConvert(ScoreOverallScoreCalVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            
            scoreOverallService.saveRelativeScoreConvert(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("score.label.match.convert.fail.msg")); // 성적환산중 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //종합평가 절대평가  성적환산
    @RequestMapping(value="/score/scoreOverall/saveAbsoluteScoreConvert.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> saveAbsoluteScoreConvert(ScoreOverallScoreCalVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            
            scoreOverallService.saveAbsoluteScoreConvert(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("score.label.match.convert.fail.msg")); // 성적환산중 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //종합평가 P/F  성적환산
    @RequestMapping(value="/score/scoreOverall/savePfScoreConvert.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> savePfScoreConvert(ScoreOverallScoreCalVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            
            scoreOverallService.savePfScoreConvert(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("score.label.match.convert.fail.msg")); // 성적환산중 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //종합평가 초기화(LMS 데이터 가져오기)
    @RequestMapping(value="/score/scoreOverall/updateOverallScoreInit.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> updateOverallScoreInit(ScoreOverallScoreCalVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            
            scoreOverallService.updateOverallScoreInit(vo);
            resultVO.setResult(1);
        } catch (EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("score.label.match.convert.fail.msg")); // 성적환산중 에러가 발생했습니다!
        }
        
        return resultVO;
    }


    //종합평가 성적 등급 분포도 그래프 조회
    @RequestMapping(value="/score/scoreOverall/selectOverallGraphList.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectOverallGraphList(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        try {
            List<ScoreOverallVO> list = scoreOverallService.selectOverallGraphList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("score.label.match.convert.fail.msg")); // 성적환산중 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //종합평가 성적 등급 그리드 및 그래프 조회
    @RequestMapping(value="/score/scoreOverall/selectOverallGridCase.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectOverallGridCase(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        try {
            ScoreOverallVO scoreOverallVO = scoreOverallService.selectOverallGridCase(vo);
            resultVO.setReturnVO(scoreOverallVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("score.label.match.convert.fail.msg")); // 성적환산중 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //종합평가 성적 공개/미공개 수정
    @RequestMapping(value="/score/scoreOverall/updateOverallScoreOpenYn.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> updateOverallScoreOpenYn(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setMdfrId(userId);
            
            scoreOverallService.updateOverallScoreOpenYn(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("score.label.match.convert.fail.msg")); // 성적환산중 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //성적 재확인 신청하기 팝업(학생)
    @RequestMapping(value="/score/scoreOverall/scoreOverallScoreReCfmRegPopup.do")
    public String scoreOverallScoreReCfmRegPopup(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        vo.setUserId(SessionInfo.getUserId(request));
        ProcessResultVO<ScoreOverallVO> resultVo = scoreOverallService.selectOverallBaseInfo(vo);

        ScoreOverallVO curDate = scoreOverallService.selectCurDateFmt();
        model.addAttribute("curYear", curDate.getCurYear());
        model.addAttribute("curMonth", curDate.getCurMonth());
        model.addAttribute("curDay", curDate.getCurDay());

        model.addAttribute("tchVo", resultVo.getReturnVO());
        model.addAttribute("stdVo", resultVo.getReturnSubVO());

        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, vo.getCrsCreCd(), CommConst.ACTN_HSTY_SCORE_OVERALL, "성적재확인 신청하기");
        return "score/overall/score_overall_score_reCfm_reg_popup";
    }

    //성적 재확인 수정하기 팝업(학생)
    @RequestMapping(value="/score/scoreOverall/scoreOverallScoreReCfmModPopup.do")
    public String scoreOverallScoreReCfmModPopup(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        vo.setUserId(SessionInfo.getUserId(request));
        ProcessResultVO<ScoreOverallVO> resultVo = scoreOverallService.selectOverallModStdInfo(vo);

        ScoreOverallVO curDate = scoreOverallService.selectCurDateFmt();
        model.addAttribute("curYear", curDate.getCurYear());
        model.addAttribute("curMonth", curDate.getCurMonth());
        model.addAttribute("curDay", curDate.getCurDay());

        model.addAttribute("tchVo", resultVo.getReturnVO());
        model.addAttribute("stdVo", resultVo.getReturnSubVO());
        return "score/overall/score_overall_score_reCfm_reg_popup";
    }

    //성적 재확인 신청하기 저장(학생)
    @RequestMapping(value="/score/scoreOverall/insertStdScoreObjt.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> insertStdScoreObjt(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setObjtUserId(SessionInfo.getUserId(request));
            vo.setRgtrId(SessionInfo.getUserId(request));
            vo.setMdfrId(SessionInfo.getUserId(request));
            vo.setAuthrtGrpcd("USR");
            
            scoreOverallService.insertStdScoreObjt(vo);
            resultVO.setResult(1);
        } catch (EgovBizException | MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    //성적 재확인 신청하기 저장(교수)
    @RequestMapping(value="/score/scoreOverall/insertStdScoreObjtTch.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> insertStdScoreObjtTch(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(SessionInfo.getUserId(request));
            vo.setMdfrId(SessionInfo.getUserId(request));
            vo.setAuthrtGrpcd(SessionInfo.getAuthrtGrpcd(request));
            
            scoreOverallService.insertStdScoreObjt(vo);
            resultVO.setResult(1);
        } catch (EgovBizException | MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //성적 재확인 신청하기 수정(학생)
    @RequestMapping(value="/score/scoreOverall/updateStdScoreObjt.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> updateStdScoreObjt(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        try {
            vo.setOrgId(SessionInfo.getOrgId(request));
            vo.setUserId(SessionInfo.getUserId(request));
            vo.setRgtrId(SessionInfo.getUserId(request));
            vo.setMdfrId(SessionInfo.getUserId(request));
            
            scoreOverallService.updateStdScoreObjt(vo);
            
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //성적 재확인 리스트 조회(학생,교수)
    @RequestMapping(value="/score/scoreOverall/selectScoreObjtList.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectScoreObjtList(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        
        try {
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 강의실 정보를 찾을 수 없거나 비정상적인 접근입니다. 웹브라우저를 다시 시작하여 접속하세요. 오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.not.found.course.error"));
            }
            
            vo.setUserId(userId);
            vo.setAuthrtGrpcd(menuType);
            
            List<ScoreOverallVO> list = scoreOverallService.selectScoreObjtList(vo);
            
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
    
    //성적 재확인 리스트 조회(교수)
    @RequestMapping(value="/score/scoreOverall/selectScoreObjtTchList.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectScoreObjtTchList(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            
            List<ScoreOverallVO> list = scoreOverallService.selectScoreObjtTchList(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //이의신청 사유보기 팝업(교수)
    @RequestMapping(value="/score/scoreOverall/scoreOverallObjtCtntPopup.do")
    public String scoreOverallObjtCtntPopup(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ScoreOverallVO scoreOverallVO = scoreOverallService.selectScoreObjtCtnt(vo);

        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("SCORE_OBJT");
        fileVO.setFileBindDataSn(vo.getScoreObjtCd());
        ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);
        for(FileVO fvo : fileList.getReturnList()) {
            fvo.setFileId(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")));
        }
        
        model.addAttribute("vo", vo);
        model.addAttribute("scoreOverallVO", scoreOverallVO);
        model.addAttribute("fileList", fileList.getReturnList());
        
        return "score/overall/score_overall_objt_ctnt_popup";
    }

    //성적 재확인 대상자 과목 정보(교수)
    @RequestMapping(value="/score/scoreOverall/scoreOverallScoreReCfmTchRegPopup.do")
    public String scoreOverallScoreReCfmTchRegPopup(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        
        vo.setOrgId(SessionInfo.getOrgId(request));
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        String termCd = termVO.getTermCd();
        
        List<CreCrsVO> crsCreList = new ArrayList<>();
        
        if(ValidationUtils.isEmpty(crsCreCd)) {
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setUserId(userId);
            // 아래 하드코딩으로 되어 있는부분은 추후 수정 필요
            creCrsVO.setTermCd("TERM_202420");
            crsCreList = crecrsService.listMainMypageTch(creCrsVO);
        } else {
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(crsCreCd);
            creCrsVO = crecrsService.select(creCrsVO);
            
            crsCreList.add(creCrsVO);
        }

        model.addAttribute("vo", vo);
        model.addAttribute("termVO", termVO);
        model.addAttribute("crsCreList", crsCreList);
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        
        return "score/overall/score_overall_score_reCfm_tch_reg_popup";
    }

    //성적 재확인 대상자 리스트 조회(교수)
    @RequestMapping(value="/score/scoreOverall/selectScoreObjtRegList.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectScoreObjtRegList(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            List<ScoreOverallVO> list = scoreOverallService.selectScoreObjtRegList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    //성적 재확인 대상자 리스트 조회(교수)
    @RequestMapping(value="/score/scoreOverall/downExcelScoreObjtRegList.do" )
    public String downExcelScoreObjtRegList(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        String[] searchValues = {getMessage("common.search.condition") + " : " + StringUtil.nvl(vo.getSearchValue())};
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        List<ScoreOverallVO> list = scoreOverallService.selectScoreObjtRegList(vo);
        
        String title = getMessage("score.label.answer.list"); // 성적재확인 신청목록
        
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

    //성적 변경처리(교수)
    @RequestMapping(value="/score/scoreOverall/scoreOverallObjtProcPopup.do")
    public String scoreOverallObjtProcPopup(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));

        ScoreOverallVO scoreOverallVO = scoreOverallService.selectScoreObjtReg(vo);

        // 첨부파일 조회
        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("SCORE_OBJT");
        fileVO.setFileBindDataSn(vo.getScoreObjtCd());
        ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);
        for(FileVO fvo : fileList.getReturnList()) {
            fvo.setFileId(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")));
        }

        model.addAttribute("vo", vo);
        model.addAttribute("scoreOverallVO", scoreOverallVO);
        model.addAttribute("objtUserId", StringUtil.nvl(vo.getObjtUserId()));
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        model.addAttribute("fileList", fileList.getReturnList());

        return "score/overall/score_overall_objt_proc_popup";
    }

    //성적 변경처리 대상자 리스트 조회(교수)
    @RequestMapping(value="/score/scoreOverall/selectScoreObjtProcList.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectScoreObjtProcList(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            List<ScoreOverallVO> list = scoreOverallService.selectScoreObjtProcList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //성적 재확인 신청하기 저장(학생)
    @RequestMapping(value="/score/scoreOverall/updateScoreObjtProc.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> updateScoreObjtProc(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setMdfrId(SessionInfo.getUserId(request));
            scoreOverallService.updateScoreObjtProc(vo);
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


    //성적재확인신청처리->항목별 점수 상세 팝업(교수)
    @RequestMapping(value="/score/scoreOverall/scoreOverallScoreDtlPopup.do")
    public String scoreOverallScoreDtlPopup(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        vo.setOrgId( SessionInfo.getOrgId(request));
        ScoreOverallVO rVo =  scoreOverallService.selectOverallScoreDtl(vo);

        model.addAttribute("rVo", rVo);
        return "score/overall/score_overall_score_dtl_popup";
    }

    //종합성적탭 - 학생 메모(교수)
    @RequestMapping(value="/score/scoreOverall/scoreOverallStdMemoPopup.do")
    public String scoreOverallStdMemoPopup(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        vo.setSelectType("OBJECT");

        ScoreOverallVO dVo = scoreOverallService.selectStdMemo(vo);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        model.addAttribute("cVo", crecrsService.selectCreCrs(creCrsVO));
        model.addAttribute("dVo", dVo);
        model.addAttribute("vo", vo);

        return "score/overall/score_overall_std_memo_popup";
    }

    //성적 메모하기 저장(교수)
    @RequestMapping(value="/score/scoreOverall/updateStdMemo.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> updateStdMemo(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        try {
            vo.setMdfrId(SessionInfo.getUserId(request));
            scoreOverallService.updateStdMemo(vo);
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

    //종합성적처리리스트 - 상세 팝업(교수)
    @RequestMapping(value="/score/scoreOverall/scoreOverallDtlPopup.do")
    public String scoreOverallScoreOverallDtlPopup(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        vo.setOrgId( SessionInfo.getOrgId(request));
        ScoreOverallVO stdInfo = scoreOverallService.selectOverallStdInfo(vo);
        List<ScoreOverallVO> chartScoreList = scoreOverallService.chartScoreList(vo);
        List<ScoreOverallVO> avgScoreList = scoreOverallService.avgScoreList(vo);

        //강의
        ScoreOverallVO lessonInfo = scoreOverallService.selectLessonInfo(vo);

        //중간고사
        vo.setExamStareTypeCd("M");
        List<ScoreOverallVO> midTestList = scoreOverallService.selectTestsDtlList(vo);

        //기말고사
        vo.setExamStareTypeCd("L");
        List<ScoreOverallVO> lastTestList = scoreOverallService.selectTestsDtlList(vo);

        //퀴즈
        List<ScoreOverallVO> quizList = scoreOverallService.selectQuizDtlList(vo);
        //상시평가
        List<ScoreOverallVO> testList = scoreOverallService.selectTestDtlList(vo);
        //과제
        List<ScoreOverallVO> asmntList = scoreOverallService.selectAsmntDtlList(vo);
        //토론
        List<ScoreOverallVO> forumList = scoreOverallService.selectForumDtlList(vo);

        model.addAttribute("lessonInfo", lessonInfo);
        model.addAttribute("midTestList", midTestList);
        model.addAttribute("lastTestList", lastTestList);
        model.addAttribute("quizList", quizList);
        model.addAttribute("testList", testList);
        model.addAttribute("asmntList", asmntList);
        model.addAttribute("forumList", forumList);


        model.addAttribute("stdInfo", stdInfo);
        model.addAttribute("chartScoreList", chartScoreList);
        model.addAttribute("avgScoreList", avgScoreList);
        return "score/overall/score_overall_dtl_popup";
    }

    @RequestMapping(value="/score/scoreOverall/selectScoreObjtTchExcelDown.do")
    public String selectScoreObjtTchExcelDown(ScoreOverallVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        HashMap<String, Object> map = new HashMap<>();

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        String title = getMessage("score.label.objt.list"); // 성적재확인신청목록
        
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        List<ScoreOverallVO> list = scoreOverallService.selectScoreObjtTchList(vo);
        
        map.put("title", title);
        map.put("sheetName", title);
        map.put("list", list);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("workbook", scoreObjtExcel(map, request));
        modelMap.put("list", list);
        modelMap.put("sheetName", title);
        model.addAllAttributes(modelMap);


        return "excelView";
    }

    public SXSSFWorkbook scoreObjtExcel(HashMap<String, Object> map, HttpServletRequest request)  {
        String title = StringUtil.nvl(map.get("title"));
        String sheetName = StringUtil.nvl(map.get("sheetName"),"sheet1");
        List<ScoreOverallVO> resultList = (List<ScoreOverallVO>) map.get("list");

        SXSSFWorkbook workbook = null;
        SXSSFSheet worksheet = null;
        SXSSFRow row = null;

        int colSize = 10;

        String ext = StringUtil.nvl(map.get("ext"));
        if(StringUtil.isNull(ext)) {
           ext = ".xlsx";
        }

        workbook = new SXSSFWorkbook();
        // 새로운 sheet를 생성한다.
        worksheet = workbook.createSheet(sheetName);

        //폰트 설정
        Font fontTitle = workbook.createFont();
        fontTitle.setFontHeight((short)(16*25)); //사이즈
        fontTitle.setBold(true);

        //폰트 설정
        Font font1 = workbook.createFont();
        font1.setFontName("나눔고딕"); //글씨체
        font1.setFontHeight((short)(16*10)); //사이즈
        font1.setBold(true);

        // 셀 스타일 및 폰트 설정
        CellStyle styleTitle = workbook.createCellStyle();
        //정렬
        styleTitle.setAlignment(HorizontalAlignment.CENTER);
        styleTitle.setVerticalAlignment(VerticalAlignment.CENTER);
        styleTitle.setBorderRight(BorderStyle.NONE);
        styleTitle.setBorderLeft(BorderStyle.NONE);
        styleTitle.setBorderTop(BorderStyle.NONE);
        styleTitle.setBorderBottom(BorderStyle.NONE);
        styleTitle.setFont(fontTitle);

        // 셀 스타일 및 폰트 설정
        CellStyle styleCulums = workbook.createCellStyle();
        //정렬
        styleCulums.setAlignment(HorizontalAlignment.CENTER); //왼쪽 정렬
        styleCulums.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleCulums.setBorderRight(BorderStyle.NONE);
        styleCulums.setBorderLeft(BorderStyle.NONE);
        styleCulums.setBorderTop(BorderStyle.NONE);
        styleCulums.setBorderBottom(BorderStyle.NONE);
        styleCulums.setFont(font1);

        // 셀 스타일 및 폰트 설정
        CellStyle styleContent = workbook.createCellStyle();
        //정렬
        styleContent.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
        styleContent.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleContent.setBorderRight(BorderStyle.NONE);
        styleContent.setBorderLeft(BorderStyle.NONE);
        styleContent.setBorderTop(BorderStyle.NONE);
        styleContent.setBorderBottom(BorderStyle.NONE);
        styleContent.setFont(font1);

        // 칼럼 길이 설정
        worksheet.setColumnWidth(0, 1500);
        worksheet.setColumnWidth(1, 2500);
        worksheet.setColumnWidth(2, 5000);
        worksheet.setColumnWidth(3, 1500);
        worksheet.setColumnWidth(4, 3000);
        worksheet.setColumnWidth(5, 5000);
        worksheet.setColumnWidth(6, 3000);
        worksheet.setColumnWidth(7, 5000);
        worksheet.setColumnWidth(8, 3000);
        worksheet.setColumnWidth(9, 5000);
        worksheet.setColumnWidth(10, 5000);
        worksheet.setColumnWidth(11, 1500);
        worksheet.setColumnWidth(12, 3000);
        worksheet.setColumnWidth(13, 3000);
        worksheet.setColumnWidth(14, 3000);
        worksheet.setColumnWidth(15, 3000);
        worksheet.setColumnWidth(16, 5000);

        int rowNum = -1;
        // TITLE
        row = worksheet.createRow(++rowNum);
        for(int j=0;j<colSize;j++) {
            row.createCell(j).setCellValue(title);
            row.getCell(j).setCellStyle(styleTitle);
        }

        // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
        if(colSize>1) {
            worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, colSize));
        }

        // 빈행
        row = worksheet.createRow(++rowNum);
        for(int j=0;j<colSize;j++) {
            row.createCell(j).setCellValue("");
        }

        row = worksheet.createRow(++rowNum);
        row.createCell(0).setCellValue("NO."); row.getCell(0).setCellStyle(styleCulums);
        row.createCell(1).setCellValue("학수번호"); row.getCell(1).setCellStyle(styleCulums);
        row.createCell(2).setCellValue("과목명"); row.getCell(2).setCellStyle(styleCulums);
        row.createCell(3).setCellValue("분반"); row.getCell(3).setCellStyle(styleCulums);
        row.createCell(4).setCellValue("교수명"); row.getCell(4).setCellStyle(styleCulums);
        row.createCell(6).setCellValue("조교명"); row.getCell(6).setCellStyle(styleCulums);
        row.createCell(8).setCellValue("학생정보"); row.getCell(8).setCellStyle(styleCulums); // 학생정보
        row.createCell(12).setCellValue("변경전성적"); row.getCell(12).setCellStyle(styleCulums); // 변경전성적
        row.createCell(14).setCellValue("변경후성적"); row.getCell(14).setCellStyle(styleCulums); // 변경전성적
        row.createCell(16).setCellValue("처리상태"); row.getCell(16).setCellStyle(styleCulums); // 처리상태

        row = worksheet.createRow(++rowNum);
        row.createCell(4).setCellValue("사번"); row.getCell(4).setCellStyle(styleCulums); // 사번
        row.createCell(5).setCellValue("성명"); row.getCell(5).setCellStyle(styleCulums); // 성명
        row.createCell(6).setCellValue("사번"); row.getCell(6).setCellStyle(styleCulums); // 사번
        row.createCell(7).setCellValue("성명"); row.getCell(7).setCellStyle(styleCulums); // 성명
        row.createCell(8).setCellValue("학과"); row.getCell(8).setCellStyle(styleCulums); // 학과
        row.createCell(9).setCellValue("학번"); row.getCell(9).setCellStyle(styleCulums); // 학번
        row.createCell(10).setCellValue("성명"); row.getCell(10).setCellStyle(styleCulums); // 성명
        row.createCell(11).setCellValue("학년"); row.getCell(11).setCellStyle(styleCulums); // 학년
        row.createCell(12).setCellValue("점수"); row.getCell(12).setCellStyle(styleCulums); // 점수
        row.createCell(13).setCellValue("등급"); row.getCell(13).setCellStyle(styleCulums); // 등급
        row.createCell(14).setCellValue("점수"); row.getCell(14).setCellStyle(styleCulums); // 점수
        row.createCell(15).setCellValue("등급"); row.getCell(15).setCellStyle(styleCulums); // 등급

        worksheet.addMergedRegion(new CellRangeAddress(rowNum-1, rowNum, 0, 0));
        worksheet.addMergedRegion(new CellRangeAddress(rowNum-1, rowNum, 1, 1));
        worksheet.addMergedRegion(new CellRangeAddress(rowNum-1, rowNum, 2, 2));
        worksheet.addMergedRegion(new CellRangeAddress(rowNum-1, rowNum, 3, 3));
        worksheet.addMergedRegion(new CellRangeAddress(rowNum-1, rowNum-1, 4, 5));
        worksheet.addMergedRegion(new CellRangeAddress(rowNum-1, rowNum-1, 6, 7));
        worksheet.addMergedRegion(new CellRangeAddress(rowNum-1, rowNum-1, 8, 11));
        worksheet.addMergedRegion(new CellRangeAddress(rowNum-1, rowNum-1, 12, 13));
        worksheet.addMergedRegion(new CellRangeAddress(rowNum-1, rowNum-1, 14, 15));
        worksheet.addMergedRegion(new CellRangeAddress(rowNum-1, rowNum, 16, 16));

        for (int i = 0; i < resultList.size(); i++) {
            ScoreOverallVO vo = resultList.get(i);
            row = worksheet.createRow(++rowNum);
            String lineNo = vo.getLineNo();
            String crsCd = StringUtil.nvl(vo.getCrsCd());
            String crsCreNm = StringUtil.nvl(vo.getCrsCreNm());
            String declsNo = StringUtil.nvl(vo.getDeclsNo());
            String profUserId = StringUtil.nvl(vo.getProfUserId());
            String profUserNm = StringUtil.nvl(vo.getProfUserNm());
            String tutUserId = StringUtil.nvl(vo.getTutUserId());
            String tutUserNm = StringUtil.nvl(vo.getTutUserNm());
            String deptNm = StringUtil.nvl(vo.getDeptNm());
            String objtUserId = StringUtil.nvl(vo.getObjtUserId());
            String objtUserNm = StringUtil.nvl(vo.getObjtUserNm());
            String hy = StringUtil.nvl(vo.getHy());

            String modScore = StringUtil.nvl(vo.getModScore());
            String modGrade = StringUtil.nvl(vo.getModGrade());
            String prvScore = StringUtil.nvl(vo.getPrvScore());
            String prvGrade = StringUtil.nvl(vo.getPrvGrade());

            String procNm = StringUtil.nvl(vo.getProcNm());

            row.createCell(0).setCellValue(StringUtil.nvl(lineNo)); row.getCell(0).setCellStyle(styleContent);
            row.createCell(1).setCellValue(StringUtil.nvl(crsCd)); row.getCell(1).setCellStyle(styleContent);
            row.createCell(2).setCellValue(StringUtil.nvl(crsCreNm)); row.getCell(2).setCellStyle(styleContent);
            row.createCell(3).setCellValue(StringUtil.nvl(declsNo)); row.getCell(3).setCellStyle(styleContent);
            row.createCell(4).setCellValue(StringUtil.nvl(profUserId)); row.getCell(4).setCellStyle(styleContent);
            row.createCell(5).setCellValue(StringUtil.nvl(profUserNm)); row.getCell(5).setCellStyle(styleContent);
            row.createCell(6).setCellValue(StringUtil.nvl(tutUserId)); row.getCell(6).setCellStyle(styleContent);
            row.createCell(7).setCellValue(StringUtil.nvl(tutUserNm)); row.getCell(7).setCellStyle(styleContent);
            row.createCell(8).setCellValue(StringUtil.nvl(deptNm)); row.getCell(8).setCellStyle(styleContent);
            row.createCell(9).setCellValue(StringUtil.nvl(objtUserId));  row.getCell(9).setCellStyle(styleContent);
            row.createCell(10).setCellValue(StringUtil.nvl(objtUserNm)); row.getCell(10).setCellStyle(styleContent);
            row.createCell(11).setCellValue(StringUtil.nvl(hy)); row.getCell(11).setCellStyle(styleContent);
            row.createCell(12).setCellValue(StringUtil.nvl(prvScore)); row.getCell(12).setCellStyle(styleContent);
            row.createCell(13).setCellValue(StringUtil.nvl(prvGrade)); row.getCell(13).setCellStyle(styleContent);
            row.createCell(14).setCellValue(StringUtil.nvl(modScore)); row.getCell(14).setCellStyle(styleContent);
            row.createCell(15).setCellValue(StringUtil.nvl(modGrade)); row.getCell(15).setCellStyle(styleContent);
            row.createCell(16).setCellValue(StringUtil.nvl(procNm)); row.getCell(16).setCellStyle(styleContent);
        }

        return workbook;
    }


    //이의신청탭 - 답변확인(학생)
    @RequestMapping(value="/score/scoreOverall/scoreOverallObjtProcCfmPopup.do")
    public String scoreOverallObjtProcCfmPopup(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        ProcessResultVO<ScoreOverallVO> resultVo = scoreOverallService.selectObjtProcCfmInfo(vo);

        model.addAttribute("resultVo", resultVo.getReturnVO());

        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, vo.getCrsCreCd(), CommConst.ACTN_HSTY_SCORE_OVERALL, "성적재확인 댑변확인");
        return "score/overall/score_overall_objt_proc_cfm_popup";
    }

    //환산완료시 환산총점 수동 입력 (교수)
    @RequestMapping(value="/score/scoreOverall/updateTotScoreByStdNo.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> updateTotScoreByStdNo(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setMdfrId(SessionInfo.getUserId(request));
            scoreOverallService.updateTotScoreByStdNo(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    // 강의실 홈 성적 재확인 메인페이지
    @RequestMapping(value="/score/scoreOverall/scoreOverallCourseMain.do")
    public String scoreOverallCourseMain(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        
        // 성적재확인신청정정기간(학부)
        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        String calendarCtgr = "00210203";
        sysJobSchVO.setOrgId(orgId);
        sysJobSchVO.setCalendarCtgr(calendarCtgr);
        sysJobSchVO.setTermCd(termVO.getTermCd());
        sysJobSchVO = sysJobSchService.select(sysJobSchVO);
        model.addAttribute("sysJobSchVO", sysJobSchVO);
        
        // 성적재확인 신청기간(대학원)
        sysJobSchVO = new SysJobSchVO();
        calendarCtgr = "00210205";
        sysJobSchVO.setOrgId(orgId);
        sysJobSchVO.setCalendarCtgr(calendarCtgr);
        sysJobSchVO.setTermCd(termVO.getTermCd());
        sysJobSchVO = sysJobSchService.select(sysJobSchVO);
        model.addAttribute("sysJobSchVOGraduate", sysJobSchVO);

        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "score/overall/score_overall_course_list";
    }

    //성적 재확인 기간 조회(관리자)
    @RequestMapping(value="/score/scoreOverall/selectScoreObjtCtgrAdmin.do" )
    @ResponseBody
    public ProcessResultVO<SysJobSchVO> selectScoreObjtCtgrAdmin(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<SysJobSchVO> resultVO = new ProcessResultVO<SysJobSchVO>();
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        try {
            SysJobSchVO sysJobSchVO = new SysJobSchVO();
            sysJobSchVO.setOrgId(orgId);
            sysJobSchVO.setCalendarCtgr("00210203"); // 성적재확인신청정정기간 (학부)
            sysJobSchVO.setHaksaYear(vo.getCreYear());
            sysJobSchVO.setHaksaTerm(vo.getCreTerm());
            
            resultVO.setReturnVO(sysJobSchService.select(sysJobSchVO));
            sysJobSchVO.setCalendarCtgr("00210205"); // 성적재확인신청정정기간 (대학원)
            resultVO.setReturnSubVO(sysJobSchService.select(sysJobSchVO));
            
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }

    //성적 재확인 리스트 조회(관리자)
    @RequestMapping(value="/score/scoreOverall/selectScoreObjtListAdmin.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectScoreObjtListAdmin(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            List<ScoreOverallVO> list = scoreOverallService.selectScoreObjtListAdmin(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }

    @RequestMapping(value="/score/scoreOverall/selectScoreObjtExcelDownAdmin.do")
    public String selectScoreObjtExcelDownAdmin(ScoreOverallVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        HashMap<String, Object> map = new HashMap<>();

        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setAuthrtGrpcd(SessionInfo.getAuthrtGrpcd(request));

        List<ScoreOverallVO> list = scoreOverallService.selectScoreObjtListAdmin(vo);

        map.put("title", "성적이의신청");
        map.put("sheetName", "성적이의신청");
        map.put("list", list);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", "성적이의신청");
        modelMap.put("workbook", scoreObjtExcel(map, request));
        modelMap.put("list", list);
        modelMap.put("sheetName", "성적이의신청");
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    //성적 변경처리 조회
    @RequestMapping(value="/score/scoreOverall/scoreOverallObjtViewPopup.do")
    public String scoreOverallObjtViewPopup(ScoreOverallVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));

        ScoreOverallVO resultVo = scoreOverallService.selectScoreObjtReg(vo);

        // 첨부파일 조회
        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("SCORE_OBJT");
        fileVO.setFileBindDataSn(vo.getScoreObjtCd());
        ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);
        for(FileVO fvo : fileList.getReturnList()) {
            fvo.setFileId(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")));
        }

        model.addAttribute("vo", resultVo);
        model.addAttribute("objtUserId", StringUtil.nvl(vo.getObjtUserId()));
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        model.addAttribute("fileList", fileList.getReturnList());

        return "score/overall/score_overall_objt_view_popup";
    }

    //성적 재확인 리스트 조회(학생)
    @RequestMapping(value="/score/scoreOverall/selectStdScoreObjtList.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectStdScoreObjtList(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        vo.setUserId(SessionInfo.getUserId(request));
        
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String creYear = vo.getCreYear();
        String creTerm = vo.getCreTerm();
        String scoreSearchYn = "Y";
        
        try {
            vo.setUserId(userId);
            
            TermVO termVO = new TermVO();
            termVO.setOrgId(SessionInfo.getOrgId(request));
            termVO = termService.selectCurrentTerm(termVO);
            
            // 현재학기 경우
            SysJobSchVO sysJobSchVO = new SysJobSchVO();
            sysJobSchVO.setOrgId(orgId);
            sysJobSchVO.setUseYn("Y");
            sysJobSchVO.setCalendarCtgr("00210210"); //성적조회기간
            sysJobSchVO.setHaksaYear(creYear);
            sysJobSchVO.setHaksaTerm(creTerm);
            sysJobSchVO = sysJobSchService.select(sysJobSchVO);
            
            if(sysJobSchVO == null || creYear.equals(termVO.getHaksaYear()) && creTerm.equals(termVO.getHaksaTerm()) && !"Y".equals(StringUtil.nvl(sysJobSchVO.getSysjobSchdlStartYn()))) {
                scoreSearchYn = "N";
            }
            
            if(!"Y".equals(StringUtil.nvl(sysJobSchVO.getSysjobSchdlStartYn()))) {
            	scoreSearchYn = "N";
            }
            
            vo.setScoreSearchYn(scoreSearchYn);
           
            List<ScoreOverallVO> list = scoreOverallService.selectStdScoreObjtList(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    //종합평가 리스트 조회
    @RequestMapping(value="/score/scoreOverall/selectOverallListAdmin.do")
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectOverallListAdmin(ScoreOverallVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            resultVO = scoreOverallService.selectOverallList(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    @RequestMapping(value="/score/scoreOverall/selectScoreOverAllExcelDownAdmin.do")
    public String selectCreCrsExcelDownAdmin(ScoreOverallVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        if(ValidationUtils.isEmpty(vo.getCrsCreCd())) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        vo.setOrgId( SessionInfo.getOrgId(request) );
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "종합성적처리");
        map.put("sheetName", "종합성적처리");
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", scoreOverallService.selectOverallExcelList(vo));

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", "종합성적처리");

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    //종합평가 성적 등급 분포도 그래프 조회
    @RequestMapping(value="/score/scoreOverall/selectOverallGraphListAdmin.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectOverallGraphListAdmin(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        try {
            List<ScoreOverallVO> list = scoreOverallService.selectOverallGraphList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("score.label.match.convert.fail.msg")); // 성적환산중 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    //종합평가 성적 등급 분포도 그래프 조회 (등급)
    @RequestMapping(value="/score/scoreOverall/selectOverallGraphListByGrade.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectOverallGraphListByGrade(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        try {
            List<ScoreOverallVO> list = scoreOverallService.selectOverallGraphListByGrade(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    //종합평가 성적 등급 그리드 및 그래프 조회
    @RequestMapping(value="/score/scoreOverall/selectOverallGridCaseAdmin.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectOverallGridCaseAdmin(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        try {
            ScoreOverallVO scoreOverallVO = scoreOverallService.selectOverallGridCase(vo);
            resultVO.setReturnVO(scoreOverallVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("score.label.match.convert.fail.msg")); // 성적환산중 에러가 발생했습니다!
        }
        
        return resultVO;
    }

    @RequestMapping(value="/score/scoreOverall/selectOverallStdInfoAdmin.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectOverallStdInfoAdmin(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        try {
            resultVO = scoreOverallService.selectOverallStdInfoAdmin(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    @RequestMapping(value="/score/scoreOverall/beforeScoreExcelDown.do")
    public String beforeScoreExcelDown(ScoreOverallVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        vo.setOrgId( SessionInfo.getOrgId(request) );
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "확정 전 성적");
        map.put("sheetName", "확정 전 성적");
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", scoreOverallService.selectOverallStdInfoAdmin(vo).getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", "확정 전 성적");

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }
    
    // 테스트 성적 저장
    @RequestMapping(value="/score/scoreOverall/insertTestScore.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> insertTestScore(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        
        try {
            vo.setOrgId(orgId);
            
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(crsCreCd);
            creCrsVO = crecrsService.select(creCrsVO);
            
            ScoreOverallVO evalSearchVO = new ScoreOverallVO();
            evalSearchVO.setCrsCreCd(crsCreCd);
            String creCrsEval = scoreOverallService.selectCreCrsEval(evalSearchVO);
            
            List<ScoreOverallVO> scoreItemConfList = scoreOverallService.selectScoreItemConfList(evalSearchVO);
            boolean useLesson = true;
            boolean useMidTest = true;
            boolean useLastTest = true;
            boolean useTest = true;
            boolean useAsmnt = true;
            boolean useForum = true;
            boolean useQuiz = true;
            boolean useResh = true;
            
            for(ScoreOverallVO scoreItemConf : scoreItemConfList) {
                if("LESSON".equals(StringUtil.nvl(scoreItemConf.getScoreTypeCd())) && Integer.valueOf(scoreItemConf.getScoreRatio()) == 0) {
                    useLesson = false;
                }
                if("MIDDLE_TEST".equals(StringUtil.nvl(scoreItemConf.getScoreTypeCd())) && Integer.valueOf(scoreItemConf.getScoreRatio()) == 0) {
                    useMidTest = false;
                }
                if("LAST_TEST".equals(StringUtil.nvl(scoreItemConf.getScoreTypeCd())) && Integer.valueOf(scoreItemConf.getScoreRatio()) == 0) {
                    useLastTest = false;
                }
                if("TEST".equals(StringUtil.nvl(scoreItemConf.getScoreTypeCd())) && Integer.valueOf(scoreItemConf.getScoreRatio()) == 0) {
                    useTest = false;
                }
                if("ASSIGNMENT".equals(StringUtil.nvl(scoreItemConf.getScoreTypeCd())) && Integer.valueOf(scoreItemConf.getScoreRatio()) == 0) {
                    useAsmnt = false;
                }
                if("FORUM".equals(StringUtil.nvl(scoreItemConf.getScoreTypeCd())) && Integer.valueOf(scoreItemConf.getScoreRatio()) == 0) {
                    useForum = false;
                }
                if("QUIZ".equals(StringUtil.nvl(scoreItemConf.getScoreTypeCd())) && Integer.valueOf(scoreItemConf.getScoreRatio()) == 0) {
                    useQuiz = false;
                }
                if("RESH".equals(StringUtil.nvl(scoreItemConf.getScoreTypeCd())) && Integer.valueOf(scoreItemConf.getScoreRatio()) == 0) {
                    useResh = false;
                }
            }
            String yy = creCrsVO.getCreYear();
            String tmGbn = creCrsVO.getCreTerm();
            String scCd = creCrsVO.getCrsCd();
            String ltNo = creCrsVO.getDeclsNo();
            
            ProcessResultVO<ScoreOverallVO> result = scoreOverallService.selectOverallList(vo);
            List<ScoreOverallVO> resultList = result.getReturnList();
            
            List<ErpScoreTestVO> insertList = new ArrayList<>();
            
            for(ScoreOverallVO scoreOverallVO : resultList) {
                ErpScoreTestVO erpScoreTestVO = new ErpScoreTestVO();
                
                ScoreOverallVO stdScoreVO = scoreOverallService.selectScoreOverallStd(scoreOverallVO);
                
                erpScoreTestVO.setYy(yy);
                erpScoreTestVO.setTmGbn(tmGbn);
                erpScoreTestVO.setScCd(scCd);
                erpScoreTestVO.setLtNo(ltNo);
                erpScoreTestVO.setStuno(scoreOverallVO.getUserId());
                // 중간
                if(useMidTest) {
                    String score = StringUtil.nvl(scoreOverallVO.getMiddleTestScore());
                    
                    if("-".equals(score)) {
                        score = "0";
                    }
                    
                    erpScoreTestVO.setIniScr1(Float.valueOf(score) < 0 ? 0 : Float.valueOf(score));
                } else {
                    erpScoreTestVO.setIniScr1(0);
                }
                // 기말
                if(useLastTest) {
                    String score = StringUtil.nvl(scoreOverallVO.getLastTestScore());
                    
                    if("-".equals(score)) {
                        score = "0";
                    }
                    
                    erpScoreTestVO.setIniScr2(Float.valueOf(score) < 0 ? 0 : Float.valueOf(score));
                } else {
                    erpScoreTestVO.setIniScr2(0);
                }
                // 과제
                if(useAsmnt) {
                    String score = StringUtil.nvl(scoreOverallVO.getAssignmentScore());
                    
                    if("-".equals(score)) {
                        score = "0";
                    }
                    
                    erpScoreTestVO.setIniScr3(Float.valueOf(score) < 0 ? 0 : Float.valueOf(score));
                } else {
                    erpScoreTestVO.setIniScr3(0);
                }
                // 출석
                if(useLesson) {
                    String score = StringUtil.nvl(scoreOverallVO.getLessonScore());
                    
                    if("-".equals(score)) {
                        score = "0";
                    }
                    
                    erpScoreTestVO.setIniScr4(Float.valueOf(score) < 0 ? 0 : Float.valueOf(score));
                } else {
                    erpScoreTestVO.setIniScr4(0);
                }
                
                erpScoreTestVO.setIniScr5(0);
                erpScoreTestVO.setIniScr6(0);
                // 토론
                if(useForum) {
                    String score = StringUtil.nvl(scoreOverallVO.getForumScore());
                    
                    if("-".equals(score)) {
                        score = "0";
                    }
                    
                    erpScoreTestVO.setIniScr7(Float.valueOf(score) < 0 ? 0 : Float.valueOf(score));
                } else {
                    erpScoreTestVO.setIniScr7(0);
                }
                erpScoreTestVO.setIniScr8(0);
                erpScoreTestVO.setIniScr9(0);
                // 기타
                erpScoreTestVO.setIniScr10(0);
                // 퀴즈
                if(useQuiz) {
                    String score = StringUtil.nvl(scoreOverallVO.getQuizScore());
                    
                    if("-".equals(score)) {
                        score = "0";
                    }
                    
                    erpScoreTestVO.setIniScr11(Float.valueOf(score) < 0 ? 0 : Float.valueOf(score));
                } else {
                    erpScoreTestVO.setIniScr11(0);
                }
                // 설문
                if(useResh) {
                    String score = StringUtil.nvl(scoreOverallVO.getReshScore());
                    
                    if("-".equals(score)) {
                        score = "0";
                    }
                    
                    erpScoreTestVO.setIniScr12(Float.valueOf(score) < 0 ? 0 : Float.valueOf(score));
                } else {
                    erpScoreTestVO.setIniScr12(0);
                }
                // 수시
                if(useTest) {
                    String score = StringUtil.nvl(scoreOverallVO.getReshScore());
                    
                    if("-".equals(score)) {
                        score = "0";
                    }
                    
                    erpScoreTestVO.setIniScr13(Float.valueOf(score) < 0 ? 0 : Float.valueOf(score));
                } else {
                    erpScoreTestVO.setIniScr13(0);
                }
                erpScoreTestVO.setIniScr14(0);
                erpScoreTestVO.setIniTotScr(
                      erpScoreTestVO.getIniScr1()
                    + erpScoreTestVO.getIniScr2()
                    + erpScoreTestVO.getIniScr3()
                    + erpScoreTestVO.getIniScr4()
                    + erpScoreTestVO.getIniScr5()
                    + erpScoreTestVO.getIniScr6()
                    + erpScoreTestVO.getIniScr7()
                    + erpScoreTestVO.getIniScr8()
                    + erpScoreTestVO.getIniScr9()
                    + erpScoreTestVO.getIniScr10()
                    + erpScoreTestVO.getIniScr11()
                    + erpScoreTestVO.getIniScr12()
                    + erpScoreTestVO.getIniScr13()
                    + erpScoreTestVO.getIniScr14()
                );
                
                if("3".equals(scoreOverallVO.getScoreStatus())) {
                    erpScoreTestVO.setCalScr1(Float.valueOf(stdScoreVO.getCalScrMidTest())); // 중간
                    erpScoreTestVO.setCalScr2(Float.valueOf(stdScoreVO.getCalScrLastTest())); // 기말
                    erpScoreTestVO.setCalScr3(Float.valueOf(stdScoreVO.getCalScrAsmnt())); // 과제
                    erpScoreTestVO.setCalScr4(Float.valueOf(stdScoreVO.getCalScrLesson())); // 출석
                    erpScoreTestVO.setCalScr5(0);
                    erpScoreTestVO.setCalScr6(0);
                    erpScoreTestVO.setCalScr7(Float.valueOf(stdScoreVO.getCalScrForum())); // 토론
                    erpScoreTestVO.setCalScr8(0);
                    erpScoreTestVO.setCalScr9(0);
                    erpScoreTestVO.setCalScr10(0); // 기타
                    erpScoreTestVO.setCalScr11(Float.valueOf(stdScoreVO.getCalScrQuiz())); // 퀴즈
                    erpScoreTestVO.setCalScr12(Float.valueOf(stdScoreVO.getCalScrResh())); // 설문
                    erpScoreTestVO.setCalScr13(Float.valueOf(stdScoreVO.getCalScrTest())); // 수시
                    erpScoreTestVO.setCalScr14(0);
                    erpScoreTestVO.setCalTotScr(Float.valueOf(stdScoreVO.getCalTotScr()));
                    
                    erpScoreTestVO.setExchScr1(Float.valueOf(stdScoreVO.getExchScrMidTest())); // 중간
                    erpScoreTestVO.setExchScr2(Float.valueOf(stdScoreVO.getExchScrLastTest())); // 기말
                    erpScoreTestVO.setExchScr3(Float.valueOf(stdScoreVO.getExchScrAsmnt())); // 과제
                    erpScoreTestVO.setExchScr4(Float.valueOf(stdScoreVO.getExchScrLesson())); // 출석
                    erpScoreTestVO.setExchScr5(0f);
                    erpScoreTestVO.setExchScr6(0f);
                    erpScoreTestVO.setExchScr7(Float.valueOf(stdScoreVO.getExchScrForum())); // 토론
                    erpScoreTestVO.setExchScr8(0f);
                    erpScoreTestVO.setExchScr9(0f);
                    erpScoreTestVO.setExchScr10(0f); // 기타
                    erpScoreTestVO.setExchScr11(Float.valueOf(stdScoreVO.getExchScrQuiz())); // 퀴즈
                    erpScoreTestVO.setExchScr12(Float.valueOf(stdScoreVO.getExchScrResh())); // 설문
                    erpScoreTestVO.setExchScr13(Float.valueOf(stdScoreVO.getExchScrTest())); // 수시
                    erpScoreTestVO.setExchScr14(0f);
                    erpScoreTestVO.setExchTotScr(Float.valueOf(stdScoreVO.getExchTotScr()));
                    
                    erpScoreTestVO.setCorrScr(Float.valueOf(StringUtil.nvl(stdScoreVO.getAddScore(), "0")));
                    erpScoreTestVO.setFlExchScr(Float.valueOf(stdScoreVO.getTotScore()));
                    erpScoreTestVO.setMrksGrdGbn(scoreOverallVO.getScoreGrade());
                    erpScoreTestVO.setMrks(Float.valueOf(stdScoreVO.getMrks()));
                    erpScoreTestVO.setMrksGrdGvGbn("RELATIVE".equals(creCrsEval) ? "02" : "03");
                    erpScoreTestVO.setExchYn("1");
                    erpScoreTestVO.setExchGapScr(Float.valueOf(StringUtil.nvl(stdScoreVO.getExchGapScr(), "0")));
                    
                    if("Y".equals(StringUtil.nvl(stdScoreVO.getRankObjYn()))) {
                        erpScoreTestVO.setRank(Integer.valueOf(stdScoreVO.getRanking()));
                        erpScoreTestVO.setRankRcnt(Integer.valueOf(stdScoreVO.getRankRCnt()));
                        erpScoreTestVO.setRankObjYn("1");
                    } else {
                        erpScoreTestVO.setRankObjYn("0");
                    }
                } else {
                    erpScoreTestVO.setCalScr1(Float.valueOf(scoreOverallVO.getMiddleTestScoreAvg())); // 중간
                    erpScoreTestVO.setCalScr2(Float.valueOf(scoreOverallVO.getLastTestScoreAvg())); // 기말
                    erpScoreTestVO.setCalScr3(Float.valueOf(scoreOverallVO.getAssignmentScoreAvg())); // 과제
                    erpScoreTestVO.setCalScr4(Float.valueOf(scoreOverallVO.getLessonScoreAvg())); // 출석
                    erpScoreTestVO.setCalScr5(0);
                    erpScoreTestVO.setCalScr6(0);
                    erpScoreTestVO.setCalScr7(Float.valueOf(scoreOverallVO.getForumScoreAvg())); // 토론
                    erpScoreTestVO.setCalScr8(0);
                    erpScoreTestVO.setCalScr9(0);
                    erpScoreTestVO.setCalScr10(0); // 기타
                    erpScoreTestVO.setCalScr11(Float.valueOf(scoreOverallVO.getQuizScoreAvg())); // 퀴즈
                    erpScoreTestVO.setCalScr12(Float.valueOf(scoreOverallVO.getReshScoreAvg())); // 설문
                    erpScoreTestVO.setCalScr13(Float.valueOf(scoreOverallVO.getTestScoreAvg())); // 수시
                    erpScoreTestVO.setCalScr14(0);
                    erpScoreTestVO.setCalTotScr(Float.valueOf(scoreOverallVO.getFinalScore()));
                    erpScoreTestVO.setMrksGrdGvGbn("RELATIVE".equals(creCrsEval) ? "02" : "03");
                    erpScoreTestVO.setExchYn("0");
                }
                
                erpScoreTestVO.setInptId("system");
                erpScoreTestVO.setInptIp(SessionInfo.getLoginIp(request));
                erpScoreTestVO.setInptMenuId("LMS");
                erpScoreTestVO.setModId("system");
                erpScoreTestVO.setModIp(SessionInfo.getLoginIp(request));
                erpScoreTestVO.setModMenuId("LMS");
                
                insertList.add(erpScoreTestVO);
            }
            
            ErpScoreTestVO deleteErpScoreTestVO = new ErpScoreTestVO();
            deleteErpScoreTestVO.setYy(yy);
            deleteErpScoreTestVO.setTmGbn(tmGbn);
            deleteErpScoreTestVO.setScCd(scCd);
            deleteErpScoreTestVO.setLtNo(ltNo);
            
            erpService.insertTestScore(deleteErpScoreTestVO, insertList);
            
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    // 성적변경이력 조회
    @RequestMapping(value="/score/scoreOverall/selectScoreHistList.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectScoreHistList(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        try {
            List<ScoreOverallVO> list = scoreOverallService.selectScoreHistList(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }
    
    // 성적변경이력 조회 엑셀 다운
    @RequestMapping(value="/score/scoreOverall/downExcelScoreHistList.do" )
    public String downExcelScoreHistList(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        
        // 조회조건 
        String[] searchValues = {getMessage("common.search.condition") + " : " + StringUtil.nvl(vo.getSearchValue())};
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        List<ScoreOverallVO> list = scoreOverallService.selectScoreHistList(vo);
        
        String title = getMessage("score.label.score.change.log"); // 성적변경이력
        
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
     
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    //erp 전송버튼
    @RequestMapping(value="/score/scoreOverall/insertErpTestScoreList.do")
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> insertErpTestScoreList(ScoreOverallVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String creYear = vo.getCreYear();
        String creTerm = vo.getCreTerm();
        
        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            vo.setLoginIp(SessionInfo.getLoginIp(request));
            List<ErpScoreTestVO> scoreList = scoreOverallService.selectErpTestScoreList(vo);
            
            ErpScoreTestVO erpScoreTestVO = new ErpScoreTestVO();
            erpScoreTestVO.setYy(creYear);
            erpScoreTestVO.setTmGbn(creTerm);
            erpScoreTestVO.setInptId(userId);
            erpScoreTestVO.setInptIp(SessionInfo.getLoginIp(request));
            erpScoreTestVO.setInptMenuId("LMS");
            
            erpService.insertTestScore(erpScoreTestVO, scoreList);
            
            // ERP 성적 메인 테이블로 이관하는 프로시저 실행
            String outMsg = null;
            
            try {
                Integer outNum = null;
                
                EgovMap scoreExistsYnMap = scoreOverallService.selectScoreExistsYnByUniCd(vo);
                
                String scoreExistsYnC = scoreExistsYnMap.get("scoreExistsYnC").toString();
                String scoreExistsYnG = scoreExistsYnMap.get("scoreExistsYnG").toString();
                
                if("Y".equals(scoreExistsYnC)) {
                    // 대학
                    Map<String, Object> paramMap = new HashMap<>();
                    paramMap.put("univGbn", "1");
                    paramMap.put("yy", creYear);
                    paramMap.put("tmGbn", creTerm);
                    paramMap.put("stuno", null);
                    paramMap.put("inptId", SessionInfo.getUserId(request));
                    paramMap.put("inptIp", SessionInfo.getLoginIp(request));
                    paramMap.put("inptMenuId", "LMS");
                    paramMap.put("outNum", null);
                    paramMap.put("outMsg", null);
                    erpService.callSpScorLmsMrksGet(paramMap);
                    
                    outNum = (Integer) paramMap.get("outNum");
                    
                    if(outNum != null && outNum != 0 && !"".equals(StringUtil.nvl(paramMap.get("outMsg")))) {
                        outMsg = "대학 : " + paramMap.get("outMsg").toString();
                    }
                }
                
                if("Y".equals(scoreExistsYnG)) {
                    // 대학원
                    Map<String, Object> paramMap = new HashMap<>();
                    paramMap.put("univGbn", "2");
                    paramMap.put("yy", creYear);
                    paramMap.put("tmGbn", creTerm);
                    paramMap.put("stuno", null);
                    paramMap.put("inptId", SessionInfo.getUserId(request));
                    paramMap.put("inptIp", SessionInfo.getLoginIp(request));
                    paramMap.put("inptMenuId", "LMS");
                    paramMap.put("outNum", null);
                    paramMap.put("outMsg", null);
                    erpService.callSpScorLmsMrksGet(paramMap);
                    
                    outNum = (Integer) paramMap.get("outNum");
                    
                    if(outNum != null && outNum != 0 && !"".equals(StringUtil.nvl(paramMap.get("outMsg")))) {
                        if(outMsg != null) {
                            outMsg += "\n";
                        } else {
                            outMsg = "";
                        }
                        
                        outMsg += "대학원 : " + paramMap.get("outMsg").toString();
                    }
                }
            } catch (Exception e) {
                outMsg += "ERP 성적 메인 테이블로 이관 프로시저 실행중 오류가 발생하였습니다.";
            }
            
            resultVO.setMessage(outMsg);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    //종합성적 메인리스트
    @RequestMapping(value="/score/scoreOverall/selectOverallMainList.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectOverallMainList(ScoreOverallVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String userType = SessionInfo.getAuthrtCd(request);
        
        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            
            if(StringUtil.nvl(userType).contains("PFS")) {
                vo.setRepYn("Y");
            }
            
            List<ScoreOverallVO> list = scoreOverallService.selectOverallMainList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    // 평가기준 조회
    @RequestMapping(value="/score/scoreOverall/selectScoreItemConfList.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> selectScoreItemConfList(ScoreOverallVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        try {
            resultVO.setReturnList(scoreOverallService.selectScoreItemConfList(vo));
            resultVO.setResult(1);
        }catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    // 평가기준 수정
    @RequestMapping(value="/score/scoreOverall/updateScoreItemConf.do" )
    @ResponseBody
    public ProcessResultVO<ScoreOverallVO> updateScoreItemConf(@RequestBody List<ScoreOverallVO> list, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<>();
        
        try {
            scoreOverallService.updateScoreItemConfList(request, list);
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
