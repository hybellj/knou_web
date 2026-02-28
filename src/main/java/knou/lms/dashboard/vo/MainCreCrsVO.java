package knou.lms.dashboard.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;
import knou.lms.exam.vo.ExamVO;
import knou.lms.lesson.vo.LessonScheduleVO;

public class MainCreCrsVO extends DefaultVO {
	
    private static final long serialVersionUID = 1L;
    
    private String crsCreCd;
    private String crsCreNm;
    private String crsCreNmEng;
    private String profNo;
    private String profNm;
    private String profNmEng;
    private String profTel;
    private String assistNo;
    private String assistNm;
    private String assistNmEng;
    private String assistTel;
    private String userId;
    private int lessonCnt = 0;
    private int completeCnt = 0;
    private int asmntCnt = 0;
    private int asmntSbmtCnt = 0;
    private int asmntEvalCnt = 0;
    private int qnaCnt = 0;
    private int qnaAnsCnt = 0;
    private int examCnt = 0;
    private int examAnsCnt = 0;
    private int examEvalCnt = 0;
    private int alwaysExamCnt = 0;       // 수시평가 수
    private int alwaysExamAnsCnt = 0;    // 수시평가 참여수
    private int forumCnt = 0;
    private int forumAnsCnt = 0;
    private int forumEvalCnt = 0;
    private int quizCnt = 0;
    private int quizAnsCnt = 0;
    private int quizEvalCnt = 0;
    private int seminarCnt = 0;
    private int seminarAnsCnt = 0;
    private int reschCnt = 0;
    private int reschAnsCnt = 0;
    private int studyProg = 0;
    private int noticeCnt = 0;
    private int noticeReadCnt = 0;
    private int secretCnt = 0;
    private int secretAnsCnt = 0;
    private int stdCnt = 0;
    private int auditCnt = 0;
    private int connCnt = 0;
    private int warnCnt = 0;
    private String orgId;
    private String uniCd = "C";
    private String univGbn;
    private String declsNo;
    private String crsCd;
    private String lsnPlanUrl;
    private String grdtScYn;
    
    private List<String> corList;
    private List<LessonScheduleVO> lessonScheduleList;
    private ExamVO examMid = null;
    private ExamVO examLast = null;
    
    private String noticeBbsId;
    private String qnaBbsId;
    private String secretBbsId;
    private String auditYn;
    private String repeatYn;
    private String tmswPreScYn;
    private String gvupYn;
    private String preScYn;
    private String suppScYn;
    
    private String enrlStartDttm;
    private String enrlEndDttm;
    
    private String lessonScheduleId;
    private String lessonTimeId;
    private Integer prgrRatio;
    private String tchType;
    
    private String examStareSearchYn;
    private float credit; 	// 학점 
    private Double totalRate; // 진도율

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getCrsCreNm() {
        return crsCreNm;
    }

    public void setCrsCreNm(String crsCreNm) {
        this.crsCreNm = crsCreNm;
    }

    public String getProfNo() {
        return profNo;
    }

    public void setProfNo(String profNo) {
        this.profNo = profNo;
    }

    public String getProfNm() {
        return profNm;
    }

    public void setProfNm(String profNm) {
        this.profNm = profNm;
    }

    public List<String> getCorList() {
        return corList;
    }

    public void setCorList(List<String> corList) {
        this.corList = corList;
    }

    public int getLessonCnt() {
        return lessonCnt;
    }

    public void setLessonCnt(int lessonCnt) {
        this.lessonCnt = lessonCnt;
    }

    public int getCompleteCnt() {
        return completeCnt;
    }

