package knou.lms.subject2.facade;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.lms.bbs2.service.Bbs2Service;
import knou.lms.lecture2.service.LectureScheduleService;
import knou.lms.subject2.service.SubjectService;
import knou.lms.subject2.web.view.SubjectMainResponse;

@Service("subjectFacadeService")
public class SubjectFacadeServiceImpl extends ServiceBase implements SubjectFacadeService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SubjectFacadeServiceImpl.class);

    @Resource(name="subjectService")
    private SubjectService subjectService;

    @Resource(name="lectureScheduleService")
    private LectureScheduleService lectureScheduleService;

    @Resource(name="bbs2Service")
    private Bbs2Service bbs2Service;

	@Override
	public SubjectMainResponse loadSubjectMainView(UserContext userCtx, String subjectId) throws Exception {
		
		SubjectMainResponse	subjectMainResponse = new SubjectMainResponse();
		
		//	과목조회
		subjectMainResponse.setSubjectVO(subjectService.subjectSelect(subjectId));
		
		//	과목게시판아이디조회
		subjectMainResponse.setSubjectBbsIds(subjectService.subjectBbsIdsSelect(subjectId));
		
		//	과목관리자들조회
		subjectMainResponse.setSubjectAdmsMap(subjectService.sbjctAdmSelect(subjectId));		
		
		//	과목학습활동목록조회
		subjectMainResponse.setSubjectLearingActvList(subjectService.subjectLearningActvList(subjectId));
		
		//	중간고사시험조회, 기말고사시험조회
		subjectMainResponse.setMiddleLastExamMap(subjectService.middleLastExamSelect(subjectId));
		
		//	최신게시글목록조회
		subjectMainResponse.setLatestTopArticlesList(bbs2Service.latestTopArticlesList(userCtx.getUserId(), subjectId, 3));
		
		//	최신게시글미열람미답변건수조회	
		//subjectMainView.setLatestTopArticlesUnreadNoreplyCntSelect(bbs2Service.latestTopArticlesUnreadNoreplyCntSelect(userCtx.getUserId(), subjectId));
		
		//	강의주차일정목록조회
		subjectMainResponse.setLectureScheduleList(lectureScheduleService.lectureScheduleList(subjectId));
		
		//	교수강의주차일정목록조회
		subjectMainResponse.setProfLectureScheduleList(lectureScheduleService.profLectureScheduleList(subjectId));
		
		//	금주강의조회
		subjectMainResponse.setThisWeekLectureMap(lectureScheduleService.thisWeekLectureSelect(subjectId));
					
		//	주차별강의목록조회
		subjectMainResponse.setByWeeknoLectureSchdlList(lectureScheduleService.byWeeknoLectureSchdlList(subjectId));
		
		return subjectMainResponse;
	}  
}