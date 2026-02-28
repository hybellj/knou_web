package knou.lms.exam.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class ExamStareVO extends DefaultVO {
    private static final long serialVersionUID = -696944464258293092L;
    
    /** tb_lms_exam_stare */
    private String  stdId;                  // 수강생 번호
    private String  examCd;                 // 시험 고유 번호
    private String  stareSn;                 // 수강생 번호 + 시험고유번호
    private float totGetScore;            // 총 취득 점수
    private Integer stareCnt;               // 응시 횟수
    private Integer stareTm;                // 응시 시간
    private String  startDttm;              // 시작 일시
    private String  endDttm;                // 종료 일시
    private String  atchCts;                // 첨언 내용
    private String  evalDttm;               // 평가 일시
    private String  evalYn;                 // 평가 여부
    private String  reExamYn;               // 재시험 여부
    private String  profMemo;               // 교수 메모
    private String  delYn;                  // 삭제 여부
    
    private String  userNm;
    private String  deptNm;
    private String  userId;
    private String  hstyTypeNm;
    private String  hstyTypeCd;
    private Integer stareScore;
    private String  stdIds;
    private List<String> stdNoList;
    private String  scoreType;
    private String  totGetScoreArr;
    
    private String  label;                  // 점수 통계용
    private Integer cnt;                    // 점수 통계용
    private String  examStareTypeCd;
    private String  conditionType;
    private String  stareStatusCd;
    private String  examQstnSn;
    
    private String  mobileNo;
    private String  email;
    private String  examTypeCd;
    private String  reExamStartDttm;
    private String  reExamEndDttm;
    private Integer reExamAplyRatio;
    
    private String  haksaYear;
    private String  haksaTerm;
    private String  deptCd;
    private String  uniCd;
    private String  tchNo;
    private String  tchNm;
    private String  apprStat;
    private String  hy;
    
    private String  stareYn;
    private String  absentYn;
    private String  absentNm;
    private String  examStareYn;
    private String  konanMaxCopyRate;
    private String  grscDegrCorsGbn;
    private String  grscDegrCorsGbnNm;
    
    public String getStdId() {
        return stdId;
    }
    public void setStdId(String stdId) {
        this.stdId = stdId;
    }
    public String getExamCd() {
        return examCd;
    }
    public void setExamCd(String examCd) {
        this.examCd = examCd;
    }
    
    public String getStareSn() {
    	if (stareSn == null) {
    		stareSn = stdId+examCd;
    	}
        return stareSn;
    }
    public void setStareSn(String stareSn) {
        this.stareSn = stareSn;
    }
    
    public float getTotGetScore() {
        return totGetScore;
    }
    public void setTotGetScore(float totGetScore) {
        this.totGetScore = totGetScore;
    }
    public Integer getStareCnt() {
        return stareCnt;
    }
    public void setStareCnt(Integer stareCnt) {
        this.stareCnt = stareCnt;
    }
    public Integer getStareTm() {
        return stareTm;
    }
    public void setStareTm(Integer stareTm) {
        this.stareTm = stareTm;
    }
    public String getStartDttm() {
        return startDttm;
    }
    public void setStartDttm(String startDttm) {
        this.startDttm = startDttm;
    }
    public String getEndDttm() {
        return endDttm;
    }
    public void setEndDttm(String endDttm) {
        this.endDttm = endDttm;
    }
    public String getAtchCts() {
        return atchCts;
    }
    public void setAtchCts(String atchCts) {
        this.atchCts = atchCts;
    }
    public String getEvalDttm() {
        return evalDttm;
    }
    public void setEvalDttm(String evalDttm) {
        this.evalDttm = evalDttm;
    }
    public String getEvalYn() {
        return evalYn;
    }
    public void setEvalYn(String evalYn) {
        this.evalYn = evalYn;
    }
    public String getReExamYn() {
        return reExamYn;
    }
    public void setReExamYn(String reExamYn) {
        this.reExamYn = reExamYn;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    public String getProfMemo() {
        return profMemo;
    }
    public void setProfMemo(String profMemo) {
        this.profMemo = profMemo;
    }
    public String getUserNm() {
        return userNm;
    }
    public void setUserNm(String userNm) {
        this.userNm = userNm;
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
    public String getHstyTypeNm() {
        return hstyTypeNm;
    }
    public void setHstyTypeNm(String hstyTypeNm) {
        this.hstyTypeNm = hstyTypeNm;
    }
    public String getHstyTypeCd() {
        return hstyTypeCd;
    }
    public void setHstyTypeCd(String hstyTypeCd) {
        this.hstyTypeCd = hstyTypeCd;
    }
    public Integer getStareScore() {
        return stareScore;
    }
    public void setStareScore(Integer stareScore) {
        this.stareScore = stareScore;
    }
    public String getStdIds() {
        return stdIds;
    }
    public void setStdIds(String stdIds) {
        this.stdIds = stdIds;
    }
    public List<String> getStdNoList() {
        return stdNoList;
    }
    public void setStdNoList(List<String> stdNoList) {
        this.stdNoList = stdNoList;
    }
    public String getScoreType() {
        return scoreType;
    }
    public void setScoreType(String scoreType) {
        this.scoreType = scoreType;
    }
    public String getTotGetScoreArr() {
        return totGetScoreArr;
    }
    public void setTotGetScoreArr(String totGetScoreArr) {
        this.totGetScoreArr = totGetScoreArr;
    }
    public String getLabel() {
        return label;
    }
    public void setLabel(String label) {
        this.label = label;
    }
    public Integer getCnt() {
        return cnt;
    }
    public void setCnt(Integer cnt) {
        this.cnt = cnt;
    }
    public String getExamStareTypeCd() {
        return examStareTypeCd;
    }
    public void setExamStareTypeCd(String examStareTypeCd) {
        this.examStareTypeCd = examStareTypeCd;
    }
    public String getConditionType() {
        return conditionType;
    }
    public void setConditionType(String conditionType) {
        this.conditionType = conditionType;
    }
    public String getStareStatusCd() {
        return stareStatusCd;
    }
    public void setStareStatusCd(String stareStatusCd) {
        this.stareStatusCd = stareStatusCd;
    }
    public String getExamQstnSn() {
        return examQstnSn;
    }
    public void setExamQstnSn(String examQstnSn) {
        this.examQstnSn = examQstnSn;
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
    public String getExamTypeCd() {
        return examTypeCd;
    }
    public void setExamTypeCd(String examTypeCd) {
        this.examTypeCd = examTypeCd;
    }
    public String getReExamStartDttm() {
        return reExamStartDttm;
    }
    public void setReExamStartDttm(String reExamStartDttm) {
        this.reExamStartDttm = reExamStartDttm;
    }
    public String getReExamEndDttm() {
        return reExamEndDttm;
    }
    public void setReExamEndDttm(String reExamEndDttm) {
        this.reExamEndDttm = reExamEndDttm;
    }
    public Integer getReExamAplyRatio() {
        return reExamAplyRatio;
    }
    public void setReExamAplyRatio(Integer reExamAplyRatio) {
        this.reExamAplyRatio = reExamAplyRatio;
    }
    public String getDeptCd() {
        return deptCd;
    }
    public void setDeptCd(String deptCd) {
        this.deptCd = deptCd;
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
    public String getHaksaYear() {
        return haksaYear;
    }
    public void setHaksaYear(String haksaYear) {
        this.haksaYear = haksaYear;
    }
    public String getHaksaTerm() {
        return haksaTerm;
    }
    public void setHaksaTerm(String haksaTerm) {
        this.haksaTerm = haksaTerm;
    }
    public String getApprStat() {
        return apprStat;
    }
    public void setApprStat(String apprStat) {
        this.apprStat = apprStat;
    }
    public String getTchNm() {
        return tchNm;
    }
    public void setTchNm(String tchNm) {
        this.tchNm = tchNm;
    }
    public String getHy() {
        return hy;
    }
    public void setHy(String hy) {
        this.hy = hy;
    }
    public String getStareYn() {
        return stareYn;
    }
    public void setStareYn(String stareYn) {
        this.stareYn = stareYn;
    }
    public String getAbsentYn() {
        return absentYn;
    }
    public void setAbsentYn(String absentYn) {
        this.absentYn = absentYn;
    }
    public String getAbsentNm() {
        return absentNm;
    }
    public void setAbsentNm(String absentNm) {
        this.absentNm = absentNm;
    }
    public String getExamStareYn() {
        return examStareYn;
    }
    public void setExamStareYn(String examStareYn) {
        this.examStareYn = examStareYn;
    }
    public String getKonanMaxCopyRate() {
        return konanMaxCopyRate;
    }
    public void setKonanMaxCopyRate(String konanMaxCopyRate) {
        this.konanMaxCopyRate = konanMaxCopyRate;
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
