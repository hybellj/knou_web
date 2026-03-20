package knou.lms.msg.vo;

import knou.lms.common.vo.DefaultVO;

public class MsgSndrDsctnVO extends DefaultVO {
    private static final long serialVersionUID = 1L;

    // 검색 조건
    private String sbjctYr;
    private String sbjctSmstr;
    private String deptId;
    private String sndngSdttm;
    private String sndngEdttm;
    private String sndngGbncd;
    private String rsltGbncd;
    private String[] sndngGbncds;

    // 목록 결과
    private String msgId;
    private int rnum;
    private String sndngGbnnm;
    private String orgnm;
    private String deptnm;
    private String dvclasNo;
    private String rcvrnm;
    private String rcvrTelno;
    private String sndngDttm;
    private String sndngYn;
    private String sndngRsltCd;

    // 요약 결과
    private int pushTotalCnt;
    private int pushSuccCnt;
    private int pushFailCnt;
    private int shrtntTotalCnt;
    private int shrtntSuccCnt;
    private int shrtntFailCnt;
    private int emlTotalCnt;
    private int emlSuccCnt;
    private int emlFailCnt;
    private int alimtalkTotalCnt;
    private int alimtalkSuccCnt;
    private int alimtalkFailCnt;
    private int smsTotalCnt;
    private int smsSuccCnt;
    private int smsFailCnt;
    private int lmsTotalCnt;
    private int lmsSuccCnt;
    private int lmsFailCnt;

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

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
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

    public String getSndngGbncd() {
        return sndngGbncd;
    }

    public void setSndngGbncd(String sndngGbncd) {
        this.sndngGbncd = sndngGbncd;
    }

    public String getRsltGbncd() {
        return rsltGbncd;
    }

    public void setRsltGbncd(String rsltGbncd) {
        this.rsltGbncd = rsltGbncd;
    }

    public String[] getSndngGbncds() {
        return sndngGbncds;
    }

    public void setSndngGbncds(String[] sndngGbncds) {
        this.sndngGbncds = sndngGbncds;
    }

    public int getRnum() {
        return rnum;
    }

    public void setRnum(int rnum) {
        this.rnum = rnum;
    }

    public String getMsgId() {
        return msgId;
    }

    public void setMsgId(String msgId) {
        this.msgId = msgId;
    }

    public String getSndngGbnnm() {
        return sndngGbnnm;
    }

    public void setSndngGbnnm(String sndngGbnnm) {
        this.sndngGbnnm = sndngGbnnm;
    }

    public String getOrgnm() {
        return orgnm;
    }

    public void setOrgnm(String orgnm) {
        this.orgnm = orgnm;
    }

    public String getDeptnm() {
        return deptnm;
    }

    public void setDeptnm(String deptnm) {
        this.deptnm = deptnm;
    }

    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public String getRcvrnm() {
        return rcvrnm;
    }

    public void setRcvrnm(String rcvrnm) {
        this.rcvrnm = rcvrnm;
    }

    public String getRcvrTelno() {
        return rcvrTelno;
    }

    public void setRcvrTelno(String rcvrTelno) {
        this.rcvrTelno = rcvrTelno;
    }

    public String getSndngDttm() {
        return sndngDttm;
    }

    public void setSndngDttm(String sndngDttm) {
        this.sndngDttm = sndngDttm;
    }

    public String getSndngYn() {
        return sndngYn;
    }

    public void setSndngYn(String sndngYn) {
        this.sndngYn = sndngYn;
    }

    public String getSndngRsltCd() {
        return sndngRsltCd;
    }

    public void setSndngRsltCd(String sndngRsltCd) {
        this.sndngRsltCd = sndngRsltCd;
    }

    public int getPushTotalCnt() {
        return pushTotalCnt;
    }

    public void setPushTotalCnt(int pushTotalCnt) {
        this.pushTotalCnt = pushTotalCnt;
    }

    public int getPushSuccCnt() {
        return pushSuccCnt;
    }

    public void setPushSuccCnt(int pushSuccCnt) {
        this.pushSuccCnt = pushSuccCnt;
    }

    public int getPushFailCnt() {
        return pushFailCnt;
    }

    public void setPushFailCnt(int pushFailCnt) {
        this.pushFailCnt = pushFailCnt;
    }

    public int getShrtntTotalCnt() {
        return shrtntTotalCnt;
    }

    public void setShrtntTotalCnt(int shrtntTotalCnt) {
        this.shrtntTotalCnt = shrtntTotalCnt;
    }

    public int getShrtntSuccCnt() {
        return shrtntSuccCnt;
    }

    public void setShrtntSuccCnt(int shrtntSuccCnt) {
        this.shrtntSuccCnt = shrtntSuccCnt;
    }

    public int getShrtntFailCnt() {
        return shrtntFailCnt;
    }

    public void setShrtntFailCnt(int shrtntFailCnt) {
        this.shrtntFailCnt = shrtntFailCnt;
    }

    public int getEmlTotalCnt() {
        return emlTotalCnt;
    }

    public void setEmlTotalCnt(int emlTotalCnt) {
        this.emlTotalCnt = emlTotalCnt;
    }

    public int getEmlSuccCnt() {
        return emlSuccCnt;
    }

    public void setEmlSuccCnt(int emlSuccCnt) {
        this.emlSuccCnt = emlSuccCnt;
    }

    public int getEmlFailCnt() {
        return emlFailCnt;
    }

    public void setEmlFailCnt(int emlFailCnt) {
        this.emlFailCnt = emlFailCnt;
    }

    public int getAlimtalkTotalCnt() {
        return alimtalkTotalCnt;
    }

    public void setAlimtalkTotalCnt(int alimtalkTotalCnt) {
        this.alimtalkTotalCnt = alimtalkTotalCnt;
    }

    public int getAlimtalkSuccCnt() {
        return alimtalkSuccCnt;
    }

    public void setAlimtalkSuccCnt(int alimtalkSuccCnt) {
        this.alimtalkSuccCnt = alimtalkSuccCnt;
    }

    public int getAlimtalkFailCnt() {
        return alimtalkFailCnt;
    }

    public void setAlimtalkFailCnt(int alimtalkFailCnt) {
        this.alimtalkFailCnt = alimtalkFailCnt;
    }

    public int getSmsTotalCnt() {
        return smsTotalCnt;
    }

    public void setSmsTotalCnt(int smsTotalCnt) {
        this.smsTotalCnt = smsTotalCnt;
    }

    public int getSmsSuccCnt() {
        return smsSuccCnt;
    }

    public void setSmsSuccCnt(int smsSuccCnt) {
        this.smsSuccCnt = smsSuccCnt;
    }

    public int getSmsFailCnt() {
        return smsFailCnt;
    }

    public void setSmsFailCnt(int smsFailCnt) {
        this.smsFailCnt = smsFailCnt;
    }

    public int getLmsTotalCnt() {
        return lmsTotalCnt;
    }

    public void setLmsTotalCnt(int lmsTotalCnt) {
        this.lmsTotalCnt = lmsTotalCnt;
    }

    public int getLmsSuccCnt() {
        return lmsSuccCnt;
    }

    public void setLmsSuccCnt(int lmsSuccCnt) {
        this.lmsSuccCnt = lmsSuccCnt;
    }

    public int getLmsFailCnt() {
        return lmsFailCnt;
    }

    public void setLmsFailCnt(int lmsFailCnt) {
        this.lmsFailCnt = lmsFailCnt;
    }
}
