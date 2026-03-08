package knou.lms.dashboard.dto;

import knou.lms.common.dto.BaseParam;

public class DashboardParam extends BaseParam {
	
	public DashboardParam() {}
	
	public DashboardParam(String orgId, String userId, int limitTop) {
		this.setOrgId(orgId);
		this.setUserId(userId);
		this.setLimitTop(limitTop);
	}
}