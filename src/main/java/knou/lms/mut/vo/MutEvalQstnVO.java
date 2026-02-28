package knou.lms.mut.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class MutEvalQstnVO extends DefaultVO {

    /** tb_lms_mut_eval_qstn */
    private String  evalCd;         // 평가 코드
    private String  qstnCd;         // 문제 코드
    private String  evalTypeCd;     // 평가 유형 코드
    private String  parQstnCd;      // 부모 문제 코드
    private Integer qstnNo;         // 문제 번호
    private String  qstnCts;        // 문제 내용
    private Integer evalScore;      // 배점

    private List<MutEvalGradeVO> evalGradeList;     // 등급 리스트

    private String  rltnCd;

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
    public String getEvalTypeCd() {
        return evalTypeCd;
    }
    public void setEvalTypeCd(String evalTypeCd) {
        this.evalTypeCd = evalTypeCd;
    }
    public String getParQstnCd() {
        return parQstnCd;
    }
    public void setParQstnCd(String parQstnCd) {
        this.parQstnCd = parQstnCd;
    }
    public Integer getQstnNo() {
        return qstnNo;
    }
    public void setQstnNo(Integer qstnNo) {
        this.qstnNo = qstnNo;
    }
    public String getQstnCts() {
        return qstnCts;
    }
    public void setQstnCts(String qstnCts) {
        this.qstnCts = qstnCts;
    }
    public Integer getEvalScore() {
        return evalScore;
    }
    public void setEvalScore(Integer evalScore) {
        this.evalScore = evalScore;
    }
    public String getRltnCd() {
        return rltnCd;
    }
    public void setRltnCd(String rltnCd) {
        this.rltnCd = rltnCd;
    }
    public List<MutEvalGradeVO> getEvalGradeList() {
        return evalGradeList;
    }
    public void setEvalGradeList(List<MutEvalGradeVO> evalGradeList) {
        this.evalGradeList = evalGradeList;
    }

}
