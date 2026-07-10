package knou.lms.review.vo;

import knou.framework.common.PageInfo;

public class ReviewPeriodListVO extends PageInfo {

    private static final long serialVersionUID = -420924783719694967L;

    private String menuId;      // 메뉴 ID
    private String langCd;      // 언어 코드
    private String crsGbncd;    // 과정구분 코드
    private String sbjctTycd;   // 과목분류 코드



    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public String getCrsGbncd() {
        return crsGbncd;
    }

    public void setCrsGbncd(String crsGbncd) {
        this.crsGbncd = crsGbncd;
    }

    public String getSbjctTycd() {
        return sbjctTycd;
    }

    public void setSbjctTycd(String sbjctTycd) {
        this.sbjctTycd = sbjctTycd;
    }
}
