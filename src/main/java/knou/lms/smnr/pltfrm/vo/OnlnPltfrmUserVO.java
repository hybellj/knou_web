package knou.lms.smnr.pltfrm.vo;

import knou.lms.common.vo.DefaultVO;

public class OnlnPltfrmUserVO extends DefaultVO {

	private static final long serialVersionUID = 5059887110577814957L;

	// TB_LMS_ONLN_PLTFRM_USER ( 온라인플랫폼사용자 )
	private String onlnPltfrmUserId;		// 온라인플랫폼사용자아이디
	private String onlnPltfrmAuthrtId;      // 온라인플랫폼권한아이디
	private String pltfrmUserId;            // 플랫폼사용자아이디
	private String pltfrmUserEml;           // 플랫폼사용자이메일
	private String pltfrmUserTycd;          // 플랫폼사용자유형코드
	private String pltfrmUserStscd;         // 플랫폼사용자상태코드

	public String getOnlnPltfrmUserId() {
		return onlnPltfrmUserId;
	}
	public String getOnlnPltfrmAuthrtId() {
		return onlnPltfrmAuthrtId;
	}
	public String getPltfrmUserId() {
		return pltfrmUserId;
	}
	public String getPltfrmUserEml() {
		return pltfrmUserEml;
	}
	public String getPltfrmUserTycd() {
		return pltfrmUserTycd;
	}
	public String getPltfrmUserStscd() {
		return pltfrmUserStscd;
	}
	public void setOnlnPltfrmUserId(String onlnPltfrmUserId) {
		this.onlnPltfrmUserId = onlnPltfrmUserId;
	}
	public void setOnlnPltfrmAuthrtId(String onlnPltfrmAuthrtId) {
		this.onlnPltfrmAuthrtId = onlnPltfrmAuthrtId;
	}
	public void setPltfrmUserId(String pltfrmUserId) {
		this.pltfrmUserId = pltfrmUserId;
	}
	public void setPltfrmUserEml(String pltfrmUserEml) {
		this.pltfrmUserEml = pltfrmUserEml;
	}
	public void setPltfrmUserTycd(String pltfrmUserTycd) {
		this.pltfrmUserTycd = pltfrmUserTycd;
	}
	public void setPltfrmUserStscd(String pltfrmUserStscd) {
		this.pltfrmUserStscd = pltfrmUserStscd;
	}
}