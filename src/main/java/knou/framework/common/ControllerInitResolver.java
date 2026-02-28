package knou.framework.common;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;

import org.springframework.core.MethodParameter;
import org.springframework.web.bind.ServletRequestParameterPropertyValues;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

/**
 * Controller에서 VO 파라메터 초기화
 */
public class ControllerInitResolver implements HandlerMethodArgumentResolver {
	@Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.getParameterType().getSimpleName().endsWith("VO");
    }

    @Override
    public Object resolveArgument(MethodParameter parameter,
                                  ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest,
                                  WebDataBinderFactory binderFactory) throws Exception {

        Object paramVO = parameter.getParameterType().getDeclaredConstructor().newInstance();
        WebDataBinder binder = binderFactory.createBinder(webRequest, paramVO, parameter.getParameterName());
        ServletRequest request = webRequest.getNativeRequest(ServletRequest.class);
        binder.bind(new ServletRequestParameterPropertyValues(request));

        HttpServletRequest httpRequest = webRequest.getNativeRequest(HttpServletRequest.class);
        Object controller = httpRequest.getAttribute("CURRENT_CONTROLLER");

        if (controller instanceof ControllerBase) {
        	// ConrollerBase의 init 호출
            ((ControllerBase) controller).init(httpRequest, mavContainer.getModel(), paramVO);
        }

        return paramVO;
    }
}
