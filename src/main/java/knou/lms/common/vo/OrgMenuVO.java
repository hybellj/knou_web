package knou.lms.common.vo;

import java.util.ArrayList;
import java.util.List;

import knou.framework.util.ValidationUtils;

public class OrgMenuVO extends DefaultVO {

	private static final long serialVersionUID = -4478185162564991830L;
	
	private String  menuCd;
	private String  parMenuCd;
	private String  menuType;
	private String  menuNm;
	private Integer menuLvl = 1;
	private Integer menuOdr = 1;
	private String  menuUrl;
	private String  menuPath;
	private String  menuDesc;
	private String  useYn = "Y";
	private String  topMenuYn = "N";
	private String  topMenuImg;
	private String  leftMenuImg;
	private String  leftMenuTitle;
	private String  menuTitle;
	private String  optnCtgrCd1;
	private String  optnCd1;
	private String  optnCtgrCd2;
	private String  optnCd2;
	private String  optnCtgrCd3;
	private String  optnCd3;
	private String  optnCtgrCd4;
	private String  optnCd4;
	private String  optnCtgrCd5;
	private String  optnCd5;
	private String  sslYn;
	private String  divLineUseYn;
	private String  dfltYn = "N";

	private String	viewAuth	= "Y";
	private String	creAuth		= "N";
	private String	modAuth		= "N";
	private String	delAuth		= "N";

	private String  parMenuNm;
	private Integer parMenuLvl = 0;

	private Integer subCnt = 0;

	private String  autoMakeYn = "Y";
	private String  menuViewYn = "Y";

	private OrgMenuVO parentMenu;
	
	private String knowCtgrs;
	private String knowTypes;

	private List<OrgMenuVO>	subList;

	private String menuTypeNm;

	
	public String getKnowTypes() {
		return knowTypes;
	}

	public void setKnowTypes(String knowTypes) {
		this.knowTypes = knowTypes;
	}

	public String getKnowCtgrs() {
		return knowCtgrs;
	}

	public void setKnowCtgrs(String knowCtgrs) {
		this.knowCtgrs = knowCtgrs;
	}

	public String getMenuCd() {
		return menuCd;
	}

	public void setMenuCd(String menuCd) {
		this.menuCd = menuCd;
	}

	public String getParMenuCd() {
		return parMenuCd;
	}

	public void setParMenuCd(String parMenuCd) {
		this.parMenuCd = parMenuCd;
	}

	public String getAuthrtGrpcd() {
		return menuType;
	}

	public void setAuthrtGrpcd(String menuType) {
		this.menuType = menuType;
	}

	public String getMenuNm() {
		return menuNm;
	}

	public void setMenuNm(String menuNm) {
		this.menuNm = menuNm;
	}

	public Integer getMenuLvl() {
		return menuLvl;
	}

	public void setMenuLvl(Integer menuLvl) {
		this.menuLvl = menuLvl;
	}

	public Integer getMenuOdr() {
		return menuOdr;
	}

	public void setMenuOdr(Integer menuOdr) {
		this.menuOdr = menuOdr;
	}

	public String getMenuUrl() {
		return menuUrl;
	}

	public void setMenuUrl(String menuUrl) {
		this.menuUrl = menuUrl;
	}

	public String getMenuPath() {
		return menuPath;
	}

	public void setMenuPath(String menuPath) {
		this.menuPath = menuPath;
	}

	public String getMenuDesc() {
		return menuDesc;
	}

