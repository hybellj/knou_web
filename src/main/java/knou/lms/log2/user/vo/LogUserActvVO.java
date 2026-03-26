package knou.lms.log2.user.vo;

import knou.lms.common.vo.DefaultVO;

public class LogUserActvVO extends DefaultVO {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 9169428961607751473L;

	/** 사용자활동ID */
    private String userActvId;

    /** 사용자ID */
    private String userId;

    /** 교과목개설ID */
    private String subjectId;

    /** 요청유형코드 */
    private String reqTycd;

    /** 사용자요청URL */
    private String userReqUrl;

    /** 사용자요청메뉴 */
    private String userReqMenu;

    /** 사용자요청내용 */
    private String userReqCts;

    /** 사용자유형코드 */
    private String userTycd;

    /** 접속IP */
    private String cntnIp;

    /** 접속기기유형코드 */
    private String cntnDvcTycd;

    /** 접속브라우저 */
    private String cntnBrwsr;

    /** 활동일시 (YYYYMMDDHH24MISS) */
    private String actvDttm;

    /** 세션ID */
    private String sessId;

    /** 세션시작일시 (YYYYMMDDHH24MISS) */
    private String sessSdttm;

    /** 세션종료일시 (YYYYMMDDHH24MISS) */
    private String sessEdttm;

    /** 등록자ID */
    private String rgtrId;

    /** 등록일시 (YYYYMMDDHH24MISS) */
    private String regDttm;

    /** 수정자ID */
    private String mdfrId;

    /** 수정일시 (YYYYMMDDHH24MISS) */
    private String modDttm;

	public String getUserActvId() {
		return userActvId;
	}

	public void setUserActvId(String userActvId) {
		this.userActvId = userActvId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getSbjctId() {
		return subjectId;
	}

	public void setSbjctId(String subjectId) {
		this.subjectId = subjectId;
	}

	public String getReqTycd() {
		return reqTycd;
	}

	public void setReqTycd(String reqTycd) {
		this.reqTycd = reqTycd;
	}

	public String getUserReqUrl() {
		return userReqUrl;
	}

	public void setUserReqUrl(String userReqUrl) {
		this.userReqUrl = userReqUrl;
	}

	public String getUserReqMenu() {
		return userReqMenu;
	}

	public void setUserReqMenu(String userReqMenu) {
		this.userReqMenu = userReqMenu;
	}

	public String getUserReqCts() {
		return userReqCts;
	}

	public void setUserReqCts(String userReqCts) {
		this.userReqCts = userReqCts;
	}

	public String getUserTycd() {
		return userTycd;
	}

	public void setUserTycd(String userTycd) {
		this.userTycd = userTycd;
	}

	public String getCntnIp() {
		return cntnIp;
	}

	public void setCntnIp(String cntnIp) {
		this.cntnIp = cntnIp;
	}

	public String getCntnDvcTycd() {
		return cntnDvcTycd;
	}

	public void setCntnDvcTycd(String cntnDvcTycd) {
		this.cntnDvcTycd = cntnDvcTycd;
	}

	public String getCntnBrwsr() {
		return cntnBrwsr;
	}

	public void setCntnBrwsr(String cntnBrwsr) {
		this.cntnBrwsr = cntnBrwsr;
	}

	public String getActvDttm() {
		return actvDttm;
	}

	public void setActvDttm(String actvDttm) {
		this.actvDttm = actvDttm;
	}

	public String getSessId() {
		return sessId;
	}

	public void setSessId(String sessId) {
		this.sessId = sessId;
	}

	public String getSessSdttm() {
		return sessSdttm;
	}

	public void setSessSdttm(String sessSdttm) {
		this.sessSdttm = sessSdttm;
	}

	public String getSessEdttm() {
		return sessEdttm;
	}

	public void setSessEdttm(String sessEdttm) {
		this.sessEdttm = sessEdttm;
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
}