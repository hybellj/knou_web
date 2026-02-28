package knou.lms.mrk.facade;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;

public interface MarkFacadeService {
	
	EgovMap loadFilterOptions(UserContext userCtx) throws Exception;
	
}
