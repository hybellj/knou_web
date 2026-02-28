package knou.lms.menu.vo;

import knou.lms.common.vo.DefaultVO;

public class MgrSysMenuVO extends DefaultVO {

	private static final long serialVersionUID = 4252183986455972229L;

	private String			menuType;
	private String			menuCd;
	private String			menuNm;
	private int				menuLvl		= 0;
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
	private String          parMenuCd;
    public String getAuthrtGrpcd() {
        return menuType;
    }
    public void setAuthrtGrpcd(String menuType) {
        this.menuType = menuType;
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
    public void setMenuNm(String menuNm) {
        this.menuNm = menuNm;
    }
    public int getMenuLvl() {
        return menuLvl;
    }
    public void setMenuLvl(int menuLvl) {
        this.menuLvl = menuLvl;
    }
    public int getMenuOdr() {
        return menuOdr;
    }
    public void setMenuOdr(int menuOdr) {
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
    public String getOptnValue1() {
        return optnValue1;
    }
    public void setOptnValue1(String optnValue1) {
        this.optnValue1 = optnValue1;
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
    public String getOptnValue2() {
        return optnValue2;
    }
    public void setOptnValue2(String optnValue2) {
        this.optnValue2 = optnValue2;
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
    public String getOptnValue3() {
        return optnValue3;
    }
    public void setOptnValue3(String optnValue3) {
        this.optnValue3 = optnValue3;
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
    public String getOptnValue4() {
        return optnValue4;
    }
    public void setOptnValue4(String optnValue4) {
        this.optnValue4 = optnValue4;
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
    public String getOptnValue5() {
        return optnValue5;
    }
    public void setOptnValue5(String optnValue5) {
        this.optnValue5 = optnValue5;
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
    public int getSubCnt() {
        return subCnt;
    }
    public void setSubCnt(int subCnt) {
        this.subCnt = subCnt;
    }
    public String getAutoMakeYn() {
        return autoMakeYn;
    }
    public void setAutoMakeYn(String autoMakeYn) {
        this.autoMakeYn = autoMakeYn;
    }
    public String getParMenuCd() {
        return parMenuCd;
    }
    public void setParMenuCd(String parMenuCd) {
        this.parMenuCd = parMenuCd;
    }
}
