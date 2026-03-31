package knou.lms.mrk.vo;

import knou.lms.common.vo.DefaultVO;

public class MarkSubjectDetailVO extends DefaultVO {

    private String mrkSbjctDtlId;   // 성적 과목 상세 아이디
    private String mrkSbjctId;      // 성적 과목 아이디
    private String mrkItmTycd;      // 성적 항목 유형코드
    private double scr;         // 점수

    public String getMrkSbjctDtlId() {
        return mrkSbjctDtlId;
    }

    public void setMrkSbjctDtlId(String mrkSbjctDtlId) {
        this.mrkSbjctDtlId = mrkSbjctDtlId;
    }

    public String getMrkSbjctId() {
        return mrkSbjctId;
    }

    public void setMrkSbjctId(String mrkSbjctId) {
        this.mrkSbjctId = mrkSbjctId;
    }

    public String getMrkItmTycd() {
        return mrkItmTycd;
    }

    public void setMrkItmTycd(String mrkItmTycd) {
        this.mrkItmTycd = mrkItmTycd;
    }

    public double getScr() {
        return scr;
    }

    public void setScr(double scr) {
        this.scr = scr;
    }
}
