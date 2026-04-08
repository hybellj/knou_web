package knou.lms.smnr.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.smnr.vo.SmnrTeamVO;

@Mapper("smnrTeamDAO")
public interface SmnrTeamDAO {

	/**
	 * 세미나팀일괄등록
	 *
	 * @param List<SmnrTeamVO>
	 * @throws Exception
	 */
	public void smnrTeamBulkRegist(List<SmnrTeamVO> vo) throws Exception;

	/**
	 * 세미나팀일괄삭제
	 *
	 * @param smnrId 	세미나아이디
	 * @throws Exception
	 */
	public void smnrTeamBulkDelete(@Param("smnrId") String smnrId) throws Exception;

}
