package knou.lms.mut.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class MutEvalGradeVO extends DefaultVO {
    
    /** tb_lms_mut_eval_grade */
    private String  gradeCd;        // 등급 코드
    private String  evalCd;         // 평가 코드
    private String  qstnCd;         // 문제 코드
    private String  gradeTitle;     // 등급 제목
    private String  gradeCts;       // 등급 설명
    private Integer gradeScore;     // 등급 성적
    
    private List<String> qstnCds;
    
    public String getGradeCd() {
        return gradeCd;
    }
    public void setGradeCd(String gradeCd) {
        this.gradeCd = gradeCd;
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
    public Integer getGradeScore() {
        return gradeScore;
    }
    public void setGradeScore(Integer gradeScore) {
        this.gradeScore = gradeScore;
    }
    public List<String> getQstnCds() {
        return qstnCds;
    }
    public void setQstnCds(List<String> qstnCds) {
        this.qstnCds = qstnCds;
    }

}
