package knou.lms.seminar.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class SeminarAtndVO extends DefaultVO {

    private static final long serialVersionUID = 7707104363263796441L;
    /** tb_lms_seminar_atnd */
    private String  seminarAtndId;      // 세미나 참석 고유번호
    private String  seminarId;          // 세미나 고유번호
    private String  stdNo;              // 수강생 번호
    private String  userId;             // 사용자 번호
    private String  atndDttm;           // 참석 일시
    private Integer atndTime;           // 참석 시간
    private String  atndCd;             // 참석 상태 코드
    private String  deviceTypeCd;       // 접속 환경 코드
    private String  atndMemo;           // 메모내용
    private String  regIp;              // 참석자 IP
    
    private String  userNm;             // 사용자명
    private String  deptNm;             // 학과명
    private String  seminarStatus;      // 세미나 오픈 상태
    private String  seminarTime;        // 세미나 학습시간
    
    private List<String> attendStdList; // 출결 변경용 리스트
    private String  tcEmail;
    private String  mobileNo;
    private String  email;
    
    private String  entrYy;
    private String  entrHy;
    private String  entrGbnNm;
    private String  grscDegrCorsGbn;
    private String  grscDegrCorsGbnNm;

    public String getSeminarAtndId() {
        return seminarAtndId;
    }
    public void setSeminarAtndId(String seminarAtndId) {
        this.seminarAtndId = seminarAtndId;
    }
    public String getSeminarId() {
        return seminarId;
    }
    public void setSeminarId(String seminarId) {
        this.seminarId = seminarId;
    }
    public String getStdNo() {
        return stdNo;
    }
    public void setStdNo(String stdNo) {
        this.stdNo = stdNo;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getAtndDttm() {
        return atndDttm;
    }
    public void setAtndDttm(String atndDttm) {
        this.atndDttm = atndDttm;
    }
    public Integer getAtndTime() {
        return atndTime;
    }
    public void setAtndTime(Integer atndTime) {
        this.atndTime = atndTime;
    }
    public String getAtndCd() {
        return atndCd;
    }
    public void setAtndCd(String atndCd) {
        this.atndCd = atndCd;
    }
    public String getDeviceTypeCd() {
        return deviceTypeCd;
    }
    public void setDeviceTypeCd(String deviceTypeCd) {
        this.deviceTypeCd = deviceTypeCd;
    }
    public String getRegIp() {
        return regIp;
    }
    public void setRegIp(String regIp) {
        this.regIp = regIp;
    }
    public String getUserNm() {
        return userNm;
    }
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }
    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
    public String getSeminarStatus() {
        return seminarStatus;
    }
    public void setSeminarStatus(String seminarStatus) {
        this.seminarStatus = seminarStatus;
    }
    public String getSeminarTime() {
        return seminarTime;
    }
    public void setSeminarTime(String seminarTime) {
        this.seminarTime = seminarTime;
    }
    public List<String> getAttendStdList() {
        return attendStdList;
    }
    public void setAttendStdList(List<String> attendStdList) {
        this.attendStdList = attendStdList;
    }
    public String getTcEmail() {
        return tcEmail;
    }
    public void setTcEmail(String tcEmail) {
        this.tcEmail = tcEmail;
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
    public String getEntrGbnNm() {
        return entrGbnNm;
    }
    public void setEntrGbnNm(String entrGbnNm) {
        this.entrGbnNm = entrGbnNm;
    }
    public String getAtndMemo() {
        return atndMemo;
    }
    public void setAtndMemo(String atndMemo) {
        this.atndMemo = atndMemo;
    }
    public String getGrscDegrCorsGbn() {
        return grscDegrCorsGbn;
    }
    public void setGrscDegrCorsGbn(String grscDegrCorsGbn) {
        this.grscDegrCorsGbn = grscDegrCorsGbn;
    }
    public String getGrscDegrCorsGbnNm() {
        return grscDegrCorsGbnNm;
    }
    public void setGrscDegrCorsGbnNm(String grscDegrCorsGbnNm) {
        this.grscDegrCorsGbnNm = grscDegrCorsGbnNm;
    }

}
