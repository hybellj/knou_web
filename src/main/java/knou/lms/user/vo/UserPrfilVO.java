package knou.lms.user.vo;

import knou.lms.common.vo.DefaultVO;

import java.util.List;

public class UserPrfilVO extends DefaultVO {

    /* ================= USER ================= */

    private String usernm;            // 사용자명
    private String photoFileId;       // 프로필사진파일ID
    private String deptId;            // 학과/부서아이디
    private String shrtntAlimRcvyn;   // 쪽지수신여부
    private String emlAlimRcvyn;      // 이메일알림수신여부
    private String pushTalkSmsFlag;     // 푸시톡문자수신플래그
    private String pushRcvyn;         // 푸시알림수신여부
    private String alimTalkRcvyn;   // 알림톡수신여부
    private String smsRcvyn;        // 문자수신여부
    private String stdntNo;     // 학번/교번
    private String userNcnm;     // 사용자별칭
    private String useEmlGbncd;     // 사용이메일구분코드
    private String gndrTycd;     // 성별유형코드
    private String gndrTynm;     // 성별유형명
    private String userIdEncpswd;     // 사용자아이디암호화비밀번호



    /* ================= CONTACT ================= */

    private String userCntctId;       // 사용자연락처아이디
    private String cntctTycd;         // 연락처유형코드 (HP, EMAIL)
    private String cntct;             // 연락처값 (전화번호, 이메일)
    private String mblPhn;          // 모바일전화
    private String lnkgEml;               // 연계이메일
    private String indvEml;               // 개인이메일



    /* ================= SNS ================= */

    private String snsTycd;           // SNS유형코드 (NAVER 등)
    private String snsNm;             // SNS명

    /* ================= 로직/쿼리용 ================= */
    private String pswdMtchyn;   // 패스워드일치여부
    private List<String> orgIdList;   // 기관아이디목록
    private List<String> authrtIdList;  // 권한아이디목록
    private String photoFileDelyn;  // 사진파일삭제여부

    /* ================= 임시 ================= */
    private String orgnm;
    private String userAuthrtId;    // 사용자권한아이디
    private String authrtId;    // 권한아이디

    public String getUsernm() {
        return usernm;
    }

    public void setUsernm(String usernm) {
        this.usernm = usernm;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getPhotoFileId() {
        return photoFileId;
    }

    public void setPhotoFileId(String photoFileId) {
        this.photoFileId = photoFileId;
    }

    public String getShrtntAlimRcvyn() {
        return shrtntAlimRcvyn;
    }

    public void setShrtntAlimRcvyn(String shrtntAlimRcvyn) {
        this.shrtntAlimRcvyn = shrtntAlimRcvyn;
    }

    public String getEmlAlimRcvyn() {
        return emlAlimRcvyn;
    }

    public void setEmlAlimRcvyn(String emlAlimRcvyn) {
        this.emlAlimRcvyn = emlAlimRcvyn;
    }

    public String getUserCntctId() {
        return userCntctId;
    }

    public void setUserCntctId(String userCntctId) {
        this.userCntctId = userCntctId;
    }

    public String getCntctTycd() {
        return cntctTycd;
    }

    public void setCntctTycd(String cntctTycd) {
        this.cntctTycd = cntctTycd;
    }

    public String getCntct() {
        return cntct;
    }

    public void setCntct(String cntct) {
        this.cntct = cntct;
    }

    public String getSnsTycd() {
        return snsTycd;
    }

    public void setSnsTycd(String snsTycd) {
        this.snsTycd = snsTycd;
    }

    public String getSnsNm() {
        return snsNm;
    }

    public void setSnsNm(String snsNm) {
        this.snsNm = snsNm;
    }

    public String getPushRcvyn() {
        return pushRcvyn;
    }

    public void setPushRcvyn(String pushRcvyn) {
        this.pushRcvyn = pushRcvyn;
    }

    public String getAlimTalkRcvyn() {
        return alimTalkRcvyn;
    }

    public void setAlimTalkRcvyn(String alimTalkRcvyn) {
        this.alimTalkRcvyn = alimTalkRcvyn;
    }

    public String getSmsRcvyn() {
        return smsRcvyn;
    }

    public void setSmsRcvyn(String smsRcvyn) {
        this.smsRcvyn = smsRcvyn;
    }

    public String getStdntNo() {
        return stdntNo;
    }

    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }

    public String getUserNcnm() {
        return userNcnm;
    }

    public void setUserNcnm(String userNcnm) {
        this.userNcnm = userNcnm;
    }

    public String getUseEmlGbncd() {
        return useEmlGbncd;
    }

    public void setUseEmlGbncd(String useEmlGbncd) {
        this.useEmlGbncd = useEmlGbncd;
    }

    public String getMblPhn() {
        return mblPhn;
    }

    public void setMblPhn(String mblPhn) {
        this.mblPhn = mblPhn;
    }

    public String getLnkgEml() {
        return lnkgEml;
    }

    public void setLnkgEml(String lnkgEml) {
        this.lnkgEml = lnkgEml;
    }

    public String getIndvEml() {
        return indvEml;
    }

    public void setIndvEml(String indvEml) {
        this.indvEml = indvEml;
    }

    public String getPushTalkSmsFlag() {
        return pushTalkSmsFlag;
    }

    public void setPushTalkSmsFlag(String pushTalkSmsFlag) {
        this.pushTalkSmsFlag = pushTalkSmsFlag;
    }


    public String getOrgnm() {
        return orgnm;
    }

    public void setOrgnm(String orgnm) {
        this.orgnm = orgnm;
    }

    public String getGndrTycd() {
        return gndrTycd;
    }

    public void setGndrTycd(String gndrTycd) {
        this.gndrTycd = gndrTycd;
    }

    public String getGndrTynm() {
        return gndrTynm;
    }

    public void setGndrTynm(String gndrTynm) {
        this.gndrTynm = gndrTynm;
    }

    public String getUserIdEncpswd() {
        return userIdEncpswd;
    }

    public void setUserIdEncpswd(String userIdEncpswd) {
        this.userIdEncpswd = userIdEncpswd;
    }

    public String getPswdMtchyn() {
        return pswdMtchyn;
    }

    public void setPswdMtchyn(String pswdMtchyn) {
        this.pswdMtchyn = pswdMtchyn;
    }

    public List<String> getOrgIdList() {
        return orgIdList;
    }

    public void setOrgIdList(List<String> orgIdList) {
        this.orgIdList = orgIdList;
    }

    public String getUserAuthrtId() {
        return userAuthrtId;
    }

    public void setUserAuthrtId(String userAuthrtId) {
        this.userAuthrtId = userAuthrtId;
    }

    public List<String> getAuthrtIdList() {
        return authrtIdList;
    }

    public void setAuthrtIdList(List<String> authrtIdList) {
        this.authrtIdList = authrtIdList;
    }

    public String getAuthrtId() {
        return authrtId;
    }

    public void setAuthrtId(String authrtId) {
        this.authrtId = authrtId;
    }

    public String getPhotoFileDelyn() {
        return photoFileDelyn;
    }

    public void setPhotoFileDelyn(String photoFileDelyn) {
        this.photoFileDelyn = photoFileDelyn;
    }
}



