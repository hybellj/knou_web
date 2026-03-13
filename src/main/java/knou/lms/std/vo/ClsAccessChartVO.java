package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 강의실 접속현황 차트 VO (일별 접속 데이터)
 * 화면ID : KNOU_MN_B0102060102 (학습자 학습현황 팝업)
 */
public class ClsAccessChartVO extends DefaultVO {
    private static final long serialVersionUID = 5512038476192834710L;

    private int    day;        // 일(1~31)
    private int    prevCnt;   // 지난달 접속 수
    private int    stdntCnt;  // 학습자 접속 수
    private double avgCnt;    // 전체 평균 접속 수

    // 검색 조건
    private String sbjctId;
    private String userId;
    private String yyyymm;    // 조회 년월 (예: 202206)

    public int    getDay()      { return day; }
    public void   setDay(int day) { this.day = day; }

    public int    getPrevCnt()  { return prevCnt; }
    public void   setPrevCnt(int prevCnt) { this.prevCnt = prevCnt; }

    public int    getStdntCnt() { return stdntCnt; }
    public void   setStdntCnt(int stdntCnt) { this.stdntCnt = stdntCnt; }

    public double getAvgCnt()   { return avgCnt; }
    public void   setAvgCnt(double avgCnt) { this.avgCnt = avgCnt; }

    public String getSbjctId()  { return sbjctId; }
    public void   setSbjctId(String sbjctId) { this.sbjctId = sbjctId; }

    public String getUserId()   { return userId; }
    public void   setUserId(String userId) { this.userId = userId; }

    public String getYyyymm()   { return yyyymm; }
    public void   setYyyymm(String yyyymm) { this.yyyymm = yyyymm; }
}