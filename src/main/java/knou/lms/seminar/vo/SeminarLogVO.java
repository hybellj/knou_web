package knou.lms.seminar.vo;

import knou.lms.common.vo.DefaultVO;

public class SeminarLogVO extends DefaultVO {

    private static final long serialVersionUID = 54724262548337134L;
    /** tb_lms_seminar_log */
    private String  seminarLogId;       // 세미나 로그 고유번호
    private String  seminarId;          // 세미나 고유번호
    private String  stdNo;              // 수강생 번호
    private String  startDttm;          // 참석 시작 일시
    private String  endDttm;            // 참석 종료 일시
    private String  deviceTypeCd;       // 접속 환경 코드
    private Integer atndTime;           // 참여시간
    private String  atndCd;             // 참석 상태 코드
    private String  regIp;              // 참석자 IP
    
    public String getSeminarLogId() {
        return seminarLogId;
    }
    public void setSeminarLogId(String seminarLogId) {
        this.seminarLogId = seminarLogId;
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
    public String getStartDttm() {
        return startDttm;
    }
    public void setStartDttm(String startDttm) {
        this.startDttm = startDttm;
    }
    public String getEndDttm() {
        return endDttm;
    }
    public void setEndDttm(String endDttm) {
        this.endDttm = endDttm;
    }
    public String getDeviceTypeCd() {
        return deviceTypeCd;
    }
    public void setDeviceTypeCd(String deviceTypeCd) {
        this.deviceTypeCd = deviceTypeCd;
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
    public String getRegIp() {
        return regIp;
    }
    public void setRegIp(String regIp) {
        this.regIp = regIp;
    }

}
