package knou.lms.lesson.vo;

import knou.lms.common.vo.DefaultVO;

public class LessonProgVO extends DefaultVO {

    private static final long serialVersionUID = -1489436137658347717L;

    private String lineNo;
    
    private String sbjctYr;
    private String sbjctSmstr;
    private String smstrChrtId;
    private String sbjctOfrngId;
    
    private String declsNo;
    private String deptId;
    private String deptnm;
    
    private String initYn;
    private String progressCd;
    
    private String majorUserNm;
    private String majorUserId;
    private String tripleUserNm;
    private String tripleUserId;
    private String minorUserNm;
    private String minorUserId;
    
    private String stdCnt;
    
    private String qnaCnt;
    private String qnaAnsCnt;
    private String qnaNoAnsCnt;
    
    private String secretCnt;
    private String secretAnsCnt;
    private String secretNoAnsCnt;
    
    private String asmntTitle;
    private String sendStartDttm;
    private String sendEndDttm;
    private String extSendDttm;
    private String asmntCnt;
    private String asmntSubmitCnt;
    private String asmntNoSubmitCnt;
    private String asmntEvalCnt;
    private String asmntNoEvalCnt;
    private String asmntAnsCnt;
    private String asmntNoAnsCnt;
    
    private String forumTitle;
    private String forumStartDttm;
    private String forumEndDttm;
    private String extEndDttm;
    private String forumCnt;
    private String forumAnsCnt;
    private String forumNoAnsCnt;
    private String forumEvalCnt;
    private String forumSubmitCnt;
    
    private String examTitle;
    private String examStartDttm;
    private String examEndDttm;
    // private String extSendDttm;
    private String quizCnt;
    private String quizAnsCnt;
    private String quizNoAnsCnt;
    private String quizEvalCnt;
    private String quizSubmitCnt;
        
    private String altaskCnt;
    private String altaskAsmntSubmtCnt;
    private String altaskForumAnsCnt;
    private String altaskExamAnsCnt;

    private String reschTitle;
    private String reschStartDttm;
    private String reschEndDttm;
    // private String extEndDttm;
    private String reschEvalCnt;
    private String reschCnt;
    
    private int lessonCnt = 0;
    private String lectureComments;
    
    private String middleStartDttm;
    private String middleEndDttm;
    private String middleExamStareTm;
    private String middleGradeViewNm;
    private String middleScoreOpenNm;
    private String lastStartDttm;
    private String lastEndDttm;
    private String lastExamStareTm;
    private String lastGradeViewNm;
    private String lastScoreOpenNm;

    private String scoreEvalGbn;    // 평가구분
    private String scoreGrantGbn;   // 성적부여방법
    
    private String userNmEng;
    private String mobileNo;
    private String email;
    private String userSts;
    private String userStsNm;
    private String userType;
    private String userTypeNm;
    private String lastLoginDttm;
    private String loginCnt;
    private String snsDiv;
    private String snsKey;
    
    private String crsTypeCds;
    private String[] crsTypeCdList;


    public String getLineNo() {
        return lineNo;
    }
    public void setLineNo(String lineNo) {
        this.lineNo = lineNo;
    }
    public String getSbjctYr() {
        return sbjctYr;
    }
    public void setSbjctYr(String sbjctYr) {
        this.sbjctYr = sbjctYr;
    }
    
    public String getSbjctSmstr() {
        return sbjctSmstr;
    }
    public void setSbjctSmstr(String sbjctSmstr) {
        this.sbjctSmstr = sbjctSmstr;
    }
    
