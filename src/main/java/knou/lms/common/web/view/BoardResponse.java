package knou.lms.common.web.view;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public class BoardResponse {	
	
	List<EgovMap>	topAllNoticeList;	
	List<EgovMap>	topCrsNoticeList;
	
	List<EgovMap>	profTopSubjctNoticeList;
	List<EgovMap>	profTopLctrQnaList;
	List<EgovMap>	profTopOneOnOneList;
	
	List<EgovMap>	stdntTopSubjctNoticeList;
	List<EgovMap>	stdntTopLctrQnaList;
	List<EgovMap>	stdntTopDatarmList;
	
	String	viewName;
	
	public String getViewName() {
		return viewName;
	}
	public void setViewName(String viewName) {
		this.viewName = viewName;
	}
	public List<EgovMap> getTopAllNoticeList() {
		return topAllNoticeList;
	}
	public void setTopAllNoticeList(List<EgovMap> topAllNoticeList) {
		this.topAllNoticeList = topAllNoticeList;
	}
	public List<EgovMap> getTopCrsNoticeList() {
		return topCrsNoticeList;
	}
	public void setTopCrsNoticeList(List<EgovMap> topCrsNoticeList) {
		this.topCrsNoticeList = topCrsNoticeList;
	}
	public List<EgovMap> getProfTopSubjctNoticeList() {
		return profTopSubjctNoticeList;
	}
	public void setProfTopSubjctNoticeList(List<EgovMap> profTopSubjctNoticeList) {
		this.profTopSubjctNoticeList = profTopSubjctNoticeList;
	}
	public List<EgovMap> getProfTopLctrQnaList() {
		return profTopLctrQnaList;
	}
	public void setProfTopLctrQnaList(List<EgovMap> profTopLctrQnaList) {
		this.profTopLctrQnaList = profTopLctrQnaList;
	}
	public List<EgovMap> getProfTopOneOnOneList() {
		return profTopOneOnOneList;
	}
	public void setProfTopOneOnOneList(List<EgovMap> profTopOneOnOneList) {
		this.profTopOneOnOneList = profTopOneOnOneList;
	}
	public List<EgovMap> getStdntTopSubjctNoticeList() {
		return stdntTopSubjctNoticeList;
	}
	public void setStdntTopSubjctNoticeList(List<EgovMap> stdntTopSubjctNoticeList) {
		this.stdntTopSubjctNoticeList = stdntTopSubjctNoticeList;
	}
	public List<EgovMap> getStdntTopLctrQnaList() {
		return stdntTopLctrQnaList;
	}
	public void setStdntTopLctrQnaList(List<EgovMap> stdntTopLctrQnaList) {
		this.stdntTopLctrQnaList = stdntTopLctrQnaList;
	}
	public List<EgovMap> getStdntTopDatarmList() {
		return stdntTopDatarmList;
	}
	public void setStdntTopDatarmList(List<EgovMap> stdntTopDatarmList) {
		this.stdntTopDatarmList = stdntTopDatarmList;
	}







	/////////////////////////////////////////////////////////////////////////// 이전 멤범 변수 및 메쏘드
	List<EgovMap> latestTopArticlesList;
	
	EgovMap latestTopArticlesListUnreadNoreplyCntMap;

	public List<EgovMap> getLatestTopArticlesList() {
		return latestTopArticlesList;
	}

	public void setLatestTopArticlesList(List<EgovMap> latestTopArticlesList) {
		this.latestTopArticlesList = latestTopArticlesList;
	}

	public EgovMap getLatestTopArticlesListUnreadNoreplyCntMap() {
		return latestTopArticlesListUnreadNoreplyCntMap;
	}

	public void setLatestTopArticlesUnreadNoreplyCntSelect(EgovMap latestTopArticlesListUnreadNoreplyCntMap) {
		this.latestTopArticlesListUnreadNoreplyCntMap = latestTopArticlesListUnreadNoreplyCntMap;
	}
}