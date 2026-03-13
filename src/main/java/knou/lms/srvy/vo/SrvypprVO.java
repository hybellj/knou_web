package knou.lms.srvy.vo;

import knou.lms.common.vo.DefaultVO;

public class SrvypprVO extends DefaultVO {

	private static final long serialVersionUID = 6022239489419508163L;

	// TB_LMS_SRVYPPR ( 설문지 )
	private String  srvypprId;		// 설문지아이디
	private String  srvyId;			// 설문아이디
	private String  srvyTtl;		// 설문제목
	private String  srvyCts;		// 설문내용
	private String  edtrUseyn;		// 편집기사용여부
	private Integer srvySeqno;		// 설문지순번

	public String getSrvypprId() {
		return srvypprId;
	}
	public String getSrvyId() {
		return srvyId;
	}
	public String getSrvyTtl() {
		return srvyTtl;
	}
	public String getSrvyCts() {
		return srvyCts;
	}
	public String getEdtrUseyn() {
		return edtrUseyn;
	}
	public Integer getSrvySeqno() {
		return srvySeqno;
	}
	public void setSrvypprId(String srvypprId) {
		this.srvypprId = srvypprId;
	}
	public void setSrvyId(String srvyId) {
		this.srvyId = srvyId;
	}
	public void setSrvyTtl(String srvyTtl) {
		this.srvyTtl = srvyTtl;
	}
	public void setSrvyCts(String srvyCts) {
		this.srvyCts = srvyCts;
	}
	public void setEdtrUseyn(String edtrUseyn) {
		this.edtrUseyn = edtrUseyn;
	}
	public void setSrvySeqno(Integer srvySeqno) {
		this.srvySeqno = srvySeqno;
	}

}
