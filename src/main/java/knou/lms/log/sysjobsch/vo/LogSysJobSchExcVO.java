package knou.lms.log.sysjobsch.vo;

import knou.lms.common.vo.DefaultVO;

public class LogSysJobSchExcVO extends DefaultVO {

    private static final long serialVersionUID = 4766945674595347831L;

    private String  excLogSn;
    private String  excLogCts;
    
    private String  creYear;
    private String  creTerm;
    private String  uniCd;
    private String  univGbn;
    private String  mngtDeptCd;
    private String  deptNm;
    private String  crsCd;
    private String  declsNo;
    private String  tchNo;
    private String  tchNm;
    
    public String getExcLogSn() {
        return excLogSn;
    }
    public void setExcLogSn(String excLogSn) {
        this.excLogSn = excLogSn;
    }
    public String getExcLogCts() {
        return excLogCts;
    }
    public void setExcLogCts(String excLogCts) {
        this.excLogCts = excLogCts;
    }
    public String getCreYear() {
        return creYear;
    }
    public void setCreYear(String creYear) {
        this.creYear = creYear;
    }
    public String getCreTerm() {
        return creTerm;
    }
    public void setCreTerm(String creTerm) {
        this.creTerm = creTerm;
    }
    public String getUniCd() {
        return uniCd;
    }
    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }
    public String getMngtDeptCd() {
        return mngtDeptCd;
    }
    public void setMngtDeptCd(String mngtDeptCd) {
        this.mngtDeptCd = mngtDeptCd;
    }
    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
    public String getCrsCd() {
        return crsCd;
    }
    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }
    public String getDeclsNo() {
        return declsNo;
    }
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }
    public String getTchNo() {
        return tchNo;
    }
    public void setTchNo(String tchNo) {
        this.tchNo = tchNo;
    }
    public String getTchNm() {
        return tchNm;
    }
    public void setTchNm(String tchNm) {
        this.tchNm = tchNm;
    }
    public String getUnivGbn() {
        return univGbn;
    }
    public void setUnivGbn(String univGbn) {
        this.univGbn = univGbn;
    }
    
}
