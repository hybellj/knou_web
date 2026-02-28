package knou.lms.seminar.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class SeminarVO extends DefaultVO {

    private static final long serialVersionUID = 6882352607511794506L;
    /** tb_lms_seminar */
    private String  seminarId;              // 세미나 고유번호
    private String  lessonScheduleId;       // 학습일정 아이디
    private String  lessonTimeId;           // 교시 아이디
    private String  seminarNm;              // 세미나 명
    private String  seminarCts;             // 세미나 내용
    private String  seminarCtgrCd;          // 세미나 분류코드
    private String  seminarStartDttm;       // 세미나 시작 일시
    private String  seminarEndDttm;         // 세미나 종료 일시
    private String  seminarTime;            // 진행 시간
    private String  hostUrl;                // ZOOM 교수용 URL
    private String  joinUrl;                // ZOOM 학생용 URL
    private String  zoomId;                 // ZOOM ID
    private String  zoomPw;                 // ZOOM PW
    private String  attProcYn;              // 세미나 출결처리 여부
    private String  autoRecordYn;           // 자동녹화여부
    private String  delYn;                  // 삭제 여부
    
    private String  seminarCtgrNm;          // 세미나 분류코드명
    private Integer lessonScheduleOrder;    // 학습일정순서
    private Integer lessonTimeOrder;        // 교시순서
    private List<String> crsCreCds;         // 분반 같이 등록용 과목 리스트
    private String  seminarStatus;          // 세미나 오픈 상태
    private Integer seminarTotalStdCnt;     // 세미나 총 인원 수
    private Integer seminarJoinStdCnt;      // 세미나 참여 인원 수
    private Integer seminarAttendUserCnt;   // 세미나 출석 인원 수
    private Integer seminarLateUserCnt;     // 세미나 지각 인원 수
    private Integer seminarAbsentUserCnt;   // 세미나 결석 인원 수
    private String  stdNo;                  // 학습자 번호
    private String  stdAttendStatus;        // 학습자 출결 상태
    private String  seminarStartYn;         // 세미나 참여 가능 여부
    private String  seminarEndYn;           // 세미나 종료 여부(익일)
    
    private String  profNo;                 // 과목 담당 교수 번호
    private String  tcEmail;                // ZOOM 미팅 등록용 Service 호출 시 사용하는 email
    private String  hostYn;
    private Integer tchAtndTime;            // 교수 ZOOM 미팅 시간
    
    private String  creYear;
    private String  creTerm;
    
    public String getSeminarId() {
        return seminarId;
    }
    public void setSeminarId(String seminarId) {
        this.seminarId = seminarId;
    }
    public String getLessonScheduleId() {
        return lessonScheduleId;
    }
    public void setLessonScheduleId(String lessonScheduleId) {
        this.lessonScheduleId = lessonScheduleId;
    }
    public String getLessonTimeId() {
        return lessonTimeId;
    }
    public void setLessonTimeId(String lessonTimeId) {
        this.lessonTimeId = lessonTimeId;
    }
    public String getSeminarNm() {
        return seminarNm;
    }
    public void setSeminarNm(String seminarNm) {
        this.seminarNm = seminarNm;
    }
    public String getSeminarCts() {
        return seminarCts;
    }
    public void setSeminarCts(String seminarCts) {
        this.seminarCts = seminarCts;
    }
    public String getSeminarCtgrCd() {
        return seminarCtgrCd;
    }
    public void setSeminarCtgrCd(String seminarCtgrCd) {
        this.seminarCtgrCd = seminarCtgrCd;
    }
    public String getSeminarStartDttm() {
        return seminarStartDttm;
    }
    public void setSeminarStartDttm(String seminarStartDttm) {
        this.seminarStartDttm = seminarStartDttm;
    }
    public String getSeminarEndDttm() {
        return seminarEndDttm;
    }
    public void setSeminarEndDttm(String seminarEndDttm) {
        this.seminarEndDttm = seminarEndDttm;
    }
    public String getSeminarTime() {
        return seminarTime;
    }
    public void setSeminarTime(String seminarTime) {
        this.seminarTime = seminarTime;
    }
    public String getHostUrl() {
        return hostUrl;
    }
    public void setHostUrl(String hostUrl) {
        this.hostUrl = hostUrl;
    }
    public String getJoinUrl() {
        return joinUrl;
    }
    public void setJoinUrl(String joinUrl) {
        this.joinUrl = joinUrl;
    }
    public String getZoomId() {
        return zoomId;
    }
    public void setZoomId(String zoomId) {
        this.zoomId = zoomId;
    }
    public String getZoomPw() {
        return zoomPw;
    }
    public void setZoomPw(String zoomPw) {
        this.zoomPw = zoomPw;
    }
    public String getAttProcYn() {
        return attProcYn;
    }
    public void setAttProcYn(String attProcYn) {
        this.attProcYn = attProcYn;
    }
    public String getAutoRecordYn() {
        return autoRecordYn;
    }
    public void setAutoRecordYn(String autoRecordYn) {
        this.autoRecordYn = autoRecordYn;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    public String getSeminarCtgrNm() {
        return seminarCtgrNm;
    }
    public void setSeminarCtgrNm(String seminarCtgrNm) {
        this.seminarCtgrNm = seminarCtgrNm;
    }
    public Integer getLessonScheduleOrder() {
        return lessonScheduleOrder;
    }
    public void setLessonScheduleOrder(Integer lessonScheduleOrder) {
        this.lessonScheduleOrder = lessonScheduleOrder;
    }
    public Integer getLessonTimeOrder() {
        return lessonTimeOrder;
    }
    public void setLessonTimeOrder(Integer lessonTimeOrder) {
        this.lessonTimeOrder = lessonTimeOrder;
    }
    public List<String> getCrsCreCds() {
        return crsCreCds;
    }
    public void setCrsCreCds(List<String> crsCreCds) {
        this.crsCreCds = crsCreCds;
    }
    public String getSeminarStatus() {
        return seminarStatus;
    }
    public void setSeminarStatus(String seminarStatus) {
        this.seminarStatus = seminarStatus;
    }
    public Integer getSeminarTotalStdCnt() {
        return seminarTotalStdCnt;
    }
    public void setSeminarTotalStdCnt(Integer seminarTotalStdCnt) {
        this.seminarTotalStdCnt = seminarTotalStdCnt;
    }
    public Integer getSeminarJoinStdCnt() {
        return seminarJoinStdCnt;
    }
    public void setSeminarJoinStdCnt(Integer seminarJoinStdCnt) {
        this.seminarJoinStdCnt = seminarJoinStdCnt;
    }
    public Integer getSeminarAttendUserCnt() {
        return seminarAttendUserCnt;
    }
    public void setSeminarAttendUserCnt(Integer seminarAttendUserCnt) {
        this.seminarAttendUserCnt = seminarAttendUserCnt;
    }
    public Integer getSeminarLateUserCnt() {
        return seminarLateUserCnt;
    }
    public void setSeminarLateUserCnt(Integer seminarLateUserCnt) {
        this.seminarLateUserCnt = seminarLateUserCnt;
    }
    public Integer getSeminarAbsentUserCnt() {
        return seminarAbsentUserCnt;
    }
    public void setSeminarAbsentUserCnt(Integer seminarAbsentUserCnt) {
        this.seminarAbsentUserCnt = seminarAbsentUserCnt;
    }
    public String getStdNo() {
        return stdNo;
    }
    public void setStdNo(String stdNo) {
        this.stdNo = stdNo;
    }
    public String getStdAttendStatus() {
        return stdAttendStatus;
    }
    public void setStdAttendStatus(String stdAttendStatus) {
        this.stdAttendStatus = stdAttendStatus;
    }
    public String getSeminarStartYn() {
        return seminarStartYn;
    }
    public void setSeminarStartYn(String seminarStartYn) {
        this.seminarStartYn = seminarStartYn;
    }
    public String getTcEmail() {
        return tcEmail;
    }
    public void setTcEmail(String tcEmail) {
        this.tcEmail = tcEmail;
    }
    public String getProfNo() {
        return profNo;
    }
    public void setProfNo(String profNo) {
        this.profNo = profNo;
    }
    public String getHostYn() {
        return hostYn;
    }
    public void setHostYn(String hostYn) {
        this.hostYn = hostYn;
    }
    public Integer getTchAtndTime() {
        return tchAtndTime;
    }
    public void setTchAtndTime(Integer tchAtndTime) {
        this.tchAtndTime = tchAtndTime;
    }
    public String getCreYear() {
        return creYear;
    }
    public void setCreYear(String creYear) {
        this.creYear = creYear;
    }
    public String getCreTerm() {
        return creTerm;
    }
    public void setCreTerm(String creTerm) {
        this.creTerm = creTerm;
    }
    public String getSeminarEndYn() {
        return seminarEndYn;
    }
    public void setSeminarEndYn(String seminarEndYn) {
        this.seminarEndYn = seminarEndYn;
    }

}
