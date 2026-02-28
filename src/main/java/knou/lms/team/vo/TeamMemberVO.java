package knou.lms.team.vo;

import knou.lms.common.vo.DefaultVO;

public class TeamMemberVO extends DefaultVO {
    
    private static final long serialVersionUID = -4001758793879634685L;
    
    // TB_LMS_TEAM_MEMBER
    private String teamCd;
    private String stdId;
    private String userId;
    private String memberRole;
    private String leaderYn;

    private String teamCtgrCd;
    private String userNm;
    private String deptNm;
    private String teamNm;

    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;

    private String avgMrks;
    private String riskGrade;
    private String grscDegrCorsGbn;
    private String grscDegrCorsGbnNm;

    public String getTeamCd() {
        return teamCd;
    }

    public void setTeamCd(String teamCd) {
        this.teamCd = teamCd;
    }

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getMemberRole() {
        return memberRole;
    }

    public void setMemberRole(String memberRole) {
        this.memberRole = memberRole;
    }

    public String getLeaderYn() {
        return leaderYn;
    }

    public void setLeaderYn(String leaderYn) {
        this.leaderYn = leaderYn;
    }

    public String getTeamCtgrCd() {
        return teamCtgrCd;
    }

    public void setTeamCtgrCd(String teamCtgrCd) {
        this.teamCtgrCd = teamCtgrCd;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public String getDeptNm() {
        return deptNm;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public String getTeamNm() {
        return teamNm;
    }

    public void setTeamNm(String teamNm) {
        this.teamNm = teamNm;
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

    public String getAvgMrks() {
        return avgMrks;
    }

    public void setAvgMrks(String avgMrks) {
        this.avgMrks = avgMrks;
    }

    public String getRiskGrade() {
        return riskGrade;
    }

    public void setRiskGrade(String riskGrade) {
        this.riskGrade = riskGrade;
    }

    public String getGrscDegrCorsGbn() {
        return grscDegrCorsGbn;
    }

    public void setGrscDegrCorsGbn(String grscDegrCorsGbn) {
        this.grscDegrCorsGbn = grscDegrCorsGbn;
    }

    public String getGrscDegrCorsGbnNm() {
        return grscDegrCorsGbnNm;
    }

    public void setGrscDegrCorsGbnNm(String grscDegrCorsGbnNm) {
        this.grscDegrCorsGbnNm = grscDegrCorsGbnNm;
    }
    
}