package knou.lms.asmt2.vo;

import knou.lms.common.vo.DefaultVO;

public class AsmtFdbkVO extends DefaultVO {
    private String asmtFdbkId;             // 과제피드백아이디
    private String asmtId;                 // 과제아이디
    private String fdbkCts;                // 피드백내용
    private String teamId;                 // 팀아이디
    private String pushAlimyn;             // 푸시알림여부

    /* 로직용 */
    private String userIds; // 다건 평가 대상

    public String getAsmtFdbkId() {
        return asmtFdbkId;
    }

    public void setAsmtFdbkId(String asmtFdbkId) {
        this.asmtFdbkId = asmtFdbkId;
    }

    public String getAsmtId() {
        return asmtId;
    }

    public void setAsmtId(String asmtId) {
        this.asmtId = asmtId;
    }

    public String getFdbkCts() {
        return fdbkCts;
    }

    public void setFdbkCts(String fdbkCts) {
        this.fdbkCts = fdbkCts;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }

    public String getPushAlimyn() {
        return pushAlimyn;
    }

    public void setPushAlimyn(String pushAlimyn) {
        this.pushAlimyn = pushAlimyn;
    }

    public String getUserIds() {
        return userIds;
    }

    public void setUserIds(String userIds) {
        this.userIds = userIds;
    }
}
