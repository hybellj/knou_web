package knou.lms.sys.vo;

import knou.lms.common.vo.DefaultVO;

public class SysJobSchVO extends DefaultVO {

	private static final long serialVersionUID = -3753493919199508963L;

	private String sysjobSchdlId; // 시스템작업 일정 아이디
	private String sysjobSchdlnm; // 시스템작업 일정명
	private String sysjobSchdlTycd; // 시스템작업 유형코드(공통코드밸류값)
	private String sysjobSchdlSymd; // 시스템작업 일정 시작일자
	private String sysjobSchdlEymd; // 시스템작업 일정 종료일자
	private String sysjobSchdlCmnt; // 시스템작업 일정 댓글(내용)

	private String useYn; // 사용 여부

//	  private String  codeOptn;           // 코드 옵션(대학구분)
	private String calendarCtgr; // 일정 분류
	private String calendarCtgrNm;

	private String excSchStartDttm;
	private String excSchEndDttm;

	private String sysjobSchdlPeriodYn; // 업무일정 기간 여부
	private String sysjobSchdlExcPeriodYn; // 예외처리 기간 여부
	private String sysjobSchdlStartYn; // 업무일정 기간 시작여부
	private String sysjobSchdlEndYn; // 업무일정 기간 종료여부
	public String getSysjobSchdlId() {
		return sysjobSchdlId;
	}
	public void setSysjobSchdlId(String sysjobSchdlId) {
		this.sysjobSchdlId = sysjobSchdlId;
	}
	public String getSysjobSchdlnm() {
		return sysjobSchdlnm;
	}
	public void setSysjobSchdlnm(String sysjobSchdlnm) {
		this.sysjobSchdlnm = sysjobSchdlnm;
	}
	public String getSysjobSchdlTycd() {
		return sysjobSchdlTycd;
	}
	public void setSysjobSchdlTycd(String sysjobSchdlTycd) {
		this.sysjobSchdlTycd = sysjobSchdlTycd;
	}
	public String getSysjobSchdlSymd() {
		return sysjobSchdlSymd;
	}
	public void setSysjobSchdlSymd(String sysjobSchdlSymd) {
		this.sysjobSchdlSymd = sysjobSchdlSymd;
	}
	public String getSysjobSchdlEymd() {
		return sysjobSchdlEymd;
	}
	public void setSysjobSchdlEymd(String sysjobSchdlEymd) {
		this.sysjobSchdlEymd = sysjobSchdlEymd;
	}
	public String getSysjobSchdlCmnt() {
		return sysjobSchdlCmnt;
	}
	public void setSysjobSchdlCmnt(String sysjobSchdlCmnt) {
		this.sysjobSchdlCmnt = sysjobSchdlCmnt;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getCalendarCtgr() {
		return calendarCtgr;
	}
	public void setCalendarCtgr(String calendarCtgr) {
		this.calendarCtgr = calendarCtgr;
	}
	public String getCalendarCtgrNm() {
		return calendarCtgrNm;
	}
	public void setCalendarCtgrNm(String calendarCtgrNm) {
		this.calendarCtgrNm = calendarCtgrNm;
	}
	public String getExcSchStartDttm() {
		return excSchStartDttm;
	}
	public void setExcSchStartDttm(String excSchStartDttm) {
		this.excSchStartDttm = excSchStartDttm;
	}
	public String getExcSchEndDttm() {
		return excSchEndDttm;
	}
	public void setExcSchEndDttm(String excSchEndDttm) {
		this.excSchEndDttm = excSchEndDttm;
	}
	public String getSysjobSchdlPeriodYn() {
		return sysjobSchdlPeriodYn;
	}
	public void setSysjobSchdlPeriodYn(String sysjobSchdlPeriodYn) {
		this.sysjobSchdlPeriodYn = sysjobSchdlPeriodYn;
	}
	public String getSysjobSchdlExcPeriodYn() {
		return sysjobSchdlExcPeriodYn;
	}
	public void setSysjobSchdlExcPeriodYn(String sysjobSchdlExcPeriodYn) {
		this.sysjobSchdlExcPeriodYn = sysjobSchdlExcPeriodYn;
	}
	public String getSysjobSchdlStartYn() {
		return sysjobSchdlStartYn;
	}
	public void setSysjobSchdlStartYn(String sysjobSchdlStartYn) {
		this.sysjobSchdlStartYn = sysjobSchdlStartYn;
	}
	public String getSysjobSchdlEndYn() {
		return sysjobSchdlEndYn;
	}
	public void setSysjobSchdlEndYn(String sysjobSchdlEndYn) {
		this.sysjobSchdlEndYn = sysjobSchdlEndYn;
	}

	
}
