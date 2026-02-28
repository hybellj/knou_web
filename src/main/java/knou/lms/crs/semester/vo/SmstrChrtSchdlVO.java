package knou.lms.crs.semester.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 학기기수일정
 * Table: TB_LMS_SMSTR_CHRT_SCHDL
 */
public class SmstrChrtSchdlVO extends DefaultVO {
	private static final long serialVersionUID = 4411642881684327155L;
	private String		smstrChrtSchdlId;	// 학기기수일정아이디
	private String		smstrChrtId;		// 학기기수아이디
	private Integer		schdlWkno;			// 일정주차
	private Integer		tocSeq;				// 목차순서
	private String		smstrChrtSymd;		// 학기기수시작일자
	private String		smstrChrtEymd;		// 학기기수종료일자
	private String		atndcRcgSymd;		// 출석인정시작일자
	private String		atndcRcgEymd;		// 출석인정종료일자


	public String getSmstrChrtSchdlId() {
		return smstrChrtSchdlId;
	}

	public void setSmstrChrtSchdlId(String smstrChrtSchdlId) {
		this.smstrChrtSchdlId = smstrChrtSchdlId;
	}

	public String getSmstrChrtId() {
		return smstrChrtId;
	}

	public void setSmstrChrtId(String smstrChrtId) {
		this.smstrChrtId = smstrChrtId;
	}

	public Integer getSchdlWkno() {
		return schdlWkno;
	}

	public void setSchdlWkno(Integer schdlWkno) {
		this.schdlWkno = schdlWkno;
	}

	public Integer getTocSeq() {
		return tocSeq;
	}

	public void setTocSeq(Integer tocSeq) {
		this.tocSeq = tocSeq;
	}

	public String getSmstrChrtSymd() {
		return smstrChrtSymd;
	}

	public void setSmstrChrtSymd(String smstrChrtSymd) {
		this.smstrChrtSymd = smstrChrtSymd;
	}

	public String getSmstrChrtEymd() {
		return smstrChrtEymd;
	}

	public void setSmstrChrtEymd(String smstrChrtEymd) {
		this.smstrChrtEymd = smstrChrtEymd;
	}

	public String getAtndcRcgSymd() {
		return atndcRcgSymd;
	}

	public void setAtndcRcgSymd(String atndcRcgSymd) {
		this.atndcRcgSymd = atndcRcgSymd;
	}

	public String getAtndcRcgEymd() {
		return atndcRcgEymd;
	}

	public void setAtndcRcgEymd(String atndcRcgEymd) {
		this.atndcRcgEymd = atndcRcgEymd;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}
