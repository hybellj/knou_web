package knou.lms.subject.vo;

import knou.lms.common.vo.DefaultVO;

import java.math.BigDecimal;

/**
 *
 * TB_LMS_SBJCT - 과목
 *
 */
public class SubjectVO extends DefaultVO {

    private static final long serialVersionUID = -1164386279694378535L;

    private String subjectId;
    private String profId;
    private String sbjctRefTycd;
    private String crsMstrId;
    private String smstrChrtId;
    private String sbjctGbncd;
    private String sbjctTycd;
    private String eduMthdTycd;
    private String rgLryn;
    private Integer crclmnNo;
    private String sbjctnm;
    private String sbjctExpln;
    private String sbjctEnnm;
    private String sbjctYr;
    private String sbjctSmstr;
    private BigDecimal crdts;
    private String rvwPsblGbncd;
    private String rvwSdttm;
    private String rvwEdttm;
    private String dvclasGrpcd;
    private Integer dvclasNo;
    private String dvclasNcknm;
    private Integer wholWkCnt;
    private String deptId;
    private String deptnm;
    private String cmcrsGbncd;
    private String cmcrsGbnnm;
    private String lrnCntrlGbncd;
    private String fnshProcMthdCd;
    private BigDecimal fnshScr;
    private BigDecimal fnshScrDelrt;
    private BigDecimal etcDelrt;
    private BigDecimal atndcDelrt;
    private BigDecimal asmtDelrt;
    private BigDecimal dscsDelrt;
    private BigDecimal examDelrt;
    private BigDecimal teamActvDelrt;
    private String lctrSdttm;
    private String lctrEdttm;
    private String atndlcCertProcMthdCd;
    private Integer atndlcQuota;
    private String atndlcCertStscd;
    private String atndlcAplySdttm;
    private String atndlcAplyEdttm;
    private String atndlcSdttm;
    private String atndlcEdttm;
    private String auditSdttm;
    private String auditEdttm;
    private String mrkProcSdttm;
    private String mrkProcEdttm;
    private String mrkEvlGbncd;
    private String mrkEvlGbnnm;
    private String mrkInqSrvyId;
    private String useyn;
    private String delyn;
    private String scrEvlGbncd;
    private String kywd;
    private String lctrFrmtGbncd;

    private int atndlcStdntCnt = 0;

    public String getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(String subjectId) {
        this.subjectId = subjectId;
    }

    public String getProfId() {
        return profId;
    }

    public void setProfId(String profId) {
        this.profId = profId;
    }

    public String getSbjctRefTycd() {
        return sbjctRefTycd;
    }

    public void setSbjctRefTycd(String sbjctRefTycd) {
        this.sbjctRefTycd = sbjctRefTycd;
    }

    public String getCrsMstrId() {
        return crsMstrId;
    }

    public void setCrsMstrId(String crsMstrId) {
        this.crsMstrId = crsMstrId;
    }

