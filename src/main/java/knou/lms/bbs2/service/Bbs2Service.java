package knou.lms.bbs2.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.bbs2.dto.BbsParam;

public interface Bbs2Service {	
	
	public List<EgovMap> latestTopArticlesList(String userId, String subjctId, int limitTop) throws Exception;
	public EgovMap latestTopArticlesUnreadNoreplyCntSelect(BbsParam param) throws Exception;	
	

	public List<EgovMap> topAllNoticeList(BbsParam param) throws Exception;
	
	public List<EgovMap> topCrsNoticeList(BbsParam param) throws Exception;

	public List<EgovMap> profTopSubjctNoticeList(BbsParam param) throws Exception;

	public List<EgovMap> profTopLctrQnaList(BbsParam param) throws Exception;
	
	public List<EgovMap> profTopOneOnOneList(BbsParam param) throws Exception;
	
	public List<EgovMap> stdntTopSubjctNoticeList(BbsParam param) throws Exception;
	
	public List<EgovMap> stdntTopLctrQnaList(BbsParam param) throws Exception;
	
	public List<EgovMap> stdntTopDatarmList(BbsParam param) throws Exception;
}