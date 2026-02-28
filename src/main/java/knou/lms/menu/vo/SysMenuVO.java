package knou.lms.menu.vo;

import java.util.ArrayList;
import java.util.List;

import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;
import knou.lms.crs.home.vo.CrsHomeBbsMenuVO;

public class SysMenuVO extends DefaultVO {

	private static final long serialVersionUID = 4252183986455972229L;

	private String			authrtGrpcd;
	private String			menuId;
	private String			menuCd;
	private String			menuNm;
	private String         menuEnnm;
	private String         menuNmEn;
	private int				menuLv		= 0;
	private int				menuLvl		= 0;
	private int				menuSeq		= 0;
	private int				menuOdr		= 0;
	private String			menuUrl;
	private String			menuPath;
	private String			menuDesc;
	private String			useYn;
	private String			topMenuYn;
	private String			optnCtgrCd1;
	private String			optnCd1;
	private String			optnValue1;
	private String			optnCtgrCd2;
	private String			optnCd2;
	private String			optnValue2;
	private String			optnCtgrCd3;
	private String			optnCd3;
	private String			optnValue3;
	private String			optnCtgrCd4;
	private String			optnCd4;
	private String			optnValue4;
	private String			optnCtgrCd5;
	private String			optnCd5;
	private String			optnValue5;
	private String			topMenuImg;
	private String			menuImgFileId;
	private String			leftMenuImg;
	private String			leftMenuTitle;
	private String			menuTitle;
	private String			sslYn		= "N";
	private String			divLineUseYn	= "N";

	private String			viewAuth	= "N";
	private String			creAuth		= "N";
	private String			modAuth		= "N";
	private String			delAuth		= "N";
	private int				subCnt		= 0;
	private String			autoMakeYn;

	private SysMenuVO		parentMenu;
	private String			menuPathNm;

	private String			orgId;
	private String			relationYn	= "N";
	private String          orgUse;
	private String          orgNoUse;
	private String          upMenuId;
	private String          parMenuCd;

	private String          useYns;
	private String          menuCds;
	private String          viewAuthGrpCds;

	private List<SysMenuVO> subList;
	private List<CrsHomeBbsMenuVO> bbsList;

	private String menuTycd;

	public String getSslYn() {
		return this.sslYn;
	}

	public void setSslYn(String sslYn) {
		this.sslYn = sslYn;
	}

	public String getDivLineUseYn() {
		return this.divLineUseYn;
	}

	public void setDivLineUseYn(String divlineUseYn) {
		this.divLineUseYn = divlineUseYn;
	}

	/**
	 * @return the topMenuImg
	 */
	public String getTopMenuImg() {
		return this.topMenuImg;
	}


	/**
	 * @param topMenuImg the topMenuImg to set
	 */
	public void setTopMenuImg(String topMenuImg) {
		this.topMenuImg = topMenuImg;
	}


	/**
	 * @return the leftMenuImg
	 */
	public String getMenuImgFileId() {
		return this.menuImgFileId;
	}


	/**
	 * @param leftMenuImg the leftMenuImg to set
	 */
	public void setMenuImgFileId(String menuImgFileId) {
		this.menuImgFileId = menuImgFileId;
	}


	/**
	 * @return the leftMenuTitle
	 */
	public String getLeftMenuTitle() {
		return this.leftMenuTitle;
	}


	/**
	 * @param leftMenuTitle the leftMenuTitle to set
	 */
	public void setLeftMenuTitle(String leftMenuTitle) {
		this.leftMenuTitle = leftMenuTitle;
	}


	/**
	 * @return the menuTitle
	 */
	public String getMenuTitle() {
		return this.menuTitle;
	}


	/**
	 * @param menuTitle the menuTitle to set
	 */
	public void setMenuTitle(String menuTitle) {
		this.menuTitle = menuTitle;
	}

	/**
	 * @return the topMenuYn
	 */
	public String getTopMenuYn() {
		return this.topMenuYn;
	}

	/**
	 * @param topMenuYn the topMenuYn to set
	 */
	public void setTopMenuYn(String topMenuYn) {
		this.topMenuYn = topMenuYn;
	}

	public String getAuthrtGrpcd() {
		return this.authrtGrpcd;
	}

	public void setAuthrtGrpcd(String authrtGrpcd) {
		this.authrtGrpcd = authrtGrpcd;
	}

