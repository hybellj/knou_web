package knou.lms.crs.home.web;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.*;
import knou.framework.vo.FileVO;
import knou.lms.asmt.service.AsmtProService;
import knou.lms.asmt.vo.AsmtVO;
import knou.lms.bbs.service.BbsAtclService;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.home.service.CrsHomeMenuService;
import knou.lms.crs.home.service.CrsHomeService;
import knou.lms.crs.home.vo.CrsHomeBbsMenuVO;
import knou.lms.crs.home.vo.CrsHomeMenuVO;
import knou.lms.crs.home.vo.CrsHomeVO;
import knou.lms.crs.score.service.ScoreItemConfService;
import knou.lms.crs.score.vo.ScoreItemConfVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.service.DashboardService;
import knou.lms.dashboard.vo.DashboardVO;
import knou.lms.exam.service.ExamService;
import knou.lms.exam.vo.ExamVO;
import knou.lms.forum.service.ForumService;
import knou.lms.forum.vo.ForumVO;
import knou.lms.lesson.service.LessonScheduleService;
import knou.lms.lesson.service.LessonService;
import knou.lms.lesson.service.LessonStudyService;
import knou.lms.lesson.vo.*;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.log.userconn.vo.LogUserConnStateVO;
import knou.lms.resh.service.ReshService;
import knou.lms.resh.vo.ReshVO;
import knou.lms.score.service.ScoreConfService;
import knou.lms.score.vo.ScoreConfVO;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.sys.service.SysJobSchService;
import knou.lms.sys.vo.SysJobSchVO;
import knou.lms.user.vo.UsrUserInfoVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping(value="/crs")
public class CrsHomeController extends ControllerBase {
    private static final Logger LOGGER = LoggerFactory.getLogger(CrsHomeController.class);

