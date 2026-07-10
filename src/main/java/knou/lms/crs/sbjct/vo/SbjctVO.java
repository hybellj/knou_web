package knou.lms.crs.sbjct.vo;

import java.math.BigDecimal;

import knou.lms.common.vo.DefaultVO;

public class SbjctVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String sbjctId; // 과목아이디
    private String profId; // 교수아이디
    private String sbjctRefTycd; // 과목참조유형코드
    private String crsMstrId; // 과정마스터아이디
    private String smstrChrtId; // 학기기수아이디
    private String sbjctGbncd; // 과목구분코드
    private String crsGbncd; // 과정구분코드
    private String sbjctTycd; // 과목유형코드
    private String eduMthdTycd; // 교육방법유형코드
    private String rglryn; // 정규여부
    private String crclmnNo; // 교과목번호
    private String sbjctnm; // 과목명
    private String sbjctExpln; // 과목설명
    private String sbjctEnnm; // 과목영문명
    private String sbjctYr; // 과목연도
    private String sbjctSmstr; // 과목학기
    private Integer crdts; // 학점
    private String rvwPsblGbncd; // 복습가능구분코드
    private String rvwSdttm; // 복습시작일시
    private String rvwEdttm; // 복습종료일시
    private String dvclasGrpcd; // 분반그룹코드
    private Integer dvclasNo; // 분반번호
    private String dvclasNcknm; // 분반별칭
    private Integer wholWkCnt; // 전체주차수
    private String cmcrsGbncd; // 이수구분코드
    private String cmcrsGbnnm; // 이수구분명
    private String evlGbncd; // 평가구분코드
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
    private String sbjctLctrSdttm; // 과목강의시작일시
    private String sbjctLctrEdttm; // 과목강의종료일시
    private String atndlcAplyMthdCd; // 수강신청방법코드
    private Integer atndlcQuota; // 수강정원
    private String atndlcCertStscd; // 수강인증상태코드
    private String atndlcAplySdttm; // 수강신청시작일시
    private String atndlcAplyEdttm; // 수강신청종료일시
    private String atndlcSdttm; // 수강시작일시
    private String atndlcEdttm; // 수강종료일시
    private String auditSdttm; // 청강시작일시
    private String auditEdttm; // 청강종료일시
    private String sbjctLateRecgDttm; // 과목지각인정일시
    private String mrkProcSdttm; // 성적처리시작일시
    private String mrkProcEdttm; // 성적처리종료일시
    private String mrkEvlGbncd; // 성적평가구분코드
    private String mrkInqSrvyId; // 성적조회설문아이디
    private String useyn; // 사용여부
    private String delyn; // 삭제여부
    private String scrEvlGbncd; // 점수평가구분코드
    private String kywd; // 키워드
    private String lctrFrmtGbncd; // 강의형식구분코드
    private String rgtrId; // 등록자아이디
    private String regDttm; // 등록일시
    private String mdfrId; // 수정자아이디
    private String modDttm; // 수정일시
    private String lctrGbncd; // 강의구분코드
    private String sbjctCd; // 과목코드
    private String lctrEvlyn; // 강의평가여부
    private Integer lctrPrvwWkno; // 강의미리보기주차번호
    private BigDecimal passfailScr; // PASS/FAIL 점수

    /* DB와 관계없는 파라미터 */
    private String limitYn; // 인원제한여부
    private String lctrPermYn; // 강의기간 영구 여부
    private String sbjctTmpltId; // 과목템플릿아이디
    private String crsGbncdnm; // 과정구분코드명
    private String sbjctTycdnm; // 과목유형코드명
    private String lctrGbncdnm; // 강의구분코드명
    private String evlGbncdnm; // 평가구분코드명
    private String lctrFrmtGbncdnm; // 강의형식구분코드명
    private String lrnCntrlGbncdnm; // 학습제어구분코드명
    private String atndlcAplyMthdCdnm; // 수강신청방법코드명
    private String atndlcCertStscdnm; // 수강인증상태코드명
    private String rvwPsblGbncdnm; // 복습가능구분코드명
    private String lessonCntsUrl; // 강의 미리보기 URL

    public String getSbjctId() { return sbjctId; }
    public void setSbjctId(String sbjctId) { this.sbjctId = sbjctId; }

    public String getProfId() { return profId; }
    public void setProfId(String profId) { this.profId = profId; }

    public String getSbjctRefTycd() { return sbjctRefTycd; }
    public void setSbjctRefTycd(String sbjctRefTycd) { this.sbjctRefTycd = sbjctRefTycd; }

    public String getCrsMstrId() { return crsMstrId; }
    public void setCrsMstrId(String crsMstrId) { this.crsMstrId = crsMstrId; }

    public String getSmstrChrtId() { return smstrChrtId; }
    public void setSmstrChrtId(String smstrChrtId) { this.smstrChrtId = smstrChrtId; }

    public String getSbjctGbncd() { return sbjctGbncd; }
    public void setSbjctGbncd(String sbjctGbncd) { this.sbjctGbncd = sbjctGbncd; }

    public String getCrsGbncd() { return crsGbncd; }
    public void setCrsGbncd(String crsGbncd) { this.crsGbncd = crsGbncd; }

    public String getSbjctTycd() { return sbjctTycd; }
    public void setSbjctTycd(String sbjctTycd) { this.sbjctTycd = sbjctTycd; }

    public String getEduMthdTycd() { return eduMthdTycd; }
    public void setEduMthdTycd(String eduMthdTycd) { this.eduMthdTycd = eduMthdTycd; }

    public String getRglryn() { return rglryn; }
    public void setRglryn(String rglryn) { this.rglryn = rglryn; }

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

    public Integer getCrdts() { return crdts; }
    public void setCrdts(Integer crdts) { this.crdts = crdts; }

    public String getRvwPsblGbncd() { return rvwPsblGbncd; }
    public void setRvwPsblGbncd(String rvwPsblGbncd) { this.rvwPsblGbncd = rvwPsblGbncd; }

    public String getRvwSdttm() { return rvwSdttm; }
    public void setRvwSdttm(String rvwSdttm) { this.rvwSdttm = rvwSdttm; }

    public String getRvwEdttm() { return rvwEdttm; }
    public void setRvwEdttm(String rvwEdttm) { this.rvwEdttm = rvwEdttm; }

    public String getDvclasGrpcd() { return dvclasGrpcd; }
    public void setDvclasGrpcd(String dvclasGrpcd) { this.dvclasGrpcd = dvclasGrpcd; }

    public Integer getDvclasNo() { return dvclasNo; }
    public void setDvclasNo(Integer dvclasNo) { this.dvclasNo = dvclasNo; }

    public String getDvclasNcknm() { return dvclasNcknm; }
    public void setDvclasNcknm(String dvclasNcknm) { this.dvclasNcknm = dvclasNcknm; }

    public Integer getWholWkCnt() { return wholWkCnt; }
    public void setWholWkCnt(Integer wholWkCnt) { this.wholWkCnt = wholWkCnt; }

    public String getCmcrsGbncd() { return cmcrsGbncd; }
    public void setCmcrsGbncd(String cmcrsGbncd) { this.cmcrsGbncd = cmcrsGbncd; }

    public String getCmcrsGbnnm() { return cmcrsGbnnm; }
    public void setCmcrsGbnnm(String cmcrsGbnnm) { this.cmcrsGbnnm = cmcrsGbnnm; }

    public String getEvlGbncd() { return evlGbncd; }
    public void setEvlGbncd(String evlGbncd) { this.evlGbncd = evlGbncd; }

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

    public String getSbjctLctrSdttm() { return sbjctLctrSdttm; }
    public void setSbjctLctrSdttm(String sbjctLctrSdttm) { this.sbjctLctrSdttm = sbjctLctrSdttm; }

    public String getSbjctLctrEdttm() { return sbjctLctrEdttm; }
    public void setSbjctLctrEdttm(String sbjctLctrEdttm) { this.sbjctLctrEdttm = sbjctLctrEdttm; }

    public String getAtndlcAplyMthdCd() { return atndlcAplyMthdCd; }
    public void setAtndlcAplyMthdCd(String atndlcAplyMthdCd) { this.atndlcAplyMthdCd = atndlcAplyMthdCd; }

    public Integer getAtndlcQuota() { return atndlcQuota; }
    public void setAtndlcQuota(Integer atndlcQuota) { this.atndlcQuota = atndlcQuota; }

    public String getLimitYn() { return limitYn; }
    public void setLimitYn(String limitYn) { this.limitYn = limitYn; }

    public String getLctrPermYn() { return lctrPermYn; }
    public void setLctrPermYn(String lctrPermYn) { this.lctrPermYn = lctrPermYn; }

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

    public String getSbjctLateRecgDttm() { return sbjctLateRecgDttm; }
    public void setSbjctLateRecgDttm(String sbjctLateRecgDttm) { this.sbjctLateRecgDttm = sbjctLateRecgDttm; }

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

    public String getScrEvlGbncd() { return scrEvlGbncd; }
    public void setScrEvlGbncd(String scrEvlGbncd) { this.scrEvlGbncd = scrEvlGbncd; }

    public String getKywd() { return kywd; }
    public void setKywd(String kywd) { this.kywd = kywd; }

    public String getLctrFrmtGbncd() { return lctrFrmtGbncd; }
    public void setLctrFrmtGbncd(String lctrFrmtGbncd) { this.lctrFrmtGbncd = lctrFrmtGbncd; }

    public String getRgtrId() { return rgtrId; }
    public void setRgtrId(String rgtrId) { this.rgtrId = rgtrId; }

    public String getRegDttm() { return regDttm; }
    public void setRegDttm(String regDttm) { this.regDttm = regDttm; }

    public String getMdfrId() { return mdfrId; }
    public void setMdfrId(String mdfrId) { this.mdfrId = mdfrId; }

    public String getModDttm() { return modDttm; }
    public void setModDttm(String modDttm) { this.modDttm = modDttm; }

    public String getLctrGbncd() { return lctrGbncd; }
    public void setLctrGbncd(String lctrGbncd) { this.lctrGbncd = lctrGbncd; }

    public String getSbjctCd() { return sbjctCd; }
    public void setSbjctCd(String sbjctCd) { this.sbjctCd = sbjctCd; }

    public String getLctrEvlyn() { return lctrEvlyn; }
    public void setLctrEvlyn(String lctrEvlyn) { this.lctrEvlyn = lctrEvlyn; }

    public Integer getLctrPrvwWkno() { return lctrPrvwWkno; }
    public void setLctrPrvwWkno(Integer lctrPrvwWkno) { this.lctrPrvwWkno = lctrPrvwWkno; }

    public BigDecimal getPassfailScr() { return passfailScr; }
    public void setPassfailScr(BigDecimal passfailScr) { this.passfailScr = passfailScr; }

    public String getSbjctEnNm() { return sbjctEnnm; }
    public void setSbjctEnNm(String sbjctEnNm) { this.sbjctEnnm = sbjctEnNm; }

    public String getSbjctGbnCd() { return sbjctGbncd; }
    public void setSbjctGbnCd(String sbjctGbnCd) { this.sbjctGbncd = sbjctGbnCd; }

    public String getSbjctTmpltId() { return sbjctTmpltId; }
    public void setSbjctTmpltId(String sbjctTmpltId) { this.sbjctTmpltId = sbjctTmpltId; }

    public String getCrsGbncdnm() { return crsGbncdnm; }
    public void setCrsGbncdnm(String crsGbncdnm) { this.crsGbncdnm = crsGbncdnm; }

    public String getSbjctTycdnm() { return sbjctTycdnm; }
    public void setSbjctTycdnm(String sbjctTycdnm) { this.sbjctTycdnm = sbjctTycdnm; }

    public String getLctrGbncdnm() { return lctrGbncdnm; }
    public void setLctrGbncdnm(String lctrGbncdnm) { this.lctrGbncdnm = lctrGbncdnm; }

    public String getEvlGbncdnm() { return evlGbncdnm; }
    public void setEvlGbncdnm(String evlGbncdnm) { this.evlGbncdnm = evlGbncdnm; }

    public String getLctrFrmtGbncdnm() { return lctrFrmtGbncdnm; }
    public void setLctrFrmtGbncdnm(String lctrFrmtGbncdnm) { this.lctrFrmtGbncdnm = lctrFrmtGbncdnm; }

    public String getLrnCntrlGbncdnm() { return lrnCntrlGbncdnm; }
    public void setLrnCntrlGbncdnm(String lrnCntrlGbncdnm) { this.lrnCntrlGbncdnm = lrnCntrlGbncdnm; }

    public String getAtndlcAplyMthdCdnm() { return atndlcAplyMthdCdnm; }
    public void setAtndlcAplyMthdCdnm(String atndlcAplyMthdCdnm) { this.atndlcAplyMthdCdnm = atndlcAplyMthdCdnm; }

    public String getAtndlcCertStscdnm() { return atndlcCertStscdnm; }
    public void setAtndlcCertStscdnm(String atndlcCertStscdnm) { this.atndlcCertStscdnm = atndlcCertStscdnm; }

    public String getRvwPsblGbncdnm() { return rvwPsblGbncdnm; }
    public void setRvwPsblGbncdnm(String rvwPsblGbncdnm) { this.rvwPsblGbncdnm = rvwPsblGbncdnm; }

    public String getLessonCntsUrl() { return lessonCntsUrl; }
    public void setLessonCntsUrl(String lessonCntsUrl) { this.lessonCntsUrl = lessonCntsUrl; }
}
