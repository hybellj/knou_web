package knou.lms.bbs.facade;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;
import knou.lms.bbs.vo.BbsInfoVO;

public interface BbsFacadeService {

	EgovMap loadFilterOptions(UserContext userCtx) throws Exception;

}