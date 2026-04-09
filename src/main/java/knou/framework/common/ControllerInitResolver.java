package knou.framework.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.core.MethodParameter;
import org.springframework.web.bind.ServletRequestParameterPropertyValues;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import knou.framework.exception.SessionTimeoutException;
import knou.lms.user.CurrentUser;

/**
 * Controller에서 VO 파라메터 초기화
 */
public class ControllerInitResolver implements HandlerMethodArgumentResolver {
	@Override
    public boolean supportsParameter(MethodParameter parameter) {
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
            Object userContext = (session != null) ? session.getAttribute("USER_CONTEXT") : null;

            // 세션이 없거나 유저 정보가 없으면 여기서 즉시 예외 발생
            if (userContext == null) {
                // 사용자 정의 예외를 던집니다 (예: SessionTimeoutException)
                // 이 예외는 ExcepHandler로 넘어가서 딱 한 번의 로그를 남깁니다.
                throw new SessionTimeoutException("세션이 만료되었거나 로그인 정보가 없습니다.");
            }
            
            return userContext;
        }
        

        // [CASE 2] 기존 VO 처리 및 ControllerBase.init 호출
        Object paramVO = parameter.getParameterType().getDeclaredConstructor().newInstance();
        WebDataBinder binder = binderFactory.createBinder(webRequest, paramVO, parameter.getParameterName());
        binder.bind(new ServletRequestParameterPropertyValues(request));

        Object controller = request.getAttribute("CURRENT_CONTROLLER");
        if (controller instanceof ControllerBase) {
            // 이 부분이 실행되어야 로그에 "ControllerBase.init 진입"이 찍힙니다!
            ((ControllerBase) controller).init(request, mavContainer.getModel(), paramVO);
        }

        return paramVO;
    }
}
