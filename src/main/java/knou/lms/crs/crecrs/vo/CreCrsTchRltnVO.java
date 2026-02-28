package knou.lms.crs.crecrs.vo;

import knou.lms.common.vo.DefaultVO;

public class CreCrsTchRltnVO extends DefaultVO {

    /** tb_lms_cre_crs_tch_rltn */
    private String  crsCreCd;       // 과정 개설 코드
    private String  userId;         // 사용자 번호
    private String  tchType;        // 강사 유형
    private String  repYn;          // 대표교수 여부(Y/N)
    private String  haksaYn;        // 학사데이터여부(Y/N)
    
    private String  userNm;         // 사용자 이름
    private String  email;          // 이메일
    private String  mobileNo;       // 연락처
    private Integer photoFileSn;    // 이미지 파일 번호
    private String  menuType;       // 메뉴 유형
    private String  deptNm;         // 학과명
    private String  encFileSn;      // 암호화 파일 번호
    private String  phtFile;
    private byte[] phtFileByte;
    private String  ofceTelNo;
    
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getTchType() {
        return tchType;
    }
    public void setTchType(String tchType) {
        this.tchType = tchType;
    }
    public String getRepYn() {
        return repYn;
    }
    public void setRepYn(String repYn) {
        this.repYn = repYn;
    }
    public String getHaksaYn() {
        return haksaYn;
    }
    public void setHaksaYn(String haksaYn) {
        this.haksaYn = haksaYn;
    }
    public String getUserNm() {
        return userNm;
    }
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }
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
    public Integer getPhotoFileSn() {
        return photoFileSn;
    }
    public void setPhotoFileSn(Integer photoFileSn) {
        this.photoFileSn = photoFileSn;
    }
    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
    public String getEncFileSn() {
        return encFileSn;
    }
    public void setEncFileSn(String encFileSn) {
        this.encFileSn = encFileSn;
    }
    public String getPhtFile() {
        return phtFile;
    }
    public void setPhtFile(String phtFile) {
        this.phtFile = phtFile;
    }
    public byte[] getPhtFileByte() {
        return phtFileByte;
    }
    public void setPhtFileByte(byte[] phtFileByte) {
        this.phtFileByte = phtFileByte;
    }
    public String getOfceTelNo() {
        return ofceTelNo;
    }
    public void setOfceTelNo(String ofceTelNo) {
        this.ofceTelNo = ofceTelNo;
    }
    
}
