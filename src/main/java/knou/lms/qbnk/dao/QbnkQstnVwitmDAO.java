package knou.lms.qbnk.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.vo.QbnkQstnVwitmVO;

@Mapper("qbnkQstnVwitmDAO")
public interface QbnkQstnVwitmDAO {

	/**
	 * 문제은행문항보기항목일괄등록
	 *
	 * @param QstnVwitmVO
	 * @throws Exception
	 */
	public void qbnkQstnVwitmBulkRegist(List<QbnkQstnVwitmVO> list) throws Exception;

	/**
	 * 문제은행문항보기항목목록조회
	 *
	 * @param qbnkQstnId 문제은행문항아이디
	 * return 문제은행문항보기항목 목록
	 * @throws Exception
	 */
	public List<QbnkQstnVwitmVO> qbnkQstnVwitmList(QbnkQstnVO vo) throws Exception;

	/**
	 * 문제은행문항보기항목삭제
	 *
	 * @param QbnkQstnVO
	 * @throws Exception
	 */
	public void qbnkQstnVwitmDelete(QbnkQstnVO vo) throws Exception;

}
