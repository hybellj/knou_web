package knou.lms.bbs.facade;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;
import knou.lms.bbs.vo.BbsVO;

public interface BbsFacadeService {

	EgovMap loadFilterOptions(UserContext userCtx) throws Exception;
}