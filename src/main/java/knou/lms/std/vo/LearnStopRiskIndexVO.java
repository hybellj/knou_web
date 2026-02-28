package knou.lms.std.vo;

import knou.lms.common.vo.DefaultVO;

public class LearnStopRiskIndexVO extends DefaultVO {

    private static final long serialVersionUID = -948350675325032357L;

    private String creYear;
    private String creTerm;
    private String userId;
    private String pubYear;
    private String pubTerm;
    private float  riskIndex;
    private String riskGrade;

    // 추가
    private String userNm;
    private String deptNm;

    public String getCreYear() {
        return creYear;
    }

    public void setCreYear(String creYear) {
        this.creYear = creYear;
    }

    public String getCreTerm() {
        return creTerm;
    }

    public void setCreTerm(String creTerm) {
        this.creTerm = creTerm;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getPubYear() {
        return pubYear;
    }

    public void setPubYear(String pubYear) {
        this.pubYear = pubYear;
    }

    public String getPubTerm() {
        return pubTerm;
    }

    public void setPubTerm(String pubTerm) {
        this.pubTerm = pubTerm;
    }

    public float getRiskIndex() {
        return riskIndex;
    }

    public void setRiskIndex(float riskIndex) {
        this.riskIndex = riskIndex;
    }

    public String getRiskGrade() {
        return riskGrade;
    }

    public void setRiskGrade(String riskGrade) {
        this.riskGrade = riskGrade;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public String getDeptNm() {
        return deptNm;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

}
