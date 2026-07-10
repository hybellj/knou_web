package knou.framework.taglib;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import knou.framework.common.MenuInfo;
import knou.framework.common.Message;
import knou.framework.common.ParamInfo;

/**
 * 네비게이션바 표시
 */
public class NavibarTag extends TagSupport {
	private static final long serialVersionUID = 2748639843830369723L;
	private static Log log = LogFactory.getLog(NavibarTag.class);

	private String type;	// 유형 (메인화면:main, 강의실:lect, 관리자:admin)


	public int doEndTag() throws JspException{
		try {
			PageContext context = this.pageContext;
            HttpServletRequest request = (HttpServletRequest)context.getRequest();
            Message message = new Message(request);
            StringBuffer tag = new StringBuffer();

            String menuId		= ParamInfo.getParamValue(request, "menuId");

            tag.append("<div class='navi_bar'>");
            tag.append("<ul>");
            tag.append("<li><i class='xi-home-o' aria-hidden='true'></i><span class='sr-only'>Home</span></li>");

            if ("lect".equalsIgnoreCase(type)) {
            	tag.append("<li>" + message.getMessage("common.label.classroom") + "</li>");
            }

            if (menuId != null && !"".equals(menuId)) {
            	List<String> menuNmList = MenuInfo.getMenuNaviInfo(request);

            	if (menuNmList != null && !menuNmList.isEmpty()) {
            		for (int i = 0; i < menuNmList.size(); i++) {
            		    String menuNm = menuNmList.get(i);

            		    if (i == menuNmList.size() - 1) {
            		    	tag.append("<li><span class='current'>" + menuNm + "</span></li>");
            		    }
            		    else {
            		    	tag.append("<li>" + menuNm + "</li>");
            		    }
            		}
                }
            }

            tag.append("</ul>");
            tag.append("</div>");

			pageContext.getOut().print(tag.toString());
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return EVAL_PAGE;
	}


	public void setType(String type) {
		this.type = type;
	}
}
