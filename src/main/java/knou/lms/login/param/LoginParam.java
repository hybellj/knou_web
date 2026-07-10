package knou.lms.login.param;

public class LoginParam {
	
	private String	orgId;
	private String	orgnm;
	private String	userId;
	private String	userIdEncpswd;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserIdEncpswd() {
		return this.userIdEncpswd;
	}
	public void setUserIdEncpswd(String userIdEncpswd) {
		this.userIdEncpswd = userIdEncpswd;
	}
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getOrgnm() {
		return orgnm;
	}
	public void setOrgnm(String orgnm) {
		this.orgnm = orgnm;
	}	

	// 🌟 콘솔 및 로그 확인용 toString() 메서드 추가
	@Override
	public String toString() {
		return "LoginParam [" +
				"orgId='" + orgId + '\'' +
				", orgnm='" + orgnm + '\'' +
				", userId='" + userId + '\'' +
				", userIdEncpswd=" + (userIdEncpswd != null ? "'[PROTECTED:LEN=" + userIdEncpswd.length() + "]'" : "null") +
				']';
	}
}