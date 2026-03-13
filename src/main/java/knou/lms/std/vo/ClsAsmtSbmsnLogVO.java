package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 학습자 학습요소 참여현황 팝업 - 요소별 제출기록 VO
 * 화면ID : KNOU_MN_B01020601_03 (슬라이드8 팝업)
 *
 * ASMT(과제) / QUIZ(퀴즈) / QNA(Q&A) / SRVY(설문) / DSCC(토론) 공용
 */
public class ClsAsmtSbmsnLogVO extends DefaultVO {
    private static final long serialVersionUID = 1234567890123456789L;

    // ── 조회 조건 ──────────────────────────────────────────
    private String asmtId;      // 과제 ID        (ASMT 타입용, TB_LMS_ASMT.ASMT_ID)
    private String cntntsId;    // 콘텐츠 ID      (QUIZ / QNA / SRVY / DSCC 타입용)
    private String elemType;    // 요소 타입 구분  "ASMT" | "QUIZ" | "QNA" | "SRVY" | "DSCC"

    // userId 는 DefaultVO 상속

    // ── 공통 결과 ───────────────────────────────────────────
    private String lineNo;      // 행 번호
    private String sbmsnDttm;   // 제출 일시 (YYYY.MM.DD HH24:MI)

    // ── ASMT(과제) 전용 ─────────────────────────────────────
    private String fileNm;      // 파일명        (TB_LMS_ATFL.FILENM)
    private String fileSzText;  // 파일 크기     (예: 157.35KB / 1.23MB)
    private String fileId;      // 첨부파일 ID   (TB_LMS_ATFL.ATFL_ID) - 다운로드용

    // ── QUIZ(퀴즈) 전용 ─────────────────────────────────────
    private String score;       // 점수          (예: "85")
    private String resultText;  // 정오답 결과   (예: "8/10 정답")

    // ── QNA(Q&A) 전용 ───────────────────────────────────────
    private String title;       // 제목          (TB_LMS_BBS_ATCL.ATCL_TTL)

    // ── SRVY(설문) / DSCC(토론) 전용 ────────────────────────
    private String contents;    // 내용 요약     (TB_LMS_SRVY_PTCP / TB_LMS_DSCS_ATCL)

    // ===================== getter / setter =====================

    public String getAsmtId()              { return asmtId; }
    public void   setAsmtId(String v)      { this.asmtId = v; }

    public String getCntntsId()            { return cntntsId; }
    public void   setCntntsId(String v)    { this.cntntsId = v; }

    public String getElemType()            { return elemType; }
    public void   setElemType(String v)    { this.elemType = v; }

    public String getLineNo()              { return lineNo; }
    public void   setLineNo(String v)      { this.lineNo = v; }

    public String getSbmsnDttm()           { return sbmsnDttm; }
    public void   setSbmsnDttm(String v)   { this.sbmsnDttm = v; }

    public String getFileNm()              { return fileNm; }
    public void   setFileNm(String v)      { this.fileNm = v; }

    public String getFileSzText()          { return fileSzText; }
    public void   setFileSzText(String v)  { this.fileSzText = v; }

    public String getFileId()              { return fileId; }
    public void   setFileId(String v)      { this.fileId = v; }

    public String getScore()               { return score; }
    public void   setScore(String v)       { this.score = v; }

    public String getResultText()          { return resultText; }
    public void   setResultText(String v)  { this.resultText = v; }

    public String getTitle()               { return title; }
    public void   setTitle(String v)       { this.title = v; }

    public String getContents()            { return contents; }
    public void   setContents(String v)    { this.contents = v; }
}