package knou.lms.std.vo;

import java.util.Base64;

import knou.lms.common.vo.DefaultVO;

public class StdVO extends DefaultVO {

    private static final long serialVersionUID = -6627136185177479376L;

    /** tb_lms_std */
    private String  stdId;          // 수강생 번호
    private String  orgId;          // 기관 코드
    private String  crsCreCd;       // 과정 개설 코드
    private String  enrlSts;        // 수강 상태 (E : 신청, S : 승인, N : 반려, D : 삭제 )
    private String  enrlStsNm;      // 수강 상태 명
    private String  enrlStartDttm;  // 수강 시작 일시
    private String  enrlEndDttm;    // 수강 종료 일시
    private String  auditEndDttm;   // 청강 종료 일시
    private String  enrlAplcDttm;   // 수강 신청 일시
    private String  enrlCancelDttm; // 수강 취소 일시
    private String  enrlCertDttm;   // 수강 인증 일시
    private String  enrlCpltDttm;   // 수강 수료 일시
    private Integer eduNo;          // 수강 번호
    private String  cpltNo;         // 수료 번호
    private Integer getCredit;      // 취득 학점
    private String  docReceiptYn;   // 문서 접수 여부
    private String  docReceiptNo;   // 문서 접수 번호
    private String  deptNm;         // 부서(학과) 명
    private String  areaCd;         // 지역 코드
    private String  empNo;          // 사원 번호
    private String  scoreEcltYn;    // 점수 우수 여부
    private String  recvNoticeYn;   // 알림 수신 여부
    private String  haksaYn;        // 학사 여부
    
    private String userNm;         // 사용자 이름
    private String disabilityCd;   // 장애 유형
    private String disabilityCdNm; // 장애 유형명
    private String disabilityLv;   // 장애 등급
    private String disabilityLvNm; // 장애등급 구분
    private String disablilityYn;  // 장애여부
    private String dsblReqCd;      // 장애인 지원 신청 고유번호
    private String midApprStat;    // 장애인 지원 신청 중간고사 승인 상태
    private String midAddTime;     // 장애인 지원 신청 중간고사 추가 시간(분)
    private String endApprStat;    // 장애인 지원 신청 기말고사 승인 상태
    private String endAddTime;     // 장애인 지원 신청 기말고사 추가 시간

    private String mobileNo; // 휴대폰 번호
    private String email;    // 이메일 아이디
    private String userId;   // 사용자 아이디

    private String beforeStdNo;
    private String afterStdNo;

    private String lessonScheduleId; // 주차 ID
    private String studyStatusCd;    // 학습 상태 코드
    private String studyStatusNm;    // 학습 상태 명
    private String auditYn;          // 청강여부
    private String repeatYn;         // 재수강여부
    private String midLtsatsfClsYn;  // 강의만족도 참여여부
    private String ltsatsfClsYn;     // 중간강의만족도 참여여부
    private String hy;               // 현재학년
    private String  gvupYn;          // 수강포기여부
    private String entrYy;
    private String entrHy;
    private String readmiYy;
    private String entrGbn;
    private String entrGbnNm;
    private String  crsCd;                     // 과정 코드
    private String  creYear;                   // 개설 년도
    private String  creTerm;                   // 개설 학기(기수)
    
    private String phtFile;
    private byte[] phtFileByte; // 사용자 프로필 사진
    private String[] stdIdArr;
    private String avgMrks;
    private String dsblDttm;
    private String studyStatusCdBak;
    
    private String subDisabilityLvNm;
    private String subDisabilityCdNm;
    private String  riskIndex;
    private String  riskGrade;
    private String  deptCd;
    private String  declsNo;
    private String  schregGbn;
    private String  uniCd;
    private String  univGbn;
    private String  grscDegrCorsGbn;
    private String  grscDegrCorsGbnNm;
    private String  searchAuditYn;
    
