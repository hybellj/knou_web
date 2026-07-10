package knou.lms.lrnsts.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

/**
 * 나의 학습현황 주차별 상세 팝업 - 차시별 학습 VO
 */
public class LrnStsChsiLrnVO extends DefaultVO {
    private static final long serialVersionUID = 6388291559646532156L;

    // 조회조건
    private int wkNo;               // 주차번호

    // 차시 정보
    private String chsiSchdlId;    // 차시일정 ID
    private int    chsiNo;         // 차시번호
    private String chsiTitle;      // 차시제목
    private String cntntsId;       // 콘텐츠 ID
    private String cntntsTitle;    // 콘텐츠 제목
    private String cntntsTypeNm;   // 콘텐츠 유형명

    // 학습 상태
    private String lrnSts;         // 학습완료 / 학습중 / 미학습
    private String atndTrgtYn;     // 출결대상 여부
    private String scoreText;      // 상태표시 문자열

    // 학습기간
    private String lrnStDt;        // 학습 시작일
    private String lrnEndDt;       // 학습 종료일
    private int    lrnMin;         // 인정 학습시간(분)

    // 학습기록 목록
    private List<LrnStsLrnLogVO> logList;  // 3분 단위 학습로그



    public int getWkNo() { return wkNo; }
    public void setWkNo(int v) { this.wkNo = v; }

    public String getChsiSchdlId() { return chsiSchdlId; }
    public void setChsiSchdlId(String v) { this.chsiSchdlId = v; }

    public int getChsiNo() { return chsiNo; }
    public void setChsiNo(int v) { this.chsiNo = v; }

    public String getChsiTitle() { return chsiTitle; }
    public void setChsiTitle(String v) { this.chsiTitle = v; }

    public String getCntntsId() { return cntntsId; }
    public void setCntntsId(String v) { this.cntntsId = v; }

    public String getCntntsTitle() { return cntntsTitle; }
    public void setCntntsTitle(String v) { this.cntntsTitle = v; }

    public String getCntntsTypeNm() { return cntntsTypeNm; }
    public void setCntntsTypeNm(String v) { this.cntntsTypeNm = v; }

    public String getLrnSts() { return lrnSts; }
    public void setLrnSts(String v) { this.lrnSts = v; }

    public String getAtndTrgtYn() { return atndTrgtYn; }
    public void setAtndTrgtYn(String v) { this.atndTrgtYn = v; }

    public String getScoreText() { return scoreText; }
    public void setScoreText(String v) { this.scoreText = v; }

    public String getLrnStDt() { return lrnStDt; }
    public void setLrnStDt(String v) { this.lrnStDt = v; }

    public String getLrnEndDt() { return lrnEndDt; }
    public void setLrnEndDt(String v) { this.lrnEndDt = v; }

    public int getLrnMin() { return lrnMin; }
    public void setLrnMin(int v) { this.lrnMin = v; }

    public List<LrnStsLrnLogVO> getLogList() { return logList; }
    public void setLogList(List<LrnStsLrnLogVO> logList) { this.logList = logList; }

}