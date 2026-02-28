package knou.lms.user.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;


public class UsrUserInfoChgHstyVO extends DefaultVO {

	private static final long serialVersionUID = 1298581295332327903L;

	private String  userId;
	private String  userInfoChgDivCd;
	private String  userInfoChgDivNm;
	private String  userInfoCts;
	private String  chgTarget;
	private List<String>  chgTargetList;
	private String  connIp;
	private String  lineNo;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserInfoChgDivCd() {
		return userInfoChgDivCd;
	}
	public void setUserInfoChgDivCd(String userInfoChgDivCd) {
		this.userInfoChgDivCd = userInfoChgDivCd;
	}
	public String getUserInfoCts() {
		return userInfoCts;
	}
	public void setUserInfoCts(String userInfoCts) {
		this.userInfoCts = userInfoCts;
	}
	public String getChgTarget() {
		return chgTarget;
	}
	public void setChgTarget(String chgTarget) {
		this.chgTarget = chgTarget;
	}
	public List<String> getChgTargetList() {
		return chgTargetList;
	}
	public void setChgTargetList(List<String> chgTargetList) {
		this.chgTargetList = chgTargetList;
	}
	public String getConnIp() {
		return connIp;
	}
	public void setConnIp(String connIp) {
		this.connIp = connIp;
	}
	public String getLineNo() {
		return lineNo;
	}
	public void setLineNo(String lineNo) {
		this.lineNo = lineNo;
	}
    public String getUserInfoChgDivNm() {
        return userInfoChgDivNm;
    }
    public void setUserInfoChgDivNm(String userInfoChgDivNm) {
        this.userInfoChgDivNm = userInfoChgDivNm;
    }
}
