package knou.framework.common;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.lms.menu.service.SysMenuService;
import knou.lms.menu.vo.MenuVO;

/**
 * 관리자 메뉴 캐시 유틸
 */
public class AdminMenuInfo {

    private static final Logger log = LoggerFactory.getLogger(AdminMenuInfo.class);

    /**
     * KEY : ORG_ID:AUTH_GRP_CD:MENU_GBNCD
     * VALUE : TOP MENU LIST
     */
    private static final Map<String, List<MenuVO>> ADMIN_MENU_CACHE_MAP = new LinkedHashMap<>(); // LinkedHashMap은 들어간데로 나온다

    /**
     * KEY : MENU_ID
     * VALUE : MENU INFO
     */
    private static final Map<String, MenuVO> ADMIN_MENU_MAP = new LinkedHashMap<>();

    /**
     * 관리자 TOP 메뉴 목록 조회
     */
    public static List<MenuVO> getAdminMenuList(HttpServletRequest request, MenuVO menuVO) throws Exception {

        validateAdminUser(request);

        String cacheKey = createCacheKey(request, menuVO);

        log.info("getTopMenuList > cacheKey={}", cacheKey);

//        if (ADMIN_MENU_CACHE_MAP.isEmpty()) {
//            loadAdminMenuCache(request, menuVO);
//        }
//
//        List<MenuVO> menuList = ADMIN_MENU_CACHE_MAP.get(cacheKey);

        List<MenuVO> menuList = new ArrayList<>();

        if (!ADMIN_MENU_CACHE_MAP.isEmpty()) {
            menuList = ADMIN_MENU_CACHE_MAP.get(cacheKey);
        }

//        if (menuList == null) {
//            return new ArrayList<>();
//        }
        if (menuList == null || menuList.isEmpty()) {
            loadAdminMenuCache(request, menuVO);
        }

        return copyMenuList(menuList);
    }

    /**
     * TOP MENU 기준 서브메뉴 목록 조회
     */
    public static List<MenuVO> getSubMenuList(HttpServletRequest request, MenuVO menuVO) throws Exception {

        validateAdminUser(request);

        String cacheKey = createCacheKey(request, menuVO);

        List<MenuVO> topMenuList = ADMIN_MENU_CACHE_MAP.get(cacheKey);

        if (topMenuList == null || topMenuList.isEmpty()) {
            return new ArrayList<>();
        }

        for (MenuVO topMenu : topMenuList) {

            if (topMenu.getMenuId().equals(menuVO.getMenuId())) {

                if (topMenu.getSubMenuList() == null) {
                    return new ArrayList<>();
                }

                return copyMenuList(topMenu.getSubMenuList());
            }
        }

        return new ArrayList<>();
    }

    /**
     * 메뉴 단건 조회
     */
    public static MenuVO getMenu(String menuId) throws Exception {

        MenuVO menuVO = ADMIN_MENU_MAP.get(menuId);

        if (menuVO == null) {
            return null;
        }

        return menuVO.copy();
    }

    /**
     * 현재 메뉴명 목록 조회
     */
    public static List<String> getCurrentMenuNameList(HttpServletRequest request) throws Exception {

        List<String> menuNameList = new ArrayList<>();

        String menuId = ParamInfo.getParamValue(request, "menuId");

        MenuVO currentMenu = getMenu(menuId);

        if (currentMenu == null || currentMenu.getUpMenuIds() == null) {
            return menuNameList;
        }

        String[] upMenuIds = currentMenu.getUpMenuIds().split(",");

        for (String upMenuId : upMenuIds) {

            MenuVO menu = getMenu(upMenuId);

            if (menu != null) {
                menuNameList.add(menu.getMenunm());
            }
        }

        return menuNameList;
    }

