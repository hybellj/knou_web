package knou.lms.mrk.vo;

import knou.lms.common.vo.DefaultVO;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class SubjectMarkDetailVO extends DefaultVO {

    private String sbjctMrkDtlId;   // 성적 과목 상세 아이디
    private String sbjctMrkId;      // 성적 과목 아이디
    private String mrkItmTycd;      // 성적 항목 유형코드

    private BigDecimal acqsScr;     // 취득점수
    private BigDecimal drvtnScr;    // 산출점수

    public SubjectMarkDetailVO() {
    }



    public SubjectMarkDetailVO(String userId, String sbjctMrkId, String mrkItmTycd, BigDecimal mrkRfltrt, BigDecimal acqsScr) {
        super();
        this.setUserId(userId);
        this.sbjctMrkId = sbjctMrkId;
        this.mrkItmTycd = mrkItmTycd;
        this.acqsScr = acqsScr;
        this.drvtnScr = acqsScr.multiply(mrkRfltrt).setScale(2, RoundingMode.HALF_UP); // 소수점 둘째짜리까지 표시. 반올림.
    }

    public String getSbjctMrkDtlId() {
        return sbjctMrkDtlId;
    }

    public void setSbjctMrkDtlId(String sbjctMrkDtlId) {
        this.sbjctMrkDtlId = sbjctMrkDtlId;
    }

    public String getSbjctMrkId() {
        return sbjctMrkId;
    }

    public void setSbjctMrkId(String sbjctMrkId) {
        this.sbjctMrkId = sbjctMrkId;
    }

    public String getMrkItmTycd() {
        return mrkItmTycd;
    }

    public void setMrkItmTycd(String mrkItmTycd) {
        this.mrkItmTycd = mrkItmTycd;
    }

    public BigDecimal getAcqsScr() {
        return acqsScr;
    }

    public void setAcqsScr(BigDecimal acqsScr) {
        this.acqsScr = acqsScr;
    }

    public BigDecimal getDrvtnScr() {
        return drvtnScr;
    }

    public void setDrvtnScr(BigDecimal drvtnScr) {
        this.drvtnScr = drvtnScr;
    }
}
