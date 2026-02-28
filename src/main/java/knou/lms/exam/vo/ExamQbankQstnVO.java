package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExamQbankQstnVO extends DefaultVO {

    /** tb_lms_exam_qbank_qstn */
    private Integer examQbankQstnSn;            // 문제은행 문제 고유번호
    private String  examQbankCtgrCd;            // 문제은행 분류 코드
    private Integer qstnNo;                     // 문제 번호
    private Integer subNo;                      // 후보 번호
    private String  title;                      // 제목
    private String  qstnCts;                    // 문제 내용
    private String  empl1;                      // 예시 1
    private String  empl2;                      // 예시 2
    private String  empl3;                      // 예시 3
    private String  empl4;                      // 예시 4
    private String  empl5;                      // 예시 5
    private String  empl6;                      // 예시 6
    private String  empl7;                      // 예시 7
    private String  empl8;                      // 예시 8
    private String  empl9;                      // 예시 9
    private String  empl10;                     // 예시 10
    private String  multiRgtChoiceYn;           // 멀티 정답 허용 (Y: 복수정답, N :단일정답)
    private String  multiRgtChoiceTypeCd;       // 멀티 정답 구분 (A : 순서에 맞게 정답, B : 순서에 상관 없이 정답, C: 복수 정답 처리)
    private String  multiRgtAnsr;               // 멀티 정답
    private String  rgtAnsr;                    // 정답
    private String  rgtAnsr1;                   // 정답1
    private String  rgtAnsr2;                   // 정답2
    private String  rgtAnsr3;                   // 정답3
    private String  rgtAnsr4;                   // 정답4
    private String  rgtAnsr5;                   // 정답5
    private String  qstnExpl;                   // 문제 해설
    private String  qstnTypeCd;                 // 문제 유형
    private Float   qstnScore;                  // 문제 점수
    private String  qstnDiff;                   // 문제 난이도
    private String  errorAnsrYn;                // 전체 정답 처리 (Y: 처리, N : 미처리)
    private String  editorYn;                   // 에디터 유무
    private String  delYn;                      // 삭제 여부
    
    private String  parExamQbankCtgrCd;         // 상위 문제은행 분류 코드
    private String  parExamCtgrNm;              // 상위 문제은행 분류 명
    private String  examCtgrNm;                 // 문제은행 분류명
    private Integer examCtgrOdr;                // 문제은행 분류 순서
    private Integer parExamCtgrOdr;             // 상위 문제은행 분류 순서
    private String  crsNm;                      // 과목명
    private String  userNm;                     // 사용자명
    private String  qstnTypeNm;                 // 문제 유형명
    private String  crsNo;
    private Integer emplCnt;
    private String  userId;
    private String  crsCreCd;
    private String  qstnDiffNm;
    
    private String  creYear;
    private String  creTerm;
    
    public Integer getExamQbankQstnSn() {
        return examQbankQstnSn;
    }
    public void setExamQbankQstnSn(Integer examQbankQstnSn) {
        this.examQbankQstnSn = examQbankQstnSn;
    }
    public String getExamQbankCtgrCd() {
        return examQbankCtgrCd;
    }
    public void setExamQbankCtgrCd(String examQbankCtgrCd) {
        this.examQbankCtgrCd = examQbankCtgrCd;
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
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getQstnCts() {
        return qstnCts;
    }
    public void setQstnCts(String qstnCts) {
        this.qstnCts = qstnCts;
    }
    public String getEmpl1() {
        return empl1;
    }
    public void setEmpl1(String empl1) {
        this.empl1 = empl1;
    }
    public String getEmpl2() {
        return empl2;
    }
    public void setEmpl2(String empl2) {
        this.empl2 = empl2;
    }
    public String getEmpl3() {
        return empl3;
    }
    public void setEmpl3(String empl3) {
        this.empl3 = empl3;
    }
    public String getEmpl4() {
        return empl4;
    }
    public void setEmpl4(String empl4) {
        this.empl4 = empl4;
    }
    public String getEmpl5() {
        return empl5;
    }
    public void setEmpl5(String empl5) {
        this.empl5 = empl5;
    }
    public String getEmpl6() {
        return empl6;
    }
    public void setEmpl6(String empl6) {
        this.empl6 = empl6;
    }
    public String getEmpl7() {
        return empl7;
    }
    public void setEmpl7(String empl7) {
        this.empl7 = empl7;
    }
    public String getEmpl8() {
        return empl8;
    }
    public void setEmpl8(String empl8) {
        this.empl8 = empl8;
    }
    public String getEmpl9() {
        return empl9;
    }
    public void setEmpl9(String empl9) {
        this.empl9 = empl9;
    }
    public String getEmpl10() {
        return empl10;
    }
    public void setEmpl10(String empl10) {
        this.empl10 = empl10;
    }
    public String getMultiRgtChoiceYn() {
        return multiRgtChoiceYn;
    }
    public void setMultiRgtChoiceYn(String multiRgtChoiceYn) {
        this.multiRgtChoiceYn = multiRgtChoiceYn;
    }
    public String getMultiRgtChoiceTypeCd() {
        return multiRgtChoiceTypeCd;
    }
    public void setMultiRgtChoiceTypeCd(String multiRgtChoiceTypeCd) {
        this.multiRgtChoiceTypeCd = multiRgtChoiceTypeCd;
    }
    public String getMultiRgtAnsr() {
        return multiRgtAnsr;
    }
    public void setMultiRgtAnsr(String multiRgtAnsr) {
        this.multiRgtAnsr = multiRgtAnsr;
    }
    public String getRgtAnsr() {
        return rgtAnsr;
    }
    public void setRgtAnsr(String rgtAnsr) {
        this.rgtAnsr = rgtAnsr;
    }
    public String getQstnExpl() {
        return qstnExpl;
    }
    public void setQstnExpl(String qstnExpl) {
        this.qstnExpl = qstnExpl;
    }
    public String getQstnTypeCd() {
        return qstnTypeCd;
    }
    public void setQstnTypeCd(String qstnTypeCd) {
        this.qstnTypeCd = qstnTypeCd;
    }
    public Float getQstnScore() {
        return qstnScore;
    }
    public void setQstnScore(Float qstnScore) {
        this.qstnScore = qstnScore;
    }
    public String getQstnDiff() {
        return qstnDiff;
    }
    public void setQstnDiff(String qstnDiff) {
        this.qstnDiff = qstnDiff;
    }
    public String getErrorAnsrYn() {
        return errorAnsrYn;
    }
    public void setErrorAnsrYn(String errorAnsrYn) {
        this.errorAnsrYn = errorAnsrYn;
    }
    public String getEditorYn() {
        return editorYn;
    }
    public void setEditorYn(String editorYn) {
        this.editorYn = editorYn;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    public String getParExamQbankCtgrCd() {
        return parExamQbankCtgrCd;
    }
    public void setParExamQbankCtgrCd(String parExamQbankCtgrCd) {
        this.parExamQbankCtgrCd = parExamQbankCtgrCd;
    }
    public String getParExamCtgrNm() {
        return parExamCtgrNm;
    }
    public void setParExamCtgrNm(String parExamCtgrNm) {
        this.parExamCtgrNm = parExamCtgrNm;
    }
    public Integer getExamCtgrOdr() {
        return examCtgrOdr;
    }
    public void setExamCtgrOdr(Integer examCtgrOdr) {
        this.examCtgrOdr = examCtgrOdr;
    }
    public Integer getParExamCtgrOdr() {
        return parExamCtgrOdr;
    }
    public void setParExamCtgrOdr(Integer parExamCtgrOdr) {
        this.parExamCtgrOdr = parExamCtgrOdr;
    }
    public String getCrsNm() {
        return crsNm;
    }
    public void setCrsNm(String crsNm) {
        this.crsNm = crsNm;
    }
    public String getUserNm() {
        return userNm;
    }
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }
    public String getExamCtgrNm() {
        return examCtgrNm;
    }
    public void setExamCtgrNm(String examCtgrNm) {
        this.examCtgrNm = examCtgrNm;
    }
    public String getQstnTypeNm() {
        return qstnTypeNm;
    }
    public void setQstnTypeNm(String qstnTypeNm) {
        this.qstnTypeNm = qstnTypeNm;
    }
    public String getCrsNo() {
        return crsNo;
    }
    public void setCrsNo(String crsNo) {
        this.crsNo = crsNo;
    }
    public Integer getEmplCnt() {
        return emplCnt;
    }
    public void setEmplCnt(Integer emplCnt) {
        this.emplCnt = emplCnt;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getQstnDiffNm() {
        return qstnDiffNm;
    }
    public void setQstnDiffNm(String qstnDiffNm) {
        this.qstnDiffNm = qstnDiffNm;
    }
    public String getRgtAnsr1() {
        return rgtAnsr1;
    }
    public void setRgtAnsr1(String rgtAnsr1) {
        this.rgtAnsr1 = rgtAnsr1;
    }
    public String getRgtAnsr2() {
        return rgtAnsr2;
    }
    public void setRgtAnsr2(String rgtAnsr2) {
        this.rgtAnsr2 = rgtAnsr2;
    }
    public String getRgtAnsr3() {
        return rgtAnsr3;
    }
    public void setRgtAnsr3(String rgtAnsr3) {
        this.rgtAnsr3 = rgtAnsr3;
    }
    public String getRgtAnsr4() {
        return rgtAnsr4;
    }
    public void setRgtAnsr4(String rgtAnsr4) {
        this.rgtAnsr4 = rgtAnsr4;
    }
    public String getRgtAnsr5() {
        return rgtAnsr5;
    }
    public void setRgtAnsr5(String rgtAnsr5) {
        this.rgtAnsr5 = rgtAnsr5;
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
    
}
