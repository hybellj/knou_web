package knou.lms.system.manager.vo;

import knou.lms.common.vo.DefaultVO;

public class SysMgrErrVO extends DefaultVO {
    private static final long serialVersionUID = 180723044442176021L;

	private String		orgnm;			// 기관명
	private String		orgId;			// 기관 I ID
	private String		deptnm;			// 학과명
	private String		deptId;			// 학과 ID
	private String		regDttm;		// 등록일시
	private String		stdntNo;		// 학번/사번
	private String		usernm;			// 등록자 명
	private String		rgtrId;			// 등록자 ID
	private String		sysErrPageNm;	// 오류페이지
	private String		sysErrMsgId;	// 에러메시지 ID

	private String		errLocation;	// 에러 경로
	private String		errType;		// 에러 타입
	private String		sysErrMsgCts;	// 에러 메시지
	private String		excelGrid;		// 엑셀 그리드 정의

	// Getter
 	public String getOrgnm() {
		return orgnm;
	}
	
	public String getOrgId() {
		return orgId;
	}

 	public String getDeptnm() {
		return deptnm;
	}

 	public String getDeptId() {
		return deptId;
	}

 	public String getRegDttm() {
		return regDttm;
	}

 	public String getStdntNo() {
		return stdntNo;
	}

 	public String getUsernm() {
		return usernm;
	}

 	public String getRgtrId() {
		return rgtrId;
	}

	public String getSysErrPageNm() {
		return sysErrPageNm;
	}
	
	public String getSysErrMsgId() {
		return sysErrMsgId;
	}

	public String getErrLocation() {
		return errLocation;
	}

	public String getErrType() {
		return errType;
	}

	public String getSysErrMsgCts() {
		return sysErrMsgCts;
	}

	public String getExcelGrid() {
		return excelGrid;
	}

	// Setter
	public void setOrgnm(String orgnm) {
		this.orgnm = orgnm;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public void setDeptnm(String deptnm) {
		this.deptnm = deptnm;
	}

	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}

	public void setRegDttm(String regDttm) {
		this.regDttm = regDttm;
	}

	public void setStdntNo(String stdntNo) {
		this.stdntNo = stdntNo;
	}

	public void setUsernm(String usernm) {
		this.usernm = usernm;
	}

	public void setRgtrId(String rgtrId) {
		this.rgtrId = rgtrId;
	}

	public void setSysErrPageNm(String sysErrPageNm) {
		this.sysErrPageNm = sysErrPageNm;
	}

	public void setSysErrMsgId(String sysErrMsgId) {
		this.sysErrMsgId = sysErrMsgId;
	}

	public void setErrLocation(String errLocation) {
		this.errLocation = errLocation;
	}

	public void setErrType(String errType) {
		this.errType = errType;
	}

	public void setSysErrMsgCts(String sysErrMsgCts) {
		this.sysErrMsgCts = sysErrMsgCts;
	}

	public void setExcelGrid(String excelGrid) {
		this.excelGrid = excelGrid;
	}
}