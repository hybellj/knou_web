package knou.lms.msg.vo;

import knou.lms.common.vo.DefaultVO;

public class MsgRcptnAgreVO extends DefaultVO {
    private static final long serialVersionUID = 1L;

    // 검색 조건
    private String sbjctYr;
    private String sbjctSmstr;
    private String userTycd;

    // 목록 결과
    private int rnum;
    private String orgnm;
    private String dvclasNo;
    private String stdntNo;
    private String usernm;
    private String mblPhn;
    private String eml;

    // 수신 동의
    private String pushRcvyn;
    private String shrtntAlimRcvyn;
    private String emlAlimRcvyn;
    private String alimTalkRcvyn;
    private String smsRcvyn;

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

    public String getUserTycd() {
        return userTycd;
    }

    public void setUserTycd(String userTycd) {
        this.userTycd = userTycd;
    }

    public int getRnum() {
        return rnum;
    }

    public void setRnum(int rnum) {
        this.rnum = rnum;
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

    public String getPushRcvyn() {
        return pushRcvyn;
    }

    public void setPushRcvyn(String pushRcvyn) {
        this.pushRcvyn = pushRcvyn;
    }

    public String getShrtntAlimRcvyn() {
        return shrtntAlimRcvyn;
    }

    public void setShrtntAlimRcvyn(String shrtntAlimRcvyn) {
        this.shrtntAlimRcvyn = shrtntAlimRcvyn;
    }

    public String getEmlAlimRcvyn() {
        return emlAlimRcvyn;
    }

    public void setEmlAlimRcvyn(String emlAlimRcvyn) {
        this.emlAlimRcvyn = emlAlimRcvyn;
    }

    public String getAlimTalkRcvyn() {
        return alimTalkRcvyn;
    }

    public void setAlimTalkRcvyn(String alimTalkRcvyn) {
        this.alimTalkRcvyn = alimTalkRcvyn;
    }

    public String getSmsRcvyn() {
        return smsRcvyn;
    }

    public void setSmsRcvyn(String smsRcvyn) {
        this.smsRcvyn = smsRcvyn;
    }
}
