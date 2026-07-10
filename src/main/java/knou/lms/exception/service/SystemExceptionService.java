package knou.lms.exception.service;

import knou.lms.exception.vo.SystemExceptionVO;

public interface SystemExceptionService {
	
	void systemExceptionInsert(SystemExceptionVO vo) throws Exception ;
	
}