package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

import java.math.BigDecimal;

/**
 * 전체수업현황 - 학습요소 참여현황 VO
 * 화면ID : KNOU_MN_B0102060102 (학습요소 참여현황 탭)
 */
public class ClsElemStatsVO extends DefaultVO {
    private static final long serialVersionUID = -5863588968258046138L;

    // 조건
    private String sbjctId;
    private String keyword;

    // 공통 결과
    private String lineNo;
    private int totalCnt;

    // ===== (기존) 요소별 집계 필드 (남겨둠: 다른 곳 영향 방지) =====
    private String elemTypeNm;
    private String title;
    private int trgtCnt;
    private int joinCnt;
    private int notJoinCnt;
    private BigDecimal joinRt;

    // ===== (신규) 화면정의서의 "학습요소 참여현황" 표(학생 행) 필드 =====
    private String userId;
    private String usernm;
    private String stdntNo;
    private String deptnm;

    private int qaAnsCnt;       // Q&A 답변
    private int qaRegCnt;       // Q&A 등록
    private int talkReplyCnt;   // 토론방 댓글수

    private int asmtSbmsnCnt;   // 과제 제출
    private int asmtTrgtCnt;    // 과제 전체

    private int quizSbmsnCnt;   // 퀴즈 제출
    private int quizTrgtCnt;    // 퀴즈 전체

    private int srvySbmsnCnt;   // 설문 제출
    private int srvyTrgtCnt;    // 설문 전체

    private int dsccSbmsnCnt;   // 토론 제출
    private int dsccTrgtCnt;    // 토론 전체

    private BigDecimal midScore;    // 중간
    private BigDecimal finalScore;  // 기말

    // 엑셀
    private String excelGrid;

    // getter/setter
    public String getSbjctId() { return sbjctId; }
    public void setSbjctId(String sbjctId) { this.sbjctId = sbjctId; }

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public String getLineNo() { return lineNo; }
    public void setLineNo(String lineNo) { this.lineNo = lineNo; }

    public int getTotalCnt() { return totalCnt; }
    public void setTotalCnt(int totalCnt) { this.totalCnt = totalCnt; }

    public String getElemTypeNm() { return elemTypeNm; }
    public void setElemTypeNm(String elemTypeNm) { this.elemTypeNm = elemTypeNm; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getTrgtCnt() { return trgtCnt; }
    public void setTrgtCnt(int trgtCnt) { this.trgtCnt = trgtCnt; }

    public int getJoinCnt() { return joinCnt; }
    public void setJoinCnt(int joinCnt) { this.joinCnt = joinCnt; }

    public int getNotJoinCnt() { return notJoinCnt; }
    public void setNotJoinCnt(int notJoinCnt) { this.notJoinCnt = notJoinCnt; }

    public BigDecimal getJoinRt() { return joinRt; }
    public void setJoinRt(BigDecimal joinRt) { this.joinRt = joinRt; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUsernm() { return usernm; }
    public void setUsernm(String usernm) { this.usernm = usernm; }

    public String getStdntNo() { return stdntNo; }
    public void setStdntNo(String stdntNo) { this.stdntNo = stdntNo; }

    public String getDeptnm() { return deptnm; }
    public void setDeptnm(String deptnm) { this.deptnm = deptnm; }

    public int getQaAnsCnt() { return qaAnsCnt; }
    public void setQaAnsCnt(int qaAnsCnt) { this.qaAnsCnt = qaAnsCnt; }

    public int getQaRegCnt() { return qaRegCnt; }
    public void setQaRegCnt(int qaRegCnt) { this.qaRegCnt = qaRegCnt; }

    public int getTalkReplyCnt() { return talkReplyCnt; }
    public void setTalkReplyCnt(int talkReplyCnt) { this.talkReplyCnt = talkReplyCnt; }

    public int getAsmtSbmsnCnt() { return asmtSbmsnCnt; }
    public void setAsmtSbmsnCnt(int asmtSbmsnCnt) { this.asmtSbmsnCnt = asmtSbmsnCnt; }

    public int getAsmtTrgtCnt() { return asmtTrgtCnt; }
    public void setAsmtTrgtCnt(int asmtTrgtCnt) { this.asmtTrgtCnt = asmtTrgtCnt; }

    public int getQuizSbmsnCnt() { return quizSbmsnCnt; }
    public void setQuizSbmsnCnt(int quizSbmsnCnt) { this.quizSbmsnCnt = quizSbmsnCnt; }

    public int getQuizTrgtCnt() { return quizTrgtCnt; }
    public void setQuizTrgtCnt(int quizTrgtCnt) { this.quizTrgtCnt = quizTrgtCnt; }

    public int getSrvySbmsnCnt() { return srvySbmsnCnt; }
    public void setSrvySbmsnCnt(int srvySbmsnCnt) { this.srvySbmsnCnt = srvySbmsnCnt; }

    public int getSrvyTrgtCnt() { return srvyTrgtCnt; }
    public void setSrvyTrgtCnt(int srvyTrgtCnt) { this.srvyTrgtCnt = srvyTrgtCnt; }

    public int getDsccSbmsnCnt() { return dsccSbmsnCnt; }
    public void setDsccSbmsnCnt(int dsccSbmsnCnt) { this.dsccSbmsnCnt = dsccSbmsnCnt; }

    public int getDsccTrgtCnt() { return dsccTrgtCnt; }
    public void setDsccTrgtCnt(int dsccTrgtCnt) { this.dsccTrgtCnt = dsccTrgtCnt; }

    public BigDecimal getMidScore() { return midScore; }
    public void setMidScore(BigDecimal midScore) { this.midScore = midScore; }

    public BigDecimal getFinalScore() { return finalScore; }
    public void setFinalScore(BigDecimal finalScore) { this.finalScore = finalScore; }

    public String getExcelGrid() { return excelGrid; }
    public void setExcelGrid(String excelGrid) { this.excelGrid = excelGrid; }
}