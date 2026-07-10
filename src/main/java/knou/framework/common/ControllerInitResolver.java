package knou.framework.common;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.MethodParameter;
import org.springframework.web.bind.ServletRequestParameterPropertyValues;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import knou.framework.context2.UserContext;
import knou.framework.exception.SessionTimeoutException;
import knou.lms.user.CurrentUser;

/**
 * Controller에서 VO 파라메터 초기화
 */
public class ControllerInitResolver implements HandlerMethodArgumentResolver {
	
	private static final Logger log = LoggerFactory.getLogger(ControllerInitResolver.class);	
	
	@Override
    public boolean supportsParameter(MethodParameter parameter) { // 캐싱되면 두번 들어오지 않는다
		//System.out.println(">>> [DEBUG] Resolver Check for Parameter: " + parameter.getParameterName());
        //return parameter.getParameterType().getSimpleName().endsWith("VO");
		
		// 1. 기존 VO 처리 조건
        if (parameter.getParameterType().getSimpleName().endsWith("VO")) return true;
        // 2. 새로운 UserContext 처리 조건 추가
        if (parameter.hasParameterAnnotation(CurrentUser.class)) return true;
        
        return false;
    }

    @Override
    public Object resolveArgument(MethodParameter parameter,
                                  ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest,
                                  WebDataBinderFactory binderFactory) throws Exception {
    	
    	HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);

    	// [CASE 1] @CurrentUser UserContext 처리
    	if (parameter.hasParameterAnnotation(CurrentUser.class)) {

    	    HttpSession session = request.getSession(false);
    	    
    	    if (session == null) {
	    	    log.info("UserContextResolver.resolveArgument 세션만료");
	            throw new SessionTimeoutException("세션이 존재하지 않습니다.");
    	    }

    	    UserContext userCtx = (session != null) ? (UserContext) session.getAttribute("USER_CONTEXT") : null;

    	    if ( userCtx == null ) {
    	    	log.info("ControllerInitResolver.resolveArgument 세션만료");
    	        throw new SessionTimeoutException("세션이 만료되었거나 로그인 정보가 없습니다.");
    	    }

    	    return userCtx;
    	}        
    	// [CASE 2] 기존 VO 처리 및 ControllerBase.init 호출
        Object paramVO = parameter.getParameterType().getDeclaredConstructor().newInstance();

    	log.info(">>> [DEBUG] Resolver Check for Parameter: " + paramVO);
    	
        WebDataBinder binder = binderFactory.createBinder(webRequest, paramVO, parameter.getParameterName());
        binder.bind(new ServletRequestParameterPropertyValues(request));
        
        log.info("paramVO = {}", paramVO);        
        
        //Enumeration<String> names = request.getParameterNames();

        //while (names.hasMoreElements()) {
        //    String name = names.nextElement();
        //    log.info("{} = {}", name, request.getParameter(name));
        //}

        Object controller = request.getAttribute("CURRENT_CONTROLLER");
        if (controller instanceof ControllerBase) {
            // 이 부분이 실행되어야 로그에 "ControllerBase.init 진입"이 찍힙니다!
            ((ControllerBase) controller).init(request, mavContainer.getModel(), paramVO);
        }

        return paramVO;
    }
}