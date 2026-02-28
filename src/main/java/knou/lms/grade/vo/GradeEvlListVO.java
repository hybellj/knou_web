package knou.lms.grade.vo;

import knou.lms.common.vo.DefaultVO;

public class GradeEvlListVO extends DefaultVO {
	private static final long serialVersionUID = 2037999059387125063L;
	private String crsCreCd;
    private String scoreEvalGbn;
    private String scoreGrantGbn;
    
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getScoreEvalGbn() {
        return scoreEvalGbn;
    }
    public void setScoreEvalGbn(String scoreEvalGbn) {
        this.scoreEvalGbn = scoreEvalGbn;
    }
    public String getScoreGrantGbn() {
        return scoreGrantGbn;
    }
    public void setScoreGrantGbn(String scoreGrantGbn) {
        this.scoreGrantGbn = scoreGrantGbn;
    }
}
