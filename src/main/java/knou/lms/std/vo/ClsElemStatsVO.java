package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;
import java.math.BigDecimal;

/**
 * 전체수업현황 - 학습요소 참여현황 VO
 */

public class ClsElemStatsVO extends DefaultVO {
    private static final long serialVersionUID = -5863588968258046138L;

    // 조건
    private String keyword;   // 검색어

    // ===== 요소별 집계 필드 <현재 미사용> =====
    private String elemTypeNm;  //학습요소 유형명
    private String title;     // 학습요소 제목
    private int trgtCnt;     // 대상자 수
    private int joinCnt;      // 참여자 수
    private int notJoinCnt;    //미참여자 수
    private BigDecimal joinRt;  // 참여율

    // ===== "학습요소 참여현황" 표(학생 행) 필드 =====
    private String usernm;   // 학습자명
    private String stdntNo;  //학번
    private String deptnm;   // 학과명

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

    private BigDecimal midLiveScore;    // 중간(실시간)
    private BigDecimal midAltScore;     // 중간(대체)
    private BigDecimal midEtcScore;     // 중간(기타)
    private BigDecimal finalLiveScore;  // 기말(실시간)
    private BigDecimal finalAltScore;   // 기말(대체)
    private BigDecimal finalEtcScore;   // 기말(기타)

    private BigDecimal midScore;        // 중간 대표값
    private BigDecimal finalScore;      // 기말 대표값




    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

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

    public BigDecimal getMidLiveScore() { return midLiveScore; }
    public void setMidLiveScore(BigDecimal midLiveScore) { this.midLiveScore = midLiveScore; }

    public BigDecimal getMidAltScore() { return midAltScore; }
    public void setMidAltScore(BigDecimal midAltScore) { this.midAltScore = midAltScore; }

    public BigDecimal getMidEtcScore() { return midEtcScore; }
    public void setMidEtcScore(BigDecimal midEtcScore) { this.midEtcScore = midEtcScore; }

    public BigDecimal getFinalLiveScore() { return finalLiveScore; }
    public void setFinalLiveScore(BigDecimal finalLiveScore) { this.finalLiveScore = finalLiveScore; }

    public BigDecimal getFinalAltScore() { return finalAltScore; }
    public void setFinalAltScore(BigDecimal finalAltScore) { this.finalAltScore = finalAltScore; }

    public BigDecimal getFinalEtcScore() { return finalEtcScore; }
    public void setFinalEtcScore(BigDecimal finalEtcScore) { this.finalEtcScore = finalEtcScore; }

    public BigDecimal getMidScore() { return midScore; }
    public void setMidScore(BigDecimal midScore) { this.midScore = midScore; }

    public BigDecimal getFinalScore() { return finalScore; }
    public void setFinalScore(BigDecimal finalScore) { this.finalScore = finalScore; }
}