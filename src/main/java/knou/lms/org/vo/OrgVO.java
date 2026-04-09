package knou.lms.org.vo;

import java.io.Serializable;

/**
 * 기관(Organization) 정보 VO
 * 테이블: TB_LMS_ORG
 */
public class OrgVO implements Serializable {

    private static final long serialVersionUID = 1L;

    // --- 필드 선언 (Private Encapsulation) ---
    private String orgId;           // ORG_ID (기관 ID)
    private String orgRegNo;        // ORG_REG_NO (사업자등록번호)
    private String orgnm;           // ORGNM (기관명)
    private String orgShrtnm;       // ORG_SHRTNM (기관 약칭)
    private String orgNcnm;         // ORG_NCNM (기관 별칭)
    private String orgTycd;         // ORG_TYCD (기관 유형코드)
    private String zipCd;           // ZIP_CD (우편번호)
    private String addr1;           // ADDR1 (주소1)
    private String addr2;           // ADDR2 (주소2)
    private String dmnnm;           // DMNNM (도메인명)
    private String sdttm;           // SDTTM (서비스 시작일시)
    private String edttm;           // EDTTM (서비스 종료일시)
    private String useyn;           // USEYN (사용여부)
    private String bscLangCd;       // BSC_LANG_CD (기본언어코드)
    private String ofcTelno;        // OFC_TELNO (사무실전화번호)
    private String rprsTelno;       // RPRS_TELNO (대표전화번호)
    private String chrgrnm;         // CHRGRNM (담당자명)
    private String chrgrCntct;      // CHRGR_CNTCT (담당자연락처)
    private String chrgrEml;        // CHRGR_EML (담당자이메일)
    private String mltLgnyn;        // MLT_LGNYN (중복로그인여부)
    private String pswdChgUseyn;    // PSWD_CHG_USEYN (비밀번호변경사용여부)
    private int pswdUseDayCnt;      // PSWD_USE_DAY_CNT (비밀번호사용일수)
    private String mbridTycd;       // MBRID_TYCD (회원ID유형코드)
    private String joinUseyn;       // JOIN_USEYN (회원가입사용여부)
    private String siteUsgCd;       // SITE_USG_CD (사이트용도코드)
    private String cpghtCts;        // CPRGHT_CTS (카피라이트문구)
    private String hmpgUrl;         // HMPG_URL (홈페이지URL)
    private String rgtrId;          // RGTR_ID (등록자ID)
    private String regDttm;         // REG_DTTM (등록일시)
    private String mdfrId;          // MDFR_ID (수정자ID)
    private String modDttm;         // MOD_DTTM (수정일시)

    // --- 생성자 (Constructor) ---
    public OrgVO() {}

    // --- Getter & Setter Methods ---

    public String getOrgId() { return orgId; }
    public void setOrgId(String orgId) { this.orgId = orgId; }

    public String getOrgRegNo() { return orgRegNo; }
    public void setOrgRegNo(String orgRegNo) { this.orgRegNo = orgRegNo; }

    public String getOrgnm() { return orgnm; }
    public void setOrgnm(String orgnm) { this.orgnm = orgnm; }

    public String getOrgShrtnm() { return orgShrtnm; }
    public void setOrgShrtnm(String orgShrtnm) { this.orgShrtnm = orgShrtnm; }

    public String getOrgNcnm() { return orgNcnm; }
    public void setOrgNcnm(String orgNcnm) { this.orgNcnm = orgNcnm; }

    public String getOrgTycd() { return orgTycd; }
    public void setOrgTycd(String orgTycd) { this.orgTycd = orgTycd; }

    public String getZipCd() { return zipCd; }
    public void setZipCd(String zipCd) { this.zipCd = zipCd; }

    public String getAddr1() { return addr1; }
    public void setAddr1(String addr1) { this.addr1 = addr1; }

    public String getAddr2() { return addr2; }
    public void setAddr2(String addr2) { this.addr2 = addr2; }

    public String getDmnnm() { return dmnnm; }
    public void setDmnnm(String dmnnm) { this.dmnnm = dmnnm; }

    public String getSdttm() { return sdttm; }
    public void setSdttm(String sdttm) { this.sdttm = sdttm; }

    public String getEdttm() { return edttm; }
    public void setEdttm(String edttm) { this.edttm = edttm; }

    public String getUseyn() { return useyn; }
    public void setUseyn(String useyn) { this.useyn = useyn; }

    public String getBscLangCd() { return bscLangCd; }
    public void setBscLangCd(String bscLangCd) { this.bscLangCd = bscLangCd; }

    public String getOfcTelno() { return ofcTelno; }
    public void setOfcTelno(String ofcTelno) { this.ofcTelno = ofcTelno; }

    public String getRprsTelno() { return rprsTelno; }
    public void setRprsTelno(String rprsTelno) { this.rprsTelno = rprsTelno; }

    public String getChrgrnm() { return chrgrnm; }
    public void setChrgrnm(String chrgrnm) { this.chrgrnm = chrgrnm; }

    public String getChrgrCntct() { return chrgrCntct; }
    public void setChrgrCntct(String chrgrCntct) { this.chrgrCntct = chrgrCntct; }

    public String getChrgrEml() { return chrgrEml; }
    public void setChrgrEml(String chrgrEml) { this.chrgrEml = chrgrEml; }

    public String getMltLgnyn() { return mltLgnyn; }
    public void setMltLgnyn(String mltLgnyn) { this.mltLgnyn = mltLgnyn; }

    public String getPswdChgUseyn() { return pswdChgUseyn; }
    public void setPswdChgUseyn(String pswdChgUseyn) { this.pswdChgUseyn = pswdChgUseyn; }

    public int getPswdUseDayCnt() { return pswdUseDayCnt; }
    public void setPswdUseDayCnt(int pswdUseDayCnt) { this.pswdUseDayCnt = pswdUseDayCnt; }

    public String getMbridTycd() { return mbridTycd; }
    public void setMbridTycd(String mbridTycd) { this.mbridTycd = mbridTycd; }

    public String getJoinUseyn() { return joinUseyn; }
    public void setJoinUseyn(String joinUseyn) { this.joinUseyn = joinUseyn; }

    public String getSiteUsgCd() { return siteUsgCd; }
    public void setSiteUsgCd(String siteUsgCd) { this.siteUsgCd = siteUsgCd; }

    public String getCpghtCts() { return cpghtCts; }
    public void setCpghtCts(String cpghtCts) { this.cpghtCts = cpghtCts; }

    public String getHmpgUrl() { return hmpgUrl; }
    public void setHmpgUrl(String hmpgUrl) { this.hmpgUrl = hmpgUrl; }

    public String getRgtrId() { return rgtrId; }
    public void setRgtrId(String rgtrId) { this.rgtrId = rgtrId; }

    public String getRegDttm() { return regDttm; }
    public void setRegDttm(String regDttm) { this.regDttm = regDttm; }

    public String getMdfrId() { return mdfrId; }
    public void setMdfrId(String mdfrId) { this.mdfrId = mdfrId; }

    public String getModDttm() { return modDttm; }
    public void setModDttm(String modDttm) { this.modDttm = modDttm; }

    // --- toString Override (디버깅용) ---
    @Override
    public String toString() {
        return "OrgVO [orgId=" + orgId + ", orgnm=" + orgnm + ", dmnnm=" + dmnnm + 
               ", useyn=" + useyn + ", siteUsgCd=" + siteUsgCd + "]";
    }
}