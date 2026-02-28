package knou.lms.exam.vo;

import java.math.BigDecimal;

import knou.lms.common.vo.DefaultVO;

public class TkexamHstryVO extends DefaultVO {

	private static final long serialVersionUID = 8179774996652463779L;

	// TB_LMS_TKEXAM_HSTRY ( 시험응시이력 )
	private String 		tkexamHstryId;		// 시험응시이력아이디
	private String 		examDtlId;			// 시험상세아이디
	private String 		hstryGbncd;			// 이력구분코드 (EXAMPPR_INVALID_PROC : 시험지무료처리, EXAMPPR_SBMSN : 시험지제출, EXAMPPR_GRNT : 시험지부여, REEXAM_STNG : 재시험설정, EXAMPPR_TMP_SAVE : 시험지임시저장, EXAM_QSTNS : 시험문제출제, TKEXAM_STRT : 시험응시시작 )
	private Integer		tkexamCnt;			// 시험응시수
	private BigDecimal  totScr;				// 총점수
	private String 		tkexamMnts;			// 시험응시시간
	private String 		tkexamSdttm;		// 시험응시시작일시
	private String 		tkexamEdttm;		// 시험응시종료일시
	private String 		evlyn;				// 평가여부
	private String 		evlDttm;			// 평가일시
	private String		tkexamIp;			// 시험응시아이피

	public String getTkexamHstryId() {
		return tkexamHstryId;
	}
	public String getExamDtlId() {
		return examDtlId;
	}
	public String getHstryGbncd() {
		return hstryGbncd;
	}
	public Integer getTkexamCnt() {
		return tkexamCnt;
	}
	public BigDecimal getTotScr() {
		return totScr;
	}
	public String getTkexamMnts() {
		return tkexamMnts;
	}
	public String getTkexamSdttm() {
		return tkexamSdttm;
	}
	public String getTkexamEdttm() {
		return tkexamEdttm;
	}
	public String getEvlyn() {
		return evlyn;
	}
	public String getEvlDttm() {
		return evlDttm;
	}
	public void setTkexamHstryId(String tkexamHstryId) {
		this.tkexamHstryId = tkexamHstryId;
	}
	public void setExamDtlId(String examDtlId) {
		this.examDtlId = examDtlId;
	}
	public void setHstryGbncd(String hstryGbncd) {
		this.hstryGbncd = hstryGbncd;
	}
	public void setTkexamCnt(Integer tkexamCnt) {
		this.tkexamCnt = tkexamCnt;
	}
	public void setTotScr(BigDecimal totScr) {
		this.totScr = totScr;
	}
	public void setTkexamMnts(String tkexamMnts) {
		this.tkexamMnts = tkexamMnts;
	}
	public void setTkexamSdttm(String tkexamSdttm) {
		this.tkexamSdttm = tkexamSdttm;
	}
	public void setTkexamEdttm(String tkexamEdttm) {
		this.tkexamEdttm = tkexamEdttm;
	}
	public void setEvlyn(String evlyn) {
		this.evlyn = evlyn;
	}
	public void setEvlDttm(String evlDttm) {
		this.evlDttm = evlDttm;
	}
	public String getTkexamIp() {
		return tkexamIp;
	}
	public void setTkexamIp(String tkexamIp) {
		this.tkexamIp = tkexamIp;
	}

}
