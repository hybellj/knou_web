package knou.lms.team.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class TeamVO extends DefaultVO {
    private String teamCd;
    private String teamCtgrCd;
    private String teamNm;
    private String leaderNm;
    private String teamMbrCnt;

    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;

    private String stdNo;
    private String stdRole;
    private String leaderYn;
    private String userNm;
    private String userId;
    private String deptNm;

    private String memberRole;

    private List<TeamMemberVO> teamMemberList;

    private String teamId;
    private String teamTycd;

    public String getTeamCd() {
        return teamCd;
    }

    public void setTeamCd(String teamCd) {
        this.teamCd = teamCd;
    }

    public String getTeamCtgrCd() {
        return teamCtgrCd;
    }

    public void setTeamCtgrCd(String teamCtgrCd) {
        this.teamCtgrCd = teamCtgrCd;
    }

    public String getTeamNm() {
        return teamNm;
    }

    public void setTeamNm(String teamNm) {
        this.teamNm = teamNm;
    }

    public String getLeaderNm() {
        return leaderNm;
    }

    public void setLeaderNm(String leaderNm) {
        this.leaderNm = leaderNm;
    }

    public String getTeamMbrCnt() {
        return teamMbrCnt;
    }

    public void setTeamMbrCnt(String teamMbrCnt) {
        this.teamMbrCnt = teamMbrCnt;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getRegDttm() {
        return regDttm;
    }

    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getModDttm() {
        return modDttm;
    }

    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

    public String getStdRole() {
        return stdRole;
    }

    public void setStdRole(String stdRole) {
        this.stdRole = stdRole;
    }

    public String getStdNo() {
        return stdNo;
    }

    public void setStdNo(String stdNo) {
        this.stdNo = stdNo;
    }

    public String getMemberRole() {
        return memberRole;
    }

    public void setMemberRole(String memberRole) {
        this.memberRole = memberRole;
    }

    public List<TeamMemberVO> getTeamMemberList() {
        return teamMemberList;
    }

    public void setTeamMemberList(List<TeamMemberVO> teamMemberList) {
        this.teamMemberList = teamMemberList;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getDeptNm() {
        return deptNm;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public String getLeaderYn() {
        return leaderYn;
    }

    public void setLeaderYn(String leaderYn) {
        this.leaderYn = leaderYn;
    }

	public String getTeamId() {
		return teamId;
	}

	public String getTeamTycd() {
		return teamTycd;
	}

	public void setTeamId(String teamId) {
		this.teamId = teamId;
	}

	public void setTeamTycd(String teamTycd) {
		this.teamTycd = teamTycd;
	}
}