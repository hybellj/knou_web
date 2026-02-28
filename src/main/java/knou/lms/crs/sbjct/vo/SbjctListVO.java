package knou.lms.crs.sbjct.vo;

import knou.lms.common.vo.DefaultVO;

public class SbjctListVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String orgId;         // 기관아이디
    private String orgNm;         // 기관이름
    private String searchValue;   // 검색어

    private String sbjctMstrId;       // 과목아이디(SBJCT_MSTR_ID)
    private String sbjctNm;       // 과목명(SBJCTNM)
    private String sbjctEnNm;     // 과목영문명(SBJCT_ENNM)
    private String sbjctExpln;    // 과목설명(SBJCT_EXPLN)

    private String sbjctYr;       // 과목연도(SBJCT_YR)
    private String sbjctSmstr;    // 과목학기(SBJCT_SMSTR)
    private String sbjctGbnCd;    // 과목구분코드(SBJCT_GBNCD)
    private String sbjctTycd;     // 과목유형코드(SBJCT_TYCD)

    private String smstrChrtId;   // 학기기수아이디(SMSTR_CHRT_ID)
    private String deptId;        // 학과부서아이디(DEPT_ID)
    private String univId;        // 대학교아이디(UNIV_ID)

    private String useYn;         // 사용여부(USEYN)
    private String delYn;         // 삭제여부(DELYN)

    private String regDttm;       // 등록일시(REG_DTTM)
    private String mdfrId;        // 수정자아이디(MDFR_ID)
    private String modDttm;       // 수정일시(MOD_DTTM)

    @Override
    public String getOrgId() {
        return orgId;
    }

    @Override
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    @Override
    public String getOrgNm() {
        return orgNm;
    }

    @Override
    public String getSearchValue() {
        return searchValue;
    }

    @Override
    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }

    @Override
    public void setOrgNm(String orgNm) {
        this.orgNm = orgNm;
    }

    public String getSbjctMstrId() {
        return sbjctMstrId;
    }

    public void setSbjctMstrId(String sbjctMstrId) {
        this.sbjctMstrId = sbjctMstrId;
    }

    public String getSbjctNm() { return sbjctNm; }
    public void setSbjctNm(String sbjctNm) { this.sbjctNm = sbjctNm; }

    public String getSbjctEnNm() { return sbjctEnNm; }
    public void setSbjctEnNm(String sbjctEnNm) { this.sbjctEnNm = sbjctEnNm; }

    public String getSbjctExpln() { return sbjctExpln; }
    public void setSbjctExpln(String sbjctExpln) { this.sbjctExpln = sbjctExpln; }

    public String getSbjctYr() { return sbjctYr; }
    public void setSbjctYr(String sbjctYr) { this.sbjctYr = sbjctYr; }

    public String getSbjctSmstr() { return sbjctSmstr; }
    public void setSbjctSmstr(String sbjctSmstr) { this.sbjctSmstr = sbjctSmstr; }

    public String getSbjctGbnCd() { return sbjctGbnCd; }
    public void setSbjctGbnCd(String sbjctGbnCd) { this.sbjctGbnCd = sbjctGbnCd; }

    public String getSbjctTycd() {
        return sbjctTycd;
    }

    public void setSbjctTycd(String sbjctTycd) {
        this.sbjctTycd = sbjctTycd;
    }

    public String getSmstrChrtId() { return smstrChrtId; }
    public void setSmstrChrtId(String smstrChrtId) { this.smstrChrtId = smstrChrtId; }

    public String getDeptId() { return deptId; }
    public void setDeptId(String deptId) { this.deptId = deptId; }

    public String getUnivId() { return univId; }
    public void setUnivId(String univId) { this.univId = univId; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public String getDelYn() { return delYn; }
    public void setDelYn(String delYn) { this.delYn = delYn; }

    public String getRegDttm() { return regDttm; }
    public void setRegDttm(String regDttm) { this.regDttm = regDttm; }

    public String getMdfrId() { return mdfrId; }
    public void setMdfrId(String mdfrId) { this.mdfrId = mdfrId; }

    public String getModDttm() { return modDttm; }
    public void setModDttm(String modDttm) { this.modDttm = modDttm; }
}
