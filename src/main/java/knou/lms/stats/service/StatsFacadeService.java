package knou.lms.stats.service;

import knou.framework.context2.UserContext;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface StatsFacadeService {

    EgovMap loadFilterOptions(UserContext userCtx);
}
