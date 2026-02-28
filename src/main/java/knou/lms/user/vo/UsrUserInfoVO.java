package knou.lms.user.vo;

import java.util.Date;

public class UsrUserInfoVO extends UsrLoginVO {
    private static final long serialVersionUID = 7274370578132144752L;

    private String email; 
    private String mobileNo; 
    private String emailStr;
    private String disablilityExamYn;
    private String hy; // 학년

    private String userStsNm;
    private Date hakModifyAt;
    private String disablilityLv;
    private String disablilityCd;
    private String userTypeDetail;
    
    private String  profAuthGrpCd;
    
    private Integer photoFileSn;
    private String  dupInfo;
    private String  deptNm;
    private String  deptCd;
    private String  deptId;
    private String  orgNm;
    private String  tchSbj;
    
    private String  menuTypes;
    private String[] menuTypeList;
    
    private String  searchAuthGrp;
    private String  searchUserStatus;

    private String  checkCertiYn = "N";
    private String  checkAgree = "N";

    private String  emailRecv;
    private String  smsRecv;
    private String  msgRecv;
    private String  tempYn = "N";

    private String	tchCtgrCd;
    private String	tchDivCd;
    private String  lineExcelNo;
    private String  errorCode;

    private String  userEnnm;
    private String  disablilityYn;
    private String  disabilityDttm;
    private String  disabilityCancelGbn;
    private String  memo;
    private String  disabilityLv;
    private String  disabilityCd;

    private String  usrKnowCtgrCds; //나의 관심분야(str)
    private String  usrKnowKeywords; //나의 관심검색어(str)
    private String  usrKnowCtgrNames; //나의 관심분야 이름(str)
    private String  itgrtMbrUseYn; //통합로그인
    private String  rtnJson; //통합로그인 json 데이타
    
    private String userName;
    private String userGrade;
    private String photoFileId;
    private byte[] phtFileByte;
    private String phtFileDelYn;
    private String entrYy;
    private String entrHy;
    private String readmiYy;
    private String entrGbn;
    private String entrGbnNm;

    //과정
    private String  crsCreCd;               /*과정 개설 코드*/
    private Integer declsNo;                /*분반*/
    private String gubun;
    
    private String userIds;
    private String userConf;    // 사용자환경설정
    
    // zoom 컬럼
    private String tcId;        // 토큰 아이디
    private String tcPw;        // 토큰 비밀번호
    private String tcEmail;     // 토큰 이메일
    private String tcRole;      // 토큰 권한
    private String accessToken;
    
    private String uniCd;
    private String schregGbn;
    private String schregGbnCd;
    private String stdDetaGbn;
    private String mstYn;
    private String subDisabilityLv;
    private String subDisabilityCd;
    private String ofceTelno;
    private String status;
    private String hycuUserId;
    private String hycuUserNm;
    private String orgKnouRltn = "N";
    
