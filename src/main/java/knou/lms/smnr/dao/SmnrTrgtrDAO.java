package knou.lms.smnr.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.smnr.vo.SmnrTrgtrVO;

@Mapper("smnrTrgtrDAO")
public interface SmnrTrgtrDAO {

	/**
	 * 세미나대상자일괄등록
	 *
	 * @param List<SmnrTrgtrVO>
	 * @throws Exception
	 */
	public void smnrTrgtrBulkRegist(List<SmnrTrgtrVO> list) throws Exception;

	/**
	 * 세미나대상자일괄삭제
	 *
	 * @param smnrId 	세미나아이디
	 * @throws Exception
	 */
	public void smnrTrgtrBulkDelete(@Param("smnrId") String smnrId) throws Exception;

}
