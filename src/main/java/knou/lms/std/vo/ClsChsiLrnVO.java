package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

import java.util.List;

/**
 * 학습자 주차별 학습현황 팝업 - 차시별 학습 VO
 * 화면ID : KNOU_MN_B0102060102 (슬라이드7 팝업)
 *
 * sbjctId, userId, orgId 는 DefaultVO 상속
 */
public class ClsChsiLrnVO extends DefaultVO {
    private static final long serialVersionUID = 2230947856412309871L;

    // 차시 정보
    private String chsiSchdlId;   // 차시 스케줄 ID (로그 조회용)
    private int    chsiNo;        // 차시 번호 (1, 2, 3...)
    private String chsiTitle;     // 차시 제목
    private String cntntsId;      // 콘텐츠 ID
    private String cntntsTitle;   // 콘텐츠 제목
    private String cntntsTypeNm;  // 콘텐츠 유형명 (동영상 / 문서 등)

    // 학습 상태
    private String lrnSts;        // 학습완료 / 학습중 / 미학습
    private String atndTrgtYn;    // 출결대상 여부 (Y/N)

    // 학습기간
    private String lrnStDt;       // 학습 시작일 (YYYY.MM.DD)
    private String lrnEndDt;      // 학습 종료일 (YYYY.MM.DD)
    private int    lrnMin;        // 출결 기준 학습 시간(분)

    // 3분 단위 학습로그 목록 (조회 결과)
    private List<ClsLrnLogVO> logList;

    // ===================== getter / setter =====================

    public String getChsiSchdlId()              { return chsiSchdlId; }
    public void setChsiSchdlId(String v)        { this.chsiSchdlId = v; }

    public int getChsiNo()                      { return chsiNo; }
    public void setChsiNo(int v)                { this.chsiNo = v; }

    public String getChsiTitle()                { return chsiTitle; }
    public void setChsiTitle(String v)          { this.chsiTitle = v; }

    public String getCntntsId()                 { return cntntsId; }
    public void setCntntsId(String v)           { this.cntntsId = v; }

    public String getCntntsTitle()              { return cntntsTitle; }
    public void setCntntsTitle(String v)        { this.cntntsTitle = v; }

    public String getCntntsTypeNm()             { return cntntsTypeNm; }
    public void setCntntsTypeNm(String v)       { this.cntntsTypeNm = v; }

    public String getLrnSts()                   { return lrnSts; }
    public void setLrnSts(String v)             { this.lrnSts = v; }

    public String getAtndTrgtYn()               { return atndTrgtYn; }
    public void setAtndTrgtYn(String v)         { this.atndTrgtYn = v; }

    public String getLrnStDt()                  { return lrnStDt; }
    public void setLrnStDt(String v)            { this.lrnStDt = v; }

    public String getLrnEndDt()                 { return lrnEndDt; }
    public void setLrnEndDt(String v)           { this.lrnEndDt = v; }

    public int getLrnMin()                      { return lrnMin; }
    public void setLrnMin(int v)                { this.lrnMin = v; }

    public List<ClsLrnLogVO> getLogList()            { return logList; }
    public void setLogList(List<ClsLrnLogVO> logList){ this.logList = logList; }
}