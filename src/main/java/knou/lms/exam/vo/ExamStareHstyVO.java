package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamStareHstyVO extends DefaultVO {
	private static final long serialVersionUID = -2679268422459521714L;
    private Integer stareHstySn;            // 시험 응시 이력 고유번호
    private String  stdNo;                  // 수강생 번호
    private String  examCd;                 // 시험 고유번호
    private Integer totGetScore;            // 총 취득 점수
    private Integer stareCnt;               // 응시 횟수
    private Integer stareTm;                // 응시 시간
    private String  startDttm;              // 시작 일시
    private String  endDttm;                // 조욜 일시
    private String  atchCts;                // 첨언 내용
    private String  evalDttm;               // 평가 일시
    private String  evalYn;                 // 평가 여부
    private String  reExamYn;               // 재시험 여부
    private String  delYn;                  // 삭제 여부
    private String  hstyTypeCd;             // 이력 구분 코드 ( START : 시험응시시작, RESTORE : 임시저장, COMPLETE : 시험지제출, CLOSETIME : 시험강제종료, DENIAL : 부정행위처리, INIT : 시험초기화, PAUSE : 일시중지 )
    private String  connIp;                 // 접속 IP
    
    private String  userNm;
    private String  deptNm;
    private String  userId;
    private String  hstyTypeNm;
    
    public Integer getStareHstySn() {
        return stareHstySn;
    }
    public void setStareHstySn(Integer stareHstySn) {
        this.stareHstySn = stareHstySn;
    }
    public String getStdNo() {
        return stdNo;
    }
    public void setStdNo(String stdNo) {
        this.stdNo = stdNo;
    }
    public String getExamCd() {
        return examCd;
    }
    public void setExamCd(String examCd) {
        this.examCd = examCd;
    }
    public Integer getTotGetScore() {
        return totGetScore;
    }
    public void setTotGetScore(Integer totGetScore) {
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
    public String getHstyTypeCd() {
        return hstyTypeCd;
    }
    public void setHstyTypeCd(String hstyTypeCd) {
        this.hstyTypeCd = hstyTypeCd;
    }
    public String getConnIp() {
        return connIp;
    }
    public void setConnIp(String connIp) {
        this.connIp = connIp;
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
    
}
