package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 전체수업현황 - 주차별 학습상태 VO
 * 화면ID : KNOU_MN_B0102060102
 */
public class ClsWkStsVO extends DefaultVO {
    private static final long serialVersionUID = 194466706021209066L;

    private int wkNo;          // 주차
    private String atndSts;    // 출석상태(ATND/LATE/ABSNT)
    private String userId;    // 사용자 ID

    public int getWkNo() { return wkNo; }
    public void setWkNo(int wkNo) { this.wkNo = wkNo; }

    public String getAtndSts() { return atndSts; }
    public void setAtndSts(String atndSts) { this.atndSts = atndSts; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
}