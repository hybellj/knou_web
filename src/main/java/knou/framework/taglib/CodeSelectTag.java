package knou.framework.taglib;

import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import knou.framework.common.CodeInfo;
import knou.framework.common.Message;
import knou.framework.util.StringUtil;
import knou.lms.system.code.vo.SysCmmnCdVO;

/**
 * 시스템 공통 코드 selectbox 생성
 */
public class CodeSelectTag extends TagSupport {
	private static final long serialVersionUID = -314627422476771886L;
	private static Log log = LogFactory.getLog(CodeSelectTag.class);

	private String id;				// selectbox 필드ID
	private String name;			// selectbox 필드명
	private String orgId;			// 기관코드 (기관을 직접 지정하여 코드명을 가져올 경우만 사용)
	private String upCd;			// 상위코드
	private String selectedVal;		// 선택된 값
	private String onchange;		// 값을 선택할때 호출할 함수
	private String title;			// 타이틀 (메시지코드)
	private String selectMsg;		// option 의 맨 첫번째 항목에 표시할 메시지, 생략할 경우 상위코드명 표시 (메시지코드)
	private String style;			// 스타일
	private String styleClass;		// 스타일 클래스
	private String required;		// 필수 선택 여부 true/false
	private String multiple;		// 멀티 선택 여부 true/false


	public int doEndTag() throws JspException{
		try {
			StringBuffer tag = new StringBuffer();
			PageContext context = this.pageContext;
            HttpServletRequest req = (HttpServletRequest)context.getRequest();
            Message message = new Message(req);
            List<SysCmmnCdVO> codeList = null;

            if (!"".equals(StringUtil.nvl(id))) {
				id = "selectbox_" + UUID.randomUUID().toString().replace("-", "").substring(0, 4);
			}

            if (!"".equals(StringUtil.nvl(styleClass))) {
            	if (styleClass.indexOf("form-select") == -1) {
            		styleClass = "form-select " + styleClass;
            	}
				if (styleClass.indexOf("chosen") == -1) {
					styleClass += " chosen";
				}
			}
            else {
            	styleClass = "form-select chosen";
            }

			if (!"".equals(StringUtil.nvl(title))) {
				title = message.get(title);
			}
			else {
				title = message.get("common.item.select.msg"); // 항목을 선택하세요.
			}

			if (!"".equals(StringUtil.nvl(selectMsg))) {
				selectMsg = message.get(selectMsg);
			}

			if ("true".equals(StringUtil.nvl(multiple))) {
				multiple = " multiple=\"true\"";
			}
			else {
				multiple = "";
			}

			if ("true".equals(StringUtil.nvl(required))) {
				required = " required=\"true\"";
			}
			else {
				required = "";
			}

			if (!"".equals(StringUtil.nvl(onchange))) {
				onchange = " onchange=\""+onchange+"(this.value)\"";
			}
			else {
				onchange = "";
			}

			String placeHolder = selectMsg;
			if ("".equals(StringUtil.nvl(placeHolder))) {
				placeHolder = title;
			}

			// 코드목록 가져오기
            if (!"".equals(StringUtil.nvl(orgId))) {
            	codeList = CodeInfo.getOrgCodeList(req, orgId, upCd);
            }
            else {
            	codeList = CodeInfo.getCodeList(req, upCd);
            }

            tag.append("<label for=\""+id+"\" class=\"hide\">Select</label>");
            tag.append("<select id=\""+id+"\" id=\""+name+"\" class=\""+styleClass+"\" title=\""+title+"\" style=\""+style+"\"" + onchange + multiple + required + " data-placeholder=\""+placeHolder+"\">");

            for (SysCmmnCdVO vo : codeList) {
            	if (vo.getCdSeqno() == 0) {
            		if ("".equals(StringUtil.nvl(selectMsg))) {
            			selectMsg = vo.getCdnm();
            		}
            		tag.append("<option value=\"\">:: "+selectMsg+" ::</option>");
            	}
            	else {
            		String selected = "";
            		if (!"".equals(StringUtil.nvl(selectedVal)) && vo.getCd().equals(selectedVal)) {
            			selected = " selected=\"selected\"";
            		}

            		tag.append("<option value=\""+vo.getCd()+"\""+selected+">"+vo.getCdnm()+"</option>");
            	}
            }

            tag.append("</select>");

			pageContext.getOut().println(tag.toString());
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

	public void setId(String id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setSelectedVal(String selectedVal) {
		this.selectedVal = selectedVal;
	}

	public void setOnchange(String onchange) {
		this.onchange = onchange;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public void setSelectMsg(String selectMsg) {
		this.selectMsg = selectMsg;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	public void setStyleClass(String styleClass) {
		this.styleClass = styleClass;
	}

	public void setRequired(String required) {
		this.required = required;
	}

	public void setMultiple(String multiple) {
		this.multiple = multiple;
	}

}
