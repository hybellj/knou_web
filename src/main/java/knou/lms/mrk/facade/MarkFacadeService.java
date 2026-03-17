package knou.lms.mrk.facade;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.score.vo.ScoreOverallVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;

public interface MarkFacadeService {
	
	EgovMap loadFilterOptions(UserContext userCtx) throws Exception;

    ProcessResultVO<EgovMap> stdMrkListSelect(String orgId, String sbjctId, String searchType) throws Exception;

}