	public String getMenuId() {
		return this.menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	/*
	 * public String getMenunm() { return this.menunm; }
	 *
	 * public void setMenunm(String menunm) { this.menunm = menunm; }
	 */

	public int getMenuLv() {
		return this.menuLv;
	}

	public void setMenuLv(int menuLv) {
		this.menuLv = menuLv;
	}

	public int getMenuSeq() {
		return this.menuSeq;
	}

	public void setMenuOdr(int menuSeq) {
		this.menuSeq = menuSeq;
	}

	public String getMenuUrl() {
		return this.menuUrl;
	}

	public void setMenuUrl(String menuUrl) {
		this.menuUrl = menuUrl;
	}

	public String getMenuPath() {
		return this.menuPath;
	}

	public void setMenuPath(String menuPath) {
		this.menuPath = menuPath;
	}

	public String getMenuDesc() {
		return this.menuDesc;
	}

	public void setMenuDesc(String menuDesc) {
		this.menuDesc = menuDesc;
	}

	public String getUseYn() {
		return this.useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getOptnCtgrCd1() {
		return this.optnCtgrCd1;
	}

	public void setOptnCtgrCd1(String optnCtgrCd1) {
		this.optnCtgrCd1 = optnCtgrCd1;
	}

	public String getOptnCd1() {
		return this.optnCd1;
	}

	public void setOptnCd1(String optnCd1) {
		this.optnCd1 = optnCd1;
	}

	public String getOptnCtgrCd2() {
		return this.optnCtgrCd2;
	}

	public void setOptnCtgrCd2(String optnCtgrCd2) {
		this.optnCtgrCd2 = optnCtgrCd2;
	}

	public String getOptnCd2() {
		return this.optnCd2;
	}

	public void setOptnCd2(String optnCd2) {
		this.optnCd2 = optnCd2;
	}

	public String getOptnCtgrCd3() {
		return this.optnCtgrCd3;
	}

	public void setOptnCtgrCd3(String optnCtgrCd3) {
		this.optnCtgrCd3 = optnCtgrCd3;
	}

	public String getOptnCd3() {
		return this.optnCd3;
	}

	public void setOptnCd3(String optnCd3) {
		this.optnCd3 = optnCd3;
	}

	public String getOptnCtgrCd4() {
		return this.optnCtgrCd4;
	}

	public void setOptnCtgrCd4(String optnCtgrCd4) {
		this.optnCtgrCd4 = optnCtgrCd4;
	}

	public String getOptnCd4() {
		return this.optnCd4;
	}

	public void setOptnCd4(String optnCd4) {
		this.optnCd4 = optnCd4;
	}

	public String getOptnCtgrCd5() {
		return optnCtgrCd5;
	}

	public void setOptnCtgrCd5(String optnCtgrCd5) {
		this.optnCtgrCd5 = optnCtgrCd5;
	}

	public String getOptnCd5() {
		return optnCd5;
	}

	public void setOptnCd5(String optnCd5) {
		this.optnCd5 = optnCd5;
	}

	public String getViewAuth() {
		return this.viewAuth;
	}

	public void setViewAuth(String viewAuth) {
		this.viewAuth = viewAuth;
	}

	public String getCreAuth() {
		return this.creAuth;
	}

	public void setCreAuth(String creAuth) {
		this.creAuth = creAuth;
	}

	public String getModAuth() {
		return this.modAuth;
	}

	public void setModAuth(String modAuth) {
		this.modAuth = modAuth;
	}

	public String getDelAuth() {
		return this.delAuth;
	}

	public void setDelAuth(String delAuth) {
		this.delAuth = delAuth;
	}

	public int getSubCnt() {
		return this.subCnt;
	}

	public void setSubCnt(int subCnt) {
		this.subCnt = subCnt;
	}

	public int getParMenuLvl() {
		return this.getParentMenu().getMenuLv();
	}

	public void setParMenuLvl(int parMenuLvl) {
		this.getParentMenu().setMenuLv(parMenuLvl);
	}

	public String getParMenuPath() {
		return this.getParentMenu().getMenuPath();
	}

	public void setParMenuPath(String parMenuPath) {
		this.getParentMenu().setMenuPath(parMenuPath);
	}

	public String getParMenuNm() {
		return this.getParentMenu().getMenuNm();
	}

	public void setParMenuNm(String parMenuNm) {
		this.getParentMenu().setMenuNm(parMenuNm);
	}

	public String getOptnValue1() {
		return this.optnValue1;
	}

	public void setOptnValue1(String optnValue1) {
		this.optnValue1 = optnValue1;
	}

	public String getOptnValue2() {
		return this.optnValue2;
	}

	public void setOptnValue2(String optnValue2) {
		this.optnValue2 = optnValue2;
	}

	public String getOptnValue3() {
		return this.optnValue3;
	}

	public void setOptnValue3(String optnValue3) {
		this.optnValue3 = optnValue3;
	}

	public String getOptnValue4() {
		return this.optnValue4;
	}

	public void setOptnValue4(String optnValue4) {
		this.optnValue4 = optnValue4;
	}

	public String getOptnValue5() {
		return this.optnValue5;
	}

	public void setOptnValue5(String optnValue5) {
		this.optnValue5 = optnValue5;
	}

	public List<SysMenuVO> getSubList() {
		if (this.subList == null)
			this.subList = new ArrayList<SysMenuVO>();
		return this.subList;
	}

	public void setSubList(List<SysMenuVO> subList) {
		this.subList = subList;
	}

	public String getMenuPathNm() {
		return this.menuPathNm;
	}

	public void setMenuPathNm(String menuPathNm) {
		this.menuPathNm = menuPathNm;
	}

	public String getAutoMakeYn() {
		return autoMakeYn;
	}

	public void setAutoMakeYn(String autoMakeYn) {
		this.autoMakeYn = autoMakeYn;
	}

	public SysMenuVO getParentMenu() {
		if(this.parentMenu == null) {
			this.parentMenu = new SysMenuVO();
			this.parentMenu.setMenuLv(0);
			this.parentMenu.setMenuPath("");
			this.parentMenu.setMenuNm("ROOT");
		}
		return this.parentMenu;
	}

	public void setParentMenu(SysMenuVO parentMenu) {
		this.parentMenu = parentMenu;
	}


	public void addSubMenu(SysMenuVO childSysMenuVO) {
		childSysMenuVO.setParentMenu(this);
		this.getSubList().add(childSysMenuVO);
	}


	public SysMenuVO searchParentLvl(int searchLvl) {
		if(this.menuLv == searchLvl)
			return this;
		else if (this.menuLv > searchLvl)
			return this.getParentMenu().searchParentLvl(searchLvl);
		else
			return null;
	}

	@Override
	public String toString() {
		return "SysMenuVO [menuId=" + this.menuId + ", menuNm=" + this.menuNm + "]" + super.toString();
	}

	/** 사이트 메뉴 과련 추가 사항 **/
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getRelationYn() {
		return relationYn;
	}
	public void setRelationYn(String relationYn) {
		this.relationYn = relationYn;
	}
	public String getOrgUse() {
		return orgUse;
	}
	public void setOrgUse(String orgUse) {
		this.orgUse = orgUse;
	}
	public String getOrgNoUse() {
		return orgNoUse;
	}
	public void setOrgNoUse(String orgNoUse) {
		this.orgNoUse = orgNoUse;
	}

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public String getUpMenuId() {
        return upMenuId;
    }

    public void setUpMenuId(String upMenuId) {
        this.upMenuId = upMenuId;
    }

    public String getMenuCds() {
        return menuCds;
    }

    public void setMenuCds(String menuCds) {
        this.menuCds = menuCds;
    }

    public String getUseYns() {
        return useYns;
    }

    public void setUseYns(String useYns) {
        this.useYns = useYns;
    }

    public String getMenuEnnm() {
        return menuEnnm;
    }

    public void setMenuEnnm(String menuEnnm) {
        this.menuEnnm = menuEnnm;
    }

    public List<CrsHomeBbsMenuVO> getBbsList() {
        return bbsList;
    }

    public void setBbsList(List<CrsHomeBbsMenuVO> bbsList) {
        this.bbsList = bbsList;
    }

    public String getViewAuthGrpCds() {
        return viewAuthGrpCds;
    }

    public void setViewAuthGrpCds(String viewAuthGrpCds) {
        this.viewAuthGrpCds = viewAuthGrpCds;
    }

	public String getMenuTycd() {
		return menuTycd;
	}

	public void setMenuTycd(String menuTycd) {
		this.menuTycd = menuTycd;
	}

	public String getMenuCd() {
		return menuCd;
	}

	public void setMenuCd(String menuCd) {
		this.menuCd = menuCd;
	}

	public String getMenuNm() {
		return menuNm;
	}

	public String getMenuNmEn() {
		return menuNmEn;
	}

	public int getMenuLvl() {
		return menuLvl;
	}

	public int getMenuOdr() {
		return menuOdr;
	}

	public String getLeftMenuImg() {
		return leftMenuImg;
	}

	public String getParMenuCd() {
		return parMenuCd;
	}

	public void setMenuNm(String menuNm) {
		this.menuNm = menuNm;
	}

	public void setMenuNmEn(String menuNmEn) {
		this.menuNmEn = menuNmEn;
	}

	public void setMenuLvl(int menuLvl) {
		this.menuLvl = menuLvl;
	}

	public void setMenuSeq(int menuSeq) {
		this.menuSeq = menuSeq;
	}

	public void setLeftMenuImg(String leftMenuImg) {
		this.leftMenuImg = leftMenuImg;
	}

	public void setParMenuCd(String parMenuCd) {
		this.parMenuCd = parMenuCd;
	}
}
