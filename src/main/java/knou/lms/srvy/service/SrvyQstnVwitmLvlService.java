package knou.lms.srvy.service;

import java.util.List;
import java.util.Map;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyQstnVwitmLvlVO;

public interface SrvyQstnVwitmLvlService {

	/**
	 * 설문문항목록보기항목레벨삭제
	 *
	 * @param List<SrvyQstnVO>
	 * @throws Exception
	 */
	public void srvyQstnListVwitmLvlDelete(List<SrvyQstnVO> list) throws Exception;

	/**
	 * 설문문항보기항목레벨등록
	 *
	 * @param SrvyQstnVO
	 * @param List<Map<String, Object>> lvls
	 * @throws Exception
	 */
	public void srvyQstnVwitmLvlRegist(SrvyQstnVO vo, List<Map<String, Object>> lvls) throws Exception;

	/**
	 * 설문문항보기항목레벨삭제
	 *
	 * @param srvyQstnId 설문문항아이디
	 * @throws Exception
	 */
	public void srvyQstnVwitmLvlDelete(String srvyQstnId) throws Exception;

	/**
	 * 설문문항보기항목레벨목록조회
	 *
	 * @param srvyQstnId 설문문항아이디
	 * return 설문문항보기항목레벨목록
	 * @throws Exception
	 */
	public List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlList(String srvyQstnId) throws Exception;

}
