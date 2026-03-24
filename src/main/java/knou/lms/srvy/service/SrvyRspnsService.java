package knou.lms.srvy.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyRspnsVO;

public interface SrvyRspnsService {

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
	public List<EgovMap> srvyChcQstnRspnsStatusList(String sbjctId, String srvyId, String searchType) throws Exception;

	/**
	 * 설문서술형문항답변현황목록
	 *
	 * @param sbjctId 		과목아이디
	 * @param srvyId 		설문아이디
	 * @param searchType 	조회유형
	 * @return 설문서술형문항답변현황목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyTextQstnRspnsStatusList(String sbjctId, String srvyId, String searchType) throws Exception;

	/**
	 * 설문레벨형문항답변현황목록
	 *
	 * @param sbjctId 		과목아이디
	 * @param srvyId 		설문아이디
	 * @param searchType 	조회유형
	 * @return 설문레벨형문항답변현황목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyLevelQstnRspnsStatusList(String sbjctId, String srvyId, String searchType) throws Exception;

	/**
	 * 설문엑셀다운문항목록
	 *
	 * @param srvyId 		설문아이디
	 * @return 설문엑셀다운문항목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyExcelDownQstnList(String srvyId) throws Exception;

	/**
	 * 설문엑셀다운문항답변목록
	 *
	 * @param srvyId 		설문아이디
	 * @return 설문엑셀다운문항답변목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyExcelDownQstnRspnsList(String srvyId) throws Exception;

	/**
	 * 설문답변목록
	 *
	 * @param srvyPtcpId 	설문참여아이디
	 * @param srvyId 		설문아이디
	 * @param userId 		사용자아이디
	 * @return 설문답변목록
	 * @throws Exception
	 */
	public List<SrvyRspnsVO> srvyRspnsList(String srvyPtcpId, String srvyId, String userId) throws Exception;

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
	public List<EgovMap> srvyQstnRspnsDistributionList(String sbjctId, String srvyId, String srvypprId, String srvyQstnId) throws Exception;

}
