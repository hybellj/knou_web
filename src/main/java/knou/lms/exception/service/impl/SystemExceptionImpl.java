package knou.lms.exception.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.lms.exception.dao.SystemExceptionDAO;
import knou.lms.exception.service.SystemExceptionService;
import knou.lms.exception.vo.SystemExceptionVO;

@Service("systemExceptionService")
public class SystemExceptionImpl implements SystemExceptionService {

	
	@Resource(name="systemExceptionDAO")
    private SystemExceptionDAO systemExceptionDAO;
	
	@Override
	public void systemExceptionInsert(SystemExceptionVO vo) throws Exception {
		systemExceptionDAO.systemExceptionInsert(vo);
	}
}