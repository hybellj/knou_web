package knou.lms.menu.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 테이블: TB_LMS_MENU_USE_ORG
 */
public class MenuUseOrgVO extends DefaultVO {
	private static final long serialVersionUID = -8854136686629009782L;
	private String		menuUseId;		// 메뉴사용아이디
	private String		menuId;			// 메뉴아이디
	private String		orgId;			// 기관아이디
	private String		useyn;			// 사용여부
	private String 		menuAuthTycd;	// 메뉴권한유형코드
	private String		menuGbncd;		// 메뉴구분코드

	public String getMenuUseId() {
		return menuUseId;
	}

	public void setMenuUseId(String menuUseId) {
		this.menuUseId = menuUseId;
	}

	public String getMenuId() {
		return menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getUseyn() {
		return useyn;
	}

	public void setUseyn(String useyn) {
		this.useyn = useyn;
	}

	public String getMenuAuthTycd() {
		return menuAuthTycd;
	}

	public void setMenuAuthTycd(String menuAuthTycd) {
		this.menuAuthTycd = menuAuthTycd;
	}

	public String getMenuGbncd() {
		return menuGbncd;
	}

	public void setMenuGbncd(String menuGbncd) {
		this.menuGbncd = menuGbncd;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}


}
