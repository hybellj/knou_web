package knou.lms.menu.vo;

import java.util.List;

import knou.lms.bbs.vo.BbsVO;
import knou.lms.common.vo.DefaultVO;

/**
 *  테이블: TB_LMS_MENU
 */
public class MenuVO extends DefaultVO {
	private static final long serialVersionUID = 4170716267411986828L;
	private String		menuId;			// 메뉴아이디
	private String 		upMenuId;		// 상위메뉴아이디
	private String 		menunm;			// 메뉴명
	private String 		menuEnnm;		// 메뉴영문명
	private String 		menuExpln;		// 메뉴설명
	private String 		menuUrl;		// 메뉴URL
	private String 		menuPath;		// 메뉴경로
	private int 		menuLv;			// 메뉴레벨
	private int 		menuSeq;		// 메뉴순서
	private String 		menuTycd;		// 메뉴유형코드
	private String 		menuTtl;		// 메뉴제목
	private String 		menuInqyn;		// 메뉴조회여부
	private String 		menuUseyn;		// 메뉴사용여부
	private String 		bscyn;			// 기본여부
	private String 		brdrlnUseyn;	// 경계선사용여부
	private String 		sslUseyn;		// SSL사용여부
	private String 		menuImgFileId;	// 이미지 파일 아이디
	private String 		menuGbncd;		// 메뉴구분코드

	private List<MenuVO> subMenuList;	// 서브메뉴 목록
	private List<BbsVO>  subBbsList;	// 서브 게시판 목록


	public String getMenuId() {
		return menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	public String getUpMenuId() {
		return upMenuId;
	}

	public void setUpMenuId(String upMenuId) {
		this.upMenuId = upMenuId;
	}

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

}
