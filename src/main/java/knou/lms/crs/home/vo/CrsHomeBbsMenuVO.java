package knou.lms.crs.home.vo;

import knou.lms.common.vo.DefaultVO;

public class CrsHomeBbsMenuVO extends DefaultVO {
    private static final long serialVersionUID = -3050336327615798979L;

    private String bbsId;
    private String bbsCd;
    private String bbsNm;
    private String bbsNmEn;
    private String sysDefaultYn;
    private String crsCreCd;

    public String getBbsId() {
        return bbsId;
    }

    public void setBbsId(String bbsId) {
        this.bbsId = bbsId;
    }

    public String getBbsCd() {
        return bbsCd;
    }

    public void setBbsCd(String bbsCd) {
        this.bbsCd = bbsCd;
    }

    public String getBbsNm() {
        return bbsNm;
    }

    public void setBbsNm(String bbsNm) {
        this.bbsNm = bbsNm;
    }

    public String getSysDefaultYn() {
        return sysDefaultYn;
    }

    public void setSysDefaultYn(String sysDefaultYn) {
        this.sysDefaultYn = sysDefaultYn;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getBbsNmEn() {
        return bbsNmEn;
    }

    public void setBbsNmEn(String bbsNmEn) {
        this.bbsNmEn = bbsNmEn;
    }

}