	public void setMenuDesc(String menuDesc) {
		this.menuDesc = menuDesc;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getTopMenuYn() {
		return topMenuYn;
	}

	public void setTopMenuYn(String topMenuYn) {
		this.topMenuYn = topMenuYn;
	}

	public String getTopMenuImg() {
		return topMenuImg;
	}

	public void setTopMenuImg(String topMenuImg) {
		this.topMenuImg = topMenuImg;
	}

	public String getLeftMenuImg() {
		return leftMenuImg;
	}

	public void setLeftMenuImg(String leftMenuImg) {
		this.leftMenuImg = leftMenuImg;
	}

	public String getLeftMenuTitle() {
		return leftMenuTitle;
	}

	public void setLeftMenuTitle(String leftMenuTitle) {
		this.leftMenuTitle = leftMenuTitle;
	}

	public String getMenuTitle() {
		return menuTitle;
	}

	public void setMenuTitle(String menuTitle) {
		this.menuTitle = menuTitle;
	}

	public String getOptnCtgrCd1() {
		return optnCtgrCd1;
	}

	public void setOptnCtgrCd1(String optnCtgrCd1) {
		this.optnCtgrCd1 = optnCtgrCd1;
	}

	public String getOptnCd1() {
		return optnCd1;
	}

	public void setOptnCd1(String optnCd1) {
		this.optnCd1 = optnCd1;
	}

	public String getOptnCtgrCd2() {
		return optnCtgrCd2;
	}

	public void setOptnCtgrCd2(String optnCtgrCd2) {
		this.optnCtgrCd2 = optnCtgrCd2;
	}

	public String getOptnCd2() {
		return optnCd2;
	}

	public void setOptnCd2(String optnCd2) {
		this.optnCd2 = optnCd2;
	}

	public String getOptnCtgrCd3() {
		return optnCtgrCd3;
	}

	public void setOptnCtgrCd3(String optnCtgrCd3) {
		this.optnCtgrCd3 = optnCtgrCd3;
	}

	public String getOptnCd3() {
		return optnCd3;
	}

	public void setOptnCd3(String optnCd3) {
		this.optnCd3 = optnCd3;
	}

	public String getOptnCtgrCd4() {
		return optnCtgrCd4;
	}

	public void setOptnCtgrCd4(String optnCtgrCd4) {
		this.optnCtgrCd4 = optnCtgrCd4;
	}

	public String getOptnCd4() {
		return optnCd4;
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

	public String getSslYn() {
		return sslYn;
	}

	public void setSslYn(String sslYn) {
		this.sslYn = sslYn;
	}

	public String getDivLineUseYn() {
		return divLineUseYn;
	}

	public void setDivLineUseYn(String divLineUseYn) {
		this.divLineUseYn = divLineUseYn;
	}

	public String getDfltYn() {
		return dfltYn;
	}

	public void setDfltYn(String dfltYn) {
		this.dfltYn = dfltYn;
	}

	public String getParMenuNm() {
		return parMenuNm;
	}

	public void setParMenuNm(String parMenuNm) {
		this.parMenuNm = parMenuNm;
	}

	public Integer getParMenuLvl() {
		return parMenuLvl;
	}

	public void setParMenuLvl(Integer parMenuLvl) {
		this.parMenuLvl = parMenuLvl;
	}

	public Integer getSubCnt() {
		return subCnt;
	}

	public void setSubCnt(Integer subCnt) {
		this.subCnt = subCnt;
	}

	public String getAutoMakeYn() {
		return autoMakeYn;
	}

	public void setAutoMakeYn(String autoMakeYn) {
		this.autoMakeYn = autoMakeYn;
	}

	public String getViewAuth() {
		return viewAuth;
	}

	public void setViewAuth(String viewAuth) {
		this.viewAuth = viewAuth;
	}

	public String getCreAuth() {
		return creAuth;
	}

	public void setCreAuth(String creAuth) {
		this.creAuth = creAuth;
	}

	public String getModAuth() {
		return modAuth;
	}

	public void setModAuth(String modAuth) {
		this.modAuth = modAuth;
	}

	public String getDelAuth() {
		return delAuth;
	}

	public void setDelAuth(String delAuth) {
		this.delAuth = delAuth;
	}

	public List<OrgMenuVO> getSubList() {
		if(ValidationUtils.isEmpty(subList)) subList = new ArrayList<OrgMenuVO>();
		return subList;
	}

	public void setSubList(List<OrgMenuVO> subList) {
		this.subList = subList;
	}

	public void addSubMenu(OrgMenuVO vo) {
		vo.setParentMenu(this);
		this.getSubList().add(vo);
	}

	public OrgMenuVO getParentMenu() {
		if(this.parentMenu == null) {
			this.parentMenu = new OrgMenuVO();
			this.parentMenu.setMenuLvl(0);
			this.parentMenu.setMenuPath("");
			this.parentMenu.setMenuNm("ROOTMENU");
		}
		return this.parentMenu;
	}

	public void setParentMenu(OrgMenuVO parentMenu) {
		this.parentMenu = parentMenu;
	}

	public OrgMenuVO searchParentLvl(int searchLvl) {
		if(this.menuLvl == searchLvl)
			return this;
		else if (this.menuLvl > searchLvl)
			return this.getParentMenu().searchParentLvl(searchLvl);
		else
			return null;
	}

	public String getMenuViewYn() {
		return menuViewYn;
	}

	public void setMenuViewYn(String menuViewYn) {
		this.menuViewYn = menuViewYn;
	}

    public String getMenuTypeNm() {
        return menuTypeNm;
    }

    public void setMenuTypeNm(String menuTypeNm) {
        this.menuTypeNm = menuTypeNm;
    }

}