package knou.lms.qbnk.service;

import java.util.List;

import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.vo.QbnkQstnVwitmVO;

public interface QbnkQstnVwitmService {

	/**
	 * 문제은행문항보기항목목록조회
	 *
	 * @param qbnkQstnId 문제은행문항아이디
	 * return 문제은행문항보기항목 목록
	 * @throws Exception
	 */
	public List<QbnkQstnVwitmVO> qbnkQstnVwitmList(QbnkQstnVO vo) throws Exception;

}
