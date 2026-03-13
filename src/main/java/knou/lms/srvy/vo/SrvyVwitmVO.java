package knou.lms.srvy.vo;

import knou.lms.common.vo.DefaultVO;

public class SrvyVwitmVO extends DefaultVO {

	private static final long serialVersionUID = -1251487255569238387L;

	// TB_LMS_SRVY_VWITM ( 설문보기항목 )
	private String  srvyVwitmId;		// 설문보기항목아이디
	private String  srvyQstnId;			// 설문문항아이디
	private String  vwitmGbncd;			// 보기항목구분코드
	private String  vwitmCts;			// 보기항목내용
	private Integer vwitmSeqno;			// 보기항목순번
	private String  mvmnSrvyQstnId;		// 다음설문지아이디
	private String  etcInptyn;			// 기타입력여부
	private String  edtrUseyn;			// 편집기사용여부

	public String getSrvyVwitmId() {
		return srvyVwitmId;
	}
	public String getSrvyQstnId() {
		return srvyQstnId;
	}
	public String getVwitmGbncd() {
		return vwitmGbncd;
	}
	public String getVwitmCts() {
		return vwitmCts;
	}
	public Integer getVwitmSeqno() {
		return vwitmSeqno;
	}
	public String getMvmnSrvyQstnId() {
		return mvmnSrvyQstnId;
	}
	public String getEtcInptyn() {
		return etcInptyn;
	}
	public String getEdtrUseyn() {
		return edtrUseyn;
	}
	public void setSrvyVwitmId(String srvyVwitmId) {
		this.srvyVwitmId = srvyVwitmId;
	}
	public void setSrvyQstnId(String srvyQstnId) {
		this.srvyQstnId = srvyQstnId;
	}
	public void setVwitmGbncd(String vwitmGbncd) {
		this.vwitmGbncd = vwitmGbncd;
	}
	public void setVwitmCts(String vwitmCts) {
		this.vwitmCts = vwitmCts;
	}
	public void setVwitmSeqno(Integer vwitmSeqno) {
		this.vwitmSeqno = vwitmSeqno;
	}
	public void setMvmnSrvyQstnId(String mvmnSrvyQstnId) {
		this.mvmnSrvyQstnId = mvmnSrvyQstnId;
	}
	public void setEtcInptyn(String etcInptyn) {
		this.etcInptyn = etcInptyn;
	}
	public void setEdtrUseyn(String edtrUseyn) {
		this.edtrUseyn = edtrUseyn;
	}

}
