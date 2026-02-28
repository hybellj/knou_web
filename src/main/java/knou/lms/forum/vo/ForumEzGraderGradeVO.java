package knou.lms.forum.vo;

import knou.lms.common.vo.DefaultVO;

public class ForumEzGraderGradeVO extends DefaultVO {

    private String forumCd;
    private String orgId;      // 기관 코드
    private String crsCreCd;

    private String evalCd;     // 평가코드
    private String qstnCd;     // 문항코드
    private String gradeCd;    // 등급코드
    private String gradeTitle; // 등급 제묵
    private String gradeCts;   // 등급 설명
    private int    gradeScore; // 등급 점수

    public String getForumCd() {
        return forumCd;
    }
    public void setForumCd(String forumCd) {
        this.forumCd = forumCd;
    }
    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getEvalCd() {
        return evalCd;
    }
    public void setEvalCd(String evalCd) {
        this.evalCd = evalCd;
    }
    public String getQstnCd() {
        return qstnCd;
    }
    public void setQstnCd(String qstnCd) {
        this.qstnCd = qstnCd;
    }
    public String getGradeCd() {
        return gradeCd;
    }
    public void setGradeCd(String gradeCd) {
        this.gradeCd = gradeCd;
    }
    public String getGradeTitle() {
        return gradeTitle;
    }
    public void setGradeTitle(String gradeTitle) {
        this.gradeTitle = gradeTitle;
    }
    public String getGradeCts() {
        return gradeCts;
    }
    public void setGradeCts(String gradeCts) {
        this.gradeCts = gradeCts;
    }
    public int getGradeScore() {
        return gradeScore;
    }
    public void setGradeScore(int gradeScore) {
        this.gradeScore = gradeScore;
    }

}
