package knou.lms.menu.vo;

import java.util.ArrayList;
import java.util.List;

import knou.lms.bbs.vo.BbsVO;
import knou.lms.common.vo.DefaultVO;

/**
 *  테이블: TB_LMS_MENU, TB_LMS_MENU_USE_ORG
 */
public class MenuVO extends DefaultVO {

	private static final long serialVersionUID = 4170716267411986828L;

    /* TB_LMS_MENU */
	//private String		menuId;			// 메뉴아이디 --> DefaultVO에 정의
	//private String 		upMenuId;		// 상위메뉴아이디 --> DefaultVO에 정의
	private String		myTopMenuId;		// 가장상위메뉴아이디
	private String 		menunm;			// 메뉴명
	private String 		menuEnnm;		// 메뉴영문명
	private String 		menuExpln;		// 메뉴설명
	private String 		menuUrl;		// 메뉴URL
	private String 		menuPath;		// 메뉴경로
	private int 		menuLv;			// 메뉴레벨
	private int 		menuSeq;		// 메뉴순서
	private String 		menuAuthTycd;	// 메뉴권한유형코드
	private String 		menuTtl;		// 메뉴제목
	private String 		menuInqyn;		// 메뉴조회여부
	private String 		menuUseyn;		// 메뉴사용여부
	private String 		bscyn;			// 기본여부
	private String 		brdrlnUseyn;	// 경계선사용여부
	private String 		sslUseyn;		// SSL사용여부

	private String 		menuImgFileId;	// 이미지 파일 아이디
	private String 		menuGbncd;		// 메뉴구분코드
	private String 		linkTargetTycd;	// 링크타겟유형코드
	private String 		menuTycd;		// 메뉴유형코드

	private List<MenuVO> subMenuList;	// 서브메뉴 목록
	private List<BbsVO>  subBbsList;	// 서브 게시판 목록
	private boolean	menuOn = false;	// 메뉴 On  (선택된 메뉴)

	private String 		authrtId;       // 권한 ID
	private String 		writeyn;        // 쓰기 허용 여부

	public String 	toString() {
		return new StringBuffer().append("[menuId=" + this.getMenuId() +
				", myTopMenuId=" + this.getMyTopMenuId() +
				", upMenuId=" + this.getUpMenuId() +
				", menunm=" + menunm + ", menuLv=" + menuLv +
				", menuSeq=" + menuSeq + ", orgId=" + this.getOrgId()).toString();
	}

	public MenuVO () {}

	public MenuVO copy() {

	    MenuVO copy = new MenuVO();

	    copy.setMyTopMenuId(this.getMyTopMenuId());

	    copy.setMenuId(this.getMenuId());
	    copy.setUpMenuId(this.getUpMenuId());
	    copy.setUpMenuIds(this.getUpMenuIds());

	    copy.setMenunm(this.getMenunm());
	    copy.setMenuUrl(this.getMenuUrl());

	    copy.setMenuAuthTycd(this.getMenuAuthTycd());
	    copy.setMenuGbncd(this.getMenuGbncd());

	    copy.setLinkTargetTycd(this.getLinkTargetTycd());

	    copy.setOrgId(this.getOrgId());

	    if (this.getSubMenuList() != null) {

	        List<MenuVO> subList = new ArrayList<>();

	        for (MenuVO sub : this.getSubMenuList()) {
	            subList.add(sub.copy());
	        }

	        copy.setSubMenuList(subList);
	    }

	    return copy;
	}

	@Override
	public String getMenuId() {
	    return super.getMenuId();
	}

	@Override
	public String getUpMenuId() {
	    return super.getUpMenuId();
	}

    public String getMyTopMenuId() {
		return myTopMenuId;
	}

	public void setMyTopMenuId(String myTopMenuId) {
		this.myTopMenuId = myTopMenuId;
	}

	/* TB_LMS_MENU_USE_ORG */
    private String      menuUseId;  // 메뉴사용아이디
    private String      useyn;      // 사용여부

    public String getMenunm() {
		return menunm;
	}

	public void setMenunm(String menunm) {
		this.menunm = menunm;
	}

	public String getMenuEnnm() {
		return menuEnnm;
	}

	public void setMenuEnnm(String menuEnnm) {
		this.menuEnnm = menuEnnm;
	}

	public String getMenuExpln() {
		return menuExpln;
	}

	public void setMenuExpln(String menuExpln) {
		this.menuExpln = menuExpln;
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

	public int getMenuLv() {
		return menuLv;
	}

	public void setMenuLv(int menuLv) {
		this.menuLv = menuLv;
	}

	public int getMenuSeq() {
		return menuSeq;
	}

	public void setMenuSeq(int menuSeq) {
		this.menuSeq = menuSeq;
	}

	public String getMenuTycd() {
		return menuTycd;
	}

	public void setMenuTycd(String menuTycd) {
		this.menuTycd = menuTycd;
	}

	public String getMenuTtl() {
		return menuTtl;
	}

	public void setMenuTtl(String menuTtl) {
		this.menuTtl = menuTtl;
	}

	public String getMenuInqyn() {
		return menuInqyn;
	}

	public void setMenuInqyn(String menuInqyn) {
		this.menuInqyn = menuInqyn;
	}

	public String getMenuUseyn() {
		return menuUseyn;
	}

	public void setMenuUseyn(String menuUseyn) {
		this.menuUseyn = menuUseyn;
	}

	public String getBscyn() {
		return bscyn;
	}

	public void setBscyn(String bscyn) {
		this.bscyn = bscyn;
	}

	public String getBrdrlnUseyn() {
		return brdrlnUseyn;
	}

	public void setBrdrlnUseyn(String brdrlnUseyn) {
		this.brdrlnUseyn = brdrlnUseyn;
	}

	public String getSslUseyn() {
		return sslUseyn;
	}

	public void setSslUseyn(String sslUseyn) {
		this.sslUseyn = sslUseyn;
	}

	public String getMenuImgFileId() {
		return menuImgFileId;
	}

	public void setMenuImgFileId(String menuImgFileId) {
		this.menuImgFileId = menuImgFileId;
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

	public List<MenuVO> getSubMenuList() {
		return subMenuList;
	}

	public void setSubMenuList(List<MenuVO> subMenuList) {
		this.subMenuList = subMenuList;
	}

	public List<BbsVO> getSubBbsList() {
		return subBbsList;
	}

	public void setSubBbsList(List<BbsVO> subBbsList) {
		this.subBbsList = subBbsList;
	}

	public String getLinkTargetTycd() {
		return linkTargetTycd;
	}

	public void setLinkTargetTycd(String linkTargetTycd) {
		this.linkTargetTycd = linkTargetTycd;
	}

	public String getMenuAuthTycd() {
		return menuAuthTycd;
	}

	public void setMenuAuthTycd(String menuAuthTycd) {
		this.menuAuthTycd = menuAuthTycd;
	}

	public boolean isMenuOn() {
		return menuOn;
	}

	public void setMenuOn(boolean menuOn) {
		this.menuOn = menuOn;
	}

    public String getMenuUseId() {
        return menuUseId;
    }

    public void setMenuUseId(String menuUseId) {
        this.menuUseId = menuUseId;
    }

    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
    }

	public String getAuthrtId() {
		return authrtId;
	}

	public void setAuthrtId(String authrtId) {
		this.authrtId = authrtId;
	}

	public String getWriteyn() {
		return writeyn;
	}

	public void setWriteyn(String writeyn) {
		this.writeyn = writeyn;
	}
}
