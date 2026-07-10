package knou.lms.srvy.vo;

import java.math.BigDecimal;

import knou.lms.common.vo.DefaultVO;

public class SrvyPtcpVO extends DefaultVO {

	private static final long serialVersionUID = 2656613132560194056L;

	// TB_LMS_SRVY_PTCP ( 설문참여 )
	private String  	srvyPtcpId;		// 설문참여아이디
	private String  	srvyId;			// 설문아이디
	private String  	ptcpSdttm;		// 참여시작일시
	private String  	ptcpEdttm;		// 참여종료일시
	private String  	cntnDvcTycd;	// 접속기기유형코드
	private String  	cntnIp;			// 접속아이피
	private BigDecimal 	ptcpEvlScr;		// 참여평가점수
	private String  	profMemo;		// 교수메모
	private String  	srvyPtcpEvlyn;	// 설문참여평가여부

	public String getSrvyPtcpId() {
		return srvyPtcpId;
	}
	public String getSrvyId() {
		return srvyId;
	}
	public String getPtcpSdttm() {
		return ptcpSdttm;
	}
	public String getPtcpEdttm() {
		return ptcpEdttm;
	}
	public String getCntnDvcTycd() {
		return cntnDvcTycd;
	}
	public String getCntnIp() {
		return cntnIp;
	}
	public BigDecimal getPtcpEvlScr() {
		return ptcpEvlScr;
	}
	public String getProfMemo() {
		return profMemo;
	}
	public String getSrvyPtcpEvlyn() {
		return srvyPtcpEvlyn;
	}
	public void setSrvyPtcpId(String srvyPtcpId) {
		this.srvyPtcpId = srvyPtcpId;
	}
	public void setSrvyId(String srvyId) {
		this.srvyId = srvyId;
	}
	public void setPtcpSdttm(String ptcpSdttm) {
		this.ptcpSdttm = ptcpSdttm;
	}
	public void setPtcpEdttm(String ptcpEdttm) {
		this.ptcpEdttm = ptcpEdttm;
	}
	public void setCntnDvcTycd(String cntnDvcTycd) {
		this.cntnDvcTycd = cntnDvcTycd;
	}
	public void setCntnIp(String cntnIp) {
		this.cntnIp = cntnIp;
	}
	public void setPtcpEvlScr(BigDecimal ptcpEvlScr) {
		this.ptcpEvlScr = ptcpEvlScr;
	}
	public void setProfMemo(String profMemo) {
		this.profMemo = profMemo;
	}
	public void setSrvyPtcpEvlyn(String srvyPtcpEvlyn) {
		this.srvyPtcpEvlyn = srvyPtcpEvlyn;
	}

}
