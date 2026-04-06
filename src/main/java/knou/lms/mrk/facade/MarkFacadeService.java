package knou.lms.mrk.facade;

import knou.lms.common.vo.ProcessResultVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;

import java.util.List;
import java.util.Map;

public interface MarkFacadeService {
	
	EgovMap loadFilterOptions(UserContext userCtx) throws Exception;

}
