package knou.lms.user.vo;

import knou.lms.common.vo.DefaultVO;

public class UsrLoginVO extends DefaultVO {

	private static final long serialVersionUID = 5941614641360094267L;
	
	private String loginId;
	private String userIdEncpswd;
	private String userPassConfirm;
	private String tmpPswd;
	private String newUserPass;
	private String newUserPassConfirm;
	private String encUserPass;
	private String encTmpPass;
	private String encUserId;
	private String adminLoginAcptDivCd;
	private String loginAcptDivCd;
	private String loginFailDttm;
	private Integer loginFailCnt;
	private String lastLoginDttm;
	private Integer loginCnt;
	private String secedeDttm;
	private String userSts;
	private String isUseable = "N";
	private String loginUseYn;
	private String cfgLoginCnt;
	private String pswdChgReqDttm;
	private String pswdChgReqYn;
//	private String orgId;
	private String orgNm;

	private String encryptData;
	
	/* 2016-12-21 arothy about SNS*/
	private String snsKey;
	private String snsDiv;
	private String snsCode;
	
	private String ssoKey;
	private String ssoIdx;
	private String sessionId;
	
	private String	wwwAuthrtCd;
    private String  authrtTycd;
	private String	admAuthrtCd;
	private String  mngAuthGrpCd;
	private String	wwwAuthGrpNm;
	private String	adminAuthGrpNm;
	private String  mngAuthGrpNm;
	
	private String modChgFromMenuCd;    // 사용자 모드 전환 시 복귀용 메뉴코드
	private String ModChgSearchCond;    // 사용자 모드 전환시 전환전 화면의 검색조건(원 사용자로 되 돌아갔을때 원 화면과 똑같이 구성하기 위해)
	
