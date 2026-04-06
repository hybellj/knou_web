package knou.lms.user;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import knou.framework.context2.UserContext;
import knou.framework.exception.SessionExpiredException;

public class UserContextResolver implements HandlerMethodArgumentResolver {
    
    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        // 파라미터에 @CurrentUser가 있고 타입이 UserContext인 경우에만 동작
    	
    	System.out.println(">>> [DEBUG] UserContextResolver: supportsParameter" + parameter.getParameterName());
        return parameter.hasParameterAnnotation(CurrentUser.class) 
               && parameter.getParameterType().equals(UserContext.class);
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        
    	
    	System.out.println(">>> [DEBUG] UserContextResolver: resolveArgument" + parameter.getParameterName());
    	
        HttpServletRequest request = (HttpServletRequest) webRequest.getNativeRequest();
        
        // false로 설정하여 세션이 없으면 새로 만들지 않고 null을 받음
        HttpSession session = request.getSession(false); 
        
        if (session == null) {
            throw new SessionExpiredException("세션이 존재하지 않습니다.");
        }

        UserContext userCtx = (UserContext) session.getAttribute("USER_CONTEXT");

        if (userCtx == null) {
            // 운영 팁: 여기서 예외를 던지면 GlobalExceptionHandler에서 잡아서 
            // 로그인 페이지로 redirect 시키는 처리를 공통으로 할 수 있습니다.
            throw new SessionExpiredException("사용자 정보가 세션에 없습니다."); 
        }

        return userCtx;
    }
}