package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

public class DscsTeamDscsVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String dscsId;              // 토론 ID
    private String upDscsId;            // 상위 토론 ID
    private String teamId;              // 팀 ID
    private String teamnm;              // 팀명
    private String dscsTtl;             // 토론 제목
    private String dscsCts;             // 토론 내용
    private String teamDscsOyn;         // 팀 토론 오픈 여부
    private String teamGrpId;           // 팀그룹아이디
    private String dvclasNo;            // 분반번호
    private String sbjctId;             // 과목아이디
    private String byteamDscsUseyn;     // 팀별 토론 설정 여부

    private String leaderNm;            // 팀장명
    private int teamMbrCnt;             // 팀원 수
    private int atclCnt;                // 게시글 수
    private int cmntCnt;                // 댓글 수
    private String teamUploadFiles;     // 팀 업로드 파일
    private String teamUploadPath;      // 팀 업로드 경로

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

    public String getTeamGrpId() {
        return teamGrpId;
    }

    public void setTeamGrpId(String teamGrpId) {
        this.teamGrpId = teamGrpId;
    }

    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getByteamDscsUseyn() {
        return byteamDscsUseyn;
    }

    public void setByteamDscsUseyn(String byteamDscsUseyn) {
        this.byteamDscsUseyn = byteamDscsUseyn;
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

    public String getTeamUploadFiles() {
        return teamUploadFiles;
    }

    public void setTeamUploadFiles(String teamUploadFiles) {
        this.teamUploadFiles = teamUploadFiles;
    }

    public String getTeamUploadPath() {
        return teamUploadPath;
    }

    public void setTeamUploadPath(String teamUploadPath) {
        this.teamUploadPath = teamUploadPath;
    }
}
