package knou.lms.api.vo;

import knou.lms.common.vo.DefaultVO;

public class ApiListInfoVO extends DefaultVO {

    private static final long serialVersionUID = -4578144020891116461L;

    private String atclTitle;                   // 제목
    private String regNm;                       // 등록자
    private String regDttm;                     // 등록일시
    private String viewLink;                    // 상세화면링크
    private String viewUrl;                     // 상세링크 url
    private String viewParam1;                  // 상세링크 변수1
    private String viewParam2;                  // 상세링크 변수2
    private String year;                        // 년도
    private String semester;                    // 학기
    private String courseCode;                  // 과목코드
    private String section;                     // 분반
    private String userId;                      // 사용자번호
    private String alarmType;                   // 알림 구분
    private String bbsId;                       // 게시판 아이디
    private String enquirer;                    // 문의자
    private String answerYn;                    // 답변여부
    private String crsCd; 
    private String crsCreCd;                    // 과정 개설 코드
    private String crsCreNm;                    // 과목명
    private String progressType;                // 진도율 구분
    private String stdProgRatio;                // 나의 평균 진도율
    private Double stdTotalProgressRatio;       // 전체 평균 진도율
    private Double myLessonScheduleJoinRate;    // 교수 나의 평균 진도율
    private Double totalLessonProgressRate;     // 교수 전체 평균 진도율
    private Double subjectAttendRate;           // 과목 평균진도율
    private int lessonScheduleOrder;            // 주차강의
    private Double lastYearAvgAttendRate;       // 작년평균출석율
    private Double thisYearAvgAttendRate;       // 올해평균출석율
    private String token;                       // 토큰
    private String uniCd;                       // 대학구분
    private String declsNo;                     // 분반번호
    private int cmplWeekCnt;                    // 학습주차주
    private int totWeekCnt;                     // 전체주차주
    private String progRatio;                   // 진도율
    private String corsUrl;                     // 강의실홈URL
    private String totalProgRatio;              // 전체(학부+대학원) 진도율
    private String colleageProgRatio;           // 학부 진도율
    private String gradProgRatio;               // 대학원 진도율
    private String profProgRatio;               // 교수별 평균진도율
    private String lastYear;                    // 지난년도
    private String deptId;                      // 학과코드
    private String deptNm;                      // 학과명
    private String crsProgRatio;                // 과목진도율
    private String todayDttm;                   // 현재날짜
    private String ltOmitWeek;                  // 제외주차
    private String ltWeek;                      // 주차
    private String domainUrl;                   // 도메인 URL
    private String enrHp;                       // 신청학점
    private String connDay;                     // 접속일수합계
    private String connDaySum;                  // 접속일수누적합계
    private String connTm;                      // 접속시간합계
    private String connTmSum;                   // 접속시간누적합계
    private String dayTmAvg;                    // 일접속시간 평균
    private String dayTmDev;                    // 일접속시간 표준편차
    private String dayTermAvg;                  // 접속일간격 평균
    private String dayTermDev;                  // 접속일간격 표준편차
    private String connDayRatio;                // 주간접속비율
    private String connWeekdayRatio;            // 주중접속비율
    // private String regDttm;                     // 등록일
    private String modDttm;                     // 수정일

    // 과제
    private String creYear;
    private String creTerm;
    // private String declsNo;
    // private String crsCreCd;
    private String asmntCd;
    private String asmntTitle;
    private String sendStartDttm;
    private String sendEndDttm;
    private String delYn;
    private String useYn;
    private String asmntSendCd;
    private String asmntSubmitStatusCd;
    private String resendYn;

    // 토론
    private String forumCd;
    private String forumTitle;
    private String forumStartDttm;
    private String forumEndDttm;

    // 퀴즈
    private String examCd;
    private String examTitle;
    private String examStartDttm;
    private String examEndDttm;

    // 설문
    private String reschCd;
    private String reschTitle;
    private String reschStartDttm;
    private String reschEndDttm;

    //  세미나
    private String seminarId;
    private String seminarNm;
    private String seminarTime;
    private String seminarStartDttm;
    private String seminarEndDttm;
    private String atndCd;
    private int totalRecordCount;

    // 학습진도
    // private String userId;
    // private String crsCreCd;
    // private String declsNo;
    // private String progRatio;
    // private String modDttm;
    // private String userId;
    // private String crsCd;
    // private String declsNo;
    // private String uniCd;
    private String lessonOrder;
    private String attendYn;
    // private String progRatio;
    // private String regDttm;
    // private String modDttm;
    private String colleageAvgAttendRate;
    private String colleageWeekRatio;
    private String gradAvgAttendRate;
    private String gradWeekRatio;
    private String univGbn;

