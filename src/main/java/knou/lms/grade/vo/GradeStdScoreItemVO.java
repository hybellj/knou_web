package knou.lms.grade.vo;

import knou.lms.common.vo.DefaultVO;

public class GradeStdScoreItemVO extends DefaultVO {
	private static final long serialVersionUID = 2087288602759928787L;
	private String scoreItemId;
    private String scoreItemOrder;
    private String scoreTypeCd;
    private String scoreItemNm;
    private String scoreRatio;
    private String crsTypeCd;
    
    public String getScoreItemId() {
        return scoreItemId;
    }
    public void setScoreItemId(String scoreItemId) {
        this.scoreItemId = scoreItemId;
    }
    public String getScoreItemOrder() {
        return scoreItemOrder;
    }
    public void setScoreItemOrder(String scoreItemOrder) {
        this.scoreItemOrder = scoreItemOrder;
    }
    public String getScoreTypeCd() {
        return scoreTypeCd;
    }
    public void setScoreTypeCd(String scoreTypeCd) {
        this.scoreTypeCd = scoreTypeCd;
    }
    public String getScoreItemNm() {
        return scoreItemNm;
    }
    public void setScoreItemNm(String scoreItemNm) {
        this.scoreItemNm = scoreItemNm;
    }
    public String getScoreRatio() {
        return scoreRatio;
    }
    public void setScoreRatio(String scoreRatio) {
        this.scoreRatio = scoreRatio;
    }
    public String getCrsTypeCd() {
        return crsTypeCd;
    }
    public void setCrsTypeCd(String crsTypeCd) {
        this.crsTypeCd = crsTypeCd;
    }
}
