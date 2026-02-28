package knou.framework.taglib;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

/**
 * javascript 참조 파일 위치를 생성해준다.
 *
 * @author 장철웅
 */
public class JsTag extends TagSupport {

	private static final long serialVersionUID = 8579777631200693967L;

	private String src;

	/**
	 * javascript 소스위치를 돌려준다.
	 *
	 * @return Returns the src.
	 */
	public String getSrc() {
		return src;
	}

	/**
	 * javascript 소스위치를 셋팅한다.
	 *
	 * @param src
	 * The src to set.
	 */
	public void setSrc(String src) {
		this.src = src;
	}

	/**
	 * 자바스크립트 링크를 출력해준다.
	 */
	public int doEndTag() throws JspException {
		HttpServletRequest req = (HttpServletRequest)pageContext.getRequest();
		String lmsContext = req.getContextPath();

		StringBuilder tag = new StringBuilder()
				.append("<script type=\"text/JavaScript\" src=\"")
				.append(lmsContext).append(src)
				.append("\"></script>");
		try {
			pageContext.getOut().print(tag.toString());
		} catch (IOException ignore) {
		}
		return EVAL_PAGE;
	}
}
