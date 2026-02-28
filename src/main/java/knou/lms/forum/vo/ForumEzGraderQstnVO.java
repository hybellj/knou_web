package knou.lms.forum.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class ForumEzGraderQstnVO extends DefaultVO {

    private String forumCd;
    private String orgId;      // 기관 코드
    private String crsCreCd;

    private String evalCd;     // 평가코드
    private String evalTypeCd; // 평가 유형 코드
    private String evalTitle;  // 평가제목
    private String qstnCd;     // 문항코드

    private String parQstnCd;  // 부모 문항 코드
    private int    qstnNo;     // 문항 제묵
    private String qstnCts;    // 문항 내용
    private String allotScore; // 문항별 배점

    private List<ForumEzGraderGradeVO> grades;

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

    public String getEvalTypeCd() {
        return evalTypeCd;
    }

    public void setEvalTypeCd(String evalTypeCd) {
        this.evalTypeCd = evalTypeCd;
    }

    public String getEvalTitle() {
        return evalTitle;
    }

    public void setEvalTitle(String evalTitle) {
        this.evalTitle = evalTitle;
    }

    public String getQstnCd() {
        return qstnCd;
    }

    public void setQstnCd(String qstnCd) {
        this.qstnCd = qstnCd;
    }

    public String getParQstnCd() {
        return parQstnCd;
    }

    public void setParQstnCd(String parQstnCd) {
        this.parQstnCd = parQstnCd;
    }

    public int getQstnNo() {
        return qstnNo;
    }

    public void setQstnNo(int qstnNo) {
        this.qstnNo = qstnNo;
    }

    public String getQstnCts() {
        return qstnCts;
    }

    public void setQstnCts(String qstnCts) {
        this.qstnCts = qstnCts;
    }

    public String getAllotScore() {
        return allotScore;
    }

    public void setAllotScore(String allotScore) {
        this.allotScore = allotScore;
    }

    public List<ForumEzGraderGradeVO> getGrades() {
        return grades;
    }

    public void setGrades(List<ForumEzGraderGradeVO> grades) {
        this.grades = grades;
    }

}
