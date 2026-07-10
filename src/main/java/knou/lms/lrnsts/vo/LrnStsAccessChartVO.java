package knou.lms.lrnsts.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 나의 학습현황 강의실 접속현황 차트 VO
 */
public class LrnStsAccessChartVO extends DefaultVO {
    private static final long serialVersionUID = 9002541041723890078L;

    private int day;          // 일(1~31)
    private int prevCnt;      // 전월 접속 수
    private int stdntCnt;     // 학습자 접속 수
    private double avgCnt;    // 전체 평균 접속 수

    // 검색조건
    private String yyyymm;    // 조회 연월 (예: 202603)



    public int getDay() { return day; }
    public void setDay(int day) { this.day = day; }

    public int getPrevCnt() { return prevCnt; }
    public void setPrevCnt(int prevCnt) { this.prevCnt = prevCnt; }

    public int getStdntCnt() { return stdntCnt; }
    public void setStdntCnt(int stdntCnt) { this.stdntCnt = stdntCnt; }

    public double getAvgCnt() { return avgCnt; }
    public void setAvgCnt(double avgCnt) { this.avgCnt = avgCnt; }

    public String getYyyymm() { return yyyymm; }
    public void setYyyymm(String yyyymm) { this.yyyymm = yyyymm; }
}