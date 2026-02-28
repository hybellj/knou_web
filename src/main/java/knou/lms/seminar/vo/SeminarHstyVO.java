package knou.lms.seminar.vo;

import knou.lms.common.vo.DefaultVO;

public class SeminarHstyVO extends DefaultVO {

    private static final long serialVersionUID = 8987534977453878734L;
    /** tb_lms_seminar_hsty */
    private String  seminarHstyId;      // 세미나 참석 기록 고유번호
    private String  seminarId;          // 세미나 고유번호
    private String  stdNo;              // 수강생 번호
    private String  atndDttm;           // 참석 일시
    private String  deviceTypeCd;       // 접속 환경 코드
    private String  userId;             // 사용자 번호
    private String  regIp;              // 참석자 IP
    
    private String  tcEmail;
    
    public String getSeminarHstyId() {
        return seminarHstyId;
    }
    public void setSeminarHstyId(String seminarHstyId) {
        this.seminarHstyId = seminarHstyId;
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
    public String getAtndDttm() {
        return atndDttm;
    }
    public void setAtndDttm(String atndDttm) {
        this.atndDttm = atndDttm;
    }
    public String getDeviceTypeCd() {
        return deviceTypeCd;
    }
    public void setDeviceTypeCd(String deviceTypeCd) {
        this.deviceTypeCd = deviceTypeCd;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getRegIp() {
        return regIp;
    }
    public void setRegIp(String regIp) {
        this.regIp = regIp;
    }
    public String getTcEmail() {
        return tcEmail;
    }
    public void setTcEmail(String tcEmail) {
        this.tcEmail = tcEmail;
    }

}
