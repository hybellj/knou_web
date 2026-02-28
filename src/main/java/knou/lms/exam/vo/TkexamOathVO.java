package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class TkexamOathVO extends DefaultVO {

	private static final long serialVersionUID = 26111075077752338L;

	// TB_LMS_TKEXAM_OATH ( 시험응시서약 )
	private String 	tkexamOathId;		// 시험응시서약아이디
	private String 	tkexamId;			// 시험응시아이디
	private String 	oathyn;				// 서약여부

	public String getTkexamOathId() {
		return tkexamOathId;
	}
	public String getTkexamId() {
		return tkexamId;
	}
	public String getOathyn() {
		return oathyn;
	}
	public void setTkexamOathId(String tkexamOathId) {
		this.tkexamOathId = tkexamOathId;
	}
	public void setTkexamId(String tkexamId) {
		this.tkexamId = tkexamId;
	}
	public void setOathyn(String oathyn) {
		this.oathyn = oathyn;
	}

}
