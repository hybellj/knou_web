package knou.lms.mut.vo;

import knou.lms.common.vo.DefaultVO;

public class MutEvalRsltVO extends DefaultVO {
    
    /** tb_lms_mut_eval_rslt */
    private String  mutEvalCd;          // 상호평가 코드
    private String  evalCd;             // 평가 코드
    private String  rltnTeamCd;         // 연결팀 ID
    private String  evalUserId;         // 평가 사용자 번호
    private String  evalTrgtUserId;     // 평가 대상 사용자 번호
    private String  evalDttm;           // 평가 일시
    private String  qstnNos;            // 문항 코드들
    private String  evalScores;         // 평가 점수들
    private Integer evalTotal;          // 평가 총점
    private String  evalCts;            // 평가 내용
    private String  evalStatusCd;       // 평가 상태
    
    private String  crsCreCd;
    
    public String getMutEvalCd() {
        return mutEvalCd;
    }
    public void setMutEvalCd(String mutEvalCd) {
        this.mutEvalCd = mutEvalCd;
    }
    public String getEvalCd() {
        return evalCd;
    }
    public void setEvalCd(String evalCd) {
        this.evalCd = evalCd;
    }
    public String getRltnTeamCd() {
        return rltnTeamCd;
    }
    public void setRltnTeamCd(String rltnTeamCd) {
        this.rltnTeamCd = rltnTeamCd;
    }
    public String getEvalUserId() {
        return evalUserId;
    }
    public void setEvalUserId(String evalUserId) {
        this.evalUserId = evalUserId;
    }
    public String getEvalTrgtUserId() {
        return evalTrgtUserId;
    }
    public void setEvalTrgtUserId(String evalTrgtUserId) {
        this.evalTrgtUserId = evalTrgtUserId;
    }
    public String getEvalDttm() {
        return evalDttm;
    }
    public void setEvalDttm(String evalDttm) {
        this.evalDttm = evalDttm;
    }
    public String getQstnNos() {
        return qstnNos;
    }
    public void setQstnNos(String qstnNos) {
        this.qstnNos = qstnNos;
    }
    public String getEvalScores() {
        return evalScores;
    }
    public void setEvalScores(String evalScores) {
        this.evalScores = evalScores;
    }
    public Integer getEvalTotal() {
        return evalTotal;
    }
    public void setEvalTotal(Integer evalTotal) {
        this.evalTotal = evalTotal;
    }
    public String getEvalCts() {
        return evalCts;
    }
    public void setEvalCts(String evalCts) {
        this.evalCts = evalCts;
    }
    public String getEvalStatusCd() {
        return evalStatusCd;
    }
    public void setEvalStatusCd(String evalStatusCd) {
        this.evalStatusCd = evalStatusCd;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

}
