package knou.lms.smnr.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.smnr.vo.SmnrTeamVO;

@Mapper("smnrTeamDAO")
public interface SmnrTeamDAO {

	// 세미나팀일괄등록
	public void smnrTeamBulkRegist(List<SmnrTeamVO> vo);

	// 세미나팀일괄삭제
	public void smnrTeamBulkDelete(@Param("smnrId") String smnrId);

}
