package knou.framework.taglib;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

import knou.framework.common.Message;
import knou.framework.common.SessionInfo;

/**
 * 메시지 발송 버튼 태그
 * 
 * @author shil
 */
public class MessageSendBtnTag extends TagSupport {
	@SuppressWarnings("unused")
	private static final long serialVersionUID = 1L;
	private String func		= "";	// 호출 함수
	private String styleClass = "ui basic button";	

	
	@Override 
	public int doEndTag() throws JspException {
		try {
			StringBuffer tag = new StringBuffer();
			PageContext context = this.pageContext;
            HttpServletRequest req = (HttpServletRequest)context.getRequest();
            Message message = new Message(req);
			
			// 방송대만 메시지 버튼 표시
            if (SessionInfo.isKnou(req)) {
            	tag.append("<a href=\"javascript:void(0)\" class=\""+styleClass+"\" onclick=\""+func+";return false;\" ");
            	tag.append("title=\""+message.getMessage("common.button.message.send")+"\">");
            	tag.append("<i class=\"paper plane outline icon\"></i> ");
            	tag.append(message.getMessage("common.button.message"));
            	tag.append("</a>");
            }
			
			pageContext.getOut().print(tag);
			
		} catch (Exception e) {
			System.err.println(e);
		}
		
		return EVAL_PAGE;
	}



	public void setFunc(String func) {
		this.func = func;
	}

	public void setStyleClass(String styleClass) {
		this.styleClass = styleClass;
	}
	
}
