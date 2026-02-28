package knou.lms.exam.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class ExamStarePaperHstyVO extends DefaultVO {

    /** tb_lms_exam_stare_paper */
    private Integer examStarePaperHstySn;       // 응시 시험지 이력 고유번호
    private Integer stareHstySn;                // 시험 응시 이력 고유번호
    private String  examCd;                     // 시험 고유번호
    private Integer examQstnSn;                 // 시험 문제 고유번호
    private String  stdNo;                      // 수강생 번호
    private Integer qstnNo;                     // 문제 번호
    private Integer subNo;                      // 후보 번호
    private String  stareAnsr;                  // 응시답
    private Integer getScore;                   // 취득 점수
    private String  examOdr;                    // 보기 순번
    private String  fdbkCts;                    // 피드백 내용
    private String  fdbkDttm;                   // 피드백 일시
    
    private String  hstyTypeNm;
    private String  connIp;
    
    private String[] examQstnSnList; // 시험 응시 임시 저장시 사용
    
    public Integer getExamStarePaperHstySn() {
        return examStarePaperHstySn;
    }
    public void setExamStarePaperHstySn(Integer examStarePaperHstySn) {
        this.examStarePaperHstySn = examStarePaperHstySn;
    }
    public Integer getStareHstySn() {
        return stareHstySn;
    }
    public void setStareHstySn(Integer stareHstySn) {
        this.stareHstySn = stareHstySn;
    }
    public String getExamCd() {
        return examCd;
    }
    public void setExamCd(String examCd) {
        this.examCd = examCd;
    }
    public Integer getExamQstnSn() {
        return examQstnSn;
    }
    public void setExamQstnSn(Integer examQstnSn) {
        this.examQstnSn = examQstnSn;
    }
    public String getStdNo() {
        return stdNo;
    }
    public void setStdNo(String stdNo) {
        this.stdNo = stdNo;
    }
    public Integer getQstnNo() {
        return qstnNo;
    }
    public void setQstnNo(Integer qstnNo) {
        this.qstnNo = qstnNo;
    }
    public Integer getSubNo() {
        return subNo;
    }
    public void setSubNo(Integer subNo) {
        this.subNo = subNo;
    }
    public String getStareAnsr() {
        return stareAnsr;
    }
    public void setStareAnsr(String stareAnsr) {
        this.stareAnsr = stareAnsr;
    }
    public Integer getGetScore() {
        return getScore;
    }
    public void setGetScore(Integer getScore) {
        this.getScore = getScore;
    }
    public String getExamOdr() {
        return examOdr;
    }
    public void setExamOdr(String examOdr) {
        this.examOdr = examOdr;
    }
    public String getFdbkCts() {
        return fdbkCts;
    }
    public void setFdbkCts(String fdbkCts) {
        this.fdbkCts = fdbkCts;
    }
    public String getFdbkDttm() {
        return fdbkDttm;
    }
    public void setFdbkDttm(String fdbkDttm) {
        this.fdbkDttm = fdbkDttm;
    }
    public String[] getExamQstnSnList() {
        return examQstnSnList;
    }
    public void setExamQstnSnList(String[] examQstnSnList) {
        this.examQstnSnList = examQstnSnList;
    }
    public String getHstyTypeNm() {
        return hstyTypeNm;
    }
    public void setHstyTypeNm(String hstyTypeNm) {
        this.hstyTypeNm = hstyTypeNm;
    }
    public String getConnIp() {
        return connIp;
    }
    public void setConnIp(String connIp) {
        this.connIp = connIp;
    }
    
}
