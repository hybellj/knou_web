package knou.lms.dashboard.facade;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.BaseParam;
import knou.lms.dashboard.web.view.DashboardViewModel;

public interface DashboardFacadeService {

	public DashboardViewModel cmmonDashboardViewModel(BaseParam param) throws Exception ;
	
	public DashboardViewModel stdntDashboardViewModel(BaseParam param) throws Exception ;
	
	public DashboardViewModel profDashboardViewModel(BaseParam param) throws Exception ;
	
	public DashboardViewModel getDashboardResponse(UserContext userCtx, BaseParam param) throws Exception ;
}