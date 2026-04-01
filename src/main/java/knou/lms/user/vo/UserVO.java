package knou.lms.user.vo;

import java.io.Serializable;

import knou.lms.login.param.LoginParam;

public class UserVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String userId;
    private String userRprsId;
    private String orgId;
    private String usernm;
    private String userEnnm;
    private String userTycd;
    private String userStngCts;
    private String deptId;
    private String photoFileId;
    private String userStscd;
    private String mnDsblCd;
    private String mnDsblGrdcd;
    private String scndDsblCd;
    private String scndDsblGrdcd;
    private String examSprtAplyTycd;
    private String snryn;
    private String gndrTycd;
    private String userEnvStngCts;
    private String userIdEncpswd;
    private String userIdAplyDttm;
    private Integer lgnCntnuFailCnt;
    private String userIdLockyn;
    private String lgnMthdGbncd;
    private String userIdAprvDttm;
    private String userIdLeaveDttm;
    private String userIdStscd;
    private String userIdMigyn;
    private String dupLgnPrmyn;
    private String autoLgnUseyn;
    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;
    private String pushTalkSmsFlag;
    private String shrtntAlimRcvyn;
    private String emlAlimRcvyn;
    private String useEmlGbncd;
    private String userNcnm;
    private String stdntNo;
    private String dsblyn;
    
    public UserVO() {}

	public UserVO(LoginParam param) {
		this.setUserId(param.getUserId());
		this.setUserIdEncpswd(param.getUserIdEncpswd());
	}

	public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUserRprsId() { return userRprsId; }
    public void setUserRprsId(String userRprsId) { this.userRprsId = userRprsId; }

    public String getOrgId() { return orgId; }
    public void setOrgId(String orgId) { this.orgId = orgId; }

    public String getUsernm() { return usernm; }
    public void setUsernm(String usernm) { this.usernm = usernm; }

    public String getUserEnnm() { return userEnnm; }
    public void setUserEnnm(String userEnnm) { this.userEnnm = userEnnm; }

    public String getUserTycd() { return userTycd; }
    public void setUserTycd(String userTycd) { this.userTycd = userTycd; }

    public String getUserStngCts() { return userStngCts; }
    public void setUserStngCts(String userStngCts) { this.userStngCts = userStngCts; }

    public String getDeptId() { return deptId; }
    public void setDeptId(String deptId) { this.deptId = deptId; }

    public String getPhotoFileId() { return photoFileId; }
    public void setPhotoFileId(String photoFileId) { this.photoFileId = photoFileId; }

    public String getUserStscd() { return userStscd; }
    public void setUserStscd(String userStscd) { this.userStscd = userStscd; }

    public String getMnDsblCd() { return mnDsblCd; }
    public void setMnDsblCd(String mnDsblCd) { this.mnDsblCd = mnDsblCd; }

    public String getMnDsblGrdcd() { return mnDsblGrdcd; }
    public void setMnDsblGrdcd(String mnDsblGrdcd) { this.mnDsblGrdcd = mnDsblGrdcd; }

    public String getScndDsblCd() { return scndDsblCd; }
    public void setScndDsblCd(String scndDsblCd) { this.scndDsblCd = scndDsblCd; }

    public String getScndDsblGrdcd() { return scndDsblGrdcd; }
    public void setScndDsblGrdcd(String scndDsblGrdcd) { this.scndDsblGrdcd = scndDsblGrdcd; }

    public String getExamSprtAplyTycd() { return examSprtAplyTycd; }
    public void setExamSprtAplyTycd(String examSprtAplyTycd) { this.examSprtAplyTycd = examSprtAplyTycd; }

    public String getSnryn() { return snryn; }
    public void setSnryn(String snryn) { this.snryn = snryn; }

    public String getGndrTycd() { return gndrTycd; }
    public void setGndrTycd(String gndrTycd) { this.gndrTycd = gndrTycd; }

    public String getUserEnvStngCts() { return userEnvStngCts; }
    public void setUserEnvStngCts(String userEnvStngCts) { this.userEnvStngCts = userEnvStngCts; }

    public String getUserIdEncpswd() { return userIdEncpswd; }
    public void setUserIdEncpswd(String userIdEncpswd) { this.userIdEncpswd = userIdEncpswd; }

    public String getUserIdAplyDttm() { return userIdAplyDttm; }
    public void setUserIdAplyDttm(String userIdAplyDttm) { this.userIdAplyDttm = userIdAplyDttm; }

    public Integer getLgnCntnuFailCnt() { return lgnCntnuFailCnt; }
    public void setLgnCntnuFailCnt(Integer lgnCntnuFailCnt) { this.lgnCntnuFailCnt = lgnCntnuFailCnt; }

    public String getUserIdLockyn() { return userIdLockyn; }
    public void setUserIdLockyn(String userIdLockyn) { this.userIdLockyn = userIdLockyn; }

    public String getLgnMthdGbncd() { return lgnMthdGbncd; }
    public void setLgnMthdGbncd(String lgnMthdGbncd) { this.lgnMthdGbncd = lgnMthdGbncd; }

    public String getUserIdAprvDttm() { return userIdAprvDttm; }
    public void setUserIdAprvDttm(String userIdAprvDttm) { this.userIdAprvDttm = userIdAprvDttm; }

    public String getUserIdLeaveDttm() { return userIdLeaveDttm; }
    public void setUserIdLeaveDttm(String userIdLeaveDttm) { this.userIdLeaveDttm = userIdLeaveDttm; }

    public String getUserIdStscd() { return userIdStscd; }
    public void setUserIdStscd(String userIdStscd) { this.userIdStscd = userIdStscd; }

    public String getUserIdMigyn() { return userIdMigyn; }
    public void setUserIdMigyn(String userIdMigyn) { this.userIdMigyn = userIdMigyn; }

    public String getDupLgnPrmyn() { return dupLgnPrmyn; }
    public void setDupLgnPrmyn(String dupLgnPrmyn) { this.dupLgnPrmyn = dupLgnPrmyn; }

    public String getAutoLgnUseyn() { return autoLgnUseyn; }
    public void setAutoLgnUseyn(String autoLgnUseyn) { this.autoLgnUseyn = autoLgnUseyn; }

    public String getRgtrId() { return rgtrId; }
    public void setRgtrId(String rgtrId) { this.rgtrId = rgtrId; }

    public String getRegDttm() { return regDttm; }
    public void setRegDttm(String regDttm) { this.regDttm = regDttm; }

    public String getMdfrId() { return mdfrId; }
    public void setMdfrId(String mdfrId) { this.mdfrId = mdfrId; }

    public String getModDttm() { return modDttm; }
    public void setModDttm(String modDttm) { this.modDttm = modDttm; }

    public String getPushTalkSmsFlag() { return pushTalkSmsFlag; }
    public void setPushTalkSmsFlag(String pushTalkSmsFlag) { this.pushTalkSmsFlag = pushTalkSmsFlag; }

    public String getShrtntAlimRcvyn() { return shrtntAlimRcvyn; }
    public void setShrtntAlimRcvyn(String shrtntAlimRcvyn) { this.shrtntAlimRcvyn = shrtntAlimRcvyn; }

    public String getEmlAlimRcvyn() { return emlAlimRcvyn; }
    public void setEmlAlimRcvyn(String emlAlimRcvyn) { this.emlAlimRcvyn = emlAlimRcvyn; }

    public String getUseEmlGbncd() { return useEmlGbncd; }
    public void setUseEmlGbncd(String useEmlGbncd) { this.useEmlGbncd = useEmlGbncd; }

    public String getUserNcnm() { return userNcnm; }
    public void setUserNcnm(String userNcnm) { this.userNcnm = userNcnm; }

    public String getStdntNo() { return stdntNo; }
    public void setStdntNo(String stdntNo) { this.stdntNo = stdntNo; }

    public String getDsblyn() { return dsblyn; }
    public void setDsblyn(String dsblyn) { this.dsblyn = dsblyn; }
    
    public String	toString() {
    	return "userId =" + userId + ", userRprsId=" + userRprsId;
    }
}