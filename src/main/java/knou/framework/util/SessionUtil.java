package knou.framework.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspContext;
import javax.servlet.jsp.PageContext;

/**
 * 세션 유틸리티
 * 
 * @author shil
 */
public class SessionUtil {
	
	/**
	 * Set Session value
	 * @param jspContext
	 * @param name
	 * @param value
	 */
	public static void setSessionValue(JspContext jspContext, String name, Object value) {
		HttpServletRequest request = (HttpServletRequest)((PageContext)jspContext).getRequest();
		setSessionValue(request, name, value);
	}
	
	/**
	 * Set Session value
	 * @param request
	 * @param name
	 * @param value
	 */
	public static void setSessionValue(HttpServletRequest request, String name, Object value) {
		HttpSession session = request.getSession();
		session.setAttribute(name, value);
	}
	
	/**
	 * Get Session value
	 * @param jspContext
	 * @param name
	 * @return sessionValue
	 */
	public static Object getSessionValue(JspContext jspContext, String name) {
		HttpServletRequest request = (HttpServletRequest)((PageContext)jspContext).getRequest();
		return getSessionValue(request, name);
	}
	
	/**
	 * Get Session value
	 * @param request
	 * @param name
	 * @return sessionValue
	 */
	public static Object getSessionValue(HttpServletRequest request, String name) {
		HttpSession session = request.getSession();
		return session.getAttribute(name);
	}
	
	/**
	 * Remove Session value
	 * @param jspContext
	 * @param name
	 * @param value
	 */
	public static void removeSessionValue(JspContext jspContext, String name) {
		HttpServletRequest request = (HttpServletRequest)((PageContext)jspContext).getRequest();
		removeSessionValue(request, name);
	}
	
	/**
	 * Remove Session value
	 * @param request
	 * @param name
	 * @param value
	 */
	public static void removeSessionValue(HttpServletRequest request, String name) {
		HttpSession session = request.getSession();
		session.removeAttribute(name);
	}
	
	/**
	 * Remove all session
	 * @param request
	 */
	public static void removeAll(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.invalidate();
	}
}
