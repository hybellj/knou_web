package knou.lms.exam.vo;

import java.math.BigDecimal;

import knou.lms.common.vo.DefaultVO;

public class TkexamAnswShtVO extends DefaultVO {

	private static final long serialVersionUID = 1317669211047825633L;

	// TB_LMS_TKEXAM_ANSW_SHT ( 시험응시답안 )
	private String 		tkexamAnswShtId;		// 시험응시답안아이디
	private String 		exampprId;				// 시험지아이디
	private String 		qstnId;					// 문항아이디
	private String 		answShtCts;				// 답안내용
	private BigDecimal 	scr;					// 점수
	private String 		fdbkCts;				// 피드백내용
	private String 		fdbkDttm;				// 피드백일시
	private String 		fdbkrId;				// 피드백자아이디

	public String getTkexamAnswShtId() {
		return tkexamAnswShtId;
	}
	public String getExampprId() {
		return exampprId;
	}
	public String getQstnId() {
		return qstnId;
	}
	public String getAnswShtCts() {
		return answShtCts;
	}
	public BigDecimal getScr() {
		return scr;
	}
	public String getFdbkCts() {
		return fdbkCts;
	}
	public String getFdbkDttm() {
		return fdbkDttm;
	}
	public String getFdbkrId() {
		return fdbkrId;
	}
	public void setTkexamAnswShtId(String tkexamAnswShtId) {
		this.tkexamAnswShtId = tkexamAnswShtId;
	}
	public void setExampprId(String exampprId) {
		this.exampprId = exampprId;
	}
	public void setQstnId(String qstnId) {
		this.qstnId = qstnId;
	}
	public void setAnswShtCts(String answShtCts) {
		this.answShtCts = answShtCts;
	}
	public void setScr(BigDecimal scr) {
		this.scr = scr;
	}
	public void setFdbkCts(String fdbkCts) {
		this.fdbkCts = fdbkCts;
	}
	public void setFdbkDttm(String fdbkDttm) {
		this.fdbkDttm = fdbkDttm;
	}
	public void setFdbkrId(String fdbkrId) {
		this.fdbkrId = fdbkrId;
	}

}
