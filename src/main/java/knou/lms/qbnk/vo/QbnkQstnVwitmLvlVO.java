package knou.lms.qbnk.vo;

import knou.lms.common.vo.DefaultVO;

public class QbnkQstnVwitmLvlVO extends DefaultVO {

	private static final long serialVersionUID = 693426871816168811L;

	// TB_LMS_QBNK_QSTN_VWITM_LVL ( 문제은행문항보기항목레벨 )
	private String  qbnkQstnVwitmLvlId;		// 문제은행문항보기항목레벨아이디
	private String  qbnkQstnId;				// 문제은행문항아이디
	private Integer lvlSeqno;				// 레벨순번
	private String  lvlCts;					// 레벨내용
	private Integer lvlScr;					// 레벨점수

	public String getQbnkQstnVwitmLvlId() {
		return qbnkQstnVwitmLvlId;
	}
	public String getQbnkQstnId() {
		return qbnkQstnId;
	}
	public Integer getLvlSeqno() {
		return lvlSeqno;
	}
	public String getLvlCts() {
		return lvlCts;
	}
	public Integer getLvlScr() {
		return lvlScr;
	}
	public void setQbnkQstnVwitmLvlId(String qbnkQstnVwitmLvlId) {
		this.qbnkQstnVwitmLvlId = qbnkQstnVwitmLvlId;
	}
	public void setQbnkQstnId(String qbnkQstnId) {
		this.qbnkQstnId = qbnkQstnId;
	}
	public void setLvlSeqno(Integer lvlSeqno) {
		this.lvlSeqno = lvlSeqno;
	}
	public void setLvlCts(String lvlCts) {
		this.lvlCts = lvlCts;
	}
	public void setLvlScr(Integer lvlScr) {
		this.lvlScr = lvlScr;
	}

}