    @Autowired
    private CrsHomeMenuService crsHomeMenuService;

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="crsHomeService")
    private CrsHomeService crsHomeService;

    @Resource(name="dashboardService")
    private DashboardService dashboardService;

    @Resource(name="scoreItemConfService")
    private ScoreItemConfService scoreItemConfService;

    @Resource(name="stdService")
    private StdService stdService;

    @Resource(name="lessonScheduleService")
    private LessonScheduleService lessonScheduleService;

    @Resource(name="lessonService")
    private LessonService lessonService;

    @Resource(name="lessonStudyService")
    private LessonStudyService lessonStudyService;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name="scoreConfService")
    private ScoreConfService scoreConfService;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name="termService")
    private TermService termService;

    @Resource(name="asmtProService")
    private AsmtProService asmtProService;

    @Resource(name="forumService")
    private ForumService forumService;

    @Resource(name="examService")
    private ExamService examService;

    @Resource(name="reshService")
    private ReshService reshService;

    @Resource(name="sysJobSchService")
    private SysJobSchService sysJobSchService;

    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    @Resource(name="bbsAtclService")
    private BbsAtclService bbsAtclService;

    /**
     * 과목조회
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/crsHome.do")
    public String main(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String crsCreCd = StringUtil.nvl(request.getParameter("crsCreCd"));

        if(menuType.contains("PROF")) {
            return "redirect:/crs/crsHomeProf.do?crsCreCd=" + crsCreCd;
        } else if(menuType.contains("USR")) {
            return "redirect:/crs/crsHomeStd.do?crsCreCd=" + crsCreCd;
        } else {
            // 접근 권한이 없습니다.
            throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
        }
        
        /*
        String url = SessionInfo.getCurCorHome(request);

        if (!url.equals(null)) {
            if (!"".equals(crsCreCd)) {
                int idx = url.indexOf("crsCreCd=");
                if (idx > -1) {
                    url = url.substring(0, idx) + "crsCreCd="+crsCreCd;
                }
                else {
                    url += "?crsCreCd="+crsCreCd;
                }
            }

            return "redirect:"+url;
        }

        */
        //return "/";
    }

    /**
     * 과목홈(학생)
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/crsHomeStd.do")
    public String crsHomeStd(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserRprsId(request);
        String crsCreCd = request.getParameter("crsCreCd");
        String termCd = "";
        String uniCd = "";
        String stdNo = "";

        // 과목정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setOrgId(orgId);
        creCrsVO = crecrsService.select(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);

        termCd = creCrsVO.getTermCd();
        uniCd = creCrsVO.getUniCd();

        // 수강중인 학생정보 조회
        StdVO stdVO = new StdVO();
        stdVO.setOrgId(orgId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(userId);
        stdVO = stdService.selectStd(stdVO);

        stdNo = stdVO.getStdId();
        model.addAttribute("stdNo", stdNo);
        model.addAttribute("curTermCd", termCd);
        model.addAttribute("curCrsCreCd", crsCreCd);
        model.addAttribute("stdCnt", creCrsVO.getStdCnt());

        BbsAtclVO cosNoticeVO = new BbsAtclVO();
        cosNoticeVO.setOrgId(orgId);
        cosNoticeVO.setBbsId("NOTICE");
        cosNoticeVO.setUserId(userId);
        cosNoticeVO.setListScale(5);
        cosNoticeVO.setCrsCreCd(crsCreCd);
        cosNoticeVO.setVwerId(userId); // 본인이 읽은 게시글 체크
        cosNoticeVO.setLearnerViewModeYn("Y");

        // 강의 공지사항
        List<EgovMap> cosNoticeList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
        model.addAttribute("cosNoticeList", cosNoticeList);

        // 강의 QNA
        cosNoticeVO.setBbsId("QNA");
        List<EgovMap> cosQnaList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
        model.addAttribute("cosQnaList", cosQnaList);

        // QNA 미답변수 조회
        EgovMap qnaNoAnsInfo = bbsAtclService.selectNoAnswerAtclStatus(cosNoticeVO);
        model.addAttribute("qnaNoAnsInfo", qnaNoAnsInfo);

        // 1:1 상담
        cosNoticeVO.setBbsId("SECRET");
        List<EgovMap> cosSecretList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
        model.addAttribute("cosSecretList", cosSecretList);

        // 1:1상담 미답변수 조회
        EgovMap secretNoAnsInfo = bbsAtclService.selectNoAnswerAtclStatus(cosNoticeVO);
        model.addAttribute("secretNoAnsInfo", secretNoAnsInfo);

        String dsblReqPeriodYn = StringUtil.nvl(stdVO.getDisablilityYn(), "N");

        // 학습요소 참여현황 조회
        StdVO stdJoinStatusVO = new StdVO();
        stdJoinStatusVO.setCrsCreCd(crsCreCd);
        stdJoinStatusVO.setStdId(stdNo);
        stdJoinStatusVO.setUserId(userId);
        EgovMap JoinStatus = crsHomeService.selectCrsHomeStdJoinStatus(stdJoinStatusVO);
        model.addAttribute("JoinStatus", JoinStatus);

        // 강의실 학습주차 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        List<LessonScheduleVO> lessonScheduleList = lessonScheduleService.list(lessonScheduleVO);
        model.addAttribute("lessonScheduleList", lessonScheduleList);

        // 현재 주차 조회
        lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        EgovMap crsHomeCurrentWeek = crsHomeService.crsHomeCurrentWeek(lessonScheduleVO);
        model.addAttribute("crsHomeCurrentWeek", crsHomeCurrentWeek);

        // 업무일정 조회
        String examAbsentPeroidYn = "N";
        String scoreObjtPeriodYn = "N";

        SysJobSchVO sysJobSchVO;
        SysJobSchVO sysJobSchSearchVO = new SysJobSchVO();
        sysJobSchSearchVO.setOrgId(orgId);
        sysJobSchSearchVO.setUseYn("Y");
        sysJobSchSearchVO.setTermCd(termCd);

        // 00190904: 결시원 신청기간(중간), 00190905: 결시원 신청기간(기말), 00210202: 성적이의 신청기간(학부), 00210204: 성적이의 신청기간(대학원), 00190805: 장애인 시험지원 신청기간, 00190809: 장애인 시험지원요청 확인기간
        sysJobSchSearchVO.setSqlForeach(new String[]{"00190904", "00190905", "00210202", "00210204", "00190805", "00190809"});
        List<SysJobSchVO> jobSchList = sysJobSchService.list(sysJobSchSearchVO);
        Map<String, SysJobSchVO> jobSchMap = new HashMap<>();
        for(SysJobSchVO sysJobSchVO2 : jobSchList) {
            jobSchMap.put(sysJobSchVO2.getCalendarCtgr(), sysJobSchVO2);
        }

        // 1.결시원 신청기간 (중간)
        sysJobSchVO = jobSchMap.get("00190904");

        if(sysJobSchVO != null) {
            examAbsentPeroidYn = sysJobSchVO.getSysjobSchdlPeriodYn();
        }

        // 2.결시원 신청기간 (기말)
        if("N".equals(examAbsentPeroidYn)) {
            sysJobSchVO = jobSchMap.get("00190905");

            if(sysJobSchVO != null) {
                examAbsentPeroidYn = sysJobSchVO.getSysjobSchdlPeriodYn();
            }
        }

        // 2.성적이의 신청기간(학부)
        if("C".equals(uniCd)) {
            sysJobSchVO = jobSchMap.get("00210202");

            if(sysJobSchVO != null) {
                String jobSchPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();

                if("Y".equals(StringUtil.nvl(jobSchPeriodYn))) {
                    scoreObjtPeriodYn = "Y";
                }
            }
        }
        // 2.성적이의 신청기간(대학원)
        else if("G".equals(uniCd)) {
            sysJobSchVO = jobSchMap.get("00210204");

            if(sysJobSchVO != null) {
                String jobSchPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();

                if("Y".equals(StringUtil.nvl(jobSchPeriodYn))) {
                    scoreObjtPeriodYn = "Y";
                }
            }
        }

        model.addAttribute("examAbsentPeroidYn", examAbsentPeroidYn);
        model.addAttribute("scoreObjtPeriodYn", scoreObjtPeriodYn);
        model.addAttribute("dsblReqPeriodYn", dsblReqPeriodYn);

        // Redirect 1회용 파라미터
        Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);
        if(flashMap != null) {
            // 주차 학습팝업 open
            String viewLessonScheduleId = (String) flashMap.get("viewLessonScheduleId");
            model.addAttribute("viewLessonScheduleId", viewLessonScheduleId);
        }

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", crsCreCd);

        // 과목 접속자 목록 조회
        List<String> connCors = new ArrayList<>();
        connCors.add(crsCreCd);
        LogUserConnStateVO stateVO = new LogUserConnStateVO();
        stateVO.setConnGbn("learner");
        stateVO.setCorsList(connCors);
        stateVO.setSearchTm(CommConst.CONN_USER_CHECK_TIME); // 검색시간(분)

        List<LogUserConnStateVO> userConnList = logUserConnService.listLogUserConnState(stateVO);
        model.addAttribute("userConnList", userConnList);

        // 강의실 세션 설정
        crecrsService.setCreCrsStuSession(request, creCrsVO, stdVO);

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);
        // 강의실 활동 로그 등록 (common.log.classroomEnter: 과목홈 입장)
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_LECTURE_HOME, messageSource.getMessage("common.log.classroomEnter", null, locale));

        return "std2/std_sbjct_ofrng_select_view";
    }

    /**
     * 과목홈(학생) Redirect 파라미터 전달
     *
     * @param request
     * @param response
     * @param model
     * @param redirectAttributes
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/crsHomeStdRedirect.do")
    public String crsHomeStdRedirect(HttpServletRequest request, HttpServletResponse response, ModelMap model, RedirectAttributes redirectAttributes) throws Exception {
        String crsCreCd = request.getParameter("crsCreCd");

        // 주차 학습팝업 open
        String viewLessonScheduleId = request.getParameter("viewLessonScheduleId");
        redirectAttributes.addFlashAttribute("viewLessonScheduleId", viewLessonScheduleId);

        return "redirect:crsHomeStd.do?crsCreCd=" + crsCreCd;
    }

    /**
     * 학생 강의목록
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/crsStuLessonList.do")
    public String crsStuLessonList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = request.getParameter("crsCreCd");
        String stdNo = request.getParameter("stdNo");
        String userId = SessionInfo.getUserId(request);
        StdVO stdVO;
        String univGbn;
        String auditYn;

        // 과목정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setOrgId(orgId);
        creCrsVO = crecrsService.select(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);

        univGbn = creCrsVO.getUnivGbn();

        // 수강중인 학생정보 조회
        stdVO = new StdVO();
        stdVO.setOrgId(orgId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(userId);
        stdVO = stdService.selectStd(stdVO);

        stdNo = stdVO.getStdId();
        auditYn = stdVO.getAuditYn();

        // 강의실 학습주차 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        List<LessonScheduleVO> lessonScheduleList = lessonScheduleService.list(lessonScheduleVO);
        model.addAttribute("lessonScheduleList", lessonScheduleList);

        // 주차별 참여현황 조회
        stdVO = new StdVO();
        stdVO.setOrgId(SessionInfo.getOrgId(request));
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(userId);
        stdVO.setStdId(stdNo);
        if("3".equals(univGbn) || "4".equals(univGbn)) {
            stdVO.setSearchAuditYn("Y");
        }
        List<Map<String, Object>> attendList = stdService.listAttend(stdVO);

        if(attendList != null && attendList.size() != 0) {
            model.addAttribute("attendInfo", attendList.get(0));
        }

        // 진도율 조회
        stdVO = new StdVO();
        stdVO.setOrgId(SessionInfo.getOrgId(request));
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(userId);
        stdVO.setStdId(stdNo);
        EgovMap stdLessonProgress = stdService.selectStdLessonProgress(stdVO);
        model.addAttribute("stdLessonProgress", stdLessonProgress);

        // 강의실 학기 조회
        TermVO termVO = new TermVO();
        termVO.setCrsCreCd(crsCreCd);
        termVO = termService.selectTermByCrsCreCd(termVO);
        model.addAttribute("termVO", termVO);

        model.addAttribute("orgId", orgId);
        model.addAttribute("crsCreCd", crsCreCd);
        model.addAttribute("userId", userId);
        model.addAttribute("stdNo", stdNo);
        model.addAttribute("auditYn", auditYn);

        String url = "crs/home/crs_stu_lesson_list";

        return url;
    }

    /**
     * 학생 강의목록 화면
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/Form/crsStuLesson.do")
    public String crsStuLessonForm(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);

        String crsCreCd = request.getParameter("crsCreCd");
        String userId = SessionInfo.getUserId(request);

        // 수강중인 학생정보 조회
        StdVO stdVO = new StdVO();
        stdVO.setOrgId(SessionInfo.getOrgId(request));
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(userId);
        stdVO = stdService.selectStd(stdVO);

        String stdNo = stdVO.getStdId();
        model.addAttribute("stdNo", stdNo);

        // 과목정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setOrgId(SessionInfo.getOrgId(request));
        creCrsVO = crecrsService.select(creCrsVO);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", crsCreCd);
        model.addAttribute("creCrsVO", creCrsVO);

        return "crs/home/crs_std_lesson";
    }

    /*****************************************************
     * 강의실 홈 학습 주차 목록 조회
     * @param vo
     * @param map
     * @param request
     * @return ProcessResultVO<LessonVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listCrsHomeLessonSchedule.do")
    @ResponseBody
    public ProcessResultVO<LessonScheduleVO> listCrsHomeLessonSchedule(LessonVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<LessonScheduleVO> resultVO = new ProcessResultVO<>();

        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String langCd = SessionInfo.getLocaleKey(request);

        try {
            vo.setOrgId(orgId);
            vo.setLangCd(langCd);

            if(StringUtil.nvl(menuType).contains("USR")) {
                vo.setAuthrtGrpcd("USR");
            }

            List<LessonScheduleVO> list = crsHomeService.listCrsHomeLessonSchedule(vo);

            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /**
     * 교수과목조회
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/crsHomeProf.do"})
    public String crsHomeProf(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	
    	
    	//  TODO: 데이터정리
        // 	UserContext 	- 기관아이디, 대표아이디, 사용자아이디, 사용자유형, 사용자접속장치, IP, 마지마로그인 일시, 접속위치?, 날짜, 언어코드;
        //					- 이전접속위치, 이전접속일시, 이전접속체크번호
        //	AcademyContext 	- 학기, 주차, 
        //	AuthrityContext - 권한타입
        //	MenuContext 	- 메뉴타입
        //	SubjectContext 	- 과목정보 저장;
    	
    	//	사용자세션에서 가져오는 UserContext
    	UserContext userCtx = new UserContext( 	SessionInfo.getOrgId(request),
    											SessionInfo.getUserId(request),
    											SessionInfo.getUserType(request),
    											SessionInfo.getAuthrtCd(request),
    											SessionInfo.getAuthrtGrpcd(request),
    											SessionInfo.getUserRprsId(request), 
    											SessionInfo.getLastLogin(request) );
    	
    	request.getSession().setAttribute("USER_CONTEXT", userCtx);
    	
        String type = StringUtil.nvl(request.getParameter("type"));
        String sbjctOfrngId = request.getParameter("crsCreCd");
        String termCd = "";
        String uniCd = "";
        String orgId = SessionInfo.getOrgId(request);

        if("ADM".equals(type)) {
            Map<String, Object> srcUserMap = new HashMap<String, Object>();
            srcUserMap.put("userId", SessionInfo.getUserId(request));
            srcUserMap.put("userNm", SessionInfo.getUserNm(request));
            srcUserMap.put("curParMenuCd", SessionInfo.getCurParMenuCd(request));
            srcUserMap.put("curMenuCd", SessionInfo.getCurMenuCd(request));
            SessionInfo.setAdminCrsInfo(request, srcUserMap);
        }

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);

        // 과목개설조회
        //SubjectOfferingVO subjctOfferingVO = subjectService.subjctOfferingSelect(sbjctOfrngId));
        
        CreCrsVO subjctOfferingVO = new CreCrsVO();
        //creCrsVO.setCrsCreCd(sbjctOfrngId);
        //creCrsVO.setOrgId(SessionInfo.getOrgId(request));
        //creCrsVO.setUniCd("");
        //creCrsVO = crecrsService.select(creCrsVO);  
        
        subjctOfferingVO = crecrsService.select(subjctOfferingVO);  

        termCd = subjctOfferingVO.getTermCd();
        uniCd = subjctOfferingVO.getUniCd();

        model.addAttribute("creCrsVO", subjctOfferingVO);
        model.addAttribute("curTermCd", termCd);
        model.addAttribute("curCrsCreCd", sbjctOfrngId);
        model.addAttribute("stdCnt", subjctOfferingVO.getStdCnt());

        // 사용자 세션정보
        UsrUserInfoVO userInfo = new UsrUserInfoVO();
        String userId = SessionInfo.getUserRprsId(request);
        userInfo.setUserId(userId);

        BbsAtclVO cosNoticeVO = new BbsAtclVO();
        cosNoticeVO.setOrgId(userInfo.getOrgId());
        cosNoticeVO.setBbsId("NOTICE");
        cosNoticeVO.setListScale(5);
        cosNoticeVO.setCrsCreCd(sbjctOfrngId);
        cosNoticeVO.setVwerId(userId); // 본인이 읽은 게시글 체크

        // 강의 공지사항
        List<EgovMap> cosNoticeList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
        model.addAttribute("cosNoticeList", cosNoticeList);

        // 강의 QNA
        cosNoticeVO.setBbsId("QNA");
        List<EgovMap> cosQnaList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
        model.addAttribute("cosQnaList", cosQnaList);

        // 	QNA 미답변수 정보 조회
        EgovMap qnaNoAnsInfo = bbsAtclService.selectNoAnswerAtclStatus(cosNoticeVO);
        model.addAttribute("qnaNoAnsInfo", qnaNoAnsInfo);

        // 	1:1 상담
        //	cosNoticeVO.setBbsId("SECRET"); // TODO: 
        List<EgovMap> cosSecretList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
        model.addAttribute("cosSecretList", cosSecretList);

        // 1:1상담 미답변수 정보 조회
        EgovMap secretNoAnsInfo = bbsAtclService.selectNoAnswerAtclStatus(cosNoticeVO);
        model.addAttribute("secretNoAnsInfo", secretNoAnsInfo);

        
        // 강의실 학습주차 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(sbjctOfrngId);
        List<LessonScheduleVO> lessonScheduleList = lessonScheduleService.list(lessonScheduleVO);
        model.addAttribute("lessonScheduleList", lessonScheduleList);

        // 현재 주차 조회
        lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(sbjctOfrngId);
        EgovMap crsHomeCurrentWeek = crsHomeService.crsHomeCurrentWeek(lessonScheduleVO);
        model.addAttribute("crsHomeCurrentWeek", crsHomeCurrentWeek);

        // 강의실 교수 홈 학습요소 상태
        DefaultVO defaultVO = new DefaultVO();
        defaultVO.setCrsCreCd(sbjctOfrngId);
        EgovMap profElementStatus = crsHomeService.selectCrsHomeProfElementStatus(defaultVO);
        model.addAttribute("profElementStatus", profElementStatus);

        // 업무일정 조회
        String examAbsentPeroidYn = "N";    // 결시원
        String scoreObjtPeriodYn = "N";     // 성적재확인
        String dsblReqPeriodYn = "N";       // 장애인지원

        SysJobSchVO sysJobSchVO;
        SysJobSchVO sysJobSchSearchVO = new SysJobSchVO();
        sysJobSchSearchVO.setOrgId(orgId);
        sysJobSchSearchVO.setUseYn("Y");
        sysJobSchSearchVO.setTermCd(termCd);
        // 00190901: 결시원 승인기간, 00210203: 성적이의 신청 정정기간(학부), 00210205: 성적이의 신청 정정기간(대학원), 00190806: 장애인 시험지원 승인기간
        sysJobSchSearchVO.setSqlForeach(new String[]{"00190901", "00210203", "00210205", "00190806"});
        List<SysJobSchVO> jobSchList = sysJobSchService.list(sysJobSchSearchVO);
        Map<String, SysJobSchVO> jobSchMap = new HashMap<>();
        for(SysJobSchVO sysJobSchVO2 : jobSchList) {
            jobSchMap.put(sysJobSchVO2.getCalendarCtgr(), sysJobSchVO2);
        }

        // 1.결시원 승인기간
        sysJobSchVO = jobSchMap.get("00190901");

        if(sysJobSchVO != null) {
            examAbsentPeroidYn = sysJobSchVO.getSysjobSchdlPeriodYn();
        }

        // 2.성적이의 신청 정정기간(학부)
        if("C".equals(uniCd)) {
            sysJobSchVO = jobSchMap.get("00210203");

            if(sysJobSchVO != null) {
                String jobSchPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();

                if("Y".equals(StringUtil.nvl(jobSchPeriodYn))) {
                    scoreObjtPeriodYn = "Y";
                }
            }
        }
        // 2.성적이의 신청 정정기간(대학원)
        else if("G".equals(uniCd)) {
            sysJobSchVO = jobSchMap.get("00210205");

            if(sysJobSchVO != null) {
                String jobSchPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();

                if("Y".equals(StringUtil.nvl(jobSchPeriodYn))) {
                    scoreObjtPeriodYn = "Y";
                }
            }
        }

        // 3.장애인 시험지원 승인기간
        sysJobSchVO = jobSchMap.get("00190806");

        if(sysJobSchVO != null) {
            dsblReqPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();
        }

        model.addAttribute("examAbsentPeroidYn", examAbsentPeroidYn);
        model.addAttribute("scoreObjtPeriodYn", scoreObjtPeriodYn);
        model.addAttribute("dsblReqPeriodYn", dsblReqPeriodYn);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", sbjctOfrngId);

        // 과목 접속자 목록 조회
        List<String> connCors = new ArrayList<>();
        connCors.add(sbjctOfrngId);
        LogUserConnStateVO stateVO = new LogUserConnStateVO();
        stateVO.setConnGbn("learner");
        stateVO.setCorsList(connCors);
        stateVO.setSearchTm(CommConst.CONN_USER_CHECK_TIME); // 검색시간(분)

        List<LogUserConnStateVO> userConnList = logUserConnService.listLogUserConnState(stateVO);
        model.addAttribute("userConnList", userConnList);

        // 강의실 교수 세션설정
        crecrsService.setCreCrsProfSession(request, subjctOfferingVO);

        return "crs/home/crs_home_prof";
    }

    /**
     * 교수 주차 목록 상세
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/crsProfLessonList.do")
    public String crsProfLessonList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);

        String crsCreCd = request.getParameter("crsCreCd");
        String userId = SessionInfo.getUserId(request);
        String deptId = StringUtil.nvl(SessionInfo.getUserDeptId(request));
        String seminarAttendAuthYn = "N";

        // 주차정보 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLcdmsLinkYn(StringUtil.nvl(request.getParameter("lcdmsLinkYn")));
        List<LessonScheduleVO> lessonScheduleList = lessonScheduleService.list(lessonScheduleVO);

        // 수업지원팀(20042), 교육플랫폼혁신팀(20134)
        if("20042".equals(deptId) || "20134".equals(deptId)) {
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

        model.addAttribute("crsCreCd", crsCreCd);
        model.addAttribute("lessonScheduleList", lessonScheduleList);
        model.addAttribute("deptId", SessionInfo.getUserDeptId(request));
        model.addAttribute("userId", SessionInfo.getUserId(request));
        model.addAttribute("prevCourseYn", SessionInfo.getPrevCourseYn(request));
        model.addAttribute("seminarAttendAuthYn", seminarAttendAuthYn);
        model.addAttribute("lcdmsLinkYn", StringUtil.nvl(request.getParameter("lcdmsLinkYn")));

        String url = "crs/home/crs_prof_lesson_list";

        return url;
    }

    /**
     * 교수 강의목록 화면
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/Form/crsProfLesson.do")
    public String crsProfLessonForm(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);

        String crsCreCd = request.getParameter("crsCreCd");
        String userId = SessionInfo.getUserId(request);

        //개설과목코드 세션SET
        SessionInfo.setCrsCreCd(request, crsCreCd);
        SessionInfo.setCurCrsCreCd(request, crsCreCd);
        SessionInfo.setCurCorHome(request, "/crs/crsHomeProf.do");

        // 과목정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setOrgId(SessionInfo.getOrgId(request));
        creCrsVO = crecrsService.select(creCrsVO);

        // 사용자 세션정보
        UsrUserInfoVO userInfo = new UsrUserInfoVO();
        userInfo.setUserId(userId);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", SessionInfo.getCrsCreCd(request));
        model.addAttribute("creCrsVO", creCrsVO);

        return "crs/home/crs_prof_lesson";
    }

    /*****************************************************
     * 학생 참여현황 조회
     * @param vo
     * @param map
     * @param request
     * @return ProcessResultVO<LessonVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/crsHomeScheduleListStatus.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> crsHomeScheduleListStatus(DefaultVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String crsCreCd = vo.getCrsCreCd();

        String lessonScheduleIds = request.getParameter("lessonScheduleIds");
        String lessonCntsIds = request.getParameter("lessonCntsIds");
        String aExamCds = request.getParameter("aExamCds");
        String asmntCds = request.getParameter("asmntCds");
        String forumCds = request.getParameter("forumCds");
        String quizCds = request.getParameter("quizCds");
        String reschCds = request.getParameter("reschCds");
        String seminarIds = request.getParameter("seminarIds");

        try {
            EgovMap egovMap = new EgovMap();
            egovMap.put("crsCreCd", crsCreCd);

            if(ValidationUtils.isNotEmpty(lessonScheduleIds)) {
                egovMap.put("lessonScheduleIdList", lessonScheduleIds.split(","));
            }

            if(ValidationUtils.isNotEmpty(lessonCntsIds)) {
                egovMap.put("lessonCntsIdList", lessonCntsIds.split(","));
            }

            if(ValidationUtils.isNotEmpty(aExamCds)) {
                egovMap.put("aExamCdList", aExamCds.split(","));
            }

            if(ValidationUtils.isNotEmpty(asmntCds)) {
                egovMap.put("asmntCdList", asmntCds.split(","));
            }

            if(ValidationUtils.isNotEmpty(forumCds)) {
                egovMap.put("forumCdList", forumCds.split(","));
            }

            if(ValidationUtils.isNotEmpty(quizCds)) {
                egovMap.put("quizCdList", quizCds.split(","));
            }

            if(ValidationUtils.isNotEmpty(reschCds)) {
                egovMap.put("reschCdList", reschCds.split(","));
            }

            if(ValidationUtils.isNotEmpty(seminarIds)) {
                egovMap.put("seminarIdList", seminarIds.split(","));
            }

            egovMap = crsHomeService.crsHomeScheduleListStatus(egovMap);

            resultVO.setReturnVO(egovMap);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 사용자 메뉴 조회
     * @param request
     * @param response
     * @param model
     * @param SysMenuVO
     * @return int
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectCrsHomeMenulist.do")
    @ResponseBody
    public CrsHomeVO selectCrsHomeMenulist(HttpServletRequest request, HttpServletResponse response, ModelMap model, CrsHomeMenuVO vo) throws Exception {
        CrsHomeVO resultVo = crsHomeMenuService.selectCrsHomeMenulist(vo);

        if("en".equals(SessionInfo.getLocaleKey(request))) {
            List<CrsHomeMenuVO> menuList = resultVo.getMenuList();
            for(CrsHomeMenuVO menuVO : menuList) {
                menuVO.setMenuNm(menuVO.getMenuNmEn());
            }

            List<CrsHomeBbsMenuVO> bbsList = resultVo.getBbsMenuList();
            for(CrsHomeBbsMenuVO menuVO : bbsList) {
                menuVO.setBbsNm(menuVO.getBbsNmEn());
            }
        }

        return resultVo;
    }

    /*****************************************************
     * 권한별 메뉴 리스트 조회
     * @param request
     * @param response
     * @param model
     * @param SysMenuVO
     * @return int
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectCrsAuthHomeMenulist.do")
    @ResponseBody
    public CrsHomeVO selectCrsAuthHomeMenulist(HttpServletRequest request, HttpServletResponse response, ModelMap model, CrsHomeMenuVO vo) throws Exception {

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        CrsHomeVO resultVo = crsHomeMenuService.selectCrsAuthHomeMenulist(vo);

        return resultVo;
    }

    /**
     * 강의실 학기 목록 조회
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/listClassroomTerm.do")
    @ResponseBody
    public ProcessResultVO<TermVO> listClassroomTerm(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<TermVO> resultVO = new ProcessResultVO<>();
        // 사용자 세션정보
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String curCorHome = SessionInfo.getCurCorHome(request);

        try {
            // 학기목록 조회
            TermVO termVO = new TermVO();
            termVO.setUserId(userId);
            termVO.setOrgId(orgId);
            ProcessResultVO<TermVO> termResult = null;

            if(curCorHome.indexOf("crsHomeStd") > -1) {
                termResult = dashboardService.listStdTerm(termVO);
            } else {
                termResult = dashboardService.profSmstrList(termVO);
            }

            resultVO.setReturnList(termResult.getReturnList());
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
        }

        return resultVO;
    }

    /**
     * 강의실 과목 목록 조회
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/listClassroomCors.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listClassroomCors(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();

        // 사용자 세션정보
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String curCorHome = StringUtil.nvl(SessionInfo.getCurCorHome(request));
        String termCd = request.getParameter("termCd");

        try {
            // 학기과목 목록
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setTermCd(termCd);
            creCrsVO.setUserId(userId);


            DashboardVO dashboardVO = new DashboardVO();
            dashboardVO.setTermCd(termCd);
            dashboardVO.setUserId(userId);

            List<CreCrsVO> list;

            if(curCorHome.indexOf("crsHomeProf") > -1) {
                list = crecrsService.listMainMypageTch(creCrsVO);
            } else {
                list = crecrsService.listMainMypageStd(creCrsVO);
            }

            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
        }

        return resultVO;
    }

    /**
     * 평가기준 관리 팝업 (교수/학생)
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/evalCriteriaPop.do")
    public String evalCriteriaPop(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String crsCreCd = request.getParameter("crsCreCd");
        String prevCourseYn = SessionInfo.getPrevCourseYn(request);

        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        // 성적반영비율 조회
        ScoreItemConfVO scoreItemConfVO = new ScoreItemConfVO();
        scoreItemConfVO.setCrsCreCd(crsCreCd);
        List<ScoreItemConfVO> scoreItemConfList = scoreItemConfService.list(scoreItemConfVO);

        Map<String, String> scoreItemConfMap = new HashMap<>();

        LOGGER.debug("### 성적반영비율 ###");

        for(ScoreItemConfVO item : scoreItemConfList) {
            String scoreTypeCd = item.getScoreTypeCd();
            Integer scoreRatio = item.getScoreRatio();

            String scoreRatioStr = "-";

            if(scoreRatio != null) {
                scoreRatioStr = scoreRatio + "%";
            }

            LOGGER.debug(scoreTypeCd + " : " + scoreRatio);

            scoreItemConfMap.put(scoreTypeCd, scoreRatioStr);
        }

        if(menuType.contains("USR")) {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_LECTURE_HOME, "평가기준 이용");
        }

        model.addAttribute("scoreItemConfMap", scoreItemConfMap);
        model.addAttribute("crsCreCd", crsCreCd);
        model.addAttribute("menuType", menuType);
        model.addAttribute("prevCourseYn", prevCourseYn);

        return "crs/home/popup/eval_criteria_pop";
    }

    /*****************************************************
     * 평가기준 목록 조회  (교수/학생)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listEvalCriteria.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listEvalCriteria(DefaultVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String authrtCd = SessionInfo.getAuthrtGrpcd(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String searchKey = StringUtil.nvl(vo.getSearchKey());

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(searchKey)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }

            vo.setOrgId(orgId);

            // 전체 목록 조회
            if(authrtCd.contains("STDNT")) {
                vo.setUserId(userId);
                vo.setAuthrtGrpcd("STDNT");
            }

            List<EgovMap> list = crsHomeService.listEvalCriteria(vo);

            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
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
     * 평가기준 성적반영비율 수정  (교수)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateEvalCriteriaScoreRatio.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> updateEvalCriteriaScoreRatio(DefaultVO vo, ModelMap model, HttpServletRequest request
            , @RequestParam(value="keyList", required=true) List<String> keyList
            , @RequestParam(value="scoreRatioList", required=true) List<Integer> scoreRatioList) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String searchKey = vo.getSearchKey();

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(searchKey)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }

            // 페이지 접근 권한 체크
            if(!menuType.contains("PROF")) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }

            vo.setMdfrId(userId);

            crsHomeService.updateEvalCriteriaScoreRatio(vo, keyList, scoreRatioList);

            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /**
     * 교수 강의보기
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/crsProfLessonView.do")
    public String crsProfLessonView(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_LESSON);

        String crsCreCd = request.getParameter("crsCreCd");
        String lessonScheduleId = request.getParameter("lessonScheduleId");
        String lessonTimeId = request.getParameter("lessonTimeId");
        String lessonCntsIdx = StringUtil.nvl(request.getParameter("lessonCntsIdx"), "0");

        // 과목정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setOrgId(SessionInfo.getOrgId(request));
        creCrsVO = crecrsService.select(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);

        String crsTypeCd = StringUtil.nvl(creCrsVO.getCrsTypeCd(), "UNI");

        // 주차정보 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);

        // 교시정보 조회
        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setCrsCreCd(crsCreCd);
        lessonTimeVO.setLessonScheduleId(lessonScheduleId);
        lessonTimeVO.setLessonTimeId(lessonTimeId);
        lessonTimeVO = lessonService.selectLessonTime(lessonTimeVO);

        /*
        // 이전교시/다음교시 조회
        List<LessonTimeVO> timeList = lessonService.listLessonTimeByScheduleId(lessonTimeVO);

        for (LessonTimeVO timeVO : timeList) {
            if (timeVO.getLessonTimeOrder() < lessonTimeVO.getLessonTimeOrder()) {
                lessonTimeVO.setPrevTimeId(timeVO.getLessonTimeId());
            }
            if (timeVO.getLessonTimeOrder() > lessonTimeVO.getLessonTimeOrder() && StringUtil.isNull(lessonTimeVO.getNextTimeId())) {
                lessonTimeVO.setNextTimeId(timeVO.getLessonTimeId());
            }
        }
        */

        // 콘텐츠 목록 조회
        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setCrsCreCd(crsCreCd);
        lessonCntsVO.setLessonScheduleId(lessonScheduleId);
        lessonCntsVO.setLessonTimeId(lessonTimeId);
        List<LessonCntsVO> lessonCntsList = lessonService.listLessonCntsByLessonTime(lessonCntsVO);
        //JSONParser parser = new JSONParser();

        for(LessonCntsVO lessonCntsVO2 : lessonCntsList) {
            String lessonCntsId = lessonCntsVO2.getLessonCntsId();
            String cntsGbn = StringUtil.nvl(lessonCntsVO2.getCntsGbn());
            String lessonCntsUrl = lessonCntsVO2.getLessonCntsUrl();

            if("PDF".equals(cntsGbn) || "FILE".equals(cntsGbn)) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("LECTURE");
                fileVO.setFileBindDataSn(lessonCntsId);
                lessonCntsVO2.setFileList(sysFileService.list(fileVO).getReturnList());
            } else if("VIDEO".equals(cntsGbn)) {
                String ext = FileUtil.getFileExtention(lessonCntsUrl);
                String subtitKo = StringUtil.nvl(lessonCntsVO2.getSubtitKo());
                String scriptKo = StringUtil.nvl(lessonCntsVO2.getScriptKo());
                String subPath = lessonCntsUrl.substring(0, lessonCntsUrl.lastIndexOf("/") + 1);
                String subInfo = "";

                if(!"".equals(subtitKo)) {
                    JSONArray titList = (JSONArray) JSONSerializer.toJSON(subtitKo);

                    for(int i = 0; i < titList.size(); i++) {
                        String defaultVal = "";
                        if(i == 0) defaultVal = "default";

                        JSONObject obj = (JSONObject) (titList.get(i));
                        subInfo += "<track kind='subtitles' label='" + obj.getString("label") + "' src='" + (CommConst.WEBDATA_CONTEXT + subPath + obj.getString("saveNm")) + "' srclang='" + obj.getString("srclang") + "' " + defaultVal + ">\n";
                    }
                }

                if(!"".equals(scriptKo)) {
                    JSONObject subObj = JSONObject.fromObject(JSONSerializer.toJSON(scriptKo));
                    subInfo += "<video_script>" + (CommConst.WEBDATA_CONTEXT + subPath + subObj.get("saveNm")) + "</video_script>\n";
                }

                if("Y".equals(CommConst.CDN_NAS_YN) && "mp4".equals(ext)) {
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(new Date());
                    cal.add(Calendar.HOUR, 6);
                    String limitTime = (new SimpleDateFormat("yyyyMMddHHmmss")).format(cal.getTime());
                    String cdnParam = "?&r=17&ip=127.0.0.1&limitTime=" + limitTime + "&userId=" + SessionInfo.getUserId(request) + "&checkIP=false";
                    if(lessonCntsUrl.indexOf("/") == 0) {
                        lessonCntsUrl = lessonCntsUrl.substring(1);
                    }

                    lessonCntsUrl = CommConst.CDN_URL_NAS + SecureUtil.encodeAesCbc((lessonCntsUrl + cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                } else {
                    lessonCntsUrl = CommConst.WEBDATA_CONTEXT + lessonCntsUrl;
                }

                lessonCntsVO2.setLessonCntsUrl(lessonCntsUrl);
                lessonCntsVO2.setSubInfo(subInfo);
            }
        }

        // 페이지 목록 조회
        LessonPageVO lessonPageVO = new LessonPageVO();
        lessonPageVO.setCrsCreCd(crsCreCd);
        lessonPageVO.setLessonScheduleId(lessonScheduleId);
        List<LessonPageVO> lessonPageList = lessonService.listLessonPageBySchedule(lessonPageVO);

        // 페이지정보 설정
        setLessonPageInfo(lessonCntsList, lessonPageList, null, SessionInfo.getUserId(request), "N");

        model.addAttribute("lessonSchedule", lessonScheduleVO);
        model.addAttribute("lessonTime", lessonTimeVO);
        model.addAttribute("lessonCntsList", lessonCntsList);
        model.addAttribute("lessonCntsIdx", lessonCntsIdx);

        if("UNI".equals(crsTypeCd)) {
            /* 출석 점수 기준_시작 */
            ScoreConfVO scoreConfVO = new ScoreConfVO();

            /* 강의오픈일 정보_시작 */
            String openWeekNm, openWeekVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendOpenClassWeek(scoreConfVO);

            openWeekNm = scoreConfVO.getOpenWeekNm();
            openWeekVal = scoreConfVO.getOpenWeekVal();

            String openTmNm, openTmVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendOpenClassTm(scoreConfVO);

            openTmNm = scoreConfVO.getOpenTmNm();
            openTmVal = scoreConfVO.getOpenTmVal();

            String openWeek1ApNm, openWeek1ApVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendOpenClassWeekAp(scoreConfVO);

            openWeek1ApNm = scoreConfVO.getOpenWeek1ApNm();
            openWeek1ApVal = scoreConfVO.getOpenWeek1ApVal();

            String openWeek1TmNm, openWeek1TmVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendOpenClassWeekTm(scoreConfVO);

            openWeek1TmNm = scoreConfVO.getOpenWeek1TmNm();
            openWeek1TmVal = scoreConfVO.getOpenWeek1TmVal();
            /* 강의오픈일 정보_끝 */

            /* 출석인정 기간_시작 */
            String atendTermNm, atendTermVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendAnceClassTerm(scoreConfVO);

            atendTermNm = scoreConfVO.getAtendTermNm();
            atendTermVal = scoreConfVO.getAtendTermVal();

            String atendWeekNm, atendWeekVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendAnceClassTermWeek(scoreConfVO);

            atendWeekNm = scoreConfVO.getAtendWeekNm();
            atendWeekVal = scoreConfVO.getAtendWeekVal();
            /* 출석인정 기간_끝 */

            /* 강의 출석/지각/결석 기준_정규학기_시작 */
            String atndRatioNm, atndRatioVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendRatioRegularClass(scoreConfVO);

            atndRatioNm = scoreConfVO.getAtndRatioNm();
            atndRatioVal = scoreConfVO.getAtndRatioVal();

            // 지각비율
            String lateRatioNm, lateRatioVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectLateRatioRegularClass(scoreConfVO);

            lateRatioNm = scoreConfVO.getLateRatioNm();
            lateRatioVal = scoreConfVO.getLateRatioVal();

            // 결석비율
            String absentRatioNm, absentRatioVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAbsentRatioRegularClass(scoreConfVO);

            absentRatioNm = scoreConfVO.getAbsentRatioNm();
            absentRatioVal = scoreConfVO.getAbsentRatioVal();
            /* 강의 출석/지각/결석 기준_정규학기_끝 */

            /* 강의 출석/지각/결석 기준_계절학기_시작 */
            String senLesnWeekNm, senLesnWeekVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAtndWeekSeasonClass(scoreConfVO);

            senLesnWeekNm = scoreConfVO.getSenLesnWeekNm();
            senLesnWeekVal = scoreConfVO.getSenLesnWeekVal();

            String senAtndRatioNm, senAtndRatioVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAtndRatioSeasonClass(scoreConfVO);

            senAtndRatioNm = scoreConfVO.getSenAtndRatioNm();
            senAtndRatioVal = scoreConfVO.getSenAtndRatioVal();

            String senAbsentRatioNm, senAbsentRatioVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAbsentRatioSeasonClass(scoreConfVO);

            senAbsentRatioNm = scoreConfVO.getSenAbsentRatioNm();
            senAbsentRatioVal = scoreConfVO.getSenAbsentRatioVal();

            String senLesnWeek1Nm, senLesnWeek1Val;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectWeek1SeasonClass(scoreConfVO);

            senLesnWeek1Nm = scoreConfVO.getSenLesnWeek1Nm();
            senLesnWeek1Val = scoreConfVO.getSenLesnWeek1Val();

            String senLesnWeek2Nm, senLesnWeek2Val;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectWeek2SeasonClass(scoreConfVO);

            senLesnWeek2Nm = scoreConfVO.getSenLesnWeek2Nm();
            senLesnWeek2Val = scoreConfVO.getSenLesnWeek2Val();

            String senLesnWeek3Nm, senLesnWeek3Val;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectWeek3SeasonClass(scoreConfVO);

            senLesnWeek3Nm = scoreConfVO.getSenLesnWeek3Nm();
            senLesnWeek3Val = scoreConfVO.getSenLesnWeek3Val();

            String senLesnWeek4Nm, senLesnWeek4Val;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectWeek4SeasonClass(scoreConfVO);

            senLesnWeek4Nm = scoreConfVO.getSenLesnWeek4Nm();
            senLesnWeek4Val = scoreConfVO.getSenLesnWeek4Val();
            /* 강의 출석/지각/결석 기준_계절학기_끝 */

            /* 강의 출석/지각/결석 기준_출석평가기준_시작 */
            String absentScoreVal5, absentScoreVal4, absentScoreVal3, absentScoreVal2, absentScoreVal1;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAbsentScoreClass(scoreConfVO);

            absentScoreVal5 = scoreConfVO.getAbsentScoreVal5();
            absentScoreVal4 = scoreConfVO.getAbsentScoreVal4();
            absentScoreVal3 = scoreConfVO.getAbsentScoreVal3();
            absentScoreVal2 = scoreConfVO.getAbsentScoreVal2();
            absentScoreVal1 = scoreConfVO.getAbsentScoreVal1();
            /* 강의 출석/지각/결석 기준_출석평가기준_끝 */

            /* 강의 출석/지각/결석 기준_지각감점기준_시작 */
            String lateScoreVal1, lateScoreVal2, lateScoreVal3, lateScoreVal4, lateScoreVal5, lateScoreVal6, lateScoreVal7;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectLateScoreClass(scoreConfVO);

            lateScoreVal1 = scoreConfVO.getLateScoreVal1();
            lateScoreVal2 = scoreConfVO.getLateScoreVal2();
            lateScoreVal3 = scoreConfVO.getLateScoreVal3();
            lateScoreVal4 = scoreConfVO.getLateScoreVal4();
            lateScoreVal5 = scoreConfVO.getLateScoreVal5();
            lateScoreVal6 = scoreConfVO.getLateScoreVal6();
            lateScoreVal7 = scoreConfVO.getLateScoreVal7();
            /* 강의 출석/지각/결석 기준_지각감점기준_끝 */

            /* 출석점수 기준설정 화면 표시 설정 시작 */

            // 강의오픈
            scoreConfVO.setOpenWeekNm(openWeekNm);
            scoreConfVO.setOpenWeekVal(openWeekVal);
            scoreConfVO.setOpenTmNm(openTmNm);
            scoreConfVO.setOpenTmVal(openTmVal);
            scoreConfVO.setOpenWeek1ApNm(openWeek1ApNm);
            scoreConfVO.setOpenWeek1ApVal(openWeek1ApVal);
            scoreConfVO.setOpenWeek1TmNm(openWeek1TmNm);
            scoreConfVO.setOpenWeek1TmVal(openWeek1TmVal);

            // 출석인정기간
            scoreConfVO.setAtendTermVal(atendTermVal);
            scoreConfVO.setAtendWeekVal(atendWeekVal);

            // 강의 출석/지각/결석 기준 정규학기
            // 출석비율
            scoreConfVO.setAtndRatioVal(atndRatioVal);

            // 지각비율
            scoreConfVO.setLateRatioVal(lateRatioVal);

            // 결석비율
            scoreConfVO.setAbsentRatioVal(absentRatioVal);

            // 강의 출석/지각/결석 기준 계절학기

            // 출석주차
            scoreConfVO.setSenLesnWeekVal(senLesnWeekVal);

            // 출석비율
            scoreConfVO.setSenAtndRatioVal(senAtndRatioVal);

            // 결석비율
            scoreConfVO.setSenAbsentRatioVal(senAbsentRatioVal);

            // 1주차강좌수
            scoreConfVO.setSenLesnWeek1Val(senLesnWeek1Val);

            // 2주차강좌수
            scoreConfVO.setSenLesnWeek2Val(senLesnWeek2Val);

            // 3주차강좌수
            scoreConfVO.setSenLesnWeek3Val(senLesnWeek3Val);

            // 4주차강좌수
            scoreConfVO.setSenLesnWeek4Val(senLesnWeek4Val);

            // 출석평가 기준
            scoreConfVO.setAbsentScoreVal5(absentScoreVal5);
            scoreConfVO.setAbsentScoreVal4(absentScoreVal4);
            scoreConfVO.setAbsentScoreVal3(absentScoreVal3);
            scoreConfVO.setAbsentScoreVal2(absentScoreVal2);
            scoreConfVO.setAbsentScoreVal1(absentScoreVal1);

            // 지각 감점 기준
            scoreConfVO.setLateScoreVal1(lateScoreVal1);
            scoreConfVO.setLateScoreVal2(lateScoreVal2);
            scoreConfVO.setLateScoreVal3(lateScoreVal3);
            scoreConfVO.setLateScoreVal4(lateScoreVal4);
            scoreConfVO.setLateScoreVal5(lateScoreVal5);
            scoreConfVO.setLateScoreVal6(lateScoreVal6);
            scoreConfVO.setLateScoreVal7(lateScoreVal7);

            request.setAttribute("vo", scoreConfVO);
            /* 출석점수 기준설정 화면 표시 설정 끝 */
            /* 출석 점수 기준_끝 */
        }

        return "crs/home/crs_prof_lesson_view2";
    }


    /**
     * 학생 강의보기
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/crsStdLessonView.do")
    public String crsStdLessonView(HttpServletRequest request, HttpServletResponse response, ModelMap model, RedirectAttributes redirectAttributes) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        if("".equals(userId)) {
            model.addAttribute("userId", "");
            model.addAttribute("stdNo", "");
        }

        String crsCreCd = request.getParameter("crsCreCd");
        String lessonScheduleId = request.getParameter("lessonScheduleId");
        String lessonTimeId = request.getParameter("lessonTimeId");
        String lessonCntsIdx = StringUtil.nvl(request.getParameter("lessonCntsIdx"), "0");

        // 과목정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setOrgId(SessionInfo.getOrgId(request));
        creCrsVO = crecrsService.select(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);

        String crsTypeCd = StringUtil.nvl(creCrsVO.getCrsTypeCd(), "UNI");

        // 현재학기 정보조회
        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);

        // 현재 학기 과목인지 체크
        if(termVO != null && creCrsVO != null && termVO.getTermCd().equals(StringUtil.nvl(creCrsVO.getTermCd()))) {
            model.addAttribute("currentTermYn", "Y");
        } else {
            model.addAttribute("currentTermYn", "N");
        }

        // 수강중인 학생정보 조회
        StdVO stdVO = new StdVO();
        stdVO.setOrgId(SessionInfo.getOrgId(request));
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(SessionInfo.getUserId(request));
        stdVO = stdService.selectStd(stdVO);

        model.addAttribute("userId", userId);
        model.addAttribute("stdNo", stdVO != null ? stdVO.getStdId() : "");

        // 주차정보 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);

        // 강의인정일 설정한 경우 적용
        if(lessonScheduleVO != null) {
            String lessonStartDt = lessonScheduleVO.getLessonStartDt();
            String lessonEndDt = lessonScheduleVO.getLessonEndDt();

            String ltDetmFrDt = lessonScheduleVO.getLtDetmFrDt();
            String ltDetmToDt = lessonScheduleVO.getLtDetmToDt();

            lessonStartDt = StringUtil.nvl(ltDetmFrDt, lessonStartDt);
            lessonEndDt = StringUtil.nvl(ltDetmToDt, lessonEndDt);

            lessonScheduleVO.setLessonStartDt(lessonStartDt);
            lessonScheduleVO.setLessonEndDt(lessonEndDt);
        }

        // 강의실 활동 로그 등록
        if(!"".equals(StringUtil.nvl(crsCreCd)) && !"".equals(StringUtil.nvl(userId)) && !"".equals(StringUtil.nvl(lessonScheduleVO.getLessonScheduleOrder()))) {
            logLessonActnHstyService.saveLessonActnHstyForStudy(request, crsCreCd, CommConst.ACTN_HSTY_LESSON, StringUtil.nvl(lessonScheduleVO.getLessonScheduleOrder()) + "주차 강의보기 시작");
        }
        // 필요 정보가 없을 경우 과목홈으로 이동처리
        else {
            redirectAttributes.addFlashAttribute("resultErrorCode", "fail_study_log");
            return "redirect:/crs/crsHomeStd.do?crsCreCd=" + crsCreCd;
        }

        // 교시정보 조회
        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setCrsCreCd(crsCreCd);
        lessonTimeVO.setLessonScheduleId(lessonScheduleId);
        lessonTimeVO.setLessonTimeId(lessonTimeId);
        lessonTimeVO = lessonService.selectLessonTime(lessonTimeVO);

        // 이전교시/다음교시 조회
        /*
        List<LessonTimeVO> timeList = lessonService.listLessonTimeByScheduleId(lessonTimeVO);

        for (LessonTimeVO timeVO : timeList) {
            if (timeVO.getLessonTimeOrder() < lessonTimeVO.getLessonTimeOrder()) {
                lessonTimeVO.setPrevTimeId(timeVO.getLessonTimeId());
            }
            if (timeVO.getLessonTimeOrder() > lessonTimeVO.getLessonTimeOrder() && StringUtil.isNull(lessonTimeVO.getNextTimeId())) {
                lessonTimeVO.setNextTimeId(timeVO.getLessonTimeId());
            }
        }
        */

        // 콘텐츠 목록 조회
        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setCrsCreCd(crsCreCd);
        lessonCntsVO.setLessonScheduleId(lessonScheduleId);
        lessonCntsVO.setLessonTimeId(lessonTimeId);
        List<LessonCntsVO> lessonCntsList = lessonService.listLessonCntsByLessonTime(lessonCntsVO);

        for(LessonCntsVO lessonCntsVO2 : lessonCntsList) {
            String lessonCntsId = lessonCntsVO2.getLessonCntsId();
            String cntsGbn = StringUtil.nvl(lessonCntsVO2.getCntsGbn());
            String lessonCntsUrl = lessonCntsVO2.getLessonCntsUrl();

            if("PDF".equals(cntsGbn) || "FILE".equals(cntsGbn)) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("LECTURE");
                fileVO.setFileBindDataSn(lessonCntsId);
                lessonCntsVO2.setFileList(sysFileService.list(fileVO).getReturnList());
            } else if("VIDEO".equals(cntsGbn)) {
                String ext = FileUtil.getFileExtention(lessonCntsUrl);
                String subtitKo = StringUtil.nvl(lessonCntsVO2.getSubtitKo());
                String scriptKo = StringUtil.nvl(lessonCntsVO2.getScriptKo());
                String subPath = "";
                if(ValidationUtils.isNotEmpty(lessonCntsUrl)) {
                    subPath = lessonCntsUrl.substring(0, lessonCntsUrl.lastIndexOf("/") + 1);
                }
                String subInfo = "";

                if(!"".equals(subtitKo)) {
                    JSONArray titList = (JSONArray) JSONSerializer.toJSON(subtitKo);
                    for(int i = 0; i < titList.size(); i++) {
                        JSONObject obj = (JSONObject) (titList.get(i));
                        subInfo += "<track kind='subtitles' label='" + obj.getString("label") + "' src='" + (CommConst.WEBDATA_CONTEXT + subPath + obj.getString("saveNm")) + "' srclang='" + obj.getString("srclang") + "'>\n";
                    }
                }

                if(!"".equals(scriptKo)) {
                    JSONObject subObj = JSONObject.fromObject(JSONSerializer.toJSON(scriptKo));
                    subInfo += "<video_script>" + (CommConst.WEBDATA_CONTEXT + subPath + subObj.get("saveNm")) + "</video_script>\n";
                }

                if("Y".equals(CommConst.CDN_NAS_YN) && "mp4".equals(ext)) {
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(new Date());
                    cal.add(Calendar.HOUR, 6); // 제한시간 설정
                    String limitTime = (new SimpleDateFormat("yyyyMMddHHmmss")).format(cal.getTime());
                    String cdnParam = "?&r=17&ip=127.0.0.1&limitTime=" + limitTime + "&userId=" + SessionInfo.getUserId(request) + "&checkIP=false";
                    if(lessonCntsUrl.indexOf("/") == 0) {
                        lessonCntsUrl = lessonCntsUrl.substring(1);
                    }

                    lessonCntsUrl = CommConst.CDN_URL_NAS + SecureUtil.encodeAesCbc((lessonCntsUrl + cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                } else {
                    lessonCntsUrl = CommConst.WEBDATA_CONTEXT + lessonCntsUrl;
                }

                lessonCntsVO2.setLessonCntsUrl(lessonCntsUrl);
                lessonCntsVO2.setSubInfo(subInfo);
            }
        }

        // 페이지 목록 조회
        LessonPageVO lessonPageVO = new LessonPageVO();
        lessonPageVO.setCrsCreCd(crsCreCd);
        lessonPageVO.setLessonScheduleId(lessonScheduleId);
        List<LessonPageVO> lessonPageList = lessonService.listLessonPageBySchedule(lessonPageVO);

        // 페이지 학습 기록 목록 조회
        LessonStudyPageVO lessonStudyPageVO = new LessonStudyPageVO();
        lessonStudyPageVO.setLessonTimeId(lessonTimeId);
        lessonStudyPageVO.setLessonScheduleId(lessonScheduleId);
        lessonStudyPageVO.setStdId(stdVO.getStdId());
        lessonStudyPageVO.setCrsCreCd(crsCreCd);
        List<LessonStudyPageVO> studyPageList = lessonStudyService.listLessonStudyPageBySchedule(lessonStudyPageVO);

        Map<String, LessonStudyPageVO> studyPageMap = new HashMap<>();

        // 페이지정보 설정
        setLessonPageInfo(lessonCntsList, lessonPageList, studyPageList, SessionInfo.getUserId(request), "N");

        int startPageIndex = 0;
        if(studyPageList.size() > 0) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
            List<Long> stdyPageDttmList = new ArrayList<>();

            for(LessonStudyPageVO stdPageVO : studyPageList) {
                stdyPageDttmList.add(dateFormat.parse(stdPageVO.getStudySessionDttm()).getTime());
                studyPageMap.put(stdPageVO.getLessonCntsId() + ":" + stdPageVO.getPageCnt(), stdPageVO);
            }

            long lastTime = Collections.max(stdyPageDttmList);
            startPageIndex = stdyPageDttmList.indexOf(lastTime);
        }

        // 학습기록 목록 조회
        LessonStudyRecordVO lessonStudyRecordVO = new LessonStudyRecordVO();
        lessonStudyRecordVO.setLessonScheduleId(lessonScheduleId);
        lessonStudyRecordVO.setStdId(stdVO.getStdId());
        lessonStudyRecordVO.setLessonTimeId(lessonTimeId);
        lessonStudyRecordVO.setCrsCreCd(crsCreCd);
        lessonStudyRecordVO.setUserId(userId);
        List<LessonStudyRecordVO> studyRecordList = lessonStudyService.listLessonStudyRecordByTime(lessonStudyRecordVO);

        // 학습기록 기본값 저장
        if(lessonCntsList.size() > 0 && !"".equals(StringUtil.nvl(crsCreCd)) && !"".equals(userId)) {
            List<LessonStudyRecordVO> saveRecordList = new ArrayList<>();
            Map<String, LessonStudyRecordVO> studyRecordMap = new HashMap<>();
            LessonStudyRecordVO recordVO;

            for(LessonStudyRecordVO recVO : studyRecordList) {

                studyRecordMap.put(recVO.getLessonCntsId(), recVO);
            }
            for(LessonCntsVO cntsVO : lessonCntsList) {
                if(!studyRecordMap.containsKey(cntsVO.getLessonCntsId())) {
                    recordVO = new LessonStudyRecordVO();
                    recordVO.setLessonCntsId(cntsVO.getLessonCntsId());
                    recordVO.setStdId(stdVO.getStdId());
                    recordVO.setCrsCreCd(crsCreCd);
                    recordVO.setUserId(userId);
                    saveRecordList.add(recordVO);
                }
            }

            if(saveRecordList.size() > 0) {
                lessonStudyService.saveLessonStudyRecordBasic(saveRecordList);
            }
        }

        // 학습상태 조회
        LessonStudyStateVO studyStateVO = new LessonStudyStateVO();
        studyStateVO.setLessonScheduleId(lessonScheduleId);
        studyStateVO.setStdId(stdVO.getStdId());
        studyStateVO = lessonStudyService.selectLessonStudyState(studyStateVO);
        if(studyStateVO == null) {
            studyStateVO = new LessonStudyStateVO();
            studyStateVO.setLessonScheduleId(lessonScheduleId);
            studyStateVO.setStdId(stdVO.getStdId());
            studyStateVO.setUserId(userId);
            studyStateVO.setCrsCreCd(crsCreCd);
            studyStateVO.setStudyStatusCd("STUDY");

            // 학습상태 기본값 저장
            if(!"".equals(StringUtil.nvl(crsCreCd)) && !"".equals(userId)) {
                lessonStudyService.insertLessonStudyState(studyStateVO);
            }
        }

        // 페이지 학습 기록 기본값 저장
        if(lessonPageList.size() > 0 && studyPageList.size() < lessonPageList.size()
                && !"".equals(StringUtil.nvl(crsCreCd)) && !"".equals(userId)) {
            List<LessonStudyPageVO> studyPageBasicList = new ArrayList<LessonStudyPageVO>();
            LessonStudyPageVO stdPageVO;

            for(LessonPageVO pageVO : lessonPageList) {
                if(!studyPageMap.containsKey(pageVO.getLessonCntsId() + ":" + pageVO.getPageCnt())) {
                    stdPageVO = new LessonStudyPageVO();
                    stdPageVO.setLessonCntsId(pageVO.getLessonCntsId());
                    stdPageVO.setStdId(stdVO.getStdId());
                    stdPageVO.setPageCnt(Integer.parseInt(pageVO.getPageCnt()));
                    stdPageVO.setUserId(userId);
                    stdPageVO.setCrsCreCd(crsCreCd);
                    studyPageBasicList.add(stdPageVO);
                }
            }

            lessonStudyService.saveLessonStudyPageBasicList(studyPageBasicList);
        }

        model.addAttribute("lessonSchedule", lessonScheduleVO);
        model.addAttribute("lessonTime", lessonTimeVO);
        model.addAttribute("lessonCntsList", lessonCntsList);
        model.addAttribute("studyRecordList", studyRecordList);
        model.addAttribute("lessonCntsIdx", lessonCntsIdx);
        model.addAttribute("studyStateVO", studyStateVO);
        model.addAttribute("startPageIndex", startPageIndex);

        String speedPlayTime = "false";

        // 법정교육 과목인 경우 배속시간 반영
        if("LEGAL".equals(crsTypeCd)) {
            speedPlayTime = "true";
        }

        // 배속시간 반영 설정
        model.addAttribute("speedPlayTime", speedPlayTime);

        /* 출석 점수 기준_시작 */
        if("UNI".equals(crsTypeCd)) {
            ScoreConfVO scoreConfVO = new ScoreConfVO();

            /* 강의오픈일 정보_시작 */
            String openWeekNm, openWeekVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendOpenClassWeek(scoreConfVO);

            openWeekNm = scoreConfVO.getOpenWeekNm();
            openWeekVal = scoreConfVO.getOpenWeekVal();

            String openTmNm, openTmVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendOpenClassTm(scoreConfVO);

            openTmNm = scoreConfVO.getOpenTmNm();
            openTmVal = scoreConfVO.getOpenTmVal();

            String openWeek1ApNm, openWeek1ApVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendOpenClassWeekAp(scoreConfVO);

            openWeek1ApNm = scoreConfVO.getOpenWeek1ApNm();
            openWeek1ApVal = scoreConfVO.getOpenWeek1ApVal();

            String openWeek1TmNm, openWeek1TmVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendOpenClassWeekTm(scoreConfVO);

            openWeek1TmNm = scoreConfVO.getOpenWeek1TmNm();
            openWeek1TmVal = scoreConfVO.getOpenWeek1TmVal();
            /* 강의오픈일 정보_끝 */

            /* 출석인정 기간_시작 */
            String atendTermNm, atendTermVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendAnceClassTerm(scoreConfVO);

            atendTermNm = scoreConfVO.getAtendTermNm();
            atendTermVal = scoreConfVO.getAtendTermVal();

            String atendWeekNm, atendWeekVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendAnceClassTermWeek(scoreConfVO);

            atendWeekNm = scoreConfVO.getAtendWeekNm();
            atendWeekVal = scoreConfVO.getAtendWeekVal();
            /* 출석인정 기간_끝 */

            /* 강의 출석/지각/결석 기준_정규학기_시작 */
            String atndRatioNm, atndRatioVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAttendRatioRegularClass(scoreConfVO);

            atndRatioNm = scoreConfVO.getAtndRatioNm();
            atndRatioVal = scoreConfVO.getAtndRatioVal();

            // 지각비율
            String lateRatioNm, lateRatioVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectLateRatioRegularClass(scoreConfVO);

            lateRatioNm = scoreConfVO.getLateRatioNm();
            lateRatioVal = scoreConfVO.getLateRatioVal();

            // 결석비율
            String absentRatioNm, absentRatioVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAbsentRatioRegularClass(scoreConfVO);

            absentRatioNm = scoreConfVO.getAbsentRatioNm();
            absentRatioVal = scoreConfVO.getAbsentRatioVal();
            /* 강의 출석/지각/결석 기준_정규학기_끝 */

            /* 강의 출석/지각/결석 기준_계절학기_시작 */
            String senLesnWeekNm, senLesnWeekVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAtndWeekSeasonClass(scoreConfVO);

            senLesnWeekNm = scoreConfVO.getSenLesnWeekNm();
            senLesnWeekVal = scoreConfVO.getSenLesnWeekVal();

            String senAtndRatioNm, senAtndRatioVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAtndRatioSeasonClass(scoreConfVO);

            senAtndRatioNm = scoreConfVO.getSenAtndRatioNm();
            senAtndRatioVal = scoreConfVO.getSenAtndRatioVal();

            String senAbsentRatioNm, senAbsentRatioVal;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAbsentRatioSeasonClass(scoreConfVO);

            senAbsentRatioNm = scoreConfVO.getSenAbsentRatioNm();
            senAbsentRatioVal = scoreConfVO.getSenAbsentRatioVal();

            String senLesnWeek1Nm, senLesnWeek1Val;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectWeek1SeasonClass(scoreConfVO);

            senLesnWeek1Nm = scoreConfVO.getSenLesnWeek1Nm();
            senLesnWeek1Val = scoreConfVO.getSenLesnWeek1Val();

            String senLesnWeek2Nm, senLesnWeek2Val;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectWeek2SeasonClass(scoreConfVO);

            senLesnWeek2Nm = scoreConfVO.getSenLesnWeek2Nm();
            senLesnWeek2Val = scoreConfVO.getSenLesnWeek2Val();

            String senLesnWeek3Nm, senLesnWeek3Val;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectWeek3SeasonClass(scoreConfVO);

            senLesnWeek3Nm = scoreConfVO.getSenLesnWeek3Nm();
            senLesnWeek3Val = scoreConfVO.getSenLesnWeek3Val();

            String senLesnWeek4Nm, senLesnWeek4Val;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectWeek4SeasonClass(scoreConfVO);

            senLesnWeek4Nm = scoreConfVO.getSenLesnWeek4Nm();
            senLesnWeek4Val = scoreConfVO.getSenLesnWeek4Val();
            /* 강의 출석/지각/결석 기준_계절학기_끝 */

            /* 강의 출석/지각/결석 기준_출석평가기준_시작 */
            String absentScoreVal5, absentScoreVal4, absentScoreVal3, absentScoreVal2, absentScoreVal1;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectAbsentScoreClass(scoreConfVO);

            absentScoreVal5 = scoreConfVO.getAbsentScoreVal5();
            absentScoreVal4 = scoreConfVO.getAbsentScoreVal4();
            absentScoreVal3 = scoreConfVO.getAbsentScoreVal3();
            absentScoreVal2 = scoreConfVO.getAbsentScoreVal2();
            absentScoreVal1 = scoreConfVO.getAbsentScoreVal1();
            /* 강의 출석/지각/결석 기준_출석평가기준_끝 */

            /* 강의 출석/지각/결석 기준_지각감점기준_시작 */
            String lateScoreVal1, lateScoreVal2, lateScoreVal3, lateScoreVal4, lateScoreVal5, lateScoreVal6, lateScoreVal7;
            scoreConfVO = (ScoreConfVO) scoreConfService.selectLateScoreClass(scoreConfVO);

            lateScoreVal1 = scoreConfVO.getLateScoreVal1();
            lateScoreVal2 = scoreConfVO.getLateScoreVal2();
            lateScoreVal3 = scoreConfVO.getLateScoreVal3();
            lateScoreVal4 = scoreConfVO.getLateScoreVal4();
            lateScoreVal5 = scoreConfVO.getLateScoreVal5();
            lateScoreVal6 = scoreConfVO.getLateScoreVal6();
            lateScoreVal7 = scoreConfVO.getLateScoreVal7();
            /* 강의 출석/지각/결석 기준_지각감점기준_끝 */

            /* 출석점수 기준설정 화면 표시 설정 시작 */

            // 강의오픈
            scoreConfVO.setOpenWeekNm(openWeekNm);
            scoreConfVO.setOpenWeekVal(openWeekVal);
            scoreConfVO.setOpenTmNm(openTmNm);
            scoreConfVO.setOpenTmVal(openTmVal);
            scoreConfVO.setOpenWeek1ApNm(openWeek1ApNm);
            scoreConfVO.setOpenWeek1ApVal(openWeek1ApVal);
            scoreConfVO.setOpenWeek1TmNm(openWeek1TmNm);
            scoreConfVO.setOpenWeek1TmVal(openWeek1TmVal);

            // 출석인정기간
            scoreConfVO.setAtendTermVal(atendTermVal);
            scoreConfVO.setAtendWeekVal(atendWeekVal);

            // 강의 출석/지각/결석 기준 정규학기
            // 출석비율
            scoreConfVO.setAtndRatioVal(atndRatioVal);

            // 지각비율
            scoreConfVO.setLateRatioVal(lateRatioVal);

            // 결석비율
            scoreConfVO.setAbsentRatioVal(absentRatioVal);

            // 강의 출석/지각/결석 기준 계절학기

            // 출석주차
            scoreConfVO.setSenLesnWeekVal(senLesnWeekVal);

            // 출석비율
            scoreConfVO.setSenAtndRatioVal(senAtndRatioVal);

            // 결석비율
            scoreConfVO.setSenAbsentRatioVal(senAbsentRatioVal);

            // 1주차강좌수
            scoreConfVO.setSenLesnWeek1Val(senLesnWeek1Val);

            // 2주차강좌수
            scoreConfVO.setSenLesnWeek2Val(senLesnWeek2Val);

            // 3주차강좌수
            scoreConfVO.setSenLesnWeek3Val(senLesnWeek3Val);

            // 4주차강좌수
            scoreConfVO.setSenLesnWeek4Val(senLesnWeek4Val);

            // 출석평가 기준
            scoreConfVO.setAbsentScoreVal5(absentScoreVal5);
            scoreConfVO.setAbsentScoreVal4(absentScoreVal4);
            scoreConfVO.setAbsentScoreVal3(absentScoreVal3);
            scoreConfVO.setAbsentScoreVal2(absentScoreVal2);
            scoreConfVO.setAbsentScoreVal1(absentScoreVal1);

            // 지각 감점 기준
            scoreConfVO.setLateScoreVal1(lateScoreVal1);
            scoreConfVO.setLateScoreVal2(lateScoreVal2);
            scoreConfVO.setLateScoreVal3(lateScoreVal3);
            scoreConfVO.setLateScoreVal4(lateScoreVal4);
            scoreConfVO.setLateScoreVal5(lateScoreVal5);
            scoreConfVO.setLateScoreVal6(lateScoreVal6);
            scoreConfVO.setLateScoreVal7(lateScoreVal7);

            request.setAttribute("vo", scoreConfVO);
            /* 출석점수 기준설정 화면 표시 설정 끝 */
        }
        /* 출석 점수 기준_끝 */


        // 중복학습창 체크값 저장
        if(CommConst.REDIS_USE && "Y".equals(CommConst.MULTISTUDY_CHECK_YN)) {
            String studyWindowId = StringUtil.generateKeyString(20);
            SessionUtil.setSessionValue(request, "STUDY_WINDOW_ID", studyWindowId);
            RedisUtil.setValue("StudyWindow:" + userId, studyWindowId, (24 * 60 * 60));
        }

        return "crs/home/crs_std_lesson_view2";
    }


    /**
     * 컨텐츠 강의보기
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/crsContentsLessonView.do")
    public String crsContentsLessonView(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String crsCreCd = request.getParameter("crsCreCd");
        String lessonScheduleId = request.getParameter("lessonScheduleId");
        String lessonTimeId = request.getParameter("lessonTimeId");

        // 주차정보 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO = lessonScheduleService.select(lessonScheduleVO);

        // 교시정보 조회
        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setCrsCreCd(crsCreCd);
        lessonTimeVO.setLessonScheduleId(lessonScheduleId);
        lessonTimeVO.setLessonTimeId(lessonTimeId);
        lessonTimeVO = lessonService.selectLessonTime(lessonTimeVO);

        // 콘텐츠 목록 조회
        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setCrsCreCd(crsCreCd);
        lessonCntsVO.setLessonScheduleId(lessonScheduleId);
        lessonCntsVO.setLessonTimeId(lessonTimeId);
        List<LessonCntsVO> lessonCntsList = lessonService.listLessonCntsByLessonTime(lessonCntsVO);

        // 페이지 목록 조회
        LessonPageVO lessonPageVO = new LessonPageVO();
        lessonPageVO.setCrsCreCd(crsCreCd);
        lessonPageVO.setLessonScheduleId(lessonScheduleId);
        List<LessonPageVO> lessonPageList = lessonService.listLessonPageBySchedule(lessonPageVO);

        // 페이지정보 설정
        setLessonPageInfo(lessonCntsList, lessonPageList, null, SessionInfo.getUserId(request), "Y");

        model.addAttribute("lessonSchedule", lessonScheduleVO);
        model.addAttribute("lessonTime", lessonTimeVO);
        model.addAttribute("lessonCntsList", lessonCntsList);

        return "crs/home/crs_contents_view";
    }

    /**
     * 강의 페이지정보 xml 변환
     *
     * @return
     */
    private void setLessonPageInfo(List<LessonCntsVO> lessonCntsList, List<LessonPageVO> lessonPageList, List<LessonStudyPageVO> studyPageList, String userId, String openYn) {
        String pageInfo = "";

        HashMap<String, LessonStudyPageVO> studyPageMap = new HashMap<>();
        if(studyPageList != null) {
            for(LessonStudyPageVO studyPageVO : studyPageList) {
                studyPageMap.put(studyPageVO.getLessonCntsId() + ":" + studyPageVO.getPageCnt(), studyPageVO);
            }
        }

        HashMap<String, List<LessonPageVO>> pageMap = new HashMap<>();
        if(lessonPageList != null && lessonPageList.size() > 0) {
            for(LessonPageVO pageVO : lessonPageList) {
                if(pageMap.containsKey(pageVO.getLessonCntsId())) {
                    (pageMap.get(pageVO.getLessonCntsId())).add(pageVO);
                } else {
                    List<LessonPageVO> list = new ArrayList<>();
                    list.add(pageVO);
                    pageMap.put(pageVO.getLessonCntsId(), list);
                }
            }
        }

        //int rnd = (int)(Math.random() * 89) + 10;
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.HOUR, 6);
        String limitTime = (new SimpleDateFormat("yyyyMMddHHmmss")).format(cal.getTime());
        String cdnParam = "?&r=17&ip=127.0.0.1&limitTime=" + limitTime + "&userId=" + userId + "&checkIP=false";

        if(lessonCntsList != null && lessonCntsList.size() > 0) {
            for(LessonCntsVO cntsVO : lessonCntsList) {
                if(pageMap.containsKey(cntsVO.getLessonCntsId())) {
                    List<LessonPageVO> list = pageMap.get(cntsVO.getLessonCntsId());
                    pageInfo = "<page_list>\n";

                    for(LessonPageVO pageVO : list) {
                        if("N".equals(openYn) && "N".equals(pageVO.getOpenYn())) {
                            continue;
                        }

                        String type = "html";
                        boolean on = false;
                        String sessionLoc = "0";
                        int studySessionTm = 0;
                        int studyCnt = 0;
                        int prgrRatio = 0;

                        if("MP4".equalsIgnoreCase(pageVO.getUploadGbn())) {
                            type = "video/mp4";
                        }

                        if(studyPageMap.containsKey(pageVO.getLessonCntsId() + ":" + pageVO.getPageCnt())) {
                            LessonStudyPageVO studyPageVO = studyPageMap.get(pageVO.getLessonCntsId() + ":" + pageVO.getPageCnt());
                            on = true;
                            sessionLoc = studyPageVO.getStudySessionLoc();
                            studySessionTm = studyPageVO.getStudySessionTm();
                            studyCnt = studyPageVO.getStudyCnt();
                            prgrRatio = studyPageVO.getPrgrRatio();
                        }

                        String hdUrl = pageVO.getUrl();
                        String sdUrl = "";
                        String srcUri = "";
                        String script = "";
                        String caption = "";
                        String chapter = "";
                        String extData = "";

                        int idx = hdUrl.indexOf("/courseware/");
                        if(idx > -1) {
                            hdUrl = hdUrl.substring(idx + 12);
                            srcUri = hdUrl.substring(0, hdUrl.lastIndexOf("/") + 1);
                            extData = new String((Base64.getEncoder()).encode((CommConst.CDN_URL + "," + srcUri + "," + CommConst.CDN_SECRET_IV + "," + CommConst.CDN_SECRET_KEY + "," + cdnParam).getBytes()));

                            if(hdUrl.indexOf("_hd.mp4") > 0) {
                                sdUrl = hdUrl.replace("_hd.mp4", "_sd.mp4");
                            }

                            script = srcUri + "media_script_list.xml";
                            caption = srcUri + "caption_list.xml";
                            chapter = srcUri + "chapter.xml";

                            try {
                                hdUrl = CommConst.CDN_URL + SecureUtil.encodeAesCbc((hdUrl + cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                script = CommConst.CDN_URL + SecureUtil.encodeAesCbc((script + cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                caption = CommConst.CDN_URL + SecureUtil.encodeAesCbc((caption + cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                chapter = CommConst.CDN_URL + SecureUtil.encodeAesCbc((chapter + cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);

                                if(!"".equals(sdUrl)) {
                                    sdUrl = CommConst.CDN_URL + SecureUtil.encodeAesCbc((sdUrl + cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                }

                            } catch(Exception e) {
                            }
                        }

                        if(idx == -1) {
                            idx = hdUrl.indexOf("/lecture/");
                            if(idx == 0) {
                                try {
                                    if("Y".equals(CommConst.CDN_NAS_YN) && hdUrl.indexOf(".mp4") > 0) {
                                        if(hdUrl.indexOf("/") == 0) {
                                            hdUrl = hdUrl.substring(1);
                                        }
                                        hdUrl = CommConst.CDN_URL_NAS + SecureUtil.encodeAesCbc((hdUrl + cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                    } else {
                                        hdUrl = CommConst.WEBDATA_CONTEXT + hdUrl;
                                    }
                                } catch(Exception e) {
                                }
                            }
                        }

                        pageInfo += "<page>\n";
                        pageInfo += "<page_cnt>" + pageVO.getPageCnt() + "</page_cnt>\n";
                        pageInfo += "<page_title>" + pageVO.getPageNm() + "</page_title>\n";
                        pageInfo += "<page_source>" + hdUrl + "</page_source>\n";

                        if(!"".equals(sdUrl)) {
                            pageInfo += "<page_source_sd>" + sdUrl + "</page_source_sd>\n";
                        }
                        if(!"".equals(script)) {
                            pageInfo += "<script_xml>" + script + "</script_xml>\n";
                        }
                        if(!"".equals(caption)) {
                            pageInfo += "<track_xml>" + caption + "</track_xml>\n";
                        }
                        if(!"".equals(chapter)) {
                            pageInfo += "<chapter_xml>" + chapter + "</chapter_xml>\n";
                        }

                        pageInfo += "<page_type>" + type + "</page_type>\n";
                        pageInfo += "<study_tm>" + studySessionTm + "</study_tm>\n";
                        pageInfo += "<prgr_ratio>" + prgrRatio + "</prgr_ratio>\n";
                        pageInfo += "<session_loc>" + sessionLoc + "</session_loc>\n";
                        pageInfo += "<study_cnt>" + studyCnt + "</study_cnt>\n";
                        pageInfo += "<on>" + on + "</on>\n";
                        pageInfo += "<videotm>" + pageVO.getVideoTm() + "</videotm>\n";
                        pageInfo += "<attend>" + pageVO.getAtndYn() + "</attend>\n";
                        pageInfo += "<openyn>" + pageVO.getOpenYn() + "</openyn>\n";
                        pageInfo += "<extdata>" + extData + "</extdata>\n";
                        pageInfo += "</page>\n";
                    }

                    pageInfo += "</page_list>";
                    cntsVO.setPageInfo(pageInfo);
                }
            }
        }
    }

    // (팝업)학습독려 팝업
    @RequestMapping(value="/learnAlarmPop.do")
    public String learnAlarmPop(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ASMT);

        String crsCreCd = request.getParameter("crsCreCd");
        String userId = SessionInfo.getUserId(request);

        // 강의/출석
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);

        // 과제
        AsmtVO asmtVO = new AsmtVO();
        asmtVO.setSelectType("LIST");
        asmtVO.setCrsCreCd(crsCreCd);
        asmtVO.setUserId(userId);

        // 토론
        ForumVO forumVO = new ForumVO();
        forumVO.setCrsCreCd(crsCreCd);

        // 시험
        ExamVO examVO = new ExamVO();
        examVO.setCrsCreCd(crsCreCd);
        examVO.setExamStareTypeCd("A");

        // 퀴즈
        ExamVO quizVO = new ExamVO();
        quizVO.setCrsCreCd(crsCreCd);
        quizVO.setExamCtgrCd("QUIZ");

        // 설문
        ReshVO reshVO = new ReshVO();
        reshVO.setCrsCreCd(crsCreCd);

        model.addAttribute("crsCreCd", crsCreCd);
        model.addAttribute("lessonScheduleList", lessonScheduleService.list(lessonScheduleVO));
        model.addAttribute("asmntList", asmtProService.selectAsmnt(asmtVO).getReturnList());
        model.addAttribute("forumList", forumService.list(forumVO).getReturnList());
        model.addAttribute("examList", examService.listExamByEtc(examVO));
        model.addAttribute("quizList", examService.list(quizVO).getReturnList());
        model.addAttribute("reshList", reshService.list(reshVO));

        return "crs/home/popup/learn_alarm_pop";
    }


    // 성능테스트위한 임시


    @RequestMapping(value="/crsHomeProfTest.do")
    public String crsHomeProfTest(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String crsCreCd = request.getParameter("crsCreCd");
        String termCd = "";
        String uniCd = "";
        Locale locale = LocaleUtil.getLocale(request);

        String orgId = SessionInfo.getOrgId(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String userType = SessionInfo.getAuthrtCd(request);


        // 테스트위한 임시 세션 설정
        SessionInfo.setOrgId(request, "ORG0000001");
        SessionInfo.setUserId(request, "prof1");
        SessionInfo.setUserId(request, "prof1");
        //SessionInfo.setUserId(request, "USR000001003");
        SessionInfo.setAuthrtCd(request, "|PFS");
        SessionInfo.setAuthrtGrpcd(request, "PROF");


        //개설과목코드 세션SET
        SessionInfo.setCrsCreCd(request, crsCreCd);
        SessionInfo.setCurCrsCreCd(request, crsCreCd);
        SessionInfo.setCurCorHome(request, "/crs/crsHomeProf.do");
        SessionInfo.setClassUserType(request, "prof");

        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);

        // 과목정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setOrgId(SessionInfo.getOrgId(request));
        creCrsVO = crecrsService.select(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);

        if(creCrsVO != null) {
            SessionInfo.setCrsCreNm(request, creCrsVO.getCrsCreNm() + " (" + creCrsVO.getDeclsNo() + messageSource.getMessage("dashboard.cor.dev_class", null, locale) + ")");
            termCd = creCrsVO.getTermCd();
            uniCd = creCrsVO.getUniCd();
        }

        SessionInfo.setCurTerm(request, termCd);
        SessionInfo.setCourseUniCd(request, uniCd);
        model.addAttribute("curTermCd", termCd);
        model.addAttribute("curCrsCreCd", crsCreCd);
        model.addAttribute("stdCnt", creCrsVO.getStdCnt());

        SessionInfo.setCreDeptNm(request, creCrsVO.getDeptNm());

        // 수업계획서 링크정보
        String sSmt = creCrsVO.getCreTerm().length() < 2 ? creCrsVO.getCreTerm() + "0" : creCrsVO.getCreTerm();
        String sCuriCls = creCrsVO.getDeclsNo().length() < 2 ? "0" + creCrsVO.getDeclsNo() : creCrsVO.getDeclsNo();
        //String plnParam = "{\"sYear\":\""+creCrsVO.getCreYear()+"\",\"sSmt\":\""+sSmt+"\",\"sCuriNum\":\""+creCrsVO.getCrsCd()+"\",\"sCuriCls\":\""+sCuriCls+"\"}";
        String plnParam = "{\"sCuriNum\":\"" + creCrsVO.getCrsCd() + "\",\"sCuriCls\":\"" + sCuriCls + "\"}";
        String lsnPlanUrl = CommConst.LSNPLAN_POP_URL + new String((Base64.getEncoder()).encode(plnParam.getBytes()));
        SessionInfo.setLessonPlanUrl(request, lsnPlanUrl);

        // 사용자 세션정보
        UsrUserInfoVO userInfo = new UsrUserInfoVO();
        String userId = SessionInfo.getUserId(request);
        userInfo.setUserId(userId);
        /*
         * // 학기목록 조회 TermVO termVO = new TermVO(); termVO.setUserId(userInfo.getUserId()); ProcessResultVO<TermVO>
         * termResult = dashboardService.listProfTerm(termVO); List<TermVO> termList = new ArrayList<>(); if
         * (termResult.getReturnList() != null && termResult.getReturnList().size() > 0) { termList =
         * termResult.getReturnList(); } model.addAttribute("termList", termList);
         */
        BbsAtclVO cosNoticeVO = new BbsAtclVO();
        cosNoticeVO.setOrgId(userInfo.getOrgId());
        cosNoticeVO.setBbsId("NOTICE");
        cosNoticeVO.setListScale(5);
        cosNoticeVO.setCrsCreCd(crsCreCd);

        // 강의 공지사항
        List<EgovMap> cosNoticeList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
        model.addAttribute("cosNoticeList", cosNoticeList);

        // 강의 QNA
        cosNoticeVO.setBbsId("QNA");
        List<EgovMap> cosQnaList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
        model.addAttribute("cosQnaList", cosQnaList);

        // QNA 미답변수 정보 조회
        EgovMap qnaNoAnsInfo = bbsAtclService.selectNoAnswerAtclStatus(cosNoticeVO);
        model.addAttribute("qnaNoAnsInfo", qnaNoAnsInfo);

        // 1:1 상담
        cosNoticeVO.setBbsId("SECRET");
        List<EgovMap> cosSecretList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
        model.addAttribute("cosSecretList", cosSecretList);

        // 1:1상담 미답변수 정보 조회
        EgovMap secretNoAnsInfo = bbsAtclService.selectNoAnswerAtclStatus(cosNoticeVO);
        model.addAttribute("secretNoAnsInfo", secretNoAnsInfo);

        // 강의실 학습주차 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        List<LessonScheduleVO> lessonScheduleList = lessonScheduleService.list(lessonScheduleVO);
        model.addAttribute("lessonScheduleList", lessonScheduleList);

        // 현재 주차 조회
        LessonScheduleVO currentLessonScheduleVO = new LessonScheduleVO();
        for(LessonScheduleVO lessonScheduleVO2 : lessonScheduleList) {
            if("PROGRESS".equals(lessonScheduleVO2.getLessonScheduleProgress())) {
                currentLessonScheduleVO = lessonScheduleVO2;
            }
        }
        model.addAttribute("currentLessonScheduleVO", currentLessonScheduleVO);

        // 강의실 교수 홈 학습요소 상태
        DefaultVO defaultVO = new DefaultVO();
        defaultVO.setCrsCreCd(crsCreCd);
        EgovMap profElementStatus = crsHomeService.selectCrsHomeProfElementStatus(defaultVO);
        model.addAttribute("profElementStatus", profElementStatus);

        // 업무일정 조회
        String examAbsentPeroidYn = "N";    // 결시원
        String scoreObjtPeriodYn = "N";     // 성적재확인
        String dsblReqPeriodYn = "N";       // 장애인지원

        SysJobSchVO sysJobSchVO;
        SysJobSchVO sysJobSchSearchVO = new SysJobSchVO();
        sysJobSchSearchVO.setOrgId(orgId);
        sysJobSchSearchVO.setUseYn("Y");
        sysJobSchSearchVO.setTermCd(termCd);
        // 00190901: 결시원 승인기간, 00210203: 성적이의 신청 정정기간(학부), 00210205: 성적이의 신청 정정기간(대학원), 00190806: 장애인 시험지원 승인기간
        sysJobSchSearchVO.setSqlForeach(new String[]{"00190901", "00210203", "00210205", "00190806"});
        List<SysJobSchVO> jobSchList = sysJobSchService.list(sysJobSchSearchVO);
        Map<String, SysJobSchVO> jobSchMap = new HashMap<>();
        for(SysJobSchVO sysJobSchVO2 : jobSchList) {
            jobSchMap.put(sysJobSchVO2.getCalendarCtgr(), sysJobSchVO2);
        }

        // 1.결시원 승인기간
        sysJobSchVO = jobSchMap.get("00190901");

        if(sysJobSchVO != null) {
            examAbsentPeroidYn = sysJobSchVO.getSysjobSchdlPeriodYn();
        }

        // 2.성적이의 신청 정정기간(학부)
        if("C".equals(uniCd)) {
            sysJobSchVO = jobSchMap.get("00210203");

            if(sysJobSchVO != null) {
                String jobSchPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();

                if("Y".equals(StringUtil.nvl(jobSchPeriodYn))) {
                    scoreObjtPeriodYn = "Y";
                }
            }
        }
        // 2.성적이의 신청 정정기간(대학원)
        else if("G".equals(uniCd)) {
            sysJobSchVO = jobSchMap.get("00210205");

            if(sysJobSchVO != null) {
                String jobSchPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();

                if("Y".equals(StringUtil.nvl(jobSchPeriodYn))) {
                    scoreObjtPeriodYn = "Y";
                }
            }
        }

        // 3.장애인 시험지원 승인기간
        sysJobSchVO = jobSchMap.get("00190806");

        if(sysJobSchVO != null) {
            dsblReqPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();
        }

        model.addAttribute("examAbsentPeroidYn", examAbsentPeroidYn);
        model.addAttribute("scoreObjtPeriodYn", scoreObjtPeriodYn);
        model.addAttribute("dsblReqPeriodYn", dsblReqPeriodYn);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));

        // 담당과목 교수/조교에 있는지 체크
        boolean isProf = false;
        List<EgovMap> tchList = crecrsService.listCrecrsTchEgov(creCrsVO);
        for(EgovMap map : tchList) {
            if(map.get("userId").equals(userId)) {
                if("ASSISTANT".equals(map.get("tchType"))) {
                    // 강의실 조교 권한 세팅
                    SessionInfo.setClassUserType(request, "tut");
                }

                isProf = true;
                break;
            }
        }

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", SessionInfo.getCrsCreCd(request));

        // 과목 접속자 목록 조회
        List<String> connCors = new ArrayList<>();
        connCors.add(crsCreCd);
        LogUserConnStateVO stateVO = new LogUserConnStateVO();
        stateVO.setConnGbn("learner");
        stateVO.setCorsList(connCors);
        stateVO.setSearchTm(CommConst.CONN_USER_CHECK_TIME); // 검색시간(분)

        List<LogUserConnStateVO> userConnList = logUserConnService.listLogUserConnState(stateVO);
        model.addAttribute("userConnList", userConnList);

        // 성능테스트위한 AJAX 부분 목록 조회
        LessonVO vo = new LessonVO();
        vo.setCrsCreCd(crsCreCd);
        vo.setSortKey("LESSON_SCHEDULE_ORDER_ASC");
        vo.setOrgId("ORG0000001");
        List<LessonScheduleVO> list = crsHomeService.listCrsHomeLessonSchedule(vo);


        String url = "crs/home/crs_home_prof";

        return url;
    }


    @RequestMapping(value="/crsHomeStdTest.do")
    public String crsHomeStdTest(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = request.getParameter("crsCreCd");
        String termCd = "";
        String uniCd = "";
        Locale locale = LocaleUtil.getLocale(request);

        if("".equals(StringUtil.nvl(crsCreCd))) {
            crsCreCd = SessionInfo.getCrsCreCd(request);
        }

        // 테스트위한 임시 세션 설정
        SessionInfo.setOrgId(request, "ORG0000001");
        SessionInfo.setUserId(request, "stu1");
        SessionInfo.setUserId(request, "stu1");
        //SessionInfo.setUserId(request, "USR000000078");
        SessionInfo.setAuthrtCd(request, "|USR");
        SessionInfo.setAuthrtGrpcd(request, "USR");

        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);
        // 강의실 활동 로그 등록 (common.log.classroomEnter: 강의실 입장)
        //logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_LECTURE_HOME, messageSource.getMessage("common.log.classroomEnter", null, locale));

        // 과목정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setOrgId(SessionInfo.getOrgId(request));
        creCrsVO = crecrsService.select(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);

        if(creCrsVO != null) {
            SessionInfo.setCrsCreNm(request, creCrsVO.getCrsCreNm() + " (" + creCrsVO.getDeclsNo() + messageSource.getMessage("dashboard.cor.dev_class", null, locale) + ")");
            termCd = creCrsVO.getTermCd();
            uniCd = creCrsVO.getUniCd();
        }

        // 수업계획서 링크정보
        String sSmt = creCrsVO.getCreTerm().length() < 2 ? creCrsVO.getCreTerm() + "0" : creCrsVO.getCreTerm();
        String sCuriCls = creCrsVO.getDeclsNo().length() < 2 ? "0" + creCrsVO.getDeclsNo() : creCrsVO.getDeclsNo();
        String plnParam = "{\"sYear\":\"" + creCrsVO.getCreYear() + "\",\"sSmt\":\"" + sSmt + "\",\"sCuriNum\":\"" + creCrsVO.getCrsCd() + "\",\"sCuriCls\":\"" + sCuriCls + "\"}";
        //String plnParam = "{\"sCuriNum\":\""+creCrsVO.getCrsCd()+"\",\"sCuriCls\":\""+sCuriCls+"\"}";
        String lsnPlanUrl = CommConst.LSNPLAN_POP_URL_STD + new String((Base64.getEncoder()).encode(plnParam.getBytes()));

        //개설과목코드 세션SET
        SessionInfo.setCrsCreCd(request, crsCreCd);
        SessionInfo.setCurCrsCreCd(request, crsCreCd);
        SessionInfo.setCurCorHome(request, "/crs/crsHomeStd.do");
        SessionInfo.setClassUserType(request, "learner");
        SessionInfo.setCurTerm(request, termCd);
        SessionInfo.setCourseUniCd(request, uniCd);
        SessionInfo.setCreDeptNm(request, creCrsVO.getDeptNm());
        SessionInfo.setLessonPlanUrl(request, lsnPlanUrl);

        model.addAttribute("curTermCd", termCd);
        model.addAttribute("curCrsCreCd", crsCreCd);
        model.addAttribute("stdCnt", creCrsVO.getStdCnt());

        // 사용자 세션정보
        UsrUserInfoVO userInfo = new UsrUserInfoVO();
        String userId = SessionInfo.getUserId(request);
        userInfo.setUserId(userId);

        BbsAtclVO cosNoticeVO = new BbsAtclVO();
        cosNoticeVO.setOrgId(userInfo.getOrgId());
        cosNoticeVO.setBbsId("NOTICE");
        cosNoticeVO.setUserId(userInfo.getUserId());
        cosNoticeVO.setListScale(5);
        cosNoticeVO.setCrsCreCd(crsCreCd);
        cosNoticeVO.setLearnerViewModeYn("Y");

        // 강의 공지사항
        List<EgovMap> cosNoticeList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
        model.addAttribute("cosNoticeList", cosNoticeList);

        // 강의 QNA
        cosNoticeVO.setBbsId("QNA");
        List<EgovMap> cosQnaList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
        model.addAttribute("cosQnaList", cosQnaList);

        // QNA 미답변수 조회
        EgovMap qnaNoAnsInfo = bbsAtclService.selectNoAnswerAtclStatus(cosNoticeVO);
        model.addAttribute("qnaNoAnsInfo", qnaNoAnsInfo);

        // 1:1 상담
        cosNoticeVO.setBbsId("SECRET");
        List<EgovMap> cosSecretList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
        model.addAttribute("cosSecretList", cosSecretList);

        // 1:1상담 미답변수 조회
        EgovMap secretNoAnsInfo = bbsAtclService.selectNoAnswerAtclStatus(cosNoticeVO);
        model.addAttribute("secretNoAnsInfo", secretNoAnsInfo);

        // 수강중인 학생정보 조회
        StdVO stdVO = new StdVO();
        stdVO.setOrgId(SessionInfo.getOrgId(request));
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(userId);
        stdVO = stdService.selectStd(stdVO);

        String stdNo = stdVO.getStdId();
        model.addAttribute("stdNo", stdNo);

        // 학습요소 참여현황 조회
        stdVO = new StdVO();
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setStdId(stdNo);
        stdVO.setUserId(userId);
        EgovMap JoinStatus = crsHomeService.selectCrsHomeStdJoinStatus(stdVO);
        model.addAttribute("JoinStatus", JoinStatus);

        // 강의실 학습주차 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        List<LessonScheduleVO> lessonScheduleList = lessonScheduleService.list(lessonScheduleVO);
        model.addAttribute("lessonScheduleList", lessonScheduleList);

        // 현재 주차 조회
        LessonScheduleVO currentLessonScheduleVO = new LessonScheduleVO();
        for(LessonScheduleVO lessonScheduleVO2 : lessonScheduleList) {
            if("PROGRESS".equals(lessonScheduleVO2.getLessonScheduleProgress())) {
                currentLessonScheduleVO = lessonScheduleVO2;
            }
        }

        // 업무일정 조회
        String examAbsentPeroidYn = "N";
        String scoreObjtPeriodYn = "N";
        String dsblReqPeriodYn = "N";

        SysJobSchVO sysJobSchVO;
        SysJobSchVO sysJobSchSearchVO = new SysJobSchVO();
        sysJobSchSearchVO.setOrgId(orgId);
        sysJobSchSearchVO.setUseYn("Y");
        sysJobSchSearchVO.setTermCd(termCd);

        // 00190904: 결시원 신청기간(중간), 00190905: 결시원 신청기간(기말), 00210202: 성적이의 신청기간(학부), 00210204: 성적이의 신청기간(대학원), 00190805: 장애인 시험지원 신청기간, 00190809: 장애인 시험지원요청 확인기간
        sysJobSchSearchVO.setSqlForeach(new String[]{"00190904", "00190905", "00210202", "00210204", "00190805", "00190809"});
        List<SysJobSchVO> jobSchList = sysJobSchService.list(sysJobSchSearchVO);
        Map<String, SysJobSchVO> jobSchMap = new HashMap<>();
        for(SysJobSchVO sysJobSchVO2 : jobSchList) {
            jobSchMap.put(sysJobSchVO2.getCalendarCtgr(), sysJobSchVO2);
        }

        // 1.결시원 신청기간 (중간)
        sysJobSchVO = jobSchMap.get("00190904");

        if(sysJobSchVO != null) {
            examAbsentPeroidYn = sysJobSchVO.getSysjobSchdlPeriodYn();
        }

        // 2.결시원 신청기간 (기말)
        if("N".equals(examAbsentPeroidYn)) {
            sysJobSchVO = jobSchMap.get("00190905");

            if(sysJobSchVO != null) {
                examAbsentPeroidYn = sysJobSchVO.getSysjobSchdlPeriodYn();
            }
        }

        // 2.성적이의 신청기간(학부)
        if("C".equals(uniCd)) {
            sysJobSchVO = jobSchMap.get("00210202");

            if(sysJobSchVO != null) {
                String jobSchPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();

                if("Y".equals(StringUtil.nvl(jobSchPeriodYn))) {
                    scoreObjtPeriodYn = "Y";
                }
            }
        }
        // 2.성적이의 신청기간(대학원)
        else if("G".equals(uniCd)) {
            sysJobSchVO = jobSchMap.get("00210204");

            if(sysJobSchVO != null) {
                String jobSchPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();

                if("Y".equals(StringUtil.nvl(jobSchPeriodYn))) {
                    scoreObjtPeriodYn = "Y";
                }
            }
        }

        // 3.장애인 시험지원 신청기간
        sysJobSchVO = jobSchMap.get("00190805");

        if(sysJobSchVO != null) {
            dsblReqPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();
        }

        // 3.장애인 시험지원요청 확인기간
        if(!"Y".equals(StringUtil.nvl(dsblReqPeriodYn))) {
            sysJobSchVO = jobSchMap.get("00190809");

            if(sysJobSchVO != null) {
                dsblReqPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();
            }
        }

        model.addAttribute("examAbsentPeroidYn", examAbsentPeroidYn);
        model.addAttribute("scoreObjtPeriodYn", scoreObjtPeriodYn);
        model.addAttribute("dsblReqPeriodYn", dsblReqPeriodYn);

        // Redirect 1회용 파라미터
        Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);
        if(flashMap != null) {
            // 주차 학습팝업 open
            String viewLessonScheduleId = (String) flashMap.get("viewLessonScheduleId");
            model.addAttribute("viewLessonScheduleId", viewLessonScheduleId);
        }

        model.addAttribute("currentLessonScheduleVO", currentLessonScheduleVO);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", SessionInfo.getCrsCreCd(request));

        // 과목 접속자 목록 조회
        List<String> connCors = new ArrayList<>();
        connCors.add(crsCreCd);
        LogUserConnStateVO stateVO = new LogUserConnStateVO();
        stateVO.setConnGbn("learner");
        stateVO.setCorsList(connCors);
        stateVO.setSearchTm(CommConst.CONN_USER_CHECK_TIME); // 검색시간(분)

        List<LogUserConnStateVO> userConnList = logUserConnService.listLogUserConnState(stateVO);
        model.addAttribute("userConnList", userConnList);


        // 성능테스트위한 AJAX 부분 목록 조회
        LessonVO vo = new LessonVO();
        vo.setUserId(userId);
        vo.setCrsCreCd(crsCreCd);
        vo.setSortKey("LESSON_SCHEDULE_ORDER_ASC");
        vo.setOrgId("ORG0000001");
        List<LessonScheduleVO> list = crsHomeService.listCrsHomeLessonSchedule(vo);


        String url = "crs/home/crs_home_std";

        return url;
    }
}