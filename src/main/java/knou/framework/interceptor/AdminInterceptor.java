package knou.framework.interceptor;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.MessageSource;
import org.springframework.web.servlet.HandlerInterceptor;

import knou.framework.common.AdminMenuInfo;
import knou.framework.common.CommConst;
import knou.framework.common.ParamInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.SessionTimeoutException;
import knou.lms.menu.vo.MenuVO;

public class AdminInterceptor implements HandlerInterceptor {

	private static Log log = LogFactory.getLog(AdminInterceptor.class);

    private MessageSource messageSource;

    public void setMessageSource(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    @Override
    public boolean preHandle( HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        String uri = request.getRequestURI();

        if ( uri.contains("/login.do") || uri.contains("/logout.do") || uri.contains("/common/") ||  uri.contains("/loginProc.do") || uri.contains("/preLogin.do") || uri.contains("/passkey/") || uri.contains("/api/") || uri.contains("/module/"))
        	return true;

        String requestName = uri.substring(uri.lastIndexOf("/") + 1);

        // 	관리자 요청 여부 - URL이 adm*.do로 작성된 경우 관리자페이지 요청으로 검사합니다 >>>>> ASIS 소스 수용을 위하여.
        //	관리자페이지의 URL을 /admin/*.do 로 수정할 경우 jsp, js, java 파일들도 모두 찾아서 수정하고 테스트 해야하기 때문에 AdminInterceptor를 변칙적으로 사용합니다.
        boolean isAdminRequest =  requestName != null && requestName.toLowerCase().startsWith("adm");

        HttpSession session = request.getSession(false);

        UserContext userCtx = (UserContext) session.getAttribute("USER_CONTEXT");

        String xmlHttpRequest = request.getHeader("X-Requested-With");
        boolean isAjaxRequest = "XMLHttpRequest".equals(xmlHttpRequest);

        if ( null != userCtx && userCtx.isAdmin() && ! isAdminRequest) { // 관리자인데 requestUrl에 adm*.do로 안되어 있을 경우

        	if (isAjaxRequest) {

                //	AJAX 요청일 때: 403 에러 코드를 전송하고 응답을 마감합니다.
        		//	톰캣이 HTML 페이지를 그리지 못하도록 텍스트 타입을 강제 지정합니다.
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.setContentType("text/plain;charset=UTF-8");

                // 순수 메시지만 출력
                java.io.PrintWriter writer = response.getWriter();
                writer.write("관리자권한과 서비스 URL 명이 부적합합니다.");
                writer.flush();
                writer.close();

                return false; // 더 이상 Controller로 진행하지 않고 여기서 멈춤

            } else {
                // 일반 동기식 요청일 때: 기존대로 예외 발생 (에러 페이지 이동)
                throw new AccessDeniedException("관리자권한과 서비스 URL 명이 부적합합니다.");
            }
        }

        if(isAdminRequest) {

        	log.info("관리자페이지 요청이 들어왔습니다 : uri = " + uri  + ", requestName = " + requestName);

            if( session == null )
                throw new AccessDeniedException("로그인이 필요합니다.");

            if ( userCtx == null) {
    	    	log.info("AdminInterceptor.preHandle 세션만료");
    	        throw new SessionTimeoutException("세션이 만료되었거나 로그인 정보가 없습니다.");
    	    }

            String userAuthrtGrpcd = (String) userCtx.getLoginUser().getAuthrtGrpcd();

            // 관리자 권한 체크
            if( ! CommConst.AUTHRT_GRPCD_ADM.equals(userAuthrtGrpcd))
                throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg",null,request.getLocale()));

// [수정 구간] 관리자 권한 체크 직후 (Line 97 부근부터 교체)

            // 1. 파라미터 및 세션에서 메뉴 ID 확보
            String menuId = request.getParameter("menuId");
            String topMenuId = request.getParameter("topMenuId");

            // 2. 주소창 파라미터에 값이 들어왔을 때만 서버 세션(GLOBAL)에 실시간 백업
            if (topMenuId != null && !topMenuId.isEmpty()) {
                session.setAttribute("GLOBAL_TOP_MENU_ID", topMenuId);
            }
            if (menuId != null && !menuId.isEmpty()) {
                session.setAttribute("GLOBAL_ADMIN_MENU_ID", menuId);
            }

            // 3. 주소창 파라미터가 없는 경우 (등록, 수정 화면 또는 목록 복귀 시) 세션에서 복원
            if (topMenuId == null || topMenuId.isEmpty()) {
                topMenuId = (String) session.getAttribute("GLOBAL_TOP_MENU_ID");
            }
            if (menuId == null || menuId.isEmpty()) {
                menuId = (String) session.getAttribute("GLOBAL_ADMIN_MENU_ID");
            }

            // 4. 세션마저도 없는 완전 최초 진입 시에만 안전장치로 기존 하드코딩 기본값 작동
            if (menuId == null || menuId.isEmpty()) {
                menuId = "ADMORG0000002";
            }
            if (topMenuId == null || topMenuId.isEmpty()) {
                topMenuId = "ADMORG0000001";
            }

            // 5. 프론트엔드 JSP와 내부 로직용 객체 바인딩 (대소문자 및 오타 방어용 통합 세팅)
            request.setAttribute("adminMenuId", menuId);
            request.setAttribute("menuId", menuId);
            request.setAttribute("topMenuId", topMenuId);

            // 6. 주석 해제 ★: 수동으로 주입한 menuId를 기반으로 topMenu와 topMenuList 객체를 동적 생성합니다.
            // 이렇게 해야 JSP가 렌더링될 때 '${topMenu.menuId}'가 엉뚱한 값으로 튀지 않습니다.
            try {
                setAdminMenu(request, userCtx);
            } catch (Exception e) {
                log.error("관리자 메뉴 세팅 중 오류 발생: " + e.getMessage());
            }
        }
        return true;
    }

    /**
     * 관리자 메뉴 생성
     */
    private void setAdminMenu( HttpServletRequest request, UserContext userCtx ) throws Exception {

        String menuId = ParamInfo.getParamValue(request,"menuId");

        /**
         * 메뉴 조회 조건
         */
        MenuVO menuVO = new MenuVO();

        menuVO.setOrgId(userCtx.getLoginUser().getOrgId());
        menuVO.setAuthrtGrpcd(userCtx.getLoginUser().getAuthrtGrpcd());
        menuVO.setAuthrtCd(userCtx.getLoginUser().getAuthrtCd());
        menuVO.setMenuGbncd("ADM");

        /**
         * TOP MENU LIST
         */
        List<MenuVO> topMenuList = AdminMenuInfo.getAdminMenuList(request,menuVO);
        MenuVO topMenu = null;
        List<MenuVO> leftMenuList = null;
        Map<String, String> menuOnMap = new LinkedHashMap<>();

        /**
         * 현재 메뉴 기준 TOP MENU 계산
         */
        if (topMenuList != null && !topMenuList.isEmpty()) {

            if (menuId != null && !"".equals(menuId)) {

                MenuVO currentMenu = AdminMenuInfo.getMenu(menuId);

                if (currentMenu != null && currentMenu.getUpMenuIds() != null) {
                    String[] upMenuIds = currentMenu.getUpMenuIds().split(",");
                    String topMenuId = upMenuIds[0];

                    /**
                     * TOP MENU 찾기
                     */
                    for (MenuVO top : topMenuList) {

                        if (topMenuId.equals( top.getMenuId())) {
                            topMenu = top;
                            leftMenuList = top.getSubMenuList();
                            break;
                        }
                    }

                    /**
                     * 활성 메뉴 처리
                     */
                    List<String> menuIdList = Arrays.asList(upMenuIds);

                    if (leftMenuList != null) {
                        for (MenuVO sub1 : leftMenuList) {
                            if (menuIdList.contains( sub1.getMenuId()) || menuId.equals(sub1.getMenuId())) {
                                menuOnMap.put( sub1.getMenuId(),"Y");
                            }

                            if (sub1.getSubMenuList() != null) {
                                for (MenuVO sub2 : sub1.getSubMenuList()) {
                                    if (menuIdList.contains( sub2.getMenuId()) || menuId.equals(sub2.getMenuId())) {
                                        menuOnMap.put(sub2.getMenuId(), "Y");
                                    }
                                }
                            }
                        }
                    }
                }

            } else {
                topMenu = topMenuList.get(0);
                if (topMenu != null) {
                    leftMenuList = topMenu.getSubMenuList();
                }
            }
        }

        /**
         * REQUEST ATTRIBUTE
         */
        request.setAttribute("topMenuList",topMenuList);
        request.setAttribute("topMenu",topMenu);
        request.setAttribute("leftMenuList",leftMenuList);
        request.setAttribute("curMenuId",menuId);
        request.setAttribute("menuOnMap",menuOnMap);
    }
}