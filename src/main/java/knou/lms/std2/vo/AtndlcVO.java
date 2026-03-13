package knou.lms.std2.vo;

import knou.lms.common.vo.DefaultVO;

public class AtndlcVO extends DefaultVO {

    private String atndlcId;        // 수강아이디
    private String rptyn;           // 재수강여부
    private String atndlcAplyDttm;  // 수강신청일시
    private String atndlcCnclDttm;  // 수강취소일시
    private String atndlcCertDttm;  // 수강인증일시
    private String atndlcFnshDttm;  // 수강수료일시
    private String fnshNo;          // 수료번호
    private Integer acqsCrdts;      // 취득학점
    private Integer scyr;           // 학년
    private String cmcrsGbncd;      // 이수구분코드
    private String dgrsCrsGbncd;    // 학위과정구분코드
    private String audityn;         // 청강여부
    private String atndlcStscd;     // 수강상태코드

    public String getAtndlcId() {
        return atndlcId;
    }

    public void setAtndlcId(String atndlcId) {
        this.atndlcId = atndlcId;
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

    public String getAtndlcStscd() {
        return atndlcStscd;
    }

    public void setAtndlcStscd(String atndlcStscd) {
        this.atndlcStscd = atndlcStscd;
    }
}