    private String userId;
    
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getMobileNo() {
		return mobileNo;
	}
	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}
	public String getEmailStr() {
		return emailStr;
	}
	public void setEmailStr(String emailStr) {
		this.emailStr = emailStr;
	}
	public String getDisablilityExamYn() {
		return disablilityExamYn;
	}
	public void setDisablilityExamYn(String disablilityExamYn) {
		this.disablilityExamYn = disablilityExamYn;
	}
	public String getHy() {
		return hy;
	}
	public void setHy(String hy) {
		this.hy = hy;
	}
	public String getUserStsNm() {
		return userStsNm;
	}
	public void setUserStsNm(String userStsNm) {
		this.userStsNm = userStsNm;
	}
	public Date getHakModifyAt() {
		return hakModifyAt;
	}
	public void setHakModifyAt(Date hakModifyAt) {
		this.hakModifyAt = hakModifyAt;
	}
	public String getDisablilityLv() {
		return disablilityLv;
	}
	public void setDisablilityLv(String disablilityLv) {
		this.disablilityLv = disablilityLv;
	}
	public String getDisablilityCd() {
		return disablilityCd;
	}
	public void setDisablilityCd(String disablilityCd) {
		this.disablilityCd = disablilityCd;
	}
	public String getUserTypeDetail() {
		return userTypeDetail;
	}
	public void setUserTypeDetail(String userTypeDetail) {
		this.userTypeDetail = userTypeDetail;
	}
	public String getProfAuthGrpCd() {
		return profAuthGrpCd;
	}
	public void setProfAuthGrpCd(String profAuthGrpCd) {
		this.profAuthGrpCd = profAuthGrpCd;
	}
	public Integer getPhotoFileSn() {
		return photoFileSn;
	}
	public void setPhotoFileSn(Integer photoFileSn) {
		this.photoFileSn = photoFileSn;
	}
	public String getDupInfo() {
		return dupInfo;
	}
	public void setDupInfo(String dupInfo) {
		this.dupInfo = dupInfo;
	}
	public String getDeptNm() {
		return deptNm;
	}
	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}
	public String getDeptCd() {
		return deptCd;
	}
	public void setDeptCd(String deptCd) {
		this.deptCd = deptCd;
	}
    public String getDeptId(){ return deptId;}
    public void setDeptId(String deptId){ this.deptId = deptId;}

	public String getOrgNm() {
		return orgNm;
	}
	public void setOrgNm(String orgNm) {
		this.orgNm = orgNm;
	}
	public String getTchSbj() {
		return tchSbj;
	}
	public void setTchSbj(String tchSbj) {
		this.tchSbj = tchSbj;
	}
	public String getMenuTypes() {
		return menuTypes;
	}
	public void setMenuTypes(String menuTypes) {
		this.menuTypes = menuTypes;
	}
	public String[] getMenuTypeList() {
		return menuTypeList;
	}
	public void setMenuTypeList(String[] menuTypeList) {
		this.menuTypeList = menuTypeList;
	}
	public String getSearchAuthGrp() {
		return searchAuthGrp;
	}
	public void setSearchAuthGrp(String searchAuthGrp) {
		this.searchAuthGrp = searchAuthGrp;
	}
	public String getSearchUserStatus() {
		return searchUserStatus;
	}
	public void setSearchUserStatus(String searchUserStatus) {
		this.searchUserStatus = searchUserStatus;
	}
	public String getCheckCertiYn() {
		return checkCertiYn;
	}
	public void setCheckCertiYn(String checkCertiYn) {
		this.checkCertiYn = checkCertiYn;
	}
	public String getCheckAgree() {
		return checkAgree;
	}
	public void setCheckAgree(String checkAgree) {
		this.checkAgree = checkAgree;
	}
	public String getEmailRecv() {
		return emailRecv;
	}
	public void setEmailRecv(String emailRecv) {
		this.emailRecv = emailRecv;
	}
	public String getSmsRecv() {
		return smsRecv;
	}
	public void setSmsRecv(String smsRecv) {
		this.smsRecv = smsRecv;
	}
	public String getMsgRecv() {
		return msgRecv;
	}
	public void setMsgRecv(String msgRecv) {
		this.msgRecv = msgRecv;
	}
	public String getTempYn() {
		return tempYn;
	}
	public void setTempYn(String tempYn) {
		this.tempYn = tempYn;
	}
	public String getTchCtgrCd() {
		return tchCtgrCd;
	}
	public void setTchCtgrCd(String tchCtgrCd) {
		this.tchCtgrCd = tchCtgrCd;
	}
	public String getTchDivCd() {
		return tchDivCd;
	}
	public void setTchDivCd(String tchDivCd) {
		this.tchDivCd = tchDivCd;
	}
	public String getLineExcelNo() {
		return lineExcelNo;
	}
	public void setLineExcelNo(String lineExcelNo) {
		this.lineExcelNo = lineExcelNo;
	}
	public String getErrorCode() {
		return errorCode;
	}
	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}
	public String getUserEnnm() {
		return userEnnm;
	}
	public void setUserEnnm(String userEnnm) {
		this.userEnnm = userEnnm;
	}
	public String getDisablilityYn() {
		return disablilityYn;
	}
	public void setDisablilityYn(String disablilityYn) {
		this.disablilityYn = disablilityYn;
	}
	public String getDisabilityDttm() {
		return disabilityDttm;
	}
	public void setDisabilityDttm(String disabilityDttm) {
		this.disabilityDttm = disabilityDttm;
	}
	public String getDisabilityCancelGbn() {
		return disabilityCancelGbn;
	}
	public void setDisabilityCancelGbn(String disabilityCancelGbn) {
		this.disabilityCancelGbn = disabilityCancelGbn;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public String getDisabilityLv() {
		return disabilityLv;
	}
	public void setDisabilityLv(String disabilityLv) {
		this.disabilityLv = disabilityLv;
	}
	public String getDisabilityCd() {
		return disabilityCd;
	}
	public void setDisabilityCd(String disabilityCd) {
		this.disabilityCd = disabilityCd;
	}
	public String getUsrKnowCtgrCds() {
		return usrKnowCtgrCds;
	}
	public void setUsrKnowCtgrCds(String usrKnowCtgrCds) {
		this.usrKnowCtgrCds = usrKnowCtgrCds;
	}
	public String getUsrKnowKeywords() {
		return usrKnowKeywords;
	}
	public void setUsrKnowKeywords(String usrKnowKeywords) {
		this.usrKnowKeywords = usrKnowKeywords;
	}
	public String getUsrKnowCtgrNames() {
		return usrKnowCtgrNames;
	}
	public void setUsrKnowCtgrNames(String usrKnowCtgrNames) {
		this.usrKnowCtgrNames = usrKnowCtgrNames;
	}
	public String getItgrtMbrUseYn() {
		return itgrtMbrUseYn;
	}
	public void setItgrtMbrUseYn(String itgrtMbrUseYn) {
		this.itgrtMbrUseYn = itgrtMbrUseYn;
	}
	public String getRtnJson() {
		return rtnJson;
	}
	public void setRtnJson(String rtnJson) {
		this.rtnJson = rtnJson;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserGrade() {
		return userGrade;
	}
	public void setUserGrade(String userGrade) {
		this.userGrade = userGrade;
	}
	public String getPhotoFileId() {
		return photoFileId;
	}
	public void setPhotoFileId(String phtFile) {
		this.photoFileId = phtFile;
	}
	public byte[] getPhtFileByte() {
		return phtFileByte;
	}
	public void setPhtFileByte(byte[] phtFileByte) {
		this.phtFileByte = phtFileByte;
	}
	public String getPhtFileDelYn() {
		return phtFileDelYn;
	}
	public void setPhtFileDelYn(String phtFileDelYn) {
		this.phtFileDelYn = phtFileDelYn;
	}
	public String getEntrYy() {
		return entrYy;
	}
	public void setEntrYy(String entrYy) {
		this.entrYy = entrYy;
	}
	public String getEntrHy() {
		return entrHy;
	}
	public void setEntrHy(String entrHy) {
		this.entrHy = entrHy;
	}
	public String getReadmiYy() {
		return readmiYy;
	}
	public void setReadmiYy(String readmiYy) {
		this.readmiYy = readmiYy;
	}
	public String getEntrGbn() {
		return entrGbn;
	}
	public void setEntrGbn(String entrGbn) {
		this.entrGbn = entrGbn;
	}
	public String getEntrGbnNm() {
		return entrGbnNm;
	}
	public void setEntrGbnNm(String entrGbnNm) {
		this.entrGbnNm = entrGbnNm;
	}
	public String getCrsCreCd() {
		return crsCreCd;
	}
	public void setCrsCreCd(String crsCreCd) {
		this.crsCreCd = crsCreCd;
	}
	public Integer getDeclsNo() {
		return declsNo;
	}
	public void setDeclsNo(Integer declsNo) {
		this.declsNo = declsNo;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public String getUserIds() {
		return userIds;
	}
	public void setUserIds(String userIds) {
		this.userIds = userIds;
	}
	public String getUserConf() {
		return userConf;
	}
	public void setUserConf(String userConf) {
		this.userConf = userConf;
	}
	public String getTcId() {
		return tcId;
	}
	public void setTcId(String tcId) {
		this.tcId = tcId;
	}
	public String getTcPw() {
		return tcPw;
	}
	public void setTcPw(String tcPw) {
		this.tcPw = tcPw;
	}
	public String getTcEmail() {
		return tcEmail;
	}
	public void setTcEmail(String tcEmail) {
		this.tcEmail = tcEmail;
	}
	public String getTcRole() {
		return tcRole;
	}
	public void setTcRole(String tcRole) {
		this.tcRole = tcRole;
	}
	public String getAccessToken() {
		return accessToken;
	}
	public void setAccessToken(String accessToken) {
		this.accessToken = accessToken;
	}
	public String getUniCd() {
		return uniCd;
	}
	public void setUniCd(String uniCd) {
		this.uniCd = uniCd;
	}
	public String getSchregGbn() {
		return schregGbn;
	}
	public void setSchregGbn(String schregGbn) {
		this.schregGbn = schregGbn;
	}
	public String getSchregGbnCd() {
		return schregGbnCd;
	}
	public void setSchregGbnCd(String schregGbnCd) {
		this.schregGbnCd = schregGbnCd;
	}
	public String getStdDetaGbn() {
		return stdDetaGbn;
	}
	public void setStdDetaGbn(String stdDetaGbn) {
		this.stdDetaGbn = stdDetaGbn;
	}
	public String getMstYn() {
		return mstYn;
	}
	public void setMstYn(String mstYn) {
		this.mstYn = mstYn;
	}
	public String getSubDisabilityLv() {
		return subDisabilityLv;
	}
	public void setSubDisabilityLv(String subDisabilityLv) {
		this.subDisabilityLv = subDisabilityLv;
	}
	public String getSubDisabilityCd() {
		return subDisabilityCd;
	}
	public void setSubDisabilityCd(String subDisabilityCd) {
		this.subDisabilityCd = subDisabilityCd;
	}
	public String getOfceTelno() {
		return ofceTelno;
	}
	public void setOfceTelno(String ofceTelno) {
		this.ofceTelno = ofceTelno;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getHycuUserId() {
		return hycuUserId;
	}
	public void setHycuUserId(String hycuUserId) {
		this.hycuUserId = hycuUserId;
	}
	public String getHycuUserNm() {
		return hycuUserNm;
	}
	public void setHycuUserNm(String hycuUserNm) {
		this.hycuUserNm = hycuUserNm;
	}
	public String getOrgKnouRltn() {
		return orgKnouRltn;
	}
	public void setOrgKnouRltn(String orgHycuRltn) {
		this.orgKnouRltn = orgHycuRltn;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
}
