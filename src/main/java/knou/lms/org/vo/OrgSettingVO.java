package knou.lms.org.vo;

import java.util.List;

// TB_LMS_ORG_STNG
public class OrgSettingVO {

    private String orgStngId;   // 기관설정아이디
    private String orgId;       // 기관아이디
    private String stngCtgrCd;  // 설정 분류코드
    private String stngCd;      // 설정코드
    private String stngnm;      // 설정명
    private String stngVl;      // 설정값
    private String stngExpln;   // 설정 설명
    private String useyn;       // 사용여부
    private String rgtrId;      // 등록자 아이디
    private String regDttm;     // 등록일시
    private String mdfrId;      // 수정자 아이디
    private String modDttm;     // 수정일시

    private List<OrgSettingVO> stngList;
    private String stngListStr;

    public OrgSettingVO() {
    }

    public OrgSettingVO(String orgStngId, String orgId, String stngCtgrCd, String stngCd, String stngnm, String stngVl, String stngExpln, String useyn) {
        this.orgStngId = orgStngId;
        this.orgId = orgId;
        this.stngCtgrCd = stngCtgrCd;
        this.stngCd = stngCd;
        this.stngnm = stngnm;
        this.stngVl = stngVl;
        this.stngExpln = stngExpln;
        this.useyn = useyn;
    }

    public String getOrgStngId() {
        return orgStngId;
    }

    public void setOrgStngId(String orgStngId) {
        this.orgStngId = orgStngId;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getStngCtgrCd() {
        return stngCtgrCd;
    }

    public void setStngCtgrCd(String stngCtgrCd) {
        this.stngCtgrCd = stngCtgrCd;
    }

    public String getStngCd() {
        return stngCd;
    }

    public void setStngCd(String stngCd) {
        this.stngCd = stngCd;
    }

    public String getStngnm() {
        return stngnm;
    }

    public void setStngnm(String stngnm) {
        this.stngnm = stngnm;
    }

    public String getStngVl() {
        return stngVl;
    }

    public void setStngVl(String stngVl) {
        this.stngVl = stngVl;
    }

    public String getStngExpln() {
        return stngExpln;
    }

    public void setStngExpln(String stngExpln) {
        this.stngExpln = stngExpln;
    }

    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
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

    public List<OrgSettingVO> getStngList() {
        return stngList;
    }

    public void setStngList(List<OrgSettingVO> stngList) {
        this.stngList = stngList;
    }

    public String getStngListStr() {
        return stngListStr;
    }

    public void setStngListStr(String stngListStr) {
        this.stngListStr = stngListStr;
    }
}
