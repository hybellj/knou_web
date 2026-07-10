package knou.lms.login.vo;

import knou.lms.common.vo.DefaultVO;

public class LoginVO extends DefaultVO {

	private static final long serialVersionUID = 1L;

    private String loginId;
    private String userPass;
    private String userPassConfirm;
    private String tmpPass;
    private String newUserPass;
    private String newUserPassConfirm;
    private String encUserPass;
    private String encTmpPass;
    private String encUserId;
    private String adminLoginAcptDivCd;
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
    private String encryptData;

    /* 2016-12-21 arothy about SNS*/
    private String snsKey;
    private String snsDiv;
    private String snsCode;

    private String ssoKey;
    private String ssoIdx;

    private String  wwwAuthGrpCd;
    private String  adminAuthGrpCd;
    private String  mngAuthGrpCd;
    private String  wwwAuthGrpNm;
    private String  adminAuthGrpNm;
    private String  mngAuthGrpNm;

    /** 로그인 입력 아이디(대표 아이디). EP: LOGIN_ID */
    private String userId;

    /** 통합 번호(대표 아이디가 보유한 개별 아이디 키). EP: INTG_NO */
    private String intgNo;

    /** 대표 아이디. (userId 와 동일할 수 있으나 별도 보관) */
    private String userRprsId;

    /** 비밀번호(암호화 저장값). 평문비교 금지 - 해시/암호화 비교 권장 */
    private String userIdEncpswd;

    /** 기관/조직 ID. 화면 hidden orgId 와 매핑 */
    private String orgId;

    /** 기관/조직명 */
    private String orgNm;

    /** 사용자 유형 코드 (학생/직원/교수/일반 등). EP: TB_EPO_USER_TP.USER_TP_CD */
    private String userTycd;

    /** 권한 코드 */
    private String authrtCd;

    /** 권한 그룹 코드 */
    private String authrtGrpcd;

    /** 사용자명 */
    private String userNm;

    /** 출처 구분 : "EP" | "LMS" (서비스 분기 결과 표시용) */
    private String userSrcDvcd;

    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getLoginId() {
        return loginId;
    }
    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }
    public String getUserPass() {
        return userPass;
    }
    public void setUserPass(String userPass) {
        this.userPass = userPass;
    }
    public String getUserPassConfirm() {
        return userPassConfirm;
    }
    public void setUserPassConfirm(String userPassConfirm) {
        this.userPassConfirm = userPassConfirm;
    }
    public String getTmpPass() {
        return tmpPass;
    }
    public void setTmpPass(String tmpPass) {
        this.tmpPass = tmpPass;
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
    public String getEncTmpPass() {
        return encTmpPass;
    }
    public void setEncTmpPass(String encTmpPass) {
        this.encTmpPass = encTmpPass;
    }
    public String getEncUserId() {
        return encUserId;
    }
    public void setEncUserId(String encUserId) {
        this.encUserId = encUserId;
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
    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
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
    public String getWwwAuthGrpCd() {
        return wwwAuthGrpCd;
    }
    public void setWwwAuthGrpCd(String wwwAuthGrpCd) {
        this.wwwAuthGrpCd = wwwAuthGrpCd;
    }
    public String getAdminAuthGrpCd() {
        return adminAuthGrpCd;
    }
    public void setAdminAuthGrpCd(String adminAuthGrpCd) {
        this.adminAuthGrpCd = adminAuthGrpCd;
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
    public String getOrgNm() {
        return orgNm;
    }
    public void setOrgNm(String orgNm) {
        this.orgNm = orgNm;
    }
    public String getEncryptData() {
        return encryptData;
    }
    public void setEncryptData(String encryptData) {
        this.encryptData = encryptData;
    }
	public String getIntgNo() {
		return intgNo;
	}
	public String getUserRprsId() {
		return userRprsId;
	}
	public String getUserIdEncpswd() {
		return userIdEncpswd;
	}
	public String getUserTycd() {
		return userTycd;
	}
	public String getAuthrtCd() {
		return authrtCd;
	}
	public String getAuthrtGrpcd() {
		return authrtGrpcd;
	}
	public String getUserNm() {
		return userNm;
	}
	public String getUserSrcDvcd() {
		return userSrcDvcd;
	}
	public void setIntgNo(String intgNo) {
		this.intgNo = intgNo;
	}
	public void setUserRprsId(String userRprsId) {
		this.userRprsId = userRprsId;
	}
	public void setUserIdEncpswd(String userIdEncpswd) {
		this.userIdEncpswd = userIdEncpswd;
	}
	public void setUserTycd(String userTycd) {
		this.userTycd = userTycd;
	}
	public void setAuthrtCd(String authrtCd) {
		this.authrtCd = authrtCd;
	}
	public void setAuthrtGrpcd(String authrtGrpcd) {
		this.authrtGrpcd = authrtGrpcd;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public void setUserSrcDvcd(String userSrcDvcd) {
		this.userSrcDvcd = userSrcDvcd;
	}
}
