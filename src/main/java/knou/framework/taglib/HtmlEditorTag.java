package knou.framework.taglib;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * HTML Editor 태그
 */
public class HtmlEditorTag extends TagSupport {
	private static final long serialVersionUID = 9216972039111953258L;
	private static Log log = LogFactory.getLog(HtmlEditorTag.class);
	
	private String id;
	private String name;
	private String value;
	private String uploadPath;
	private String videoUpYn = "N";
	private int uploadMaxSize = 0;
	private int height = 0;
	
	
	
	public int doEndTag() throws JspException{
		try {
			StringBuilder tag = new StringBuilder();
			
			tag.append("<label for=\""+id+"\" class=\"hide\">Content</label>");
			tag.append("<textarea name=\""+name+"\" id=\""+id+"\">");
			tag.append(value);
			tag.append("</textarea>\n");
			tag.append("<script>");
			tag.append("let "+id+"_editor = HtmlEditor('"+id+"', '', '"+uploadPath+"', '"+videoUpYn+"', "+uploadMaxSize+", "+height+");");
			tag.append("</script>");
			
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

	public void setName(String name) {
		this.name = name;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public void setUploadPath(String uploadPath) {
		this.uploadPath = uploadPath;
	}

	public void setHeight(int height) {
		this.height = height;
	}
		
}