    private String  crsTypeCd;
    private String[] crsTypeCds;
    private Integer prgrRatio;
    private String[] crsCreCds;
    
    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getCrsCreCd() {
        return crsCreCd;
    }

    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }

    public String getEnrlSts() {
        return enrlSts;
    }

    public void setEnrlSts(String enrlSts) {
        this.enrlSts = enrlSts;
    }

    public String getEnrlStartDttm() {
        return enrlStartDttm;
    }

    public void setEnrlStartDttm(String enrlStartDttm) {
        this.enrlStartDttm = enrlStartDttm;
    }

    public String getEnrlEndDttm() {
        return enrlEndDttm;
    }

    public void setEnrlEndDttm(String enrlEndDttm) {
        this.enrlEndDttm = enrlEndDttm;
    }

    public String getAuditEndDttm() {
        return auditEndDttm;
    }

    public void setAuditEndDttm(String auditEndDttm) {
        this.auditEndDttm = auditEndDttm;
    }

    public String getEnrlAplcDttm() {
        return enrlAplcDttm;
    }

    public void setEnrlAplcDttm(String enrlAplcDttm) {
        this.enrlAplcDttm = enrlAplcDttm;
    }

    public String getEnrlCancelDttm() {
        return enrlCancelDttm;
    }

    public void setEnrlCancelDttm(String enrlCancelDttm) {
        this.enrlCancelDttm = enrlCancelDttm;
    }

    public String getEnrlCertDttm() {
        return enrlCertDttm;
    }

    public void setEnrlCertDttm(String enrlCertDttm) {
        this.enrlCertDttm = enrlCertDttm;
    }

    public String getEnrlCpltDttm() {
        return enrlCpltDttm;
    }

    public void setEnrlCpltDttm(String enrlCpltDttm) {
        this.enrlCpltDttm = enrlCpltDttm;
    }

    public Integer getEduNo() {
        return eduNo;
    }

    public void setEduNo(Integer eduNo) {
        this.eduNo = eduNo;
    }

    public String getCpltNo() {
        return cpltNo;
    }

    public void setCpltNo(String cpltNo) {
        this.cpltNo = cpltNo;
    }

    public Integer getGetCredit() {
        return getCredit;
    }

    public void setGetCredit(Integer getCredit) {
        this.getCredit = getCredit;
    }

    public String getDocReceiptYn() {
        return docReceiptYn;
    }

    public void setDocReceiptYn(String docReceiptYn) {
        this.docReceiptYn = docReceiptYn;
    }

    public String getDocReceiptNo() {
        return docReceiptNo;
    }

    public void setDocReceiptNo(String docReceiptNo) {
        this.docReceiptNo = docReceiptNo;
    }

    public String getDeptNm() {
        return deptNm;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public String getAreaCd() {
        return areaCd;
    }

    public void setAreaCd(String areaCd) {
        this.areaCd = areaCd;
    }

    public String getEmpNo() {
        return empNo;
    }

    public void setEmpNo(String empNo) {
        this.empNo = empNo;
    }

    public String getScoreEcltYn() {
        return scoreEcltYn;
    }

    public void setScoreEcltYn(String scoreEcltYn) {
        this.scoreEcltYn = scoreEcltYn;
    }

    public String getRecvNoticeYn() {
        return recvNoticeYn;
    }

    public void setRecvNoticeYn(String recvNoticeYn) {
        this.recvNoticeYn = recvNoticeYn;
    }

    public String getHaksaYn() {
        return haksaYn;
    }

    public void setHaksaYn(String haksaYn) {
        this.haksaYn = haksaYn;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public String getDisabilityCd() {
        return disabilityCd;
    }

    public void setDisabilityCd(String disabilityCd) {
        this.disabilityCd = disabilityCd;
    }

    public String getDisabilityCdNm() {
        return disabilityCdNm;
    }

    public void setDisabilityCdNm(String disabilityCdNm) {
        this.disabilityCdNm = disabilityCdNm;
    }

    public String getDisabilityLv() {
        return disabilityLv;
    }

    public void setDisabilityLv(String disabilityLv) {
        this.disabilityLv = disabilityLv;
    }

    public String getDisabilityLvNm() {
        return disabilityLvNm;
    }

    public void setDisabilityLvNm(String disabilityLvNm) {
        this.disabilityLvNm = disabilityLvNm;
    }

    public String getMobileNo() {
        return mobileNo;
    }

    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getBeforeStdNo() {
        return beforeStdNo;
    }

    public void setBeforeStdNo(String beforeStdNo) {
        this.beforeStdNo = beforeStdNo;
    }

    public String getAfterStdNo() {
        return afterStdNo;
    }

    public void setAfterStdNo(String afterStdNo) {
        this.afterStdNo = afterStdNo;
    }

    public String getEnrlStsNm() {
        return enrlStsNm;
    }

    public void setEnrlStsNm(String enrlStsNm) {
        this.enrlStsNm = enrlStsNm;
    }

    public String getDisablilityYn() {
        return disablilityYn;
    }

    public void setDisablilityYn(String disablilityYn) {
        this.disablilityYn = disablilityYn;
    }

    public String getMidApprStat() {
        return midApprStat;
    }

    public void setMidApprStat(String midApprStat) {
        this.midApprStat = midApprStat;
    }

    public String getMidAddTime() {
        return midAddTime;
    }

    public void setMidAddTime(String midAddTime) {
        this.midAddTime = midAddTime;
    }

    public String getEndApprStat() {
        return endApprStat;
    }

    public void setEndApprStat(String endApprStat) {
        this.endApprStat = endApprStat;
    }

    public String getEndAddTime() {
        return endAddTime;
    }

    public void setEndAddTime(String endAddTime) {
        this.endAddTime = endAddTime;
    }

    public String getDsblReqCd() {
        return dsblReqCd;
    }

    public void setDsblReqCd(String dsblReqCd) {
        this.dsblReqCd = dsblReqCd;
    }

    public String getLessonScheduleId() {
        return lessonScheduleId;
    }

    public void setLessonScheduleId(String lessonScheduleId) {
        this.lessonScheduleId = lessonScheduleId;
    }

    public String getStudyStatusCd() {
        return studyStatusCd;
    }

    public void setStudyStatusCd(String studyStatusCd) {
        this.studyStatusCd = studyStatusCd;
    }

    public String getStudyStatusNm() {
        return studyStatusNm;
    }

    public void setStudyStatusNm(String studyStatusNm) {
        this.studyStatusNm = studyStatusNm;
    }

    public String getAuditYn() {
        return auditYn;
    }

    public void setAuditYn(String auditYn) {
        this.auditYn = auditYn;
    }

    public String getRepeatYn() {
        return repeatYn;
    }

    public void setRepeatYn(String repeatYn) {
        this.repeatYn = repeatYn;
    }

    public String getMidLtsatsfClsYn() {
        return midLtsatsfClsYn;
    }

    public void setMidLtsatsfClsYn(String midLtsatsfClsYn) {
        this.midLtsatsfClsYn = midLtsatsfClsYn;
    }

    public String getLtsatsfClsYn() {
        return ltsatsfClsYn;
    }

    public void setLtsatsfClsYn(String ltsatsfClsYn) {
        this.ltsatsfClsYn = ltsatsfClsYn;
    }

    public byte[] getPhtFileByte() {
        return phtFileByte;
    }

    public void setPhtFileByte(byte[] phtFileByte) {
        this.phtFileByte = phtFileByte;
    }

    public String getPhtFile() {
        String phtFile = null;

        if (phtFileByte != null && phtFileByte.length > 0) {
            phtFile = "data:image/png;base64," + new String(Base64.getEncoder().encode(phtFileByte));
        }

        return phtFile;
    }

    public void setPhtFile(String phtFile) {
        this.phtFile = phtFile;
    }

    public String[] getStdIdArr() {
        return stdIdArr;
    }

    public void setStdIdArr(String[] stdIdArr) {
        this.stdIdArr = stdIdArr;
    }

    public String getHy() {
        return hy;
    }

    public void setHy(String hy) {
        this.hy = hy;
    }

    public String getEntrYy() {
        return entrYy;
    }

    public String getEntrHy() {
        return entrHy;
    }

    public String getReadmiYy() {
        return readmiYy;
    }

    public String getEntrGbn() {
        return entrGbn;
    }

    public String getEntrGbnNm() {
        return entrGbnNm;
    }

    public void setEntrYy(String entrYy) {
        this.entrYy = entrYy;
    }

    public void setEntrHy(String entrHy) {
        this.entrHy = entrHy;
    }

    public void setReadmiYy(String readmiYy) {
        this.readmiYy = readmiYy;
    }

    public void setEntrGbn(String entrGbn) {
        this.entrGbn = entrGbn;
    }

    public void setEntrGbnNm(String entrGbnNm) {
        this.entrGbnNm = entrGbnNm;
    }

    public String getCreYear() {
        return creYear;
    }

    public String getCreTerm() {
        return creTerm;
    }

    public void setCreYear(String creYear) {
        this.creYear = creYear;
    }

    public void setCreTerm(String creTerm) {
        this.creTerm = creTerm;
    }

    public String getCrsCd() {
        return crsCd;
    }

    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }

    public String getAvgMrks() {
        return avgMrks;
    }

    public void setAvgMrks(String avgMrks) {
        this.avgMrks = avgMrks;
    }

    public String getDsblDttm() {
        return dsblDttm;
    }

    public void setDsblDttm(String dsblDttm) {
        this.dsblDttm = dsblDttm;
    }

    public String getStudyStatusCdBak() {
        return studyStatusCdBak;
    }

    public void setStudyStatusCdBak(String studyStatusCdBak) {
        this.studyStatusCdBak = studyStatusCdBak;
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public String getGvupYn() {
        return gvupYn;
    }

    public void setGvupYn(String gvupYn) {
        this.gvupYn = gvupYn;
    }

    public String getSubDisabilityLvNm() {
        return subDisabilityLvNm;
    }

    public void setSubDisabilityLvNm(String subDisabilityLvNm) {
        this.subDisabilityLvNm = subDisabilityLvNm;
    }

    public String getSubDisabilityCdNm() {
        return subDisabilityCdNm;
    }

    public void setSubDisabilityCdNm(String subDisabilityCdNm) {
        this.subDisabilityCdNm = subDisabilityCdNm;
    }

    public String getRiskIndex() {
        return riskIndex;
    }

    public void setRiskIndex(String riskIndex) {
        this.riskIndex = riskIndex;
    }

    public String getDeptCd() {
        return deptCd;
    }

    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }

    public String getDeclsNo() {
        return declsNo;
    }

    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }

    public String getSchregGbn() {
        return schregGbn;
    }

    public void setSchregGbn(String schregGbn) {
        this.schregGbn = schregGbn;
    }

    public String getRiskGrade() {
        return riskGrade;
    }

    public void setRiskGrade(String riskGrade) {
        this.riskGrade = riskGrade;
    }

    public String[] getCrsTypeCds() {
        return crsTypeCds;
    }

    public void setCrsTypeCds(String[] crsTypeCds) {
        this.crsTypeCds = crsTypeCds;
    }

    public String getCrsTypeCd() {
        return crsTypeCd;
    }

    public void setCrsTypeCd(String crsTypeCd) {
        this.crsTypeCd = crsTypeCd;
    }

    public Integer getPrgrRatio() {
        return prgrRatio;
    }

    public void setPrgrRatio(Integer prgrRatio) {
        this.prgrRatio = prgrRatio;
    }

    public String[] getCrsCreCds() {
        return crsCreCds;
    }

    public void setCrsCreCds(String[] crsCreCds) {
        this.crsCreCds = crsCreCds;
    }

    public String getUniCd() {
        return uniCd;
    }

    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }

    public String getUnivGbn() {
        return univGbn;
    }

    public void setUnivGbn(String univGbn) {
        this.univGbn = univGbn;
    }

    public String getGrscDegrCorsGbn() {
        return grscDegrCorsGbn;
    }

    public void setGrscDegrCorsGbn(String grscDegrCorsGbn) {
        this.grscDegrCorsGbn = grscDegrCorsGbn;
    }

    public String getGrscDegrCorsGbnNm() {
        return grscDegrCorsGbnNm;
    }

    public void setGrscDegrCorsGbnNm(String grscDegrCorsGbnNm) {
        this.grscDegrCorsGbnNm = grscDegrCorsGbnNm;
    }

    public String getSearchAuditYn() {
        return searchAuditYn;
    }

    public void setSearchAuditYn(String searchAuditYn) {
        this.searchAuditYn = searchAuditYn;
    }

   
    
}
