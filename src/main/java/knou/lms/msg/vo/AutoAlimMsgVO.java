package knou.lms.msg.vo;

import knou.lms.common.vo.DefaultVO;

public class AutoAlimMsgVO extends DefaultVO {
    private static final long serialVersionUID = 1L;

    // === TB_LMS_AUTO_ALIM_MSG ===
    private String autoAlimMsgId;
    private String autoAlimnm;
    private String autoAlimMsgCts;
    private String sndngCndtnCts;

    // === TB_LMS_AUTO_ALIM_MSG_TRGT ===
    private String autoAlimMsgTrgtId;
    private String autoAlimTrgtTycd;

    // === 폼 바인딩용 ===
    private String[] autoAlimTrgtTycds;

    // === 목록 표시용 ===
    private String autoAlimTrgtTycdStr;

    // === 일괄 삭제용 ===
    private String[] autoAlimMsgIds;

    public String getAutoAlimMsgId() {
        return autoAlimMsgId;
    }

    public void setAutoAlimMsgId(String autoAlimMsgId) {
        this.autoAlimMsgId = autoAlimMsgId;
    }

    public String getAutoAlimnm() {
        return autoAlimnm;
    }

    public void setAutoAlimnm(String autoAlimnm) {
        this.autoAlimnm = autoAlimnm;
    }

    public String getAutoAlimMsgCts() {
        return autoAlimMsgCts;
    }

    public void setAutoAlimMsgCts(String autoAlimMsgCts) {
        this.autoAlimMsgCts = autoAlimMsgCts;
    }

    public String getSndngCndtnCts() {
        return sndngCndtnCts;
    }

    public void setSndngCndtnCts(String sndngCndtnCts) {
        this.sndngCndtnCts = sndngCndtnCts;
    }

    public String getAutoAlimMsgTrgtId() {
        return autoAlimMsgTrgtId;
    }

    public void setAutoAlimMsgTrgtId(String autoAlimMsgTrgtId) {
        this.autoAlimMsgTrgtId = autoAlimMsgTrgtId;
    }

    public String getAutoAlimTrgtTycd() {
        return autoAlimTrgtTycd;
    }

    public void setAutoAlimTrgtTycd(String autoAlimTrgtTycd) {
        this.autoAlimTrgtTycd = autoAlimTrgtTycd;
    }

    public String[] getAutoAlimTrgtTycds() {
        return autoAlimTrgtTycds;
    }

    public void setAutoAlimTrgtTycds(String[] autoAlimTrgtTycds) {
        this.autoAlimTrgtTycds = autoAlimTrgtTycds;
    }

    public String getAutoAlimTrgtTycdStr() {
        return autoAlimTrgtTycdStr;
    }

    public void setAutoAlimTrgtTycdStr(String autoAlimTrgtTycdStr) {
        this.autoAlimTrgtTycdStr = autoAlimTrgtTycdStr;
    }

    public String[] getAutoAlimMsgIds() {
        return autoAlimMsgIds;
    }

    public void setAutoAlimMsgIds(String[] autoAlimMsgIds) {
        this.autoAlimMsgIds = autoAlimMsgIds;
    }
}
