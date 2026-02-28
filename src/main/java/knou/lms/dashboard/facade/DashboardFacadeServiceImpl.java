package knou.lms.dashboard.facade;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.context2.UserContext;
import knou.lms.bbs2.dto.BbsParam;
import knou.lms.bbs2.service.Bbs2Service;
import knou.lms.dashboard.web.view.DashboardResponse;
import knou.lms.lecture2.service.LectureScheduleService;

@Service("dashboardFacadeService")
public class DashboardFacadeServiceImpl implements DashboardFacadeService {
	
	@Resource(name="lectureScheduleService")
    private LectureScheduleService lectureScheduleService;
    
    @Resource(name="bbs2Service")
    private Bbs2Service bbs2Service;    

	public DashboardResponse cmmonDashboardResponse(BbsParam param) throws Exception {		
		DashboardResponse	dashboardResponse = new DashboardResponse();		
		//	모든공지목록조회
		dashboardResponse.setTopAllNoticeList(bbs2Service.topAllNoticeList(param));			
		//	과정공지목록조회(전체)
		dashboardResponse.setTopCrsNoticeList(bbs2Service.topCrsNoticeList(param));		
		//	최신게시글미열람미답변건수조회
		dashboardResponse.setLatestTopArticlesUnreadNoreplyCntSelect(bbs2Service.latestTopArticlesUnreadNoreplyCntSelect(param));
		
		return dashboardResponse;
    }

	@Override
	public DashboardResponse profDashboardResponse(BbsParam param) throws Exception {		
		DashboardResponse	dashboardResponse = cmmonDashboardResponse(param);		
		//	교수과목공지목록조회
		dashboardResponse.setProfTopSubjctNoticeList(bbs2Service.profTopSubjctNoticeList(param));
		//	교수강의Qna목록조회
		dashboardResponse.setProfTopLctrQnaList(bbs2Service.profTopLctrQnaList(param));		
		//	교수강의Qna목록조회
		dashboardResponse.setProfTopOneOnOneList(bbs2Service.profTopOneOnOneList(param));
		
		return dashboardResponse;
	}
	
	@Override
	public DashboardResponse stdntDashboardResponse(BbsParam param) throws Exception {		
		DashboardResponse	dashboardResponse = cmmonDashboardResponse(param);		
		//	학생과목공지목록조회
		dashboardResponse.setStdntTopSubjctNoticeList(bbs2Service.stdntTopSubjctNoticeList(param));		
		//	학생강의Qna목록조회
		dashboardResponse.setStdntTopLctrQnaList(bbs2Service.stdntTopLctrQnaList(param));		
		//	학생자료실목록조회
		dashboardResponse.setStdntTopDatarmList(bbs2Service.stdntTopDatarmList(param));	
		
		return dashboardResponse;
	}
	
	public DashboardResponse getDashboardResponse(UserContext userCtx, BbsParam param) throws Exception {

	    if (userCtx.isProfessor()) {
	        DashboardResponse response = profDashboardResponse(param);
	        response.setViewName("dashboard2/prof_dashboard");
	        return response;
	    }

	    if (userCtx.isStudent()) {
	        DashboardResponse response = stdntDashboardResponse(param);
	        response.setViewName("dashboard2/stdnt_dashboard");
	        return response;
	    }

	    DashboardResponse response = new DashboardResponse();
	    response.setViewName("dashboard2/default_dashboard");
	    return response;
	}
}