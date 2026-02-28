package knou.framework.exception;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

public class MediSimpleExceptionResolver extends SimpleMappingExceptionResolver {
	protected final Log log = LogFactory.getLog(this.getClass());
	
	/** service 
	@Autowired @Qualifier("logExceptionMapper")
	private LogExceptionMapper 		logExceptionMapper;
	*/
	@Override
	protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
		
		try {
			log.error("Exception:", ex);
			
		} catch (Exception e) {
			log.error(e.getMessage());
		}
				
		String viewName = determineViewName(ex, request);
		if(viewName != null) {
			if(logger.isDebugEnabled()) {
				logger.debug("Called AJAX : "+request.getHeader("AJAX"));
			}
			
			if(request.getHeader("AJAX") != null && request.getHeader("AJAX").equals("true")) {
				Integer statusCode = determineStatusCode(request, viewName);
				if(statusCode != null) {
					applyStatusCodeIfPossible(request, response, statusCode);
				}
			}
			return getModelAndView(viewName, ex, request);
		} else {
			return null;
		}		
	}
}
