package knou.lms.bbs.vo;

import knou.lms.common.vo.DefaultVO;

public class BbsInfoLangVO extends DefaultVO {

    private static final long serialVersionUID = -5267239720021300843L;
    
    private String bbsId;
    private String langCd;
    private String bbsNm;
    private String bbsDesc;

    public String getBbsId() {
        return bbsId;
    }

    public void setBbsId(String bbsId) {
        this.bbsId = bbsId;
    }

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public String getBbsNm() {
        return bbsNm;
    }

    public void setBbsNm(String bbsNm) {
        this.bbsNm = bbsNm;
    }

    public String getBbsDesc() {
        return bbsDesc;
    }

    public void setBbsDesc(String bbsDesc) {
        this.bbsDesc = bbsDesc;
    }

}
