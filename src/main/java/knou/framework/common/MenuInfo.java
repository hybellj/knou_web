package knou.framework.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.SerializationUtils;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import knou.framework.util.RedisUtil;
import knou.framework.util.SessionUtil;
import knou.framework.util.StringUtil;
import knou.lms.crs.home.service.CrsHomeMenuService;
import knou.lms.crs.home.vo.CrsHomeBbsMenuVO;
import knou.lms.crs.home.vo.CrsHomeMenuVO;
import knou.lms.menu.service.SysMenuService;
import knou.lms.menu.vo.SysMenuVO;

/**
 * 메뉴 정보
 * @author shil
 *
 */
public class MenuInfo {

    private static HashMap<String, SysMenuVO> MENU_MAP = null;

    public static HashMap<String, Integer> COURSE_BBS_VERSION_MAP = null;
    public static String COURSE_BBS_SID_PREFIX = "MNBBS:";

    /**
     * 메뉴 정보 가져오기
     * @param request
     * @param sysMenuVO
     * @return
     * @throws Exception
     */
    public static SysMenuVO getMenuInfo(HttpServletRequest request, SysMenuVO sysMenuVO) throws Exception {

    	String authrtGrpcd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
    	String orgId = sysMenuVO.getOrgId();
        if ("".equals(StringUtil.nvl(orgId))) {
        	orgId = "LMSBASIC";
        }

        String menuKey = orgId+":"+sysMenuVO.getAuthrtGrpcd()+":"+SessionInfo.getLocaleKey(request);
        SysMenuVO menuInfo = null;

        /*if (MENU_MAP == null) {*/
            loadMenuInfo(request, sysMenuVO);
		/* } */

        menuInfo = MENU_MAP.get(menuKey);
        if (!"".equals(StringUtil.nvl(sysMenuVO.getCrsCreCd()))) {
            String bbsSid = COURSE_BBS_SID_PREFIX + sysMenuVO.getCrsCreCd();

            // 게시판 메뉴 초기화여부
            if(CommConst.REDIS_USE) {
                try {
                    if(COURSE_BBS_VERSION_MAP == null) {
                        COURSE_BBS_VERSION_MAP = new HashMap<>();
                    }

                    if(RedisUtil.exists(bbsSid)) {
                        String sVersion = RedisUtil.getValue(bbsSid);
                        int version = 1;

                        if(COURSE_BBS_VERSION_MAP.containsKey(bbsSid)) {
                            version = COURSE_BBS_VERSION_MAP.get(bbsSid);
                        }

                        if(version < Integer.valueOf(sVersion)) {
                            COURSE_BBS_VERSION_MAP.put(bbsSid, Integer.valueOf(sVersion));
                            SessionUtil.setSessionValue(request, bbsSid, null);
                        } else if(version > Integer.valueOf(sVersion)) {
                            COURSE_BBS_VERSION_MAP.put(bbsSid, version);
                            SessionUtil.setSessionValue(request, bbsSid, null);
                        }
                    } else {
                        COURSE_BBS_VERSION_MAP.put(bbsSid, 1);
                        SessionUtil.setSessionValue(request, bbsSid, null);
                        RedisUtil.setValue(bbsSid, String.valueOf(1));
                    }
                } catch (Exception e) {

                }
            }

            @SuppressWarnings("unchecked")
            List<CrsHomeBbsMenuVO> bbsList = (List<CrsHomeBbsMenuVO>)SessionUtil.getSessionValue(request, bbsSid);

            if (bbsList == null) {
                ApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
                CrsHomeMenuService crsHomeMenuService = (CrsHomeMenuService)applicationContext.getBean("crsHomeMenuService");

                CrsHomeMenuVO homeMenuVO = new CrsHomeMenuVO();
                homeMenuVO.setOrgId(orgId);
                homeMenuVO.setCrsCreCd(sysMenuVO.getCrsCreCd());

                if(authrtGrpcd.contains("PROF")) {
                    homeMenuVO.setAuthrtGrpcd("PROF");
                } else if(authrtGrpcd.contains("USR")) {
                    homeMenuVO.setAuthrtGrpcd("USR");
                }

                bbsList = crsHomeMenuService.selectCrsHomeBbslist(homeMenuVO);

                if (bbsList != null) {
                    SessionUtil.setSessionValue(request, bbsSid, bbsList);
                }
            }

            if (bbsList != null && !"ko".equals(SessionInfo.getLocaleKey(request))) {
                for (CrsHomeBbsMenuVO bbsVO : bbsList) {
                    bbsVO.setBbsNm(bbsVO.getBbsNmEn());
                }
            }

            if (menuInfo != null) {
            	menuInfo.setBbsList(bbsList);
            }
        }

        return menuInfo;
    }

