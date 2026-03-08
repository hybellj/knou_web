package knou.lms.qbnk.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.qbnk.vo.QbnkQstnVO;

public interface QbnkQstnService {

	/**
	* 문제은행문항목록조회
	*
	* @param upQbnkCtgrId 	상위문제은행분류아이디
    * @param qbnkCtgrId 	문제은행분류아이디
    * @param sbjctId 		과목아이디
    * @param userId 		사용자아이디
    * @param searchValue 	검색어(문항제목)
	* @return 문제은행문항목록
	* @throws Exception
	*/
	public ProcessResultVO<EgovMap> qbnkQstnList(Map<String, Object> params) throws Exception;

	/**
     * 교수문항복사문제은행문항목록조회
     *
     * @param qbnkCtgrId 	문제은행문항아이디
     * @return 문제은행문항목록
     * @throws Exception
     */
	public List<EgovMap> profQstnCopyQbnkQstnList(QbnkQstnVO vo) throws Exception;

	/**
     * 문제은행문항조회
     *
     * @param qbnkCtgrId 	문제은행문항아이디
     * @return 문제은행문항
     * @throws Exception
     */
	public EgovMap qbnkQstnSelect(QbnkQstnVO vo) throws Exception;

	/**
	* 문제은행문항등록
	*
	* @param QbnkQstnVO
	* @throws Exception
	*/
	public void qbnkQstnRegist(QbnkQstnVO vo) throws Exception;

	/**
	 * 문제은행문항수정
	 *
	 * @param QbnkQstnVO
	 * @throws Exception
	 */
	public void qbnkQstnModify(QbnkQstnVO vo) throws Exception;

	/**
	 * 문제은행문항삭제
	 *
	 * @param QbnkQstnVO
	 * @throws Exception
	 */
	public void qbnkQstnDelete(QbnkQstnVO vo) throws Exception;

}
