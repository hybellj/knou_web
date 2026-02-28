package knou.lms.statistics.vo;

import knou.lms.common.vo.DefaultVO;

public class StatisticsVO extends DefaultVO {

    private static final long serialVersionUID = 6631393262850571949L;

    private String lineNo;
    private String ltWeek;           /* 주차 */
    private String userId;           /* 학번 */
    private String userNm;           /* 이름 */
    private String enrHp;            /* 신청학점 */
    private String connDay;          /* 접속일수 */
    private String connTmSum;        /* 접속시간 합계 */
    private String dayTmAvg;         /* 일접속시간 평균 */
    private String dayTmDev;         /* 일접속시간 표준편차 */
    private String dayTermAvg;       /* 접속일간격 평균 */
    private String dayTermDev;       /* 접속일간 표준편차 */
    private String connDayRatio;     /* 주간접속비율 */
    private String connWeekdayRatio; /* 주중접속비율 */
    
    //검색
    private String creYear;
    private String creTerm;
    private String uniCd;
    private String univGbn;
    private String deptCd;
    private String deptNm;         // 부서(학과) 명
    private String crsCd;
    private String crsCreCd;                   
    private String crsCreNm;
    private String declsNo;                   // 분반 번호
    
    public String getLtWeek() {
        return ltWeek;
    }

    public void setLtWeek(String ltWeek) {
        this.ltWeek = ltWeek;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
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

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public String getLineNo() {
        return lineNo;
    }

    public void setLineNo(String lineNo) {
        this.lineNo = lineNo;
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

    public String getUniCd() {
        return uniCd;
    }

    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }

    public String getDeptCd() {
        return deptCd;
    }

    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
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

    public String getDeptNm() {
        return deptNm;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public String getCrsCreNm() {
        return crsCreNm;
    }

    public void setCrsCreNm(String crsCreNm) {
        this.crsCreNm = crsCreNm;
    }

    public String getDeclsNo() {
        return declsNo;
    }

    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }

    public String getUnivGbn() {
        return univGbn;
    }

    public void setUnivGbn(String univGbn) {
        this.univGbn = univGbn;
    }


}
