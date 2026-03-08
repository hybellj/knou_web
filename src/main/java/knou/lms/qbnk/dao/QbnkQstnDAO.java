package knou.lms.qbnk.dao;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.qbnk.vo.QbnkQstnVO;

@Mapper("qbnkQstnDAO")
public interface QbnkQstnDAO {

	/**
	* 문제은행문항목록조회
	*
	* @param upQbnkCtgrId 	상위문제은행분류아이디
    * @param qbnkCtgrId 	문제은행분류아이디
    * @param sbjctId 		과목아이디
    * @param userRprsId 	사용자대표아이디
    * @param searchValue 	검색어(문항제목)
	* @return 문제은행문항목록
	* @throws Exception
	*/
	public List<EgovMap> qbnkQstnList(Map<String, Object> params) throws Exception;

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
     * 문제은행다음문항순번조회
     *
     * @param qbnkCtgrId 	문제은행문항아이디
     * @return 문제은행다음문항순번
     * @throws Exception
     */
	public int qbnkNextQstnSeqnoSelect(QbnkQstnVO vo) throws Exception;

	/**
     * 문제은행문항수정
     *
     * @param QbnkQstnVO
     * @throws Exception
     */
	public void qbnkQstnModfiy(QbnkQstnVO vo) throws Exception;

	/**
     * 문제은행문항삭제여부수정
     *
     * @param QbnkQstnVO
     * @throws Exception
     */
	public void qbnkQstnDelynModify(QbnkQstnVO vo) throws Exception;

	/**
     * 문제은행문항미삭제순번수정
     *
     * @param QbnkQstnVO
     * @throws Exception
     */
	public void qbnkQstnDelNSeqnoModify(QbnkQstnVO vo) throws Exception;

}
