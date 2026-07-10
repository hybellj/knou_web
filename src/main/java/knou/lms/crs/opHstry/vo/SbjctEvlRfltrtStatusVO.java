package knou.lms.crs.opHstry.vo;

import knou.framework.common.PageInfo;

import java.util.Arrays;
import java.util.stream.Collectors;

public class SbjctEvlRfltrtStatusVO extends PageInfo {
    private String langCd;
    private String excelGrid;
    private String missingTyCds;
    private String wrongTyCds;
    private String[] missingTyCdList;
    private String[] wrongTyCdList;

    public void normalizeItemTypeParams() {
        this.missingTyCds = joinCodes(this.missingTyCdList, this.missingTyCds);
        this.wrongTyCds = joinCodes(this.wrongTyCdList, this.wrongTyCds);
    }

    private String joinCodes(String[] codes, String fallback) {
        if(codes == null || codes.length == 0) {
            return fallback;
        }
        return Arrays.stream(codes)
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

    public String getMissingTyCds() {
        return missingTyCds;
    }

    public void setMissingTyCds(String missingTyCds) {
        this.missingTyCds = missingTyCds;
    }

    public String getWrongTyCds() {
        return wrongTyCds;
    }

    public void setWrongTyCds(String wrongTyCds) {
        this.wrongTyCds = wrongTyCds;
    }

    public String[] getMissingTyCdList() {
        return missingTyCdList;
    }

    public void setMissingTyCdList(String[] missingTyCdList) {
        this.missingTyCdList = missingTyCdList;
    }

    public String[] getWrongTyCdList() {
        return wrongTyCdList;
    }

    public void setWrongTyCdList(String[] wrongTyCdList) {
        this.wrongTyCdList = wrongTyCdList;
    }
}
