package knou.lms.srvy.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyQstnVO;

@Mapper("srvyRspnsDAO")
public interface SrvyRspnsDAO {

	/**
	 * 설문문항목록답변삭제
	 *
	 * @param List<SrvyQstnVO>
	 * @throws Exception
	 */
	public void srvyQstnListRspnsDelete(List<SrvyQstnVO> list) throws Exception;

	/**
	* 설문선택형문항답변현황목록
	*
	* @param sbjctId 	과목아이디
    * @param srvyId 	설문아이디
	* @return 설문선택형문항답변현황목록
	* @throws Exception
	*/
	public List<EgovMap> srvyChcQstnRspnsStatusList(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId) throws Exception;

	/**
	 * 설문서술형문항답변현황목록
	 *
	 * @param sbjctId 	과목아이디
	 * @param srvyId 	설문아이디
	 * @return 설문서술형문항답변현황목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyTextQstnRspnsStatusList(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId) throws Exception;

	/**
	 * 설문레벨형문항답변현황목록
	 *
	 * @param sbjctId 	과목아이디
	 * @param srvyId 	설문아이디
	 * @return 설문레벨형문항답변현황목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyLevelQstnRspnsStatusList(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId) throws Exception;

}
