package knou.lms.srvy.service;

import java.util.List;

import knou.lms.srvy.vo.SrvyQstnVO;

public interface SrvyRspnsService {

	/**
	 * 설문문항목록답변삭제
	 *
	 * @param List<SrvyQstnVO>
	 * @throws Exception
	 */
	public void srvyQstnListRspnsDelete(List<SrvyQstnVO> list) throws Exception;

}
