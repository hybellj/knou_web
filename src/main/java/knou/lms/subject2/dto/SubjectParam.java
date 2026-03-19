package knou.lms.subject2.dto;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.BaseParam;

public class SubjectParam extends BaseParam {
	
	public SubjectParam(String subjectId) {
		setSubjectId(subjectId);
	}
	
	public SubjectParam(String subjectId, UserContext userCtx) {
		this.setSubjectId(subjectId);
		this.setOrgId(userCtx.getOrgId());
		this.setUserId(userCtx.getUserId());
	}
	
	public SubjectParam(String subjectId, UserContext userCtx, int limitTop) {
		this.setSubjectId(subjectId);
		this.setOrgId(userCtx.getOrgId());
		this.setUserId(userCtx.getUserId());		
		this.setLimitTop(limitTop);
	}	
}