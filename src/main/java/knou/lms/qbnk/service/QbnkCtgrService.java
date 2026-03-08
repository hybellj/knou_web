package knou.lms.qbnk.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.qbnk.vo.QbnkCtgrVO;

public interface QbnkCtgrService {

	/**
	 * 교수문제은행분류목록조회
	 *
	 * @param userId 		사용자아이디
	 * @param sbjctId 		과목아이디
	 * @param upQbnkCtgrId 	상위문제은행분류아이디
	 * return 문제은행분류 목록
	 * @throws Exception
	 */
	public List<QbnkCtgrVO> profQbnkCtgrList(QbnkCtgrVO vo) throws Exception;

	/**
	 * 교수문제은행분류전체목록조회
	 *
	 * @param upQbnkCtgrId 	상위문제은행분류아이디
	 * @param qbnkCtgrId 	문제은행분류아이디
	 * @param sbjctId 		과목아이디
	 * @param userRprsId 	사용자대표아이디
	 * @param searchValue 	검색어(분류명, 과목, 담당교수)
	 * return 문제은행분류 목록
	 * @throws Exception
	 */
	public ProcessResultVO<EgovMap> profQbnkCtgrAllList(QbnkCtgrVO vo) throws Exception;

	/**
	 * 교수문제은행과목조회
	 *
	 * @param sbjctId 		과목아이디
	 * return 문제은행과목 정보
	 * @throws Exception
	 */
	public EgovMap profQbnkSbjctSelect(String sbjctId) throws Exception;

	/**
	 * 문제은행다음분류순번조회
	 *
	 * @param userRprsId 		사용자대표아이디
	 * @param upQbnkCtgrId 		상위문제은행분류아이디
	 * return 문제은행다음분류순번
	 * @throws Exception
	 */
	public int qbnkNextCtgrSeqnoSelect(QbnkCtgrVO vo) throws Exception;

	/**
	* 문제은행분류등록
	*
	* @param QbnkCtgrVO
	* @throws Exception
	*/
	public void qbnkCtgrRegist(QbnkCtgrVO vo) throws Exception;

	/**
	 * 문제은행분류조회
	 *
	 * @param qbnkCtgrId 	문제은행분류아이디
	 * return 문제은행분류 정보
	 * @throws Exception
	 */
	public QbnkCtgrVO qbnkCtgrSelect(String qbnkCtgrId) throws Exception;

	/**
	 * 문제은행분류사용수조회
	 *
	 * @param qbnkCtgrId 	문제은행분류아이디
	 * return 문제은행분류사용수
	 * @throws Exception
	 */
	public EgovMap qbnkCtgrUseCntSelect(String qbnkCtgrId) throws Exception;

	/**
	* 문제은행분류삭제
	*
	* @param QbnkCtgrVO
	* @throws Exception
	*/
	public void qbnkCtgrDelete(QbnkCtgrVO vo) throws Exception;

	/**
	 * 문제은행검색과목목록
	 *
	 * @param userId 	사용자아이디
	 * return 문제은행검색과목목록
	 * @throws Exception
	 */
	public List<EgovMap> qbnkSearchSbjctList(String userId) throws Exception;

	/**
	 * 문제은행검색교수목록
	 *
	 * return 문제은행검색교수목록
	 * @throws Exception
	 */
	public List<EgovMap> qbnkSearchProfList() throws Exception;

}
