package knou.lms.review.vo;

import java.io.Serializable;

public class ReviewPeriodVO implements Serializable {

    private static final long serialVersionUID = 3874210203467361168L;

    private String menuId;          // 메뉴 ID
    private String orgId;           // 기관 ID
    private String langCd;          // 언어 코드
    private String haksaYear;       // 학년도
    private String haksaTerm;       // 학기(기수)
    private String sbjctId;         // 과목 ID
    private String mdfrId;          // 수정자 ID
    private String searchValue;     // 검색어
    private String sbjctTycd;       // 과목분류 코드
    private String crsGbncd;        // 과정구분 코드
    private String reviewStatus;    // 복습 가능 상태 코드
    private String reviewStartDttm; // 복습 시작 일시
    private String reviewEndDttm;   // 복습 종료 일시
    private String crsTypeCds;      // 과목분류 코드 문자열
    private String[] crsTypeCdList; // 과목분류 코드 목록

    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public String getHaksaYear() {
        return haksaYear;
    }

    public void setHaksaYear(String haksaYear) {
        this.haksaYear = haksaYear;
    }

    public String getHaksaTerm() {
        return haksaTerm;
    }

    public void setHaksaTerm(String haksaTerm) {
        this.haksaTerm = haksaTerm;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getSearchValue() {
        return searchValue;
    }

    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }

    public String getSbjctTycd() {
        return sbjctTycd;
    }

    public void setSbjctTycd(String sbjctTycd) {
        this.sbjctTycd = sbjctTycd;
    }

    public String getCrsGbncd() {
        return crsGbncd;
    }

    public void setCrsGbncd(String crsGbncd) {
        this.crsGbncd = crsGbncd;
    }

    public String getReviewStatus() {
        return reviewStatus;
    }

    public void setReviewStatus(String reviewStatus) {
        this.reviewStatus = reviewStatus;
    }

    public String getReviewStartDttm() {
        return reviewStartDttm;
    }

    public void setReviewStartDttm(String reviewStartDttm) {
        this.reviewStartDttm = reviewStartDttm;
    }

    public String getReviewEndDttm() {
        return reviewEndDttm;
    }

    public void setReviewEndDttm(String reviewEndDttm) {
        this.reviewEndDttm = reviewEndDttm;
    }

    public String getCrsTypeCds() {
        return crsTypeCds;
    }

    public void setCrsTypeCds(String crsTypeCds) {
        this.crsTypeCds = crsTypeCds;
    }

    public String[] getCrsTypeCdList() {
        return crsTypeCdList;
    }

    public void setCrsTypeCdList(String[] crsTypeCdList) {
        this.crsTypeCdList = crsTypeCdList;
    }
}
