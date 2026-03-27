package knou.lms.common.dto;

public abstract class BaseParam {
	
	String	orgId;
	String	userId;
	int		limitTop;
	String	sbjctId;
	
	public BaseParam() {};
	
	public BaseParam(String sbjctId) {
		this.setSbjctId(sbjctId);
	}
	
	public BaseParam(String orgId, String userId, int limitTop) {
		this.setOrgId(orgId);
		this.setUserId(userId);
		this.setLimitTop(limitTop);
	}
	
	public BaseParam(String orgId, String userId, String sbjctId, int limitTop) {
		this.setOrgId(orgId);
		this.setUserId(userId);
		this.setSbjctId(sbjctId);
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
	public String getSbjctId() {
		return sbjctId;
	}
	public void setSbjctId(String sbjctId) {
		this.sbjctId = sbjctId;
	}	
}