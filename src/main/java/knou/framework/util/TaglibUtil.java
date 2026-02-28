package knou.framework.util;

import java.util.Locale;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspContext;
import javax.servlet.jsp.PageContext;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * Tag library Utilities
 * @author shil
 *
 */
public class TaglibUtil {

	/**
	 * Get HttpServletRequest
	 * @param jspContext
	 * @return request
	 */
	public static HttpServletRequest getRequest(JspContext jspContext) {
		HttpServletRequest request = (HttpServletRequest)((PageContext)jspContext).getRequest();
		
		return request;
	}
	
	/**
	 * Get HttpSession
	 * @param pageContext
	 * @return session
	 */
	public static HttpSession getSession(JspContext jspContext) {
		HttpServletRequest request = getRequest(jspContext);
		HttpSession session = request.getSession();
		
		return session;
	}
	
	/**
	 * Get Session value
	 * @param jspContext
	 * @param name
	 * @return value
	 */
	public static Object getSessionValue(JspContext jspContext, String name) {
		HttpSession session = getSession(jspContext);
		Object value = session.getAttribute(name);
		
		return value;
	}
	
	/**
	 * Get Locale
	 * @param jspContext
	 * @return locale
	 */
	public static Locale getLocale(JspContext jspContext) {
		HttpServletRequest request = getRequest(jspContext);
		Locale locale = request.getLocale();
		
		return locale;
	}
	
	/**
	 * Get Locale
	 * @param jspContext
	 * @return locale
	 */
	public static String getLauguage() {
		String language = LocaleContextHolder.getLocale().toString();
		
		return language;
	}

	/**
	 * Get Context path
	 * @param request
	 * @return contextPath
	 */
	public static String getContextPath(HttpServletRequest request) {
		String contextPath = request.getContextPath();
		
		if (contextPath.equals("/")) {
			contextPath = "";
		}
		
		return contextPath;
	}
	
	/**
	 * Get Context path
	 * @param context
	 * @return contextPath
	 */
	public static String getContextPath(JspContext jspContext) {
		return getContextPath(getRequest(jspContext));
	}
	
	/**
	 * Get Request Attribute
	 * @param jspContext
	 * @param name
	 * @return value
	 */
	public static String getRequestAttribute(JspContext jspContext, String name) {
		String value = StringUtil.nvl((String)(getRequest(jspContext).getAttribute(name)));
		
		return value;
	}
	
	/**
	 * Get Message
	 * @param jspContext
	 * @param key
	 * @param args
	 * @return message
	 */
	public static String getMessage(JspContext jspContext, String key, Object...args) {
		String message = "";
		
		try {
			ServletContext servletContext = ((HttpServletRequest)getRequest(jspContext)).getServletContext();
			WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(servletContext);
			MessageSource messageSource = (MessageSource) ctx.getBean("messageSource");
			
			message = messageSource.getMessage(key, args, getLocale(jspContext));
		}
		catch (Exception e) {
			message = key;
		}
		
		return message;
	}
}
