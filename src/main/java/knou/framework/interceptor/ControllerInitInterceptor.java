package knou.framework.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * Controller 초기화 인터셉터 
 */
@Component
public class ControllerInitInterceptor implements HandlerInterceptor {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>1. ControllerInitInterceptor preHandle");
		
		if (handler instanceof HandlerMethod) {
			HandlerMethod hm = (HandlerMethod) handler;
	        Object controller = hm.getBean();
	        
	        if (controller instanceof String) {
	            ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(request.getServletContext());
	            controller = ctx.getBean((String) controller);
	        }
	        
	        System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>2. ControllerInitInterceptor preHandle toString()>>>>" + controller.toString());
			request.setAttribute("CURRENT_CONTROLLER", controller);
		}

		return true;
	}
	
}
