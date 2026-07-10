package knou.lms.srvy.vo;

import knou.lms.common.vo.DefaultVO;

public class SrvyPtcpHstryVO extends DefaultVO {

	private static final long serialVersionUID = 7857984847573686953L;

	// TB_LMS_SRVY_PTCP_HSTRY ( 설문참여이력 )
	private String srvyPtcpHstryId;		// 설문참여이력아이디
	private String srvyId;              // 설문아이디
	private String srvyHstryGbncd;      // 설문이력구분코드
	private String ptcpSdttm;           // 참여시작일시
	private String ptcpEdttm;           // 참여종료일시
	private String cntnIp;              // 접속아이피

	public String getSrvyPtcpHstryId() {
		return srvyPtcpHstryId;
	}
	public String getSrvyId() {
		return srvyId;
	}
	public String getSrvyHstryGbncd() {
		return srvyHstryGbncd;
	}
	public String getPtcpSdttm() {
		return ptcpSdttm;
	}
	public String getPtcpEdttm() {
		return ptcpEdttm;
	}
	public String getCntnIp() {
		return cntnIp;
	}
	public void setSrvyPtcpHstryId(String srvyPtcpHstryId) {
		this.srvyPtcpHstryId = srvyPtcpHstryId;
	}
	public void setSrvyId(String srvyId) {
		this.srvyId = srvyId;
	}
	public void setSrvyHstryGbncd(String srvyHstryGbncd) {
		this.srvyHstryGbncd = srvyHstryGbncd;
	}
	public void setPtcpSdttm(String ptcpSdttm) {
		this.ptcpSdttm = ptcpSdttm;
	}
	public void setPtcpEdttm(String ptcpEdttm) {
		this.ptcpEdttm = ptcpEdttm;
	}
	public void setCntnIp(String cntnIp) {
		this.cntnIp = cntnIp;
	}
}
