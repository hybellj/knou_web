package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class Forum2TeamDscsVO extends DefaultVO {

    private static final long serialVersionUID = 1L;
    // 기본 컬럼 (SnakeCase -> CamelCase 자동 매핑)
    private String dscsId;         // 토론 ID
    private String upDscsId;       // 상위 토론 ID
    private String teamId;         // 팀 ID
    private String teamnm;         // 팀명 (T.TEAMNM)
    private String dscsTtl;        // 토론 제목(부주제)
    private String dscsCts;        // 토론 내용
    private String teamDscsOyn;    // 팀 토론 오픈 여부
    private String lrnGrpId;       // 학습그룹아이디

    // 가상 컬럼 (Alias 기반 매핑)
    private String leaderNm;       // 팀장명 (LEADER_NM)
    private int teamMbrCnt;        // 팀원 수 (TEAM_MBR_CNT)
    private int atclCnt;           // 참여글 수 (ATCL_CNT)
    private int cmntCnt;           // 댓글 수 (CMNT_CNT)

    // Getter & Setter
    public String getDscsId() {
        return dscsId;
    }

    public void setDscsId(String dscsId) {
        this.dscsId = dscsId;
    }

    public String getUpDscsId() {
        return upDscsId;
    }

    public void setUpDscsId(String upDscsId) {
        this.upDscsId = upDscsId;
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

    public String getDscsTtl() {
        return dscsTtl;
    }

    public void setDscsTtl(String dscsTtl) {
        this.dscsTtl = dscsTtl;
    }

    public String getDscsCts() {
        return dscsCts;
    }

    public void setDscsCts(String dscsCts) {
        this.dscsCts = dscsCts;
    }

    public String getTeamDscsOyn() {
        return teamDscsOyn;
    }

    public void setTeamDscsOyn(String teamDscsOyn) {
        this.teamDscsOyn = teamDscsOyn;
    }

    public String getLrnGrpId() {
        return lrnGrpId;
    }

    public void setLrnGrpId(String lrnGrpId) {
        this.lrnGrpId = lrnGrpId;
    }

    public String getLeaderNm() {
        return leaderNm;
    }

    public void setLeaderNm(String leaderNm) {
        this.leaderNm = leaderNm;
    }

    public int getTeamMbrCnt() {
        return teamMbrCnt;
    }

    public void setTeamMbrCnt(int teamMbrCnt) {
        this.teamMbrCnt = teamMbrCnt;
    }

    public int getAtclCnt() {
        return atclCnt;
    }

    public void setAtclCnt(int atclCnt) {
        this.atclCnt = atclCnt;
    }

    public int getCmntCnt() {
        return cmntCnt;
    }

    public void setCmntCnt(int cmntCnt) {
        this.cmntCnt = cmntCnt;
    }
}
