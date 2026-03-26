package knou.lms.lecture2.web;

import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.asmt.service.AsmtProService;
import knou.lms.bbs.service.BbsAtclService;
import knou.lms.common.service.SysFileService;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.home.service.CrsHomeMenuService;
import knou.lms.crs.home.service.CrsHomeService;
import knou.lms.crs.score.service.ScoreItemConfService;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.term.service.TermService;
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
import knou.lms.subject.dto.SubjectParam;
import knou.lms.subject.service.SubjectService;
import knou.lms.sys.service.SysJobSchService;

@Controller
public class LectureScheduleController extends ControllerBase {
	
    private static final Logger LOGGER = LoggerFactory.getLogger(LectureScheduleController.class);

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
     * ASIS	교수 주차 목록 상세     
     * TOBE 교수강의일정목록조회 (교수강의주차일정목록조회)
     * 
     * @param	request
     * @param	response
     * @param	model
     * @return
     * @throws 	Exception
     */
    @RequestMapping(value="/profLectureScheduleList.do")
    public 	String 	profLectureScheduleList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);

    	UserContext userCtx = (UserContext) request.getSession().getAttribute("USER_CONTEXT");
        String subjectId = request.getParameter("subjectId");
        
        
        String	userId = userCtx.getUserId();        
        String	deptId = userCtx.getDeptId();
        
        String	seminarAttendAuthYn = "N";
        String	lcdmsLinkYn = "Y"; // TODO 임의처리 

        //	강의일정목록조회
        List<EgovMap> lectureScheduleList = lectureScheduleService.profLectureScheduleList(new SubjectParam(subjectId));
        
        // 수업지원팀(20042), 교육플랫폼혁신팀(20134)
        if("20042".equals(deptId) || "20134".equals(deptId)) {
            seminarAttendAuthYn = "Y";
            
        } else {
        	
            List<EgovMap> sbjctAdmList = null; // subjectService.sbjctAdmSelect(sbjctOfrngId); // TODO: 과목관리자목록조회-일단주석처리 260202 jinkoon
            
            if(sbjctAdmList != null) {
                for(EgovMap map : sbjctAdmList) {
                    if(userId.equals(StringUtil.nvl(map.get("userId")))) {
                        seminarAttendAuthYn = "Y";
                        break;
                    }
                }
            }
        }

        model.addAttribute("subjectId", subjectId);
        model.addAttribute("lctrSchdlList", lectureScheduleList);
        model.addAttribute("deptId", SessionInfo.getUserDeptId(request));
        model.addAttribute("userId", SessionInfo.getUserId(request));
        model.addAttribute("prevCourseYn", SessionInfo.getPrevCourseYn(request));
        model.addAttribute("seminarAttendAuthYn", seminarAttendAuthYn);
        model.addAttribute("lcdmsLinkYn", StringUtil.nvl(request.getParameter("lcdmsLinkYn")));

        return 	"prof2/prof_subject_schedule_list";
    }
}