    public String getCrsProgRatio() {
        return crsProgRatio;
    }
    public void setCrsProgRatio(String crsProgRatio) {
        this.crsProgRatio = crsProgRatio;
    }

    public String getLastYear() {
        return lastYear;
    }
    public void setLastYear(String lastYear) {
        this.lastYear = lastYear;
    }

    public String getColleageProgRatio() {
        return colleageProgRatio;
    }
    public void setColleageProgRatio(String colleageProgRatio) {
        this.colleageProgRatio = colleageProgRatio;
    }

    public String getGradProgRatio() {
        return gradProgRatio;
    }
    public void setGradProgRatio(String gradProgRatio) {
        this.gradProgRatio = gradProgRatio;
    }

    public String getDeclsNo() {
        return declsNo;
    }
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }

    public int getCmplWeekCnt() {
        return cmplWeekCnt;
    }
    public void setCmplWeekCnt(int cmplWeekCnt) {
        this.cmplWeekCnt = cmplWeekCnt;
    }

    public int getTotWeekCnt() {
        return totWeekCnt;
    }
    public void setTotWeekCnt(int totWeekCnt) {
        this.totWeekCnt = totWeekCnt;
    }

    public String getProgRatio() {
        return progRatio;
    }
    public void setProgRatio(String progRatio) {
        this.progRatio = progRatio;
    }

    public String getCorsUrl() {
        return corsUrl;
    }
    public void setCorsUrl(String corsUrl) {
        this.corsUrl = corsUrl;
    }

    public String getUniCd() {
        return uniCd;
    }
    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }

    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }

    public int getLessonScheduleOrder() {
        return lessonScheduleOrder;
    }
    public void setLessonScheduleOrder(int lessonScheduleOrder) {
        this.lessonScheduleOrder = lessonScheduleOrder;
    }

    public Double getLastYearAvgAttendRate() {
        return lastYearAvgAttendRate;
    }
    public void setLastYearAvgAttendRate(Double lastYearAvgAttendRate) {
        this.lastYearAvgAttendRate = lastYearAvgAttendRate;
    }

    public Double getThisYearAvgAttendRate() {
        return thisYearAvgAttendRate;
    }
    public void setThisYearAvgAttendRate(Double thisYearAvgAttendRate) {
        this.thisYearAvgAttendRate = thisYearAvgAttendRate;
    }

    public String getCrsCreNm() {
        return crsCreNm;
    }
    public void setCrsCreNm(String crsCreNm) {
        this.crsCreNm = crsCreNm;
    }

    public Double getSubjectAttendRate() {
        return subjectAttendRate;
    }
    public void setSubjectAttendRate(Double subjectAttendRate) {
        this.subjectAttendRate = subjectAttendRate;
    }

    public Double getMyLessonScheduleJoinRate() {
        return myLessonScheduleJoinRate;
    }
    public void setMyLessonScheduleJoinRate(Double myLessonScheduleJoinRate) {
        this.myLessonScheduleJoinRate = myLessonScheduleJoinRate;
    }

    public Double getTotalLessonProgressRate() {
        return totalLessonProgressRate;
    }
    public void setTotalLessonProgressRate(Double totalLessonProgressRate) {
        this.totalLessonProgressRate = totalLessonProgressRate;
    }

    public String getViewUrl() {
        return viewUrl;
    }
    public void setViewUrl(String viewUrl) {
        this.viewUrl = viewUrl;
    }

    public String getViewParam1() {
        return viewParam1;
    }
    public void setViewParam1(String viewParam1) {
        this.viewParam1 = viewParam1;
    }

    public String getViewParam2() {
        return viewParam2;
    }
    public void setViewParam2(String viewParam2) {
        this.viewParam2 = viewParam2;
    }

    public String getAtclTitle() {
        return atclTitle;
    }
    public void setAtclTitle(String atclTitle) {
        this.atclTitle = atclTitle;
    }

    public String getRegNm() {
        return regNm;
    }
    public void setRegNm(String regNm) {
        this.regNm = regNm;
    }

    public String getRegDttm() {
        return regDttm;
    }
    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    public String getViewLink() {
        return viewLink;
    }
    public void setViewLink(String viewLink) {
        this.viewLink = viewLink;
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

    public String getBbsId() {
        return bbsId;
    }
    public void setBbsId(String bbsId) {
        this.bbsId = bbsId;
    }

    public String getEnquirer() {
        return enquirer;
    }
    public void setEnquirer(String enquirer) {
        this.enquirer = enquirer;
    }

    public String getAnswerYn() {
        return answerYn;
    }
    public void setAnswerYn(String answerYn) {
        this.answerYn = answerYn;
    }

    public String getCrsCd() {
        return crsCd;
    }
    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getProgressType() {
        return progressType;
    }
    public void setProgressType(String progressType) {
        this.progressType = progressType;
    }

    public Double getStdTotalProgressRatio() {
        return stdTotalProgressRatio;
    }
    public void setStdTotalProgressRatio(Double stdTotalProgressRatio) {
        this.stdTotalProgressRatio = stdTotalProgressRatio;
    }

    public String getStdProgRatio() {
        return stdProgRatio;
    }
    public void setStdProgRatio(String stdProgRatio) {
        this.stdProgRatio = stdProgRatio;
    }

    public String getProfProgRatio() {
        return profProgRatio;
    }
    public void setProfProgRatio(String profProgRatio) {
        this.profProgRatio = profProgRatio;
    }

    public String getDeptId() {
        return deptId;
    }
    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public String getTodayDttm() {
        return todayDttm;
    }
    public void setTodayDttm(String todayDttm) {
        this.todayDttm = todayDttm;
    }

    public String getLtOmitWeek() {
        return ltOmitWeek;
    }
    public void setLtOmitWeek(String ltOmitWeek) {
        this.ltOmitWeek = ltOmitWeek;
    }
    
    public String getLtWeek() {
        return ltWeek;
    }
    public void setLtWeek(String ltWeek) {
        this.ltWeek = ltWeek;
    }

    public String getDomainUrl() {
        return domainUrl;
    }
    public void setDomainUrl(String domainUrl) {
        this.domainUrl = domainUrl;
    }

    public String getEnrHp() {
        return enrHp;
    }
    public void setEnrHp(String enrHp) {
        this.enrHp = enrHp;
    }

    public String getConnDay() {
        return connDay;
    }
    public void setConnDay(String connDay) {
        this.connDay = connDay;
    }

    public String getConnDaySum() {
        return connDaySum;
    }
    public void setConnDaySum(String connDaySum) {
        this.connDaySum = connDaySum;
    }

    public String getConnTm() {
        return connTm;
    }
    public void setConnTm(String connTm) {
        this.connTm = connTm;
    }

    public String getConnTmSum() {
        return connTmSum;
    }
    public void setConnTmSum(String connTmSum) {
        this.connTmSum = connTmSum;
    }

    public String getDayTmAvg() {
        return dayTmAvg;
    }
    public void setDayTmAvg(String dayTmAvg) {
        this.dayTmAvg = dayTmAvg;
    }

    public String getDayTmDev() {
        return dayTmDev;
    }
    public void setDayTmDev(String dayTmDev) {
        this.dayTmDev = dayTmDev;
    }

    public String getDayTermAvg() {
        return dayTermAvg;
    }
    public void setDayTermAvg(String dayTermAvg) {
        this.dayTermAvg = dayTermAvg;
    }

    public String getDayTermDev() {
        return dayTermDev;
    }
    public void setDayTermDev(String dayTermDev) {
        this.dayTermDev = dayTermDev;
    }

    public String getConnDayRatio() {
        return connDayRatio;
    }
    public void setConnDayRatio(String connDayRatio) {
        this.connDayRatio = connDayRatio;
    }

    public String getConnWeekdayRatio() {
        return connWeekdayRatio;
    }
    public void setConnWeekdayRatio(String connWeekdayRatio) {
        this.connWeekdayRatio = connWeekdayRatio;
    }
    
    public String getModDttm() {
        return modDttm;
    }
    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

    // 과제
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
    
    public String getAsmntCd() {
        return asmntCd;
    }
    public void setAsmntCd(String asmntCd) {
        this.asmntCd = asmntCd;
    }
    
    public String getAsmntTitle() {
        return asmntTitle;
    }
    public void setAsmntTitle(String asmntTitle) {
        this.asmntTitle = asmntTitle;
    }
    
    public String getSendStartDttm() {
        return sendStartDttm;
    }
    public void setSendStartDttm(String sendStartDttm) {
        this.sendStartDttm = sendStartDttm;
    }
    
    public String getSendEndDttm() {
        return sendEndDttm;
    }
    public void setSendEndDttm(String sendEndDttm) {
        this.sendEndDttm = sendEndDttm;
    }
    
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
    
    public String getAsmntSendCd() {
        return asmntSendCd;
    }
    public void setAsmntSendCd(String asmntSendCd) {
        this.asmntSendCd = asmntSendCd;
    }
    
    public String getAsmntSubmitStatusCd() {
        return asmntSubmitStatusCd;
    }
    public void setAsmntSubmitStatusCd(String asmntSubmitStatusCd) {
        this.asmntSubmitStatusCd = asmntSubmitStatusCd;
    }
    
    public String getResendYn() {
        return resendYn;
    }
    public void setResendYn(String resendYn) {
        this.resendYn = resendYn;
    }
    
    // 토론
    public String getForumCd() {
        return forumCd;
    }
    public void setForumCd(String forumCd) {
        this.forumCd = forumCd;
    }
    
    public String getForumTitle() {
        return forumTitle;
    }
    public void setForumTitle(String forumTitle) {
        this.forumTitle = forumTitle;
    }
    
    public String getForumStartDttm() {
        return forumStartDttm;
    }
    public void setForumStartDttm(String forumStartDttm) {
        this.forumStartDttm = forumStartDttm;
    }
    
    public String getForumEndDttm() {
        return forumEndDttm;
    }
    public void setForumEndDttm(String forumEndDttm) {
        this.forumEndDttm = forumEndDttm;
    }
    
    // 퀴즈
    public String getExamCd() {
        return examCd;
    }
    public void setExamCd(String examCd) {
        this.examCd = examCd;
    }
    
    public String getExamTitle() {
        return examTitle;
    }
    public void setExamTitle(String examTitle) {
        this.examTitle = examTitle;
    }
    
    public String getExamStartDttm() {
        return examStartDttm;
    }
    public void setExamStartDttm(String examStartDttm) {
        this.examStartDttm = examStartDttm;
    }
    
    public String getExamEndDttm() {
        return examEndDttm;
    }
    public void setExamEndDttm(String examEndDttm) {
        this.examEndDttm = examEndDttm;
    }
    
    // 설문
    public String getReschCd() {
        return reschCd;
    }
    public void setReschCd(String reschCd) {
        this.reschCd = reschCd;
    }
    
    public String getReschTitle() {
        return reschTitle;
    }
    public void setReschTitle(String reschTitle) {
        this.reschTitle = reschTitle;
    }
    
    public String getReschStartDttm() {
        return reschStartDttm;
    }
    public void setReschStartDttm(String reschStartDttm) {
        this.reschStartDttm = reschStartDttm;
    }
    
    public String getReschEndDttm() {
        return reschEndDttm;
    }
    public void setReschEndDttm(String reschEndDttm) {
        this.reschEndDttm = reschEndDttm;
    }
    
    // 세미나
    public String getSeminarId() {
        return seminarId;
    }
    public void setSeminarId(String seminarId) {
        this.seminarId = seminarId;
    }
    
    public String getSeminarNm() {
        return seminarNm;
    }
    public void setSeminarNm(String seminarNm) {
        this.seminarNm = seminarNm;
    }
    
    public String getSeminarTime() {
        return seminarTime;
    }
    public void setSeminarTime(String seminarTime) {
        this.seminarTime = seminarTime;
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

    public String getAtndCd() {
        return atndCd;
    }
    public void setAtndCd(String atndCd) {
        this.atndCd = atndCd;
    }

    public int getTotalRecordCount() {
        return totalRecordCount;
    }
    public void setTotalRecordCount(int totalRecordCount) {
        this.totalRecordCount = totalRecordCount;
    }

    public String getLessonOrder() {
        return lessonOrder;
    }
    public void setLessonOrder(String lessonOrder) {
        this.lessonOrder = lessonOrder;
    }
    
    public String getAttendYn() {
        return attendYn;
    }
    public void setAttendYn(String attendYn) {
        this.attendYn = attendYn;
    }

    public String getColleageAvgAttendRate() {
        return colleageAvgAttendRate;
    }
    public void setColleageAvgAttendRate(String colleageAvgAttendRate) {
        this.colleageAvgAttendRate = colleageAvgAttendRate;
    }

    public String getColleageWeekRatio() {
        return colleageWeekRatio;
    }
    public void setColleageWeekRatio(String colleageWeekRatio) {
        this.colleageWeekRatio = colleageWeekRatio;
    }

    public String getGradAvgAttendRate() {
        return gradAvgAttendRate;
    }
    public void setGradAvgAttendRate(String gradAvgAttendRate) {
        this.gradAvgAttendRate = gradAvgAttendRate;
    }

    public String getGradWeekRatio() {
        return gradWeekRatio;
    }
    public void setGradWeekRatio(String gradWeekRatio) {
        this.gradWeekRatio = gradWeekRatio;
    }

    public String getTotalProgRatio() {
        return totalProgRatio;
    }

    public void setTotalProgRatio(String totalProgRatio) {
        this.totalProgRatio = totalProgRatio;
    }
    public String getUnivGbn() {
        return univGbn;
    }
    public void setUnivGbn(String univGbn) {
        this.univGbn = univGbn;
    }
}