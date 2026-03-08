package knou.framework.taglib;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import knou.framework.common.CodeInfo;

/**
 * 시스템 공통 코드명 반환
 */
public class CodeNameTag extends TagSupport {
	private static final long serialVersionUID = -314627422476771886L;
	private static Log log = LogFactory.getLog(CodeNameTag.class);

	private String orgId;	// 기관코드 (기관을 직접 지정하여 코드명을 가져올 경우만 사용)
	private String upCd;	// 상위코드
	private String cd;		// 코드


	public int doEndTag() throws JspException{
		try {
			PageContext context = this.pageContext;
            HttpServletRequest req = (HttpServletRequest)context.getRequest();
            String codeName = "";

            if (orgId != null && !"".equals(orgId)) {
            	codeName = CodeInfo.getOrgCodeName(req, orgId, upCd, cd);
            }
            else {
            	codeName = CodeInfo.getCodeName(req, upCd, cd);
            }

			pageContext.getOut().print(codeName);
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return EVAL_PAGE;
	}



	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}


	public void setUpCd(String upCd) {
		this.upCd = upCd;
	}


	public void setCd(String cd) {
		this.cd = cd;
	}

}
