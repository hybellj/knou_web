package knou.lms.log.recom.vo;

import knou.lms.common.vo.DefaultVO;

public class LogRecomVO extends DefaultVO {

    private String recomCd;
    private String rltnType;
    private String rltnCd;
    private String rgtrId;
    private String regDttm;

    public String getRecomCd() {
        return recomCd;
    }

    public void setRecomCd(String recomCd) {
        this.recomCd = recomCd;
    }

    public String getRltnType() {
        return rltnType;
    }

    public void setRltnType(String rltnType) {
        this.rltnType = rltnType;
    }

    public String getRltnCd() {
        return rltnCd;
    }

    public void setRltnCd(String rltnCd) {
        this.rltnCd = rltnCd;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getRegDttm() {
        return regDttm;
    }

    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

}