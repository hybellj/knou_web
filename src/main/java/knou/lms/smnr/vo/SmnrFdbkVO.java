package knou.lms.smnr.vo;

import knou.lms.common.vo.DefaultVO;

public class SmnrFdbkVO extends DefaultVO {

	private static final long serialVersionUID = 4044750492651096315L;

	// TB_LMS_SMNR_FDBK ( 세미나피드백 )
	private String smnrFdbkId;		// 세미나피드백아이디
	private String smnrId;          // 세미나아이디
	private String fdbkCts;         // 피드백내용
	private String delyn;           // 삭제여부

	public String getSmnrFdbkId() {
		return smnrFdbkId;
	}
	public String getSmnrId() {
		return smnrId;
	}
	public String getFdbkCts() {
		return fdbkCts;
	}
	public String getDelyn() {
		return delyn;
	}
	public void setSmnrFdbkId(String smnrFdbkId) {
		this.smnrFdbkId = smnrFdbkId;
	}
	public void setSmnrId(String smnrId) {
		this.smnrId = smnrId;
	}
	public void setFdbkCts(String fdbkCts) {
		this.fdbkCts = fdbkCts;
	}
	public void setDelyn(String delyn) {
		this.delyn = delyn;
	}
}