    public void setCompleteCnt(int completeCnt) {
        this.completeCnt = completeCnt;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getAsmntCnt() {
        return asmntCnt;
    }

    public void setAsmntCnt(int asmntCnt) {
        this.asmntCnt = asmntCnt;
    }

    public int getAsmntSbmtCnt() {
        return asmntSbmtCnt;
    }

    public void setAsmntSbmtCnt(int asmntSbmtCnt) {
        this.asmntSbmtCnt = asmntSbmtCnt;
    }

    public int getQnaCnt() {
        return qnaCnt;
    }

    public void setQnaCnt(int qnaCnt) {
        this.qnaCnt = qnaCnt;
    }

    public int getQnaAnsCnt() {
        return qnaAnsCnt;
    }

    public void setQnaAnsCnt(int qnaAnsCnt) {
        this.qnaAnsCnt = qnaAnsCnt;
    }

    public int getExamCnt() {
        return examCnt;
    }

    public void setExamCnt(int examCnt) {
        this.examCnt = examCnt;
    }

    public int getExamAnsCnt() {
        return examAnsCnt;
    }

    public void setExamAnsCnt(int examAnsCnt) {
        this.examAnsCnt = examAnsCnt;
    }

    public int getForumCnt() {
        return forumCnt;
    }

    public void setForumCnt(int forumCnt) {
        this.forumCnt = forumCnt;
    }

    public int getForumAnsCnt() {
        return forumAnsCnt;
    }

    public void setForumAnsCnt(int forumAnsCnt) {
        this.forumAnsCnt = forumAnsCnt;
    }

    public int getQuizCnt() {
        return quizCnt;
    }

    public void setQuizCnt(int quizCnt) {
        this.quizCnt = quizCnt;
    }

    public int getQuizAnsCnt() {
        return quizAnsCnt;
    }

    public void setQuizAnsCnt(int quizAnsCnt) {
        this.quizAnsCnt = quizAnsCnt;
    }

    public int getSeminarCnt() {
        return seminarCnt;
    }

    public void setSeminarCnt(int seminarCnt) {
        this.seminarCnt = seminarCnt;
    }

    public int getSeminarAnsCnt() {
        return seminarAnsCnt;
    }

    public void setSeminarAnsCnt(int seminarAnsCnt) {
        this.seminarAnsCnt = seminarAnsCnt;
    }

    public int getReschCnt() {
        return reschCnt;
    }

    public void setReschCnt(int reschCnt) {
        this.reschCnt = reschCnt;
    }

    public int getReschAnsCnt() {
        return reschAnsCnt;
    }

    public void setReschAnsCnt(int reschAnsCnt) {
        this.reschAnsCnt = reschAnsCnt;
    }

    public int getStudyProg() {
        return studyProg;
    }

    public void setStudyProg(int studyProg) {
        this.studyProg = studyProg;
    }

    public int getNoticeCnt() {
        return noticeCnt;
    }

    public void setNoticeCnt(int noticeCnt) {
        this.noticeCnt = noticeCnt;
    }

    public int getNoticeReadCnt() {
        return noticeReadCnt;
    }

    public void setNoticeReadCnt(int noticeReadCnt) {
        this.noticeReadCnt = noticeReadCnt;
    }

    public int getSecretCnt() {
        return secretCnt;
    }

    public void setSecretCnt(int secretCnt) {
        this.secretCnt = secretCnt;
    }

    public int getSecretAnsCnt() {
        return secretAnsCnt;
    }

    public void setSecretAnsCnt(int secretAnsCnt) {
        this.secretAnsCnt = secretAnsCnt;
    }

    public String getProfTel() {
        return profTel;
    }

    public void setProfTel(String profTel) {
        this.profTel = profTel;
    }

    public String getAssistNo() {
        return assistNo;
    }

    public void setAssistNo(String assistNo) {
        this.assistNo = assistNo;
    }

    public String getAssistNm() {
        return assistNm;
    }

    public void setAssistNm(String assistNm) {
        this.assistNm = assistNm;
    }

    public String getAssistTel() {
        return assistTel;
    }

    public void setAssistTel(String assistTel) {
        this.assistTel = assistTel;
    }

    public ExamVO getExamMid() {
        return examMid;
    }

    public void setExamMid(ExamVO examMid) {
        this.examMid = examMid;
    }

    public ExamVO getExamLast() {
        return examLast;
    }

    public void setExamLast(ExamVO examLast) {
        this.examLast = examLast;
    }

    public List<LessonScheduleVO> getLessonScheduleList() {
        return lessonScheduleList;
    }

    public void setLessonScheduleList(List<LessonScheduleVO> lessonScheduleList) {
        this.lessonScheduleList = lessonScheduleList;
    }

    public int getStdCnt() {
        return stdCnt;
    }

    public void setStdCnt(int stdCnt) {
        this.stdCnt = stdCnt;
    }

    public int getAuditCnt() {
        return auditCnt;
    }

    public void setAuditCnt(int auditCnt) {
        this.auditCnt = auditCnt;
    }

    public int getConnCnt() {
        return connCnt;
    }

    public void setConnCnt(int connCnt) {
        this.connCnt = connCnt;
    }

    public int getWarnCnt() {
        return warnCnt;
    }

    public void setWarnCnt(int warnCnt) {
        this.warnCnt = warnCnt;
    }

    public int getQuizEvalCnt() {
        return quizEvalCnt;
    }

    public void setQuizEvalCnt(int quizEvalCnt) {
        this.quizEvalCnt = quizEvalCnt;
    }

    public int getAsmntEvalCnt() {
        return asmntEvalCnt;
    }

    public void setAsmntEvalCnt(int asmntEvalCnt) {
        this.asmntEvalCnt = asmntEvalCnt;
    }

    public int getExamEvalCnt() {
        return examEvalCnt;
    }

    public void setExamEvalCnt(int examEvalCnt) {
        this.examEvalCnt = examEvalCnt;
    }

    public int getForumEvalCnt() {
        return forumEvalCnt;
    }

    public void setForumEvalCnt(int forumEvalCnt) {
        this.forumEvalCnt = forumEvalCnt;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getUniCd() {
        return uniCd;
    }

    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }

    public String getDeclsNo() {
        return declsNo;
    }

    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }

