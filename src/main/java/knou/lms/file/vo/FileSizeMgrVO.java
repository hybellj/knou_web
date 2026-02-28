package knou.lms.file.vo;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

@Alias("fileSizeMgrVO")
public class FileSizeMgrVO extends DefaultVO {

    private static final long serialVersionUID = -484409939756667137L;

    private String selectedAthGrpCd;
    private String selectedUserId;
    private String userOrgId;
    private String langCd;
    
    // 권한그룹 목록 결과
    private String  authGrpCd; 
    private String  authGrpNm;
    private Integer fileSize;
    private String  fileSizeFormatted;

    // 사용자별 용량 관리 목록 결과
    private Integer rowNum;
    private String  deptCd;
    private String  deptNm;
    private String  userId;
    private String  userNm;
    private String  userSts;
    private String  userStsNm;
    private String  orgId;
    private String  email;
    private String  totalCnt;
    
    /** @return selectedAthGrpCd 값을 반환한다. */
    public String getSelectedAthGrpCd() {
        return selectedAthGrpCd;
    }

    /**
     * @param selectedAthGrpCd
     *            을 selectedAthGrpCd 에 저장한다.
     */
    public void setSelectedAthGrpCd(String selectedAthGrpCd) {
        this.selectedAthGrpCd = selectedAthGrpCd;
    }

    /** @return selectedUserId 값을 반환한다. */
    public String getSelectedUserId() {
        return selectedUserId;
    }

    /**
     * @param selectedUserId을 selectedUserId 에 저장한다.
     */
    public void setSelectedUserId(String selectedUserId) {
        this.selectedUserId = selectedUserId;
    }

    /** @return authGrpCd 값을 반환한다. */
    public String getAuthGrpCd() {
        return authGrpCd;
    }

    /**
     * @param authGrpCd을 authGrpCd 에 저장한다.
     */
    public void setAuthGrpCd(String authGrpCd) {
        this.authGrpCd = authGrpCd;
    }

    /** @return authGrpNm 값을 반환한다. */
    public String getAuthGrpNm() {
        return authGrpNm;
    }

    /**
     * @param authGrpNm을 authGrpNm 에 저장한다.
     */
    public void setAuthGrpNm(String authGrpNm) {
        this.authGrpNm = authGrpNm;
    }

    /** @return fileSize 값을 반환한다. */
    public Integer getFileSize() {
        return fileSize;
    }

    /**
     * @param fileSize을 fileSize 에 저장한다.
     */
    public void setFileSize(Integer fileSize) {
        this.fileSize = fileSize;
    }

    /** @return fileSizeFormatted 값을 반환한다. */
    public String getFileSizeFormatted() {
        return fileSizeFormatted;
    }

    /**
     * @param fileSizeFormatted을 fileSizeFormatted 에 저장한다.
     */
    public void setFileSizeFormatted(String fileSizeFormatted) {
        this.fileSizeFormatted = fileSizeFormatted;
    }

    /** @return rowNum 값을 반환한다. */
    public Integer getRowNum() {
        return rowNum;
    }

    /**
     * @param rowNum을 rowNum 에 저장한다.
     */
    public void setRowNum(Integer rowNum) {
        this.rowNum = rowNum;
    }

    /** @return deptId 값을 반환한다. */
    public String getDeptCd() {
        return deptCd;
    }

    /**
     * @param deptCd을 deptId 에 저장한다.
     */
    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }

    /** @return deptNm 값을 반환한다. */
    public String getDeptNm() {
        return deptNm;
    }

    /**
     * @param deptNm을 deptNm 에 저장한다.
     */
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    /** @return userId 값을 반환한다. */
    public String getUserId() {
        return userId;
    }

    /**
     * @param userId을 userId 에 저장한다.
     */
    public void setUserId(String userId) {
        this.userId = userId;
    }

    /** @return userNm 값을 반환한다. */
    public String getUserNm() {
        return userNm;
    }

    /**
     * @param userNm을 userNm 에 저장한다.
     */
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    /** @return userSts 값을 반환한다. */
    public String getUserSts() {
        return userSts;
    }

    /**
     * @param userSts을 userSts 에 저장한다.
     */
    public void setUserSts(String userSts) {
        this.userSts = userSts;
    }

    /** @return userStsNm 값을 반환한다. */
    public String getUserStsNm() {
        return userStsNm;
    }

    /**
     * @param userStsNm을 userStsNm 에 저장한다.
     */
    public void setUserStsNm(String userStsNm) {
        this.userStsNm = userStsNm;
    }

    /** @return orgId 값을 반환한다. */
    public String getOrgId() {
        return orgId;
    }

    /**
     * @param orgId을 orgId 에 저장한다.
     */
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    /** @return email 값을 반환한다. */
    public String getEmail() {
        return email;
    }

    /**
     * @param email을 email 에 저장한다.
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /** @return userOrgId 값을 반환한다. */
    public String getUserOrgId() {
        return userOrgId;
    }

    /**
     * @param userOrgId을 userOrgId 에 저장한다.
     */
    public void setUserOrgId(String userOrgId) {
        this.userOrgId = userOrgId;
    }

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }
    
}
