package knou.lms.mrk.vo;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public class MarkView {
	
	List<EgovMap> bySubjectAsmtList;
	
	List<EgovMap> bySubjectDscsList;
	
	List<EgovMap> bySubjectQuizList;
	
	List<EgovMap> bySubjectExamList;
	
	List<EgovMap> bySubjectSrvyList;
	
	List<EgovMap> bySubjectSmnrList;
	
	List<EgovMap> mrkActvItmRateList;
	
	List<EgovMap> mrkItmStngList;
	
	private String	viewName;	
	
	public MarkView () {}	

	public String getViewName() {
		return viewName;
	}

	public void setViewName(String viewName) {
		this.viewName = viewName;
	}

	public List<EgovMap> getMrkItmStngList() {
		return mrkItmStngList;
	}

	public void setMrkItmStngList(List<EgovMap> mrkItmStngList) {
		this.mrkItmStngList = mrkItmStngList;
	}
	
	public List<EgovMap> getBySubjectAsmtList() {
		return bySubjectAsmtList;
	}

	public void setBySubjectAsmtList(List<EgovMap> bySubjectAsmtList) {
		this.bySubjectAsmtList = bySubjectAsmtList;
	}

	public List<EgovMap> getBySubjectDscsList() {
		return bySubjectDscsList;
	}

	public void setBySubjectDscsList(List<EgovMap> bySubjectDscsList) {
		this.bySubjectDscsList = bySubjectDscsList;
	}

	public List<EgovMap> getBySubjectQuizList() {
		return bySubjectQuizList;
	}

	public void setBySubjectQuizList(List<EgovMap> bySubjectQuizList) {
		this.bySubjectQuizList = bySubjectQuizList;
	}

	public List<EgovMap> getBySubjectExamList() {
		return bySubjectExamList;
	}

	public void setBySubjectExamList(List<EgovMap> bySubjectExamList) {
		this.bySubjectExamList = bySubjectExamList;
	}

	public List<EgovMap> getBySubjectSrvyList() {
		return bySubjectSrvyList;
	}

	public void setBySubjectSrvyList(List<EgovMap> bySubjectSrvyList) {
		this.bySubjectSrvyList = bySubjectSrvyList;
	}

	public List<EgovMap> getBySubjectSmnrList() {
		return bySubjectSmnrList;
	}

	public void setBySubjectSmnrList(List<EgovMap> bySubjectSmnrList) {
		this.bySubjectSmnrList = bySubjectSmnrList;
	}

	public List<EgovMap> getMrkActvItmRateList() {
		return mrkActvItmRateList;
	}

	public void setMrkActvItmRateList(List<EgovMap> mrkActvItmRateList) {
		this.mrkActvItmRateList = mrkActvItmRateList;
	}	
}