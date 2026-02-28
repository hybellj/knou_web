package knou.lms.semester2.web;

import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.lms.asmt.service.AsmtProService;
import knou.lms.bbs.service.BbsAtclService;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.home.service.CrsHomeMenuService;
import knou.lms.crs.home.service.CrsHomeService;
import knou.lms.crs.score.service.ScoreItemConfService;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.service.DashboardService;
import knou.lms.exam.service.ExamService;
import knou.lms.forum.service.ForumService;
import knou.lms.lecture2.service.LectureScheduleService;
import knou.lms.lesson.service.LessonScheduleService;
import knou.lms.lesson.service.LessonService;
import knou.lms.lesson.service.LessonStudyService;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.log2.user.service.LogUserActvService;
import knou.lms.resh.service.ReshService;
import knou.lms.score.service.ScoreConfService;
import knou.lms.std.service.StdService;
import knou.lms.subject2.service.SubjectService;
import knou.lms.sys.service.SysJobSchService;

@Controller
public class SmstrChrtController extends ControllerBase {
	
    private static final Logger LOGGER = LoggerFactory.getLogger(SmstrChrtController.class);

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
    
    
    
    
    
    
    
    // TOBE : 
    @Resource(name="subjectService")
    private SubjectService subjectService;
    
    @Resource(name = "semesterService")
    private SemesterService semesterService;    
    
    @Resource(name="lectureScheduleService")
    private LectureScheduleService lectureScheduleService;
    
    @Resource(name="logUserActvService")
    private LogUserActvService logUserActvService;
    
    
    
    private String logSessData(HttpServletRequest request) {
    	HttpSession session = request.getSession(false); // 기존 세션 가져오기, 없으면 null 반환
    	StringBuilder sbSession = new StringBuilder();
    	if (session != null) {
    		List<String> attrNamesList = Collections.list(session.getAttributeNames());
    		Collections.sort(attrNamesList);
    		if (attrNamesList.isEmpty()) {		
		    	sbSession.append("세션은 존재하나 세션에 저장된 데이터가 없습니다.");
    		} else {
    			sbSession.append(String.format("\n%-150s 세션데이터START\n", " ").replace(" ", ">"));
    			for ( String nm : attrNamesList ) {
    				Object attrVal = session.getAttribute(nm);
    				sbSession.append(String.format("[세션][키=값][%-50s]", nm).replace(" ", "="));
    				sbSession.append(String.format("[%-5s]\n", attrVal));
    			}
    			sbSession.append(String.format("%-150s 세션데이터END\n", " ").replace(" ", "<"));
    		}
    	} else {
    		sbSession.append("세션이 존재하지 않습니다.");
    	}
    	return sbSession.toString();
	}  
    
    /**
     * ASIS 강의실 학기 목록 조회
     * TOBE 학기기수목록조회
     * @param	request
     * @param	response
     * @param	model
     * @return
     * @throws	Exception
     */
    @RequestMapping(value="/smstrChrtList.do")
    @ResponseBody
    public ProcessResultVO<TermVO> smstrChrtList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        
    	ProcessResultVO<TermVO> resultVO = new ProcessResultVO<>();
        // 사용자 세션정보
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String curCorHome = SessionInfo.getCurCorHome(request);
       
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

        return resultVO;
    }
}