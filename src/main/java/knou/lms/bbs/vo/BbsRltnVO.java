package knou.lms.bbs.vo;

import knou.lms.common.vo.DefaultVO;

public class BbsRltnVO extends DefaultVO {

    private static final long serialVersionUID = -5743238104523435868L;
    
    private String bbsId;
    private String rltnRefCd;
    private String rltnType;

    public String getBbsId() {
        return bbsId;
    }

    public void setBbsId(String bbsId) {
        this.bbsId = bbsId;
    }

    public String getRltnRefCd() {
        return rltnRefCd;
    }

    public void setRltnRefCd(String rltnRefCd) {
        this.rltnRefCd = rltnRefCd;
    }

    public String getRltnType() {
        return rltnType;
    }

    public void setRltnType(String rltnType) {
        this.rltnType = rltnType;
    }
}
