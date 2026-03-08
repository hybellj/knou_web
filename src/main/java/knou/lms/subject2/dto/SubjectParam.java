package knou.lms.subject2.dto;

import knou.lms.common.dto.BaseParam;

public class SubjectParam extends BaseParam {
	
	public SubjectParam(String subjectId) {
		setSubjectId(subjectId);
	}
	
	public SubjectParam(String orgId, String userId, String subjectId, int limitTop) {
		this.setOrgId(orgId);
		this.setUserId(userId);
		this.setSubjectId(subjectId);
		this.setLimitTop(limitTop);
	}	
}