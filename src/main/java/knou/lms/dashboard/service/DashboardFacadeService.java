package knou.lms.dashboard.service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.dashboard.web.view.DashboardViewModel;

public interface DashboardFacadeService {

    EgovMap loadFilterOptions(UserContext userCtx);

	public DashboardViewModel cmmonDashboardViewModel(SubjectDTO sbjctDto);
	
	public DashboardViewModel stdntDashboardViewModel(SubjectDTO sbjctDto);
	
	public DashboardViewModel profDashboardViewModel(SubjectDTO sbjctDto);

    public DashboardViewModel admDashboardViewModel(int limitTop);
	
	public DashboardViewModel getDashboardResponse(UserContext userCtx);
}