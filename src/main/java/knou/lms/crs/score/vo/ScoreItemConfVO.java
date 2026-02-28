package knou.lms.crs.score.vo;

import knou.lms.common.vo.DefaultVO;

public class ScoreItemConfVO extends DefaultVO {

    private static final long serialVersionUID = 4632561828701868500L;

    private String  scoreItemId;
    private Integer scoreItemOrder;
    private String  scoreTypeCd;
    private String  scoreItemNm;
    private String  scoreItemDesc;
    private Integer scoreRatio;

    public String getScoreItemId() {
        return scoreItemId;
    }

    public void setScoreItemId(String scoreItemId) {
        this.scoreItemId = scoreItemId;
    }

    public Integer getScoreItemOrder() {
        return scoreItemOrder;
    }

    public void setScoreItemOrder(Integer scoreItemOrder) {
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

    public String getScoreItemDesc() {
        return scoreItemDesc;
    }

    public void setScoreItemDesc(String scoreItemDesc) {
        this.scoreItemDesc = scoreItemDesc;
    }

    public Integer getScoreRatio() {
        return scoreRatio;
    }

    public void setScoreRatio(Integer scoreRatio) {
        this.scoreRatio = scoreRatio;
    }

}
