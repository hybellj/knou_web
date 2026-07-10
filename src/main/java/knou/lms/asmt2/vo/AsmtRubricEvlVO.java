package knou.lms.asmt2.vo;

import knou.lms.common.vo.DefaultVO;

import java.math.BigDecimal;
import java.util.List;

public class AsmtRubricEvlVO extends DefaultVO {
    private String asmtId;            // 과제아이디
    private String userIds;           // 평가대상 사용자아이디 목록
    private String teamId;            // 팀아이디
    private String rubricId;          // 루브릭아이디
    private String rubricQstnId;      // 루브릭문항아이디
    private String rubricVwitmId;     // 루브릭보기항목아이디
    private BigDecimal evlrt;         // 평가비율
    private BigDecimal rubricVwitmPnt; // 루브릭보기항목포인트
    private BigDecimal maxRubricVwitmPnt; // 문항 내 최대 루브릭보기항목포인트
    private String rubricVwitmIds;    // 선택한 루브릭보기항목아이디 목록
    private List<String> rubricVwitmIdList; // 선택한 루브릭보기항목아이디 목록

    public String getAsmtId() {
        return asmtId;
    }

    public void setAsmtId(String asmtId) {
        this.asmtId = asmtId;
    }

    public String getUserIds() {
        return userIds;
    }

    public void setUserIds(String userIds) {
        this.userIds = userIds;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }

    public String getRubricId() {
        return rubricId;
    }

    public void setRubricId(String rubricId) {
        this.rubricId = rubricId;
    }

    public String getRubricQstnId() {
        return rubricQstnId;
    }

    public void setRubricQstnId(String rubricQstnId) {
        this.rubricQstnId = rubricQstnId;
    }

    public String getRubricVwitmId() {
        return rubricVwitmId;
    }

    public void setRubricVwitmId(String rubricVwitmId) {
        this.rubricVwitmId = rubricVwitmId;
    }

    public BigDecimal getEvlrt() {
        return evlrt;
    }

    public void setEvlrt(BigDecimal evlrt) {
        this.evlrt = evlrt;
    }

    public BigDecimal getRubricVwitmPnt() {
        return rubricVwitmPnt;
    }

    public void setRubricVwitmPnt(BigDecimal rubricVwitmPnt) {
        this.rubricVwitmPnt = rubricVwitmPnt;
    }

    public BigDecimal getMaxRubricVwitmPnt() {
        return maxRubricVwitmPnt;
    }

    public void setMaxRubricVwitmPnt(BigDecimal maxRubricVwitmPnt) {
        this.maxRubricVwitmPnt = maxRubricVwitmPnt;
    }

    public String getRubricVwitmIds() {
        return rubricVwitmIds;
    }

    public void setRubricVwitmIds(String rubricVwitmIds) {
        this.rubricVwitmIds = rubricVwitmIds;
    }

    public List<String> getRubricVwitmIdList() {
        return rubricVwitmIdList;
    }

    public void setRubricVwitmIdList(List<String> rubricVwitmIdList) {
        this.rubricVwitmIdList = rubricVwitmIdList;
    }
}
