package knou.lms.smnr.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.smnr.dao.SmnrTeamDAO;
import knou.lms.smnr.service.SmnrTeamService;

@Service("smnrTeamService")
public class SmnrTeamServiceImpl extends ServiceBase implements SmnrTeamService {

	@Resource(name="smnrTeamDAO")
	private SmnrTeamDAO smnrTeamDAO;

}
