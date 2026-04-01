package knou.lms.dashboard.dto;

import knou.lms.common.dto.BaseParam;
import knou.lms.user.vo.UserVO;

public class DashboardParam extends BaseParam {
	
	public DashboardParam() {}
	
	public DashboardParam(String orgId, String userId, int limitTop) {
		this.setOrgId(orgId);
		this.setUserId(userId);
		this.setLimitTop(limitTop);
	}
	
	public DashboardParam(UserVO selectedUser, int limitTop) {
		this.setOrgId(selectedUser.getOrgId());
		this.setUserId(selectedUser.getUserId());
		this.setLimitTop(limitTop);
	}
}