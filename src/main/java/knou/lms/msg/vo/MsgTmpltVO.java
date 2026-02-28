package knou.lms.msg.vo;

import knou.lms.common.vo.DefaultVO;

public class MsgTmpltVO extends DefaultVO {
    private static final long serialVersionUID = 1L;

    private String msgTmpltId;
    private String msgCtsGbncd;
    private String msgTmpltTtl;
    private String msgTmpltCts;

    private String[] msgTmpltIds;

    public String getMsgTmpltId() {
        return msgTmpltId;
    }

    public void setMsgTmpltId(String msgTmpltId) {
        this.msgTmpltId = msgTmpltId;
    }

    public String getMsgCtsGbncd() {
        return msgCtsGbncd;
    }

    public void setMsgCtsGbncd(String msgCtsGbncd) {
        this.msgCtsGbncd = msgCtsGbncd;
    }

    public String getMsgTmpltTtl() {
        return msgTmpltTtl;
    }

    public void setMsgTmpltTtl(String msgTmpltTtl) {
        this.msgTmpltTtl = msgTmpltTtl;
    }

    public String getMsgTmpltCts() {
        return msgTmpltCts;
    }

    public void setMsgTmpltCts(String msgTmpltCts) {
        this.msgTmpltCts = msgTmpltCts;
    }

    public String[] getMsgTmpltIds() {
        return msgTmpltIds;
    }

    public void setMsgTmpltIds(String[] msgTmpltIds) {
        this.msgTmpltIds = msgTmpltIds;
    }
}
