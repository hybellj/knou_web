package knou.lms.dashboard.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class DashboardAdminVO extends DefaultVO {
    
    private static final long serialVersionUID = 1L;
    
    private String userNm;
    private String tchCnt;         /* 책임교수자수:책임교수자 선정여부로확인 */
    
    private String crsCd;        /* 과목코드 */
    private String crsCreCd;        /* 과목코드 */
    private String crsCreNm;        /* 과목명 */
    private String profNo;          /* 교수자 번호(학번)*/
    private String profNm;          /* 교수자명 */
    private String profTel;         /*교수자 연락처*/
    
    private String assistNo;        /* 조교 번호(학번)*/ 
    private String assistNm;        /* 조교명 */
    private String assistTel;       /* 조교 연락처 */
    
    private String userId;          /*학습자번호(학번) */
    private String stdNo;          /*수강자번호(과목코드_학번) */
    
    private int lessonCnt = 0;      /* 강의수 */
    private int completeCnt = 0;    /* 출결완료수 */
    
    private int asmntCnt = 0;       /* 과제갯수 */
    private int asmntSubmitCnt = 0;   /* 과제제출자수 */
    private int asmntEvalCnt = 0;   /* 과제평가자수 */
    
    private int qnaCnt = 0;         /* Q&A갯수 */
    private int qnaAnsCnt = 0;      /* Q&A응답수 */
    
    private int examCnt = 0;        /* 시험갯수 */
    private int examAnsCnt = 0;     /* 시험응시자수 */
    private int examEvalCnt = 0;    /* 시험평가자수 */
    
    private int forumCnt = 0;       /* 토론갯수 */
    private int forumAnsCnt = 0;    /* 토론응답자수 */
    private int forumEvalCnt = 0;   /* 토론평가자수 */
    
    private int quizCnt = 0;        /* 퀴즈갯수 */
    private int quizAnsCnt = 0;     /* 퀴즈응답자수 */
    private int quizEvalCnt = 0;    /* 퀴즈평가자수 */
    
    private int seminarCnt = 0;     /* 세미나갯수 */
    private int seminarAnsCnt = 0;  /* 세미나참석자수 */
    
    private int reschCnt = 0;       /* 설문갯수 */
    private int reschAnsCnt = 0;    /* 설문응답자수 */
    
    private int studyProg = 0;
    
    private int noticeCnt = 0;      /* 강의공지갯수 */
    private int noticeReadCnt = 0;  /* 강의공지읽은수 */
    
    private int secretCnt = 0;      /* 1:1상담갯수 */
    private int secretAnsCnt = 0;   /* 1:1상담응답수 */
    
    private int stdCnt = 0;         /* 수강자수 */
    private int auditCnt = 0;       /* 청강자수 */
    private int connCnt = 0;        /* 접속자수 */
    private int warnCnt = 0;        /* 이수위험수 */
    private int accessCnt = 0;      /* 접속자수 */
    
    private String orgId;           /* 기관코드 */
    private String uniCd = "C";
    private String declsNo;         /* 분반 */
    
    private List<String> corList;    /*  과목 부가자료 */

    private String noticeBbsId;     /* 강의공지ID */
    private String qnaBbsId;        /* Q&AID */
    private String secretBbsId;     /* 1:1ID */

    private String middleStartDttm;
    private String middleExamStareTm;
    private String lastStartDttm;
    private String lastExamStareTm;
    private String termCd;
    private String crsOperTypeCd;
    private String searchValue;
    private String crsTypeCd;
    private String crsTypeNm;
    private String enrlAplcStartDttm;   // 수강 시작 일시
    private String enrlAplcEndDttm;    // 수강 종료 일시
    private String enrlStartDttm;         // 수강 시작 일시
    private String enrlEndDttm;          // 수강 종료 일시
    private String lbnTm;                   // 학습시간
    private String stdRate;                // 진도 비율
    private String totalRate;              // 전체진도비율
    private String studyStatusCd;
    private String deptCd;
    private String deptNm;
    
    private String openSearchValue;
    private String userSearchValue;
    private String legalSearchValue;
    
    private String userNmEng;
    private String photoFileSn;
    private String isHaksaStatus;
    private String dupInfo;
    private String mobileNo;
    private String email;
    private String orgNm;
    private String emailRecv;
    private String smsRecv;
    private String disablilityYn;
    private String userGrade;
    private String userPass;
    private String adminLoginAcptDivCd;
    private String loginFailDttm;
    private String loginFailCnt;
    private String lastLoginDttm;
    private String loginCnt;
    private String secedeDttm;
    private String userSts;
    private String userStsNm;
    private String snsDiv;
    private String snsKey;
    private String otpUseYn;
    private String dupLoginAcptYn;
    private String userTypeCd;
    private String menuType;
    private String searchAuthGrp;
    private String searchUserStatus;
    private String pages;
    private String creYear;
    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;;
    
    private List<MainCreCrsVO> creCrsList;
    private List<MainCreCrsVO> adminCreCrsList;
    
    public String getUserNm() {
        return userNm;
    }
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }
    
    public String getTchCnt() {
        return tchCnt;
    }
    public void setTchCnt(String tchCnt) {
        this.tchCnt = tchCnt;
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

    public String getStdNo() {
        return stdNo;
    }
    public void setStdNo(String stdNo) {
        this.stdNo = stdNo;
    }
    
    public int getAsmntCnt() {
        return asmntCnt;
    }
    public void setAsmntCnt(int asmntCnt) {
        this.asmntCnt = asmntCnt;
    }

    public int getAsmntSubmitCnt() {
        return asmntSubmitCnt;
    }
    public void setAsmntSubmitCnt(int asmntSubmitCnt) {
        this.asmntSubmitCnt = asmntSubmitCnt;
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

    public int getAccessCnt() {
        return accessCnt;
    }
    public void setAccessCnt(int accessCnt) {
        this.accessCnt = accessCnt;
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
    
    public String getMiddleStartDttm() {
        return middleStartDttm;
    }
    public void setMiddleStartDttm(String middleStartDttm) {
        this.middleStartDttm = middleStartDttm;
    }
    
    public String getMiddleExamStareTm() {
        return middleExamStareTm;
    }
    public void setMiddleExamStareTm(String middleExamStareTm) {
        this.middleExamStareTm = middleExamStareTm;
    }
    
    public String getLastStartDttm() {
        return lastStartDttm;
    }
    public void setLastStartDttm(String lastStartDttm) {
        this.lastStartDttm = lastStartDttm;
    }
    
    public String getLastExamStareTm() {
        return lastExamStareTm;
    }
    public void setLastExamStareTm(String lastExamStareTm) {
        this.lastExamStareTm = lastExamStareTm;
    }
    
    public String getTermCd() {
        return termCd;
    }
    public void setTermCd(String termCd) {
        this.termCd = termCd;
    }

    public String getCrsOperTypeCd() {
        return crsOperTypeCd;
    }
    public void setCrsOperTypeCd(String crsOperTypeCd) {
        this.crsOperTypeCd = crsOperTypeCd;
    }

    public String getSearchValue() {
        return searchValue;
    }
    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }
    
    public String getCrsTypeCd() {
        return crsTypeCd;
    }
    public void setCrsTypeCd(String crsTypeCd) {
        this.crsTypeCd = crsTypeCd;
    }

    public String getCrsTypeNm() {
        return crsTypeNm;
    }
    public void setCrsTypeNm(String crsTypeNm) {
        this.crsTypeNm = crsTypeNm;
    }

    public String getEnrlAplcStartDttm() {
        return enrlAplcStartDttm;
    }
    public void setEnrlAplcStartDttm(String enrlAplcStartDttm) {
        this.enrlAplcStartDttm = enrlAplcStartDttm;
    }
    public String getEnrlAplcEndDttm() {
        return enrlAplcEndDttm;
    }
    public void setEnrlAplcEndDttm(String enrlAplcEndDttm) {
        this.enrlAplcEndDttm = enrlAplcEndDttm;
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

    public String getLbnTm() {
        return lbnTm;
    }
    public void setLbnTm(String lbnTm) {
        this.lbnTm = lbnTm;
    }
    
    public String getStdRate() {
        return stdRate;
    }
    public void setStdRate(String stdRate) {
        this.stdRate = stdRate;
    }
    
    public String getTotalRate() {
        return totalRate;
    }
    public void setTotalRate(String totalRate) {
        this.totalRate = totalRate;
    }
    
    public String getStudyStatusCd() {
        return studyStatusCd;
    }
    public void setStudyStatusCd(String studyStatusCd) {
        this.studyStatusCd = studyStatusCd;
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
    
    public String getOpenSearchValue() {
        return openSearchValue;
    }
    public void setOpenSearchValue(String openSearchValue) {
        this.openSearchValue = openSearchValue;
    }
    
    public String getUserSearchValue() {
        return userSearchValue;
    }
    public void setUserSearchValue(String userSearchValue) {
        this.userSearchValue = userSearchValue;
    }

    public String getLegalSearchValue() {
        return legalSearchValue;
    }
    public void setLegalSearchValue(String legalSearchValue) {
        this.legalSearchValue = legalSearchValue;
    }
    
    public String getUserNmEng() {
        return userNmEng;
    }
    public void setUserNmEng(String userNmEng) {
        this.userNmEng = userNmEng;
    }
    
    public String getPhotoFileSn() {
        return photoFileSn;
    }
    public void setPhotoFileSn(String photoFileSn) {
        this.photoFileSn = photoFileSn;
    }
    
    public String getIsHaksaStatus() {
        return isHaksaStatus;
    }
    public void setIsHaksaStatus(String isHaksaStatus) {
        this.isHaksaStatus = isHaksaStatus;
    }
    
    public String getDupInfo() {
        return dupInfo;
    }
    public void setDupInfo(String dupInfo) {
        this.dupInfo = dupInfo;
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
    
    public String getOrgNm() {
        return orgNm;
    }
    public void setOrgNm(String orgNm) {
        this.orgNm = orgNm;
    }
    
    public String getEmailRecv() {
        return emailRecv;
    }
    public void setEmailRecv(String emailRecv) {
        this.emailRecv = emailRecv;
    }
    
    public String getSmsRecv() {
        return smsRecv;
    }
    public void setSmsRecv(String smsRecv) {
        this.smsRecv = smsRecv;
    }
    
    public String getDisablilityYn() {
        return disablilityYn;
    }
    public void setDisablilityYn(String disablilityYn) {
        this.disablilityYn = disablilityYn;
    }
    
    public String getUserGrade() {
        return userGrade;
    }
    public void setUserGrade(String userGrade) {
        this.userGrade = userGrade;
    }
    
    public String getUserPass() {
        return userPass;
    }
    public void setUserPass(String userPass) {
        this.userPass = userPass;
    }
    
    public String getAdminLoginAcptDivCd() {
        return adminLoginAcptDivCd;
    }
    public void setAdminLoginAcptDivCd(String adminLoginAcptDivCd) {
        this.adminLoginAcptDivCd = adminLoginAcptDivCd;
    }
    
    public String getLoginFailDttm() {
        return loginFailDttm;
    }
    public void setLoginFailDttm(String loginFailDttm) {
        this.loginFailDttm = loginFailDttm;
    }
    
    public String getLoginFailCnt() {
        return loginFailCnt;
    }
    public void setLoginFailCnt(String loginFailCnt) {
        this.loginFailCnt = loginFailCnt;
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
    
    public String getSecedeDttm() {
        return secedeDttm;
    }
    public void setSecedeDttm(String secedeDttm) {
        this.secedeDttm = secedeDttm;
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
    
    public String getOtpUseYn() {
        return otpUseYn;
    }
    public void setOtpUseYn(String otpUseYn) {
        this.otpUseYn = otpUseYn;
    }
    
    public String getDupLoginAcptYn() {
        return dupLoginAcptYn;
    }
    public void setDupLoginAcptYn(String dupLoginAcptYn) {
        this.dupLoginAcptYn = dupLoginAcptYn;
    }
    public String getUserTypeCd() {
        return userTypeCd;
    }
    public void setUserTypeCd(String userTypeCd) {
        this.userTypeCd = userTypeCd;
    }
    public String getSearchAuthGrp() {
        return searchAuthGrp;
    }
    public void setSearchAuthGrp(String searchAuthGrp) {
        this.searchAuthGrp = searchAuthGrp;
    }
    
    public String getSearchUserStatus() {
        return searchUserStatus;
    }
    public void setSearchUserStatus(String searchUserStatus) {
        this.searchUserStatus = searchUserStatus;
    }
    
    public String getPages() {
        return pages;
    }
    public void setPages(String pages) {
        this.pages = pages;
    }
    
    public String getCreYear() {
        return creYear;
    }
    public void setCreYear(String creYear) {
        this.creYear = creYear;
    }
    
    public String getRgtrId() {
        return rgtrId;
    }
    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }
    
    public String getRegDttm() {
        return regDttm;
    }
    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }
    
    public String getMdfrId() {
        return mdfrId;
    }
    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }
    
    public String getModDttm() {
        return modDttm;
    }
    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }
    
    public List<MainCreCrsVO> getCreCrsList() {
        return creCrsList;
    }
    public void setCreCrsList(List<MainCreCrsVO> creCrsList) {
        this.creCrsList = creCrsList;
    }
    
    public List<MainCreCrsVO> getAdminCreCrsList() {
        return adminCreCrsList;
    }
    public void setAdminCreCrsList(List<MainCreCrsVO> adminCreCrsList) {
        this.adminCreCrsList = adminCreCrsList;
    }

}
