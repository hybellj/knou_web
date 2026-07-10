package knou.lms.user.vo;

public class UserMsgVO {

    private String channels;
    private String ttl;
    private String cts;
    private String sndngr;
    private String sndngrPhn;
    private String rcvrListJson;

    public UserMsgVO() {
    }

    public String getChannels() {
        return channels;
    }

    public void setChannels(String channels) {
        this.channels = channels;
    }

    public String getTtl() {
        return ttl;
    }

    public void setTtl(String ttl) {
        this.ttl = ttl;
    }

    public String getCts() {
        return cts;
    }

    public void setCts(String cts) {
        this.cts = cts;
    }

    public String getSndngr() {
        return sndngr;
    }

    public void setSndngr(String sndngr) {
        this.sndngr = sndngr;
    }

    public String getSndngrPhn() {
        return sndngrPhn;
    }

    public void setSndngrPhn(String sndngrPhn) {
        this.sndngrPhn = sndngrPhn;
    }

    public String getRcvrListJson() {
        return rcvrListJson;
    }

    public void setRcvrListJson(String rcvrListJson) {
        this.rcvrListJson = rcvrListJson;
    }
}