    /**
     * 메뉴정보 로딩
     * @param request
     * @throws Exception
     */
    private static void loadMenuInfo(HttpServletRequest request, SysMenuVO sysMenuVO) throws Exception {
        MENU_MAP = new HashMap<>();
        List<SysMenuVO> menuList = new ArrayList<>();
        List<SysMenuVO> menuListEn = new ArrayList<>();

        ApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
        SysMenuService sysMenuService = (SysMenuService)applicationContext.getBean("sysMenuService");
        List<SysMenuVO> serviceMenuList = sysMenuService.selectServiceMenuAll(sysMenuVO);

        for(SysMenuVO menuVO : serviceMenuList) {
            SysMenuVO enVO = (SysMenuVO)SerializationUtils.clone(menuVO);
            enVO.setMenuNm(enVO.getMenuNmEn());
			/*
			 * if ("PRO0000000001".equals(menuVO.getMenuCd()) ||
			 * "STU0000000001".equals(menuVO.getMenuCd())) { continue; }
			 */
            if (!"".equals(StringUtil.nvl(menuVO.getUpMenuId()))) {
                if (menuList.size() > 0) {
                	for (SysMenuVO mvo : menuList) { // 레벨 1 메뉴 리스트 순회 (최상위)

                	    // 1. mvo (L1) 아래에 menuVO (L2) 추가 시도
                	    if (mvo.getOrgId().equals(menuVO.getOrgId()) && mvo.getMenuId().equals(menuVO.getUpMenuId())) {

                	        List<SysMenuVO> subList = mvo.getSubList();
                	        if (subList == null) {
                	            subList = new ArrayList<>();
                	        }
                	        subList.add(menuVO);
                	        mvo.setSubList(subList);
                	        break;

                	    } else {

                	        // mvo (L1)의 자식 리스트(L2) 순회 시도
                	        List<SysMenuVO> subList = mvo.getSubList();
                	        if (subList != null) {

                	            for(SysMenuVO subVO : subList) { // 레벨 2 메뉴 리스트 순회

                	                // 2. subVO (L2) 아래에 menuVO (L3) 추가 시도
                	                if (subVO.getOrgId().equals(menuVO.getOrgId()) && subVO.getMenuId().equals(menuVO.getUpMenuId())) {

                	                    List<SysMenuVO> msubList = subVO.getSubList();
                	                    if (msubList == null) {
                	                        msubList = new ArrayList<>();
                	                    }
                	                    msubList.add(menuVO);
                	                    subVO.setSubList(msubList);
                	                    break;

                	                } else {

                	                    // subVO (L2)의 자식 리스트(L3) 순회 시도 <-- **추가된 핵심 로직**
                	                    List<SysMenuVO> level3List = subVO.getSubList();
                	                    if (level3List != null) {

                	                        // 3. level3VO (L3) 아래에 menuVO (L4) 추가 시도
                	                        for(SysMenuVO level3VO : level3List) { // 레벨 3 메뉴 리스트 순회
                	                            if (level3VO.getOrgId().equals(menuVO.getOrgId()) && level3VO.getMenuId().equals(menuVO.getUpMenuId())) {

                	                                List<SysMenuVO> level4List = level3VO.getSubList();
                	                                if (level4List == null) {
                	                                    level4List = new ArrayList<>();
                	                                }
                	                                level4List.add(menuVO);
                	                                level3VO.setSubList(level4List);
                	                                break; // 레벨 4 추가 성공 후 루프 탈출
                	                            }
                	                        }
                	                    }
                	                }
                	            }
                	        }
                	    }
                	}

					/*
					 * for(SysMenuVO mvo : menuListEn) { if
					 * (mvo.getOrgId().equals(menuVO.getOrgId()) &&
					 * mvo.getMenuCd().equals(menuVO.getParMenuCd())) { List<SysMenuVO> subList =
					 * mvo.getSubList(); if (subList == null) { subList = new ArrayList<>(); }
					 * subList.add(enVO); mvo.setSubList(subList); break; } else { List<SysMenuVO>
					 * subList = mvo.getSubList(); if (subList != null) { for(SysMenuVO subVO :
					 * subList) { if (subVO.getOrgId().equals(menuVO.getOrgId()) &&
					 * subVO.getMenuCd().equals(menuVO.getParMenuCd())) { List<SysMenuVO> msubList =
					 * subVO.getSubList(); if (msubList == null) { msubList = new ArrayList<>(); }
					 * msubList.add(enVO); subVO.setSubList(msubList); break; } } } } }
					 */
                } else {
                    menuList.add(menuVO);
                    menuListEn.add(enVO);
                }
            } else {
                menuList.add(menuVO);
                menuListEn.add(enVO);
            }
        }

        for(SysMenuVO menuVO : menuList) {
            MENU_MAP.put(menuVO.getOrgId()+":"+menuVO.getMenuTycd()+":ko", menuVO);
        }

        for(SysMenuVO menuVO : menuListEn) {
            MENU_MAP.put(menuVO.getOrgId()+":"+menuVO.getMenuTycd()+":en", menuVO);
        }
    }

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
}
