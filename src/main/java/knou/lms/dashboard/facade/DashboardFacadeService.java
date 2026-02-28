package knou.lms.dashboard.facade;

import knou.framework.context2.UserContext;
import knou.lms.bbs2.dto.BbsParam;
import knou.lms.dashboard.web.view.DashboardResponse;

public interface DashboardFacadeService {

	public DashboardResponse cmmonDashboardResponse(BbsParam param) throws Exception ;
	
	public DashboardResponse stdntDashboardResponse(BbsParam param) throws Exception ;
	
	public DashboardResponse profDashboardResponse(BbsParam param) throws Exception ;
	
	public DashboardResponse getDashboardResponse(UserContext userCtx, BbsParam param) throws Exception ;
}