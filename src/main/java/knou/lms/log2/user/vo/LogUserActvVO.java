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
    private String sbjctId;

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

    /** 활동일시 (DATE) */
    private String actvDatetime;

    /* ======================================================
     * JOIN 결과 필드 (TB_LMS_USER / TB_LMS_SBJCT / TB_LMS_ORG)
     * ====================================================== */
    /** 사용자명 */
    private String usernm;

    /** 학번/교번 */
    private String stdntNo;

    /** 대표아이디 */
    private String userRprsId;

    /** 기관명 */
    private String orgnm;

    /** 과목명 */
    private String sbjctnm;

    /** 과목연도 */
    private String sbjctYr;

    /** 과목학기 */
    private String sbjctSmstr;

    /** 학과명 (DEPT_ID 기준) */
    private String deptNm;

    /** 분반번호 */
    private String dvclasNo;

    /* ======================================================
     * 검색 파라미터
     * ====================================================== */
    /** 검색시작일시 (YYYYMMDDHH24MISS) */
    private String searchSdttm;

    /** 검색종료일시 (YYYYMMDDHH24MISS) */
    private String searchEdttm;

    /** 교수아이디 */
    private String profId;

    /** 검색어 (대표아이디/학번/이름) */
    private String searchValue;

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
		return sbjctId;
	}

	public void setSbjctId(String sbjctId) {
		this.sbjctId = sbjctId;
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

	public String getActvDatetime() { return actvDatetime; }
	public void setActvDatetime(String actvDatetime) { this.actvDatetime = actvDatetime; }

	public String getUsernm() { return usernm; }
	public void setUsernm(String usernm) { this.usernm = usernm; }

	public String getStdntNo() { return stdntNo; }
	public void setStdntNo(String stdntNo) { this.stdntNo = stdntNo; }

	public String getUserRprsId() { return userRprsId; }
	public void setUserRprsId(String userRprsId) { this.userRprsId = userRprsId; }

	public String getOrgnm() { return orgnm; }
	public void setOrgnm(String orgnm) { this.orgnm = orgnm; }

	public String getSbjctnm() { return sbjctnm; }
	public void setSbjctnm(String sbjctnm) { this.sbjctnm = sbjctnm; }

	public String getSbjctYr() { return sbjctYr; }
	public void setSbjctYr(String sbjctYr) { this.sbjctYr = sbjctYr; }

	public String getSbjctSmstr() { return sbjctSmstr; }
	public void setSbjctSmstr(String sbjctSmstr) { this.sbjctSmstr = sbjctSmstr; }

	public String getDeptNm() { return deptNm; }
	public void setDeptNm(String deptNm) { this.deptNm = deptNm; }

	public String getDvclasNo() { return dvclasNo; }
	public void setDvclasNo(String dvclasNo) { this.dvclasNo = dvclasNo; }

	public String getSearchSdttm() { return searchSdttm; }
	public void setSearchSdttm(String searchSdttm) { this.searchSdttm = searchSdttm; }

	public String getSearchEdttm() { return searchEdttm; }
	public void setSearchEdttm(String searchEdttm) { this.searchEdttm = searchEdttm; }

	public String getProfId() { return profId; }
	public void setProfId(String profId) { this.profId = profId; }

	public String getSearchValue() { return searchValue; }
	public void setSearchValue(String searchValue) { this.searchValue = searchValue; }
}