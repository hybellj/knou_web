package knou.lms.log.logintry.vo;

import knou.lms.common.vo.DefaultVO;

public class LogUserLoginTryLogVO extends DefaultVO {

	private static final long serialVersionUID = 7612328799504699385L;

	private String	loginTrySn;
	private	String	userId;
	private String	loginTryDttm;
	private String	loginSuccYn;
	private String	browserInfo;
	private String	connIp;
	
	private String  loginTryDttmStr;
	
	public LogUserLoginTryLogVO(String userId) {
		this.userId = userId;
	}

	public LogUserLoginTryLogVO() {
	}

	public String getLoginTrySn() {
		return this.loginTrySn;
	}
	
	public void setLoginTrySn(String loginTrySn) {
		this.loginTrySn = loginTrySn;
	}
	
	public String getUserId() {
		return this.userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public String getLoginTryDttm() {
		return this.loginTryDttm;
	}
	
	public void setLoginTryDttm(String loginTryDttm) {
		this.loginTryDttm = loginTryDttm;
	}
	
	public String getLoginSuccYn() {
		return this.loginSuccYn;
	}
	
	public void setLoginSuccYn(String loginSuccYn) {
		this.loginSuccYn = loginSuccYn;
	}
	
	public String getBrowserInfo() {
		return this.browserInfo;
	}
	
	public void setBrowserInfo(String browserInfo) {
		this.browserInfo = browserInfo;
	}
	
	public String getConnIp() {
		return this.connIp;
	}
	
	public void setConnIp(String connIp) {
		this.connIp = connIp;
	}

    public String getLoginTryDttmStr() {
        return loginTryDttmStr;
    }

    public void setLoginTryDttmStr(String loginTryDttmStr) {
        this.loginTryDttmStr = loginTryDttmStr;
    }

}
