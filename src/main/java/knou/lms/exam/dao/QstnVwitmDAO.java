package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.QstnVwitmVO;

@Mapper("qstnVwitmDAO")
public interface QstnVwitmDAO {

	/**
	 * 문항보기항목목록조회
	 *
	 * @param qstnId 문항아이디
	 * return 문항보기항목 목록
	 * @throws Exception
	 */
	public List<QstnVwitmVO> qstnVwitmList(QstnVwitmVO vo) throws Exception;

	/**
	 * 문항보기항목일괄등록
	 *
	 * @param QstnVwitmVO
	 * @throws Exception
	 */
	public void qstnVwitmBulkRegist(List<QstnVwitmVO> list) throws Exception;

	/**
	 * 문항보기항목삭제
	 *
	 * @param QstnVwitmVO
	 * @throws Exception
	 */
	public void qstnVwitmDelete(QstnVwitmVO vo) throws Exception;

	/**
	 * 문항보기항목일괄목록조회
	 *
	 * @param examDtlId 시험상세아이디
	 * return 문항보기항목 목록
	 * @throws Exception
	 */
	public List<QstnVwitmVO> qstnVwitmBulkList(String examDtlId) throws Exception;

	/**
	 * 퀴즈문항보기항목가져오기
	 *
	 * @param copyType  	복사유형 ( qbnk : 문제은행, examppr : 다른 퀴즈 )
     * @param copyQstnId 	복사문항아이디
     * @param examDtlId 	시험상세아이디
	 * @throws Exception
	 */
	public void quizQstnVwitmCopy(List<Map<String, Object>> list) throws Exception;

	/**
	 * 문항보기항목전체삭제
	 *
	 * @param ExamDtlVO
	 * @throws Exception
	 */
	public void qstnVwitmAllDelete(ExamDtlVO vo) throws Exception;

	/**
	 * 문항보기항목일괄수정
	 *
	 * @param QstnVwitmVO
	 * @throws Exception
	 */
	public void qstnVwitmBulkModify(List<QstnVwitmVO> list) throws Exception;

}
