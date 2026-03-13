package knou.lms.srvy.dao;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.srvy.vo.SrvyTrgtVO;

@Mapper("srvyTrgtDAO")
public interface SrvyTrgtDAO {

	/**
	 * 설문대상등록
	 *
	 * @param SrvyTrgtVO
	 * @throws Exception
	 */
	public void srvyTrgtRegist(SrvyTrgtVO vo) throws Exception;

	/**
	 * 설문대상삭제
	 *
	 * @param srvyId 	설문아이디
	 * @throws Exception
	 */
	public void srvyTrgtrDelete(@Param("srvyId") String srvyId) throws Exception;

}
