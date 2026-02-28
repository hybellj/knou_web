package knou.lms.resh.vo;

import knou.lms.common.vo.DefaultVO;

public class ReshQstnItemVO extends DefaultVO {

    /** tb_lms_resch_qstn_item */
    private String  reschQstnItemCd;            // 설문 항목 선택지 고유번호
    private String  reschQstnCd;                // 설문 항목 고유번호
    private String  reschQstnItemTitle;         // 설문 항목 선택지 제목
    private Integer itemOdr;                    // 항목 순서
    private String  jumpPage;                   // 이동 정보
    private String  etcItemYn;                  // 기타 항목 여부
    
    private String  reschPageCd;                // 설문 페이지 고유번호
    
    public String getReschQstnItemCd() {
        return reschQstnItemCd;
    }
    public void setReschQstnItemCd(String reschQstnItemCd) {
        this.reschQstnItemCd = reschQstnItemCd;
    }
    public String getReschQstnCd() {
        return reschQstnCd;
    }
    public void setReschQstnCd(String reschQstnCd) {
        this.reschQstnCd = reschQstnCd;
    }
    public String getReschQstnItemTitle() {
        return reschQstnItemTitle;
    }
    public void setReschQstnItemTitle(String reschQstnItemTitle) {
        this.reschQstnItemTitle = reschQstnItemTitle;
    }
    public Integer getItemOdr() {
        return itemOdr;
    }
    public void setItemOdr(Integer itemOdr) {
        this.itemOdr = itemOdr;
    }
    public String getJumpPage() {
        return jumpPage;
    }
    public void setJumpPage(String jumpPage) {
        this.jumpPage = jumpPage;
    }
    public String getEtcItemYn() {
        return etcItemYn;
    }
    public void setEtcItemYn(String etcItemYn) {
        this.etcItemYn = etcItemYn;
    }
    public String getReschPageCd() {
        return reschPageCd;
    }
    public void setReschPageCd(String reschPageCd) {
        this.reschPageCd = reschPageCd;
    }
    
}
