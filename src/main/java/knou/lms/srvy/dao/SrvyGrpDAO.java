package knou.lms.srvy.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.srvy.vo.SrvyGrpVO;

@Mapper("srvyGrpDAO")
public interface SrvyGrpDAO {

	/**
	 * 설문그룹등록
	 *
	 * @param SrvyGrpVO
	 * @throws Exception
	 */
	public void srvyGrpRegist(SrvyGrpVO vo) throws Exception;

}
