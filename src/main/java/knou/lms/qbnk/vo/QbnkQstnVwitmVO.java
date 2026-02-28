package knou.lms.qbnk.vo;

import knou.lms.common.vo.DefaultVO;

public class QbnkQstnVwitmVO extends DefaultVO {

	private static final long serialVersionUID = 8698445216638288126L;

	// TB_LMS_QBNK_QSTN_VWITM ( 문제은행보기항목 )
	private String 	qbnkVwitmId;		// 문제은행보기항목아이디
	private String 	qbnkQstnId;			// 문제은행문항아이디
	private String 	vwitmCts;			// 보기항목내용
	private Integer	vwitmSeqno;			// 보기항목순번
	private String 	cransyn;			// 정답여부
	private String 	edtrUseyn;			// 편집기사용여부

	public String getQbnkVwitmId() {
		return qbnkVwitmId;
	}
	public String getQbnkQstnId() {
		return qbnkQstnId;
	}
	public String getVwitmCts() {
		return vwitmCts;
	}
	public Integer getVwitmSeqno() {
		return vwitmSeqno;
	}
	public String getCransyn() {
		return cransyn;
	}
	public String getEdtrUseyn() {
		return edtrUseyn;
	}
	public void setQbnkVwitmId(String qbnkVwitmId) {
		this.qbnkVwitmId = qbnkVwitmId;
	}
	public void setQbnkQstnId(String qbnkQstnId) {
		this.qbnkQstnId = qbnkQstnId;
	}
	public void setVwitmCts(String vwitmCts) {
		this.vwitmCts = vwitmCts;
	}
	public void setVwitmSeqno(Integer vwitmSeqno) {
		this.vwitmSeqno = vwitmSeqno;
	}
	public void setCransyn(String cransyn) {
		this.cransyn = cransyn;
	}
	public void setEdtrUseyn(String edtrUseyn) {
		this.edtrUseyn = edtrUseyn;
	}

}
