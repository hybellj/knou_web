package knou.lms.common.dto;

import knou.framework.context2.UserContext;

public class CalendarDTO extends SubjectDTO {

	public CalendarDTO(UserContext userCtx) {
		super(userCtx);
	}
	
	public CalendarDTO() {}	
	
	private	String	startDttm;
	private	String	endDttm;
	private	String	viewTycd;
	
	public String getStartDttm() {
		return startDttm;
	}
	public void setStartDttm(String startDttm) {
		this.startDttm = startDttm;
	}
	public String getEndDttm() {
		return endDttm;
	}
	public void setEndDttm(String endDttm) {
		this.endDttm = endDttm;
	}
	public String getViewTycd() {
		return viewTycd;
	}
	public void setViewTycd(String viewTycd) {
		this.viewTycd = viewTycd;
	}	
	
	/**
	 * 부모 클래스(CommonDTO)의 변수와 현재 클래스의 변수를 모두 출력하는 toString
	 */
	@Override
	public String toString() {
		return "CalendarDTO ["
				+ "userId=" + getUserId() + ", "      // 부모 DTO 변수
				+ "searchText=" + getSearchText() + ", "    // 부모 DTO 변수
				+ "searchValue=" + getSearchValue() + ", "    // 부모 DTO 변수
				+ "startDttm=" + startDttm + ", " 
				+ "endDttm=" + endDttm + ", " 
				+ "viewTycd=" + viewTycd 
				+ "]";
	}
}