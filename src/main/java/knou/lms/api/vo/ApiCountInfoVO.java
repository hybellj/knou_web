package knou.lms.api.vo;

import knou.lms.common.vo.DefaultVO;

public class ApiCountInfoVO extends DefaultVO {

    private static final long serialVersionUID = -546224615404667826L;

    private String year;            // 년도
    private String semester;        // 학기
    private String courseCode;      // 과목코드
    private String section;         // 분반
    private String todayDttm;       // 현재날짜
    private String crsCreCd;        // 학수번호
    private String userId;          // 사용자번호
    private String alarmType;       // 알림구분
    private int countInfo;          // 조회수
    private String ltWeek;
    private String token;


    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }

    public String getYear() {
        return year;
    }
    public void setYear(String year) {
        this.year = year;
    }

    public String getSemester() {
        return semester;
    }
    public void setSemester(String semester) {
        this.semester = semester;
    }

    public String getCourseCode() {
        return courseCode;
    }
    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public String getSection() {
        return section;
    }
    public void setSection(String section) {
        this.section = section;
    }

    public String getTodayDttm() {
        return todayDttm;
    }
    public void setTodayDttm(String todayDttm) {
        this.todayDttm = todayDttm;
    }

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

    public String getAlarmType() {
        return alarmType;
    }
    public void setAlarmType(String alarmType) {
        this.alarmType = alarmType;
    }

    public int getCountInfo() {
        return countInfo;
    }
    public void setCountInfo(int countInfo) {
        this.countInfo = countInfo;
    }

    public String getLtWeek() {
        return ltWeek;
    }
    public void setLtWeek(String ltWeek) {
        this.ltWeek = ltWeek;
    }
}