package knou.lms.log2.user.vo;

import java.util.Arrays;
import java.util.stream.Collectors;

import knou.framework.common.PageInfo;

/**
 * 사용자접속이력 조회/검색 조건 VO.
 */
public class UserActvHstryVO extends PageInfo {

    private String langCd;
    private String excelGrid;
    private String searchSdttm;
    private String searchEdttm;
    private String srvcActnGbncd;
    private String userTycds;
    private String[] userTycdList;

    /**
     * 체크박스로 전달된 사용자 유형을 SQL 검색용 콤마 문자열로 정리한다.
     */
    public void normalizeSearchParams() {
        if(this.userTycdList == null || this.userTycdList.length == 0) {
            return;
        }

        this.userTycds = Arrays.stream(this.userTycdList)
                .filter(code -> code != null && !code.trim().isEmpty())
                .map(String::trim)
                .distinct()
                .collect(Collectors.joining(","));
    }

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public String getExcelGrid() {
        return excelGrid;
    }

    public void setExcelGrid(String excelGrid) {
        this.excelGrid = excelGrid;
    }

    public String getSearchSdttm() {
        return searchSdttm;
    }

    public void setSearchSdttm(String searchSdttm) {
        this.searchSdttm = searchSdttm;
    }

    public String getSearchEdttm() {
        return searchEdttm;
    }

    public void setSearchEdttm(String searchEdttm) {
        this.searchEdttm = searchEdttm;
    }

    public String getSrvcActnGbncd() {
        return srvcActnGbncd;
    }

    public void setSrvcActnGbncd(String srvcActnGbncd) {
        this.srvcActnGbncd = srvcActnGbncd;
    }

    public String getUserTycds() {
        return userTycds;
    }

    public void setUserTycds(String userTycds) {
        this.userTycds = userTycds;
    }

    public String[] getUserTycdList() {
        return userTycdList;
    }

    public void setUserTycdList(String[] userTycdList) {
        this.userTycdList = userTycdList;
    }
}
