package knou.lms.asmt2.vo;

import knou.lms.common.vo.DefaultVO;

public class AsmtTrgtVO extends DefaultVO {
    private String asmtSbmsnTrgtId;
    private String asmtId;
    private String teamId;

    public String getAsmtSbmsnTrgtId() {
        return asmtSbmsnTrgtId;
    }

    public void setAsmtSbmsnTrgtId(String asmtSbmsnTrgtId) {
        this.asmtSbmsnTrgtId = asmtSbmsnTrgtId;
    }

    public String getAsmtId() {
        return asmtId;
    }

    public void setAsmtId(String asmtId) {
        this.asmtId = asmtId;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }
}
