package knou.lms.asmt2.vo;

import knou.lms.common.vo.DefaultVO;

public class AsmtTrgtVO extends DefaultVO {
    private String asmtSbmsnTrgtId;
    private String asmtId;
    private String teamId;
    private String resbmsnPrmyn;

    /* 내부 로직용 */
    private String[] userIdArray;

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

    public String getResbmsnPrmyn() {
        return resbmsnPrmyn;
    }

    public void setResbmsnPrmyn(String resbmsnPrmyn) {
        this.resbmsnPrmyn = resbmsnPrmyn;
    }

    public String[] getUserIdArray() {
        return userIdArray;
    }

    public void setUserIdArray(String[] userIdArray) {
        this.userIdArray = userIdArray;
    }
}
