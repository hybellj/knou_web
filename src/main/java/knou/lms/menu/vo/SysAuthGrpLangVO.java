package knou.lms.menu.vo;

import knou.lms.common.vo.DefaultVO;

public class SysAuthGrpLangVO extends DefaultVO{

	private static final long serialVersionUID = -8832599594151509739L;
	private String  menuType;
	private String  authGrpDesc;
	
	public String getAuthGrpDesc() {
		return authGrpDesc;
	}
	public void setAuthGrpDesc(String authGrpDesc) {
		this.authGrpDesc = authGrpDesc;
	}
}
