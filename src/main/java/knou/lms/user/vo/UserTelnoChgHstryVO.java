package knou.lms.user.vo;

import knou.lms.common.vo.DefaultVO;

public class UserTelnoChgHstryVO extends DefaultVO {
    private String userTelnoChgHstryId;
    private String chgbfrMblTelno;
    private String chgaftMblTelno;
    private String stdntNo;
    private String chgDttm;

    public String getUserTelnoChgHstryId() {
        return userTelnoChgHstryId;
    }

    public void setUserTelnoChgHstryId(String userTelnoChgHstryId) {
        this.userTelnoChgHstryId = userTelnoChgHstryId;
    }

    public String getChgbfrMblTelno() {
        return chgbfrMblTelno;
    }

    public void setChgbfrMblTelno(String chgbfrMblTelno) {
        this.chgbfrMblTelno = chgbfrMblTelno;
    }

    public String getChgaftMblTelno() {
        return chgaftMblTelno;
    }

    public void setChgaftMblTelno(String chgaftMblTelno) {
        this.chgaftMblTelno = chgaftMblTelno;
    }

    public String getStdntNo() {
        return stdntNo;
    }

    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }

    public String getChgDttm() {
        return chgDttm;
    }

    public void setChgDttm(String chgDttm) {
        this.chgDttm = chgDttm;
    }
}
