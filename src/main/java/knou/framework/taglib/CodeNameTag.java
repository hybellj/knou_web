package knou.framework.taglib;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

import org.springframework.web.context.support.WebApplicationContextUtils;

import knou.lms.org.vo.OrgCodeLangVO;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;

/**
 * 지정된 코드에 대한 코드명을 돌려준다.
 * @author shil
 *
 */
@SuppressWarnings("serial")
public class CodeNameTag extends TagSupport {

	private String category;	// 시스템코드 카테고리 
	private String code;		// 시스템코드
	/**
	 * @return the category
	 */
	public String getCategory() {
		return category;
	}
	/**
	 * @param category the category to set
	 */
	public void setCategory(String category) {
		this.category = category;
	}
	/**
	 * @return the code
	 */
	public String getCode() {
		return code;
	}
	/**
	 * @param code the code to set
	 */
	public void setCode(String code) {
		this.code = code;
	}

	public int doEndTag() throws JspException {
	    
		OrgCodeService service =
		        WebApplicationContextUtils.getWebApplicationContext(pageContext.getServletContext()).getBean(OrgCodeService.class);

		if (service == null)
			throw new JspException("Could not load the context service of Web applications.");

		try {
			String codeName = code;
			
	    	if (!StringUtil.nvl(category).equals("")) {
	    		List<OrgCodeVO> codeList = null;
	    		
	    		try {
	    			codeList = service.getOrgCodeList(category);
	    		} catch (Exception e) {
	    			codeList = new ArrayList<OrgCodeVO>();
	    		}
	    		
	    		PageContext context = this.pageContext;
	    		HttpServletRequest req = (HttpServletRequest)context.getRequest();
	    		String locale = SessionInfo.getLocaleKey(req);
	    		
	    		for (OrgCodeVO codeVO :  codeList) {
	    			if ((codeVO.getCd()).equals(code)) {
	    				codeName = codeVO.getCdnm();
	    				for(OrgCodeLangVO codeLangVO : codeVO.getCodeLangList()) {
	    					if(locale.equals(codeLangVO.getLangCd())) codeName = codeLangVO.getCdnm();
	    				}
	    				break;
	    			}
				}
	    	}
			pageContext.getOut().print(codeName);
		} catch (IOException ignored) { }
		
		return EVAL_PAGE;
	}

}
