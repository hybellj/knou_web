package knou.lms.crs.crs.vo;

import org.apache.ibatis.type.Alias;

import knou.lms.common.vo.DefaultVO;

@Alias("crsVO")
public class CrsVO extends DefaultVO {
    
    private static final long serialVersionUID = 8502979470754269304L;
    
    private String  crsCd;          /*과정 코드*/
    private String  orgId;          /*기관 코드*/
    private String  crsCtgrCd;      /*과정 분류 코드*/
    private String  creTmCtgrCd;    /*테마 분류 코드*/
    private String  crsNm;          /*과정 명*/
    private String  crsDesc;        /*과정설명*/
    private String  crsOperTypeCd;  /*과정 운영 유형 코드*/
    private String  crsOperTypeNm;  /*과정 운영 유형 명*/
    private String  enrlCertMthd;   /*수강 인증 방법*/
    private String  cpltHandlType;  /*수료 처리 형태*/
    private Integer cpltScore;      /*수료 점수*/
    private String  certIssueYn;    /*수료증 발급 여부*/
    private String  crsTypeCd;      /*과정 유형 코드*/    
    private String  crsTypeNm;      /*과정 유형 명*/ 
    private String  eduNop;         /*교육 인원*/   
    private String  nopLimitYn;     /*인원 제한 여부*/    
    private String  useYn;          /*사용 여부*/   
    private String  rgtrId;          /*등록자 번호*/
    private String  regDttm;        /*등록 일시*/
    private String  mdfrId;          /*수정자 번호'*/
    private String  modDttm;        /*수정 일시*/
    private String  crsCtgrNm;
    
    private Integer cnt;
    private String  lineNo;
    private Integer creCrsCnt;
    private String  creYear;
    private String  crsYear;
    private String  creTerm;
    private String  deptNm;
    private String  declsNm;

    private String parCrsCtgrCdLvl1;
    private String parCrsCtgrCdLvl2;
    private String parCrsCtgrCdLvl3;
    private String parCreTmCtgrCdLvl1;
    private String parCreTmCtgrCdLvl2;
    private String parCreTmCtgrCdLvl3;
    private String parCrsCtgrNmLvl1;
    private String parCrsCtgrNmLvl2;
    private String parCrsCtgrNmLvl3;
    private String parCreTmCtgrNmLvl1;
    private String parCreTmCtgrNmLvl2;
    private String parCreTmCtgrNmLvl3;
    
    private String gubun;
    private String langCd;
    
    // 미리보기
    private String  crsInfoCntsCd;      /*과정정보콘텐츠코드*/
    private String  crsInfoCntsDivCd;   /*과정정보콘텐츠구분코드*/
    private Integer cntsOrder;          /*과정 코드*/
    private String  cntsFileLocCd;      /*콘텐츠파일위치코드*/
    private String  cntsFileNm;         /*콘텐츠파일명 */
    private String  cntsFilePath;       /*콘테네츠파일경로*/
    private String  cntsUrl;            /*콘텐츠UR*/

    // lxp-sync CrsVO
    private int attdRatio;
    private int asmtRatio;
    private int forumRatio;
    private int examRatio;
    private int projRatio;
    private int etcRatio;
    private String delYn;

    private String crsTypeCds;
    private String[] crsTypeCdList;
    private String[] crsTypeCdes;