    public String getSmstrChrtId() {
        return smstrChrtId;
    }

    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
    }

    public String getSbjctGbncd() {
        return sbjctGbncd;
    }

    public void setSbjctGbncd(String sbjctGbncd) {
        this.sbjctGbncd = sbjctGbncd;
    }

    public String getSbjctTycd() {
        return sbjctTycd;
    }

    public void setSbjctTycd(String sbjctTycd) {
        this.sbjctTycd = sbjctTycd;
    }

    public String getEduMthdTycd() {
        return eduMthdTycd;
    }

    public void setEduMthdTycd(String eduMthdTycd) {
        this.eduMthdTycd = eduMthdTycd;
    }

    public String getRgLryn() {
        return rgLryn;
    }

    public void setRgLryn(String rgLryn) {
        this.rgLryn = rgLryn;
    }

    public Integer getCrclmnNo() {
        return crclmnNo;
    }

    public void setCrclmnNo(Integer crclmnNo) {
        this.crclmnNo = crclmnNo;
    }

    public String getSbjctnm() {
        return sbjctnm;
    }

    public void setSbjctnm(String sbjctnm) {
        this.sbjctnm = sbjctnm;
    }

    public String getSbjctExpln() {
        return sbjctExpln;
    }

    public void setSbjctExpln(String sbjctExpln) {
        this.sbjctExpln = sbjctExpln;
    }

    public String getSbjctEnnm() {
        return sbjctEnnm;
    }

    public void setSbjctEnnm(String sbjctEnnm) {
        this.sbjctEnnm = sbjctEnnm;
    }

    public String getSbjctYr() {
        return sbjctYr;
    }

    public void setSbjctYr(String sbjctYr) {
        this.sbjctYr = sbjctYr;
    }

    public String getSbjctSmstr() {
        return sbjctSmstr;
    }

    public void setSbjctSmstr(String sbjctSmstr) {
        this.sbjctSmstr = sbjctSmstr;
    }

    public BigDecimal getCrdts() {
        return crdts;
    }

    public void setCrdts(BigDecimal crdts) {
        this.crdts = crdts;
    }

    public String getRvwPsblGbncd() {
        return rvwPsblGbncd;
    }

    public void setRvwPsblGbncd(String rvwPsblGbncd) {
        this.rvwPsblGbncd = rvwPsblGbncd;
    }

    public String getRvwSdttm() {
        return rvwSdttm;
    }

    public void setRvwSdttm(String rvwSdttm) {
        this.rvwSdttm = rvwSdttm;
    }

    public String getRvwEdttm() {
        return rvwEdttm;
    }

    public void setRvwEdttm(String rvwEdttm) {
        this.rvwEdttm = rvwEdttm;
    }

    public String getDvclasGrpcd() {
        return dvclasGrpcd;
    }

    public void setDvclasGrpcd(String dvclasGrpcd) {
        this.dvclasGrpcd = dvclasGrpcd;
    }

    public Integer getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(Integer dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public String getDvclasNcknm() {
        return dvclasNcknm;
    }

    public void setDvclasNcknm(String dvclasNcknm) {
        this.dvclasNcknm = dvclasNcknm;
    }

    public Integer getWholWkCnt() {
        return wholWkCnt;
    }

    public void setWholWkCnt(Integer wholWkCnt) {
        this.wholWkCnt = wholWkCnt;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getCmcrsGbncd() {
        return cmcrsGbncd;
    }

    public void setCmcrsGbncd(String cmcrsGbncd) {
        this.cmcrsGbncd = cmcrsGbncd;
    }

    public String getCmcrsGbnnm() {
        return cmcrsGbnnm;
    }

    public void setCmcrsGbnnm(String cmcrsGbnnm) {
        this.cmcrsGbnnm = cmcrsGbnnm;
    }

    public String getLrnCntrlGbncd() {
        return lrnCntrlGbncd;
    }

    public void setLrnCntrlGbncd(String lrnCntrlGbncd) {
        this.lrnCntrlGbncd = lrnCntrlGbncd;
    }

    public String getFnshProcMthdCd() {
        return fnshProcMthdCd;
    }

    public void setFnshProcMthdCd(String fnshProcMthdCd) {
        this.fnshProcMthdCd = fnshProcMthdCd;
    }

    public BigDecimal getFnshScr() {
        return fnshScr;
    }

    public void setFnshScr(BigDecimal fnshScr) {
        this.fnshScr = fnshScr;
    }

    public BigDecimal getFnshScrDelrt() {
        return fnshScrDelrt;
    }

    public void setFnshScrDelrt(BigDecimal fnshScrDelrt) {
        this.fnshScrDelrt = fnshScrDelrt;
    }

    public BigDecimal getEtcDelrt() {
        return etcDelrt;
    }

    public void setEtcDelrt(BigDecimal etcDelrt) {
        this.etcDelrt = etcDelrt;
    }

    public BigDecimal getAtndcDelrt() {
        return atndcDelrt;
    }

    public void setAtndcDelrt(BigDecimal atndcDelrt) {
        this.atndcDelrt = atndcDelrt;
    }

    public BigDecimal getAsmtDelrt() {
        return asmtDelrt;
    }

    public void setAsmtDelrt(BigDecimal asmtDelrt) {
        this.asmtDelrt = asmtDelrt;
    }

    public BigDecimal getDscsDelrt() {
        return dscsDelrt;
    }

    public void setDscsDelrt(BigDecimal dscsDelrt) {
        this.dscsDelrt = dscsDelrt;
    }

    public BigDecimal getExamDelrt() {
        return examDelrt;
    }

    public void setExamDelrt(BigDecimal examDelrt) {
        this.examDelrt = examDelrt;
    }

    public BigDecimal getTeamActvDelrt() {
        return teamActvDelrt;
    }

    public void setTeamActvDelrt(BigDecimal teamActvDelrt) {
        this.teamActvDelrt = teamActvDelrt;
    }

    public String getLctrSdttm() {
        return lctrSdttm;
    }

    public void setLctrSdttm(String lctrSdttm) {
        this.lctrSdttm = lctrSdttm;
    }

    public String getLctrEdttm() {
        return lctrEdttm;
    }

    public void setLctrEdttm(String lctrEdttm) {
        this.lctrEdttm = lctrEdttm;
    }

    public String getAtndlcCertProcMthdCd() {
        return atndlcCertProcMthdCd;
    }

    public void setAtndlcCertProcMthdCd(String atndlcCertProcMthdCd) {
        this.atndlcCertProcMthdCd = atndlcCertProcMthdCd;
    }

    public Integer getAtndlcQuota() {
        return atndlcQuota;
    }

    public void setAtndlcQuota(Integer atndlcQuota) {
        this.atndlcQuota = atndlcQuota;
    }

    public String getAtndlcCertStscd() {
        return atndlcCertStscd;
    }

    public void setAtndlcCertStscd(String atndlcCertStscd) {
        this.atndlcCertStscd = atndlcCertStscd;
    }

    public String getAtndlcAplySdttm() {
        return atndlcAplySdttm;
    }

    public void setAtndlcAplySdttm(String atndlcAplySdttm) {
        this.atndlcAplySdttm = atndlcAplySdttm;
    }

    public String getAtndlcAplyEdttm() {
        return atndlcAplyEdttm;
    }

    public void setAtndlcAplyEdttm(String atndlcAplyEdttm) {
        this.atndlcAplyEdttm = atndlcAplyEdttm;
    }

    public String getAtndlcSdttm() {
        return atndlcSdttm;
    }

    public void setAtndlcSdttm(String atndlcSdttm) {
        this.atndlcSdttm = atndlcSdttm;
    }

    public String getAtndlcEdttm() {
        return atndlcEdttm;
    }

    public void setAtndlcEdttm(String atndlcEdttm) {
        this.atndlcEdttm = atndlcEdttm;
    }

    public String getAuditSdttm() {
        return auditSdttm;
    }

    public void setAuditSdttm(String auditSdttm) {
        this.auditSdttm = auditSdttm;
    }

    public String getAuditEdttm() {
        return auditEdttm;
    }

    public void setAuditEdttm(String auditEdttm) {
        this.auditEdttm = auditEdttm;
    }

    public String getMrkProcSdttm() {
        return mrkProcSdttm;
    }

    public void setMrkProcSdttm(String mrkProcSdttm) {
        this.mrkProcSdttm = mrkProcSdttm;
    }

    public String getMrkProcEdttm() {
        return mrkProcEdttm;
    }

    public void setMrkProcEdttm(String mrkProcEdttm) {
        this.mrkProcEdttm = mrkProcEdttm;
    }

    public String getMrkEvlGbncd() {
        return mrkEvlGbncd;
    }

    public void setMrkEvlGbncd(String mrkEvlGbncd) {
        this.mrkEvlGbncd = mrkEvlGbncd;
    }

    public String getMrkInqSrvyId() {
        return mrkInqSrvyId;
    }

    public void setMrkInqSrvyId(String mrkInqSrvyId) {
        this.mrkInqSrvyId = mrkInqSrvyId;
    }

    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
    }

    public String getDelyn() {
        return delyn;
    }

    public void setDelyn(String delyn) {
        this.delyn = delyn;
    }

    public String getScrEvlGbncd() {
        return scrEvlGbncd;
    }

    public void setScrEvlGbncd(String scrEvlGbncd) {
        this.scrEvlGbncd = scrEvlGbncd;
    }

    public String getKywd() {
        return kywd;
    }

    public void setKywd(String kywd) {
        this.kywd = kywd;
    }

    public String getLctrFrmtGbncd() {
        return lctrFrmtGbncd;
    }

    public void setLctrFrmtGbncd(String lctrFrmtGbncd) {
        this.lctrFrmtGbncd = lctrFrmtGbncd;
    }

    public void setAtndlcStdntCnt(int atndlcStdntCnt) {
        this.atndlcStdntCnt = atndlcStdntCnt;
    }

    public int getAtndlcStdntCnt() {
        return atndlcStdntCnt;
    }

    public String getMrkEvlGbnnm() {
        return mrkEvlGbnnm;
    }

    public void setMrkEvlGbnnm(String mrkEvlGbnnm) {
        this.mrkEvlGbnnm = mrkEvlGbnnm;
    }

    public String getDeptnm() {
        return deptnm;
    }

    public void setDeptnm(String deptnm) {
        this.deptnm = deptnm;
    }
}
