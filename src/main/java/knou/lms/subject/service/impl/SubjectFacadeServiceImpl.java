package knou.lms.subject.service.impl;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.lms.bbs2.service.Bbs2Service;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.lecture2.service.LectureScheduleService;
import knou.lms.subject.service.SubjectFacadeService;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.web.view.SubjectViewModel;

@Service("subjectFacadeService")
public class SubjectFacadeServiceImpl extends ServiceBase implements SubjectFacadeService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SubjectFacadeServiceImpl.class);

    @Resource(name="subjectService")
    private SubjectService subjectService;

    @Resource(name="lectureScheduleService")
    private LectureScheduleService lectureScheduleService;

    @Resource(name="bbs2Service")
    private Bbs2Service bbs2Service;

	//	과목 공통
	public SubjectViewModel cmmonSubjectViewModel(SubjectDTO sbjctDto){

		SubjectViewModel	subjectVM = new SubjectViewModel();

		//	게시판미열람수조회
		subjectVM.setBadge(bbs2Service.bbsUnreadCntSelect(sbjctDto));

		//	과목조회
		subjectVM.setSubjectVO(subjectService.subjectSelect(sbjctDto));

		//	과목게시판아이디조회
		subjectVM.setSubjectBbsIds(subjectService.subjectBbsIdsSelect(sbjctDto));

		//	과목최신공지사항목록조회
		subjectVM.setSubjectTopNoticeList(bbs2Service.subjectTopNoticeList(sbjctDto));

		//	과목최신강의Qna목록조회
		subjectVM.setSubjectTopLctrQnaList(bbs2Service.subjectTopLctrQnaList(sbjctDto));

		//	강의주차일정목록조회
		subjectVM.setLectureScheduleList(lectureScheduleService.lectureScheduleList(sbjctDto));

		//	금주강의조회
		subjectVM.setThisWeekLectureMap(lectureScheduleService.thisWeekLectureSelect(sbjctDto));

		//	주차별강의목록조회
		subjectVM.setByWeeknoLectureSchdlList(lectureScheduleService.byWeeknoLectureSchdlList(sbjctDto));

		// 	중간고사시험조회, 기말고사시험조회
		subjectVM.setMiddleLastExam(subjectService.middleLastExamSelect(sbjctDto));

		return subjectVM;
    }

	//	교수과목
	@Override
	public SubjectViewModel profSubjectViewModel(SubjectDTO sbjctDto){
		
		SubjectViewModel	subjectVM = cmmonSubjectViewModel(sbjctDto);

		//	과목학습활동목록조회
		subjectVM.setSubjectLearingActvList(subjectService.subjectLearningActvList(sbjctDto));

		//	교수과목최신일대일목록조회
		subjectVM.setProfSubjectTopOneOnOneList(bbs2Service.profSubjectTopOneOnOneList(sbjctDto));

		//	교수강의주차일정목록조회
		subjectVM.setProfLectureScheduleList(lectureScheduleService.profLectureScheduleList(sbjctDto));

		return subjectVM;
	}

	//	학생과목
	@Override
	public SubjectViewModel stdntSubjectViewModel(SubjectDTO sbjctDto){

		SubjectViewModel	subjectVM = cmmonSubjectViewModel(sbjctDto);

		//	과목관리자조회
		subjectVM.setSubjectAdms(subjectService.sbjctAdmSelect(sbjctDto));

		//	학생과목최신자료실목록조회
		subjectVM.setStdntSubjectTopDatarmList(bbs2Service.stdntSubjectTopDatarmList(sbjctDto));

		return subjectVM;
	}

	@Override
	public SubjectViewModel getSubjectViewModel(UserContext userCtx, String sbjctId) {
		
		SubjectDTO sbjctDto = new SubjectDTO(userCtx, sbjctId);

		SubjectViewModel subjectVM = new SubjectViewModel();

		if ( userCtx.isProfessor() ) {
			subjectVM = profSubjectViewModel(sbjctDto);
			subjectVM.setViewName("subject/prof_layout_classroom");
	        return subjectVM;
	    }

	    if ( userCtx.isStudent() ) {
	    	subjectVM = stdntSubjectViewModel(sbjctDto);
	    	subjectVM.setViewName("subject/stdnt_classroom");
	        return subjectVM;
	    }

	    subjectVM = new SubjectViewModel();
	    subjectVM.setViewName("subject/default_classroom");
	    return subjectVM;
	}
}