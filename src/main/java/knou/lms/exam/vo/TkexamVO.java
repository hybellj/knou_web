package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class TkexamVO extends DefaultVO {

	private static final long serialVersionUID = -2342699736712192157L;

	// TB_LMS_TKEXAM ( 시험응시 )
	private String 	tkexamId;			// 시험응시아이디
	private String 	examDtlId;			// 시험상세아이디
	private Integer	tkexamCnt;			// 시험응시수
	private Integer	tkexamMnts;			// 시험응시시간
	private String 	tkexamCmptnyn;		// 시험응시완료여부
	private String 	tkexamSdttm;		// 시험응시시작일시
	private String 	tkexamEdttm;		// 시험응시종료일시
	private String 	retkexamYn;			// 재응시여부
	private String 	delyn;				// 삭제여부

	public String getTkexamId() {
		return tkexamId;
	}
	public String getExamDtlId() {
		return examDtlId;
	}
	public Integer getTkexamCnt() {
		return tkexamCnt;
	}
	public Integer getTkexamMnts() {
		return tkexamMnts;
	}
	public String getTkexamCmptnyn() {
		return tkexamCmptnyn;
	}
	public String getTkexamSdttm() {
		return tkexamSdttm;
	}
	public String getTkexamEdttm() {
		return tkexamEdttm;
	}
	public String getRetkexamYn() {
		return retkexamYn;
	}
	public String getDelyn() {
		return delyn;
	}
	public void setTkexamId(String tkexamId) {
		this.tkexamId = tkexamId;
	}
	public void setExamDtlId(String examDtlId) {
		this.examDtlId = examDtlId;
	}
	public void setTkexamCnt(Integer tkexamCnt) {
		this.tkexamCnt = tkexamCnt;
	}
	public void setTkexamMnts(Integer tkexamMnts) {
		this.tkexamMnts = tkexamMnts;
	}
	public void setTkexamCmptnyn(String tkexamCmptnyn) {
		this.tkexamCmptnyn = tkexamCmptnyn;
	}
	public void setTkexamSdttm(String tkexamSdttm) {
		this.tkexamSdttm = tkexamSdttm;
	}
	public void setTkexamEdttm(String tkexamEdttm) {
		this.tkexamEdttm = tkexamEdttm;
	}
	public void setRetkexamYn(String retkexamYn) {
		this.retkexamYn = retkexamYn;
	}
	public void setDelyn(String delyn) {
		this.delyn = delyn;
	}

}
