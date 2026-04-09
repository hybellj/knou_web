package knou.lms.asmt2.vo;

import knou.lms.common.vo.DefaultVO;

public class AsmtSubDtlVO extends DefaultVO {
    private String dvclasNo;         // 분반번호
    private String teamId;           // 팀아이디
    private String teamNm;           // 팀명
    private String asmtId;           // 부과제아이디
    private String asmtTtl;          // 과제제목
    private String asmtCts;          // 과제내용

    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
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

    public String getAsmtId() {
        return asmtId;
    }

    public void setAsmtId(String asmtId) {
        this.asmtId = asmtId;
    }

    public String getAsmtTtl() {
        return asmtTtl;
    }

    public void setAsmtTtl(String asmtTtl) {
        this.asmtTtl = asmtTtl;
    }

    public String getAsmtCts() {
        return asmtCts;
    }

    public void setAsmtCts(String asmtCts) {
        this.asmtCts = asmtCts;
    }


}


