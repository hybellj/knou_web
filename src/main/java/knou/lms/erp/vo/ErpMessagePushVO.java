package knou.lms.erp.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;
import knou.lms.user.vo.UsrUserInfoVO;

public class ErpMessagePushVO extends DefaultVO {

    private static final long serialVersionUID = -4301776214984175070L;

    private String pushNo;
    private String pushSeq;
    private String userId;
    private String userNm;
    private String sysCd;
    private String orgId;
    private String bussGbn;
    private String sendRcvGbn;
    private String subject;
    private String ctnt;
    private String sendDttm;
    private String sndrPersNo;
    private String sndrDeptCd;
    private String sndrNm;
    private String sndrPhoneNo;
    private String rcvPhoneNo;
    private String courseCd;
    private String rgtrId;
    private String regDttm;
    private String regIp;
    private String mdfrId;
    private String modDttm;
    private String modIp;

    private String pushLogNo;
    private String logGbn;
    private int    rcvNum;
    private String logDesc;

    private List<UsrUserInfoVO> usrUserInfoList; // 수신자 목록 발송

    public String getPushNo() {
        return pushNo;
    }

    public void setPushNo(String pushNo) {
        this.pushNo = pushNo;
    }

    public String getPushSeq() {
        return pushSeq;
    }

    public void setPushSeq(String pushSeq) {
        this.pushSeq = pushSeq;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public String getSysCd() {
        return sysCd;
    }

    public void setSysCd(String sysCd) {
        this.sysCd = sysCd;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getBussGbn() {
        return bussGbn;
    }

    public void setBussGbn(String bussGbn) {
        this.bussGbn = bussGbn;
    }

    public String getSendRcvGbn() {
        return sendRcvGbn;
    }

    public void setSendRcvGbn(String sendRcvGbn) {
        this.sendRcvGbn = sendRcvGbn;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getCtnt() {
        return ctnt;
    }

    public void setCtnt(String ctnt) {
        this.ctnt = ctnt;
    }

    public String getSendDttm() {
        return sendDttm;
    }

    public void setSendDttm(String sendDttm) {
        this.sendDttm = sendDttm;
    }

    public String getSndrPersNo() {
        return sndrPersNo;
    }

    public void setSndrPersNo(String sndrPersNo) {
        this.sndrPersNo = sndrPersNo;
    }

    public String getSndrDeptCd() {
        return sndrDeptCd;
    }

    public void setSndrDeptCd(String sndrDeptCd) {
        this.sndrDeptCd = sndrDeptCd;
    }

    public String getSndrNm() {
        return sndrNm;
    }

    public void setSndrNm(String sndrNm) {
        this.sndrNm = sndrNm;
    }

    public String getSndrPhoneNo() {
        return sndrPhoneNo;
    }

    public void setSndrPhoneNo(String sndrPhoneNo) {
        this.sndrPhoneNo = sndrPhoneNo;
    }

    public String getRcvPhoneNo() {
        return rcvPhoneNo;
    }

    public void setRcvPhoneNo(String rcvPhoneNo) {
        this.rcvPhoneNo = rcvPhoneNo;
    }

    public String getCourseCd() {
        return courseCd;
    }

    public void setCourseCd(String courseCd) {
        this.courseCd = courseCd;
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

    public String getRegIp() {
        return regIp;
    }

    public void setRegIp(String regIp) {
        this.regIp = regIp;
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

    public String getModIp() {
        return modIp;
    }

    public void setModIp(String modIp) {
        this.modIp = modIp;
    }

    public String getPushLogNo() {
        return pushLogNo;
    }

    public void setPushLogNo(String pushLogNo) {
        this.pushLogNo = pushLogNo;
    }

    public String getLogGbn() {
        return logGbn;
    }

    public void setLogGbn(String logGbn) {
        this.logGbn = logGbn;
    }

    public String getLogDesc() {
        return logDesc;
    }

    public void setLogDesc(String logDesc) {
        this.logDesc = logDesc;
    }

    public int getRcvNum() {
        return rcvNum;
    }

    public void setRcvNum(int rcvNum) {
        this.rcvNum = rcvNum;
    }

    public List<UsrUserInfoVO> getUsrUserInfoList() {
        return usrUserInfoList;
    }

    public void setUsrUserInfoList(List<UsrUserInfoVO> usrUserInfoList) {
        this.usrUserInfoList = usrUserInfoList;
    }

}
