package knou.lms.common.paging;

import java.io.Serializable;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public class PagingInfo extends PaginationInfo implements Serializable{
    
	private static final long serialVersionUID = -5862720655440610750L;

	public int rowNum(int idx) { return (this.getTotalRecordCount() - ((this.getCurrentPageNo() - 1) * this.getRecordCountPerPage())) - idx; }
}
