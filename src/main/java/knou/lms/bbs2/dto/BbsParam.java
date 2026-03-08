package knou.lms.bbs2.dto;

import knou.lms.common.dto.BaseParam;

public class BbsParam extends BaseParam {
	
	String	bbsId;
	
	public BbsParam() {};
	
	public BbsParam(String orgId, String userId, String bbsId, int limitTop) {
		this.setOrgId(orgId);
		this.setUserId(userId);
		this.setBbsId(bbsId);
		this.setLimitTop(limitTop);
	}
	
	public BbsParam(String orgId, String userId, String subjectId, String bbsId, int limitTop) {
		this.setOrgId(orgId);
		this.setUserId(userId);
		this.setSubjectId(subjectId);
		this.setBbsId(bbsId);
		this.setLimitTop(limitTop);
	}

	public String getBbsId() {
		return bbsId;
	}
	public void setBbsId(String bbsId) {
		this.bbsId = bbsId;
	}
}