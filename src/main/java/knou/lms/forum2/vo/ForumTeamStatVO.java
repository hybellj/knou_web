package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class ForumTeamStatVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    // 쿼리 직접 선택 컬럼
    private String dscsId;         // 토론 ID (A.DSCS_ID)
    private String upDscsId;       // 상위 토론 ID (A.UP_DSCS_ID)
    private String teamId;         // 팀 ID (A.TEAM_ID)
    private String teamNm;         // 팀명 (T.TEAMNM)
    private String dscsTtl;        // 토론 부주제 (A.DSCS_TTL)
    private String teamDscsOyn;    // 팀 토론 오픈 여부 (A.TEAM_DSCS_OYN)

    // 서브쿼리 가상 컬럼 (Alias 매핑)
    private String leaderNm;       // 팀장명
    private int teamMbrCnt;        // 팀원 수
    private int atclCnt;           // 참여글 수
    private int cmntCnt;           // 댓글 수

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

    public String getTeamNm() {
        return teamNm;
    }

    public void setTeamNm(String teamNm) {
        this.teamNm = teamNm;
    }

    public String getDscsTtl() {
        return dscsTtl;
    }

    public void setDscsTtl(String dscsTtl) {
        this.dscsTtl = dscsTtl;
    }

    public String getTeamDscsOyn() {
        return teamDscsOyn;
    }

    public void setTeamDscsOyn(String teamDscsOyn) {
        this.teamDscsOyn = teamDscsOyn;
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
