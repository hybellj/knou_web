package knou.lms.srvy.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyQstnVO;

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

}
