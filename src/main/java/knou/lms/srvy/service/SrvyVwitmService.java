package knou.lms.srvy.service;

import java.util.List;
import java.util.Map;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyVwitmVO;

public interface SrvyVwitmService {

	/**
	 * 설문문항목록보기항목삭제
	 *
	 * @param List<SrvyQstnVO>
	 * @throws Exception
	 */
	public void srvyQstnListVwitmDelete(List<SrvyQstnVO> list) throws Exception;

	/**
	 * 설문보기항목등록
	 *
	 * @param SrvyQstnVO
	 * @param List<Map<String, Object>> qstns
	 * @throws Exception
	 */
	public void srvyVwitmRegist(SrvyQstnVO vo, List<Map<String, Object>> qstns) throws Exception;

	/**
	 * 설문보기항목수정
	 *
	 * @param SrvyQstnVO
	 * @param List<Map<String, Object>> qstns
	 * @throws Exception
	 */
	public void srvyVwitmModify(SrvyQstnVO vo, List<Map<String, Object>> qstns) throws Exception;

	/**
	 * 설문보기항목목록조회
	 *
	 * @param srvyQstnId 설문문항아이디
	 * return 설문보기항목목록
	 * @throws Exception
	 */
	public List<SrvyVwitmVO> srvyVwitmList(String srvyQstnId) throws Exception;

}
