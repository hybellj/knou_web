package knou.lms.common.web.view;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public class BoardViewModel {	
	
	List<EgovMap>	dashCrsNoticeList;
	
	List<EgovMap>	profDashAllNoticeList;	
	List<EgovMap>	profDashSubjectNoticeList;
	List<EgovMap>	profDashLctrQnaList;
	List<EgovMap>	profDashOneOnOneList;
	
	List<EgovMap>	stdntDashAllNoticeList;	
	List<EgovMap>	stdntDashSubjectNoticeList;
	List<EgovMap>	stdntDashLctrQnaList;
	List<EgovMap>	stdntDashDatarmList;
	
	EgovMap			badge;
	
	List<EgovMap>	subjectTopNoticeList;
	List<EgovMap>	subjectTopLctrQnaList;
	
	List<EgovMap>	profSubjectTopOneOnOneList;
	List<EgovMap>	stdntSubjectTopDatarmList;
	
	String			viewName;

	public List<EgovMap> getDashCrsNoticeList() {
		return dashCrsNoticeList;
	}

	public void setDashCrsNoticeList(List<EgovMap> dashCrsNoticeList) {
		this.dashCrsNoticeList = dashCrsNoticeList;
	}

	public List<EgovMap> getProfDashAllNoticeList() {
		return profDashAllNoticeList;
	}

	public void setProfDashAllNoticeList(List<EgovMap> profDashAllNoticeList) {
		this.profDashAllNoticeList = profDashAllNoticeList;
	}

	public List<EgovMap> getProfDashSubjectNoticeList() {
		return profDashSubjectNoticeList;
	}

	public void setProfDashSubjectNoticeList(List<EgovMap> profDashSubjectNoticeList) {
		this.profDashSubjectNoticeList = profDashSubjectNoticeList;
	}

	public List<EgovMap> getProfDashLctrQnaList() {
		return profDashLctrQnaList;
	}

	public void setProfDashLctrQnaList(List<EgovMap> profDashLctrQnaList) {
		this.profDashLctrQnaList = profDashLctrQnaList;
	}

	public List<EgovMap> getProfDashOneOnOneList() {
		return profDashOneOnOneList;
	}

	public void setProfDashOneOnOneList(List<EgovMap> profDashOneOnOneList) {
		this.profDashOneOnOneList = profDashOneOnOneList;
	}

	public List<EgovMap> getStdntDashAllNoticeList() {
		return stdntDashAllNoticeList;
	}

	public void setStdntDashAllNoticeList(List<EgovMap> stdntDashAllNoticeList) {
		this.stdntDashAllNoticeList = stdntDashAllNoticeList;
	}

	public List<EgovMap> getStdntDashSubjectNoticeList() {
		return stdntDashSubjectNoticeList;
	}

	public void setStdntDashSubjectNoticeList(List<EgovMap> stdntDashSubjectNoticeList) {
		this.stdntDashSubjectNoticeList = stdntDashSubjectNoticeList;
	}

	public List<EgovMap> getStdntDashLctrQnaList() {
		return stdntDashLctrQnaList;
	}

	public void setStdntDashLctrQnaList(List<EgovMap> stdntDashLctrQnaList) {
		this.stdntDashLctrQnaList = stdntDashLctrQnaList;
	}

	public List<EgovMap> getStdntDashDatarmList() {
		return stdntDashDatarmList;
	}

	public void setStdntDashDatarmList(List<EgovMap> stdntDashDatarmList) {
		this.stdntDashDatarmList = stdntDashDatarmList;
	}

	public EgovMap getBadge() {
		return badge;
	}

	public void setBadge(EgovMap badge) {
		this.badge = badge;
	}

	public List<EgovMap> getSubjectTopNoticeList() {
		return subjectTopNoticeList;
	}

	public void setSubjectTopNoticeList(List<EgovMap> subjectTopNoticeList) {
		this.subjectTopNoticeList = subjectTopNoticeList;
	}

	public List<EgovMap> getSubjectTopLctrQnaList() {
		return subjectTopLctrQnaList;
	}

	public void setSubjectTopLctrQnaList(List<EgovMap> subjectTopLctrQnaList) {
		this.subjectTopLctrQnaList = subjectTopLctrQnaList;
	}

	public List<EgovMap> getProfSubjectTopOneOnOneList() {
		return profSubjectTopOneOnOneList;
	}

	public void setProfSubjectTopOneOnOneList(List<EgovMap> profSubjectTopOneOnOneList) {
		this.profSubjectTopOneOnOneList = profSubjectTopOneOnOneList;
	}

	public List<EgovMap> getStdntSubjectTopDatarmList() {
		return stdntSubjectTopDatarmList;
	}

	public void setStdntSubjectTopDatarmList(List<EgovMap> stdntSubjectTopDatarmList) {
		this.stdntSubjectTopDatarmList = stdntSubjectTopDatarmList;
	}

	public String getViewName() {
		return viewName;
	}

	public void setViewName(String viewName) {
		this.viewName = viewName;
	}
}