package knou.lms.evalwgtmng.vo;

import java.util.List;

import knou.lms.mrk.vo.MarkItemSettingVO;

public class EvalWgtMngVO {
    private String menuId;
    private String orgId;
    private String orgNm;
    private String haksaYear;
    private String haksaTerm;
    private String sbjctId;
    private String langCd;
    private String rgtrId;
    private String mdfrId;
    private String uploadFiles;
    private String uploadPath;
    private String excelGrid;
    private String searchValue;
    private String mode;
    private String smstrChrtId;
    private String crclmnNo;
    private String sbjctNm;
    private String profnm;
    private String[] targetSbjctIds;
    private List<MarkItemSettingVO> mrkItmStngList;

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

    public String getOrgNm() {
        return orgNm;
    }

    public void setOrgNm(String orgNm) {
        this.orgNm = orgNm;
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

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getUploadFiles() {
        return uploadFiles;
    }

    public void setUploadFiles(String uploadFiles) {
        this.uploadFiles = uploadFiles;
    }

    public String getUploadPath() {
        return uploadPath;
    }

    public void setUploadPath(String uploadPath) {
        this.uploadPath = uploadPath;
    }

    public String getExcelGrid() {
        return excelGrid;
    }

    public void setExcelGrid(String excelGrid) {
        this.excelGrid = excelGrid;
    }

    public String getSearchValue() {
        return searchValue;
    }

    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public String getSmstrChrtId() {
        return smstrChrtId;
    }

    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
    }

    public String getCrclmnNo() {
        return crclmnNo;
    }

    public void setCrclmnNo(String crclmnNo) {
        this.crclmnNo = crclmnNo;
    }

    public String getSbjctNm() {
        return sbjctNm;
    }

    public void setSbjctNm(String sbjctNm) {
        this.sbjctNm = sbjctNm;
    }

    public String getProfnm() {
        return profnm;
    }

    public void setProfnm(String profnm) {
        this.profnm = profnm;
    }

    public String[] getTargetSbjctIds() {
        return targetSbjctIds;
    }

    public void setTargetSbjctIds(String[] targetSbjctIds) {
        this.targetSbjctIds = targetSbjctIds;
    }

    public List<MarkItemSettingVO> getMrkItmStngList() {
        return mrkItmStngList;
    }

    public void setMrkItmStngList(List<MarkItemSettingVO> mrkItmStngList) {
        this.mrkItmStngList = mrkItmStngList;
    }
}
