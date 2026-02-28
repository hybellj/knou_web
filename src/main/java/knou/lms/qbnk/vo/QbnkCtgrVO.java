package knou.lms.qbnk.vo;

import knou.lms.common.vo.DefaultVO;

public class QbnkCtgrVO extends DefaultVO {

	private static final long serialVersionUID = 3684389411022473705L;

	// TB_LMS_QBNK_CTGR ( 문제은행분류 )
	private String 	qbnkCtgrId;			// 문제은행분류아이디
	private String 	upQbnkCtgrId;		// 상위문제은행분류아이디
	private String 	crsMstrId;			// 과정마스터아이디
	private String 	smstrChrtId;		// 학기기수아이디
	private String 	ctgrnm;				// 분류명
	private String 	ctgrExpln;			// 분류설명
	private Integer	ctgrSeqno;			// 분류순번
	private String 	shrnyn;				// 공유여부
	private String 	delyn;				// 삭제여부
	private String 	qbnkQstnGbncd;		// 문제은행문항구분코드

	public String getQbnkCtgrId() {
		return qbnkCtgrId;
	}
	public String getUpQbnkCtgrId() {
		return upQbnkCtgrId;
	}
	public String getCrsMstrId() {
		return crsMstrId;
	}
	public String getSmstrChrtId() {
		return smstrChrtId;
	}
	public String getCtgrnm() {
		return ctgrnm;
	}
	public String getCtgrExpln() {
		return ctgrExpln;
	}
	public Integer getCtgrSeqno() {
		return ctgrSeqno;
	}
	public String getShrnyn() {
		return shrnyn;
	}
	public String getDelyn() {
		return delyn;
	}
	public String getQbnkQstnGbncd() {
		return qbnkQstnGbncd;
	}
	public void setQbnkCtgrId(String qbnkCtgrId) {
		this.qbnkCtgrId = qbnkCtgrId;
	}
	public void setUpQbnkCtgrId(String upQbnkCtgrId) {
		this.upQbnkCtgrId = upQbnkCtgrId;
	}
	public void setCrsMstrId(String crsMstrId) {
		this.crsMstrId = crsMstrId;
	}
	public void setSmstrChrtId(String smstrChrtId) {
		this.smstrChrtId = smstrChrtId;
	}
	public void setCtgrnm(String ctgrnm) {
		this.ctgrnm = ctgrnm;
	}
	public void setCtgrExpln(String ctgrExpln) {
		this.ctgrExpln = ctgrExpln;
	}
	public void setCtgrSeqno(Integer ctgrSeqno) {
		this.ctgrSeqno = ctgrSeqno;
	}
	public void setShrnyn(String shrnyn) {
		this.shrnyn = shrnyn;
	}
	public void setDelyn(String delyn) {
		this.delyn = delyn;
	}
	public void setQbnkQstnGbncd(String qbnkQstnGbncd) {
		this.qbnkQstnGbncd = qbnkQstnGbncd;
	}

}
