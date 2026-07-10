package knou.lms.common.service;

import java.util.List;

import knou.framework.context2.UserContext;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;

public interface CommonService {

    EgovMap loadFilterOptions(UserContext userCtx);

	List<EgovMap> yrSmstrSelect(PageInfo pageInfo);
	
	List<EgovMap> yrSmstrOnlySelect(PageInfo pageInfo);
}