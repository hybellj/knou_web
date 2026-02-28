package knou.framework.common;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.MessageSource;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import knou.framework.util.LocaleUtil;

/**
 * 메시지 
 * 
 * @author shil
 */
public class Message {
	private HttpServletRequest request;
    private MessageSource messageSource;
	
	
    /**
     * 메시지 객체 생성자
     * 
     * @param request
     */
	public Message(HttpServletRequest request) {
		super();
		ServletContext servletContext = request.getServletContext();
		WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(servletContext);
		this.messageSource = (MessageSource) ctx.getBean("messageSource");
		this.request = request;
	}

	
	/**
	 * 메시지 가져오기
	 * @param key
	 * @param args
	 * @return message
	 */
	public String getMessage(String key, Object...args) {
		String message = "";
		
		try {
			message = messageSource.getMessage(key, args, LocaleUtil.getLocale(request));	
		} catch (Exception e) {
			message = key;
		}
		
		return message;
	}
	
	
	/**
	 * 메시지 가져오기 (JSP에서 참조용)
	 * @param key
	 * @param args
	 * @return message
	 */
	public String get(String key, Object...args) {
		return getMessage(key, args);
	}
}
