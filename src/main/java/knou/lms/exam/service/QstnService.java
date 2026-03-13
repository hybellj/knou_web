package knou.lms.exam.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.vo.QstnVO;

public interface QstnService {

	/**
	 * 문항목록조회
	 *
	 * @param examDtlId 시험상세아이디
	 * return 문항 목록
	 * @throws Exception
	 */
	public List<QstnVO> qstnList(QstnVO vo) throws Exception;

	/**
	 * 문항개수조회
	 *
	 * @param examDtlId 시험상세아이디
	 * return int
	 * @throws Exception
	 */
	public int qstnCntSelect(QstnVO vo) throws Exception;

	/**
	* 퀴즈문항등록
	*
	* @param QstnVO
	* @throws Exception
	*/
	public void quizQstnRegist(QstnVO vo) throws Exception;

	/**
	 * 퀴즈문항수정
	 *
	 * @param QstnVO
	 * @throws Exception
	 */
	public void quizQstnModify(QstnVO vo) throws Exception;

	/**
	 * 문항순번수정
	 *
	 * @param examDtlId 		시험상세아이디
	 * @param qstnSeqno 		변경할 문항순번
	 * @param searchKey 		문항순번
	 * @throws Exception
	 */
	public void qstnSeqnoModify(QstnVO vo) throws Exception;

	/**
	 * 문항후보순번수정
	 *
	 * @param examDtlId 		시험상세아이디
	 * @param qstnId	 		문항아이디
	 * @param qstnSeqno 		문항순번
	 * @param qstnCnddtSeqno 	변경할 문항후보순번
	 * @throws Exception
	 */
	public void qstnCnddtSeqnoModify(QstnVO vo) throws Exception;

	/**
	 * 문항조회
	 *
	 * @param examDtlId 시험상세아이디
	 * @param qstnId 	문항아이디
	 * return 문항 정보
	 * @throws Exception
	 */
	public QstnVO qstnSelect(QstnVO vo) throws Exception;

	/**
	 * 퀴즈문항삭제
	 *
	 * @param QstnVO
	 * @throws Exception
	 */
	public void quizQstnDelete(QstnVO vo) throws Exception;

	/**
	 * 퀴즈문항점수수정
	 *
	 * @param examDtlId 시험상세아이디
	 * @throws Exception
	 */
	public void quizQstnScrModify(QstnVO vo) throws Exception;

	/**
	 * 퀴즈문항점수일괄수정
	 *
	 * @param examDtlId 시험상세아이디
	 * @throws Exception
	 */
	public void quizQstnScrBulkModify(QstnVO vo) throws Exception;

	/**
	 * 출제완료퀴즈문항점수일괄수정
	 *
     * @param examDtlId 시험상세아이디
     * @param qstnSeqno 문항순번
     * @param qstnScr 	문항점수
	 * @throws Exception
	 */
	public void cmptnYQuizQstnScrBulkModify(List<Map<String, Object>> list) throws Exception;

	/**
     * 교수문항복사퀴즈문항목록조회
     *
     * @param examDtlId 	시험상세아이디
     * @return 퀴즈문항목록
     * @throws Exception
     */
	public List<EgovMap> profQstnCopyQuizQstnList(QstnVO vo) throws Exception;

	/**
     * 퀴즈문항가져오기
     *
     * @param copyQstnId 	복사문항아이디
     * @param examDtlId 	시험상세아이디
     * @throws Exception
     */
	public void quizQstnCopy(List<Map<String, Object>> list) throws Exception;

	/**
     * 퀴즈문항분포바차트
     *
     * @param examDtlId 	시험상세아이디
     * @param qstnId 		문항아이디
     * @param exampprId		시험지아이디
     * @return 퀴즈문항분포
     * @throws Exception
     */
	public ProcessResultVO<EgovMap> quizQstnDistributionBarChart(Map<String, Object> params) throws Exception;

	/**
     * 퀴즈문항정답현황파이차트
     *
     * @param examDtlId 	시험상세아이디
     * @param qstnId 		문항아이디
     * @param exampprId		시험지아이디
     * @return 퀴즈문항분포
     * @throws Exception
     */
	public ProcessResultVO<EgovMap> quizQstnCransStatusPieChart(Map<String, Object> params) throws Exception;

}
