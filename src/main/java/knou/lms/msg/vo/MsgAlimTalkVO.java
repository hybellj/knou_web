package knou.lms.msg.vo;

import knou.lms.common.vo.DefaultVO;

import java.util.List;

public class MsgAlimTalkVO extends DefaultVO {
    private static final long serialVersionUID = 1L;

    private String msgId;
    private String msgTmpltId;
    private String msgTycd;
    private String msgCtsGbncd;
    private String ttl;
    private String txtCts;
    private String htmlCts;
    private String rsrvSndngSdttm;
    private String smstr;
    private String rsrvSndngCnclDttm;

    private String msgMblSndngId;
    private String upMsgMblSndngId;
    private String mblSndngTycd;
    private String sndngTtl;
    private String sndngCts;
    private String sndngDttm;
    private String sndngrId;
    private String sndngnm;
    private String sndngPhnno;
    private String sndngRetrySeqno;
    private String sndngRsltCd;
    private String rcvrId;
    private String rcvrnm;
    private String readDttm;
    private String sndngrDelyn;
    private String rcvrDelyn;

    private String sbjctYr;
    private String sbjctSmstr;
    private String sndngSdttm;
    private String sndngEdttm;
    private String listType;

    private String efctvSndngDttm;

    private String orgnm;
    private String dvclasNo;
    private String readYn;
    private int rcvrCnt;
    private String rsrvYn;
    private String fullyPendingYn;
    private String sndngYn;
    private String sndngStscd;
    private String sndngRsltCts;
    private int sndngSuccCnt;

    private String rcvrListJson;
    private String sndngrPhnno;

    private List<String> userIdList;

    private String adminYn;
    private String userTycd;
    private String stdntNo;
    private String usernm;
    private String mblPhn;
    private String eml;

    public String getMsgId() {
        return msgId;
    }

