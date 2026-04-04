package knou.lms.forum2.vo;

import java.io.Serializable;

public class DscsLrnGrpVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String dvclasNo; // 분반번호
    private String sbjctId; // 과목아이디
    private String lrnGrpId; // 학습그룹아이디
    private String lrnGrpnm; // 학습그룹명
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

    public String getByteamDscsUseyn() {
        return byteamDscsUseyn;
    }

    public void setByteamDscsUseyn(String byteamDscsUseyn) {
        this.byteamDscsUseyn = byteamDscsUseyn;
    }
}
