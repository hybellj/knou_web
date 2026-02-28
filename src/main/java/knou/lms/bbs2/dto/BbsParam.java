package knou.lms.bbs2.dto;

public class BbsParam {
	String	orgId;
	String	userId;
	String	subjectId;
	int		limitTop;
	
	public BbsParam() {};
	
	public BbsParam(String orgId, String userId, String subjectId, int limitTop) {
		this.orgId = orgId;
		this.userId = userId;
		this.subjectId = subjectId;
		this.limitTop = limitTop;
	}
	
	public BbsParam(String orgId, String userId, int limitTop) {
		this.orgId = orgId;
		this.userId = userId;
		this.limitTop = limitTop;
	}

	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public int getLimitTop() {
		return limitTop;
	}
	public void setLimitTop(int limitTop) {
		this.limitTop = limitTop;
	}
	public String getSubjectId() {
		return subjectId;
	}
	public void setSubjectId(String subjectId) {
		this.subjectId = subjectId;
	}
}