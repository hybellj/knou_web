package knou.lms.srvy.vo;

import knou.lms.common.vo.DefaultVO;

public class SrvyQstnVO extends DefaultVO {

	private static final long serialVersionUID = 5955525735843376439L;

	// TB_LMS_SRVY_QSTN ( 설문문항 )
	private String  srvyQstnId;			// 설문문항아이디
	private String  srvypprId;			// 설문지아이디
	private String  qstnGbncd;			// 문항구분코드
	private String  qstnRspnsTycd;		// 문항답변유형코드
	private Integer qstnSeqno;			// 문항순번
	private String  qstnTtl;			// 문항제목
	private String  qstnCts;            // 문항내용
	private String  esntlRspnsyn;       // 필수답변여부
	private String  etcInptUseyn;       // 기타입력사용여부
	private String  edtrUseyn;          // 편집기사용여부
	private String  srvyMvmnUseyn;      // 설문이동사용여부
	private String  delyn;				// 삭제여부

	public String getSrvyQstnId() {
		return srvyQstnId;
	}
	public String getSrvypprId() {
		return srvypprId;
	}
	public String getQstnGbncd() {
		return qstnGbncd;
	}
	public String getQstnRspnsTycd() {
		return qstnRspnsTycd;
	}
	public Integer getQstnSeqno() {
		return qstnSeqno;
	}
	public String getQstnTtl() {
		return qstnTtl;
	}
	public String getQstnCts() {
		return qstnCts;
	}
	public String getEsntlRspnsyn() {
		return esntlRspnsyn;
	}
	public String getEtcInptUseyn() {
		return etcInptUseyn;
	}
	public String getEdtrUseyn() {
		return edtrUseyn;
	}
	public String getSrvyMvmnUseyn() {
		return srvyMvmnUseyn;
	}
	public String getDelyn() {
		return delyn;
	}
	public void setSrvyQstnId(String srvyQstnId) {
		this.srvyQstnId = srvyQstnId;
	}
	public void setSrvypprId(String srvypprId) {
		this.srvypprId = srvypprId;
	}
	public void setQstnGbncd(String qstnGbncd) {
		this.qstnGbncd = qstnGbncd;
	}
	public void setQstnRspnsTycd(String qstnRspnsTycd) {
		this.qstnRspnsTycd = qstnRspnsTycd;
	}
	public void setQstnSeqno(Integer qstnSeqno) {
		this.qstnSeqno = qstnSeqno;
	}
	public void setQstnTtl(String qstnTtl) {
		this.qstnTtl = qstnTtl;
	}
	public void setQstnCts(String qstnCts) {
		this.qstnCts = qstnCts;
	}
	public void setEsntlRspnsyn(String esntlRspnsyn) {
		this.esntlRspnsyn = esntlRspnsyn;
	}
	public void setEtcInptUseyn(String etcInptUseyn) {
		this.etcInptUseyn = etcInptUseyn;
	}
	public void setEdtrUseyn(String edtrUseyn) {
		this.edtrUseyn = edtrUseyn;
	}
	public void setSrvyMvmnUseyn(String srvyMvmnUseyn) {
		this.srvyMvmnUseyn = srvyMvmnUseyn;
	}
	public void setDelyn(String delyn) {
		this.delyn = delyn;
	}

}
