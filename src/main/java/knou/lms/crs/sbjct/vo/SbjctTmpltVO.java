package knou.lms.crs.sbjct.vo;

import java.math.BigDecimal;

import knou.lms.common.vo.DefaultVO;

public class SbjctTmpltVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String sbjctTmpltId; // 과목템플릿아이디
    private String sbjctRefTycd; // 과목참조유형코드
    private String rglryn; // 정규여부
    private String crsMstrId; // 과정마스터아이디
    private String smstrChrtId; // 학기기수아이디
    private String sbjctGbncd; // 과목구분코드
    private String crclmnNo; // 교과목번호
    private String sbjctnm; // 과목명
    private String sbjctExpln; // 과목설명
    private String sbjctEnnm; // 과목영문명
    private String sbjctYr; // 과목연도
    private String sbjctSmstr; // 과목학기
    private String sbjctTycd; // 과목유형코드
    private String eduMthdTycd; // 교육방법유형코드
    private Integer crdts; // 학점
    private String rvwPsblGbncd; // 복습가능구분코드
    private String rvwSdttm; // 복습시작일시
    private String rvwEdttm; // 복습종료일시
    private Integer dvclasNo; // 분반번호
    private Integer wholWkCnt; // 전체주차수
    private String cmcrsGbncd; // 이수구분코드
    private String cmcrsGbnnm; // 이수구분명
    private String lrnCntrlGbncd; // 학습제어구분코드
    private String fnshProcMthdCd; // 수료처리방법코드
    private Integer fnshScr; // 수료점수
    private BigDecimal fnshScrDelrt; // 수료점수삭제비율
    private BigDecimal etcDelrt; // 기타삭제비율
    private BigDecimal atndcDelrt; // 출석삭제비율
    private BigDecimal asmtDelrt; // 과제삭제비율
    private BigDecimal dscsDelrt; // 토론삭제비율
    private BigDecimal examDelrt; // 시험삭제비율
    private BigDecimal teamActvDelrt; // 팀활동삭제비율
    private String lctrSdttm; // 강의시작일시
    private String lctrEdttm; // 강의종료일시
    private String atndlcCertProcMthdCd; // 수강인증처리방법코드
    private Integer atndlcQuota; // 수강정원
    private String atndlcCertStscd; // 수강인증상태코드
    private String atndlcAplySdttm; // 수강신청시작일시
    private String atndlcAplyEdttm; // 수강신청종료일시
    private String atndlcSdttm; // 수강시작일시
    private String atndlcEdttm; // 수강종료일시
    private String auditSdttm; // 청강시작일시
    private String auditEdttm; // 청강종료일시
    private String mrkProcSdttm; // 성적처리시작일시
    private String mrkProcEdttm; // 성적처리종료일시
    private String mrkEvlGbncd; // 성적평가구분코드
    private String mrkInqSrvyId; // 성적조회설문아이디
    private String useyn; // 사용여부
    private String delyn; // 삭제여부
    private String univTycd; // 대학교유형코드
    private String univId; // 대학교아이디
    private String scrEvlGbncd; // 점수평가구분코드
    private String kywd; // 키워드
    private String lctrFrmtGbncd; // 강의형식구분코드
    private String lctrGbncd; // 강의구분코드
    private String sbjctCd; // 과목코드

    /* DB와 관계없는 파라미터 */
    private String checkType; // 중복체크유형

    public String getSbjctTmpltId() { return sbjctTmpltId; }
    public void setSbjctTmpltId(String sbjctTmpltId) { this.sbjctTmpltId = sbjctTmpltId; }

    public String getSbjctRefTycd() { return sbjctRefTycd; }
    public void setSbjctRefTycd(String sbjctRefTycd) { this.sbjctRefTycd = sbjctRefTycd; }

    public String getRglryn() { return rglryn; }
    public void setRglryn(String rglryn) { this.rglryn = rglryn; }

    public String getCrsMstrId() { return crsMstrId; }
    public void setCrsMstrId(String crsMstrId) { this.crsMstrId = crsMstrId; }

    public String getSmstrChrtId() { return smstrChrtId; }
    public void setSmstrChrtId(String smstrChrtId) { this.smstrChrtId = smstrChrtId; }

    public String getSbjctGbncd() { return sbjctGbncd; }
    public void setSbjctGbncd(String sbjctGbncd) { this.sbjctGbncd = sbjctGbncd; }

    public String getCrclmnNo() { return crclmnNo; }
    public void setCrclmnNo(String crclmnNo) { this.crclmnNo = crclmnNo; }

    @Override
    public String getSbjctnm() { return sbjctnm; }
    @Override
    public void setSbjctnm(String sbjctnm) { this.sbjctnm = sbjctnm; }

    public String getSbjctExpln() { return sbjctExpln; }
    public void setSbjctExpln(String sbjctExpln) { this.sbjctExpln = sbjctExpln; }

    public String getSbjctEnnm() { return sbjctEnnm; }
    public void setSbjctEnnm(String sbjctEnnm) { this.sbjctEnnm = sbjctEnnm; }

    public String getSbjctYr() { return sbjctYr; }
    public void setSbjctYr(String sbjctYr) { this.sbjctYr = sbjctYr; }

    public String getSbjctSmstr() { return sbjctSmstr; }
    public void setSbjctSmstr(String sbjctSmstr) { this.sbjctSmstr = sbjctSmstr; }

    public String getSbjctTycd() { return sbjctTycd; }
    public void setSbjctTycd(String sbjctTycd) { this.sbjctTycd = sbjctTycd; }

    public String getEduMthdTycd() { return eduMthdTycd; }
    public void setEduMthdTycd(String eduMthdTycd) { this.eduMthdTycd = eduMthdTycd; }

    public Integer getCrdts() { return crdts; }
    public void setCrdts(Integer crdts) { this.crdts = crdts; }

    public String getRvwPsblGbncd() { return rvwPsblGbncd; }
    public void setRvwPsblGbncd(String rvwPsblGbncd) { this.rvwPsblGbncd = rvwPsblGbncd; }

    public String getRvwSdttm() { return rvwSdttm; }
    public void setRvwSdttm(String rvwSdttm) { this.rvwSdttm = rvwSdttm; }

    public String getRvwEdttm() { return rvwEdttm; }
    public void setRvwEdttm(String rvwEdttm) { this.rvwEdttm = rvwEdttm; }

    public Integer getDvclasNo() { return dvclasNo; }
    public void setDvclasNo(Integer dvclasNo) { this.dvclasNo = dvclasNo; }

    public Integer getWholWkCnt() { return wholWkCnt; }
    public void setWholWkCnt(Integer wholWkCnt) { this.wholWkCnt = wholWkCnt; }

    public String getCmcrsGbncd() { return cmcrsGbncd; }
    public void setCmcrsGbncd(String cmcrsGbncd) { this.cmcrsGbncd = cmcrsGbncd; }

    public String getCmcrsGbnnm() { return cmcrsGbnnm; }
    public void setCmcrsGbnnm(String cmcrsGbnnm) { this.cmcrsGbnnm = cmcrsGbnnm; }

    public String getLrnCntrlGbncd() { return lrnCntrlGbncd; }
    public void setLrnCntrlGbncd(String lrnCntrlGbncd) { this.lrnCntrlGbncd = lrnCntrlGbncd; }

    public String getFnshProcMthdCd() { return fnshProcMthdCd; }
    public void setFnshProcMthdCd(String fnshProcMthdCd) { this.fnshProcMthdCd = fnshProcMthdCd; }

    public Integer getFnshScr() { return fnshScr; }
    public void setFnshScr(Integer fnshScr) { this.fnshScr = fnshScr; }

    public BigDecimal getFnshScrDelrt() { return fnshScrDelrt; }
    public void setFnshScrDelrt(BigDecimal fnshScrDelrt) { this.fnshScrDelrt = fnshScrDelrt; }

    public BigDecimal getEtcDelrt() { return etcDelrt; }
    public void setEtcDelrt(BigDecimal etcDelrt) { this.etcDelrt = etcDelrt; }

    public BigDecimal getAtndcDelrt() { return atndcDelrt; }
    public void setAtndcDelrt(BigDecimal atndcDelrt) { this.atndcDelrt = atndcDelrt; }

    public BigDecimal getAsmtDelrt() { return asmtDelrt; }
    public void setAsmtDelrt(BigDecimal asmtDelrt) { this.asmtDelrt = asmtDelrt; }

    public BigDecimal getDscsDelrt() { return dscsDelrt; }
    public void setDscsDelrt(BigDecimal dscsDelrt) { this.dscsDelrt = dscsDelrt; }

    public BigDecimal getExamDelrt() { return examDelrt; }
    public void setExamDelrt(BigDecimal examDelrt) { this.examDelrt = examDelrt; }

    public BigDecimal getTeamActvDelrt() { return teamActvDelrt; }
    public void setTeamActvDelrt(BigDecimal teamActvDelrt) { this.teamActvDelrt = teamActvDelrt; }

    public String getLctrSdttm() { return lctrSdttm; }
    public void setLctrSdttm(String lctrSdttm) { this.lctrSdttm = lctrSdttm; }

    public String getLctrEdttm() { return lctrEdttm; }
    public void setLctrEdttm(String lctrEdttm) { this.lctrEdttm = lctrEdttm; }

    public String getAtndlcCertProcMthdCd() { return atndlcCertProcMthdCd; }
    public void setAtndlcCertProcMthdCd(String atndlcCertProcMthdCd) { this.atndlcCertProcMthdCd = atndlcCertProcMthdCd; }

    public Integer getAtndlcQuota() { return atndlcQuota; }
    public void setAtndlcQuota(Integer atndlcQuota) { this.atndlcQuota = atndlcQuota; }

    public String getAtndlcCertStscd() { return atndlcCertStscd; }
    public void setAtndlcCertStscd(String atndlcCertStscd) { this.atndlcCertStscd = atndlcCertStscd; }

    public String getAtndlcAplySdttm() { return atndlcAplySdttm; }
    public void setAtndlcAplySdttm(String atndlcAplySdttm) { this.atndlcAplySdttm = atndlcAplySdttm; }

    public String getAtndlcAplyEdttm() { return atndlcAplyEdttm; }
    public void setAtndlcAplyEdttm(String atndlcAplyEdttm) { this.atndlcAplyEdttm = atndlcAplyEdttm; }

    public String getAtndlcSdttm() { return atndlcSdttm; }
    public void setAtndlcSdttm(String atndlcSdttm) { this.atndlcSdttm = atndlcSdttm; }

    public String getAtndlcEdttm() { return atndlcEdttm; }
    public void setAtndlcEdttm(String atndlcEdttm) { this.atndlcEdttm = atndlcEdttm; }

    public String getAuditSdttm() { return auditSdttm; }
    public void setAuditSdttm(String auditSdttm) { this.auditSdttm = auditSdttm; }

    public String getAuditEdttm() { return auditEdttm; }
    public void setAuditEdttm(String auditEdttm) { this.auditEdttm = auditEdttm; }

    public String getMrkProcSdttm() { return mrkProcSdttm; }
    public void setMrkProcSdttm(String mrkProcSdttm) { this.mrkProcSdttm = mrkProcSdttm; }

    public String getMrkProcEdttm() { return mrkProcEdttm; }
    public void setMrkProcEdttm(String mrkProcEdttm) { this.mrkProcEdttm = mrkProcEdttm; }

    public String getMrkEvlGbncd() { return mrkEvlGbncd; }
    public void setMrkEvlGbncd(String mrkEvlGbncd) { this.mrkEvlGbncd = mrkEvlGbncd; }

    public String getMrkInqSrvyId() { return mrkInqSrvyId; }
    public void setMrkInqSrvyId(String mrkInqSrvyId) { this.mrkInqSrvyId = mrkInqSrvyId; }

    public String getUseyn() { return useyn; }
    public void setUseyn(String useyn) { this.useyn = useyn; }

    public String getDelyn() { return delyn; }
    public void setDelyn(String delyn) { this.delyn = delyn; }

    public String getUnivTycd() { return univTycd; }
    public void setUnivTycd(String univTycd) { this.univTycd = univTycd; }

    public String getUnivId() { return univId; }
    public void setUnivId(String univId) { this.univId = univId; }

    public String getScrEvlGbncd() { return scrEvlGbncd; }
    public void setScrEvlGbncd(String scrEvlGbncd) { this.scrEvlGbncd = scrEvlGbncd; }

    public String getKywd() { return kywd; }
    public void setKywd(String kywd) { this.kywd = kywd; }

    public String getLctrFrmtGbncd() { return lctrFrmtGbncd; }
    public void setLctrFrmtGbncd(String lctrFrmtGbncd) { this.lctrFrmtGbncd = lctrFrmtGbncd; }

    public String getLctrGbncd() { return lctrGbncd; }
    public void setLctrGbncd(String lctrGbncd) { this.lctrGbncd = lctrGbncd; }

    public String getSbjctCd() { return sbjctCd; }
    public void setSbjctCd(String sbjctCd) { this.sbjctCd = sbjctCd; }

    public String getCheckType() { return checkType; }
    public void setCheckType(String checkType) { this.checkType = checkType; }

    public String getSbjctEnNm() { return sbjctEnnm; }
    public void setSbjctEnNm(String sbjctEnNm) { this.sbjctEnnm = sbjctEnNm; }

    public String getSbjctGbnCd() { return sbjctGbncd; }
    public void setSbjctGbnCd(String sbjctGbnCd) { this.sbjctGbncd = sbjctGbnCd; }
}
