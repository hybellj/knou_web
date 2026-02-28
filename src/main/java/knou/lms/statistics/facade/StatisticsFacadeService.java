package knou.lms.statistics.facade;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;

public interface StatisticsFacadeService {
	
	EgovMap loadFilterOptions(UserContext userCtx) throws Exception;

}
