package knou.lms.exception.vo;

import java.io.Serializable;
import java.util.Date;

public class SystemExceptionVO implements Serializable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = -746838555841822795L;

	/** 시스템에러아이디 */
    private String sysErrId;

    /** 과목아이디 */
    private String sbjctId;

    /** 시스템에러메시지 */
    private String sysErrMsg;

    /** 시스템에러유형코드 */
    private String sysErrTycd;

    /** 시스템에러요청URL */
    private String sysErrReqUrl;

    /** 시스템에러일시 */
    private Date sysErrDt;

    /** 시스템에러시각 (00~23) */
    private String sysErrHourOfDay;

    /** 시스템에러요일 (월요일 등) */
    private String sysErrDayOfWeek;

    /** 사용자아이디 */
    private String userId;

    /** 등록자아이디 */
    private String rgtrId;

    /** 등록일시 (yyyyMMddHHmmss) */
    private String regDttm;

    /** 수정자아이디 */
    private String mdfrId;

    /** 수정일시 (yyyyMMddHHmmss) */
    private String modDttm;
    
    private String cntnIp;
    
    private String traceId;

    // =========================
    // getter / setter
    // =========================

    public String getSysErrId() { return sysErrId; }
    public void setSysErrId(String sysErrId) { this.sysErrId = sysErrId; }

    public String getSbjctId() { return sbjctId; }
    public void setSbjctId(String sbjctId) { this.sbjctId = sbjctId; }

    public String getSysErrMsg() { return sysErrMsg; }
    public void setSysErrMsg(String sysErrMsg) { this.sysErrMsg = sysErrMsg; }

    public String getSysErrTycd() { return sysErrTycd; }
    public void setSysErrTycd(String sysErrTycd) { this.sysErrTycd = sysErrTycd; }

    public String getSysErrReqUrl() { return sysErrReqUrl; }
    public void setSysErrReqUrl(String sysErrReqUrl) { this.sysErrReqUrl = sysErrReqUrl; }

    public Date getSysErrDt() { return sysErrDt; }
    public void setSysErrDt(Date sysErrDt) { this.sysErrDt = sysErrDt; }

    public String getSysErrHourOfDay() { return sysErrHourOfDay; }
    public void setSysErrHourOfDay(String sysErrHourOfDay) { this.sysErrHourOfDay = sysErrHourOfDay; }

    public String getSysErrDayOfWeek() { return sysErrDayOfWeek; }
    public void setSysErrDayOfWeek(String sysErrDayOfWeek) { this.sysErrDayOfWeek = sysErrDayOfWeek; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getRgtrId() { return rgtrId; }
    public void setRgtrId(String rgtrId) { this.rgtrId = rgtrId; }

    public String getRegDttm() { return regDttm; }
    public void setRegDttm(String regDttm) { this.regDttm = regDttm; }

    public String getMdfrId() { return mdfrId; }
    public void setMdfrId(String mdfrId) { this.mdfrId = mdfrId; }

    public String getModDttm() { return modDttm; }
    public void setModDttm(String modDttm) { this.modDttm = modDttm; }
    
	public void setCntnIp(String cntnIp) {
		this.cntnIp = cntnIp ; 
	}
	public String getCntnIp() {
		return cntnIp;
	}
	public String getTraceId() {
		return traceId;
	}
	public void setTraceId(String traceId) {
		this.traceId = traceId;
	}	
}