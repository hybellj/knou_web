package knou.framework.taglib;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import org.springframework.web.context.support.WebApplicationContextUtils;

import knou.lms.org.vo.OrgCodeVO;
import knou.lms.org.service.OrgCodeMemService;
import knou.framework.util.StringUtil;

/**
 * 지정된 코드에 대한 코드명을 돌려준다.
 * @author shil
 *
 */
@SuppressWarnings("serial")
public class OrgCodeNameTag extends TagSupport {

	private String category;	// 시스템코드 카테고리
	private String code;		// 시스템코드
	private String orgId;		// 기관코드
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
	/**
	 * @return the orgId
	 */
	public String getOrgId() {
		return orgId;
	}
	/**
	 * @param orgId the code to set
	 */
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}


	public int doEndTag() throws JspException {
		OrgCodeMemService service = WebApplicationContextUtils
				.getWebApplicationContext(pageContext.getServletContext())
				.getBean(OrgCodeMemService.class);

		if (service == null)
			throw new JspException("웹어플리케이션 컨텍스트의 서비스를 로드하지 못했습니다.");

		try {
			String codeName = code;

	    	if (!StringUtil.nvl(category).equals("")) {
	    		List<OrgCodeVO> codeList ;
	    		try {
	    			codeList = service.getOrgCodeList(category,orgId);
	    		} catch (Exception e) {
	    			codeList = new ArrayList<OrgCodeVO>(); 
	    		}

	    		for (OrgCodeVO socvo :  codeList) {
	    			if ((socvo.getCd()).equals(code)) {
	    				codeName = socvo.getCdnm();
	    				break;
	    			}
				}

	    	}

			pageContext.getOut().print(codeName);
		}
		catch (IOException ignored) { }

		return EVAL_PAGE;
	}

}
