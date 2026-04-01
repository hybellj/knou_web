package knou.framework.interceptor;

import java.util.Base64;
import java.util.HashMap;
import java.util.Locale;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.MessageSource;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import knou.framework.common.CommConst;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.LocaleUtil;
import knou.framework.util.SessionUtil;
import knou.framework.util.StringUtil;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.user.service.UsrLoginService;
import knou.lms.user.vo.UsrLoginVO;

/**
 * 인증여부 체크 인터셉터
 * @author 공통서비스 개발팀 서준식
 * @since 2011.07.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2011.07.01  서준식          최초 생성
 *  2011.09.07  서준식          인증이 필요없는 URL을 패스하는 로직 추가
 *  </pre>
 */


public class AuthenticInterceptor extends HandlerInterceptorAdapter {
    @Resource(name = "messageSource")
    private MessageSource messageSource;

    @Resource(name = "usrLoginService")
    private UsrLoginService usrLoginService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    private static HashMap<String, String> CONN_CHECK_MAP = new HashMap<>();

	/**
	 * Controller 실행전 실행됨.
	 *
	 * 권한 체크
	 * 기관 정보 설정(홈페이지용)
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>1 preHandle AuthenticInterceptor");
				
        String uri = request.getRequestURI();
        String profiles = messageSource.getMessage("SERVER.MODE", null, null);
        String userAgent = StringUtil.nvl(request.getHeader("User-Agent"));
        String loginUrl = "local".equals(profiles) ? "/" : "/sso/CreateRequest.jsp";
        Locale locale = LocaleUtil.getLocale(request);

	    // 시스템 점검중 안내페이지 표시여부
	    if ("Y".equals(CommConst.WORK_PAGE_YN)) {
	    	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>1-1 preHandle AuthenticInterceptor");            
            response.sendRedirect("/");
            return false;
	    }

        // 세션체크 예외 패턴
        boolean checkSession = true;
        if (uri.contains("/api/")
        		|| uri.contains("/dext/")
                || uri.contains("/profDashboardTest.do")
                || uri.contains("/stuDashboardTest.do")
                || uri.contains("/crsHomeProfTest.do")
                || uri.contains("/crsHomeStdTest.do")
                || uri.contains("/saveStdyRecord.do")
                || uri.contains("/index.do")
                || uri.contains("/forum2/")
                ) {
            checkSession = false;

            SessionInfo.setUserId(request,"prof1");
            SessionInfo.setOrgId(request,"ORG0000001");
            SessionInfo.setAuthrtGrpcd(request,"PROF");
            SessionInfo.setAuthrtCd(request,"PROF");
        }

        // ERP,홈페이지에서 이동인 경우 (로그인 안됐을 때)
        if (!SessionInfo.isLogin(request) && (uri.contains("/common/movePage.do")
        		|| uri.contains("/common/moveNotice.do")
        		|| uri.contains("/common/moveCrs.do"))) {
        	String moveUrl = uri;
        	Set<String> keySet = request.getParameterMap().keySet();
        	for(String key: keySet) {
        		if (moveUrl.indexOf("?") == -1) moveUrl += "?";
        		else moveUrl += "&";
        		moveUrl += key + "=" + request.getParameter(key);
        	}

        	SessionUtil.setSessionValue(request, "MOVE_URL_NOLOGIN", moveUrl);
        	response.sendRedirect("/sso/CreateRequest.jsp");
        	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>2 preHandle AuthenticInterceptor");
	        return false;
        }
	    
        if(checkSession && !SessionInfo.isLogin(request)) {
	    	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>3 preHandle AuthenticInterceptor");
	        response.sendRedirect("/");
	        return false;
	    }

        try {
        	String userId        = StringUtil.nvl(SessionInfo.getUserId(request));
            String userType      = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
            String sessionId     = request.getSession().getId();
            boolean checkMultiConn = true;
            boolean valid = true;

            // SSO에서 로그아웃 됏는지 체크
            String ssoStatus = (String)request.getSession().getAttribute("SSO_STATUS");

            //System.out.println("ssoStatus -----------------------------------"+ssoStatus);

            if ("logout".equals(ssoStatus) && !"".equals(userId)) {
            	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>4 preHandle AuthenticInterceptor");
                request.getSession().invalidate();
                response.sendRedirect("/");
                return false;
            }
            else if ("logout".equals(ssoStatus)) {
                request.getSession().setAttribute("SSO_STATUS", "");
            }

            // 중복로그인 체크 예외 조건 설정
            if (uri.indexOf("/login.do") > -1
                    || uri.contains("/zipFileUploadForm.do")
                    || "2023201349".equals(userId) // 임시예외처리
                    ) {
                checkMultiConn = false;
            }

            // 가상로그인이면
            if (SessionInfo.getVirtualLoginInfo(request) != null) {
                checkMultiConn = false;
            }

            // 중복로그인 체크
            if ("Y".equals(CommConst.MULTICONN_CHECK_YN)
                    && checkMultiConn == true
                    && !"".equals(userId)
                    && userType.contains("USR") && checkSession) {

                UsrLoginVO loginVO = new UsrLoginVO();
                loginVO.setUserId(userId);
                loginVO = usrLoginService.selectSessionId(loginVO);
                String sid = loginVO.getSessionId();

                // 중복 로그인 시
                if (sid != null && !sessionId.equals(sid)) {
                    String loginGbn = SessionInfo.getLoginGbn(request);
                    // 세션 초기화
                    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>X invalidate 호출");
                    request.getSession().invalidate();
                    request.getSession().setAttribute("MULTICON_STATE", "LOGOUT");
                    request.getSession().setAttribute("LOGOUT_GBN", loginGbn);
                    valid = false;
                }
            }

            // 사용자 접속상태 저장
            if (valid) {
            	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>logUserConnService.saveUserConnState 사용자접속상태저장");
                logUserConnService.saveUserConnState(request);
            }

            // 관리자 강의실 접근권한 추가
            String menuTycd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

            if(menuTycd.contains("ADM") && !(menuTycd.contains("PROF") || menuTycd.contains("USR"))) {
            	menuTycd += "|PROFESSOR";
                SessionInfo.setAuthrtGrpcd(request, menuTycd);
            }

            // 파라메터로 메뉴코드 전달받은 경우
            String menuParam = StringUtil.nvl(request.getParameter("param"));
            if (!"".equals(menuParam)) {
                menuParam = new String(Base64.getDecoder().decode(menuParam));
                if ("new".equals(menuParam)) {
                    SessionInfo.setCurUpMenuId(request, "");
                    SessionInfo.setCurMenuId(request, "");
                }
                else if (menuParam.indexOf("MENU,") == 0) {
                    String[] menus = menuParam.split(",");
                    if (menus.length == 3) {
                        SessionInfo.setCurUpMenuId(request, menus[1]);
                        SessionInfo.setCurMenuId(request, menus[2]);
                    }
                }
            }
        }
        catch (Exception e) {
        	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>5 preHandle AuthenticInterceptor");
            System.out.println("ERROR : AuthenticInterceptor ---> "+e.toString());
            e.printStackTrace();
        }

        System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>6 preHandle AuthenticInterceptor");

		return true;
	}


	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView model) throws Exception {
	    //postHandle(request, response, handler, model);
	}
}