package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class QstnVwitmVO extends DefaultVO {

	private static final long serialVersionUID = 599794982969630388L;

	// TB_LMS_QSTN_VWITM ( 문항보기항목 )
	private String 	qstnVwitmId;			// 문항보기항목아이디
	private String 	qstnId;					// 문항아이디
	private String 	qstnVwitmGbncd;			// 문항보기항목구분코드
	private String 	qstnVwitmCts;			// 문항보기항목내용
	private String 	cransYn;				// 정답여부
	private String 	edtrUseyn;				// 편집기사용여부
	private Integer	qstnVwitmSeqno;			// 문항보기항목순번

	public String getQstnVwitmId() {
		return qstnVwitmId;
	}
	public String getQstnId() {
		return qstnId;
	}
	public String getQstnVwitmGbncd() {
		return qstnVwitmGbncd;
	}
	public String getQstnVwitmCts() {
		return qstnVwitmCts;
	}
	public String getCransYn() {
		return cransYn;
	}
	public String getEdtrUseyn() {
		return edtrUseyn;
	}
	public Integer getQstnVwitmSeqno() {
		return qstnVwitmSeqno;
	}
	public void setQstnVwitmId(String qstnVwitmId) {
		this.qstnVwitmId = qstnVwitmId;
	}
	public void setQstnId(String qstnId) {
		this.qstnId = qstnId;
	}
	public void setQstnVwitmGbncd(String qstnVwitmGbncd) {
		this.qstnVwitmGbncd = qstnVwitmGbncd;
	}
	public void setQstnVwitmCts(String qstnVwitmCts) {
		this.qstnVwitmCts = qstnVwitmCts;
	}
	public void setCransYn(String cransYn) {
		this.cransYn = cransYn;
	}
	public void setEdtrUseyn(String edtrUseyn) {
		this.edtrUseyn = edtrUseyn;
	}
	public void setQstnVwitmSeqno(Integer qstnVwitmSeqno) {
		this.qstnVwitmSeqno = qstnVwitmSeqno;
	}

}