    public String getSmstrChrtId() {
		return smstrChrtId;
	}
	public void setSmstrChrtId(String sbjctSmstrId) {
		this.smstrChrtId = sbjctSmstrId;
	}
	public String getSbjctOfrngId() {
		return sbjctOfrngId;
	}
	public void setSbjctOfrngId(String sbjctOfrngId) {
		this.sbjctOfrngId = sbjctOfrngId;
	}
	public String getDeclsNo() {
        return declsNo;
    }
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }
    
    public String getDeptId() {
        return deptId;
    }
    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }
    
    public String getDeptnm() {
        return deptnm;
    }
    public void setDeptnm(String deptnm) {
        this.deptnm = deptnm;
    }
    
    public String getProgressCd() {
        return progressCd;
    }
    public void setProgressCd(String progressCd) {
        this.progressCd = progressCd;
    }
    
    public String getMajorUserNm() {
        return majorUserNm;
    }
    public void setMajorUserNm(String majorUserNm) {
        this.majorUserNm = majorUserNm;
    }
    
    public String getMajorUserId() {
        return majorUserId;
    }
    public void setMajorUserId(String majorUserId) {
        this.majorUserId = majorUserId;
    }
    
    public String getTripleUserNm() {
        return tripleUserNm;
    }
    public void setTripleUserNm(String tripleUserNm) {
        this.tripleUserNm = tripleUserNm;
    }

    public String getTripleUserId() {
        return tripleUserId;
    }
    public void setTripleUserId(String tripleUserId) {
        this.tripleUserId = tripleUserId;
    }
    
    public String getMinorUserNm() {
        return minorUserNm;
    }
    public void setMinorUserNm(String minorUserNm) {
        this.minorUserNm = minorUserNm;
    }
    
    public String getMinorUserId() {
        return minorUserId;
    }
    public void setMinorUserId(String minorUserId) {
        this.minorUserId = minorUserId;
    }
    
    public String getStdCnt() {
        return stdCnt;
    }
    public void setStdCnt(String stdCnt) {
        this.stdCnt = stdCnt;
    }
    
    public String getQnaCnt() {
        return qnaCnt;
    }
    public void setQnaCnt(String qnaCnt) {
        this.qnaCnt = qnaCnt;
    }
    
    public String getQnaAnsCnt() {
        return qnaAnsCnt;
    }
    public void setQnaAnsCnt(String qnaAnsCnt) {
        this.qnaAnsCnt = qnaAnsCnt;
    }
    
    public String getQnaNoAnsCnt() {
        return qnaNoAnsCnt;
    }
    public void setQnaNoAnsCnt(String qnaNoAnsCnt) {
        this.qnaNoAnsCnt = qnaNoAnsCnt;
    }
    
    public String getSecretCnt() {
        return secretCnt;
    }
    public void setSecretCnt(String secretCnt) {
        this.secretCnt = secretCnt;
    }
    
    public String getSecretAnsCnt() {
        return secretAnsCnt;
    }
    public void setSecretAnsCnt(String secretAnsCnt) {
        this.secretAnsCnt = secretAnsCnt;
    }
    
    
    public String getSecretNoAnsCnt() {
        return secretNoAnsCnt;
    }
    public void setSecretNoAnsCnt(String secretNoAnsCnt) {
        this.secretNoAnsCnt = secretNoAnsCnt;
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

    public String getExtSendDttm() {
        return extSendDttm;
    }
    public void setExtSendDttm(String extSendDttm) {
        this.extSendDttm = extSendDttm;
    }

    
    public String getAsmntCnt() {
        return asmntCnt;
    }
    public void setAsmntCnt(String asmntCnt) {
        this.asmntCnt = asmntCnt;
    }
    
    public String getAsmntSubmitCnt() {
        return asmntSubmitCnt;
    }
    public void setAsmntSubmitCnt(String asmntSubmitCnt) {
        this.asmntSubmitCnt = asmntSubmitCnt;
    }
    
    public String getAsmntNoSubmitCnt() {
        return asmntNoSubmitCnt;
    }
    public void setAsmntNoSubmitCnt(String asmntNoSubmitCnt) {
        this.asmntNoSubmitCnt = asmntNoSubmitCnt;
    }
    
    public String getAsmntEvalCnt() {
        return asmntEvalCnt;
    }
    public void setAsmntEvalCnt(String asmntEvalCnt) {
        this.asmntEvalCnt = asmntEvalCnt;
    }
    
    public String getAsmntNoEvalCnt() {
        return asmntNoEvalCnt;
    }
    public void setAsmntNoEvalCnt(String asmntNoEvalCnt) {
        this.asmntNoEvalCnt = asmntNoEvalCnt;
    }
    
    public String getAsmntAnsCnt() {
        return asmntAnsCnt;
    }
    public void setAsmntAnsCnt(String asmntAnsCnt) {
        this.asmntAnsCnt = asmntAnsCnt;
    }
    
    public String getAsmntNoAnsCnt() {
        return asmntNoAnsCnt;
    }
    public void setAsmntNoAnsCnt(String asmntNoAnsCnt) {
        this.asmntNoAnsCnt = asmntNoAnsCnt;
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
    
    public String getExtEndDttm() {
        return extEndDttm;
    }
    public void setExtEndDttm(String extEndDttm) {
        this.extEndDttm = extEndDttm;
    }

    public String getForumCnt() {
        return forumCnt;
    }
    public void setForumCnt(String forumCnt) {
        this.forumCnt = forumCnt;
    }
    
    public String getForumAnsCnt() {
        return forumAnsCnt;
    }
    public void setForumAnsCnt(String forumAnsCnt) {
        this.forumAnsCnt = forumAnsCnt;
    }
    
    public String getForumNoAnsCnt() {
        return forumNoAnsCnt;
    }
    public void setForumNoAnsCnt(String forumNoAnsCnt) {
        this.forumNoAnsCnt = forumNoAnsCnt;
    }
    
    public String getForumEvalCnt() {
        return forumEvalCnt;
    }
    public void setForumEvalCnt(String forumEvalCnt) {
        this.forumEvalCnt = forumEvalCnt;
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
    
    public String getQuizCnt() {
        return quizCnt;
    }
    public void setQuizCnt(String quizCnt) {
        this.quizCnt = quizCnt;
    }
    
    public String getQuizAnsCnt() {
        return quizAnsCnt;
    }
    public void setQuizAnsCnt(String quizAnsCnt) {
        this.quizAnsCnt = quizAnsCnt;
    }
    
    public String getQuizNoAnsCnt() {
        return quizNoAnsCnt;
    }
    public void setQuizNoAnsCnt(String quizNoAnsCnt) {
        this.quizNoAnsCnt = quizNoAnsCnt;
    }
    
    public String getQuizEvalCnt() {
        return quizEvalCnt;
    }
    public void setQuizEvalCnt(String quizEvalCnt) {
        this.quizEvalCnt = quizEvalCnt;
    }
    
    public String getAltaskCnt() {
        return altaskCnt;
    }
    public void setAltaskCnt(String altaskCnt) {
        this.altaskCnt = altaskCnt;
    }
    
    public String getAltaskAsmntSubmtCnt() {
        return altaskAsmntSubmtCnt;
    }
    public void setAltaskAsmntSubmtCnt(String altaskAsmntSubmtCnt) {
        this.altaskAsmntSubmtCnt = altaskAsmntSubmtCnt;
    }
    
    public String getAltaskForumAnsCnt() {
        return altaskForumAnsCnt;
    }
    public void setAltaskForumAnsCnt(String altaskForumAnsCnt) {
        this.altaskForumAnsCnt = altaskForumAnsCnt;
    }
    
    public String getAltaskExamAnsCnt() {
        return altaskExamAnsCnt;
    }
    public void setAltaskExamAnsCnt(String altaskExamAnsCnt) {
        this.altaskExamAnsCnt = altaskExamAnsCnt;
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
    
    public String getReschEvalCnt() {
        return reschEvalCnt;
    }
    public void setReschEvalCnt(String reschEvalCnt) {
        this.reschEvalCnt = reschEvalCnt;
    }
    
    public String getReschCnt() {
        return reschCnt;
    }
    public void setReschCnt(String reschCnt) {
        this.reschCnt = reschCnt;
    }
    
    public int getLessonCnt() {
        return lessonCnt;
    }
    public void setLessonCnt(int lessonCnt) {
        this.lessonCnt = lessonCnt;
    }
    
    public String getLectureComments() {
        return lectureComments;
    }
    public void setLectureComments(String lectureComments) {
        this.lectureComments = lectureComments;
    }
    
    public String getMiddleStartDttm() {
        return middleStartDttm;
    }
    public void setMiddleStartDttm(String middleStartDttm) {
        this.middleStartDttm = middleStartDttm;
    }
    
    public String getMiddleEndDttm() {
        return middleEndDttm;
    }
    public void setMiddleEndDttm(String middleEndDttm) {
        this.middleEndDttm = middleEndDttm;
    }
    
    public String getMiddleExamStareTm() {
        return middleExamStareTm;
    }
    public void setMiddleExamStareTm(String middleExamStareTm) {
        this.middleExamStareTm = middleExamStareTm;
    }
    
    public String getMiddleGradeViewNm() {
        return middleGradeViewNm;
    }
    public void setMiddleGradeViewNm(String middleGradeViewNm) {
        this.middleGradeViewNm = middleGradeViewNm;
    }
    
    public String getMiddleScoreOpenNm() {
        return middleScoreOpenNm;
    }
    public void setMiddleScoreOpenNm(String middleScoreOpenNm) {
        this.middleScoreOpenNm = middleScoreOpenNm;
    }
    
    public String getLastStartDttm() {
        return lastStartDttm;
    }
    public void setLastStartDttm(String lastStartDttm) {
        this.lastStartDttm = lastStartDttm;
    }
    
    public String getLastEndDttm() {
        return lastEndDttm;
    }
    public void setLastEndDttm(String lastEndDttm) {
        this.lastEndDttm = lastEndDttm;
    }
    
    public String getLastExamStareTm() {
        return lastExamStareTm;
    }
    public void setLastExamStareTm(String lastExamStareTm) {
        this.lastExamStareTm = lastExamStareTm;
    }
    
    public String getLastGradeViewNm() {
        return lastGradeViewNm;
    }
    public void setLastGradeViewNm(String lastGradeViewNm) {
        this.lastGradeViewNm = lastGradeViewNm;
    }
    
    public String getLastScoreOpenNm() {
        return lastScoreOpenNm;
    }
    public void setLastScoreOpenNm(String lastScoreOpenNm) {
        this.lastScoreOpenNm = lastScoreOpenNm;
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
    
    public String getUserNmEng() {
        return userNmEng;
    }
    public void setUserNmEng(String userNmEng) {
        this.userNmEng = userNmEng;
    }
    
    public String getMobileNo() {
        return mobileNo;
    }
    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }
    
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getUserSts() {
        return userSts;
    }
    public void setUserSts(String userSts) {
        this.userSts = userSts;
    }
    
    public String getUserStsNm() {
        return userStsNm;
    }
    public void setUserStsNm(String userStsNm) {
        this.userStsNm = userStsNm;
    }
    
    public String getUserType() {
        return userType;
    }
    public void setUserType(String userType) {
        this.userType = userType;
    }
    
    public String getUserTypeNm() {
        return userTypeNm;
    }
    public void setUserTypeNm(String userTypeNm) {
        this.userTypeNm = userTypeNm;
    }
    
    public String getLastLoginDttm() {
        return lastLoginDttm;
    }
    public void setLastLoginDttm(String lastLoginDttm) {
        this.lastLoginDttm = lastLoginDttm;
    }
    
    public String getLoginCnt() {
        return loginCnt;
    }
    public void setLoginCnt(String loginCnt) {
        this.loginCnt = loginCnt;
    }
    
    public String getSnsDiv() {
        return snsDiv;
    }
    public void setSnsDiv(String snsDiv) {
        this.snsDiv = snsDiv;
    }
    
    public String getSnsKey() {
        return snsKey;
    }
    public void setSnsKey(String snsKey) {
        this.snsKey = snsKey;
    }

    public String getCrsTypeCds() {
        return crsTypeCds;
    }
    public void setCrsTypeCds(String crsTypeCds) {
        this.crsTypeCds = crsTypeCds;
    }

    public String[] getCrsTypeCdList() {
        return crsTypeCdList;
    }
    public void setCrsTypeCdList(String[] crsTypeCdList) {
        this.crsTypeCdList = crsTypeCdList;
    }
    public String getForumSubmitCnt() {
        return forumSubmitCnt;
    }
    public void setForumSubmitCnt(String forumSubmitCnt) {
        this.forumSubmitCnt = forumSubmitCnt;
    }
    public String getQuizSubmitCnt() {
        return quizSubmitCnt;
    }
    public void setQuizSubmitCnt(String quizSubmitCnt) {
        this.quizSubmitCnt = quizSubmitCnt;
    }
    public String getInitYn() {
        return initYn;
    }
    public void setInitYn(String initYn) {
        this.initYn = initYn;
    }
    
}
