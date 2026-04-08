package knou.lms.smnr.vo;

import knou.lms.common.vo.DefaultVO;

public class SmnrTeamVO extends DefaultVO {

	private static final long serialVersionUID = -996149104472674881L;

	// TB_LMS_SMNR_TEAM ( 세미나팀 )
	private String smnrTeamId;		// 세미나팀아이디
	private String smnrId;          // 세미나아이디
	private String teamId;          // 팀아이디

	public String getSmnrTeamId() {
		return smnrTeamId;
	}
	public String getSmnrId() {
		return smnrId;
	}
	public String getTeamId() {
		return teamId;
	}
	public void setSmnrTeamId(String smnrTeamId) {
		this.smnrTeamId = smnrTeamId;
	}
	public void setSmnrId(String smnrId) {
		this.smnrId = smnrId;
	}
	public void setTeamId(String teamId) {
		this.teamId = teamId;
	}
}
