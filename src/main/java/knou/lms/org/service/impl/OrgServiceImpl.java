package knou.lms.org.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.lms.org.dao.OrgDAO;
import knou.lms.org.service.OrgService;
import knou.lms.org.vo.OrgVO;

@Service("orgService")
public class OrgServiceImpl implements OrgService {

	@Resource(name="orgDAO")
	private OrgDAO orgDAO;
	
	@Override
	public List<OrgVO> orgListSelect() throws Exception {
		return orgDAO.orgListSelect();
	}
}