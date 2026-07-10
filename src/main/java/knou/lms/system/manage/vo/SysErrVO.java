package knou.lms.system.manage.vo;

public class SysErrVO {

    // 멤버 변수 (Fields)
    private String sysErrId;         // SYS_ERR_ID
    private String sbjctId;        // SBJCT_ID
    private String sysErrMsg;      // SYS_ERR_MSG
    private String sysErrTycd;     // SYS_ERR_TYCD
    private String sysErrReqUrl;   // SYS_ERR_REQ_URL
    private String sysErrDt;       // SYS_ERR_DT (날짜 String)
    private Integer sysErrHourofday;// SYS_ERR_HOUROFDAY
    private String sysErrDayofweek; // SYS_ERR_DAYOFWEEK
    private String userId;         // USER_ID
    private String rgtrId;         // RGTR_ID
    private String regDttm;        // REG_DTTM (날짜 String)
    private String mdfrId;         // MDFR_ID
    private String modDttm;        // MOD_DTTM (날짜 String)
    private String cntnIp;         // CNTN_IP
    private String traceId;        // TRACE_ID

    // 기본 생성자
    public SysErrVO() {}
	
	// Getter and Setter Methods
    public String getSysErrId() {
        return sysErrId;
    }

    public void setSysErrId(String sysErrId) {
        this.sysErrId = sysErrId;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getSysErrMsg() {
        return sysErrMsg;
    }

    public void setSysErrMsg(String sysErrMsg) {
        this.sysErrMsg = sysErrMsg;
    }

    public String getSysErrTycd() {
        return sysErrTycd;
    }

    public void setSysErrTycd(String sysErrTycd) {
        this.sysErrTycd = sysErrTycd;
    }

    public String getSysErrReqUrl() {
        return sysErrReqUrl;
    }

    public void setSysErrReqUrl(String sysErrReqUrl) {
        this.sysErrReqUrl = sysErrReqUrl;
    }

    public String getSysErrDt() {
        return sysErrDt;
    }

    public void setSysErrDt(String sysErrDt) {
        this.sysErrDt = sysErrDt;
    }

    public Integer getSysErrHourofday() {
        return sysErrHourofday;
    }

    public void setSysErrHourofday(Integer sysErrHourofday) {
        this.sysErrHourofday = sysErrHourofday;
    }

    public String getSysErrDayofweek() {
        return sysErrDayofweek;
    }

    public void setSysErrDayofweek(String sysErrDayofweek) {
        this.sysErrDayofweek = sysErrDayofweek;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
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

    public String getCntnIp() {
        return cntnIp;
    }

    public void setCntnIp(String cntnIp) {
        this.cntnIp = cntnIp;
    }

    public String getTraceId() {
        return traceId;
    }

    public void setTraceId(String traceId) {
        this.traceId = traceId;
    }

    // toString() Method
    @Override
    public String toString() {
        return "SysErrVO [" +
                "sysErrId=" + sysErrId +
                ", sbjctId='" + sbjctId + '\'' +
                ", sysErrMsg='" + sysErrMsg + '\'' +
                ", sysErrTycd='" + sysErrTycd + '\'' +
                ", sysErrReqUrl='" + sysErrReqUrl + '\'' +
                ", sysErrDt='" + sysErrDt + '\'' +
                ", sysErrHourofday=" + sysErrHourofday +
                ", sysErrDayofweek='" + sysErrDayofweek + '\'' +
                ", userId='" + userId + '\'' +
                ", rgtrId='" + rgtrId + '\'' +
                ", regDttm='" + regDttm + '\'' +
                ", mdfrId='" + mdfrId + '\'' +
                ", modDttm='" + modDttm + '\'' +
                ", cntnIp='" + cntnIp + '\'' +
                ", traceId='" + traceId + '\'' +
                ']';
    }
}