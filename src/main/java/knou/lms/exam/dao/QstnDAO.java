package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.QstnVO;

@Mapper("qstnDAO")
public interface QstnDAO {

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
	 * 문항등록
	 *
	 * @param QstnVO
	 * @throws Exception
	 */
	public void qstnRegist(QstnVO vo) throws Exception;

	/**
	 * 문항수정
	 *
	 * @param QstnVO
	 * @throws Exception
	 */
	public void qstnModify(QstnVO vo) throws Exception;

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
	 * 문항삭제여부수정
	 *
	 * @param examDtlId 		시험상세아이디
	 * @param qstnSeqno 		문항순번
	 * @param qstnCnddtSeqno 	문항후보순번
	 * @throws Exception
	 */
	public void qstnDelynModify(QstnVO vo) throws Exception;

	/**
	 * 문항미삭제순번수정
	 *
	 * @param examDtlId 		시험상세아이디
	 * @param qstnSeqno 		문항순번
	 * @param qstnCnddtSeqno 	문항후보순번
	 * @throws Exception
	 */
	public void qstnDelNSeqnoModify(QstnVO vo) throws Exception;

	/**
	 * 퀴즈문항점수수정
	 *
	 * @param examDtlId 	시험상세아이디
	 * @param qstnSeqno 	문항순번
	 * @param examDtlId 	시험상세아이디
	 * @throws Exception
	 */
	public void quizQstnScrModify(QstnVO vo) throws Exception;

	/**
	 *
	 * 퀴즈문항점수일괄수정
	 *
	 * @param examDtlId 	시험상세아이디
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
	 * @param copyType  	복사유형 ( qbnk : 문제은행, examppr : 다른 퀴즈 )
     * @param copyQstnId 	복사문항아이디
     * @param examDtlId 	시험상세아이디
	 * @throws Exception
	 */
	public void quizQstnCopy(List<Map<String, Object>> list) throws Exception;

	/**
	 * 문항전체삭제
	 *
	 * @param ExamDtlVO
	 * @throws Exception
	 */
	public void qstnAllDelete(ExamDtlVO vo) throws Exception;

	/**
	 * 문항일괄등록
	 *
	 * @param List<QstnVO>
	 * @throws Exception
	 */
	public void qstnBulkRegist(List<QstnVO> list) throws Exception;

}
