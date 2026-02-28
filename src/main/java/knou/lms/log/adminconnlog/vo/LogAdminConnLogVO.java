package knou.lms.log.adminconnlog.vo;

import knou.lms.common.vo.DefaultVO;

public class LogAdminConnLogVO extends DefaultVO {

	private static final long serialVersionUID = 3393594960904216406L;
	
	private String	connLogSn;
	private String	userNm;
	private String	userId;
	private String	loginIp;
	private String	loginDttm;
	private String	logoutDttm;
	private String	lineNo;
	
	public String getConnLogSn() {
		return connLogSn;
	}
	public void setConnLogSn(String connLogSn) {
		this.connLogSn = connLogSn;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getLoginIp() {
		return loginIp;
	}
	public void setLoginIp(String loginIp) {
		this.loginIp = loginIp;
	}
	public String getLoginDttm() {
		return loginDttm;
	}
	public void setLoginDttm(String loginDttm) {
		this.loginDttm = loginDttm;
	}
	public String getLogoutDttm() {
		return logoutDttm;
	}
	public void setLogoutDttm(String logoutDttm) {
		this.logoutDttm = logoutDttm;
	}
	public String getLineNo() {
		return lineNo;
	}
	public void setLineNo(String lineNo) {
		this.lineNo = lineNo;
	}
}
