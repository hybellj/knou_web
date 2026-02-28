package knou.lms.mut.vo;

import knou.lms.common.vo.DefaultVO;

public class MutEvalRltnVO extends DefaultVO {
    
    /** tb_lms_mut_eval_rltn */
    private String  evalCd;         // 평가 코드
    private String  evalDivCd;      // 평가 구분 코드
    private String  rltnCd;         // 연결 코드
    private String  crsCreCd;       // 과정 개설 코드
    
    public String getEvalCd() {
        return evalCd;
    }
    public void setEvalCd(String evalCd) {
        this.evalCd = evalCd;
    }
    public String getEvalDivCd() {
        return evalDivCd;
    }
    public void setEvalDivCd(String evalDivCd) {
        this.evalDivCd = evalDivCd;
    }
    public String getRltnCd() {
        return rltnCd;
    }
    public void setRltnCd(String rltnCd) {
        this.rltnCd = rltnCd;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

}
