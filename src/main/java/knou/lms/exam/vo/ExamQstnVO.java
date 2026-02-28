package knou.lms.exam.vo;

import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;

public class ExamQstnVO extends DefaultVO {
	private static final long serialVersionUID = -2300878710107020780L;
	
	/** tb_lms_exam_qstn */
    private String  examCd;                     // 시험 고유번호
    private Integer examQstnSn;                 // 시험 문제 고유번호
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
    private String  multiRgtChoiceYn;           // 멀티 정답 허용 (Y:복수정답, N:단일정답)
    private String  multiRgtChoiceTypeCd;       // 멀티 정답 구분 (A:순서에 맞게 정답,B:순서에 상관 없이 정답,C:복수 정답 처리)
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
    private String  errorAnsrYn;                // 전체 정답 처리 (Y:처리, N:미처리)
    private String  editorYn;                   // 에디터 유무
    private String  delYn;                      // 삭제 여부
    
    private Integer emplCnt;                    // 문항 수
    private String[] randomRgtAnsr;             // 정답 셔플 리스트
    private String  qstnTypeNm;                 // 문제 유형명
    private Integer qstnCnt;                    // 문항 그룹 수
    
    private Integer newQstnNo;
    private String  examQstnSns;
    private String[] examQstnSnList;
    private Integer newSubNo;
    private String  qstnScores;
    
    /** 문항 복사용 */
    private String  copyType;                   // 복사 타입 ( qbank : 문제은행, another : 다른 시험 )
    private String  copyCd;                     // 복사 코드 ( examQbankCtgrCd : 문제은행, examCd : 다른 시험 )
    private String  copyQstnSn;                 // 복사 문항 번호 ( '|' 로 구분 )
    
    private String  stareAnsr;
    
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
        this.empl1 = StringUtil.fn_html_text_convert(empl1);
    }
    public String getEmpl2() {
        return empl2;
    }
    public void setEmpl2(String empl2) {
        this.empl2 = StringUtil.fn_html_text_convert(empl2);
    }
    public String getEmpl3() {
        return empl3;
    }
    public void setEmpl3(String empl3) {
        this.empl3 = StringUtil.fn_html_text_convert(empl3);
    }
    public String getEmpl4() {
        return empl4;
    }
    public void setEmpl4(String empl4) {
        this.empl4 = StringUtil.fn_html_text_convert(empl4);
    }
    public String getEmpl5() {
        return empl5;
    }
    public void setEmpl5(String empl5) {
        this.empl5 = StringUtil.fn_html_text_convert(empl5);
    }
    public String getEmpl6() {
        return empl6;
    }
    public void setEmpl6(String empl6) {
        this.empl6 = StringUtil.fn_html_text_convert(empl6);
    }
    public String getEmpl7() {
        return empl7;
    }
    public void setEmpl7(String empl7) {
        this.empl7 = StringUtil.fn_html_text_convert(empl7);
    }
    public String getEmpl8() {
        return empl8;
    }
    public void setEmpl8(String empl8) {
        this.empl8 = StringUtil.fn_html_text_convert(empl8);
    }
    public String getEmpl9() {
        return empl9;
    }
    public void setEmpl9(String empl9) {
        this.empl9 = StringUtil.fn_html_text_convert(empl9);
    }
    public String getEmpl10() {
        return empl10;
    }
    public void setEmpl10(String empl10) {
        this.empl10 = StringUtil.fn_html_text_convert(empl10);
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
    public Integer getEmplCnt() {
        return emplCnt;
    }
    public void setEmplCnt(Integer emplCnt) {
        this.emplCnt = emplCnt;
    }
    public String[] getRandomRgtAnsr() {
        return randomRgtAnsr;
    }
    public void setRandomRgtAnsr(String[] randomRgtAnsr) {
        this.randomRgtAnsr = randomRgtAnsr;
    }
    public String getQstnTypeNm() {
        return qstnTypeNm;
    }
    public void setQstnTypeNm(String qstnTypeNm) {
        this.qstnTypeNm = qstnTypeNm;
    }
    public Integer getQstnCnt() {
        return qstnCnt;
    }
    public void setQstnCnt(Integer qstnCnt) {
        this.qstnCnt = qstnCnt;
    }
    public Integer getNewQstnNo() {
        return newQstnNo;
    }
    public void setNewQstnNo(Integer newQstnNo) {
        this.newQstnNo = newQstnNo;
    }
    public String getExamQstnSns() {
        return examQstnSns;
    }
    public void setExamQstnSns(String examQstnSns) {
        this.examQstnSns = examQstnSns;
    }
    public String[] getExamQstnSnList() {
        return examQstnSnList;
    }
    public void setExamQstnSnList(String[] examQstnSnList) {
        this.examQstnSnList = examQstnSnList;
    }
    public Integer getNewSubNo() {
        return newSubNo;
    }
    public void setNewSubNo(Integer newSubNo) {
        this.newSubNo = newSubNo;
    }
    public String getQstnScores() {
        return qstnScores;
    }
    public void setQstnScores(String qstnScores) {
        this.qstnScores = qstnScores;
    }
    public String getCopyType() {
        return copyType;
    }
    public void setCopyType(String copyType) {
        this.copyType = copyType;
    }
    public String getCopyCd() {
        return copyCd;
    }
    public void setCopyCd(String copyCd) {
        this.copyCd = copyCd;
    }
    public String getCopyQstnSn() {
        return copyQstnSn;
    }
    public void setCopyQstnSn(String copyQstnSn) {
        this.copyQstnSn = copyQstnSn;
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
    public String getStareAnsr() {
        return stareAnsr;
    }
    public void setStareAnsr(String stareAnsr) {
        this.stareAnsr = stareAnsr;
    }
    
}
