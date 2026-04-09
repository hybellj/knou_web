package knou.lms.bbs.service;

import java.util.List;

import knou.framework.context2.UserContext;
import knou.lms.bbs2.vo.Bbs2AtclVO;

public interface BbsService {

	public void checkBbsAccessWithAuth(String bbsId, UserContext userCtx) throws Exception ;

	public List<Bbs2AtclVO> bbsAtclSelect(String bbsId)  throws Exception ;

}