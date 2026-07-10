package knou.lms.dashboard.service.impl;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.lms.bbs2.service.Bbs2Service;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.dashboard.service.DashboardFacadeService;
import knou.lms.dashboard.web.view.DashboardViewModel;
import knou.lms.lecture2.service.LectureScheduleService;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.srvy.service.SrvyService;
import knou.lms.subject.service.SubjectService;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

@Service("dashboardFacadeService")
public class DashboardFacadeServiceImpl implements DashboardFacadeService {

	private static Logger log = Logger.getLogger(DashboardFacadeServiceImpl.class);

	@Resource(name="lectureScheduleService")
    private LectureScheduleService lectureScheduleService;

    @Resource(name="bbs2Service")
    private Bbs2Service bbs2Service;

    @Resource(name="subjectService")
    private SubjectService subjectService;

    @Resource(name="semesterService")
    private SemesterService semesterService;

    @Resource(name="orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;

    @Resource(name="srvyService")
    private SrvyService srvyService;

    // 조회 옵션 세팅
    @Override
    public EgovMap loadFilterOptions(UserContext userCtx){
        EgovMap filterOptions = new EgovMap();

        String orgId = userCtx.getOrgId();
        filterOptions.put("orgId", orgId);

        // 연도 목록
        filterOptions.put("yearList", DateTimeUtil.getYearList(10, "mix"));

        // 현재 연도 : yyyy
        String curYear = DateTimeUtil.getYear();
        filterOptions.put("curYear", curYear);

        // 조회기준연도에 개설된 학기기수 조회
        SmstrChrtVO curSmstrChrtVO = new SmstrChrtVO();
        curSmstrChrtVO.setOrgId(orgId);
        curSmstrChrtVO.setDgrsYr(curYear);
        filterOptions.put("smstrChrtList", semesterService.listSmstrChrtByDgrsYr(curSmstrChrtVO));

        // 기관 목록 조회
        OrgInfoVO orgInfoVO = new OrgInfoVO();
        orgInfoVO.setOrgId(orgId);
        filterOptions.put("orgList", orgInfoService.list(orgInfoVO));

        // 기관에 따른 학과 조회
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(orgId);
        filterOptions.put("deptList", usrDeptCdService.list(usrDeptCdVO));

        return filterOptions;
    }

    //	대시보드 공통
	public DashboardViewModel cmmonDashboardViewModel(SubjectDTO sbjctDto){
		
		DashboardViewModel	dashVM = new DashboardViewModel();
		
		//	게시판미열람수조회
		dashVM.setBadge(bbs2Service.bbsUnreadCntSelect(sbjctDto));
		
		//	최신과정공지목록조회(전체)
		dashVM.setDashCrsNoticeList(bbs2Service.dashCrsNoticeList(sbjctDto));
		
		return dashVM;
    }

	//	대시보드 교수
	@Override
	public DashboardViewModel profDashboardViewModel(SubjectDTO sbjctDto){
		
		DashboardViewModel	dashVM = cmmonDashboardViewModel(sbjctDto);

		//	교수대시보드 전체+과목 공지목록조회
		dashVM.setProfDashAllNoticeList(bbs2Service.profDashAllNoticeList(sbjctDto));
		
		//	교수대시보드 과목공지목록조회
		dashVM.setProfDashSubjectNoticeList(bbs2Service.profDashSubjectNoticeList(sbjctDto));
		
		//	교수대시보드 강의Qna목록조회
		dashVM.setProfDashLctrQnaList(bbs2Service.profDashLctrQnaList(sbjctDto));
		
		//	교수대시보드 1ON1상담조회
		dashVM.setProfDashOneOnOneList(bbs2Service.profDashOneOnOneList(sbjctDto));
		
		//	교수대시보드 강의과목목록조회
		dashVM.setLctrSbjctSummaryList(subjectService.profSubjectSummaryList(sbjctDto));

		return dashVM;
	}

	//	대시보드 학생
	@Override
	public DashboardViewModel stdntDashboardViewModel(SubjectDTO sbjctDto) {

		DashboardViewModel	dashVM = cmmonDashboardViewModel(sbjctDto);
		
		//	학생대시보드 전체+과목 공지목록조회
		dashVM.setStdntDashAllNoticeList(bbs2Service.stdntDashAllNoticeList(sbjctDto));
		
		//	학생대시보드 과목공지목록조회
		dashVM.setStdntDashSubjectNoticeList(bbs2Service.stdntDashSubjectNoticeList(sbjctDto));
		
		//	학생대시보드 강의Qna목록조회
		dashVM.setStdntDashLctrQnaList(bbs2Service.stdntDashLctrQnaList(sbjctDto));
		
		//	학생대시보드 자료실목록조회
		dashVM.setStdntDashDatarmList(bbs2Service.stdntDashDatarmList(sbjctDto));
		
		//	학생대시보드 강의과목목록조회
		dashVM.setLctrSbjctSummaryList(subjectService.stdntSubjectSummaryList(sbjctDto));

		return dashVM;
	}

    // 대시보드 관리자
    @Override
    public DashboardViewModel admDashboardViewModel(int limitTop) {

        DashboardViewModel	dashVM = new DashboardViewModel();

        // 관리자 대시보드 시스템공지
        dashVM.setAdmDashSysNoticeList(bbs2Service.admDashSysNoticeList(limitTop));

        // 관리자 대시보드 전체 공지사항
        dashVM.setAdmDashAllNoticeList(bbs2Service.admDashAllNoticeList(limitTop));

        // 관리자 대시보드 전체 설문
        dashVM.setAdmDashAllSrvyList(srvyService.admAllSrvyList(limitTop));

        return dashVM;
    }

    //	화면이동설정
	public DashboardViewModel getDashboardResponse(UserContext userCtx) {		

		SubjectDTO sbjctDto = new SubjectDTO(userCtx);

		DashboardViewModel dsVM = new DashboardViewModel();
		
	    if (CommConst.AUTHRT_GRPCD_PROF.equals(userCtx.getLoginUser().getUserTycd())) {
	    	dsVM = profDashboardViewModel(sbjctDto);
	    	dsVM.setViewName("dashboard2/prof_dashboard");
	        return dsVM;
	    }

	    if (CommConst.AUTHRT_GRPCD_STDNT.equals(userCtx.getLoginUser().getUserTycd())) {
	    	dsVM = stdntDashboardViewModel(sbjctDto);
	    	dsVM.setViewName("/dashboard2/stdnt_dashboard");
	        return dsVM;
	    }

	    dsVM = new DashboardViewModel();
	    dsVM.setViewName("/dashboard2/default_dashboard");
	    return dsVM;
	}
}