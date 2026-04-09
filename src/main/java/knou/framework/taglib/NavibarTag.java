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
import knou.framework.common.SessionInfo;
import knou.lms.menu.vo.MenuVO;

/**
 * 네비게이션바 표시
 */
public class NavibarTag extends TagSupport {
	private static final long serialVersionUID = 2748639843830369723L;
	private static Log log = LogFactory.getLog(NavibarTag.class);

	private String type;	// 유형 (메인화면:main, 강의실:lect)


	public int doEndTag() throws JspException{
		try {
			PageContext context = this.pageContext;
            HttpServletRequest req = (HttpServletRequest)context.getRequest();
            Message message = new Message(req);
            StringBuffer tag = new StringBuffer();

            String orgId = ParamInfo.getParamValue(req, "orgId");
            if (orgId == null || "".equals(orgId)) {
            	orgId = SessionInfo.getOrgId(req);
            }

            String authrtGrpcd	= SessionInfo.getAuthrtGrpcd(req);
            String upMenuId		= ParamInfo.getParamValue(req, "upMenuId");
            String menuId		= ParamInfo.getParamValue(req, "menuId");
            String sbjctId		= ParamInfo.getParamValue(req, "sbjctId");

            tag.append("<div class='navi_bar'>");
            tag.append("<ul>");
            tag.append("<li><i class='xi-home-o' aria-hidden='true'></i><span class='sr-only'>Home</span></li>");

            if ("lect".equalsIgnoreCase(type)) {
            	tag.append("<li>" + message.getMessage("common.label.classroom") + "</li>");
            }

            if (menuId != null && !"".equals(menuId)) {
	            MenuVO menuVO = new MenuVO();
	            menuVO.setOrgId(orgId);
	            menuVO.setMenuTycd(authrtGrpcd);
	            menuVO.setMenuGbncd(type.toUpperCase());

	            List<MenuVO> menuList = null;
	            if ("main".equalsIgnoreCase(type)) {
	            	menuList = MenuInfo.getMenuInfo(req, menuVO);
	            }
	            else if ("lect".equalsIgnoreCase(type)) {
	            	menuVO.setSbjctId(sbjctId);
	            	menuList = MenuInfo.getLectMenuInfo(req, menuVO);
	            }

	            if (menuList != null && !menuList.isEmpty()) {
		            for (MenuVO vo : menuList) {
		            	if (!"ROOT".equals(upMenuId) && vo.getMenuId().equals(upMenuId)) {
		            		tag.append("<li>" + vo.getMenunm() + "</li>");

		            		List<MenuVO> subList = vo.getSubMenuList();
		            		for (MenuVO subVO : subList) {
		            			if (subVO.getMenuId().equals(menuId)) {
		            				tag.append("<li><span class='current'>" + subVO.getMenunm() + "</span></li>");
		            				break;
		            			}
		            		}
		            		break;
		            	}
		            	else if (vo.getMenuId().equals(menuId)) {
		            		tag.append("<li><span class='current'>" + vo.getMenunm() + "</span></li>");
		            		break;
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
