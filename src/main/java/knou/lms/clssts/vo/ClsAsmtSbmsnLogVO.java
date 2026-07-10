package knou.lms.clssts.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 학습자 학습요소 참여현황 팝업 - 요소별 제출/참여기록 VO
 * ASMT(과제) / QUIZ(퀴즈) / SRVY(설문) / DSCS(토론) 공용
 */

public class ClsAsmtSbmsnLogVO extends DefaultVO {
    private static final long serialVersionUID = 1234567890123456789L;

    // 조회 조건
    private String asmtId;      // 과제 ID        (ASMT 타입용, TB_LMS_ASMT.ASMT_ID)
    private String cntntsId;    // 콘텐츠 ID      (QUIZ / SRVY / DSCS 타입용)
    private String elemType;    // 요소 타입 구분  "ASMT" | "QUIZ" | "SRVY" | "DSCS"

    // 공통 결과
    private String sbmsnDttm;   // 제출/참여 일시 (YYYY.MM.DD HH24:MI)

    // ASMT(과제) 전용
    private String fileNm;      // 파일명
    private String fileSzText;  // 파일 크기(예: 157.35KB / 1.23MB)
    private String fileId;      // 첨부파일 ID - 다운로드용
    private String fileSavnm;   // 파일 저장명
    private String filePath;    // 파일 경로
    private String encDownParam;// 암호화 다운로드 파라미터

    // QUIZ(퀴즈) 전용
    private String actionText;  // 응시 이력 구분(응시/재응시 등)
    private String ipAddr;      // 응시 IP

    // SRVY(설문) / DSCS(토론) 전용
    private String contents;    // 내용 요약 또는 참여 결과
    private Integer postCnt;    // 토론 참여글 수
    private Integer commentCnt; // 토론 댓글 수



    public String getAsmtId()              { return asmtId; }
    public void   setAsmtId(String v)      { this.asmtId = v; }

    public String getCntntsId()            { return cntntsId; }
    public void   setCntntsId(String v)    { this.cntntsId = v; }

    public String getElemType()            { return elemType; }
    public void   setElemType(String v)    { this.elemType = v; }

    public String getSbmsnDttm()           { return sbmsnDttm; }
    public void   setSbmsnDttm(String v)   { this.sbmsnDttm = v; }

    public String getFileNm()              { return fileNm; }
    public void   setFileNm(String v)      { this.fileNm = v; }

    public String getFileSzText()          { return fileSzText; }
    public void   setFileSzText(String v)  { this.fileSzText = v; }

    public String getFileId()              { return fileId; }
    public void   setFileId(String v)      { this.fileId = v; }

    public String getFileSavnm()           { return fileSavnm; }
    public void   setFileSavnm(String v)   { this.fileSavnm = v; }

    public String getFilePath()            { return filePath; }
    public void   setFilePath(String v)    { this.filePath = v; }

    public String getEncDownParam()        { return encDownParam; }
    public void setEncDownParam(String v)  { this.encDownParam = v; }

    public String getActionText()          { return actionText; }
    public void   setActionText(String v)  { this.actionText = v; }

    public String getIpAddr()              { return ipAddr; }
    public void   setIpAddr(String v)      { this.ipAddr = v; }

    public String getContents()            { return contents; }
    public void   setContents(String v)    { this.contents = v; }

    public Integer getPostCnt()            { return postCnt; }
    public void    setPostCnt(Integer v)   { this.postCnt = v; }

    public Integer getCommentCnt()         { return commentCnt; }
    public void    setCommentCnt(Integer v){ this.commentCnt = v; }
}
