package knou.lms.smnr.vo;

import java.math.BigDecimal;

import knou.lms.common.vo.DefaultVO;

public class SmnrAtndVO extends DefaultVO {

	private static final long serialVersionUID = -1539193020494243255L;

	// TB_LMS_SMNR_ATND ( 세미나참석 )
	private String  	smnrAtndId;			// 세미나참석아이디
	private String  	smnrId;             // 세미나아이디
	private String  	atndSdttm;          // 참석시작일시
	private String  	atndEdttm;          // 참석종료일시
	private Integer 	atndScnds;          // 참석시간
	private String  	atndStscd;          // 참석상태코드
	private String  	cntnDvcTycd;        // 접속기기유형코드
	private String  	smnrCntnGbncd;      // 세미나접속구분코드
	private String  	atndMemo;           // 참석메모
	private String  	rgtrIp;             // 등록자아이피
	private BigDecimal 	atndEvlScr;			// 참석평가점수
	private String  	atndEvlyn;          // 참석평가여부
	private String  	atndEvlDttm;        // 참석평가일시

	public String getSmnrAtndId() {
		return smnrAtndId;
	}
	public String getSmnrId() {
		return smnrId;
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
	public String getSmnrCntnGbncd() {
		return smnrCntnGbncd;
	}
	public String getAtndMemo() {
		return atndMemo;
	}
	public String getRgtrIp() {
		return rgtrIp;
	}
	public BigDecimal getAtndEvlScr() {
		return atndEvlScr;
	}
	public String getAtndEvlyn() {
		return atndEvlyn;
	}
	public String getAtndEvlDttm() {
		return atndEvlDttm;
	}
	public void setSmnrAtndId(String smnrAtndId) {
		this.smnrAtndId = smnrAtndId;
	}
	public void setSmnrId(String smnrId) {
		this.smnrId = smnrId;
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
	public void setSmnrCntnGbncd(String smnrCntnGbncd) {
		this.smnrCntnGbncd = smnrCntnGbncd;
	}
	public void setAtndMemo(String atndMemo) {
		this.atndMemo = atndMemo;
	}
	public void setRgtrIp(String rgtrIp) {
		this.rgtrIp = rgtrIp;
	}
	public void setAtndEvlScr(BigDecimal atndEvlScr) {
		this.atndEvlScr = atndEvlScr;
	}
	public void setAtndEvlyn(String atndEvlyn) {
		this.atndEvlyn = atndEvlyn;
	}
	public void setAtndEvlDttm(String atndEvlDttm) {
		this.atndEvlDttm = atndEvlDttm;
	}
}
