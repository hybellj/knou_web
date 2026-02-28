package knou.lms.exam.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

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

}
