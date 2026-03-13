package knou.lms.srvy.vo;

import knou.lms.common.vo.DefaultVO;

public class SrvyQstnVwitmLvlVO extends DefaultVO {

	private static final long serialVersionUID = 4784886005685324486L;

	// TB_LMS_SRVY_QSTN_VWITM_LVL ( 설문문항보기항목레벨 )
	private String  srvyQstnVwitmLvlId;		// 설문문항보기항목레벨아이디
	private String  srvyQstnId;				// 설문문항아이디
	private Integer lvlSeqno;				// 레벨순번
	private String  lvlCts;					// 레벨내용
	private Integer lvlScr;					// 레벨점수

	public String getSrvyQstnVwitmLvlId() {
		return srvyQstnVwitmLvlId;
	}
	public String getSrvyQstnId() {
		return srvyQstnId;
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
	public void setSrvyQstnVwitmLvlId(String srvyQstnVwitmLvlId) {
		this.srvyQstnVwitmLvlId = srvyQstnVwitmLvlId;
	}
	public void setSrvyQstnId(String srvyQstnId) {
		this.srvyQstnId = srvyQstnId;
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
