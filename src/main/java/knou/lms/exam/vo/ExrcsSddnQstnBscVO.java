package knou.lms.exam.vo;

import knou.lms.common.vo.DefaultVO;

public class ExrcsSddnQstnBscVO extends DefaultVO {

	private static final long serialVersionUID = 19870452996485776L;

	// TB_LMS_EXRCS_SDDN_QSTN_BSC ( 연습돌발문항기본 )
	private String exrcsSddnQstnBscId;		// 연습돌발문항기본아이디
	private String qstnTtl;                 // 문항제목
	private String qstnCts;                 // 문항내용
	private String qstnsCmptnyn;            // 문제출제완료여부
	private String qstnGrpId;               // 문항그룹아이디
	private String lctrWknoSchdlId;         // 강의주차일정아이디
	private String qstnGbncd;               // 문항구분코드
	private String delyn;                   // 삭제여부

	public String getExrcsSddnQstnBscId() {
		return exrcsSddnQstnBscId;
	}
	public String getQstnTtl() {
		return qstnTtl;
	}
	public String getQstnCts() {
		return qstnCts;
	}
	public String getQstnsCmptnyn() {
		return qstnsCmptnyn;
	}
	public String getQstnGrpId() {
		return qstnGrpId;
	}
	public String getLctrWknoSchdlId() {
		return lctrWknoSchdlId;
	}
	public String getQstnGbncd() {
		return qstnGbncd;
	}
	public String getDelyn() {
		return delyn;
	}
	public void setExrcsSddnQstnBscId(String exrcsSddnQstnBscId) {
		this.exrcsSddnQstnBscId = exrcsSddnQstnBscId;
	}
	public void setQstnTtl(String qstnTtl) {
		this.qstnTtl = qstnTtl;
	}
	public void setQstnCts(String qstnCts) {
		this.qstnCts = qstnCts;
	}
	public void setQstnsCmptnyn(String qstnsCmptnyn) {
		this.qstnsCmptnyn = qstnsCmptnyn;
	}
	public void setQstnGrpId(String qstnGrpId) {
		this.qstnGrpId = qstnGrpId;
	}
	public void setLctrWknoSchdlId(String lctrWknoSchdlId) {
		this.lctrWknoSchdlId = lctrWknoSchdlId;
	}
	public void setQstnGbncd(String qstnGbncd) {
		this.qstnGbncd = qstnGbncd;
	}
	public void setDelyn(String delyn) {
		this.delyn = delyn;
	}
}
