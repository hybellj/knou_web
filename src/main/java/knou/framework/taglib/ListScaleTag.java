package knou.framework.taglib;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * 목록 스케일 태그
 */
public class ListScaleTag extends TagSupport {
	private static final long serialVersionUID = 3648062516745554124L;
	private static Log log = LogFactory.getLog(ListScaleTag.class);

	private static final int[] SCALES = {10, 20, 30, 50, 100};
	private String id;
	private int value = 20;
	private String func;
	private String styleClass;

	public int doEndTag() throws JspException{
		try {
			StringBuilder tag = new StringBuilder();

			if (id == null || "".equals(id)) {
				id = "listScale_" + UUID.randomUUID().toString().replace("-", "").substring(0, 4);
			}

			if (styleClass == null || "".equals(styleClass)) {
				styleClass = "form-select type-num chosen";
			}

			tag.append("<label for=\""+id+"\" class=\"hide\">List scale</label>");
			tag.append("<select id=\""+id+"\" class=\""+styleClass+"\" onchange=\""+func+"(this.value)\" title=\"List scale\" style=\"width:55px\">");

			for (int sc : SCALES) {
				String selected = "";
				if (value == sc) {
					selected = " selected";
				}
				tag.append("<option value=\""+sc+"\""+selected+">"+sc+"</option>");
			}

			tag.append("</select>");

			pageContext.getOut().println(tag.toString());
		}
		catch (IOException e) {
			log.error(e.getMessage());
		}

		return EVAL_PAGE;
	}



	public void setId(String id) {
		this.id = id;
	}

	public void setValue(int value) {
		this.value = value;
	}

	public void setFunc(String func) {
		this.func = func;
	}

	public void setStyleClass(String styleClass) {
		this.styleClass = styleClass;
	}
}
