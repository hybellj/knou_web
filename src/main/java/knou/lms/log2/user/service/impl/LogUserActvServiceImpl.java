package knou.lms.log2.user.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.log2.user.dao.LogUserActvDAO;
import knou.lms.log2.user.service.LogUserActvService;

@Service("logUserActvService")
public class LogUserActvServiceImpl extends ServiceBase implements LogUserActvService {
    
    @Resource(name="logUserActvDAO")
    private LogUserActvDAO logUserActvDAO;

	/*
	 * @Override public Object userSbjctOfrngActvHstryList(String sbjctId, int
	 * timeRange) throws Exception { return
	 * logUserActvDAO.userSbjctOfrngActvHstryList(sbjctId, timeRange); }
	 */
}