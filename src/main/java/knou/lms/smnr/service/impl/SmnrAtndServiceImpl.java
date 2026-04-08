package knou.lms.smnr.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.smnr.dao.SmnrAtndDAO;
import knou.lms.smnr.service.SmnrAtndService;

@Service("smnrAtndService")
public class SmnrAtndServiceImpl extends ServiceBase implements SmnrAtndService {

	@Resource(name="smnrAtndDAO")
	private SmnrAtndDAO smnrAtndDAO;

}
