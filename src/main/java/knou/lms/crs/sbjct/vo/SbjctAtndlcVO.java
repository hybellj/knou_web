package knou.lms.crs.sbjct.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class SbjctAtndlcVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String atndlcId; // 수강아이디
    private String sbjctId; // 과목아이디
    private String userId; // 사용자아이디
    private String rptyn; // 재수강여부
    private String atndlcAplyDttm; // 수강신청일시
    private String atndlcCnclDttm; // 수강취소일시
    private String atndlcCertDttm; // 수강인증일시
    private String atndlcFnshDttm; // 수강수료일시
    private String fnshNo; // 수료번호
    private Integer acqsCrdts; // 취득학점
    private Integer scyr; // 학년
    private String cmcrsGbncd; // 이수구분코드
    private String dgrsCrsGbncd; // 학위과정구분코드
    private String audityn; // 청강여부
    private String rgtrId; // 등록자아이디
    private String regDttm; // 등록일시
    private String mdfrId; // 수정자아이디
    private String modDttm; // 수정일시
    private String atndlcStscd; // 수강상태코드

    /* DB와 관계없는 파라미터 */
    private String orgId; // 기관아이디
    private String orgnm; // 기관명
    private String deptId; // 학과부서아이디
    private String deptnm; // 학과명
    private String usernm; // 사용자명
    private String stdntNo; // 학번
    private String mblPhn; // 휴대전화번호
    private String eml; // 이메일
    private String langCd; // 언어코드
    private List<SbjctAtndlcVO> atndlcList; // 수강생목록

    public String getAtndlcId() {
        return atndlcId;
    }

    public void setAtndlcId(String atndlcId) {
        this.atndlcId = atndlcId;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getRptyn() {
        return rptyn;
    }

    public void setRptyn(String rptyn) {
        this.rptyn = rptyn;
    }

    public String getAtndlcAplyDttm() {
        return atndlcAplyDttm;
    }

    public void setAtndlcAplyDttm(String atndlcAplyDttm) {
        this.atndlcAplyDttm = atndlcAplyDttm;
    }

    public String getAtndlcCnclDttm() {
        return atndlcCnclDttm;
    }

    public void setAtndlcCnclDttm(String atndlcCnclDttm) {
        this.atndlcCnclDttm = atndlcCnclDttm;
    }

    public String getAtndlcCertDttm() {
        return atndlcCertDttm;
    }

    public void setAtndlcCertDttm(String atndlcCertDttm) {
        this.atndlcCertDttm = atndlcCertDttm;
    }

    public String getAtndlcFnshDttm() {
        return atndlcFnshDttm;
    }

    public void setAtndlcFnshDttm(String atndlcFnshDttm) {
        this.atndlcFnshDttm = atndlcFnshDttm;
    }

    public String getFnshNo() {
        return fnshNo;
    }

    public void setFnshNo(String fnshNo) {
        this.fnshNo = fnshNo;
    }

    public Integer getAcqsCrdts() {
        return acqsCrdts;
    }

    public void setAcqsCrdts(Integer acqsCrdts) {
        this.acqsCrdts = acqsCrdts;
    }

    public Integer getScyr() {
        return scyr;
    }

    public void setScyr(Integer scyr) {
        this.scyr = scyr;
    }

    public String getCmcrsGbncd() {
        return cmcrsGbncd;
    }

    public void setCmcrsGbncd(String cmcrsGbncd) {
        this.cmcrsGbncd = cmcrsGbncd;
    }

    public String getDgrsCrsGbncd() {
        return dgrsCrsGbncd;
    }

    public void setDgrsCrsGbncd(String dgrsCrsGbncd) {
        this.dgrsCrsGbncd = dgrsCrsGbncd;
    }

    public String getAudityn() {
        return audityn;
    }

    public void setAudityn(String audityn) {
        this.audityn = audityn;
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

    public String getAtndlcStscd() {
        return atndlcStscd;
    }

    public void setAtndlcStscd(String atndlcStscd) {
        this.atndlcStscd = atndlcStscd;
    }

    @Override
    public String getOrgId() {
        return orgId;
    }

    @Override
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getOrgnm() {
        return orgnm;
    }

    public void setOrgnm(String orgnm) {
        this.orgnm = orgnm;
    }

    @Override
    public String getDeptId() {
        return deptId;
    }

    @Override
    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getDeptnm() {
        return deptnm;
    }

    public void setDeptnm(String deptnm) {
        this.deptnm = deptnm;
    }

    public String getUsernm() {
        return usernm;
    }

    public void setUsernm(String usernm) {
        this.usernm = usernm;
    }

    public String getStdntNo() {
        return stdntNo;
    }

    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }

    public String getMblPhn() {
        return mblPhn;
    }

    public void setMblPhn(String mblPhn) {
        this.mblPhn = mblPhn;
    }

    public String getEml() {
        return eml;
    }

    public void setEml(String eml) {
        this.eml = eml;
    }

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public List<SbjctAtndlcVO> getAtndlcList() {
        return atndlcList;
    }

    public void setAtndlcList(List<SbjctAtndlcVO> atndlcList) {
        this.atndlcList = atndlcList;
    }
}