	public String getWwwAuthrtCd() {
		return wwwAuthrtCd;
	}
	public void setWwwAuthrtCd(String wwwAuthGrpCd) {
		this.wwwAuthrtCd = wwwAuthGrpCd;
	}
    public String getAuthrtTycd() {
    	return authrtTycd;
    }
    public void setAuthrtTycd(String authrtTycd) {
    	this.authrtTycd = authrtTycd;
    }
	public String getAdminAuthGrpCd() {
		return admAuthrtCd;
	}
	public void setAdminAuthGrpCd(String adminAuthGrpCd) {
		this.admAuthrtCd = adminAuthGrpCd;
	}
	public String getMngAuthGrpCd() {
		return mngAuthGrpCd;
	}
	public void setMngAuthGrpCd(String mngAuthGrpCd) {
		this.mngAuthGrpCd = mngAuthGrpCd;
	}
	public String getWwwAuthGrpNm() {
		return wwwAuthGrpNm;
	}
	public void setWwwAuthGrpNm(String wwwAuthGrpNm) {
		this.wwwAuthGrpNm = wwwAuthGrpNm;
	}
	public String getAdminAuthGrpNm() {
		return adminAuthGrpNm;
	}
	public void setAdminAuthGrpNm(String adminAuthGrpNm) {
		this.adminAuthGrpNm = adminAuthGrpNm;
	}
	public String getMngAuthGrpNm() {
		return mngAuthGrpNm;
	}
	public void setMngAuthGrpNm(String mngAuthGrpNm) {
		this.mngAuthGrpNm = mngAuthGrpNm;
	}
	public String getSnsKey() {
		return snsKey;
	}
	public void setSnsKey(String snsKey) {
		this.snsKey = snsKey;
	}
	public String getSnsDiv() {
		return snsDiv;
	}
	public void setSnsDiv(String snsDiv) {
		this.snsDiv = snsDiv;
	}
//	public String getUserId() {
//		return userId;
//	}
//	public void setUserId(String userId) {
//		this.userId = userId;
//	}
//	public String getUserId() {
//		return userId;
//	}
//	public void setUserId(String userId) {
//		this.userId = userId;
//	}
	public String getUserIdEncpswd() {
		return userIdEncpswd;
	}
	public void setUserIdEncpswd(String userIdEncpswd) {
		this.userIdEncpswd = userIdEncpswd;
	}
	public String getUserPassConfirm() {
		return userPassConfirm;
	}
	public void setUserPassConfirm(String userPswdConfirm) {
		this.userPassConfirm = userPswdConfirm;
	}
	public String getTmpPswd() {
		return tmpPswd;
	}
	public void setTmpPswd(String tmpPswd) {
		this.tmpPswd = tmpPswd;
	}
	public String getNewUserPass() {
		return newUserPass;
	}
	public void setNewUserPass(String newUserPass) {
		this.newUserPass = newUserPass;
	}
	public String getNewUserPassConfirm() {
		return newUserPassConfirm;
	}
	public void setNewUserPassConfirm(String newUserPassConfirm) {
		this.newUserPassConfirm = newUserPassConfirm;
	}
	public String getEncUserPass() {
		return encUserPass;
	}
	public void setEncUserPass(String encUserPass) {
		this.encUserPass = encUserPass;
	}
	public String getAdminLoginAcptDivCd() {
		return adminLoginAcptDivCd;
	}
	public void setAdminLoginAcptDivCd(String adminLoginAcptDivCd) {
		this.adminLoginAcptDivCd = adminLoginAcptDivCd;
	}
	public String getLoginFailDttm() {
		return loginFailDttm;
	}
	public void setLoginFailDttm(String loginFailDttm) {
		this.loginFailDttm = loginFailDttm;
	}
	public Integer getLoginFailCnt() {
		return loginFailCnt;
	}
	public void setLoginFailCnt(Integer loginFailCnt) {
		this.loginFailCnt = loginFailCnt;
	}
	public String getLastLoginDttm() {
		return lastLoginDttm;
	}
	public void setLastLoginDttm(String lastLoginDttm) {
		this.lastLoginDttm = lastLoginDttm;
	}
	public Integer getLoginCnt() {
		return loginCnt;
	}
	public void setLoginCnt(Integer loginCnt) {
		this.loginCnt = loginCnt;
	}
	public String getSecedeDttm() {
		return secedeDttm;
	}
	public void setSecedeDttm(String secedeDttm) {
		this.secedeDttm = secedeDttm;
	}
	public String getUserSts() {
		return userSts;
	}
	public void setUserSts(String userSts) {
		this.userSts = userSts;
	}
	public String getEncryptData() {
		return encryptData;
	}
	public void setEncryptData(String encryptData) {
		this.encryptData = encryptData;
	}
	public String getIsUseable() {
		return isUseable;
	}
	public void setIsUseable(String isUseable) {
		this.isUseable = isUseable;
	}
	public String getLoginUseYn() {
		return loginUseYn;
	}
	public void setLoginUseYn(String loginUseYn) {
		this.loginUseYn = loginUseYn;
	}
	public String getCfgLoginCnt() {
		return cfgLoginCnt;
	}
	public void setCfgLoginCnt(String cfgLoginCnt) {
		this.cfgLoginCnt = cfgLoginCnt;
	}
	public String getPswdChgReqDttm() {
		return pswdChgReqDttm;
	}
	public void setPswdChgReqDttm(String pswdChgReqDttm) {
		this.pswdChgReqDttm = pswdChgReqDttm;
	}
	public String getPswdChgReqYn() {
		return pswdChgReqYn;
	}
	public void setPswdChgReqYn(String pswdChgReqYn) {
		this.pswdChgReqYn = pswdChgReqYn;
	}
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getSnsCode() {
		return snsCode;
	}
	public void setSnsCode(String snsCode) {
		this.snsCode = snsCode;
	}
	public String getSsoKey() {
		return ssoKey;
	}
	public void setSsoKey(String ssoKey) {
		this.ssoKey = ssoKey;
	}
	public String getSsoIdx() {
		return ssoIdx;
	}
	public void setSsoIdx(String ssoIdx) {
		this.ssoIdx = ssoIdx;
	}
//	public String getOrgId() {
//		return orgId;
//	}
//	public void setOrgId(String orgId) {
//		this.orgId = orgId;
//	}
	public String getEncUserId() {
		return encUserId;
	}
	public void setEncUserId(String encUserId) {
		this.encUserId = encUserId;
	}
	public String getEncTmpPass() {
		return encTmpPass;
	}
	public void setEncTmpPass(String encTmpPass) {
		this.encTmpPass = encTmpPass;
	}
    public String getOrgNm() {
        return orgNm;
    }
    public void setOrgNm(String orgNm) {
        this.orgNm = orgNm;
    }
    public String getModChgFromMenuCd() {
        return modChgFromMenuCd;
    }
    public void setModChgFromMenuCd(String modChgFromMenuCd) {
        this.modChgFromMenuCd = modChgFromMenuCd;
    }
    public String getModChgSearchCond() {
        return ModChgSearchCond;
    }
    public void setModChgSearchCond(String modChgSearchCond) {
        ModChgSearchCond = modChgSearchCond;
    }
    public String getSessionId() {
        return sessionId;
    }
    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }
    public String getLoginAcptDivCd() {
        return loginAcptDivCd;
    }
    public void setLoginAcptDivCd(String loginAcptDivCd) {
        this.loginAcptDivCd = loginAcptDivCd;
    }

}
