package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamDsblReqVO extends DefaultVO {

    private static final long serialVersionUID = 5586671936853707832L;
    
    /** tb_lms_exam_dsbl_req */
    private String  dsblReqCd;          // 결시원 고유번호
    private String  crsCreCd;           // 과정 개설 코드
    private String  stdId;              // 수강생 번호
    private String  midApprStat;        // 중간고사 승인 상태
    private Integer midAddTime;         // 중간고사 추가 시간(분)
    private String  endApprStat;        // 기말고사 승인 상태
    private Integer endAddTime;         // 기말고사 추가 시간(분)
    private String  profEditYn;         // 연장시간  변경여부
    
    private String  deptCd;             // 학과코드
    private String  deptNm;             // 학과명
    private String  userId;             // 사용자 번호
    private String  userNm;             // 사용자 이름
    private String  crsCreNm;           // 과목명
    private String  declsNo;            // 분반 번호
    
    private String  disablilityYn;      // 장애 여부
    private String  disabilityLv;       // 장애 등급
    private String  disabilityCd;       // 장애 유형
    private String  disabilityCdNm;     // 장애 유형명
    private String  disabilityLvNm;     // 장애 등급명
    
    private String  creYear;            // 년도
    private String  creTerm;            // 학기
    private String  disablilityExamYn;  // 장애인 시험지원 신청 여부
    private String  uniCd;              // 대학구분
    private String  univGbn;            // 대학구분
    
    private String  profUserId;         // 교수 사용자 번호
    private String  profUserNm;         // 교수명
    private String  tutorUserId;        // 튜터 사용자 번호
    private String  tutorUserNm;        // 튜터명
    private String  mobileNo;           // 휴대폰 번호
    private String  email;              // 이메일
    
    private String  disabilityCancelGbn; // 시험지원 취소 신청 구분
    private String  dsblReqDtYn;
    private String  dsblConfirmDtYn;
    private String  midExamYn;
    private String  lastExamYn;
    private String  schregGbn;
    private String  apprStat;
    private String  examStareTypeCd;
    private String  grscDegrCorsGbn;
    private String  grscDegrCorsGbnNm;
    
    public String getDsblReqCd() {
        return dsblReqCd;
    }
    public void setDsblReqCd(String dsblReqCd) {
        this.dsblReqCd = dsblReqCd;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getStdId() {
        return stdId;
    }
    public void setStdId(String stdId) {
        this.stdId = stdId;
    }
    public String getMidApprStat() {
        return midApprStat;
    }
    public void setMidApprStat(String midApprStat) {
        this.midApprStat = midApprStat;
    }
    public Integer getMidAddTime() {
        return midAddTime;
    }
    public void setMidAddTime(Integer midAddTime) {
        this.midAddTime = midAddTime;
    }
    public String getEndApprStat() {
        return endApprStat;
    }
    public void setEndApprStat(String endApprStat) {
        this.endApprStat = endApprStat;
    }
    public Integer getEndAddTime() {
        return endAddTime;
    }
    public void setEndAddTime(Integer endAddTime) {
        this.endAddTime = endAddTime;
    }
    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getUserNm() {
        return userNm;
    }
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }
    public String getCrsCreNm() {
        return crsCreNm;
    }
    public void setCrsCreNm(String crsCreNm) {
        this.crsCreNm = crsCreNm;
    }
    public String getDeclsNo() {
        return declsNo;
    }
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }
    public String getDisablilityYn() {
        return disablilityYn;
    }
    public void setDisablilityYn(String disablilityYn) {
        this.disablilityYn = disablilityYn;
    }
    public String getDisabilityLv() {
        return disabilityLv;
    }
    public void setDisabilityLv(String disabilityLv) {
        this.disabilityLv = disabilityLv;
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
    public String getDisabilityLvNm() {
        return disabilityLvNm;
    }
    public void setDisabilityLvNm(String disabilityLvNm) {
        this.disabilityLvNm = disabilityLvNm;
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
    public String getDisablilityExamYn() {
        return disablilityExamYn;
    }
    public void setDisablilityExamYn(String disablilityExamYn) {
        this.disablilityExamYn = disablilityExamYn;
    }
    public String getDeptCd() {
        return deptCd;
    }
    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }
    public String getProfUserId() {
        return profUserId;
    }
    public void setProfUserId(String profUserId) {
        this.profUserId = profUserId;
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
    public String getDisabilityCancelGbn() {
        return disabilityCancelGbn;
    }
    public void setDisabilityCancelGbn(String disabilityCancelGbn) {
        this.disabilityCancelGbn = disabilityCancelGbn;
    }
    public String getUniCd() {
        return uniCd;
    }
    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }
    public String getProfUserNm() {
        return profUserNm;
    }
    public void setProfUserNm(String profUserNm) {
        this.profUserNm = profUserNm;
    }
    public String getDsblReqDtYn() {
        return dsblReqDtYn;
    }
    public void setDsblReqDtYn(String dsblReqDtYn) {
        this.dsblReqDtYn = dsblReqDtYn;
    }
    public String getMidExamYn() {
        return midExamYn;
    }
    public void setMidExamYn(String midExamYn) {
        this.midExamYn = midExamYn;
    }
    public String getLastExamYn() {
        return lastExamYn;
    }
    public void setLastExamYn(String lastExamYn) {
        this.lastExamYn = lastExamYn;
    }
    public String getTutorUserId() {
        return tutorUserId;
    }
    public void setTutorUserId(String tutorUserId) {
        this.tutorUserId = tutorUserId;
    }
    public String getTutorUserNm() {
        return tutorUserNm;
    }
    public void setTutorUserNm(String tutorUserNm) {
        this.tutorUserNm = tutorUserNm;
    }
    public String getProfEditYn() {
        return profEditYn;
    }
    public void setProfEditYn(String profEditYn) {
        this.profEditYn = profEditYn;
    }
    public String getSchregGbn() {
        return schregGbn;
    }
    public void setSchregGbn(String schregGbn) {
        this.schregGbn = schregGbn;
    }
    public String getApprStat() {
        return apprStat;
    }
    public void setApprStat(String apprStat) {
        this.apprStat = apprStat;
    }
    public String getExamStareTypeCd() {
        return examStareTypeCd;
    }
    public void setExamStareTypeCd(String examStareTypeCd) {
        this.examStareTypeCd = examStareTypeCd;
    }
    public String getDsblConfirmDtYn() {
        return dsblConfirmDtYn;
    }
    public void setDsblConfirmDtYn(String dsblConfirmDtYn) {
        this.dsblConfirmDtYn = dsblConfirmDtYn;
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
    
}
