package knou.lms.srvy.vo;

import knou.lms.common.vo.DefaultVO;

public class SrvyTrgtVO extends DefaultVO {

	private static final long serialVersionUID = -2225394765050657414L;

	// TB_LMS_SRVY_TRGT ( 설문대상 )
	private String srvyTrgtrId;		// 설문대상아이디
	private String srvyId;			// 설문아이디
	private String teamId;			// 팀아이디

	public String getSrvyTrgtrId() {
		return srvyTrgtrId;
	}
	public String getSrvyId() {
		return srvyId;
	}
	public String getTeamId() {
		return teamId;
	}
	public void setSrvyTrgtrId(String srvyTrgtrId) {
		this.srvyTrgtrId = srvyTrgtrId;
	}
	public void setSrvyId(String srvyId) {
		this.srvyId = srvyId;
	}
	public void setTeamId(String teamId) {
		this.teamId = teamId;
	}

}
