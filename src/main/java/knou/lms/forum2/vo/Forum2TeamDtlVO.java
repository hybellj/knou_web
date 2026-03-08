package knou.lms.forum2.vo;

import java.io.Serializable;

public class Forum2TeamDtlVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String dvclasNo;      // 분반번호
    private String sbjctId;       // 과목아이디
    private String lrnGrpId;      // 학습그룹아이디
    private String teamId;        // 팀아이디
    private String teamNm;        // 팀명
    private String teamTtl;       // 팀주제
    private String teamCts;       // 팀토론내용
    private String attchFileId;   // 첨부파일아이디(1개)

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

    public String getTeamTtl() {
        return teamTtl;
    }

    public void setTeamTtl(String teamTtl) {
        this.teamTtl = teamTtl;
    }

    public String getTeamCts() {
        return teamCts;
    }

    public void setTeamCts(String teamCts) {
        this.teamCts = teamCts;
    }

    public String getAttchFileId() {
        return attchFileId;
    }

    public void setAttchFileId(String attchFileId) {
        this.attchFileId = attchFileId;
    }
}
