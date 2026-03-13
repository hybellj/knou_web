package knou.lms.srvy.vo;

import knou.lms.common.vo.DefaultVO;

public class SrvyRspnsVO extends DefaultVO {

	private static final long serialVersionUID = 6156219424700086561L;

	// TB_LMS_SRVY_RSPNS ( 설문답변 )
	private String srvyRspnsId;				// 설문답변아이디
	private String srvyPtcpId;				// 설문참여아이디
	private String srvyQstnId;				// 설문문항아이디
	private String srvyVwitmId;				// 설문보기항목아이디
	private String srvyQstnVwitmLvlId;		// 설문문항보기항목레벨아이디
	private String rspns;					// 답변

	public String getSrvyRspnsId() {
		return srvyRspnsId;
	}
	public String getSrvyPtcpId() {
		return srvyPtcpId;
	}
	public String getSrvyQstnId() {
		return srvyQstnId;
	}
	public String getSrvyVwitmId() {
		return srvyVwitmId;
	}
	public String getSrvyQstnVwitmLvlId() {
		return srvyQstnVwitmLvlId;
	}
	public String getRspns() {
		return rspns;
	}
	public void setSrvyRspnsId(String srvyRspnsId) {
		this.srvyRspnsId = srvyRspnsId;
	}
	public void setSrvyPtcpId(String srvyPtcpId) {
		this.srvyPtcpId = srvyPtcpId;
	}
	public void setSrvyQstnId(String srvyQstnId) {
		this.srvyQstnId = srvyQstnId;
	}
	public void setSrvyVwitmId(String srvyVwitmId) {
		this.srvyVwitmId = srvyVwitmId;
	}
	public void setSrvyQstnVwitmLvlId(String srvyQstnVwitmLvlId) {
		this.srvyQstnVwitmLvlId = srvyQstnVwitmLvlId;
	}
	public void setRspns(String rspns) {
		this.rspns = rspns;
	}

}
