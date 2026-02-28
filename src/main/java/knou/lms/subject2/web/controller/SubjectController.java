package knou.lms.subject2.web.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.lms.subject2.facade.SubjectFacadeService;
import knou.lms.subject2.web.view.SubjectMainResponse;

@Controller
public class SubjectController extends ControllerBase {
	
    private static final Logger LOGGER = LoggerFactory.getLogger(SubjectController.class);    
    
    @Resource(name="subjectFacadeService")
    private SubjectFacadeService subjectFacadeService;    

    /**
     * 과목메인화면
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"/subject2MainView.do"})
    public String crsHomeProf(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	String	returnUrl = "";
    	try {
    	//  TODO: 데이터정리
        // 	UserContext 	- 기관아이디, 대표아이디, 사용자아이디, 사용자유형, 사용자접속장치, IP, 마지마로그인 일시, 접속위치?, 날짜, 언어코드;
        //					- 이전접속위치, 이전접속일시, 이전접속체크번호
        //	AcademyContext 	- 학기, 주차, 
        //	AuthrityContext - 권한타입
        //	MenuContext 	- 메뉴타입
        //	SubjectContext 	- 과목정보 저장;
    	
    	//	사용자세션에서 가져오는 UserContext 	
    	// 	TODO: 로그인시 저장하는 변수로 지정하기 START
    	UserContext userCtx2 = new UserContext( SessionInfo.getOrgId(request),
    											SessionInfo.getUserId(request),
    											SessionInfo.getUserTycd(request),
    											SessionInfo.getAuthrtCd(request),
    											SessionInfo.getAuthrtGrpcd(request),
    											SessionInfo.getUserRprsId(request),
    											SessionInfo.getLastLogin(request) );
    	request.getSession().setAttribute("USER_CONTEXT", userCtx2);
    	// TODO: 로그인시 저장하는 변수로 지정하기 END
    	
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("USER_CONTEXT");
    	model.addAttribute("userCtx", userCtx);
    	
    	String subjectId = request.getParameter("subjectId"); //	TODO: 과목아이디 체크는 난중에
    	
    	SubjectMainResponse subjectMainView = subjectFacadeService.loadSubjectMainView(userCtx, subjectId);
    	
    	//	과목정보
    	model.addAttribute("subjectVO", 				subjectMainView.getSubjectVO());
    	
    	//	과목게시판아이디정보
    	model.addAttribute("subjectBbsIds", 			subjectMainView.getSubjectBbsIds()); 
    	
    	//	과목관리자정보
    	model.addAttribute("subjectAdms", 				subjectMainView.getSubjectAdmsMap());
    	
    	//	중간기말시험정보
    	model.addAttribute("middleLastExamMap", 		subjectMainView.getMiddleLastExamMap());
    	
    	//	성적학습활동목록
    	model.addAttribute("subjectLearningActvList", 	subjectMainView.getSubjectLearingActvList());
    	
    	//	최신게시글정보
        model.addAttribute("recentTopList", 			subjectMainView.getLatestTopArticlesList());
        
        //	최신게시글미열람미답변정보
        model.addAttribute("unreadNoreplyCnt",      	subjectMainView.getLatestTopArticlesListUnreadNoreplyCntMap());
    	
        //	강의일정목록조회
    	model.addAttribute("lectureScheduleList",		subjectMainView.getLectureScheduleList());
    	
    	//	교수강의일정목록조회
    	model.addAttribute("profLectureScheduleList",	subjectMainView.getProfLectureScheduleList()); 
    	
    	//	이번주강의정보
    	model.addAttribute("thisWeekLectureMap",		subjectMainView.getThisWeekLectureMap()); 
    	
    	//	주차별강의일정목록조회
    	model.addAttribute("byWeeknoLectureSchdlList",	subjectMainView.getByWeeknoLectureSchdlList());
    	
    	if ( userCtx.isProfessor() )
    		returnUrl = "subject2/prof_classroom";
    	
    	if ( userCtx.isStudent() )
    		returnUrl = "subject2/stdnt_classroom";
    	
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    	return returnUrl;
    }    
}