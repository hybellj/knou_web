package knou.lms.clssts.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 주차별 출석/학습 상태 VO
 */

public class ClsWkStsVO extends DefaultVO {
    private static final long serialVersionUID = 194466706021209066L;

    private int wkNo;          // 주차
    private String atndSts;    // 출석상태(ATND/LATE/ABSNT)



    public int getWkNo() { return wkNo; }
    public void setWkNo(int wkNo) { this.wkNo = wkNo; }

    public String getAtndSts() { return atndSts; }
    public void setAtndSts(String atndSts) { this.atndSts = atndSts; }
}
