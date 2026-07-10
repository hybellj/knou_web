package knou.lms.smnr.vo;

import knou.lms.common.vo.DefaultVO;

public class SmnrAtndHstryVO extends DefaultVO {

	private static final long serialVersionUID = 1702553905270395952L;

	// TB_LMS_SMNR_ATND_HSTRY ( 세미나참석이력 )
	private String  smnrAtndHstryId;	// 세미나참석이력아이디
	private String  smnrId;             // 세미나아이디
	private String  atndeId;			// 참석자아이디
	private String  atndSdttm;          // 참석시작일시
	private String  atndEdttm;          // 참석종료일시
	private Integer atndScnds;          // 참석시간
	private String  atndStscd;          // 참석상태코드
	private String  cntnDvcTycd;        // 접속기기유형코드
	private String  atndeIp;            // 참석자아이피

	public String getSmnrAtndHstryId() {
		return smnrAtndHstryId;
	}
	public String getSmnrId() {
		return smnrId;
	}
	public String getAtndeId() {
		return atndeId;
	}
	public String getAtndSdttm() {
		return atndSdttm;
	}
	public String getAtndEdttm() {
		return atndEdttm;
	}
	public Integer getAtndScnds() {
		return atndScnds;
	}
	public String getAtndStscd() {
		return atndStscd;
	}
	public String getCntnDvcTycd() {
		return cntnDvcTycd;
	}
	public String getAtndeIp() {
		return atndeIp;
	}
	public void setSmnrAtndHstryId(String smnrAtndHstryId) {
		this.smnrAtndHstryId = smnrAtndHstryId;
	}
	public void setSmnrId(String smnrId) {
		this.smnrId = smnrId;
	}
	public void setAtndeId(String atndeId) {
		this.atndeId = atndeId;
	}
	public void setAtndSdttm(String atndSdttm) {
		this.atndSdttm = atndSdttm;
	}
	public void setAtndEdttm(String atndEdttm) {
		this.atndEdttm = atndEdttm;
	}
	public void setAtndScnds(Integer atndScnds) {
		this.atndScnds = atndScnds;
	}
	public void setAtndStscd(String atndStscd) {
		this.atndStscd = atndStscd;
	}
	public void setCntnDvcTycd(String cntnDvcTycd) {
		this.cntnDvcTycd = cntnDvcTycd;
	}
	public void setAtndeIp(String atndeIp) {
		this.atndeIp = atndeIp;
	}
}
