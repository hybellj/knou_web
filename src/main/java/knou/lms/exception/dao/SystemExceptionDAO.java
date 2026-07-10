package knou.lms.exception.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.exception.vo.SystemExceptionVO;

@Mapper("systemExceptionDAO")
public interface SystemExceptionDAO {
	public void systemExceptionInsert(SystemExceptionVO vo) throws Exception ;
}
