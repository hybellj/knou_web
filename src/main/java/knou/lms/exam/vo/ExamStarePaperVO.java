package knou.lms.exam.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class ExamStarePaperVO extends DefaultVO {
	private static final long serialVersionUID = -2421718669281450882L;

    private String  examCd;             // 시험 고유번호
    private Integer examQstnSn;         // 시험 문제 고유번호
    private String  stdNo;              // 수강생 번호
    private Integer qstnNo;             // 문제 번호
    private Integer subNo;              // 후보 번호
    private String  stareAnsr;          // 응시답
    private float   getScore;           // 취득 점수
    private String  examOdr;            // 보기 순번
    private String  fdbkCts;            // 피드백 내용
    private String  fdbkDttm;           // 피드백 일시
    
    private String  stdScores;           // 학습자별 점수 수정용
    private List<String> examQstnSnList; // 시험 응시 임시 저장시 사용
    private List<String> stareAnsrList;  // 시험 응시 임시 저장시 사용
    private String  stdNos;
    private String[] examQstnSns;
    private String qstnScoreArr;
    
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
    public Float getGetScore() {
        return getScore;
    }
    public void setGetScore(Float getScore) {
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
    public String getStdScores() {
        return stdScores;
    }
    public void setStdScores(String stdScores) {
        this.stdScores = stdScores;
    }
    public List<String> getExamQstnSnList() {
        return examQstnSnList;
    }
    public void setExamQstnSnList(List<String> examQstnSnList) {
        this.examQstnSnList = examQstnSnList;
    }
    public List<String> getStareAnsrList() {
        return stareAnsrList;
    }
    public void setStareAnsrList(List<String> stareAnsrList) {
        this.stareAnsrList = stareAnsrList;
    }
    public String getStdNos() {
        return stdNos;
    }
    public void setStdNos(String stdNos) {
        this.stdNos = stdNos;
    }
    public String[] getExamQstnSns() {
        return examQstnSns;
    }
    public void setExamQstnSns(String[] examQstnSns) {
        this.examQstnSns = examQstnSns;
    }
    public String getQstnScoreArr() {
        return qstnScoreArr;
    }
    public void setQstnScoreArr(String qstnScoreArr) {
        this.qstnScoreArr = qstnScoreArr;
    }
    
}
