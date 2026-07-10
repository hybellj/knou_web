package knou.framework.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import knou.framework.util.CommonBeanUtils;
import knou.framework.util.RedisUtil;
import knou.framework.util.SessionUtil;
import knou.framework.util.StringUtil;
import knou.lms.bbs.service.BbsInfoService;
import knou.lms.bbs.vo.BbsVO;
import knou.lms.menu.service.SysMenuService;
import knou.lms.menu.vo.MenuVO;

/**
 * 메뉴 정보
 */
public class MenuInfo {

    private static Map<String, List<MenuVO>> MENU_INFO_MAP = null;
    private static Map<String, MenuVO> MENU_BASE_MAP = null;
    private static String BBS_SBJCT_MENU = "/bbs/bbsLect/bbsAtclListView.do";

    public static HashMap<String, Integer> COURSE_BBS_VERSION_MAP = null;
    public static String COURSE_BBS_SID_PREFIX = "MNBBS:";

    @Deprecated
    public static void increaseCourseBbsVersion(String crsCreCd) {
        String bbsSid = MenuInfo.COURSE_BBS_SID_PREFIX + crsCreCd;

        try {
            if(RedisUtil.exists(bbsSid)) {
                String sVersion = RedisUtil.getValue(bbsSid);
                int version = Integer.valueOf(sVersion);

                RedisUtil.setValue(bbsSid, String.valueOf(++version));
            } else {
                RedisUtil.setValue(bbsSid, String.valueOf(1));
            }
        } catch (Exception e) {

        }
    }

    /**
     * 메뉴 정보 가져오기
     * @param request
     * @param menuVO
     * @return List<MenuVO>
     * @throws Exception
     */
    public static List<MenuVO> getMenuInfo(HttpServletRequest request, MenuVO menuVO) throws Exception {

    	String orgId = StringUtil.nvl(menuVO.getOrgId());
        String authrtGrpcd = StringUtil.nvl(menuVO.getAuthrtGrpcd());

        if ("".equals(authrtGrpcd)) {
        	authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        }

        if (authrtGrpcd.indexOf(CommConst.AUTHRT_GRPCD_ADM) > -1) {
        	authrtGrpcd = CommConst.AUTHRT_GRPCD_ADM;
        }

        if ("".equals(orgId) || "".equals(authrtGrpcd)) {
        	return null;
        }

        String menuKey = orgId + ":" + authrtGrpcd + ":" + menuVO.getMenuGbncd();
        List<MenuVO> menuList = new ArrayList<>();

        if (MENU_INFO_MAP != null && !MENU_INFO_MAP.isEmpty()) {
        	menuList = MENU_INFO_MAP.get(menuKey);
		}

        if (menuList == null || menuList.size() == 0) {
        	loadMainMenuInfo(request, menuVO);
        	menuList = MENU_INFO_MAP.get(menuKey);
        }

        return menuList;
    }

    /**
     * 서브메뉴 정보 가져오기
     * @param request
     * @param menuVO
     * @return List<MenuVO>
     * @throws Exception
     */
    public static List<MenuVO> getSubMenuInfo(HttpServletRequest request, MenuVO menuVO) throws Exception {

    	String orgId = StringUtil.nvl(menuVO.getOrgId());
        String authrtGrpcd = StringUtil.nvl(menuVO.getAuthrtGrpcd());

        if ("".equals(authrtGrpcd)) {
        	authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        }

        if (authrtGrpcd.indexOf(CommConst.AUTHRT_GRPCD_ADM) > -1) {
        	authrtGrpcd = CommConst.AUTHRT_GRPCD_ADM;
        }

        if ("".equals(orgId) || "".equals(authrtGrpcd)) {
        	return null;
        }

        String menuKey = orgId + ":" + authrtGrpcd + ":" + menuVO.getMenuGbncd();
        List<MenuVO> menuList = null;
        List<MenuVO> subMenuList = null;

        if ( MENU_INFO_MAP != null && !MENU_INFO_MAP.isEmpty()) {
        	menuList = MENU_INFO_MAP.get(menuKey);
		}

        if (menuList != null && menuList.size() > 0) {
        	for (MenuVO menu : menuList) {
        		if (menu.getMenuId().equals(menuVO.getMenuId())) {
        			subMenuList = new ArrayList<>(menu.getSubMenuList());
        			break;
        		}
        	}
        }

        return subMenuList;
    }


