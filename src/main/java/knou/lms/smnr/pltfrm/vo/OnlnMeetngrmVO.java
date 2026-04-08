package knou.lms.smnr.pltfrm.vo;

import knou.lms.common.vo.DefaultVO;

public class OnlnMeetngrmVO extends DefaultVO {

	private static final long serialVersionUID = 5492639781286615145L;

	// TB_LMS_ONLN_MEETNGRM ( 온라인회의실 )
	private String onlnMeetngrmId;			// 온라인회의실아이디
	private String onlnPltfrmUserId;    	// 온라인플랫폼사용자아이디
	private String smnrId;                  // 세미나아이디
	private String meetngrmUrl;             // 회의실접속URL
	private String meetngrmId;              // 회의실아이디
	private String meetngrmSdttm;           // 회의실시작일시
	private String meetngrmEdttm;           // 회의실종료일시
	private String meetngrmPswd;            // 회의실비밀번호
	private String meetngrmUuid;			// 회의실UUID

	public String getOnlnMeetngrmId() {
		return onlnMeetngrmId;
	}
	public String getOnlnPltfrmUserId() {
		return onlnPltfrmUserId;
	}
	public String getSmnrId() {
		return smnrId;
	}
	public String getMeetngrmUrl() {
		return meetngrmUrl;
	}
	public String getMeetngrmId() {
		return meetngrmId;
	}
	public String getMeetngrmSdttm() {
		return meetngrmSdttm;
	}
	public String getMeetngrmEdttm() {
		return meetngrmEdttm;
	}
	public String getMeetngrmPswd() {
		return meetngrmPswd;
	}
	public String getMeetngrmUuid() {
		return meetngrmUuid;
	}
	public void setOnlnMeetngrmId(String onlnMeetngrmId) {
		this.onlnMeetngrmId = onlnMeetngrmId;
	}
	public void setOnlnPltfrmUserId(String onlnPltfrmUserId) {
		this.onlnPltfrmUserId = onlnPltfrmUserId;
	}
	public void setSmnrId(String smnrId) {
		this.smnrId = smnrId;
	}
	public void setMeetngrmUrl(String meetngrmUrl) {
		this.meetngrmUrl = meetngrmUrl;
	}
	public void setMeetngrmId(String meetngrmId) {
		this.meetngrmId = meetngrmId;
	}
	public void setMeetngrmSdttm(String meetngrmSdttm) {
		this.meetngrmSdttm = meetngrmSdttm;
	}
	public void setMeetngrmEdttm(String meetngrmEdttm) {
		this.meetngrmEdttm = meetngrmEdttm;
	}
	public void setMeetngrmPswd(String meetngrmPswd) {
		this.meetngrmPswd = meetngrmPswd;
	}
	public void setMeetngrmUuid(String meetngrmUuid) {
		this.meetngrmUuid = meetngrmUuid;
	}
}
