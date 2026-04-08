package knou.lms.smnr.pltfrm.vo;

import knou.lms.common.vo.DefaultVO;

public class OnlnPltfrmAuthrtVO extends DefaultVO {

	private static final long serialVersionUID = 2636256590893924243L;

	// TB_LMS_ONLN_PLTFRM_AUTHRT ( 온라인플랫폼권한 )
	private String onlnPltfrmAuthrtId;		// 온라인플랫폼권한아이디
	private String onlnPltfrmStngId;		// 온라인플랫폼설정아이디
	private String authrtTkn;				// 권한토큰
	private String tknExpDttm;              // 토큰만료일시
	private String authrtEml;               // 권한이메일

	public String getOnlnPltfrmAuthrtId() {
		return onlnPltfrmAuthrtId;
	}
	public String getOnlnPltfrmStngId() {
		return onlnPltfrmStngId;
	}
	public String getAuthrtTkn() {
		return authrtTkn;
	}
	public String getTknExpDttm() {
		return tknExpDttm;
	}
	public String getAuthrtEml() {
		return authrtEml;
	}
	public void setOnlnPltfrmAuthrtId(String onlnPltfrmAuthrtId) {
		this.onlnPltfrmAuthrtId = onlnPltfrmAuthrtId;
	}
	public void setOnlnPltfrmStngId(String onlnPltfrmStngId) {
		this.onlnPltfrmStngId = onlnPltfrmStngId;
	}
	public void setAuthrtTkn(String authrtTkn) {
		this.authrtTkn = authrtTkn;
	}
	public void setTknExpDttm(String tknExpDttm) {
		this.tknExpDttm = tknExpDttm;
	}
	public void setAuthrtEml(String authrtEml) {
		this.authrtEml = authrtEml;
	}
}
