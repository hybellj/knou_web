package knou.lms.team.vo;

import knou.lms.common.vo.DefaultVO;

import java.util.List;

public class TeamGrpMgrVO extends DefaultVO {

    private String  teamGrpId;          // 팀 그룹 ID
    private String  teamGrpnm;           // 팀 그룹명
    private int     teamTot;            // 팀 전체 수
    private String  userId;             // 사용자 ID
    private String  usernm;             // 사용자 이름
    private String  teamGrpCmptnyn;      // 팀 그룹 구성완료여부
    private String  deptnm;             // 부서명
    private String  userRprsId;         // 사용자 대표 ID
    private String  stdntNo;            // 학번
    private String  mobileNo;           // 휴대폰 번호
    private String  usingyn;            // 현재 그룹 사용여부

    // teamRegist
    private String  teamId;             // 팀 ID
    private String  teamnm;             // 팀명
    private int     teamQuota;          // 팀 정원
    private String  autoAllocyn;        // 자동배정여부
    private String  mrkActvTycd;        // 점수활동유형코드
    private String  teamBbsId;          // 팀 게시판 ID
    private String  teamBbsUseyn;       // 팀 게시판 사용여부
    private String  teamMbrId;          // 팀 멤버 ID
    private String  role;               // 역할
    private String  ldryn;              // 리더여부
    private String  actvGbncd;          // 활동구분코드
    private String  teamCpstCmptnyn;    // 팀구성완료여부

    // 등록 시 콤마 구분 문자열 (서비스에서 split 처리)
    private String  teamList;           // 팀 멤버 userId List (콤마로 구분)
    private String  ldrynList;          // 팀 멤버 리더여부 List (콤마로 구분)
    // 팀 목록 (Spring MVC 리스트 바인딩용)
    private List<TeamGrpMgrVO> teamDataList;

    public String getTeamGrpId() {
        return teamGrpId;
    }
    public void setTeamGrpId(String teamGrpId) {
        this.teamGrpId = teamGrpId;
    }
    public String getTeamGrpnm() {
        return teamGrpnm;
    }
    public void setTeamGrpnm(String teamGrpnm) {
        this.teamGrpnm = teamGrpnm;
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
    public String getTeamGrpCmptnyn() {
        return teamGrpCmptnyn;
    }
    public void setTeamGrpCmptnyn(String teamGrpCmptnyn) {
        this.teamGrpCmptnyn = teamGrpCmptnyn;
    }
    public String getDeptnm() {
        return deptnm;
    }
    public void setDeptnm(String deptnm) {
        this.deptnm = deptnm;
    }
    public String getUserRprsId() {
        return userRprsId;
    }
    public void setUserRprsId(String userRprsId) {
        this.userRprsId = userRprsId;
    }
    public String getStdntNo() {
        return stdntNo;
    }
    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }
    public String getMobileNo() {
        return mobileNo;
    }
    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }
    public String getUsingyn() {
        return usingyn;
    }
    public void setUsingyn(String usingyn) {
        this.usingyn = usingyn;
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
    public int getTeamQuota() {
        return teamQuota;
    }
    public void setTeamQuota(int teamQuota) {
        this.teamQuota = teamQuota;
    }
    public String getAutoAllocyn() {
        return autoAllocyn;
    }
    public void setAutoAllocyn(String autoAllocyn) {
        this.autoAllocyn = autoAllocyn;
    }
    public String getMrkActvTycd() {
        return mrkActvTycd;
    }
    public void setMrkActvTycd(String mrkActvTycd) {
        this.mrkActvTycd = mrkActvTycd;
    }
    public String getTeamBbsId() {
        return teamBbsId;
    }
    public void setTeamBbsId(String teamBbsId) {
        this.teamBbsId = teamBbsId;
    }
    public String getTeamBbsUseyn() {
        return teamBbsUseyn;
    }
    public void setTeamBbsUseyn(String teamBbsUseyn) {
        this.teamBbsUseyn = teamBbsUseyn;
    }
    public String getTeamMbrId() {
        return teamMbrId;
    }
    public void setTeamMbrId(String teamMbrId) {
        this.teamMbrId = teamMbrId;
    }
    public String getRole() {
        return role;
    }
    public void setRole(String role) {
        this.role = role;
    }
    public String getLdryn() {
        return ldryn;
    }
    public void setLdryn(String ldryn) {
        this.ldryn = ldryn;
    }
    public String getActvGbncd() {
        return actvGbncd;
    }
    public void setActvGbncd(String actvGbncd) {
        this.actvGbncd = actvGbncd;
    }
    public String getTeamCpstCmptnyn() {
        return teamCpstCmptnyn;
    }
    public void setTeamCpstCmptnyn(String teamCpstCmptnyn) {
        this.teamCpstCmptnyn = teamCpstCmptnyn;
    }
    public String getTeamList() {
        return teamList;
    }
    public void setTeamList(String teamList) {
        this.teamList = teamList;
    }
    public String getLdrynList() {
        return ldrynList;
    }
    public void setLdrynList(String ldrynList) {
        this.ldrynList = ldrynList;
    }
    public List<TeamGrpMgrVO> getTeamDataList() {
        return teamDataList;
    }
    public void setTeamDataList(List<TeamGrpMgrVO> teamDataList) {
        this.teamDataList = teamDataList;
    }
}