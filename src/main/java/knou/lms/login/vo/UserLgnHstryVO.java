package knou.lms.login.vo;

import java.io.Serializable;

import knou.framework.common.IdPrefixType;
import knou.framework.util.IdGenUtil;
import knou.lms.login.param.LoginParam;
import knou.lms.user.param.UserMetaParam;

public class UserLgnHstryVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String userLgnHstryId;   // USER_LGN_HSTRY_ID
    private String userId;           // USER_ID
    private String userSnsId;        // USER_SNS_ID
    private String acsrTycd;         // ACSR_TYCD
    private String lgnIp;            // LGN_IP
    private String lgnDttm;          // LGN_DTTM
    private String lgtDttm;          // LGT_DTTM
    private String lgnScsyn;         // LGN_SCSYN
    private String cntnDvcTycd;      // CNTN_DVC_TYCD
    private String lgnCntnBrwsr;     // LGN_CNTN_BRWSR
    private String sessId;           // SESS_ID
    private String rgtrId;           // RGTR_ID
    private String regDttm;          // REG_DTTM
    private String mdfrId;           // MDFR_ID
    private String modDttm;          // MOD_DTTM
    
    public UserLgnHstryVO() {}
   
    public static UserLgnHstryVO of(LoginParam param, UserMetaParam meta) {
        UserLgnHstryVO vo = new UserLgnHstryVO();        
        vo.setUserId(param.getUserId());
        vo.setAcsrTycd("WEB");
        vo.setLgnIp(meta.getIp());
        vo.setLgnScsyn("Y");
        vo.setCntnDvcTycd(parseDevice(meta.getUserAgent()));
        vo.setLgnCntnBrwsr(meta.getUserAgent());
        vo.setSessId(meta.getSessionId());
        return vo;
    }
    
    private static String parseDevice(String userAgent) {
        if (userAgent == null) return "PC";

        String ua = userAgent.toLowerCase();

        if (ua.contains("mobile") || ua.contains("android") || ua.contains("iphone")) {
            return "MOBILE";
        }
        return "PC";
    }

    // Getter / Setter

    public String getUserLgnHstryId() {
        return userLgnHstryId;
    }

    public void setUserLgnHstryId(String userLgnHstryId) {
        this.userLgnHstryId = userLgnHstryId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserSnsId() {
        return userSnsId;
    }

    public void setUserSnsId(String userSnsId) {
        this.userSnsId = userSnsId;
    }

    public String getAcsrTycd() {
        return acsrTycd;
    }

    public void setAcsrTycd(String acsrTycd) {
        this.acsrTycd = acsrTycd;
    }

    public String getLgnIp() {
        return lgnIp;
    }

    public void setLgnIp(String lgnIp) {
        this.lgnIp = lgnIp;
    }

    public String getLgnDttm() {
        return lgnDttm;
    }

    public void setLgnDttm(String lgnDttm) {
        this.lgnDttm = lgnDttm;
    }

    public String getLgtDttm() {
        return lgtDttm;
    }

    public void setLgtDttm(String lgtDttm) {
        this.lgtDttm = lgtDttm;
    }

    public String getLgnScsyn() {
        return lgnScsyn;
    }

    public void setLgnScsyn(String lgnScsyn) {
        this.lgnScsyn = lgnScsyn;
    }

    public String getCntnDvcTycd() {
        return cntnDvcTycd;
    }

    public void setCntnDvcTycd(String cntnDvcTycd) {
        this.cntnDvcTycd = cntnDvcTycd;
    }

    public String getLgnCntnBrwsr() {
        return lgnCntnBrwsr;
    }

    public void setLgnCntnBrwsr(String lgnCntnBrwsr) {
        this.lgnCntnBrwsr = lgnCntnBrwsr;
    }

    public String getSessId() {
        return sessId;
    }

    public void setSessId(String sessId) {
        this.sessId = sessId;
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

    @Override
    public String toString() {
        return "UserLgnHstryVO{" +
                "userLgnHstryId='" + userLgnHstryId + '\'' +
                ", userId='" + userId + '\'' +
                ", userSnsId='" + userSnsId + '\'' +
                ", acsrTycd='" + acsrTycd + '\'' +
                ", lgnIp='" + lgnIp + '\'' +
                ", lgnDttm='" + lgnDttm + '\'' +
                ", lgtDttm='" + lgtDttm + '\'' +
                ", lgnScsyn='" + lgnScsyn + '\'' +
                ", cntnDvcTycd='" + cntnDvcTycd + '\'' +
                ", lgnCntnBrwsr='" + lgnCntnBrwsr + '\'' +
                ", sessId='" + sessId + '\'' +
                ", rgtrId='" + rgtrId + '\'' +
                ", regDttm='" + regDttm + '\'' +
                ", mdfrId='" + mdfrId + '\'' +
                ", modDttm='" + modDttm + '\'' +
                '}';
    }
}