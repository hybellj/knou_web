package knou.lms.bbs2.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.bbs2.dto.BbsParam;

/**
 * 게시판2게시글 DAO
 * 
 */
@Mapper("bbs2AtclDAO")
public interface Bbs2AtclDAO {
	
	public List<EgovMap> topAllNoticeList(BbsParam param)  throws Exception;
	
	public List<EgovMap> topCrsNoticeList(BbsParam param)  throws Exception;
	
	public List<EgovMap> profTopSubjctNoticeList(BbsParam param)  throws Exception;

	public List<EgovMap> profTopLctrQnaList(BbsParam param)  throws Exception;
	
	public List<EgovMap> profTopOneOnOneList(BbsParam param)  throws Exception;

	public List<EgovMap> stdntTopSubjctNoticeList(BbsParam param)  throws Exception;
	
	public List<EgovMap> stdntTopLctrQnaList(BbsParam param)  throws Exception;

	public List<EgovMap> stdntTopDatarmList(BbsParam param)  throws Exception;	
	
	
	
	public List<EgovMap> latestTopArticlesList( @Param("userId") String userId
			, @Param("subjectId") String subjectId, @Param("limitTop") int limitTop) throws Exception;

	public EgovMap latestTopArticlesUnreadNoreplyCntSelect(BbsParam param) throws Exception;
}