    /**
     * 강의실 메뉴 정보 가져오기
     * @param request
     * @param menuVO
     * @return List<MenuVO>
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
	public static List<MenuVO> getLectMenuInfo(HttpServletRequest request, MenuVO menuVO) throws Exception {
    	String sbjctId = menuVO.getSbjctId();
    	if ("".equals(StringUtil.nvl(sbjctId))) {
    		return new ArrayList<>();
    	}

    	String orgId = menuVO.getOrgId();
        if ("".equals(StringUtil.nvl(orgId))) {
        	orgId = "LMSBASIC";
        }

        String authrtGrpcd = menuVO.getAuthrtGrpcd();
        if (authrtGrpcd == null || "".equals(authrtGrpcd)) {
        	authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        }

        String menuKey = "LECTMENU:"+sbjctId+":"+authrtGrpcd;
		List<MenuVO> menuList = (List<MenuVO>) SessionUtil.getSessionValue(request, menuKey);

        if (menuList == null) {
        	loadLectMenuInfo(request, menuVO);
        	menuList = (List<MenuVO>) SessionUtil.getSessionValue(request, menuKey);
        }

        return menuList;
    }

    /**
     * 메뉴 가져오기 (단일정보)
     * @param menuId
     * @return MenuVO
     * @throws Exception
     */
    public static MenuVO getMenuVO(String menuId) throws Exception {
    	MenuVO menuVO = null;

    	if (null != MENU_BASE_MAP && MENU_BASE_MAP.containsKey(menuId)) {
    		menuVO = MENU_BASE_MAP.get(menuId);
    	}

    	return menuVO;
    }

    /**
     * 현재 메뉴명 리스트 가져오기(현재 메뉴명과 상위메뉴명)
     */
    public static List<String> getCurMenunmList(HttpServletRequest request) throws Exception {
    	List<String> menunmList = new ArrayList<>();
    	String menuId = ParamInfo.getParamValue(request, "menuId");
    	MenuVO menuVO = MenuInfo.getMenuVO(menuId);

    	if (menuVO != null && menuVO.getUpMenuIds() != null) {
			String[] menuIds = menuVO.getUpMenuIds().split(",");

			for (String mid : menuIds) {
				MenuVO mvo = MenuInfo.getMenuVO(mid);
				if (mvo != null) {
					menunmList.add(mvo.getMenunm());
				}
			}
    	}

    	return menunmList;
    }

    /**
     * 메뉴 네비게이션 정보 가져오기
     * @param request
     * @return
     * @throws Exception
     */
    public static List<String> getMenuNaviInfo(HttpServletRequest request) throws Exception {
        String authrtGrpcd	= SessionInfo.getAuthrtGrpcd(request);
        String upMenuId		= ParamInfo.getParamValue(request, "upMenuId");
        String menuId		= ParamInfo.getParamValue(request, "menuId");
        String sbjctId		= ParamInfo.getParamValue(request, "sbjctId");
    	String orgId 		= ParamInfo.getParamValue(request, "orgId");

    	if (orgId == null || "".equals(orgId)) {
        	orgId = SessionInfo.getOrgId(request);
        }

        return getMenuNaviInfo(request, orgId, authrtGrpcd, upMenuId, menuId, sbjctId);
    }

