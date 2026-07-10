package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

import java.util.List;

public class DscsEzGraderTeamVO extends DefaultVO {

    private String dscsId;          // 토론아이디
    private String sbjctId;         // 과목아이디
    private String teamTycd;        // 팀유형코드
    private String teamId;          // 팀아이디
    private String teamnm;          // 팀명
    private String teamStdIds;      // 팀원 사용자아이디 목록

    private List<DscsJoinUserVO> teamMembers; // 팀원 목록

    public String getDscsId() {
        return dscsId;
    }

    public void setDscsId(String dscsId) {
        this.dscsId = dscsId;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getTeamTycd() {
        return teamTycd;
    }

    public void setTeamTycd(String teamTycd) {
        this.teamTycd = teamTycd;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }

    public String getTeamnm() {
        return teamnm;
    }

    public void setTeamnm(String teamnm) {
        this.teamnm = teamnm;
    }

    public String getTeamStdIds() {
        return teamStdIds;
    }

    public void setTeamStdIds(String teamStdIds) {
        this.teamStdIds = teamStdIds;
    }

    public List<DscsJoinUserVO> getTeamMembers() {
        return teamMembers;
    }

    public void setTeamMembers(List<DscsJoinUserVO> teamMembers) {
        this.teamMembers = teamMembers;
    }

}
