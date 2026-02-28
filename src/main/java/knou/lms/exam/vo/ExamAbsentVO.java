package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamAbsentVO extends DefaultVO {

    private static final long serialVersionUID = -645035954236542846L;
    
    /** tb_lms_exam_absent */
    private String  examAbsentCd;       // 결시원 고유번호
    private String  crsCreCd;           // 과정 개설 코드
    private String  examCd;             // 시험 고유번호
    private String  stdId;              // 수강생 번호
    private String  absentTitle;        // 결시원 제목
    private String  absentCts;          // 결시원 내용
    private String  apprStat;           // 승인 상태
    private String  apprCts;            // 승인 내용
    private String  mgrCmnt;            // 관리자 의견
    
    private String  deptNm;             // 학과명
    private String  mobileNo;           // 휴대폰번호
    private String  declsNo;            // 분반 번호
    private String  examStareTypeCd;    // 시험 응시 유형 코드
    private String  examStareTypeNm;    // 시험 응시 유형명
    private String  examStartDttm;      // 시험 시작일시
    
    private String  creYear;            // 년도
    private String  creTerm;            // 학기
    private String  tchNo;
    private String  tchNm;              // 교수명
    private String  tutorNo;
    private String  tutorNm;            // 튜터명
    
    private String  reApplicateYn;      // 재신청 여부
    private String  apprStatNm;         // 승인 상태명
    private String  deptCd;             // 학과코드
    private String  crsCd;              // 학수번호
    private String  crsDeptNm;          // 과목 개설학과명
    private String  examStareYn;        // 실시간시험 응시여부
    private String  email;              // 이메일
    private String  examSubsYn;         // 대체과제 부여여부
    private String  uniCd;              // 대학구분
    private String  univGbn;            // 대학구분
    private String  grscDegrCorsGbn;    // 대학구분
    private String  grscDegrCorsGbnNm;  // 대학구분
    
    public String getExamAbsentCd() {
        return examAbsentCd;
    }
    public void setExamAbsentCd(String examAbsentCd) {
        this.examAbsentCd = examAbsentCd;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getExamCd() {
        return examCd;
    }
    public void setExamCd(String examCd) {
        this.examCd = examCd;
    }
    public String getStdId() {
        return stdId;
    }
    public void setStdId(String stdId) {
        this.stdId = stdId;
    }
    public String getAbsentTitle() {
        return absentTitle;
    }
    public void setAbsentTitle(String absentTitle) {
        this.absentTitle = absentTitle;
    }
    public String getAbsentCts() {
        return absentCts;
    }
    public void setAbsentCts(String absentCts) {
        this.absentCts = absentCts;
    }
    public String getApprStat() {
        return apprStat;
    }
    public void setApprStat(String apprStat) {
        this.apprStat = apprStat;
    }
    public String getApprCts() {
        return apprCts;
    }
    public void setApprCts(String apprCts) {
        this.apprCts = apprCts;
    }
    public String getMgrCmnt() {
        return mgrCmnt;
    }
    public void setMgrCmnt(String mgrCmnt) {
        this.mgrCmnt = mgrCmnt;
    }
    public String getDeptNm() {
        return deptNm;
    }
    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }
    public String getMobileNo() {
        return mobileNo;
    }
    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }
    public String getDeclsNo() {
        return declsNo;
    }
    public void setDeclsNo(String declsNo) {
        this.declsNo = declsNo;
    }
    public String getExamStareTypeCd() {
        return examStareTypeCd;
    }
    public void setExamStareTypeCd(String examStareTypeCd) {
        this.examStareTypeCd = examStareTypeCd;
    }
    public String getExamStareTypeNm() {
        return examStareTypeNm;
    }
    public void setExamStareTypeNm(String examStareTypeNm) {
        this.examStareTypeNm = examStareTypeNm;
    }
    public String getExamStartDttm() {
        return examStartDttm;
    }
    public void setExamStartDttm(String examStartDttm) {
        this.examStartDttm = examStartDttm;
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
    public String getTchNm() {
        return tchNm;
    }
    public void setTchNm(String tchNm) {
        this.tchNm = tchNm;
    }
    public String getTutorNm() {
        return tutorNm;
    }
    public void setTutorNm(String tutorNm) {
        this.tutorNm = tutorNm;
    }
    public String getReApplicateYn() {
        return reApplicateYn;
    }
    public void setReApplicateYn(String reApplicateYn) {
        this.reApplicateYn = reApplicateYn;
    }
    public String getApprStatNm() {
        return apprStatNm;
    }
    public void setApprStatNm(String apprStatNm) {
        this.apprStatNm = apprStatNm;
    }
    public String getDeptCd() {
        return deptCd;
    }
    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
    }
    public String getCrsCd() {
        return crsCd;
    }
    public void setCrsCd(String crsCd) {
        this.crsCd = crsCd;
    }
    public String getCrsDeptNm() {
        return crsDeptNm;
    }
    public void setCrsDeptNm(String crsDeptNm) {
        this.crsDeptNm = crsDeptNm;
    }
    public String getExamStareYn() {
        return examStareYn;
    }
    public void setExamStareYn(String examStareYn) {
        this.examStareYn = examStareYn;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getExamSubsYn() {
        return examSubsYn;
    }
    public void setExamSubsYn(String examSubsYn) {
        this.examSubsYn = examSubsYn;
    }
    public String getUniCd() {
        return uniCd;
    }
    public void setUniCd(String uniCd) {
        this.uniCd = uniCd;
    }
    public String getTchNo() {
        return tchNo;
    }
    public void setTchNo(String tchNo) {
        this.tchNo = tchNo;
    }
    public String getTutorNo() {
        return tutorNo;
    }
    public void setTutorNo(String tutorNo) {
        this.tutorNo = tutorNo;
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
