package knou.lms.forum2.vo;

import java.io.Serializable;

public class DscsTeamGrpVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String dvclasNo; // 분반번호
    private String sbjctId; // 과목아이디
    private String teamGrpId; // 팀그룹아이디
    private String teamGrpnm; // 팀그룹명
    private String byteamDscsUseyn; // 팀별부토론사용여부

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

    public String getByteamDscsUseyn() {
        return byteamDscsUseyn;
    }

    public void setByteamDscsUseyn(String byteamDscsUseyn) {
        this.byteamDscsUseyn = byteamDscsUseyn;
    }
}
