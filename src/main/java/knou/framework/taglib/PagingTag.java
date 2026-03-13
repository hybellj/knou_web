package knou.framework.taglib;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import knou.framework.common.Message;
import knou.framework.common.PageInfo;


/**
 * 페이지 정보 출력
 */
public class PagingTag extends TagSupport {
	private static final long serialVersionUID = 2508056547525242158L;
	private static Log log = LogFactory.getLog(PagingTag.class);

	private String pageFunc;					// 페이지 이동 Javascript 함수
	private PageInfo pageInfo;					// 페이지 정보
	private boolean showTotRecord = true;		// 전체 페이지 정보 표시 여부 (true/false), 기본값 true
	private boolean showCurrentPage = true;	// 현재 페이지 정보 표시 여부 (true/false), 기본값 true


	public int doEndTag() throws JspException{
		try {
			StringBuilder tag = new StringBuilder();
			PageContext context = this.pageContext;
            HttpServletRequest req = (HttpServletRequest)context.getRequest();
            Message message = new Message(req);

			int pageNo = pageInfo.getCurrentPageNo();
			int prev = (pageNo > 1) ? pageNo -1 : 1;
			int next = (pageNo < pageInfo.getLastPageNo()) ? pageNo + 1 : pageInfo.getLastPageNo();
			int last = pageInfo.getLastPageNo();
			String firstStatus = (pageNo == 1) ? "disabled" : "";
			String prevStatus = (pageNo == 1) ? "disabled" : "";
			String nextStatus = (pageNo == pageInfo.getLastPageNo()) ? "disabled" : "";
			String lastStatus = (pageNo == pageInfo.getLastPageNo()) ? "disabled" : "";

			tag.append("<div class='board_foot'>\n");
			tag.append("<div class='page_info'>\n");

			if (showTotRecord) {
				tag.append("<span class='total_page'>"+message.getMessage("common.paging.tot_count", pageInfo.getTotalRecordCount())+"</span>");
			}

			if (showCurrentPage) {
				tag.append("<span class='"+(showTotRecord ? "current_page" : "current_page_info")+"'>"+message.getMessage("common.paging.cur_page"));
				tag.append(" <strong>"+pageNo+"</strong>/"+pageInfo.getTotalPageCount()+"</span>\n");
			}

			tag.append("</div>\n");
			tag.append("<div class='board_pager'><span class='inner'>\n");

			tag.append("<button class='page' type='button' role='button' aria-label='First Page' title='"+message.getMessage("common.paging.first_page")+"' data-page='1' "+firstStatus+" onclick='"+pageFunc+"(1)'><i class='icon-page-first'></i></button>\n");
			tag.append("<button class='page' type='button' role='button' aria-label='Prev Page' title='"+message.getMessage("common.paging.prev_page")+"' data-page='"+prev+"' "+prevStatus+" onclick='"+pageFunc+"("+prev+")'><i class='icon-page-prev'></i></button>\n");
			tag.append("<span class='pages'>\n");

			for (int i = pageInfo.getFirstPageNoOnPageList(); i <= pageInfo.getLastPageNoOnPageList(); i++) {
	            tag.append("<button class='page"+(i == pageNo ? " active" : "")+"' type='button' role='button' aria-label='Page "+i+"' title='"+message.getMessage("common.paging.page", i)+"' data-page='"+i+"' onclick='"+pageFunc+"("+i+")'>"+i+"</button>\n");
	        }

			tag.append("</span>\n");
			tag.append("<button class='page' type='button' role='button' aria-label='Next Page' title='"+message.getMessage("common.paging.next_page")+"' data-page='"+next+"' "+nextStatus+" onclick='"+pageFunc+"("+next+")'><i class='icon-page-next'></i></button>\n");
			tag.append("<button class='page' type='button' role='button' aria-label='Last Page' title='"+message.getMessage("common.paging.last_page")+"' data-page='"+last+"' "+lastStatus+" onclick='"+pageFunc+"("+last+")'><i class='icon-page-last'></i></button>\n");

			tag.append("</span></div>\n");
			tag.append("</div>");

			pageContext.getOut().println(tag.toString());

		}catch (IOException e) {
			log.error(e.getMessage());
		}
		return EVAL_PAGE;
	}


	public void setPageFunc(String pageFunc) {
		this.pageFunc = pageFunc;
	}

	public void setPageInfo(PageInfo pageInfo) {
		this.pageInfo = pageInfo;
	}

	public void setShowTotRecord(boolean showTotRecord) {
		this.showTotRecord = showTotRecord;
	}

	public void setShowCurrentPage(boolean showCurrentPage) {
		this.showCurrentPage = showCurrentPage;
	}
}
