package knou.lms.subject.dto;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.BaseParam;

public class SubjectParam extends BaseParam {
	
	public SubjectParam(String sbjctId) {
		setSbjctId(sbjctId);
	}
	
	public SubjectParam(String sbjctId, UserContext userCtx) {
		this.setOrgId(userCtx.getOrgId());
		this.setUserId(userCtx.getUserId());
		this.setSbjctId(sbjctId);
	}	
	
	public SubjectParam(String sbjctId, UserContext userCtx, int limitTop) {
		this.setOrgId(userCtx.getOrgId());
		this.setUserId(userCtx.getUserId());
		this.setSbjctId(sbjctId);
		this.setLimitTop(limitTop);
	}	
	
	public SubjectParam(String orgId, String userId, String sbjctId, int limitTop) {
		this.setOrgId(orgId);
		this.setUserId(userId);
		this.setSbjctId(sbjctId);
		this.setLimitTop(limitTop);
	}	
}