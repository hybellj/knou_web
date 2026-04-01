package knou.lms.dashboard.service.impl;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import knou.lms.bbs2.service.Bbs2Service;
import knou.lms.common.dto.BaseParam;
import knou.lms.dashboard.service.DashboardFacadeService;
import knou.lms.dashboard.web.view.DashboardViewModel;
import knou.lms.lecture2.service.LectureScheduleService;
import knou.lms.login.web.LoginControllerTOBE;
import knou.lms.subject.service.SubjectService;
import knou.lms.user.vo.UserVO;

@Service("dashboardFacadeService")
public class DashboardFacadeServiceImpl implements DashboardFacadeService {
	
	private static Logger log = Logger.getLogger(LoginControllerTOBE.class);
	
	@Resource(name="lectureScheduleService")
    private LectureScheduleService lectureScheduleService;
    
    @Resource(name="bbs2Service")
    private Bbs2Service bbs2Service; 
    
    @Resource(name="subjectService")
    private SubjectService subjectService;  

    //	대시보드 공통
	public DashboardViewModel cmmonDashboardViewModel(BaseParam param) throws Exception {		
		DashboardViewModel	dashVM = new DashboardViewModel();
		//	게시판미열람수조회
		dashVM.setBadge(bbs2Service.bbsUnreadCntSelect(param));	
		//	최신과정공지목록조회(전체)
		dashVM.setDashCrsNoticeList(bbs2Service.dashCrsNoticeList(param));			
		return dashVM;
    }

	//	대시보드 교수
	@Override
	public DashboardViewModel profDashboardViewModel(BaseParam param) throws Exception {		
		DashboardViewModel	dashVM = cmmonDashboardViewModel(param);
		
		//	교수대시보드 전체+과목 공지목록조회
		dashVM.setProfDashAllNoticeList(bbs2Service.profDashAllNoticeList(param));		
		//	교수대시보드 과목공지목록조회
		dashVM.setProfDashSubjectNoticeList(bbs2Service.profDashSubjectNoticeList(param));
		//	교수대시보드 강의Qna목록조회
		dashVM.setProfDashLctrQnaList(bbs2Service.profDashLctrQnaList(param));		
		//	교수대시보드 강의Qna목록조회
		dashVM.setProfDashOneOnOneList(bbs2Service.profDashOneOnOneList(param));
		//	교수대시보드 강의과목목록조회
		dashVM.setLctrSbjctSummaryList(subjectService.profSubjectSummaryList(param));
		
		return dashVM;
	}
	
	//	대시보드 학생
	@Override
	public DashboardViewModel stdntDashboardViewModel(BaseParam param) throws Exception {
		
		DashboardViewModel	dashVM = cmmonDashboardViewModel(param);
		//	학생대시보드 전체+과목 공지목록조회
		dashVM.setStdntDashAllNoticeList(bbs2Service.stdntDashAllNoticeList(param));
		//	학생대시보드 과목공지목록조회
		dashVM.setStdntDashSubjectNoticeList(bbs2Service.stdntDashSubjectNoticeList(param));		
		//	학생대시보드 강의Qna목록조회
		dashVM.setStdntDashLctrQnaList(bbs2Service.stdntDashLctrQnaList(param));		
		//	학생대시보드 자료실목록조회
		dashVM.setStdntDashDatarmList(bbs2Service.stdntDashDatarmList(param));		
		//	학생대시보드 강의과목목록조회
		dashVM.setLctrSbjctSummaryList(subjectService.stdntSubjectSummaryList(param));
		
		return dashVM;
	}
	
	//	화면이동설정
	public DashboardViewModel getDashboardResponse(UserVO selectedUser, BaseParam param) throws Exception {
		log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>selectedUser.getUserTycd()=" + selectedUser.getUserTycd());
		DashboardViewModel dsVM = new DashboardViewModel();
	    if ("PROF".equals(selectedUser.getUserTycd())) {
	    	dsVM = profDashboardViewModel(param);
	    	dsVM.setViewName("dashboard2/prof_dashboard");
	        return dsVM;
	    }

	    if ("STDNT".equals(selectedUser.getUserTycd())) {
	    	dsVM = stdntDashboardViewModel(param);
	    	dsVM.setViewName("/dashboard2/stdnt_dashboard");
	        return dsVM;
	    }

	    dsVM = new DashboardViewModel();
	    dsVM.setViewName("/dashboard2/default_dashboard");
	    return dsVM;
	}
}