package knou.lms.lrnsts.vo;

import java.math.BigDecimal;

import knou.lms.common.vo.DefaultVO;

/**
 * 나의 학습현황 상세 VO
 */
public class LrnStsDetailVO extends DefaultVO {
    private static final long serialVersionUID = -6527056111725151103L;

    // 사용자/과목 기본정보
    private String orgNm;        // 기관명
    private String usernm;       // 이름
    private String stdntNo;      // 학번
    private String mobileNo;     // 휴대폰번호
    private String email;        // 이메일
    private String photoFileId;  // 사진 파일 ID
    private String dvclasNo;     // 분반번호
    private int    wkCnt;        // 전체 주차 수
    private int    wkNo;         // 주차

    // 출결 집계
    private String atndSts;      // 출석상태(ATND/LATE/ABSNT)
    private int atndCnt;         // 출석수
    private int lateCnt;         // 지각수
    private int absnCnt;         // 결석수

    // 학습요소 제출현황
    private int qaAnsCnt;        // Q&A 답변수
    private int qaRegCnt;        // Q&A 등록수
    private int talkReplyCnt;    // 토론방 댓글수

    private int asmtSbmsnCnt;    // 과제 제출수
    private int asmtTrgtCnt;     // 과제 전체수

    private int quizSbmsnCnt;    // 퀴즈 제출수
    private int quizTrgtCnt;     // 퀴즈 전체수

    private int srvySbmsnCnt;    // 설문 제출수
    private int srvyTrgtCnt;     // 설문 전체수

    private int dscsSbmsnCnt;    // 토론 제출수
    private int dscsTrgtCnt;     // 토론 전체수

    // 시험현황
    private BigDecimal midLiveScore;    // 중간(실시간)
    private BigDecimal midAltScore;     // 중간(대체)
    private BigDecimal midEtcScore;     // 중간(기타)
    private BigDecimal finalLiveScore;  // 기말(실시간)
    private BigDecimal finalAltScore;   // 기말(대체)
    private BigDecimal finalEtcScore;   // 기말(기타)



    public String getOrgNm() { return orgNm; }
    public void setOrgNm(String orgNm) { this.orgNm = orgNm; }

    public String getUsernm() { return usernm; }
    public void setUsernm(String usernm) { this.usernm = usernm; }

    public String getStdntNo() { return stdntNo; }
    public void setStdntNo(String stdntNo) { this.stdntNo = stdntNo; }

    public String getMobileNo() { return mobileNo; }
    public void setMobileNo(String mobileNo) { this.mobileNo = mobileNo; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhotoFileId() { return photoFileId; }
    public void setPhotoFileId(String photoFileId) { this.photoFileId = photoFileId; }

    public String getDvclasNo() { return dvclasNo; }
    public void setDvclasNo(String dvclasNo) { this.dvclasNo = dvclasNo; }

    public int getWkCnt() { return wkCnt; }
    public void setWkCnt(int wkCnt) { this.wkCnt = wkCnt; }

    public int getWkNo() { return wkNo; }
    public void setWkNo(int wkNo) { this.wkNo = wkNo; }

    public String getAtndSts() { return atndSts; }
    public void setAtndSts(String atndSts) { this.atndSts = atndSts; }

    public int getAtndCnt() { return atndCnt; }
    public void setAtndCnt(int atndCnt) { this.atndCnt = atndCnt; }

    public int getLateCnt() { return lateCnt; }
    public void setLateCnt(int lateCnt) { this.lateCnt = lateCnt; }

    public int getAbsnCnt() { return absnCnt; }
    public void setAbsnCnt(int absnCnt) { this.absnCnt = absnCnt; }

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

    public int getDscsSbmsnCnt() { return dscsSbmsnCnt; }
    public void setDscsSbmsnCnt(int dscsSbmsnCnt) { this.dscsSbmsnCnt = dscsSbmsnCnt; }

    public int getDscsTrgtCnt() { return dscsTrgtCnt; }
    public void setDscsTrgtCnt(int dscsTrgtCnt) { this.dscsTrgtCnt = dscsTrgtCnt; }

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
}
