package knou.lms.login.param;

public class LoginParam {
	String	userId;
	String	userIdEncpswd;
	
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
}