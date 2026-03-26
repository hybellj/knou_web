package knou.lms.msg.vo;

import knou.lms.common.vo.DefaultVO;

public class MsgAlimVO extends DefaultVO {
    private static final long serialVersionUID = 1L;

    private String sndngTycd;
    private int listCnt = 5;

    private String msgId;

    private String sndngId;
    private String sndngrId;
    private String sndngnm;
    private String sndngTtl;
    private String sndngDttm;
    private String readDttm;
    private String readYn;

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

    public String getSndngDttm() {
        return sndngDttm;
    }

    public void setSndngDttm(String sndngDttm) {
        this.sndngDttm = sndngDttm;
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
}
