package knou.framework.taglib;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import knou.lms.common.paging.PagingInfo;


/**
 * ListDTO를 사용하여 페이징 페이지를 출력할 시 페이지 구분을 출력해준다. 
 * @author 장철웅
 */
public class PagingTag extends TagSupport {
	private static final long serialVersionUID = 2508056547525242158L;
	
	private String funcName;
	private PagingInfo pageInfo;

	/**
	 * 페이지번호를 클릭했을때 호출되는 자바스크립트 함수명을 설정한다.
	 * @param funcName
	 */
	public void setFuncName(String funcName) {
		this.funcName = funcName;
	}

	
	/**
	 * PageInfo를 직접 설정한다. (name, property를 사용하지 않아도 된다.)
	 * @param pageInfo
	 */
	public void setPageInfo(PagingInfo pageInfo) {
		this.pageInfo = pageInfo;
	}

	/**
	 * 페이징 번호를 출력해준다.
	 */
	public int doEndTag() throws JspException{
		try {
			int startPage = ((pageInfo.getCurrentPageNo() - 1) / pageInfo.getPageSize())  * pageInfo.getPageSize() + 1 ; 
			int endPage = (pageInfo.getTotalPageCount() - startPage) >= pageInfo.getPageSize() ? (startPage-1) + pageInfo.getPageSize()  : pageInfo.getTotalPageCount() ;
			
			StringBuilder page = new StringBuilder();
			if(endPage > 1) {
				page.append("<div class=\"paging\">");
				page.append("	<button type=\"button\" class=\"pg_first "+(pageInfo.getCurrentPageNo() == 1?"disable" : "")+" \" onclick=\"javascript:"+funcName+"(1)\">첫 페이지로 가기</button>");
				if(pageInfo.getCurrentPageNo() == 1) {
					page.append("	<button type=\"button\" class=\"pg_prev "+(pageInfo.getCurrentPageNo() == 1?"disable" : "")+" \" onclick=\"javascript:"+funcName+"(1)\">이전 페이지로 가기</button>");
				}
				else{	
					page.append("	<button type=\"button\" class=\"pg_prev "+(pageInfo.getCurrentPageNo() == 1?"disable" : "")+" \" onclick=\"javascript:"+funcName+"("+(pageInfo.getCurrentPageNo()-1)+")\">이전 페이지로 가기</button>");
				}
				for(int i= startPage; i<=endPage ; i++ ) {
					page.append("	<a title=\"현재페이지\" href=\"javascript:"+funcName+"("+i+")\" class=\""+(i==pageInfo.getCurrentPageNo()?"current" : "")+"\">"+i+"</a>");
				}
				if(pageInfo.getCurrentPageNo() !=  pageInfo.getTotalPageCount()) {
					page.append("	<button type=\"button\" class=\"pg_next "+(pageInfo.getCurrentPageNo() == pageInfo.getTotalPageCount()?"disable" : "")+" \" onclick=\"javascript:"+funcName+"("+(pageInfo.getCurrentPageNo()+1)+")\">다음 페이지로 가기</button>");
				}else {
					page.append("	<button type=\"button\" class=\"pg_next "+(pageInfo.getCurrentPageNo() == pageInfo.getTotalPageCount()?"disable" : "")+" \" onclick=\"javascript:"+funcName+"("+pageInfo.getCurrentPageNo()+")\">다음 페이지로 가기</button>");
				}
				page.append("	<button type=\"button\" class=\"pg_last "+(pageInfo.getCurrentPageNo() == pageInfo.getTotalPageCount()?"disable" : "")+" \" onclick=\"javascript:"+funcName+"("+pageInfo.getTotalPageCount()+")\">마지막 페이지로 가기</button>");
				page.append("</div>");
			}
			
			pageContext.getOut().println(page.toString());			

		} catch (IOException ignored) { }
		return EVAL_PAGE;
	}
}
