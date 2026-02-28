package knou.lms.grade.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class GradeVO extends DefaultVO {
    private static final long serialVersionUID = 6917694481612141051L;
    
    private String curYear;
    private String curTerm;
    private String termStatus;
    
    private String termCd;
    private String termNm;
    
    private String uniGbn;
    private String uniGbnNm;
    private String univGbnNm;
    private String deptCd;
    private String deptNm;
    private String mrksGrdGvGbn;
    private String tmGbn;
    private String searchValue;
    private String declsNo;
    
    private String credit;
    private String tchNm;
    private String tchNo;
    private String tutNm;
    private String tutNo;
    private String scoreEvalGbn;
    private String scoreGrantGbn;
    private String enrlNop;
    
    private String crsTypeCd;
    private String[] crsTypeCds;
    
    private String compDvCd;
    private String compDvNm;
    
    private String lessonScoreRatio;
    private String middleTestScoreRatio;
    private String lastTestScoreRatio;
    private String testScoreRatio;
    private String assignmentScoreRatio;
    private String forumScoreRatio;
    private String quizScoreRatio;
    private String reshScoreRatio;
    private String etcScoreRatio;
    private String totalScoreRatio;
    
    private List<GradeEvlListVO> list;
    
    private List<GradeStdScoreItemVO> scoreList;
    
    private String gubun;
    
    private String crsCreCd2;
    
    private String uniCd;
    private String crsCd;
    private String tchMobileNo;
    private Integer stdCnt;
    private Integer scoreConversionCnt;
    private Integer scoreStdCnt;
    private Integer gradeStdCnt;
    
    private String creYear;
    private String creTerm;
    private String mngtDeptCd;
    private String userNm;
    private String schregGbn;
    private Integer finalScore;
    private String scoreGrade;
    private String ranking;
    private String stdNo;
    private String scoreEvalTypeNm;
    
    private Integer asmntCnt;
    private Integer forumCnt;
    private Integer quizCnt;
    private Integer reschCnt;
    private Integer testCnt;
    private Integer midTestCnt;
    private Integer lastTestCnt;
    
    // 성적입력 예외처리용
    private List<String> crsCreCdList;
    private List<String> schStartDtList;
    private List<String> schEndDtList;
    private List<String> excCmntList;
    
    private String calculationYn;
    private String converstionYn;
    private String grantYn;
    private String tchEmail;
    private String exchTotScr;
    private String univGbn;
    
    public String getCurYear() {
        return curYear;
    }
    public void setCurYear(String curYear) {
        this.curYear = curYear;
    }
    public String getTermStatus() {
        return termStatus;
    }
    public void setTermStatus(String termStatus) {
        this.termStatus = termStatus;
    }
    public String getTermCd() {
        return termCd;
    }
    public void setTermCd(String termCd) {
        this.termCd = termCd;
    }
    public String getTermNm() {
        return termNm;
    }
    public void setTermNm(String termNm) {
        this.termNm = termNm;
    }
    public String getUniGbn() {
        return uniGbn;
    }
    public void setUniGbn(String uniGbn) {
        this.uniGbn = uniGbn;
    }
    public String getDeptCd() {
        return deptCd;
    }
    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }
    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
    public String getMrksGrdGvGbn() {
        return mrksGrdGvGbn;
    }
    public void setMrksGrdGvGbn(String mrksGrdGvGbn) {
        this.mrksGrdGvGbn = mrksGrdGvGbn;
    }
    public String getTmGbn() {
        return tmGbn;
    }
    public void setTmGbn(String tmGbn) {
        this.tmGbn = tmGbn;
    }
    public String getSearchValue() {
        return searchValue;
    }
    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }
    public String getDeclsNo() {
        return declsNo;
    }
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }
    public static long getSerialversionuid() {
        return serialVersionUID;
    }
    public String getCredit() {
        return credit;
    }
    public void setCredit(String credit) {
        this.credit = credit;
    }
    public String getTchNm() {
        return tchNm;
    }
    public void setTchNm(String tchNm) {
        this.tchNm = tchNm;
    }
    public String getTchNo() {
        return tchNo;
    }
    public void setTchNo(String tchNo) {
        this.tchNo = tchNo;
    }
    public String getScoreEvalGbn() {
        return scoreEvalGbn;
    }
    public void setScoreEvalGbn(String scoreEvalGbn) {
        this.scoreEvalGbn = scoreEvalGbn;
    }
    public String getScoreGrantGbn() {
        return scoreGrantGbn;
    }
    public void setScoreGrantGbn(String scoreGrantGbn) {
        this.scoreGrantGbn = scoreGrantGbn;
    }
    public String getEnrlNop() {
        return enrlNop;
    }
    public void setEnrlNop(String enrlNop) {
        this.enrlNop = enrlNop;
    }
    public String getCrsTypeCd() {
        return crsTypeCd;
    }
    public void setCrsTypeCd(String crsTypeCd) {
        this.crsTypeCd = crsTypeCd;
    }
    public String[] getCrsTypeCds() {
        return crsTypeCds;
    }
    public void setCrsTypeCds(String[] crsTypeCds) {
        this.crsTypeCds = crsTypeCds;
    }
    public String getUniGbnNm() {
        return uniGbnNm;
    }
    public void setUniGbnNm(String uniGbnNm) {
        this.uniGbnNm = uniGbnNm;
    }
    public String getCompDvCd() {
        return compDvCd;
    }
    public void setCompDvCd(String compDvCd) {
        this.compDvCd = compDvCd;
    }
    public String getCompDvNm() {
        return compDvNm;
    }
    public void setCompDvNm(String compDvNm) {
        this.compDvNm = compDvNm;
    }
    public List<GradeEvlListVO> getList() {
        return list;
    }
    public void setList(List<GradeEvlListVO> list) {
        this.list = list;
    }
    public String getLessonScoreRatio() {
        return lessonScoreRatio;
    }
    public void setLessonScoreRatio(String lessonScoreRatio) {
        this.lessonScoreRatio = lessonScoreRatio;
    }
    public String getMiddleTestScoreRatio() {
        return middleTestScoreRatio;
    }
    public void setMiddleTestScoreRatio(String middleTestScoreRatio) {
        this.middleTestScoreRatio = middleTestScoreRatio;
    }
    public String getLastTestScoreRatio() {
        return lastTestScoreRatio;
    }
    public void setLastTestScoreRatio(String lastTestScoreRatio) {
        this.lastTestScoreRatio = lastTestScoreRatio;
    }
    public String getTestScoreRatio() {
        return testScoreRatio;
    }
    public void setTestScoreRatio(String testScoreRatio) {
        this.testScoreRatio = testScoreRatio;
    }
    public String getAssignmentScoreRatio() {
        return assignmentScoreRatio;
    }
    public void setAssignmentScoreRatio(String assignmentScoreRatio) {
        this.assignmentScoreRatio = assignmentScoreRatio;
    }
    public String getForumScoreRatio() {
        return forumScoreRatio;
    }
    public void setForumScoreRatio(String forumScoreRatio) {
        this.forumScoreRatio = forumScoreRatio;
    }
    public String getEtcScoreRatio() {
        return etcScoreRatio;
    }
    public void setEtcScoreRatio(String etcScoreRatio) {
        this.etcScoreRatio = etcScoreRatio;
    }
    public List<GradeStdScoreItemVO> getScoreList() {
        return scoreList;
    }
    public void setScoreList(List<GradeStdScoreItemVO> scoreList) {
        this.scoreList = scoreList;
    }
    public String getGubun() {
        return gubun;
    }
    public void setGubun(String gubun) {
        this.gubun = gubun;
    }
    public String getCrsCreCd2() {
        return crsCreCd2;
    }
    public void setCrsCreCd2(String crsCreCd2) {
        this.crsCreCd2 = crsCreCd2;
    }
    public String getQuizScoreRatio() {
        return quizScoreRatio;
    }
    public void setQuizScoreRatio(String quizScoreRatio) {
        this.quizScoreRatio = quizScoreRatio;
    }
    public String getReshScoreRatio() {
        return reshScoreRatio;
    }
    public void setReshScoreRatio(String reshScoreRatio) {
        this.reshScoreRatio = reshScoreRatio;
    }
    public String getUniCd() {
        return uniCd;
    }
    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }
    public String getCrsCd() {
        return crsCd;
    }
    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }
    public String getTchMobileNo() {
        return tchMobileNo;
    }
    public void setTchMobileNo(String tchMobileNo) {
        this.tchMobileNo = tchMobileNo;
    }
    public Integer getStdCnt() {
        return stdCnt;
    }
    public void setStdCnt(Integer stdCnt) {
        this.stdCnt = stdCnt;
    }
    public Integer getScoreStdCnt() {
        return scoreStdCnt;
    }
    public void setScoreStdCnt(Integer scoreStdCnt) {
        this.scoreStdCnt = scoreStdCnt;
    }
    public Integer getGradeStdCnt() {
        return gradeStdCnt;
    }
    public void setGradeStdCnt(Integer gradeStdCnt) {
        this.gradeStdCnt = gradeStdCnt;
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
    public String getMngtDeptCd() {
        return mngtDeptCd;
    }
    public void setMngtDeptCd(String mngtDeptCd) {
        this.mngtDeptCd = mngtDeptCd;
    }
    public String getUserNm() {
        return userNm;
    }
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }
    public String getSchregGbn() {
        return schregGbn;
    }
    public void setSchregGbn(String schregGbn) {
        this.schregGbn = schregGbn;
    }
    public Integer getFinalScore() {
        return finalScore;
    }
    public void setFinalScore(Integer finalScore) {
        this.finalScore = finalScore;
    }
    public String getScoreGrade() {
        return scoreGrade;
    }
    public void setScoreGrade(String scoreGrade) {
        this.scoreGrade = scoreGrade;
    }
    public String getRanking() {
        return ranking;
    }
    public void setRanking(String ranking) {
        this.ranking = ranking;
    }
    public String getStdNo() {
        return stdNo;
    }
    public void setStdNo(String stdNo) {
        this.stdNo = stdNo;
    }
    public String getTotalScoreRatio() {
        return totalScoreRatio;
    }
    public void setTotalScoreRatio(String totalScoreRatio) {
        this.totalScoreRatio = totalScoreRatio;
    }
    public String getScoreEvalTypeNm() {
        return scoreEvalTypeNm;
    }
    public void setScoreEvalTypeNm(String scoreEvalTypeNm) {
        this.scoreEvalTypeNm = scoreEvalTypeNm;
    }
    public Integer getAsmntCnt() {
        return asmntCnt;
    }
    public void setAsmntCnt(Integer asmntCnt) {
        this.asmntCnt = asmntCnt;
    }
    public Integer getForumCnt() {
        return forumCnt;
    }
    public void setForumCnt(Integer forumCnt) {
        this.forumCnt = forumCnt;
    }
    public Integer getQuizCnt() {
        return quizCnt;
    }
    public void setQuizCnt(Integer quizCnt) {
        this.quizCnt = quizCnt;
    }
    public Integer getReschCnt() {
        return reschCnt;
    }
    public void setReschCnt(Integer reschCnt) {
        this.reschCnt = reschCnt;
    }
    public Integer getTestCnt() {
        return testCnt;
    }
    public void setTestCnt(Integer testCnt) {
        this.testCnt = testCnt;
    }
    public String getCurTerm() {
        return curTerm;
    }
    public void setCurTerm(String curTerm) {
        this.curTerm = curTerm;
    }
    public Integer getMidTestCnt() {
        return midTestCnt;
    }
    public void setMidTestCnt(Integer midTestCnt) {
        this.midTestCnt = midTestCnt;
    }
    public Integer getLastTestCnt() {
        return lastTestCnt;
    }
    public void setLastTestCnt(Integer lastTestCnt) {
        this.lastTestCnt = lastTestCnt;
    }
    public String getTutNm() {
        return tutNm;
    }
    public void setTutNm(String tutNm) {
        this.tutNm = tutNm;
    }
    public String getTutNo() {
        return tutNo;
    }
    public void setTutNo(String tutNo) {
        this.tutNo = tutNo;
    }
    public List<String> getCrsCreCdList() {
        return crsCreCdList;
    }
    public void setCrsCreCdList(List<String> crsCreCdList) {
        this.crsCreCdList = crsCreCdList;
    }
    public List<String> getSchStartDtList() {
        return schStartDtList;
    }
    public void setSchStartDtList(List<String> schStartDtList) {
        this.schStartDtList = schStartDtList;
    }
    public List<String> getSchEndDtList() {
        return schEndDtList;
    }
    public void setSchEndDtList(List<String> schEndDtList) {
        this.schEndDtList = schEndDtList;
    }
    public List<String> getExcCmntList() {
        return excCmntList;
    }
    public void setExcCmntList(List<String> excCmntList) {
        this.excCmntList = excCmntList;
    }
    public String getCalculationYn() {
        return calculationYn;
    }
    public void setCalculationYn(String calculationYn) {
        this.calculationYn = calculationYn;
    }
    public String getConverstionYn() {
        return converstionYn;
    }
    public void setConverstionYn(String converstionYn) {
        this.converstionYn = converstionYn;
    }
    public String getGrantYn() {
        return grantYn;
    }
    public void setGrantYn(String grantYn) {
        this.grantYn = grantYn;
    }
    public String getTchEmail() {
        return tchEmail;
    }
    public void setTchEmail(String tchEmail) {
        this.tchEmail = tchEmail;
    }
    public Integer getScoreConversionCnt() {
        return scoreConversionCnt;
    }
    public void setScoreConversionCnt(Integer scoreConversionCnt) {
        this.scoreConversionCnt = scoreConversionCnt;
    }
    public String getExchTotScr() {
        return exchTotScr;
    }
    public void setExchTotScr(String exchTotScr) {
        this.exchTotScr = exchTotScr;
    }
    public String getUnivGbn() {
        return univGbn;
    }
    public void setUnivGbn(String univGbn) {
        this.univGbn = univGbn;
    }
    public String getUnivGbnNm() {
        return univGbnNm;
    }
    public void setUnivGbnNm(String univGbnNm) {
        this.univGbnNm = univGbnNm;
    }
}