    /**
     * 메뉴 네비게이션 정보 가져오기
     * @param request
     * @return
     * @throws Exception
     */
    public static List<String> getMenuNaviInfo(HttpServletRequest request, String orgId, String authrtGrpcd,
    		String upMenuId, String menuId, String sbjctId) throws Exception {
    	List<String> menuNmList = new ArrayList<>();

        String type = "main";
        if (sbjctId != null && !"".equals(sbjctId)) {
        	type = "lect";
        }

        if (menuId != null && !"".equals(menuId)) {
            MenuVO menuVO = new MenuVO();
            menuVO.setOrgId(orgId);
            menuVO.setMenuTycd(authrtGrpcd);
            menuVO.setMenuGbncd(type.toUpperCase());

            List<MenuVO> menuList = null;
            if ("main".equalsIgnoreCase(type)) {
            	menuList = MenuInfo.getMenuInfo(request, menuVO);
            }
            else if ("lect".equalsIgnoreCase(type)) {
            	menuVO.setSbjctId(sbjctId);
            	menuList = MenuInfo.getLectMenuInfo(request, menuVO);
            }
            else if ("admin".equalsIgnoreCase(type)) {
            	List<String> menunmList = MenuInfo.getCurMenunmList(request);
            	if (menunmList != null && !menunmList.isEmpty()) {
            		for (String menunm : menunmList) {
            			menuNmList.add(menunm);
            		}
            	}

            	MenuVO mvo = MenuInfo.getMenuVO(menuId);
            	menuNmList.add(mvo.getMenunm());
            }

            if (menuList != null && !menuList.isEmpty()) {
	            for (MenuVO vo : menuList) {
	            	if (!"ROOT".equals(upMenuId) && vo.getMenuId().equals(upMenuId)) {
	            		menuNmList.add(vo.getMenunm());

	            		List<MenuVO> subList = vo.getSubMenuList();
	            		for (MenuVO subVO : subList) {
	            			if (subVO.getMenuId().equals(menuId)) {
	            				menuNmList.add(subVO.getMenunm());
	            				break;
	            			}
	            		}
	            		break;
	            	}
	            	else if (vo.getMenuId().equals(menuId)) {
	            		menuNmList.add(vo.getMenunm());
	            		break;
	            	}
	            }
            }
        }

    	return menuNmList;
    }

    /**
     * 메인 메뉴정보 로딩
     * @param request
     * @throws Exception
     */
    private static void loadMainMenuInfo(HttpServletRequest request, MenuVO vo) throws Exception {
    	ApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
    	SysMenuService sysMenuService = (SysMenuService)applicationContext.getBean("sysMenuService");

    	// 기관 메인메뉴 전체 목록 조회
    	List<MenuVO> mainMenuList = sysMenuService.selectOrgMainMenuList(vo);

    	if (mainMenuList != null && mainMenuList.size() > 0) {
    		if (MENU_INFO_MAP == null) {
    			MENU_INFO_MAP = new HashMap<>();
    		}

    		if (MENU_BASE_MAP == null) {
    			MENU_BASE_MAP = new HashMap<>();
    		}

    		Map<String, MenuVO> menuMap = new HashMap<>();

    		for(MenuVO menuVO : mainMenuList) {
    			menuMap.put(menuVO.getMenuId(), menuVO);

    			if (!MENU_BASE_MAP.containsKey(menuVO.getMenuId())) {
    				MENU_BASE_MAP.put(menuVO.getMenuId(), menuVO);
    			}
    		}

    		for(MenuVO menuVO : mainMenuList) {

    			String key = vo.getOrgId() + ":" + menuVO.getMenuAuthTycd() + ":" + menuVO.getMenuGbncd();

    			//System.out.println("menu key=" + key);

    			// ROOT는 상단 TOP 메뉴
    			if ("ROOT".equals(menuVO.getUpMenuId())) {
    				if (MENU_INFO_MAP.containsKey(key)) {
    					MENU_INFO_MAP.get(key).add(menuVO);
    				}
    				else {
    					List<MenuVO> list = new ArrayList<>();
    					list.add(menuVO);
    					MENU_INFO_MAP.put(key, list);
    				}

    			} else {

    				MenuVO upMenu = menuMap.get(menuVO.getUpMenuId());

    				if (upMenu != null) {
    					if (upMenu.getSubMenuList() == null) {
    						upMenu.setSubMenuList(new ArrayList<>());
    					}

    					String upMenuIds = upMenu.getUpMenuIds();
    					if (upMenuIds != null) {
    						upMenuIds += ",";
    					}
    					else {
    						upMenuIds = "";
    					}
    					upMenuIds += upMenu.getMenuId();

    					menuVO.setUpMenuIds(upMenuIds);
    					upMenu.getSubMenuList().add(menuVO);
    				}
    			}
    		}
    	}
    }


