package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

import java.math.BigDecimal;

/**
 * 주차별 미학습자 통계 VO
 */
public class ClsWklyStatsVO extends DefaultVO {
    private static final long serialVersionUID = 711404933223296273L;

    private int wkNo;              // 주차
    private int totalCnt;          // 총원
    private int notLrnnCnt;        // 미학습자 수
    private BigDecimal notLrnnRt;  // 미학습 비율(%)

    public int getWkNo() { return wkNo; }
    public void setWkNo(int wkNo) { this.wkNo = wkNo; }

    public int getTotalCnt() { return totalCnt; }
    public void setTotalCnt(int totalCnt) { this.totalCnt = totalCnt; }

    public int getNotLrnnCnt() { return notLrnnCnt; }
    public void setNotLrnnCnt(int notLrnnCnt) { this.notLrnnCnt = notLrnnCnt; }

    public BigDecimal getNotLrnnRt() { return notLrnnRt; }
    public void setNotLrnnRt(BigDecimal notLrnnRt) { this.notLrnnRt = notLrnnRt; }
}