package knou.lms.stats.vo;

import knou.framework.common.PageInfo;

public class QnaStatsVO extends PageInfo {

    private String langCd;
    private String excelGrid;

    /**
     * 화면 언어 코드를 반환한다.
     */
    public String getLangCd() {
        return langCd;
    }

    /**
     * 화면 언어 코드를 설정한다.
     */
    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    /**
     * 엑셀 다운로드 컬럼 설정 JSON을 반환한다.
     */
    public String getExcelGrid() {
        return excelGrid;
    }

    /**
     * 엑셀 다운로드 컬럼 설정 JSON을 설정한다.
     */
    public void setExcelGrid(String excelGrid) {
        this.excelGrid = excelGrid;
    }
}
