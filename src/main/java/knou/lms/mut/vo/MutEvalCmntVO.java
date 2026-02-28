package knou.lms.mut.vo;

import knou.lms.common.vo.DefaultVO;

public class MutEvalCmntVO extends DefaultVO {
    
    /** tb_lms_mut_eval_cmnt */
    private String  mutEvalCmntCd;      // 상호평가 댓글 코드
    private String  mutEvalCd;          // 상포평가 코드
    private String  evalCd;             // 평가 코드
    private String  cmntCts;            // 댓글 내용
    private String  delYn;              // 삭제 여부
    
    public String getMutEvalCmntCd() {
        return mutEvalCmntCd;
    }
    public void setMutEvalCmntCd(String mutEvalCmntCd) {
        this.mutEvalCmntCd = mutEvalCmntCd;
    }
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
    public String getCmntCts() {
        return cmntCts;
    }
    public void setCmntCts(String cmntCts) {
        this.cmntCts = cmntCts;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

}
