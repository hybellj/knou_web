package knou.lms.exam.vo;

import java.math.BigDecimal;

import knou.lms.common.vo.DefaultVO;

public class TkexamRsltVO extends DefaultVO {

	private static final long serialVersionUID = 3234960351111929510L;

	// TB_LMS_TKEXAM_RSLT ( 시험응시결과 )
	private String 		tkexamRsltId;			// 시험응시결과아이디
	private String 		tkexamId;				// 시험응시아이디
	private Integer		rnk;					// 순위
	private String 		profMemo;				// 교수내용
	private String 		atchCts;				// 첨부내용
	private String 		fdbkCts;				// 피드백내용
	private String 		fdbkDttm;				// 피드백일시
	private String 		fdbkrId;				// 피드백자아이디
	private BigDecimal 	totScr;					// 총점수
	private String 		mosaCmpDttm;			// 모사비교일시
	private BigDecimal 	maxMosart;				// 최대모사율
	private String 		cmrclDataFileId;		// 상업용자료파일아이디
	private BigDecimal 	cmrclDataMosart;		// 상업용자료모사율
	private String 		maxMosaId;				// 최대모사아이디
	private String		evlyn;					// 평가여부
	private String 		evlDttm;				// 평가일시

	public String getTkexamRsltId() {
		return tkexamRsltId;
	}
	public String getTkexamId() {
		return tkexamId;
	}
	public Integer getRnk() {
		return rnk;
	}
	public String getProfMemo() {
		return profMemo;
	}
	public String getAtchCts() {
		return atchCts;
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
	public BigDecimal getTotScr() {
		return totScr;
	}
	public String getMosaCmpDttm() {
		return mosaCmpDttm;
	}
	public BigDecimal getMaxMosart() {
		return maxMosart;
	}
	public String getCmrclDataFileId() {
		return cmrclDataFileId;
	}
	public BigDecimal getCmrclDataMosart() {
		return cmrclDataMosart;
	}
	public String getMaxMosaId() {
		return maxMosaId;
	}
	public String getEvlyn() {
		return evlyn;
	}
	public String getEvlDttm() {
		return evlDttm;
	}
	public void setTkexamRsltId(String tkexamRsltId) {
		this.tkexamRsltId = tkexamRsltId;
	}
	public void setTkexamId(String tkexamId) {
		this.tkexamId = tkexamId;
	}
	public void setRnk(Integer rnk) {
		this.rnk = rnk;
	}
	public void setProfMemo(String profMemo) {
		this.profMemo = profMemo;
	}
	public void setAtchCts(String atchCts) {
		this.atchCts = atchCts;
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
	public void setTotScr(BigDecimal totScr) {
		this.totScr = totScr;
	}
	public void setMosaCmpDttm(String mosaCmpDttm) {
		this.mosaCmpDttm = mosaCmpDttm;
	}
	public void setMaxMosart(BigDecimal maxMosart) {
		this.maxMosart = maxMosart;
	}
	public void setCmrclDataFileId(String cmrclDataFileId) {
		this.cmrclDataFileId = cmrclDataFileId;
	}
	public void setCmrclDataMosart(BigDecimal cmrclDataMosart) {
		this.cmrclDataMosart = cmrclDataMosart;
	}
	public void setMaxMosaId(String maxMosaId) {
		this.maxMosaId = maxMosaId;
	}
	public void setEvlyn(String evlyn) {
		this.evlyn = evlyn;
	}
	public void setEvlDttm(String evlDttm) {
		this.evlDttm = evlDttm;
	}

}
