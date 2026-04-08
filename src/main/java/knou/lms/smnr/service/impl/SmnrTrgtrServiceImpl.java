package knou.lms.smnr.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.smnr.dao.SmnrTrgtrDAO;
import knou.lms.smnr.service.SmnrTrgtrService;

@Service("smnrTrgtrService")
public class SmnrTrgtrServiceImpl extends ServiceBase implements SmnrTrgtrService {

	@Resource(name="smnrTrgtrDAO")
	private SmnrTrgtrDAO smnrTrgtrDAO;

}
