package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamIndustryConVO extends DefaultVO {

    private static final long serialVersionUID = 3012382957297420585L;

    /** tb_lms_lesson_study_record */
    private String haksaYear;               //학사년도
    private String haksaTerm;               //학기코드
    private String haksaTermCd;             //학기코드
    private String haksaTermNm;             //학기명
    private String crsCreCd;                //과정 개설 코드
    private String lessonScheduleNm;        //학습일정 명
    private String lessonStartDt;           //학습시작일자
    private String lessonEndDt;             //학습종료일자
    private String userId;                  //학번 또는 사번
    private String userNm;                  //성명
    private String crsCd;                   //학수번호
    private String crsCreNm;                //교과목명
    private String oneWeekResult;           //1차시
    private String twoWeekResult;           //2차시
    private String threeWeekResult;         //3차시
    private String fourWeekResult;          //4차시
    private String fiveWeekResult;          //5차시
    private String sixWeekResult;           //6차시
    private String sevenWeekResult;         //7차시
    private String eightWeekResult;         //8차시
    private String nineWeekResult;          //9차시
    private String tenWeekResult;           //10차시
    private String elevenWeekResult;        //11차시
    private String twelveWeekResult;        //12차시
    private String thirteenWeekResult;      //13차시
    private String fourteenWeekResult;      //14차시
    private String fifteenWeekResult;       //15차시
    private String sixteenWeekResult;       //16차시
    private String loginCnt;                //로그인횟수
    private String credit;                  //학점
    private String meanRating;              //평균평점
    private String totScore;                //백분율점수
    private String scoreGrade;              //등급    
    private String curTermYn;               //현재학기여부
    private String oneWeekEndDt;            //1차시종료일자
    private String twoWeekEndDt;            //2차시종료일자
    private String threeWeekEndDt;          //3차시종료일자
    private String fourWeekEndDt;           //4차시종료일자
    private String fiveWeekEndDt;           //5차시종료일자
    private String sixWeekEndDt;            //6차시종료일자
    private String sevenWeekEndDt;          //7차시종료일자
    private String eightWeekEndDt;          //8차시종료일자
    private String nineWeekEndDt;           //9차시종료일자
    private String tenWeekEndDt;            //10차시종료일자
    private String elevenWeekEndDt;         //111차시종료일자
    private String twelveWeekEndDt;         //12차시종료일자
    private String thirteenWeekEndDt;       //13차시종료일자
    private String fourteenWeekEndDt;       //14차시종료일자
    private String fifteenWeekEndDt;        //15차시종료일자
            
    
    public String getHaksaYear() {
        return haksaYear;
    }
    public void setHaksaYear(String haksaYear) {
        this.haksaYear = haksaYear;
    }
    public String getHaksaTermCd() {
        return haksaTermCd;
    }
    public void setHaksaTermCd(String haksaTermCd) {
        this.haksaTermCd = haksaTermCd;
    }
    public String getHaksaTermNm() {
        return haksaTermNm;
    }
    public void setHaksaTermNm(String haksaTermNm) {
        this.haksaTermNm = haksaTermNm;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getLessonScheduleNm() {
        return lessonScheduleNm;
    }
    public void setLessonScheduleNm(String lessonScheduleNm) {
        this.lessonScheduleNm = lessonScheduleNm;
    }
    public String getLessonStartDt() {
        return lessonStartDt;
    }
    public void setLessonStartDt(String lessonStartDt) {
        this.lessonStartDt = lessonStartDt;
    }
    public String getLessonEndDt() {
        return lessonEndDt;
    }
    public void setLessonEndDt(String lessonEndDt) {
        this.lessonEndDt = lessonEndDt;
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
    public String getCrsCd() {
        return crsCd;
    }
    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }
    public String getCrsCreNm() {
        return crsCreNm;
    }
    public void setCrsCreNm(String crsCreNm) {
        this.crsCreNm = crsCreNm;
    }
    public String getOneWeekResult() {
        return oneWeekResult;
    }
    public void setOneWeekResult(String oneWeekResult) {
        this.oneWeekResult = oneWeekResult;
    }
    public String getTwoWeekResult() {
        return twoWeekResult;
    }
    public void setTwoWeekResult(String twoWeekResult) {
        this.twoWeekResult = twoWeekResult;
    }
    public String getThreeWeekResult() {
        return threeWeekResult;
    }
    public void setThreeWeekResult(String threeWeekResult) {
        this.threeWeekResult = threeWeekResult;
    }
    public String getFourWeekResult() {
        return fourWeekResult;
    }
    public void setFourWeekResult(String fourWeekResult) {
        this.fourWeekResult = fourWeekResult;
    }
    public String getFiveWeekResult() {
        return fiveWeekResult;
    }
    public void setFiveWeekResult(String fiveWeekResult) {
        this.fiveWeekResult = fiveWeekResult;
    }
    public String getSixWeekResult() {
        return sixWeekResult;
    }
    public void setSixWeekResult(String sixWeekResult) {
        this.sixWeekResult = sixWeekResult;
    }
    public String getSevenWeekResult() {
        return sevenWeekResult;
    }
    public void setSevenWeekResult(String sevenWeekResult) {
        this.sevenWeekResult = sevenWeekResult;
    }
    public String getEightWeekResult() {
        return eightWeekResult;
    }
    public void setEightWeekResult(String eightWeekResult) {
        this.eightWeekResult = eightWeekResult;
    }
    public String getNineWeekResult() {
        return nineWeekResult;
    }
    public void setNineWeekResult(String nineWeekResult) {
        this.nineWeekResult = nineWeekResult;
    }
    public String getTenWeekResult() {
        return tenWeekResult;
    }
    public void setTenWeekResult(String tenWeekResult) {
        this.tenWeekResult = tenWeekResult;
    }
    public String getElevenWeekResult() {
        return elevenWeekResult;
    }
    public void setElevenWeekResult(String elevenWeekResult) {
        this.elevenWeekResult = elevenWeekResult;
    }
    public String getTwelveWeekResult() {
        return twelveWeekResult;
    }
    public void setTwelveWeekResult(String twelveWeekResult) {
        this.twelveWeekResult = twelveWeekResult;
    }
    public String getThirteenWeekResult() {
        return thirteenWeekResult;
    }
    public void setThirteenWeekResult(String thirteenWeekResult) {
        this.thirteenWeekResult = thirteenWeekResult;
    }
    public String getFourteenWeekResult() {
        return fourteenWeekResult;
    }
    public void setFourteenWeekResult(String fourteenWeekResult) {
        this.fourteenWeekResult = fourteenWeekResult;
    }
    public String getFifteenWeekResult() {
        return fifteenWeekResult;
    }
    public void setFifteenWeekResult(String fifteenWeekResult) {
        this.fifteenWeekResult = fifteenWeekResult;
    }
    public String getSixteenWeekResult() {
        return sixteenWeekResult;
    }
    public void setSixteenWeekResult(String sixteenWeekResult) {
        this.sixteenWeekResult = sixteenWeekResult;
    }
    public String getLoginCnt() {
        return loginCnt;
    }
    public void setLoginCnt(String loginCnt) {
        this.loginCnt = loginCnt;
    }
    public String getCredit() {
        return credit;
    }
    public void setCredit(String credit) {
        this.credit = credit;
    }
    public String getMeanRating() {
        return meanRating;
    }
    public void setMeanRating(String meanRating) {
        this.meanRating = meanRating;
    }
    public String getTotScore() {
        return totScore;
    }
    public void setTotScore(String totScore) {
        this.totScore = totScore;
    }
    public String getScoreGrade() {
        return scoreGrade;
    }
    public void setScoreGrade(String scoreGrade) {
        this.scoreGrade = scoreGrade;
    }
    public String getCurTermYn() {
        return curTermYn;
    }
    public void setCurTermYn(String curTermYn) {
        this.curTermYn = curTermYn;
    }
    public String getHaksaTerm() {
        return haksaTerm;
    }
    public void setHaksaTerm(String haksaTerm) {
        this.haksaTerm = haksaTerm;
    }
    public String getOneWeekEndDt() {
        return oneWeekEndDt;
    }
    public void setOneWeekEndDt(String oneWeekEndDt) {
        this.oneWeekEndDt = oneWeekEndDt;
    }
    public String getTwoWeekEndDt() {
        return twoWeekEndDt;
    }
    public void setTwoWeekEndDt(String twoWeekEndDt) {
        this.twoWeekEndDt = twoWeekEndDt;
    }
    public String getThreeWeekEndDt() {
        return threeWeekEndDt;
    }
    public void setThreeWeekEndDt(String threeWeekEndDt) {
        this.threeWeekEndDt = threeWeekEndDt;
    }
    public String getFourWeekEndDt() {
        return fourWeekEndDt;
    }
    public void setFourWeekEndDt(String fourWeekEndDt) {
        this.fourWeekEndDt = fourWeekEndDt;
    }
    public String getFiveWeekEndDt() {
        return fiveWeekEndDt;
    }
    public void setFiveWeekEndDt(String fiveWeekEndDt) {
        this.fiveWeekEndDt = fiveWeekEndDt;
    }
    public String getSixWeekEndDt() {
        return sixWeekEndDt;
    }
    public void setSixWeekEndDt(String sixWeekEndDt) {
        this.sixWeekEndDt = sixWeekEndDt;
    }
    public String getSevenWeekEndDt() {
        return sevenWeekEndDt;
    }
    public void setSevenWeekEndDt(String sevenWeekEndDt) {
        this.sevenWeekEndDt = sevenWeekEndDt;
    }
    public String getEightWeekEndDt() {
        return eightWeekEndDt;
    }
    public void setEightWeekEndDt(String eightWeekEndDt) {
        this.eightWeekEndDt = eightWeekEndDt;
    }
    public String getNineWeekEndDt() {
        return nineWeekEndDt;
    }
    public void setNineWeekEndDt(String nineWeekEndDt) {
        this.nineWeekEndDt = nineWeekEndDt;
    }
    public String getTenWeekEndDt() {
        return tenWeekEndDt;
    }
    public void setTenWeekEndDt(String tenWeekEndDt) {
        this.tenWeekEndDt = tenWeekEndDt;
    }
    public String getElevenWeekEndDt() {
        return elevenWeekEndDt;
    }
    public void setElevenWeekEndDt(String elevenWeekEndDt) {
        this.elevenWeekEndDt = elevenWeekEndDt;
    }
    public String getTwelveWeekEndDt() {
        return twelveWeekEndDt;
    }
    public void setTwelveWeekEndDt(String twelveWeekEndDt) {
        this.twelveWeekEndDt = twelveWeekEndDt;
    }
    public String getThirteenWeekEndDt() {
        return thirteenWeekEndDt;
    }
    public void setThirteenWeekEndDt(String thirteenWeekEndDt) {
        this.thirteenWeekEndDt = thirteenWeekEndDt;
    }
    public String getFourteenWeekEndDt() {
        return fourteenWeekEndDt;
    }
    public void setFourteenWeekEndDt(String fourteenWeekEndDt) {
        this.fourteenWeekEndDt = fourteenWeekEndDt;
    }
    public String getFifteenWeekEndDt() {
        return fifteenWeekEndDt;
    }
    public void setFifteenWeekEndDt(String fifteenWeekEndDt) {
        this.fifteenWeekEndDt = fifteenWeekEndDt;
    }

}