    /**
     * 관리자 메뉴 캐시 로딩
     */
    private static synchronized void loadAdminMenuCache(HttpServletRequest request, MenuVO menuVO) throws Exception {

        //log.info("loadAdminMenuCache > start");

        ApplicationContext applicationContext =
                WebApplicationContextUtils.getWebApplicationContext(
                        request.getSession().getServletContext());

        SysMenuService sysMenuService =
                (SysMenuService) applicationContext.getBean("sysMenuService");

        List<MenuVO> dbMenuList = sysMenuService.adminMenuList(menuVO);
        if (dbMenuList == null || dbMenuList.isEmpty()) {
            return;
        }

        Map<String, MenuVO> localMenuMap = new LinkedHashMap <>();
        Map<String, List<MenuVO>> localTopMenuMap = new LinkedHashMap <>();

        /**
         * 1. 메뉴 객체 생성
         */
        for (MenuVO dbMenu : dbMenuList) {

            MenuVO menu = dbMenu.copy();

            menu.setSubMenuList(new ArrayList<>());

            localMenuMap.put(menu.getMenuId(), menu);
        }

        /**
         * 2. 메뉴 트리 구성
         */
        for (MenuVO menu : localMenuMap.values()) {

            String cacheKey =
                    menu.getOrgId()
                    + ":" + menu.getMenuAuthTycd()
                    + ":" + menu.getMenuGbncd();

            //log.info("loadAdminMenuCache > cacheKey={} , menuId={}",cacheKey,menu.getMenuId());

            /**
             * TOP MENU
             */
            if ("ROOT".equals(menu.getUpMenuId())) {

                localTopMenuMap
                    .computeIfAbsent(cacheKey, k -> new ArrayList<>())
                    .add(menu);

                continue;
            }

            /**
             * SUB MENU
             */
            MenuVO parentMenu = localMenuMap.get(menu.getUpMenuId());

            if (parentMenu == null) {
                continue;
            }

            String upMenuIds = parentMenu.getUpMenuIds();

            if (upMenuIds == null) {
                upMenuIds = parentMenu.getMenuId();
            } else {
                upMenuIds += "," + parentMenu.getMenuId();
            }

            menu.setUpMenuIds(upMenuIds);

            parentMenu.getSubMenuList().add(menu);
        }

        /**
         * 3. 캐시 저장
         */
        synchronized (ADMIN_MENU_CACHE_MAP) {

            for (Map.Entry<String, List<MenuVO>> entry : localTopMenuMap.entrySet()) {

                List<MenuVO> copyList = copyMenuList(entry.getValue());

                ADMIN_MENU_CACHE_MAP.put(entry.getKey(), copyList);
            }

            for (MenuVO menu : localMenuMap.values()) {

                ADMIN_MENU_MAP.put(menu.getMenuId(), menu.copy());
            }
        }

        //log.info("loadAdminMenuCache > end");
    }

    /**
     * 관리자 사용자 검증
     */
    private static void validateAdminUser(HttpServletRequest request) throws Exception {

        UserContext userCtx = SessionInfo.getUserContext(request);

        if (userCtx == null
                || userCtx.getLoginUser() == null
                || !CommConst.AUTHRT_GRPCD_ADM.equals(
                        userCtx.getLoginUser().getAuthrtGrpcd())) {

            throw new AccessDeniedException("사용자 정보가 없거나 세션이 만료되었습니다.");
        }
    }

    /**
     * 캐시 KEY 생성
     */
    private static String createCacheKey(HttpServletRequest request, MenuVO menuVO) {

        UserContext userCtx = SessionInfo.getUserContext(request);

        return userCtx.getLoginUser().getOrgId()
                + ":" + userCtx.getLoginUser().getAuthrtGrpcd()
                + ":" + menuVO.getMenuGbncd();
    }

    /**
     * 메뉴 목록 복사
     */
    private static List<MenuVO> copyMenuList(List<MenuVO> menuList) {

        List<MenuVO> result = new ArrayList<>();

        if (menuList == null) {
            return result;
        }

        for (MenuVO menu : menuList) {
            result.add(menu.copy());
        }

        return result;
    }
}