package knou.lms.dashboard.service;

import knou.lms.common.dto.BaseParam;
import knou.lms.dashboard.web.view.DashboardViewModel;
import knou.lms.user.vo.UserVO;

public interface DashboardFacadeService {

	public DashboardViewModel cmmonDashboardViewModel(BaseParam param) throws Exception ;
	
	public DashboardViewModel stdntDashboardViewModel(BaseParam param) throws Exception ;
	
	public DashboardViewModel profDashboardViewModel(BaseParam param) throws Exception ;
	
	public DashboardViewModel getDashboardResponse(UserVO selectedUser, BaseParam param) throws Exception ;
}