    public void setMsgId(String msgId) {
        this.msgId = msgId;
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

    public String getRsrvSndngSdttm() {
        return rsrvSndngSdttm;
    }

    public void setRsrvSndngSdttm(String rsrvSndngSdttm) {
        this.rsrvSndngSdttm = rsrvSndngSdttm;
    }

    public String getSmstr() {
        return smstr;
    }

    public void setSmstr(String smstr) {
        this.smstr = smstr;
    }

    public String getRsrvSndngCnclDttm() {
        return rsrvSndngCnclDttm;
    }

    public void setRsrvSndngCnclDttm(String rsrvSndngCnclDttm) {
        this.rsrvSndngCnclDttm = rsrvSndngCnclDttm;
    }

    public String getMsgMblSndngId() {
        return msgMblSndngId;
    }

    public void setMsgMblSndngId(String msgMblSndngId) {
        this.msgMblSndngId = msgMblSndngId;
    }

    public String getUpMsgMblSndngId() {
        return upMsgMblSndngId;
    }

    public void setUpMsgMblSndngId(String upMsgMblSndngId) {
        this.upMsgMblSndngId = upMsgMblSndngId;
    }

    public String getMblSndngTycd() {
        return mblSndngTycd;
    }

    public void setMblSndngTycd(String mblSndngTycd) {
        this.mblSndngTycd = mblSndngTycd;
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

    public String getSndngPhnno() {
        return sndngPhnno;
    }

    public void setSndngPhnno(String sndngPhnno) {
        this.sndngPhnno = sndngPhnno;
    }

    public String getSndngRetrySeqno() {
        return sndngRetrySeqno;
    }

    public void setSndngRetrySeqno(String sndngRetrySeqno) {
        this.sndngRetrySeqno = sndngRetrySeqno;
    }

    public String getSndngRsltCd() {
        return sndngRsltCd;
    }

    public void setSndngRsltCd(String sndngRsltCd) {
        this.sndngRsltCd = sndngRsltCd;
    }

    public String getRcvrId() {
        return rcvrId;
    }

    public void setRcvrId(String rcvrId) {
        this.rcvrId = rcvrId;
    }

    public String getRcvrnm() {
        return rcvrnm;
    }

    public void setRcvrnm(String rcvrnm) {
        this.rcvrnm = rcvrnm;
    }

    public String getReadDttm() {
        return readDttm;
    }

    public void setReadDttm(String readDttm) {
        this.readDttm = readDttm;
    }

    public String getSndngrDelyn() {
        return sndngrDelyn;
    }

    public void setSndngrDelyn(String sndngrDelyn) {
        this.sndngrDelyn = sndngrDelyn;
    }

    public String getRcvrDelyn() {
        return rcvrDelyn;
    }

    public void setRcvrDelyn(String rcvrDelyn) {
        this.rcvrDelyn = rcvrDelyn;
    }

    public String getSbjctYr() {
        return sbjctYr;
    }

    public void setSbjctYr(String sbjctYr) {
        this.sbjctYr = sbjctYr;
    }

    public String getSbjctSmstr() {
        return sbjctSmstr;
    }

    public void setSbjctSmstr(String sbjctSmstr) {
        this.sbjctSmstr = sbjctSmstr;
    }

    public String getSndngSdttm() {
        return sndngSdttm;
    }

    public void setSndngSdttm(String sndngSdttm) {
        this.sndngSdttm = sndngSdttm;
    }

    public String getSndngEdttm() {
        return sndngEdttm;
    }

    public void setSndngEdttm(String sndngEdttm) {
        this.sndngEdttm = sndngEdttm;
    }

    public String getListType() {
        return listType;
    }

    public void setListType(String listType) {
        this.listType = listType;
    }

    public String getEfctvSndngDttm() {
        return efctvSndngDttm;
    }

    public void setEfctvSndngDttm(String efctvSndngDttm) {
        this.efctvSndngDttm = efctvSndngDttm;
    }

    public String getOrgnm() {
        return orgnm;
    }

    public void setOrgnm(String orgnm) {
        this.orgnm = orgnm;
    }


    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public String getReadYn() {
        return readYn;
    }

    public void setReadYn(String readYn) {
        this.readYn = readYn;
    }

    public int getRcvrCnt() {
        return rcvrCnt;
    }

    public void setRcvrCnt(int rcvrCnt) {
        this.rcvrCnt = rcvrCnt;
    }

    public String getRsrvYn() {
        return rsrvYn;
    }

    public void setRsrvYn(String rsrvYn) {
        this.rsrvYn = rsrvYn;
    }

    public String getFullyPendingYn() {
        return fullyPendingYn;
    }

    public void setFullyPendingYn(String fullyPendingYn) {
        this.fullyPendingYn = fullyPendingYn;
    }

    public String getSndngYn() {
        return sndngYn;
    }

    public void setSndngYn(String sndngYn) {
        this.sndngYn = sndngYn;
    }

    public String getSndngStscd() {
        return sndngStscd;
    }

    public void setSndngStscd(String sndngStscd) {
        this.sndngStscd = sndngStscd;
    }

    public String getSndngRsltCts() {
        return sndngRsltCts;
    }

    public void setSndngRsltCts(String sndngRsltCts) {
        this.sndngRsltCts = sndngRsltCts;
    }

    public int getSndngSuccCnt() {
        return sndngSuccCnt;
    }

    public void setSndngSuccCnt(int sndngSuccCnt) {
        this.sndngSuccCnt = sndngSuccCnt;
    }

    public String getRcvrListJson() {
        return rcvrListJson;
    }

    public void setRcvrListJson(String rcvrListJson) {
        this.rcvrListJson = rcvrListJson;
    }

    public String getSndngrPhnno() {
        return sndngrPhnno;
    }

    public void setSndngrPhnno(String sndngrPhnno) {
        this.sndngrPhnno = sndngrPhnno;
    }

    public String getAdminYn() {
        return adminYn;
    }

    public void setAdminYn(String adminYn) {
        this.adminYn = adminYn;
    }

    public String getUserTycd() {
        return userTycd;
    }

    public void setUserTycd(String userTycd) {
        this.userTycd = userTycd;
    }

    public String getStdntNo() {
        return stdntNo;
    }

    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }

    public String getUsernm() {
        return usernm;
    }

    public void setUsernm(String usernm) {
        this.usernm = usernm;
    }

    public String getMblPhn() {
        return mblPhn;
    }

    public void setMblPhn(String mblPhn) {
        this.mblPhn = mblPhn;
    }

    public String getEml() {
        return eml;
    }

    public void setEml(String eml) {
        this.eml = eml;
    }


    public List<String> getUserIdList() {
        return userIdList;
    }

    public void setUserIdList(List<String> userIdList) {
        this.userIdList = userIdList;
    }

}
