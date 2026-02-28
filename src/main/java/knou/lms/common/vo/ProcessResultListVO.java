package knou.lms.common.vo;

import java.util.List;

import org.apache.ibatis.type.Alias;

import knou.lms.common.AbstractResult;
import knou.lms.common.paging.PagingInfo;

@Alias("processResultListVO")
public class ProcessResultListVO<T> extends AbstractResult {

	private List<T> returnList;
	
	private PagingInfo pageInfo;

	public ProcessResultListVO() {
		super();
	}

	public ProcessResultListVO(List<T> returnList) {
		super();
		this.returnList = returnList;
	}

	public List<T> getReturnList() {
		return returnList;
	}

	public void setReturnList(List<T> returnList) {
		this.returnList = returnList;
	}

	public PagingInfo getPageInfo() {
		return pageInfo;
	}

	public void setPageInfo(PagingInfo pageInfo) {
		this.pageInfo = pageInfo;
	}

}