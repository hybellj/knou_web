package knou.lms.seminar.vo;

import knou.lms.common.vo.DefaultVO;

public class SeminarRegVO extends DefaultVO {

    private static final long serialVersionUID = -395178461771177474L;
    /** tb_lms_seminar_reg */
    private String  seminarRegId;       // 세미나 사전등록 고유번호 ID
    private String  seminarId;          // 세미나 고유번호
    private String  crsCreCd;           // 과정 개설 코드
    private String  zoomId;             // ZOOM ID
    private String  stdNo;              // 수강생 번호
    private String  userId;             // 사용자 번호
    private String  registantId;        // 사전등록 ID
    private String  joinUrl;            // 참가 URL
    private String  tcEmail;            // 참가 이메일
    
    public String getSeminarRegId() {
        return seminarRegId;
    }
    public void setSeminarRegId(String seminarRegId) {
        this.seminarRegId = seminarRegId;
    }
    public String getSeminarId() {
        return seminarId;
    }
    public void setSeminarId(String seminarId) {
        this.seminarId = seminarId;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getZoomId() {
        return zoomId;
    }
    public void setZoomId(String zoomId) {
        this.zoomId = zoomId;
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
    public String getRegistantId() {
        return registantId;
    }
    public void setRegistantId(String registantId) {
        this.registantId = registantId;
    }
    public String getJoinUrl() {
        return joinUrl;
    }
    public void setJoinUrl(String joinUrl) {
        this.joinUrl = joinUrl;
    }
    public String getTcEmail() {
        return tcEmail;
    }
    public void setTcEmail(String tcEmail) {
        this.tcEmail = tcEmail;
    }

}
