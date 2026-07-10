package knou.lms.org.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 기관 템플릿 정보 VO
 * TB_LMS_ORG_TMPLT
 */
public class OrgTemplateVO extends DefaultVO {

    private String orgTmpltId;      // 기관 템플릿 아이디
//    private String orgId;           // 기관 아이디

//    private String langCd;          // 언어코드
    private String tmpltnm;         // 템플릿명
    private String prodCd;          // 상품코드

    private String logoFileId;      // 로고파일아이디
    private String dsgnColrTycd;    // 디자인컬러설정
    private String colrTmpltCd;     // 색상템플릿코드

    private String topLogoFileId;   // TOP 로고 파일아이디
    private String sbstLogo1FileId; // 대체로고1 파일아이디
    private String sbstLogo1Url;    // 대체로고1 URL
    private String sbstLogo2FileId; // 대체로고2 파일아이디
    private String sbstLogo2Url;    // 대체로고2 URL

    private String hmpgFtr;         // 홈페이지 FOOTER
    private String ftr;             // FOOTER
    private String menuVrsn;        // 메뉴버전

    private String useyn;           // 사용여부

//    private String rgtrId;          // RGTR_ID (등록자ID)
//    private String regDttm;         // REG_DTTM (등록일시)
//    private String mdfrId;          // MDFR_ID (수정자ID)
//    private String modDttm;         // MOD_DTTM (수정일시)


    public OrgTemplateVO() {
    }

//    public OrgTemplateVO(String orgId) {
//        this.orgId = orgId;
//    }

    public String getOrgTmpltId() {
        return orgTmpltId;
    }

    public void setOrgTmpltId(String orgTmpltId) {
        this.orgTmpltId = orgTmpltId;
    }

//    public String getOrgId() {
//        return orgId;
//    }

//    public void setOrgId(String orgId) {
//        this.orgId = orgId;
//    }

//    public String getLangCd() {
//        return langCd;
//    }

//    public void setLangCd(String langCd) {
//        this.langCd = langCd;
//    }

    public String getTmpltnm() {
        return tmpltnm;
    }

    public void setTmpltnm(String tmpltnm) {
        this.tmpltnm = tmpltnm;
    }

    public String getProdCd() {
        return prodCd;
    }

    public void setProdCd(String prodCd) {
        this.prodCd = prodCd;
    }

    public String getLogoFileId() {
        return logoFileId;
    }

    public void setLogoFileId(String logoFileId) {
        this.logoFileId = logoFileId;
    }

    public String getDsgnColrTycd() {
        return dsgnColrTycd;
    }

    public void setDsgnColrTycd(String dsgnColrTycd) {
        this.dsgnColrTycd = dsgnColrTycd;
    }

    public String getColrTmpltCd() {
        return colrTmpltCd;
    }

    public void setColrTmpltCd(String colrTmpltCd) {
        this.colrTmpltCd = colrTmpltCd;
    }

    public String getTopLogoFileId() {
        return topLogoFileId;
    }

    public void setTopLogoFileId(String topLogoFileId) {
        this.topLogoFileId = topLogoFileId;
    }

    public String getSbstLogo1FileId() {
        return sbstLogo1FileId;
    }

    public void setSbstLogo1FileId(String sbstLogo1FileId) {
        this.sbstLogo1FileId = sbstLogo1FileId;
    }

    public String getSbstLogo1Url() {
        return sbstLogo1Url;
    }

    public void setSbstLogo1Url(String sbstLogo1Url) {
        this.sbstLogo1Url = sbstLogo1Url;
    }

    public String getSbstLogo2FileId() {
        return sbstLogo2FileId;
    }

    public void setSbstLogo2FileId(String sbstLogo2FileId) {
        this.sbstLogo2FileId = sbstLogo2FileId;
    }

    public String getSbstLogo2Url() {
        return sbstLogo2Url;
    }

    public void setSbstLogo2Url(String sbstLogo2Url) {
        this.sbstLogo2Url = sbstLogo2Url;
    }

    public String getHmpgFtr() {
        return hmpgFtr;
    }

    public void setHmpgFtr(String hmpgFtr) {
        this.hmpgFtr = hmpgFtr;
    }

    public String getFtr() {
        return ftr;
    }

    public void setFtr(String ftr) {
        this.ftr = ftr;
    }

    public String getMenuVrsn() {
        return menuVrsn;
    }

    public void setMenuVrsn(String menuVrsn) {
        this.menuVrsn = menuVrsn;
    }

    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
    }

//    public String getRgtrId() {
//        return rgtrId;
//    }
//
//    public void setRgtrId(String rgtrId) {
//        this.rgtrId = rgtrId;
//    }
//
//    public String getRegDttm() {
//        return regDttm;
//    }
//
//    public void setRegDttm(String regDttm) {
//        this.regDttm = regDttm;
//    }
//
//    public String getMdfrId() {
//        return mdfrId;
//    }
//
//    public void setMdfrId(String mdfrId) {
//        this.mdfrId = mdfrId;
//    }
//
//    public String getModDttm() {
//        return modDttm;
//    }
//
//    public void setModDttm(String modDttm) {
//        this.modDttm = modDttm;
//    }
}
