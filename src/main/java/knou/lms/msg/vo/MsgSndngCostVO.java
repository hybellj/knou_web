package knou.lms.msg.vo;

import knou.lms.common.vo.DefaultVO;

public class MsgSndngCostVO extends DefaultVO {
    private static final long serialVersionUID = 1L;

    private String sndngCostId;
    private String msgTycd;
    private String sndngCost;
    private String useyn;

    public String getSndngCostId() {
        return sndngCostId;
    }

    public void setSndngCostId(String sndngCostId) {
        this.sndngCostId = sndngCostId;
    }

    public String getMsgTycd() {
        return msgTycd;
    }

    public void setMsgTycd(String msgTycd) {
        this.msgTycd = msgTycd;
    }

    public String getSndngCost() {
        return sndngCost;
    }

    public void setSndngCost(String sndngCost) {
        this.sndngCost = sndngCost;
    }

    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
    }
}
