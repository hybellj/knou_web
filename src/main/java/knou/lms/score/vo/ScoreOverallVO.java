package knou.lms.score.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class ScoreOverallVO extends DefaultVO {
    private static final long serialVersionUID = -7487352972118621089L;

    private int pRcnt;
    private double pScr;

    private String searchValue;
    private String stdId;
    private String crsCreCd;
    private String deptNm;
    private String userMobileNo;
    private String userEmail;
    private String totScore;
    private String finalScore;
    private String lessonScore;
    private String lessonScoreRatio;
    private String lessonScoreAvg;
    private String lessonItemId;
    private String middleTestScore;
    private String middleTestScoreRatio;
    private String middleTestScoreAvg;
    private String middleTestItemId;
    private String middleTestUseYn;
    private String middleTestNoYn;
    private String lastTestScore;
    private String lastTestScoreRatio;
    private String lastTestScoreAvg;
    private String lastTestItemId;
    private String lastTestUseYn;
    private String lastTestNoYn;
    private String testScore;
    private String testScoreRatio;
    private String testScoreAvg;
    private String testItemId;
    private String assignmentScore;
    private String assignmentScoreRatio;
    private String assignmentScoreAvg;
    private String assignmentItemId;
    private String forumScore;
    private String forumScoreRatio;
    private String forumScoreAvg;
    private String forumItemId;
    private String quizScore;
    private String quizScoreRatio;
    private String quizScoreAvg;
    private String quizItemId;
    private String reshScore;
    private String reshScoreRatio;
    private String reshScoreAvg;
    private String reshItemId;

    private String etcScore;
    private String etcScoreRatio;
    private String etcScoreAvg;
    private String scoreStatus;
    private String scoreItemId;
    private String getScore;
    private String addScore;
    private String scoreGrade;
    private String scoreGrade2;

    private List<ScoreOverallListVO> list;

    private String label;
    private String cnt;
    private String selectType;

    private String avgScore;
    private String maxScore;
    private String minScore;
    private String totStdCnt;
    private String avg10Score;

    private String openYn;

    private String score50;
    private String score60;
    private String score70;
    private String score80;
    private String score90;
    private String score100;
    private String stdCount;
    private String myFinalScore;

    private String scoreItemNm;
    private String scoreTypeCd;
    private String scoreItemDesc;

    private String apprStat;
    private String[] apprStats;
    private String examStareTypeCd;
    private String apprStatM;
    private String apprStatL;
    
    private String m1;
    private String m2;
    private String l1;
    private String l2;

    private String zeroCnt;

    private String searchType;
    private String[] stdIds;
    private String[] stdIds2;

    private String haksaYear;
    private String haksaTeam;
    private String calendarCtgr;

    private String schStartDt;
    private String schEndDt;
    private String schExcStartDt;
    private String schExcEndDt;

    private String scoreObjtCd;
    private String crsNm;
    private String crsCreNm;
    private String declsNo;
    private String tchNm;
    private String assNm;

    private String stdUserId;
    private String stdUserNm;
    private String stdDeptNm;
    private String stdMobileNo;
    private String objtCtnt;
    private String objtUserId;
    private String objtDttm;
    private String procCtnt;
    private String procUserId;
    private String procDttm;

    private String modScore;
    private String modGrade;
    private String prvScore;
    private String prvGrade;

    private String objtUserNm;
    private String procUserNm;
    private String procNm;
    private String procCd;
    private String ansYn;
    private String objtDttmFmt;
    private String procDttmFmt;
    private String userGrade;

    private String compDvNm;

    private String rnkNo;
    private String profMemo;

    private String curDateFmt;
    private String curYear;
    private String curTerm;
    private String curMonth;
    private String curDay;

    private String typeCd;
    private String typeNm;
    private String score;
    private String scoreAvg;
    private String scoreRatio;

    private int lessonTotCnt;
    private int absentCnt;
    private int lateCnt;
    private String reExamCnt;
    private String fCnt;

    private String phtFile;
    private byte[] phtFileByte;
    private String phtFileDelYn;

    private String rcnt;
    private String rno;
    private String grade;
    private String markRank;

    private String calScrMidTest;
    private String calScrLastTest;
    private String calScrAsmnt;
    private String calScrLesson;
    private String calScrForum;
    private String calScrTest;
    private String calScrQuiz;
    private String calScrResh;
    private String calTotScr;

    private String exchScrMidTest;
    private String exchScrLastTest;
    private String exchScrAsmnt;
    private String exchScrLesson;
    private String exchScrForum;
    private String exchScrTest;
    private String exchScrQuiz;
    private String exchScrResh;
    private String exchTotScr;
    private String mrks;
    private String exchGapScr;
    private String flExchScr;

    private String mrksGrdGbn;

    private String scoreEvalType;
    private String uniCd;

    private String midTestScore;
    private String asmntTestScore;

    private String passYn;

    private String rowStatus;

    private String ranking;
    private String rankRCnt;
    private String rankObjYn;

    private String gridSortCol;
    private String gridSortDirection;
    private String searchTypeExcel;

    private String termCd;
    private String deptCd;

    private String profUserId;
    private String profUserNm;
    private String profMobileNo;
    private String profEmail;
    private String tutUserId;
    private String tutUserNm;

    private String mainDeptNm;
    

    private String creYear;
    private String creTerm;
    private String repeatYn;

    private String crsCd;
    private String tchUserId;
    private String tchUserNm;
    private String tchCrsCreNm;
    private String crsTypeCd;

    private String compDvCd;
    private String credit;
    private String repUserNm;
    
    private String schregGbn;
    private String schregGbnCd;
    
    private Integer evalReschCnt;
    private Integer evalReschJoinCnt;
    private String repeatCrsCd;
    
    private String reExamYnM;
    private String reExamYnL;
    
    private int midNoEvalCnt;
    private int lastNoEvalCnt;
    private int asmntNoEvalCnt;
    private int forumNoEvalCnt;
    private int quizNoEvalCnt;
    private int testNoEvalCnt;
    private int reschNoEvalCnt;
    
    private String scoreHistSn;
    private String initDttm;
    private String calDttm;
    private String chgCts;
    private String scoreSearchYn;
    private Integer scoreItemOrder;
    private String orgNm;
    private String repYn;
    private String[] sortUserIds;
    
    public String getSearchValue() {
        return searchValue;
    }

    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getDeptNm() {
        return deptNm;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
    public String getTotScore() {
        return totScore;
    }

    public void setTotScore(String totScore) {
        this.totScore = totScore;
    }

    public String getFinalScore() {
        return finalScore;
    }

    public void setFinalScore(String finalScore) {
        this.finalScore = finalScore;
    }

    public String getLessonScore() {
        return lessonScore;
    }

    public void setLessonScore(String lessonScore) {
        this.lessonScore = lessonScore;
    }

    public String getLessonScoreRatio() {
        return lessonScoreRatio;
    }

    public void setLessonScoreRatio(String lessonScoreRatio) {
        this.lessonScoreRatio = lessonScoreRatio;
    }

    public String getLessonScoreAvg() {
        return lessonScoreAvg;
    }

    public void setLessonScoreAvg(String lessonScoreAvg) {
        this.lessonScoreAvg = lessonScoreAvg;
    }

    public String getLessonItemId() {
        return lessonItemId;
    }

    public void setLessonItemId(String lessonItemId) {
        this.lessonItemId = lessonItemId;
    }

    public String getMiddleTestScore() {
        return middleTestScore;
    }

    public void setMiddleTestScore(String middleTestScore) {
        this.middleTestScore = middleTestScore;
    }

    public String getMiddleTestScoreRatio() {
        return middleTestScoreRatio;
    }

    public void setMiddleTestScoreRatio(String middleTestScoreRatio) {
        this.middleTestScoreRatio = middleTestScoreRatio;
    }

    public String getMiddleTestScoreAvg() {
        return middleTestScoreAvg;
    }

    public void setMiddleTestScoreAvg(String middleTestScoreAvg) {
        this.middleTestScoreAvg = middleTestScoreAvg;
    }

    public String getMiddleTestItemId() {
        return middleTestItemId;
    }

    public void setMiddleTestItemId(String middleTestItemId) {
        this.middleTestItemId = middleTestItemId;
    }

    public String getLastTestScore() {
        return lastTestScore;
    }

    public void setLastTestScore(String lastTestScore) {
        this.lastTestScore = lastTestScore;
    }

    public String getLastTestScoreRatio() {
        return lastTestScoreRatio;
    }

    public void setLastTestScoreRatio(String lastTestScoreRatio) {
        this.lastTestScoreRatio = lastTestScoreRatio;
    }

    public String getLastTestScoreAvg() {
        return lastTestScoreAvg;
    }

    public void setLastTestScoreAvg(String lastTestScoreAvg) {
        this.lastTestScoreAvg = lastTestScoreAvg;
    }

    public String getLastTestItemId() {
        return lastTestItemId;
    }

    public void setLastTestItemId(String lastTestItemId) {
        this.lastTestItemId = lastTestItemId;
    }

    public String getTestScore() {
        return testScore;
    }

    public void setTestScore(String testScore) {
        this.testScore = testScore;
    }

    public String getTestScoreRatio() {
        return testScoreRatio;
    }

    public void setTestScoreRatio(String testScoreRatio) {
        this.testScoreRatio = testScoreRatio;
    }

    public String getTestScoreAvg() {
        return testScoreAvg;
    }

    public void setTestScoreAvg(String testScoreAvg) {
        this.testScoreAvg = testScoreAvg;
    }

    public String getTestItemId() {
        return testItemId;
    }

    public void setTestItemId(String testItemId) {
        this.testItemId = testItemId;
    }

    public String getAssignmentScore() {
        return assignmentScore;
    }

    public void setAssignmentScore(String assignmentScore) {
        this.assignmentScore = assignmentScore;
    }

    public String getAssignmentScoreRatio() {
        return assignmentScoreRatio;
    }

    public void setAssignmentScoreRatio(String assignmentScoreRatio) {
        this.assignmentScoreRatio = assignmentScoreRatio;
    }

    public String getAssignmentScoreAvg() {
        return assignmentScoreAvg;
    }

    public void setAssignmentScoreAvg(String assignmentScoreAvg) {
        this.assignmentScoreAvg = assignmentScoreAvg;
    }

    public String getAssignmentItemId() {
        return assignmentItemId;
    }

    public void setAssignmentItemId(String assignmentItemId) {
        this.assignmentItemId = assignmentItemId;
    }

    public String getForumScore() {
        return forumScore;
    }

    public void setForumScore(String forumScore) {
        this.forumScore = forumScore;
    }

    public String getForumScoreRatio() {
        return forumScoreRatio;
    }

    public void setForumScoreRatio(String forumScoreRatio) {
        this.forumScoreRatio = forumScoreRatio;
    }

    public String getForumScoreAvg() {
        return forumScoreAvg;
    }

    public void setForumScoreAvg(String forumScoreAvg) {
        this.forumScoreAvg = forumScoreAvg;
    }

    public String getForumItemId() {
        return forumItemId;
    }

    public void setForumItemId(String forumItemId) {
        this.forumItemId = forumItemId;
    }

    public String getEtcScore() {
        return etcScore;
    }

    public void setEtcScore(String etcScore) {
        this.etcScore = etcScore;
    }

    public String getEtcScoreRatio() {
        return etcScoreRatio;
    }

    public void setEtcScoreRatio(String etcScoreRatio) {
        this.etcScoreRatio = etcScoreRatio;
    }

    public String getEtcScoreAvg() {
        return etcScoreAvg;
    }

    public void setEtcScoreAvg(String etcScoreAvg) {
        this.etcScoreAvg = etcScoreAvg;
    }

    public List<ScoreOverallListVO> getList() {
        return list;
    }

    public void setList(List<ScoreOverallListVO> list) {
        this.list = list;
    }

    public String getScoreStatus() {
        return scoreStatus;
    }

    public void setScoreStatus(String scoreStatus) {
        this.scoreStatus = scoreStatus;
    }

    public String getScoreItemId() {
        return scoreItemId;
    }

    public void setScoreItemId(String scoreItemId) {
        this.scoreItemId = scoreItemId;
    }

    public String getGetScore() {
        return getScore;
    }

    public void setGetScore(String getScore) {
        this.getScore = getScore;
    }

    public String getAddScore() {
        return addScore;
    }

    public void setAddScore(String addScore) {
        this.addScore = addScore;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getScoreGrade() {
        return scoreGrade;
    }

    public void setScoreGrade(String scoreGrade) {
        this.scoreGrade = scoreGrade;
    }

    public String getScoreGrade2() {
        return scoreGrade2;
    }

    public void setScoreGrade2(String scoreGrade2) {
        this.scoreGrade2 = scoreGrade2;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getCnt() {
        return cnt;
    }

    public void setCnt(String cnt) {
        this.cnt = cnt;
    }

    public String getSelectType() {
        return selectType;
    }

    public void setSelectType(String selectType) {
        this.selectType = selectType;
    }

    public String getAvgScore() {
        return avgScore;
    }

    public void setAvgScore(String avgScore) {
        this.avgScore = avgScore;
    }

    public String getMaxScore() {
        return maxScore;
    }

    public void setMaxScore(String maxScore) {
        this.maxScore = maxScore;
    }

    public String getMinScore() {
        return minScore;
    }

    public void setMinScore(String minScore) {
        this.minScore = minScore;
    }

    public String getTotStdCnt() {
        return totStdCnt;
    }

    public void setTotStdCnt(String totStdCnt) {
        this.totStdCnt = totStdCnt;
    }

    public String getAvg10Score() {
        return avg10Score;
    }

    public void setAvg10Score(String avg10Score) {
        this.avg10Score = avg10Score;
    }

    public String getOpenYn() {
        return openYn;
    }

    public void setOpenYn(String openYn) {
        this.openYn = openYn;
    }

    public String getScore50() {
        return score50;
    }

    public void setScore50(String score50) {
        this.score50 = score50;
    }

    public String getScore60() {
        return score60;
    }

    public void setScore60(String score60) {
        this.score60 = score60;
    }

    public String getScore70() {
        return score70;
    }

    public void setScore70(String score70) {
        this.score70 = score70;
    }

    public String getScore80() {
        return score80;
    }

    public void setScore80(String score80) {
        this.score80 = score80;
    }

    public String getScore90() {
        return score90;
    }

    public void setScore90(String score90) {
        this.score90 = score90;
    }

    public String getScore100() {
        return score100;
    }

    public void setScore100(String score100) {
        this.score100 = score100;
    }

    public String getStdCount() {
        return stdCount;
    }

    public void setStdCount(String stdCount) {
        this.stdCount = stdCount;
    }

    public String getMyFinalScore() {
        return myFinalScore;
    }

    public void setMyFinalScore(String myFinalScore) {
        this.myFinalScore = myFinalScore;
    }

    public String getScoreItemNm() {
        return scoreItemNm;
    }

    public void setScoreItemNm(String scoreItemNm) {
        this.scoreItemNm = scoreItemNm;
    }

    public String getScoreTypeCd() {
        return scoreTypeCd;
    }

    public void setScoreTypeCd(String scoreTypeCd) {
        this.scoreTypeCd = scoreTypeCd;
    }

    public String getScoreItemDesc() {
        return scoreItemDesc;
    }

    public void setScoreItemDesc(String scoreItemDesc) {
        this.scoreItemDesc = scoreItemDesc;
    }

    public String getApprStat() {
        return apprStat;
    }

    public void setApprStat(String apprStat) {
        this.apprStat = apprStat;
    }

    public String[] getApprStats() {
        return apprStats;
    }

    public void setApprStats(String[] apprStats) {
        this.apprStats = apprStats;
    }

    public String getExamStareTypeCd() {
        return examStareTypeCd;
    }

    public void setExamStareTypeCd(String examStareTypeCd) {
        this.examStareTypeCd = examStareTypeCd;
    }

    public String getM1() {
        return m1;
    }

    public void setM1(String m1) {
        this.m1 = m1;
    }

    public String getM2() {
        return m2;
    }

    public void setM2(String m2) {
        this.m2 = m2;
    }

    public String getL1() {
        return l1;
    }

    public void setL1(String l1) {
        this.l1 = l1;
    }

    public String getL2() {
        return l2;
    }

    public void setL2(String l2) {
        this.l2 = l2;
    }

    public String getZeroCnt() {
        return zeroCnt;
    }

    public void setZeroCnt(String zeroCnt) {
        this.zeroCnt = zeroCnt;
    }

    public String getSearchType() {
        return searchType;
    }

    public void setSearchType(String searchType) {
        this.searchType = searchType;
    }

    public String[] getStdIds() {
        return stdIds;
    }

    public void setStdIds(String[] stdIds) {
        this.stdIds = stdIds;
    }

    public String getUserMobileNo() {
        return userMobileNo;
    }

    public void setUserMobileNo(String userMobileNo) {
        this.userMobileNo = userMobileNo;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getHaksaYear() {
        return haksaYear;
    }

    public void setHaksaYear(String haksaYear) {
        this.haksaYear = haksaYear;
    }

    public String getHaksaTeam() {
        return haksaTeam;
    }

    public void setHaksaTeam(String haksaTeam) {
        this.haksaTeam = haksaTeam;
    }

    public String getCalendarCtgr() {
        return calendarCtgr;
    }

    public void setCalendarCtgr(String calendarCtgr) {
        this.calendarCtgr = calendarCtgr;
    }

    public String getSchStartDt() {
        return schStartDt;
    }

    public void setSchStartDt(String schStartDt) {
        this.schStartDt = schStartDt;
    }

    public String getSchEndDt() {
        return schEndDt;
    }

    public void setSchEndDt(String schEndDt) {
        this.schEndDt = schEndDt;
    }

    public String getSchExcStartDt() {
        return schExcStartDt;
    }

    public void setSchExcStartDt(String schExcStartDt) {
        this.schExcStartDt = schExcStartDt;
    }

    public String getSchExcEndDt() {
        return schExcEndDt;
    }

    public void setSchExcEndDt(String schExcEndDt) {
        this.schExcEndDt = schExcEndDt;
    }

    public String getCrsNm() {
        return crsNm;
    }

    public void setCrsNm(String crsNm) {
        this.crsNm = crsNm;
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

    public String getTchNm() {
        return tchNm;
    }

    public void setTchNm(String tchNm) {
        this.tchNm = tchNm;
    }

    public String getAssNm() {
        return assNm;
    }

    public void setAssNm(String assNm) {
        this.assNm = assNm;
    }

    public String getStdUserId() {
        return stdUserId;
    }

    public void setStdUserId(String stdUserId) {
        this.stdUserId = stdUserId;
    }

    public String getStdUserNm() {
        return stdUserNm;
    }

    public void setStdUserNm(String stdUserNm) {
        this.stdUserNm = stdUserNm;
    }

    public String getStdDeptNm() {
        return stdDeptNm;
    }

    public void setStdDeptNm(String stdDeptNm) {
        this.stdDeptNm = stdDeptNm;
    }

    public String getStdMobileNo() {
        return stdMobileNo;
    }

    public void setStdMobileNo(String stdMobileNo) {
        this.stdMobileNo = stdMobileNo;
    }

    public String getObjtCtnt() {
        return objtCtnt;
    }

    public void setObjtCtnt(String objtCtnt) {
        this.objtCtnt = objtCtnt;
    }

    public String getScoreObjtCd() {
        return scoreObjtCd;
    }

    public void setScoreObjtCd(String scoreObjtCd) {
        this.scoreObjtCd = scoreObjtCd;
    }

    public String getObjtUserId() {
        return objtUserId;
    }

    public void setObjtUserId(String objtUserId) {
        this.objtUserId = objtUserId;
    }

    public String getObjtDttm() {
        return objtDttm;
    }

    public void setObjtDttm(String objtDttm) {
        this.objtDttm = objtDttm;
    }

    public String getProcCtnt() {
        return procCtnt;
    }

    public void setProcCtnt(String procCtnt) {
        this.procCtnt = procCtnt;
    }

    public String getProcUserId() {
        return procUserId;
    }

    public void setProcUserId(String procUserId) {
        this.procUserId = procUserId;
    }

    public String getProcDttm() {
        return procDttm;
    }

    public void setProcDttm(String procDttm) {
        this.procDttm = procDttm;
    }

    public String getModScore() {
        return modScore;
    }

    public void setModScore(String modScore) {
        this.modScore = modScore;
    }

    public String getModGrade() {
        return modGrade;
    }

    public void setModGrade(String modGrade) {
        this.modGrade = modGrade;
    }

    public String getPrvScore() {
        return prvScore;
    }

    public void setPrvScore(String prvScore) {
        this.prvScore = prvScore;
    }

    public String getPrvGrade() {
        return prvGrade;
    }

    public void setPrvGrade(String prvGrade) {
        this.prvGrade = prvGrade;
    }

    public String getObjtUserNm() {
        return objtUserNm;
    }

    public void setObjtUserNm(String objtUserNm) {
        this.objtUserNm = objtUserNm;
    }

    public String getProcUserNm() {
        return procUserNm;
    }

    public void setProcUserNm(String procUserNm) {
        this.procUserNm = procUserNm;
    }

    public String getProcNm() {
        return procNm;
    }

    public void setProcNm(String procNm) {
        this.procNm = procNm;
    }

    public String getProcCd() {
        return procCd;
    }

    public void setProcCd(String procCd) {
        this.procCd = procCd;
    }

    public String getAnsYn() {
        return ansYn;
    }

    public void setAnsYn(String ansYn) {
        this.ansYn = ansYn;
    }

    public String getObjtDttmFmt() {
        return objtDttmFmt;
    }

    public void setObjtDttmFmt(String objtDttmFmt) {
        this.objtDttmFmt = objtDttmFmt;
    }

    public String getProcDttmFmt() {
        return procDttmFmt;
    }

    public void setProcDttmFmt(String procDttmFmt) {
        this.procDttmFmt = procDttmFmt;
    }

    public String getUserGrade() {
        return userGrade;
    }

    public void setUserGrade(String userGrade) {
        this.userGrade = userGrade;
    }

    public String getCompDvNm() {
        return compDvNm;
    }

    public void setCompDvNm(String compDvNm) {
        this.compDvNm = compDvNm;
    }

    public String getRnkNo() {
        return rnkNo;
    }

    public void setRnkNo(String rnkNo) {
        this.rnkNo = rnkNo;
    }

    public String getProfMemo() {
        return profMemo;
    }

    public void setProfMemo(String profMemo) {
        this.profMemo = profMemo;
    }

    public String getCurDateFmt() {
        return curDateFmt;
    }

    public void setCurDateFmt(String curDateFmt) {
        this.curDateFmt = curDateFmt;
    }

    public String getCurYear() {
        return curYear;
    }

    public void setCurYear(String curYear) {
        this.curYear = curYear;
    }

    public String getCurMonth() {
        return curMonth;
    }

    public void setCurMonth(String curMonth) {
        this.curMonth = curMonth;
    }

    public String getCurDay() {
        return curDay;
    }

    public void setCurDay(String curDay) {
        this.curDay = curDay;
    }

    public String getQuizScore() {
        return quizScore;
    }

    public void setQuizScore(String quizScore) {
        this.quizScore = quizScore;
    }

    public String getQuizScoreRatio() {
        return quizScoreRatio;
    }

    public void setQuizScoreRatio(String quizScoreRatio) {
        this.quizScoreRatio = quizScoreRatio;
    }

    public String getQuizScoreAvg() {
        return quizScoreAvg;
    }

    public void setQuizScoreAvg(String quizScoreAvg) {
        this.quizScoreAvg = quizScoreAvg;
    }

    public String getQuizItemId() {
        return quizItemId;
    }

    public void setQuizItemId(String quizItemId) {
        this.quizItemId = quizItemId;
    }

    public String getReshScore() {
        return reshScore;
    }

    public void setReshScore(String reshScore) {
        this.reshScore = reshScore;
    }

    public String getReshScoreRatio() {
        return reshScoreRatio;
    }

    public void setReshScoreRatio(String reshScoreRatio) {
        this.reshScoreRatio = reshScoreRatio;
    }

    public String getReshScoreAvg() {
        return reshScoreAvg;
    }

    public void setReshScoreAvg(String reshScoreAvg) {
        this.reshScoreAvg = reshScoreAvg;
    }

    public String getReshItemId() {
        return reshItemId;
    }

    public void setReshItemId(String reshItemId) {
        this.reshItemId = reshItemId;
    }

    public String getTypeCd() {
        return typeCd;
    }

    public void setTypeCd(String typeCd) {
        this.typeCd = typeCd;
    }

    public String getTypeNm() {
        return typeNm;
    }

    public void setTypeNm(String typeNm) {
        this.typeNm = typeNm;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    public String getScoreAvg() {
        return scoreAvg;
    }

    public void setScoreAvg(String scoreAvg) {
        this.scoreAvg = scoreAvg;
    }

    public String getScoreRatio() {
        return scoreRatio;
    }

    public void setScoreRatio(String scoreRatio) {
        this.scoreRatio = scoreRatio;
    }

    public int getLessonTotCnt() {
        return lessonTotCnt;
    }

    public void setLessonTotCnt(int lessonTotCnt) {
        this.lessonTotCnt = lessonTotCnt;
    }

    public int getAbsentCnt() {
        return absentCnt;
    }

    public void setAbsentCnt(int absentCnt) {
        this.absentCnt = absentCnt;
    }

    public int getLateCnt() {
        return lateCnt;
    }

    public void setLateCnt(int lateCnt) {
        this.lateCnt = lateCnt;
    }

    public String getPhtFile() {
        return phtFile;
    }

    public void setPhtFile(String phtFile) {
        this.phtFile = phtFile;
    }

    public byte[] getPhtFileByte() {
        return phtFileByte;
    }

    public void setPhtFileByte(byte[] phtFileByte) {
        this.phtFileByte = phtFileByte;
    }

    public String getPhtFileDelYn() {
        return phtFileDelYn;
    }

    public void setPhtFileDelYn(String phtFileDelYn) {
        this.phtFileDelYn = phtFileDelYn;
    }

    public String getRcnt() {
        return rcnt;
    }

    public void setRcnt(String rcnt) {
        this.rcnt = rcnt;
    }

    public String getRno() {
        return rno;
    }

    public void setRno(String rno) {
        this.rno = rno;
    }

    public String getMarkRank() {
        return markRank;
    }

    public void setMarkRank(String markRank) {
        this.markRank = markRank;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public String getCalTotScr() {
        return calTotScr;
    }

    public void setCalTotScr(String calTotScr) {
        this.calTotScr = calTotScr;
    }

    public String getExchScrMidTest() {
        return exchScrMidTest;
    }

    public void setExchScrMidTest(String exchScrMidTest) {
        this.exchScrMidTest = exchScrMidTest;
    }

    public String getExchScrLastTest() {
        return exchScrLastTest;
    }

    public void setExchScrLastTest(String exchScrLastTest) {
        this.exchScrLastTest = exchScrLastTest;
    }

    public String getExchScrAsmnt() {
        return exchScrAsmnt;
    }

    public void setExchScrAsmnt(String exchScrAsmnt) {
        this.exchScrAsmnt = exchScrAsmnt;
    }

    public String getExchScrLesson() {
        return exchScrLesson;
    }

    public void setExchScrLesson(String exchScrLesson) {
        this.exchScrLesson = exchScrLesson;
    }

    public String getExchScrForum() {
        return exchScrForum;
    }

    public void setExchScrForum(String exchScrForum) {
        this.exchScrForum = exchScrForum;
    }

    public String getExchScrTest() {
        return exchScrTest;
    }

    public void setExchScrTest(String exchScrTest) {
        this.exchScrTest = exchScrTest;
    }

    public String getExchScrQuiz() {
        return exchScrQuiz;
    }

    public void setExchScrQuiz(String exchScrQuiz) {
        this.exchScrQuiz = exchScrQuiz;
    }

    public String getExchScrResh() {
        return exchScrResh;
    }

    public void setExchScrResh(String exchScrResh) {
        this.exchScrResh = exchScrResh;
    }

    public String getMrks() {
        return mrks;
    }

    public void setMrks(String mrks) {
        this.mrks = mrks;
    }

    public String getExchGapScr() {
        return exchGapScr;
    }

    public void setExchGapScr(String exchGapScr) {
        this.exchGapScr = exchGapScr;
    }

    public String getExchTotScr() {
        return exchTotScr;
    }

    public void setExchTotScr(String exchTotScr) {
        this.exchTotScr = exchTotScr;
    }

    public String getScoreEvalType() {
        return scoreEvalType;
    }

    public void setScoreEvalType(String scoreEvalType) {
        this.scoreEvalType = scoreEvalType;
    }

    public String getUniCd() {
        return uniCd;
    }

    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }

    public String getFlExchScr() {
        return flExchScr;
    }

    public void setFlExchScr(String flExchScr) {
        this.flExchScr = flExchScr;
    }

    public String getMrksGrdGbn() {
        return mrksGrdGbn;
    }

    public void setMrksGrdGbn(String mrksGrdGbn) {
        this.mrksGrdGbn = mrksGrdGbn;
    }

    public int getpRcnt() {
        return pRcnt;
    }

    public void setpRcnt(int pRcnt) {
        this.pRcnt = pRcnt;
    }

    public double getpScr() {
        return pScr;
    }

    public void setpScr(double pScr) {
        this.pScr = pScr;
    }

    public String getMidTestScore() {
        return midTestScore;
    }

    public void setMidTestScore(String midTestScore) {
        this.midTestScore = midTestScore;
    }

    public String getAsmntTestScore() {
        return asmntTestScore;
    }

    public void setAsmntTestScore(String asmntTestScore) {
        this.asmntTestScore = asmntTestScore;
    }

    public String getPassYn() {
        return passYn;
    }

    public void setPassYn(String passYn) {
        this.passYn = passYn;
    }

    public String[] getStdIds2() {
        return stdIds2;
    }

    public void setStdIds2(String[] stdIds2) {
        this.stdIds2 = stdIds2;
    }

    public String getRowStatus() {
        return rowStatus;
    }

    public void setRowStatus(String rowStatus) {
        this.rowStatus = rowStatus;
    }

    public String getRanking() {
        return ranking;
    }

    public void setRanking(String ranking) {
        this.ranking = ranking;
    }

    public String getRankRCnt() {
        return rankRCnt;
    }

    public void setRankRCnt(String rankRCnt) {
        this.rankRCnt = rankRCnt;
    }

    public String getRankObjYn() {
        return rankObjYn;
    }

    public void setRankObjYn(String rankObjYn) {
        this.rankObjYn = rankObjYn;
    }

    public String getCalScrMidTest() {
        return calScrMidTest;
    }

    public void setCalScrMidTest(String calScrMidTest) {
        this.calScrMidTest = calScrMidTest;
    }

    public String getCalScrLastTest() {
        return calScrLastTest;
    }

    public void setCalScrLastTest(String calScrLastTest) {
        this.calScrLastTest = calScrLastTest;
    }

    public String getCalScrAsmnt() {
        return calScrAsmnt;
    }

    public void setCalScrAsmnt(String calScrAsmnt) {
        this.calScrAsmnt = calScrAsmnt;
    }

    public String getCalScrLesson() {
        return calScrLesson;
    }

    public void setCalScrLesson(String calScrLesson) {
        this.calScrLesson = calScrLesson;
    }

    public String getCalScrForum() {
        return calScrForum;
    }

    public void setCalScrForum(String calScrForum) {
        this.calScrForum = calScrForum;
    }

    public String getCalScrTest() {
        return calScrTest;
    }

    public void setCalScrTest(String calScrTest) {
        this.calScrTest = calScrTest;
    }

    public String getCalScrQuiz() {
        return calScrQuiz;
    }

    public void setCalScrQuiz(String calScrQuiz) {
        this.calScrQuiz = calScrQuiz;
    }

    public String getCalScrResh() {
        return calScrResh;
    }

    public void setCalScrResh(String calScrResh) {
        this.calScrResh = calScrResh;
    }

    public String getGridSortCol() {
        return gridSortCol;
    }

    public void setGridSortCol(String gridSortCol) {
        this.gridSortCol = gridSortCol;
    }

    public String getGridSortDirection() {
        return gridSortDirection;
    }

    public void setGridSortDirection(String gridSortDirection) {
        this.gridSortDirection = gridSortDirection;
    }

    public String getSearchTypeExcel() {
        return searchTypeExcel;
    }

    public void setSearchTypeExcel(String searchTypeExcel) {
        this.searchTypeExcel = searchTypeExcel;
    }

    public String getTermCd() {
        return termCd;
    }

    public void setTermCd(String termCd) {
        this.termCd = termCd;
    }

    public String getDeptCd() {
        return deptCd;
    }

    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }

    public String getProfUserId() {
        return profUserId;
    }

    public void setProfUserId(String profUserId) {
        this.profUserId = profUserId;
    }

    public String getProfUserNm() {
        return profUserNm;
    }

    public void setProfUserNm(String profUserNm) {
        this.profUserNm = profUserNm;
    }

    public String getProfMobileNo() {
        return profMobileNo;
    }

    public void setProfMobileNo(String profMobileNo) {
        this.profMobileNo = profMobileNo;
    }

    public String getProfEmail() {
        return profEmail;
    }

    public void setProfEmail(String profEmail) {
        this.profEmail = profEmail;
    }

    public String getMainDeptNm() {
        return mainDeptNm;
    }

    public void setMainDeptNm(String mainDeptNm) {
        this.mainDeptNm = mainDeptNm;
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

    public String getCrsCd() {
        return crsCd;
    }

    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }

    public String getTchUserId() {
        return tchUserId;
    }

    public void setTchUserId(String tchUserId) {
        this.tchUserId = tchUserId;
    }

    public String getTchUserNm() {
        return tchUserNm;
    }

    public void setTchUserNm(String tchUserNm) {
        this.tchUserNm = tchUserNm;
    }

    public String getTchCrsCreNm() {
        return tchCrsCreNm;
    }

    public void setTchCrsCreNm(String tchCrsCreNm) {
        this.tchCrsCreNm = tchCrsCreNm;
    }

    public String getCompDvCd() {
        return compDvCd;
    }

    public void setCompDvCd(String compDvCd) {
        this.compDvCd = compDvCd;
    }

    public String getCredit() {
        return credit;
    }

    public void setCredit(String credit) {
        this.credit = credit;
    }

    public String getRepUserNm() {
        return repUserNm;
    }

    public void setRepUserNm(String repUserNm) {
        this.repUserNm = repUserNm;
    }

    public String getSchregGbn() {
        return schregGbn;
    }

    public void setSchregGbn(String schregGbn) {
        this.schregGbn = schregGbn;
    }

    public String getSchregGbnCd() {
        return schregGbnCd;
    }

    public void setSchregGbnCd(String schregGbnCd) {
        this.schregGbnCd = schregGbnCd;
    }

    public Integer getEvalReschCnt() {
        return evalReschCnt;
    }

    public void setEvalReschCnt(Integer evalReschCnt) {
        this.evalReschCnt = evalReschCnt;
    }

    public Integer getEvalReschJoinCnt() {
        return evalReschJoinCnt;
    }

    public void setEvalReschJoinCnt(Integer evalReschJoinCnt) {
        this.evalReschJoinCnt = evalReschJoinCnt;
    }

    public String getCurTerm() {
        return curTerm;
    }

    public void setCurTerm(String curTerm) {
        this.curTerm = curTerm;
    }

    public String getRepeatYn() {
        return repeatYn;
    }

    public void setRepeatYn(String repeatYn) {
        this.repeatYn = repeatYn;
    }

    public String getRepeatCrsCd() {
        return repeatCrsCd;
    }

    public void setRepeatCrsCd(String repeatCrsCd) {
        this.repeatCrsCd = repeatCrsCd;
    }

    public String getApprStatM() {
        return apprStatM;
    }

    public void setApprStatM(String apprStatM) {
        this.apprStatM = apprStatM;
    }

    public String getApprStatL() {
        return apprStatL;
    }

    public void setApprStatL(String apprStatL) {
        this.apprStatL = apprStatL;
    }

    public String getReExamYnM() {
        return reExamYnM;
    }

    public void setReExamYnM(String reExamYnM) {
        this.reExamYnM = reExamYnM;
    }

    public String getReExamYnL() {
        return reExamYnL;
    }

    public void setReExamYnL(String reExamYnL) {
        this.reExamYnL = reExamYnL;
    }

    public String getReExamCnt() {
        return reExamCnt;
    }

    public void setReExamCnt(String reExamCnt) {
        this.reExamCnt = reExamCnt;
    }

    public int getAsmntNoEvalCnt() {
        return asmntNoEvalCnt;
    }

    public void setAsmntNoEvalCnt(int asmntNoEvalCnt) {
        this.asmntNoEvalCnt = asmntNoEvalCnt;
    }

    public int getForumNoEvalCnt() {
        return forumNoEvalCnt;
    }

    public void setForumNoEvalCnt(int forumNoEvalCnt) {
        this.forumNoEvalCnt = forumNoEvalCnt;
    }

    public int getQuizNoEvalCnt() {
        return quizNoEvalCnt;
    }

    public void setQuizNoEvalCnt(int quizNoEvalCnt) {
        this.quizNoEvalCnt = quizNoEvalCnt;
    }

    public int getReschNoEvalCnt() {
        return reschNoEvalCnt;
    }

    public void setReschNoEvalCnt(int reschNoEvalCnt) {
        this.reschNoEvalCnt = reschNoEvalCnt;
    }

    public int getTestNoEvalCnt() {
        return testNoEvalCnt;
    }

    public void setTestNoEvalCnt(int testNoEvalCnt) {
        this.testNoEvalCnt = testNoEvalCnt;
    }

    public int getMidNoEvalCnt() {
        return midNoEvalCnt;
    }

    public void setMidNoEvalCnt(int midNoEvalCnt) {
        this.midNoEvalCnt = midNoEvalCnt;
    }

    public int getLastNoEvalCnt() {
        return lastNoEvalCnt;
    }

    public void setLastNoEvalCnt(int lastNoEvalCnt) {
        this.lastNoEvalCnt = lastNoEvalCnt;
    }

    public String getCrsTypeCd() {
        return crsTypeCd;
    }

    public void setCrsTypeCd(String crsTypeCd) {
        this.crsTypeCd = crsTypeCd;
    }

    public String getInitDttm() {
        return initDttm;
    }

    public void setInitDttm(String initDttm) {
        this.initDttm = initDttm;
    }

    public String getCalDttm() {
        return calDttm;
    }

    public void setCalDttm(String calDttm) {
        this.calDttm = calDttm;
    }

    public String getChgCts() {
        return chgCts;
    }

    public void setChgCts(String chgCts) {
        this.chgCts = chgCts;
    }

    public String getScoreSearchYn() {
        return scoreSearchYn;
    }

    public void setScoreSearchYn(String scoreSearchYn) {
        this.scoreSearchYn = scoreSearchYn;
    }

    public Integer getScoreItemOrder() {
        return scoreItemOrder;
    }

    public void setScoreItemOrder(Integer scoreItemOrder) {
        this.scoreItemOrder = scoreItemOrder;
    }

    public String getTutUserId() {
        return tutUserId;
    }

    public void setTutUserId(String tutUserId) {
        this.tutUserId = tutUserId;
    }

    public String getTutUserNm() {
        return tutUserNm;
    }

    public void setTutUserNm(String tutUserNm) {
        this.tutUserNm = tutUserNm;
    }

    public String getOrgNm() {
        return orgNm;
    }

    public void setOrgNm(String orgNm) {
        this.orgNm = orgNm;
    }

    public String getRepYn() {
        return repYn;
    }

    public void setRepYn(String repYn) {
        this.repYn = repYn;
    }

    public String getfCnt() {
        return fCnt;
    }

    public void setfCnt(String fCnt) {
        this.fCnt = fCnt;
    }

    public String[] getSortUserIds() {
        return sortUserIds;
    }

    public void setSortUserIds(String[] sortUserIds) {
        this.sortUserIds = sortUserIds;
    }

    public String getMiddleTestUseYn() {
        return middleTestUseYn;
    }

    public void setMiddleTestUseYn(String middleTestUseYn) {
        this.middleTestUseYn = middleTestUseYn;
    }

    public String getLastTestUseYn() {
        return lastTestUseYn;
    }

    public void setLastTestUseYn(String lastTestUseYn) {
        this.lastTestUseYn = lastTestUseYn;
    }

    public String getMiddleTestNoYn() {
        return middleTestNoYn;
    }

    public void setMiddleTestNoYn(String middleTestNoYn) {
        this.middleTestNoYn = middleTestNoYn;
    }

    public String getLastTestNoYn() {
        return lastTestNoYn;
    }

    public void setLastTestNoYn(String lastTestNoYn) {
        this.lastTestNoYn = lastTestNoYn;
    }

	public String getScoreHistSn() {
		return scoreHistSn;
	}

	public void setScoreHistSn(String scoreHistSn) {
		this.scoreHistSn = scoreHistSn;
	}

}