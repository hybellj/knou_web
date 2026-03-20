package knou.lms.subject2.dto;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.BaseParam;

public class SubjectParam extends BaseParam {
	
	public SubjectParam(String subjectId) {
		setSubjectId(subjectId);
	}
	
	public SubjectParam(String subjectId, UserContext userCtx) {
		this.setOrgId(userCtx.getOrgId());
		this.setUserId(userCtx.getUserId());
		this.setSubjectId(subjectId);
	}	
	
	public SubjectParam(String subjectId, UserContext userCtx, int limitTop) {
		this.setOrgId(userCtx.getOrgId());
		this.setUserId(userCtx.getUserId());
		this.setSubjectId(subjectId);
		this.setLimitTop(limitTop);
	}	
	
	public SubjectParam(String orgId, String userId, String subjectId, int limitTop) {
		this.setOrgId(orgId);
		this.setUserId(userId);
		this.setSubjectId(subjectId);
		this.setLimitTop(limitTop);
	}	
}