package knou.lms.srvy.vo;

import knou.lms.common.vo.DefaultVO;

public class SrvyGrpVO extends DefaultVO {

	private static final long serialVersionUID = -4864773915477204527L;

	// TB_LMS_SRVY_GRP ( 설문그룹 )
	private String srvyGrpId;		// 설문그룹아이디
	private String srvyGrpnm;		// 설문그룹명

	public String getSrvyGrpId() {
		return srvyGrpId;
	}
	public String getSrvyGrpnm() {
		return srvyGrpnm;
	}
	public void setSrvyGrpId(String srvyGrpId) {
		this.srvyGrpId = srvyGrpId;
	}
	public void setSrvyGrpnm(String srvyGrpnm) {
		this.srvyGrpnm = srvyGrpnm;
	}

}
