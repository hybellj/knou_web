package knou.lms.seminar.api.users.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ReqUserVO implements Serializable{

	private static final long serialVersionUID = 466498163494574690L;

	@JsonProperty("action")
	private String action;
	
	@JsonProperty("user_info")
	private UsersInfoVO userInfo;

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public UsersInfoVO getUserInfo() {
		return userInfo;
	}

	public void setUserInfo(UsersInfoVO userInfo) {
		this.userInfo = userInfo;
	}

	// Error 로그출력용
	@Override
	public String toString() {
		return "ReqUserVO [action=" + action + ", userInfo=" + userInfo.toString() + "]";
	}
	
}
