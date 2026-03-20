package knou.lms.srvy.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

@Mapper("srvyPtcpDAO")
public interface SrvyPtcpDAO {

	/**
	* 설문참여목록조회
	*
	* @param srvyId     	설문아이디
    * @param ptcpyn 		참여여부
    * @param srvyPtcpEvlyn  설문참여평가여부
    * @param searchValue    검색어(학과, 학번, 이름)
    * @param userId 		사용자아이디
	* @return 설문참여목록
	* @throws Exception
	*/
	public List<EgovMap> srvyPtcpList(Map<String, Object> params) throws Exception;

	/**
	* 설문참여자조회
	*
	* @param srvyId 	설문아이디
    * @param userId 	사용자이이디
	* @return 설문참여자
	* @throws Exception
	*/
	public EgovMap srvyPtcpntSelect(@Param("srvyId") String srvyId, @Param("userId") String userId) throws Exception;

	/**
	* 교수메모조회
	*
	* @param srvyPtcpId 설문참여아이디
    * @param userId 	사용자이이디
	* @return 교수메모조회
	* @throws Exception
	*/
	public EgovMap profMemoSelect(@Param("srvyPtcpId") String srvyPtcpId, @Param("userId") String userId) throws Exception;

	/**
	* 교수메모수정
	*
	* @param srvyPtcpId 	설문참여아이디
    * @param srvyId 		설문아이디
    * @param userId 		사용자이이디
    * @param profMemo 		교수메모
	* @throws Exception
	*/
	public void profMemoModify(Map<String, Object> params) throws Exception;

	/**
	 * 사용자목록평가점수일괄수정
	 *
	 * @param srvyId 		설문아이디
	 * @param srvyPtcpId	설문참여아이디
	 * @param userId 		사용자아이디
	 * @param scr 			점수
	 * @param scoreType  	점수유형
	 * @throws Exception
	 */
	public void userListEvlScrBulkModify(List<Map<String, Object>> list) throws Exception;

	/**
	* 설문참여장치별현황목록
	*
	* @param srvyId     설문아이디
    * @param sbjctId 	과목아이디
    * @param orgId  	기관아이디
	* @return 설문참여장치별현황목록
	* @throws Exception
	*/
	public List<EgovMap> srvyPtcpDvcStatusList(@Param("srvyId") String srvyId, @Param("sbjctId") String sbjctId, @Param("orgId") String orgId) throws Exception;

	/**
	* 설문참여수조회
	*
	* @param srvyId     설문아이디
    * @param sbjctId 	과목아이디
	* @return 설문참여수
	* @throws Exception
	*/
	public EgovMap srvyPtcpCntSelect(@Param("srvyId") String srvyId, @Param("sbjctId") String sbjctId) throws Exception;

}