    /**
     * 강의실 메뉴정보 로딩
     * @param request
     * @throws Exception
     */
    private static void loadLectMenuInfo(HttpServletRequest request, MenuVO vo) throws Exception {
        ApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
        SysMenuService sysMenuService = (SysMenuService)applicationContext.getBean("sysMenuService");
        BbsInfoService bbsInfoService = (BbsInfoService)applicationContext.getBean("bbsInfoService");

        // 강의실 메뉴 목록 조회
        List<MenuVO> lectMenuList = sysMenuService.selectLectMenuList(vo);

        // 강의실 게시판 목록 조회
        BbsVO bbsVO = new BbsVO();
        bbsVO.setSbjctId(vo.getSbjctId());
        List<BbsVO> bbsList = bbsInfoService.selectBbsForSbjctMenu(bbsVO);

        Map<String, MenuVO> tmpMap = new HashMap<>();
        List<MenuVO> menuList = new ArrayList<>();
        Map<String, List<MenuVO>> menuMap = new HashMap<>();

        for(MenuVO menuVO : lectMenuList) {
        	menuVO.setSubMenuList(new ArrayList<>());
        	tmpMap.put(menuVO.getMenuId(), menuVO);
        }

        for(MenuVO menuVO : lectMenuList) {
        	if ("ROOT".equals(StringUtil.nvl(menuVO.getUpMenuId(),"ROOT"))) {
        		// 메뉴목록에 과목 게시판 추가
        		if ("BBS".equals(menuVO.getMenuTycd())) {
        			if (bbsList != null && bbsList.size() > 0) {
	        			for (BbsVO menuBbsVO : bbsList) {
		        			MenuVO bbsMenuVO = new MenuVO();
		        			CommonBeanUtils.copyProperties(bbsMenuVO,  menuVO);
		        			bbsMenuVO.setMenuId(menuBbsVO.getBbsId());
		        			bbsMenuVO.setMenunm(menuBbsVO.getBbsNm());
		        			bbsMenuVO.setMenuUrl(BBS_SBJCT_MENU+"?bbsId="+menuBbsVO.getBbsId()+"&bbsAddyn="+menuBbsVO.getBbsAddyn());
		        			menuList.add(bbsMenuVO);
	        			}
        			}
        		}
        		else {
        			menuList.add(menuVO);
        		}
        	}
        	else {
        		MenuVO parent = tmpMap.get(menuVO.getUpMenuId());
        		if (parent != null) {
        			parent.getSubMenuList().add(menuVO);
        		}
        	}
        }

        for(MenuVO menuVO : menuList) {
        	String menuAuthTycd = menuVO.getMenuAuthTycd();
        	if (menuMap.containsKey(menuAuthTycd)) {
        		menuMap.get(menuAuthTycd).add(menuVO);
        	}
        	else {
        		List<MenuVO> list = new ArrayList<>();
        		list.add(menuVO);
        		menuMap.put(menuAuthTycd, list);
        	}
        }

        String[] keys = menuMap.keySet().stream().toArray(String[]::new);
        for (String key : keys) {
        	String menuKey = "LECTMENU:"+vo.getSbjctId()+":"+key;
        	List<MenuVO> list = menuMap.get(key);
            if (!list.isEmpty()) {
            	SessionUtil.setSessionValue(request, menuKey, list);
            }
        }
    }

}