    public String getNoticeBbsId() {
        return noticeBbsId;
    }

    public void setNoticeBbsId(String noticeBbsId) {
        this.noticeBbsId = noticeBbsId;
    }

    public String getQnaBbsId() {
        return qnaBbsId;
    }

    public void setQnaBbsId(String qnaBbsId) {
        this.qnaBbsId = qnaBbsId;
    }

    public String getSecretBbsId() {
        return secretBbsId;
    }

    public void setSecretBbsId(String secretBbsId) {
        this.secretBbsId = secretBbsId;
    }

    public int getAlwaysExamCnt() {
        return alwaysExamCnt;
    }

    public void setAlwaysExamCnt(int alwaysExamCnt) {
        this.alwaysExamCnt = alwaysExamCnt;
    }

    public int getAlwaysExamAnsCnt() {
        return alwaysExamAnsCnt;
    }

    public void setAlwaysExamAnsCnt(int alwaysExamAnsCnt) {
        this.alwaysExamAnsCnt = alwaysExamAnsCnt;
    }

    public String getCrsCd() {
        return crsCd;
    }

    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }

    public String getLsnPlanUrl() {
        return lsnPlanUrl;
    }

    public void setLsnPlanUrl(String lsnPlanUrl) {
        this.lsnPlanUrl = lsnPlanUrl;
    }

    public String getAuditYn() {
        return auditYn;
    }

    public void setAuditYn(String auditYn) {
        this.auditYn = auditYn;
    }

    public String getCrsCreNmEng() {
        return crsCreNmEng;
    }

    public void setCrsCreNmEng(String crsCreNmEng) {
        this.crsCreNmEng = crsCreNmEng;
    }

    public String getRepeatYn() {
        return repeatYn;
    }

    public void setRepeatYn(String repeatYn) {
        this.repeatYn = repeatYn;
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public String getTmswPreScYn() {
        return tmswPreScYn;
    }

    public void setTmswPreScYn(String tmswPreScYn) {
        this.tmswPreScYn = tmswPreScYn;
    }

    public String getGvupYn() {
        return gvupYn;
    }

    public void setGvupYn(String gvupYn) {
        this.gvupYn = gvupYn;
    }

    public String getEnrlStartDttm() {
        return enrlStartDttm;
    }

    public void setEnrlStartDttm(String enrlStartDttm) {
        this.enrlStartDttm = enrlStartDttm;
    }

    public String getEnrlEndDttm() {
        return enrlEndDttm;
    }

    public void setEnrlEndDttm(String enrlEndDttm) {
        this.enrlEndDttm = enrlEndDttm;
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

    public Integer getPrgrRatio() {
        return prgrRatio;
    }

    public void setPrgrRatio(Integer prgrRatio) {
        this.prgrRatio = prgrRatio;
    }

    public String getTchType() {
        return tchType;
    }

    public void setTchType(String tchType) {
        this.tchType = tchType;
    }

    public String getExamStareSearchYn() {
        return examStareSearchYn;
    }

    public void setExamStareSearchYn(String examStareSearchYn) {
        this.examStareSearchYn = examStareSearchYn;
    }

	public String getProfNmEng() {
		return profNmEng;
	}

	public void setProfNmEng(String profNmEng) {
		this.profNmEng = profNmEng;
	}

	public String getAssistNmEng() {
		return assistNmEng;
	}

	public void setAssistNmEng(String assistNmEng) {
		this.assistNmEng = assistNmEng;
	}

    public String getUnivGbn() {
        return univGbn;
    }

    public void setUnivGbn(String univGbn) {
        this.univGbn = univGbn;
    }

    public String getPreScYn() {
        return preScYn;
    }

    public void setPreScYn(String preScYn) {
        this.preScYn = preScYn;
    }

    public String getSuppScYn() {
        return suppScYn;
    }

    public void setSuppScYn(String suppScYn) {
        this.suppScYn = suppScYn;
    }

    public String getGrdtScYn() {
        return grdtScYn;
    }

    public void setGrdtScYn(String grdtScYn) {
        this.grdtScYn = grdtScYn;
    }

	public float getCredit() {
		return credit;
	}

	public void setCredit(float credit) {
		this.credit = credit;
	}

	public Double getTotalRate() {
		return totalRate;
	}

	public void setTotalRate(Double totalRate) {
		this.totalRate = totalRate;
	}

    
}
