package knou.lms.srvy.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyRspnsVO;

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
	* @param sbjctId 		과목아이디
	* @param srvyId 		설문아이디
	* @param searchType 	조회유형
	* @return 설문선택형문항답변현황목록
	* @throws Exception
	*/
	public List<EgovMap> srvyChcQstnRspnsStatusList(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId, @Param("searchType") String searchType) throws Exception;

	/**
	 * 설문서술형문항답변현황목록
	 *
	 * @param sbjctId 		과목아이디
	 * @param srvyId 		설문아이디
	 * @param searchType 	조회유형
	 * @return 설문서술형문항답변현황목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyTextQstnRspnsStatusList(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId, @Param("searchType") String searchType) throws Exception;

	/**
	 * 설문레벨형문항답변현황목록
	 *
	 * @param sbjctId 		과목아이디
	 * @param srvyId 		설문아이디
	 * @param searchType 	조회유형
	 * @return 설문레벨형문항답변현황목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyLevelQstnRspnsStatusList(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId, @Param("searchType") String searchType) throws Exception;

	/**
	 * 설문엑셀다운문항목록
	 *
	 * @param srvyId 		설문아이디
	 * @return 설문엑셀다운문항목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyExcelDownQstnList(@Param("srvyId") String srvyId) throws Exception;

	/**
	 * 설문엑셀다운문항답변목록
	 *
	 * @param srvyId 		설문아이디
	 * @return 설문엑셀다운문항답변목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyExcelDownQstnRspnsList(@Param("srvyId") String srvyId) throws Exception;

	/**
	 * 설문답변목록
	 *
	 * @param srvyPtcpId 	설문참여아이디
	 * @param srvyId 		설문아이디
	 * @param userId 		사용자아이디
	 * @return 설문답변목록
	 * @throws Exception
	 */
	public List<SrvyRspnsVO> srvyRspnsList(@Param("srvyPtcpId") String srvyPtcpId, @Param("srvyId") String srvyId, @Param("userId") String userId) throws Exception;

	/**
	 * 설문문항답변분포목록
	 *
	 * @param sbjctId 		과목아이디
	 * @param srvyId 		설문아이디
	 * @param srvypprId 	설문지아이디
	 * @param srvyQstnId 	설문문항아이디
	 * @return 설문문항답변분포목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyQstnRspnsDistributionList(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId, @Param("srvypprId") String srvypprId, @Param("srvyQstnId") String srvyQstnId) throws Exception;

}
