package knou.lms.msg.vo;

import knou.lms.common.vo.DefaultVO;

import java.util.List;

public class MsgMgrVO extends DefaultVO {
    private static final long serialVersionUID = 1L;

    private String sbjctYr;
    private String sbjctSmstr;
    private String sbjctId;
    private String sbjctnm;
    private String sndngrId;
    private String adminYn;
    private String userTycd;
    private String stdntNo;
    private String usernm;
    private String mblPhn;
    private String eml;

    private List<String> userIdList;

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

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getSbjctnm() {
        return sbjctnm;
    }

    public void setSbjctnm(String sbjctnm) {
        this.sbjctnm = sbjctnm;
    }

    public String getSndngrId() {
        return sndngrId;
    }

    public void setSndngrId(String sndngrId) {
        this.sndngrId = sndngrId;
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
