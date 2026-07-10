package knou.lms.crs.sbjct.web.paging;

import knou.framework.common.PageInfo;

/**
 * 과목개설 목록 조회 조건과 페이징 정보를 함께 전달한다.
 */
public class SbjctOfringPageInfo extends PageInfo {

    private static final long serialVersionUID = 1L;

    private String langCd; // 코드명 조회에 사용할 언어 코드
    private String sbjctYr; // 과목 연도 검색 조건
    private String sbjctSmstr; // 과목 학기 검색 조건
    private String crsGbncd; // 과정 구분 검색 조건
    private String sbjctTycd; // 과목 유형 검색 조건
    private String lctrGbncd; // 강의 구분 검색 조건
    private String excelGrid; // 엑셀 다운로드 헤더 정보

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public String getSbjctYr() {
        return sbjctYr;
    }

    public void setSbjctYr(String sbjctYr) {
        this.sbjctYr = sbjctYr;
    }

    public String getSbjctSmstr() {
        return sbjctSmstr;
    }

    public void setSbjctSmstr(String sbjctSmstr) {
        this.sbjctSmstr = sbjctSmstr;
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

    public String getLctrGbncd() {
        return lctrGbncd;
    }

    public void setLctrGbncd(String lctrGbncd) {
        this.lctrGbncd = lctrGbncd;
    }

    public String getExcelGrid() {
        return excelGrid;
    }

    public void setExcelGrid(String excelGrid) {
        this.excelGrid = excelGrid;
    }
}
