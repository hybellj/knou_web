package knou.lms.smnr.pltfrm.vo;

import knou.lms.common.vo.DefaultVO;

public class OnlnPltfrmStngVO extends DefaultVO {

	private static final long serialVersionUID = 1249127776337570080L;

	// TB_LMS_ONLN_PLTFRM_STNG ( 온라인플랫폼설정 )
	private String onlnPltfrmStngId;		// 온라인플랫폼설정아이디
	private String pltfrmGbncd;         	// 플랫폼구분코드
	private String pltfrmCntnId;        	// 플랫폼접속아이디
	private String pltfrmCntnClientId;  	// 플랫폼접속클라이언트아이디
	private String pltfrmCntnClientPswd;    // 플랫폼접속클라이언트비밀번호

	public String getOnlnPltfrmStngId() {
		return onlnPltfrmStngId;
	}
	public String getPltfrmGbncd() {
		return pltfrmGbncd;
	}
	public String getPltfrmCntnId() {
		return pltfrmCntnId;
	}
	public String getPltfrmCntnClientId() {
		return pltfrmCntnClientId;
	}
	public String getPltfrmCntnClientPswd() {
		return pltfrmCntnClientPswd;
	}
	public void setOnlnPltfrmStngId(String onlnPltfrmStngId) {
		this.onlnPltfrmStngId = onlnPltfrmStngId;
	}
	public void setPltfrmGbncd(String pltfrmGbncd) {
		this.pltfrmGbncd = pltfrmGbncd;
	}
	public void setPltfrmCntnId(String pltfrmCntnId) {
		this.pltfrmCntnId = pltfrmCntnId;
	}
	public void setPltfrmCntnClientId(String pltfrmCntnClientId) {
		this.pltfrmCntnClientId = pltfrmCntnClientId;
	}
	public void setPltfrmCntnClientPswd(String pltfrmCntnClientPswd) {
		this.pltfrmCntnClientPswd = pltfrmCntnClientPswd;
	}
}
