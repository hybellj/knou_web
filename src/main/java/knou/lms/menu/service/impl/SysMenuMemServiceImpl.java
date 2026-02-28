package knou.lms.menu.service.impl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.StringUtil;
import knou.lms.common.service.OrgMenuService;
import knou.lms.common.vo.OrgMenuVO;
import knou.lms.menu.service.SysMenuMemService;
import knou.lms.menu.service.SysMenuService;
import knou.lms.menu.vo.SysMenuVO;

/**
 *  <b>공통 - 공통 메뉴 메모리 서비스</b> 영역  Service 클래스
 * @author Jamfam
 *
 */
@Service("sysMenuMemService")
public class SysMenuMemServiceImpl 
	extends EgovAbstractServiceImpl implements SysMenuMemService {

	protected final Log log = LogFactory.getLog(getClass());

	@Autowired
	private SysMenuService 				sysMenuService;

	@Autowired
	private OrgMenuService 				orgMenuService;


	/**
	 * 메뉴 리스트를 반환한다.
	 *
	 * @param authGrpCd
	 * @return
	 */
	@Override
	public synchronized List<SysMenuVO> getAdmMenuList(String authGrpCd) throws Exception {
		String menuType = "ADM";
		return sysMenuService.listUserMenu(menuType, authGrpCd).getReturnList();
	}

	/**
	 * 메뉴 리스트를 반환한다.
	 *
	 * @param authGrpCd
	 * @return
	 */
	@Override
	public synchronized List<SysMenuVO> getMngMenuList(String authGrpCd) throws Exception {
		String menuType = "MANAGE";
		return sysMenuService.listUserMenu(menuType, authGrpCd).getReturnList();
	}

	/**
	 * 메뉴 리스트를 반환한다.
	 *
	 * @param authGrpCd
	 * @return
	 */
	@Override
	public synchronized List<SysMenuVO> getHomeMenuList(String authGrpCd) throws Exception {
		String menuType = "HOME";
		return sysMenuService.listUserMenu(menuType, authGrpCd).getReturnList();
	}

	/**
	 * 메뉴 리스트를 반환한다.
	 *
	 * @param authGrpCd
	 * @return
	 */
	@Override
	public synchronized OrgMenuVO getOrgHomeMenuList(String orgId, String authGrpCd) throws Exception {
		OrgMenuVO omvo = new OrgMenuVO();
		omvo.setOrgId(orgId);
		omvo.setAuthrtGrpcd("HOME");
		omvo.setAuthrtCd(authGrpCd);
		return orgMenuService.listAuthGrpTreeMenu(omvo);
	}
	/**
	 * 메뉴 타입별 메뉴 리스트를 반환한다.
	 *
	 * @param authGrpCd
	 * @return
	 */
	@Override
	public synchronized OrgMenuVO getOrgMenuList(String orgId, String menuType, String authGrpCd) throws Exception {
		OrgMenuVO omvo = new OrgMenuVO();
		omvo.setOrgId(orgId);
		omvo.setAuthrtGrpcd(menuType);
		omvo.setAuthrtCd(authGrpCd);
		return orgMenuService.listAuthGrpTreeMenu(omvo);
	}

	/**
	 * 메뉴 리스트를 반환한다.
	 *
	 * @param authGrpCd
	 * @return
	 */
	@Override
	public synchronized List<SysMenuVO> getLecMenuList(String authGrpCd) throws Exception {
		String menuType = "LECT";
		return sysMenuService.listUserMenu(menuType, authGrpCd).getReturnList();
	}


	/**
	 * 메뉴코드, 사용자 유형 정보를 이용해서 최종적으로 표시할 메뉴정보를 결정하고,
	 * 이 정보를 세션에 기록한다.
	 * @param mcd 요청메뉴코드
	 * @param userType 사용자 유형
	 * @param request 메뉴정보를 기록할 세션을 담은 request
	 * @return
	 */
	@Override
	public OrgMenuVO decideHomeMenuWithSession(String mcd, HttpServletRequest request) throws Exception {

		//-- 사용자 권한을 가져온다. 권한이 없는 경우 GST 권한
	    String menuType = SessionInfo.getAuthrtCd(request);
		String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request),"GST");
		String orgId = SessionInfo.getOrgId(request);

		//-- 권한별 메뉴 목록 검색
		OrgMenuVO rootMenu = new OrgMenuVO();
		rootMenu.setOrgId(orgId);
		rootMenu.setAuthrtGrpcd(menuType);
		rootMenu.setAuthrtCd(authGrpCd);
		rootMenu.setMenuCd(""); //-- 전체 메뉴 가져와 ...
		rootMenu = orgMenuService.listAuthGrpTreeMenu(rootMenu);

		OrgMenuVO targetMenu = orgMenuService.findMenuByMenuCd(rootMenu, mcd);

		//-- 만약 authGrpCd에 유효하지 않은 mcd가 들어왔다면 권한이 없으므로 null이 나온다.
		if(targetMenu == null)
			throw new AccessDeniedException("해당 페이지에 대한 접근 권한이 없습니다.");

		//-- 유효한(URL 정보가 있는) 최초의 메뉴를 찾는다.
		targetMenu = this.searchCorrectUrlMenu(targetMenu);

		//-- 메뉴경로를 가져와 최상위 메뉴를 구한다.
		String rootMenuCd = targetMenu.searchParentLvl(1).getMenuCd(); // menuPath[1];
		//String rootMenuGrp = StringUtil.nvl(rootSysMenuVO.searchParentLvl(1).getMenuTitle(),"01"); // 기무사프로젝트용으로 추가함.

		String curMenuName = targetMenu.getMenuNm();

		String curMenuLocation = "";
		String[] menuCds = StringUtil.split(targetMenu.getMenuPath(),"|");
		for(int i=1; i < menuCds.length; i++) {
			OrgMenuVO omudto = orgMenuService.findMenuByMenuCd(rootMenu, menuCds[i]);
			String menuNm = "";
			
			if ((i+1) == menuCds.length) curMenuLocation += "<li class=\"on\">" + menuNm + "</li>";
			else curMenuLocation += "<li><a href=\"#\">" + menuNm + "</a></li>";
		}

		// 세션에 메뉴정보를 기록
		SessionInfo.setMenuLocation(request, curMenuLocation);
		SessionInfo.setMenuName(request, curMenuName);
		SessionInfo.setMenuCode(request, targetMenu.getMenuCd());
		SessionInfo.setMenuTitle(request, targetMenu.getMenuTitle());
		SessionInfo.setRotMenuCode(request, rootMenuCd);
		
		SessionInfo.setTplTypeCd(request,targetMenu.getAuthrtGrpcd());  // 탬플릿 타입코드에 메뉴타입 코드를 등록한다. (레이아웃 코드 설정)

		return targetMenu;
	}
	/**
	 * 메뉴코드, 사용자 유형 정보를 이용해서 최종적으로 표시할 메뉴정보를 결정하고,
	 * 이 정보를 세션에 기록한다.
	 * @param mcd 요청메뉴코드
	 * @param userType 사용자 유형
	 * @param request 메뉴정보를 기록할 세션을 담은 request
	 * @return
	 */
	@Override
	public OrgMenuVO decideMenuWithSession(String mcd, HttpServletRequest request) throws Exception {

		//-- 사용자 권한을 가져온다. 권한이 없는 경우 GUEST 권한
		String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request),"GUEST");
		String orgId = SessionInfo.getOrgId(request);
		
		
		// 메뉴 코드의 메뉴 타입 정보 조회
		OrgMenuVO orgMenuVO = new OrgMenuVO();
		orgMenuVO.setOrgId(orgId);
		orgMenuVO.setMenuCd(mcd);
		orgMenuVO = orgMenuService.viewMenu(orgMenuVO);
		
		String siteAuthCd = "";
		String url = orgMenuVO.getMenuUrl();
		if(url.matches(".*Home.*")) {
			siteAuthCd = "HOME";
			authGrpCd = SessionInfo.getAuthrtCd(request);
		}else if(url.matches(".*Lect.*") || url.matches(".*Open.*")) {
            if(url.matches(".*Open.*")) {
                siteAuthCd = "OPEN"; 
            }else {
                siteAuthCd = "LECT"; 
            }
            if(SessionInfo.getMngType(request).toUpperCase().indexOf("MANAGE") > -1) {
                SessionInfo.setClassUserType(request, "CLASS_PROFESSOR");
            }else if(SessionInfo.getAuthrtCd(request).toUpperCase().indexOf("PROF") > -1) {
                SessionInfo.setClassUserType(request, "CLASS_PROFESSOR");
            }else if(SessionInfo.getAuthrtCd(request).toUpperCase().indexOf("ASSISTANT") > -1) {
                SessionInfo.setClassUserType(request, "CLASS_ASSISTANT");
            }else if(SessionInfo.getAuthrtCd(request).toUpperCase().indexOf("LEARNER") > -1) {
                SessionInfo.setClassUserType(request, "CLASS_LEARNER");
            }else {
                SessionInfo.setClassUserType(request, "");
            }
            authGrpCd = SessionInfo.getClassUserType(request);
		}else if(url.matches(".*Mgr.*")) {
			siteAuthCd = "MANAGE";
			authGrpCd = SessionInfo.getMngType(request);
		}else if(url.matches(".*Adm.*")) {
			siteAuthCd = "ADM";
			authGrpCd = SessionInfo.getAdmType(request);
		}else {
			siteAuthCd = StringUtil.nvl(orgMenuVO.getAuthrtGrpcd(),"HOME");
			authGrpCd = SessionInfo.getAuthrtCd(request);
		}

		//-- 권한별 메뉴 목록 검색
		OrgMenuVO rootMenu = new OrgMenuVO();
		rootMenu.setOrgId(orgId);
		rootMenu.setAuthrtGrpcd(orgMenuVO.getAuthrtGrpcd());
		rootMenu.setAuthrtCd(authGrpCd);
		rootMenu.setMenuCd(""); //-- 전체 메뉴 가져와 ...
		rootMenu = orgMenuService.listAuthGrpTreeMenu(rootMenu);
		rootMenu.setMenuCd(""); //-- 전체 메뉴 가져와 ...

		OrgMenuVO targetMenu = orgMenuService.findMenuByMenuCd(rootMenu, mcd);

		//-- 만약 authGrpCd에 유효하지 않은 mcd가 들어왔다면 권한이 없으므로 null이 나온다.
		if(targetMenu == null)
			throw new AccessDeniedException("해당 페이지에 대한 접근 권한이 없습니다.");

		//-- 유효한(URL 정보가 있는) 최초의 메뉴를 찾는다.
		targetMenu = this.searchCorrectUrlMenu(targetMenu);

		//-- 언에 세팅에 따라... MENU 명 설정
		String locale = SessionInfo.getLocaleKey(request);
		String curMenuName = targetMenu.getMenuNm();
		String curMenuLocation = "";
		String[] menuCds = StringUtil.split(targetMenu.getMenuPath(),"|");
		for(int i=1; i < menuCds.length; i++) {
			OrgMenuVO omudto = orgMenuService.findMenuByMenuCd(rootMenu, menuCds[i]);
			String menuNm = "";
			
			if ((i+1) == menuCds.length) curMenuLocation += "<li class=\"on\">" + menuNm + "</li>";
			else curMenuLocation += "<li><a href=\"#\">" + menuNm + "</a></li>";
		}

		SessionInfo.setTplTypeCd(request,targetMenu.getAuthrtGrpcd());  // 탬플릿 타입코드에 메뉴타입 코드를 등록한다. (레이아웃 코드 설정)

		return targetMenu;
	}

	private OrgMenuVO searchCorrectUrlMenu(OrgMenuVO vo) {
		if(StringUtil.isNotNull(vo.getMenuUrl())) {
			return vo;
		} else if (!vo.getSubList().isEmpty()) {
			return searchCorrectUrlMenu(vo.getSubList().get(0));
		} else {
			// 잘못된 메뉴 구성이다...
			return null;
		}
	}
	
	public void clearMenuSession(HttpServletRequest request) {
		// 세션에 메뉴정보를 기록
		SessionInfo.setMenuLocation(request, "");
		SessionInfo.setMenuName(request, "");
		SessionInfo.setMenuCode(request, "");
		SessionInfo.setMenuTitle(request, "");
		SessionInfo.setMenuChrgDept(request, "");
		SessionInfo.setMenuChrgName(request, "");
		SessionInfo.setMenuChrgPhone(request, "");
		SessionInfo.setRotMenuCode(request, "");
		
		SessionInfo.setTplTypeCd(request,"");  

	}
}
