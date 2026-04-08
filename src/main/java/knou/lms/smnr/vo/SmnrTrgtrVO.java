package knou.lms.smnr.vo;

import knou.lms.common.vo.DefaultVO;

public class SmnrTrgtrVO extends DefaultVO {

	private static final long serialVersionUID = -1298309804434808911L;

	// TB_LMS_SMNR_TRGTR ( 세미나대상자 )
	private String smnrTrgtrId;			// 세미나대상자아이디
	private String smnrId;              // 세미나아이디
	private String onlnMeetngrmId;      // 온라인회의실아이디
	private String trgtrCntnUrl;        // 대상자별접속URL
	private String preregyn;            // 사전등록여부

	public String getSmnrTrgtrId() {
		return smnrTrgtrId;
	}
	public String getSmnrId() {
		return smnrId;
	}
	public String getOnlnMeetngrmId() {
		return onlnMeetngrmId;
	}
	public String getTrgtrCntnUrl() {
		return trgtrCntnUrl;
	}
	public String getPreregyn() {
		return preregyn;
	}
	public void setSmnrTrgtrId(String smnrTrgtrId) {
		this.smnrTrgtrId = smnrTrgtrId;
	}
	public void setSmnrId(String smnrId) {
		this.smnrId = smnrId;
	}
	public void setOnlnMeetngrmId(String onlnMeetngrmId) {
		this.onlnMeetngrmId = onlnMeetngrmId;
	}
	public void setTrgtrCntnUrl(String trgtrCntnUrl) {
		this.trgtrCntnUrl = trgtrCntnUrl;
	}
	public void setPreregyn(String preregyn) {
		this.preregyn = preregyn;
	}
}
