package knou.lms.resh.vo;

import knou.lms.common.vo.DefaultVO;

public class ReshScaleVO extends DefaultVO {

    /** tb_lms_resch_scale */
    private String  reschScaleCd;       // 설문 척도 고유번호
    private String  reschQstnCd;        // 설문 항목 고유번호
    private Integer scaleOdr;           // 척도 순서
    private String  scaleTitle;         // 척도 제목
    private Integer scaleScore;         // 척도 점수
    
    private String  reschPageCd;        // 설문 페이지 고유번호
    
    public String getReschScaleCd() {
        return reschScaleCd;
    }
    public void setReschScaleCd(String reschScaleCd) {
        this.reschScaleCd = reschScaleCd;
    }
    public String getReschQstnCd() {
        return reschQstnCd;
    }
    public void setReschQstnCd(String reschQstnCd) {
        this.reschQstnCd = reschQstnCd;
    }
    public Integer getScaleOdr() {
        return scaleOdr;
    }
    public void setScaleOdr(Integer scaleOdr) {
        this.scaleOdr = scaleOdr;
    }
    public String getScaleTitle() {
        return scaleTitle;
    }
    public void setScaleTitle(String scaleTitle) {
        this.scaleTitle = scaleTitle;
    }
    public Integer getScaleScore() {
        return scaleScore;
    }
    public void setScaleScore(Integer scaleScore) {
        this.scaleScore = scaleScore;
    }
    public String getReschPageCd() {
        return reschPageCd;
    }
    public void setReschPageCd(String reschPageCd) {
        this.reschPageCd = reschPageCd;
    }
    
}
