package knou.lms.user.vo;

public class UserMgrVO {

    private String menuId;          // 메뉴 ID
    private String orgId;           // 기관 ID (ORG_ID)
    private String orgnm;           // 기관명 (ORGNM)
    private String userId;          // 아이디 (USER_ID)
    private String stdntNo;         // 학번/사번 (STDNT_NO)
    private String usernm;          // 이름 (USERNM)
    private String mobileNo;        // 휴대폰번호 (TB_LMS_USER_CNTCT, CNTCT_TYCD='MBL_PHN')
    private String email;           // 개인 이메일 (TB_LMS_USER_CNTCT, CNTCT_TYCD='INDV_EML')
    private String emailDomain;     // 이메일 도메인 (화면 입력 분리용)
    private String userIdEncpswd;   // 비밀번호 (폼 입력 평문 → Facade에서 SHA 암호화 후 저장)
    private String authrtGrpcd;     // 관리자 구분 (권한그룹코드)
    private String authrtGrpnm;     // 관리자 구분명
    private String userAuthrtId;    // 사용자권한 ID (USER_AUTHRT_ID, PK) - 권한 insert용
    private String authrtId;        // 권한 ID (AUTHRT_ID) - 관리자구분 선택값
    private String userTyAuthrtId;  // 사용자구분 권한 ID (AUTHRT_ID) - 등록 시 사용자구분 권한 등록용
    private String userTycd;        // 사용자 구분 코드 (USER_TYCD)
    private String userTynm;        // 사용자 구분명
    private String userStscd;       // 사용자 상태 코드 (USER_STSCD)
    private String userStsnm;       // 사용자 상태명
    private String acRcdTycd;       // 학적유형코드 (AC_RCD_TYCD) - 학적 상태
    private String dsblTycd;        // 장애 유형 코드 (DSBL_TYCD)
    private String dsblGrdcd;       // 장애 등급 코드 (DSBL_GRDCD)
    private String snryn;           // 고령자 유무 (SNRYN, Y/N)
    private String dsblyn;          // 장애 여부 (DSBLYN, Y/N)
    private String photoFileId;     // 프로필사진 파일 ID (PHOTO_FILE_ID)
    private String uploadFiles;     // 업로드 파일 정보(JSON) - 프로필 사진 첨부
    private String uploadPath;      // 업로드 경로
    private String rgtrId;          // 등록자 ID
    private String mdfrId;          // 수정자 ID

    private String cntnIp;          // 접속 IP (변경이력용)
    private String cntnBrwsr;       // 접속 브라우저 (변경이력용)
    private String cntnDvcTycd;     // 접속 기기유형코드 (변경이력용)

    public String getCntnIp() {
        return cntnIp;
    }

    public void setCntnIp(String cntnIp) {
        this.cntnIp = cntnIp;
    }

    public String getCntnBrwsr() {
        return cntnBrwsr;
    }

    public void setCntnBrwsr(String cntnBrwsr) {
        this.cntnBrwsr = cntnBrwsr;
    }

    public String getCntnDvcTycd() {
        return cntnDvcTycd;
    }

    public void setCntnDvcTycd(String cntnDvcTycd) {
        this.cntnDvcTycd = cntnDvcTycd;
    }

    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getOrgnm() {
        return orgnm;
    }

    public void setOrgnm(String orgnm) {
        this.orgnm = orgnm;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getStdntNo() {
        return stdntNo;
    }

    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }

    public String getUsernm() {
        return usernm;
    }

    public void setUsernm(String usernm) {
        this.usernm = usernm;
    }

    public String getMobileNo() {
        return mobileNo;
    }

    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmailDomain() {
        return emailDomain;
    }

    public void setEmailDomain(String emailDomain) {
        this.emailDomain = emailDomain;
    }

    public String getUserIdEncpswd() {
        return userIdEncpswd;
    }

    public void setUserIdEncpswd(String userIdEncpswd) {
        this.userIdEncpswd = userIdEncpswd;
    }

    public String getAuthrtGrpcd() {
        return authrtGrpcd;
    }

    public void setAuthrtGrpcd(String authrtGrpcd) {
        this.authrtGrpcd = authrtGrpcd;
    }

    public String getAuthrtGrpnm() {
        return authrtGrpnm;
    }

    public void setAuthrtGrpnm(String authrtGrpnm) {
        this.authrtGrpnm = authrtGrpnm;
    }

    public String getUserAuthrtId() {
        return userAuthrtId;
    }

    public void setUserAuthrtId(String userAuthrtId) {
        this.userAuthrtId = userAuthrtId;
    }

    public String getAuthrtId() {
        return authrtId;
    }

    public void setAuthrtId(String authrtId) {
        this.authrtId = authrtId;
    }

    public String getUserTyAuthrtId() {
        return userTyAuthrtId;
    }

    public void setUserTyAuthrtId(String userTyAuthrtId) {
        this.userTyAuthrtId = userTyAuthrtId;
    }

    public String getUserTycd() {
        return userTycd;
    }

    public void setUserTycd(String userTycd) {
        this.userTycd = userTycd;
    }

    public String getUserTynm() {
        return userTynm;
    }

    public void setUserTynm(String userTynm) {
        this.userTynm = userTynm;
    }

    public String getUserStscd() {
        return userStscd;
    }

    public void setUserStscd(String userStscd) {
        this.userStscd = userStscd;
    }

    public String getUserStsnm() {
        return userStsnm;
    }

    public void setUserStsnm(String userStsnm) {
        this.userStsnm = userStsnm;
    }

    public String getAcRcdTycd() {
        return acRcdTycd;
    }

    public void setAcRcdTycd(String acRcdTycd) {
        this.acRcdTycd = acRcdTycd;
    }

    public String getDsblTycd() {
        return dsblTycd;
    }

    public void setDsblTycd(String dsblTycd) {
        this.dsblTycd = dsblTycd;
    }

    public String getDsblGrdcd() {
        return dsblGrdcd;
    }

    public void setDsblGrdcd(String dsblGrdcd) {
        this.dsblGrdcd = dsblGrdcd;
    }

    public String getSnryn() {
        return snryn;
    }

    public void setSnryn(String snryn) {
        this.snryn = snryn;
    }

    public String getDsblyn() {
        return dsblyn;
    }

    public void setDsblyn(String dsblyn) {
        this.dsblyn = dsblyn;
    }

    public String getPhotoFileId() {
        return photoFileId;
    }

    public void setPhotoFileId(String photoFileId) {
        this.photoFileId = photoFileId;
    }

    public String getUploadFiles() {
        return uploadFiles;
    }

    public void setUploadFiles(String uploadFiles) {
        this.uploadFiles = uploadFiles;
    }

    public String getUploadPath() {
        return uploadPath;
    }

    public void setUploadPath(String uploadPath) {
        this.uploadPath = uploadPath;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }
}
