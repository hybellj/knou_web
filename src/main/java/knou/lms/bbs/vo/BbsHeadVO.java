package knou.lms.bbs.vo;

import knou.lms.common.vo.DefaultVO;

public class BbsHeadVO extends DefaultVO {
  
    private static final long serialVersionUID = 4527114406071284767L;
    
    private String headCd;
    private String bbsId;
    private String headNm;
    private int    headOdr;
    private String useYn;
    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;

    public String getHeadCd() {
        return headCd;
    }

    public void setHeadCd(String headCd) {
        this.headCd = headCd;
    }

    public String getBbsId() {
        return bbsId;
    }

    public void setBbsId(String bbsId) {
        this.bbsId = bbsId;
    }

    public String getHeadNm() {
        return headNm;
    }

    public void setHeadNm(String headNm) {
        this.headNm = headNm;
    }

    public int getHeadOdr() {
        return headOdr;
    }

    public void setHeadOdr(int headOdr) {
        this.headOdr = headOdr;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
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

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getModDttm() {
        return modDttm;
    }

    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

}