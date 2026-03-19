package knou.lms.msg.vo;

import knou.lms.common.vo.DefaultVO;

public class MsgAlimVO extends DefaultVO {
    private static final long serialVersionUID = 1L;

    private String sndngTycd;
    private int listCnt = 5;

    private String msgId;
    private String msgTmpltId;
    private String msgTycd;
    private String msgCtsGbncd;
    private String dgrsYr;
    private String smstr;
    private String ttl;
    private String txtCts;
    private String htmlCts;
    private String sndngOnlyyn;
    private String reqSdttm;
    private String reqEdttm;
    private String rsrvSndngSdttm;
    private String rsrvSndngCnclDttm;
    private Integer sndngRetryMaxCnt;
    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;

    private String sndngId;
    private String msgShrtntSndngId;
    private String msgMblSndngId;
    private String sndngrId;
    private String sndngnm;
    private String sndngTtl;
    private String sndngCts;
    private String sndngDttm;
    private String sndngDttmFmt;
    private String readDttm;
    private String readYn;

    private String sbjctnm;

    private int pushCnt;
    private int smsCnt;
    private int shrtntCnt;
    private int alimtalkCnt;
    private int totalUnreadCnt;

    public String getSndngTycd() {
        return sndngTycd;
    }

    public void setSndngTycd(String sndngTycd) {
        this.sndngTycd = sndngTycd;
    }

    public int getListCnt() {
        return listCnt;
    }

    public void setListCnt(int listCnt) {
        this.listCnt = listCnt;
    }

    public String getMsgId() {
        return msgId;
    }

    public void setMsgId(String msgId) {
        this.msgId = msgId;
    }

    public String getSndngId() {
        return sndngId;
    }

    public void setSndngId(String sndngId) {
        this.sndngId = sndngId;
    }

    public String getMsgShrtntSndngId() {
        return msgShrtntSndngId;
    }

    public void setMsgShrtntSndngId(String msgShrtntSndngId) {
        this.msgShrtntSndngId = msgShrtntSndngId;
    }

    public String getMsgMblSndngId() {
        return msgMblSndngId;
    }

    public void setMsgMblSndngId(String msgMblSndngId) {
        this.msgMblSndngId = msgMblSndngId;
    }

    public String getSndngrId() {
        return sndngrId;
    }

    public void setSndngrId(String sndngrId) {
        this.sndngrId = sndngrId;
    }

    public String getSndngnm() {
        return sndngnm;
    }

    public void setSndngnm(String sndngnm) {
        this.sndngnm = sndngnm;
    }

    public String getSndngTtl() {
        return sndngTtl;
    }

    public void setSndngTtl(String sndngTtl) {
        this.sndngTtl = sndngTtl;
    }

    public String getSndngCts() {
        return sndngCts;
    }

    public void setSndngCts(String sndngCts) {
        this.sndngCts = sndngCts;
    }

    public String getSndngDttm() {
        return sndngDttm;
    }

    public void setSndngDttm(String sndngDttm) {
        this.sndngDttm = sndngDttm;
    }

    public String getSndngDttmFmt() {
        return sndngDttmFmt;
    }

    public void setSndngDttmFmt(String sndngDttmFmt) {
        this.sndngDttmFmt = sndngDttmFmt;
    }

    public String getReadDttm() {
        return readDttm;
    }

    public void setReadDttm(String readDttm) {
        this.readDttm = readDttm;
    }

    public String getReadYn() {
        return readYn;
    }

    public void setReadYn(String readYn) {
        this.readYn = readYn;
    }

    public int getPushCnt() {
        return pushCnt;
    }

    public void setPushCnt(int pushCnt) {
        this.pushCnt = pushCnt;
    }

    public int getSmsCnt() {
        return smsCnt;
    }

    public void setSmsCnt(int smsCnt) {
        this.smsCnt = smsCnt;
    }

    public int getShrtntCnt() {
        return shrtntCnt;
    }

    public void setShrtntCnt(int shrtntCnt) {
        this.shrtntCnt = shrtntCnt;
    }

    public int getAlimtalkCnt() {
        return alimtalkCnt;
    }

    public void setAlimtalkCnt(int alimtalkCnt) {
        this.alimtalkCnt = alimtalkCnt;
    }

    public int getTotalUnreadCnt() {
        return totalUnreadCnt;
    }

    public void setTotalUnreadCnt(int totalUnreadCnt) {
        this.totalUnreadCnt = totalUnreadCnt;
    }

    public String getMsgTmpltId() {
        return msgTmpltId;
    }

    public void setMsgTmpltId(String msgTmpltId) {
        this.msgTmpltId = msgTmpltId;
    }

    public String getMsgTycd() {
        return msgTycd;
    }

    public void setMsgTycd(String msgTycd) {
        this.msgTycd = msgTycd;
    }

    public String getMsgCtsGbncd() {
        return msgCtsGbncd;
    }

    public void setMsgCtsGbncd(String msgCtsGbncd) {
        this.msgCtsGbncd = msgCtsGbncd;
    }

    public String getDgrsYr() {
        return dgrsYr;
    }

    public void setDgrsYr(String dgrsYr) {
        this.dgrsYr = dgrsYr;
    }

    public String getSmstr() {
        return smstr;
    }

    public void setSmstr(String smstr) {
        this.smstr = smstr;
    }

    public String getTtl() {
        return ttl;
    }

    public void setTtl(String ttl) {
        this.ttl = ttl;
    }

    public String getTxtCts() {
        return txtCts;
    }

    public void setTxtCts(String txtCts) {
        this.txtCts = txtCts;
    }

    public String getHtmlCts() {
        return htmlCts;
    }

    public void setHtmlCts(String htmlCts) {
        this.htmlCts = htmlCts;
    }

    public String getSndngOnlyyn() {
        return sndngOnlyyn;
    }

    public void setSndngOnlyyn(String sndngOnlyyn) {
        this.sndngOnlyyn = sndngOnlyyn;
    }

    public String getReqSdttm() {
        return reqSdttm;
    }

    public void setReqSdttm(String reqSdttm) {
        this.reqSdttm = reqSdttm;
    }

    public String getReqEdttm() {
        return reqEdttm;
    }

    public void setReqEdttm(String reqEdttm) {
        this.reqEdttm = reqEdttm;
    }

    public String getRsrvSndngSdttm() {
        return rsrvSndngSdttm;
    }

    public void setRsrvSndngSdttm(String rsrvSndngSdttm) {
        this.rsrvSndngSdttm = rsrvSndngSdttm;
    }

    public String getRsrvSndngCnclDttm() {
        return rsrvSndngCnclDttm;
    }

    public void setRsrvSndngCnclDttm(String rsrvSndngCnclDttm) {
        this.rsrvSndngCnclDttm = rsrvSndngCnclDttm;
    }

    public Integer getSndngRetryMaxCnt() {
        return sndngRetryMaxCnt;
    }

    public void setSndngRetryMaxCnt(Integer sndngRetryMaxCnt) {
        this.sndngRetryMaxCnt = sndngRetryMaxCnt;
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

    public String getSbjctnm() {
        return sbjctnm;
    }

    public void setSbjctnm(String sbjctnm) {
        this.sbjctnm = sbjctnm;
    }
}