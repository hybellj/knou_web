package knou.lms.exam.service;

import java.util.List;

import knou.lms.exam.vo.QstnVwitmVO;

public interface QstnVwitmService {

	/**
	 * 문항보기항목목록조회
	 *
	 * @param qstnId 문항아이디
	 * return 문항보기항목 목록
	 * @throws Exception
	 */
	public List<QstnVwitmVO> qstnVwitmList(QstnVwitmVO vo) throws Exception;

	/**
	 * 문항보기항목일괄목록조회
	 *
	 * @param examDtlId 시험상세아이디
	 * return 문항보기항목 목록
	 * @throws Exception
	 */
	public List<QstnVwitmVO> qstnVwitmBulkList(String examDtlId) throws Exception;

}
