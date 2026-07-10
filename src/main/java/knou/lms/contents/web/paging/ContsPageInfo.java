package knou.lms.contents.web.paging;

import knou.framework.common.PageInfo;

/**
 * 관리자 콘텐츠 관리 과목 목록 검색 조건을 전달한다.
 */
public class ContsPageInfo extends PageInfo {

    private static final long serialVersionUID = 1L;

    private String langCd; // 언어코드
    private String sbjctYr; // 학사년도
    private String sbjctSmstr; // 학기
    private String excelGrid; // 엑셀 헤더정보JSON string

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

    public String getExcelGrid() {
        return excelGrid;
    }

    public void setExcelGrid(String excelGrid) {
        this.excelGrid = excelGrid;
    }

}