    private int totalCnt;

    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getCrsCd() {
        return crsCd;
    }
    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }

    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getCrsCtgrCd() {
        return crsCtgrCd;
    }
    public void setCrsCtgrCd(String crsCtgrCd) {
        this.crsCtgrCd = crsCtgrCd;
    }
    
    public String getCreTmCtgrCd() {
        return creTmCtgrCd;
    }
    public void setCreTmCtgrCd(String creTmCtgrCd) {
        this.creTmCtgrCd = creTmCtgrCd;
    }

    public String getCrsNm() {
        return crsNm;
    }
    public void setCrsNm(String crsNm) {
        this.crsNm = crsNm;
    }

    public String getCrsDesc() {
        return crsDesc;
    }
    public void setCrsDesc(String crsDesc) {
        this.crsDesc = crsDesc;
    }

    public String getCrsOperTypeCd() {
        return crsOperTypeCd;
    }
    public void setCrsOperTypeCd(String crsOperTypeCd) {
        this.crsOperTypeCd = crsOperTypeCd;
    }

    public String getCrsOperTypeNm() {
        return crsOperTypeNm;
    }
    public void setCrsOperTypeNm(String crsOperTypeNm) {
        this.crsOperTypeNm = crsOperTypeNm;
    }

    public String getEnrlCertMthd() {
        return enrlCertMthd;
    }
    public void setEnrlCertMthd(String enrlCertMthd) {
        this.enrlCertMthd = enrlCertMthd;
    }

    public String getCpltHandlType() {
        return cpltHandlType;
    }
    public void setCpltHandlType(String cpltHandlType) {
        this.cpltHandlType = cpltHandlType;
    }
    
    public Integer getCpltScore() {
        return cpltScore;
    }
    public void setCpltScore(Integer cpltScore) {
        this.cpltScore = cpltScore;
    }

    public String getCertIssueYn() {
        return certIssueYn;
    }
    public void setCertIssueYn(String certIssueYn) {
        this.certIssueYn = certIssueYn;
    }

    public String getCrsTypeCd() {
        return crsTypeCd;
    }
    public void setCrsTypeCd(String crsTypeCd) {
        this.crsTypeCd = crsTypeCd;
    }

    public String getCrsTypeNm() {
        return crsTypeNm;
    }
    public void setCrsTypeNm(String crsTypeNm) {
        this.crsTypeNm = crsTypeNm;
    }

    public String getEduNop() {
        return eduNop;
    }
    public void setEduNop(String eduNop) {
        this.eduNop = eduNop;
    }

    public String getNopLimitYn() {
        return nopLimitYn;
    }
    public void setNopLimitYn(String nopLimitYn) {
        this.nopLimitYn = nopLimitYn;
    }

    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
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

    public String getCrsCtgrNm() {
        return crsCtgrNm;
    }
    public void setCrsCtgrNm(String crsCtgrNm) {
        this.crsCtgrNm = crsCtgrNm;
    }
    
    public Integer getCnt() {
        return cnt;
    }
    public void setCnt(Integer cnt) {
        this.cnt = cnt;
    }

    public String getLineNo() {
        return lineNo;
    }
    public void setLineNo(String lineNo) {
        this.lineNo = lineNo;
    }
    
    public Integer getCreCrsCnt() {
        return creCrsCnt;
    }
    public void setCreCrsCnt(Integer creCrsCnt) {
        this.creCrsCnt = creCrsCnt;
    }

    public String getCreYear() {
        return creYear;
    }
    public void setCreYear(String creYear) {
        this.creYear = creYear;
    }

    public String getCrsYear() {
        return crsYear;
    }
    public void setCrsYear(String crsYear) {
        this.crsYear = crsYear;
    }
    
    public String getCreTerm() {
        return creTerm;
    }
    public void setCreTerm(String creTerm) {
        this.creTerm = creTerm;
    }
    
    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public String getDeclsNm() {
        return declsNm;
    }
    public void setDeclsNm(String declsNm) {
        this.declsNm = declsNm;
    }

    public String getParCrsCtgrCdLvl1() {
        return parCrsCtgrCdLvl1;
    }
    public void setParCrsCtgrCdLvl1(String parCrsCtgrCdLvl1) {
        this.parCrsCtgrCdLvl1 = parCrsCtgrCdLvl1;
    }

    public String getParCrsCtgrCdLvl2() {
        return parCrsCtgrCdLvl2;
    }
    public void setParCrsCtgrCdLvl2(String parCrsCtgrCdLvl2) {
        this.parCrsCtgrCdLvl2 = parCrsCtgrCdLvl2;
    }

    public String getParCrsCtgrCdLvl3() {
        return parCrsCtgrCdLvl3;
    }
    public void setParCrsCtgrCdLvl3(String parCrsCtgrCdLvl3) {
        this.parCrsCtgrCdLvl3 = parCrsCtgrCdLvl3;
    }
    
    public String getParCreTmCtgrCdLvl1() {
        return parCreTmCtgrCdLvl1;
    }
    public void setParCreTmCtgrCdLvl1(String parCreTmCtgrCdLvl1) {
        this.parCreTmCtgrCdLvl1 = parCreTmCtgrCdLvl1;
    }

    public String getParCreTmCtgrCdLvl2() {
        return parCreTmCtgrCdLvl2;
    }
    public void setParCreTmCtgrCdLvl2(String parCreTmCtgrCdLvl2) {
        this.parCreTmCtgrCdLvl2 = parCreTmCtgrCdLvl2;
    }

    public String getParCreTmCtgrCdLvl3() {
        return parCreTmCtgrCdLvl3;
    }
    public void setParCreTmCtgrCdLvl3(String parCreTmCtgrCdLvl3) {
        this.parCreTmCtgrCdLvl3 = parCreTmCtgrCdLvl3;
    }

    public String getParCrsCtgrNmLvl1() {
        return parCrsCtgrNmLvl1;
    }
    public void setParCrsCtgrNmLvl1(String parCrsCtgrNmLvl1) {
        this.parCrsCtgrNmLvl1 = parCrsCtgrNmLvl1;
    }

    public String getParCrsCtgrNmLvl2() {
        return parCrsCtgrNmLvl2;
    }
    public void setParCrsCtgrNmLvl2(String parCrsCtgrNmLvl2) {
        this.parCrsCtgrNmLvl2 = parCrsCtgrNmLvl2;
    }

    public String getParCrsCtgrNmLvl3() {
        return parCrsCtgrNmLvl3;
    }
    public void setParCrsCtgrNmLvl3(String parCrsCtgrNmLvl3) {
        this.parCrsCtgrNmLvl3 = parCrsCtgrNmLvl3;
    }

    public String getParCreTmCtgrNmLvl1() {
        return parCreTmCtgrNmLvl1;
    }
    public void setParCreTmCtgrNmLvl1(String parCreTmCtgrNmLvl1) {
        this.parCreTmCtgrNmLvl1 = parCreTmCtgrNmLvl1;
    }

    public String getParCreTmCtgrNmLvl2() {
        return parCreTmCtgrNmLvl2;
    }
    public void setParCreTmCtgrNmLvl2(String parCreTmCtgrNmLvl2) {
        this.parCreTmCtgrNmLvl2 = parCreTmCtgrNmLvl2;
    }

    public String getParCreTmCtgrNmLvl3() {
        return parCreTmCtgrNmLvl3;
    }
    public void setParCreTmCtgrNmLvl3(String parCreTmCtgrNmLvl3) {
        this.parCreTmCtgrNmLvl3 = parCreTmCtgrNmLvl3;
    }

    public String getGubun() {
        return gubun;
    }
    public void setGubun(String gubun) {
        this.gubun = gubun;
    }

    public String getLangCd() {
        return langCd;
    }
    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }
    
    public String getCrsInfoCntsCd() {
        return crsInfoCntsCd;
    }
    public void setCrsInfoCntsCd(String crsInfoCntsCd) {
        this.crsInfoCntsCd = crsInfoCntsCd;
    }

    public String getCrsInfoCntsDivCd() {
        return crsInfoCntsDivCd;
    }
    public void setCrsInfoCntsDivCd(String crsInfoCntsDivCd) {
        this.crsInfoCntsDivCd = crsInfoCntsDivCd;
    }
    public Integer getCntsOrder() {
        return cntsOrder;
    }
    public void setCntsOrder(Integer cntsOrder) {
        this.cntsOrder = cntsOrder;
    }

    public String getCntsFileLocCd() {
        return cntsFileLocCd;
    }
    public void setCntsFileLocCd(String cntsFileLocCd) {
        this.cntsFileLocCd = cntsFileLocCd;
    }

    public String getCntsFileNm() {
        return cntsFileNm;
    }
    public void setCntsFileNm(String cntsFileNm) {
        this.cntsFileNm = cntsFileNm;
    }

    public String getCntsFilePath() {
        return cntsFilePath;
    }
    public void setCntsFilePath(String cntsFilePath) {
        this.cntsFilePath = cntsFilePath;
    }

    public String getCntsUrl() {
        return cntsUrl;
    }
    public void setCntsUrl(String cntsUrl) {
        this.cntsUrl = cntsUrl;
    }
    
    public int getAttdRatio() {
        return attdRatio;
    }
    public void setAttdRatio(int attdRatio) {
        this.attdRatio = attdRatio;
    }

    public int getAsmtRatio() {
        return asmtRatio;
    }
    public void setAsmtRatio(int asmtRatio) {
        this.asmtRatio = asmtRatio;
    }

    public int getForumRatio() {
        return forumRatio;
    }
    public void setForumRatio(int forumRatio) {
        this.forumRatio = forumRatio;
    }

    public int getExamRatio() {
        return examRatio;
    }
    public void setExamRatio(int examRatio) {
        this.examRatio = examRatio;
    }

    public int getProjRatio() {
        return projRatio;
    }
    public void setProjRatio(int projRatio) {
        this.projRatio = projRatio;
    }

    public int getEtcRatio() {
        return etcRatio;
    }
    public void setEtcRatio(int etcRatio) {
        this.etcRatio = etcRatio;
    }
    
    public String[] getCrsTypeCdList() {
        return crsTypeCdList;
    }
    public void setCrsTypeCdList(String[] crsTypeCdList) {
        this.crsTypeCdList = crsTypeCdList;
    }

    public String getCrsTypeCds() {
        return crsTypeCds;
    }
    public void setCrsTypeCds(String crsTypeCds) {
        this.crsTypeCds = crsTypeCds;
    }

    public String[] getCrsTypeCdes() {
        return crsTypeCdes;
    }
    public void setCrsTypeCdes(String[] crsTypeCdes) {
        this.crsTypeCdes = crsTypeCdes;
    }
    
    public int getTotalCnt() {
        return totalCnt;
    }
    public void setTotalCnt(int totalCnt) {
        this.totalCnt = totalCnt;
    }

}
