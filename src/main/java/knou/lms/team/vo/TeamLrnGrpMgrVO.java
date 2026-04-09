package knou.lms.team.vo;

import knou.lms.common.vo.DefaultVO;

import java.util.List;

public class TeamLrnGrpMgrVO extends DefaultVO {

    private String  lrnGrpId;       // 학습그룹 ID
    private String  lrnGrpnm;       // 학습그룹명
    private int     teamTot;        // 팀 전체 수
    private String  userId;         // 사용자 ID
    private String  usernm;         // 사용자 이름
    private String  lrnGrpCmptnyn;  // 학습그룹 구성완료여부

    public String getLrnGrpId() {
        return lrnGrpId;
    }
    public void setLrnGrpId(String lrnGrpId) {
        this.lrnGrpId = lrnGrpId;
    }
    public String getLrnGrpnm() {
        return lrnGrpnm;
    }
    public void setLrnGrpnm(String lrnGrpnm) {
        this.lrnGrpnm = lrnGrpnm;
    }
    public int getTeamTot() {
        return teamTot;
    }
    public void setTeamTot(int teamTot) {
        this.teamTot = teamTot;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getUsernm() {
        return usernm;
    }
    public void setUsernm(String usernm) {
        this.usernm = usernm;
    }
    public String getLrnGrpCmptnyn() {
        return lrnGrpCmptnyn;
    }
    public void setLrnGrpCmptnyn(String lrnGrpCmptnyn) {
        this.lrnGrpCmptnyn = lrnGrpCmptnyn;
    }
}