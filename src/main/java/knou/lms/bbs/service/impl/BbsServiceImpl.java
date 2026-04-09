package knou.lms.bbs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.context2.UserContext;
import knou.framework.exception.BBSException;
import knou.lms.bbs.dao.BbsDAO;
import knou.lms.bbs.service.BbsService;
import knou.lms.bbs2.vo.Bbs2AtclVO;

@Service("bbsService")
public class BbsServiceImpl implements BbsService {

	@Resource(name = "bbsDAO")
    private BbsDAO bbsDAO;
	
	@Override
	public void checkBbsAccessWithAuth(String bbsId, UserContext userCtx) throws Exception {
		
		EgovMap m = bbsIdWithBbsAuthrtSelect(bbsId, userCtx);
		
		if ( "".equals( bbsId ) || null == bbsId )
    		throw new BBSException("게시판 아이디가 전달되지 않았습니다.");
    	
    	if ( "NOT_EXIST_BBS_AUTHRT".equals( m.get("result")) )
    		throw new BBSException("게시판 권한이 없습니다.");
    	
    	if ( "BBSID_NOT_EXIST".equals( m.get("result")) )
    		throw new BBSException("존재하지 않는 게시판 아이디 입니다.");
	}

	private EgovMap bbsIdWithBbsAuthrtSelect(String bbsId, UserContext userCtx) throws Exception {
		
		String userId = userCtx.getSelectedUser().getUserId();
		
		if (userCtx.isAdmin()) {
	        EgovMap result = new EgovMap();
	        result.put("result", "EXIST_BBSID_AUTHRT");
	        return result;
	    }
		
		if ( userCtx.isProfessor() || userCtx.isStudent() ) 
			return	bbsDAO.bbsIdWithBbsAuthrtSelect(bbsId, userId);
		
		throw new IllegalArgumentException("지원하지 않는 사용자 유형입니다.");
	}

	@Override
	public List<Bbs2AtclVO> bbsAtclSelect(String bbsId) throws Exception {
		return	bbsDAO.atclSelect(bbsId);
	}
}