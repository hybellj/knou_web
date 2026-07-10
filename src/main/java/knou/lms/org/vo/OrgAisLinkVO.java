package knou.lms.org.vo;

import java.util.List;

// TB_LMS_AIS_LINK (학사정보시스템 연동)
public class OrgAisLinkVO {

    private String aisLinkId;   // 학사정보시스템연동 아이디
    private String orgId;       // 기관아이디

    private String autoLinkyn;  // 자동연동여부
    private String aisLinkTycd; // 학사정보시스템연동 유형코드
    private String aisLinkTynm; // 유형코드명
    private String useyn;       // 사용여부
    private String manlUrl;     // 수동URL

    private String rgtrId;      // 등록자 아이디
    private String regDttm;     // 등록일시
    private String mdfrId;      // 수정자 아이디
    private String modDttm;     // 수정일시

    private List<OrgAisLinkVO> stngList;

    public OrgAisLinkVO() {
    }

    public String getAisLinkId() {
        return aisLinkId;
    }

    public void setAisLinkId(String aisLinkId) {
        this.aisLinkId = aisLinkId;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getAutoLinkyn() {
        return autoLinkyn;
    }

    public void setAutoLinkyn(String autoLinkyn) {
        this.autoLinkyn = autoLinkyn;
    }

    public String getAisLinkTycd() {
        return aisLinkTycd;
    }

    public void setAisLinkTycd(String aisLinkTycd) {
        this.aisLinkTycd = aisLinkTycd;
    }

    public String getAisLinkTynm() {
        return aisLinkTynm;
    }

    public void setAisLinkTynm(String aisLinkTynm) {
        this.aisLinkTynm = aisLinkTynm;
    }

    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
    }

    public String getManlUrl() {
        return manlUrl;
    }

    public void setManlUrl(String manlUrl) {
        this.manlUrl = manlUrl;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getRegDttm() {
        return regDttm;
    }

    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getModDttm() {
        return modDttm;
    }

    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

    public List<OrgAisLinkVO> getStngList() {
        return stngList;
    }

    public void setStngList(List<OrgAisLinkVO> stngList) {
        this.stngList = stngList;
    }
}
