package knou.lms.score.vo;

import knou.lms.crs.crecrs.vo.CreCrsVO;

public class ScoreVO extends CreCrsVO
{
    private static final long serialVersionUID = 7793873447070655694L;
    
    //tb_lms_std_org_score_item_conf
    private String orgScoreItemId;
    private Integer scoreItemOrder;
    private String scoreTypeCd;
    private String scoreItemNm;
    private String scoreItemDesc;
    private Integer scoreRatio;
    private String scoreItemId;
    private Float getScore;
    private Float totScore;
    private Float finalScore;
    private Float avgScore;
    private String scoreGrade;
    private String passYn;
    
    /**
     * @return orgScoreItemId 값을 반환한다.
     */
    public String getOrgScoreItemId()
    {
        return orgScoreItemId;
    }
    /**
     * @param orgScoreItemId 을 orgScoreItemId 에 저장한다.
     */
    public void setOrgScoreItemId(String orgScoreItemId)
    {
        this.orgScoreItemId = orgScoreItemId;
    }
    /**
     * @return scoreItemOrder 값을 반환한다.
     */
    public Integer getScoreItemOrder()
    {
        return scoreItemOrder;
    }
    /**
     * @param scoreItemOrder 을 scoreItemOrder 에 저장한다.
     */
    public void setScoreItemOrder(Integer scoreItemOrder)
    {
        this.scoreItemOrder = scoreItemOrder;
    }
    /**
     * @return scoreTypeCd 값을 반환한다.
     */
    public String getScoreTypeCd()
    {
        return scoreTypeCd;
    }
    /**
     * @param scoreTypeCd 을 scoreTypeCd 에 저장한다.
     */
    public void setScoreTypeCd(String scoreTypeCd)
    {
        this.scoreTypeCd = scoreTypeCd;
    }
    /**
     * @return scoreItemNm 값을 반환한다.
     */
    public String getScoreItemNm()
    {
        return scoreItemNm;
    }
    /**
     * @param scoreItemNm 을 scoreItemNm 에 저장한다.
     */
    public void setScoreItemNm(String scoreItemNm)
    {
        this.scoreItemNm = scoreItemNm;
    }
    /**
     * @return scoreItemDesc 값을 반환한다.
     */
    public String getScoreItemDesc()
    {
        return scoreItemDesc;
    }
    /**
     * @param scoreItemDesc 을 scoreItemDesc 에 저장한다.
     */
    public void setScoreItemDesc(String scoreItemDesc)
    {
        this.scoreItemDesc = scoreItemDesc;
    }
    /**
     * @return scoreRatio 값을 반환한다.
     */
    public Integer getScoreRatio()
    {
        return scoreRatio;
    }
    /**
     * @param scoreRatio 을 scoreRatio 에 저장한다.
     */
    public void setScoreRatio(Integer scoreRatio)
    {
        this.scoreRatio = scoreRatio;
    }
    /**
     * @return scoreItemId 값을 반환한다.
     */
    public String getScoreItemId()
    {
        return scoreItemId;
    }
    /**
     * @param scoreItemId 을 scoreItemId 에 저장한다.
     */
    public void setScoreItemId(String scoreItemId)
    {
        this.scoreItemId = scoreItemId;
    }
    /**
     * @return getScore 값을 반환한다.
     */
    public Float getGetScore()
    {
        return getScore;
    }
    /**
     * @param getScore 을 getScore 에 저장한다.
     */
    public void setGetScore(Float getScore)
    {
        this.getScore = getScore;
    }
    /**
     * @return totScore 값을 반환한다.
     */
    public Float getTotScore()
    {
        return totScore;
    }
    /**
     * @param totScore 을 totScore 에 저장한다.
     */
    public void setTotScore(Float totScore)
    {
        this.totScore = totScore;
    }
    /**
     * @return finalScore 값을 반환한다.
     */
    public Float getFinalScore()
    {
        return finalScore;
    }
    /**
     * @param finalScore 을 finalScore 에 저장한다.
     */
    public void setFinalScore(Float finalScore)
    {
        this.finalScore = finalScore;
    }
    /**
     * @return avgScore 값을 반환한다.
     */
    public Float getAvgScore()
    {
        return avgScore;
    }
    /**
     * @param avgScore 을 avgScore 에 저장한다.
     */
    public void setAvgScore(Float avgScore)
    {
        this.avgScore = avgScore;
    }
    /**
     * @return scoreGrade 값을 반환한다.
     */
    public String getScoreGrade()
    {
        return scoreGrade;
    }
    /**
     * @param scoreGrade 을 scoreGrade 에 저장한다.
     */
    public void setScoreGrade(String scoreGrade)
    {
        this.scoreGrade = scoreGrade;
    }
    /**
     * @return passYn 값을 반환한다.
     */
    public String getPassYn()
    {
        return passYn;
    }
    /**
     * @param passYn 을 passYn 에 저장한다.
     */
    public void setPassYn(String passYn)
    {
        this.passYn = passYn;
    }
    
}
