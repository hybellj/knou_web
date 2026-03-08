package knou.lms.common.dto;

public abstract class BaseParam {
	
	String	orgId;
	String	userId;
	int		limitTop;
	String	subjectId;
	
	public BaseParam() {};
	
	public BaseParam(String subjectId) {
		this.setSubjectId(subjectId);
	}
	
	public BaseParam(String orgId, String userId, int limitTop) {
		this.setOrgId(orgId);
		this.setUserId(userId);
		this.setLimitTop(limitTop);
	}
	
	public BaseParam(String orgId, String userId, String subjectId, int limitTop) {
		this.setOrgId(orgId);
		this.setUserId(userId);
		this.setSubjectId(subjectId);
		this.setLimitTop(limitTop);
	}
	
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
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