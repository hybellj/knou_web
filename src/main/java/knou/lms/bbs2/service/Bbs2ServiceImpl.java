package knou.lms.bbs2.service;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.bbs2.dao.Bbs2AtclDAO;
import knou.lms.bbs2.dto.BbsParam;

@Service("bbs2Service")
public class Bbs2ServiceImpl extends ServiceBase implements Bbs2Service {

	@Resource(name = "bbs2AtclDAO")
    private Bbs2AtclDAO bbs2AtclDAO;	
	
	@Override
	public List<EgovMap> topAllNoticeList(BbsParam param) throws Exception {
		return bbs2AtclDAO.topAllNoticeList(param);
	}	
	@Override
	public List<EgovMap> topCrsNoticeList(BbsParam param) throws Exception {
		return bbs2AtclDAO.topCrsNoticeList(param);
	}	
	@Override
	public List<EgovMap> profTopSubjctNoticeList(BbsParam param) throws Exception {
		return bbs2AtclDAO.profTopSubjctNoticeList(param);
	}	
	@Override
	public List<EgovMap> profTopLctrQnaList(BbsParam param) throws Exception {
		return bbs2AtclDAO.profTopLctrQnaList(param);
	}	
	@Override
	public List<EgovMap> profTopOneOnOneList(BbsParam param) throws Exception {
		return bbs2AtclDAO.profTopOneOnOneList(param);
	}
	@Override
	public List<EgovMap> stdntTopSubjctNoticeList(BbsParam param) throws Exception {
		return bbs2AtclDAO.stdntTopSubjctNoticeList(param);
	}
	@Override
	public List<EgovMap> stdntTopLctrQnaList(BbsParam param) throws Exception {
		return bbs2AtclDAO.stdntTopLctrQnaList(param);
	}
	@Override
	public List<EgovMap> stdntTopDatarmList(BbsParam param) throws Exception {
		return bbs2AtclDAO.stdntTopDatarmList(param);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	/*****************************************************
     * 최신게시글조회
     * @param	userId, subjectId, limitTop
     * @return	List<BbsAtclVO>
     * @throws	Exception
     ******************************************************/
	@Override
	public List<EgovMap> latestTopArticlesList(String userId, String subjctId, int limitTop) throws Exception {
		return bbs2AtclDAO.latestTopArticlesList(userId, subjctId, limitTop);	
	}
	/*****************************************************
     * 최신게시글미열람미응답수조회
     * @param	userId, subjectId
     * @return	eGovMap
     * @throws	Exception
     ******************************************************/
	@Override
	public EgovMap latestTopArticlesUnreadNoreplyCntSelect(BbsParam param) throws Exception {
		return bbs2AtclDAO.latestTopArticlesUnreadNoreplyCntSelect(param);
	}	
}