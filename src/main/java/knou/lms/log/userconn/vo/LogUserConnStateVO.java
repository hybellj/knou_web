package knou.lms.log.userconn.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

/**
 * 사용자 접속 상태 VO
 *
 */
public class LogUserConnStateVO extends DefaultVO {
    private static final long serialVersionUID = 1457664902394936522L;
    private String userId;
    private String connGbn;
    private String crsCreCd;
    private String workLocCd;
    private String deviceTypeCd;
    private String sessionId;
    private String regIp;
    private String connDttm;
    private String userNm;
    private String email; 
    private String mobileNo;
    private String phtFile;
    private byte[] phtFileByte;
    private int    searchTm = 3; // 사용자접속 목록 검색 기준 시간(분)
    private List<String> corsList; // 과목ID 목록

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getWorkLocCd() {
        return workLocCd;
    }

    public void setWorkLocCd(String workLocCd) {
        this.workLocCd = workLocCd;
    }

    public String getDeviceTypeCd() {
        return deviceTypeCd;
    }

    public void setDeviceTypeCd(String deviceTypeCd) {
        this.deviceTypeCd = deviceTypeCd;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public String getRegIp() {
        return regIp;
    }

    public void setRegIp(String regIp) {
        this.regIp = regIp;
    }

    public String getConnDttm() {
        return connDttm;
    }

    public void setConnDttm(String connDttm) {
        this.connDttm = connDttm;
    }

    public String getConnGbn() {
        return connGbn;
    }

    public void setConnGbn(String connGbn) {
        this.connGbn = connGbn;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public int getSearchTm() {
        return searchTm;
    }

    public void setSearchTm(int searchTm) {
        this.searchTm = searchTm;
    }

    public List<String> getCorsList() {
        return corsList;
    }

    public void setCorsList(List<String> corsList) {
        this.corsList = corsList;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMobileNo() {
        return mobileNo;
    }

    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }

    public String getPhtFile() {
        return phtFile;
    }

    public void setPhtFile(String phtFile) {
        this.phtFile = phtFile;
    }

    public byte[] getPhtFileByte() {
        return phtFileByte;
    }

    public void setPhtFileByte(byte[] phtFileByte) {
        this.phtFileByte = phtFileByte;
    }
    
}
