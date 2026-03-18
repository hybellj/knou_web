package knou.lms.srvy.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.srvy.vo.SrvyQstnVO;

@Mapper("srvyRspnsDAO")
public interface SrvyRspnsDAO {

	/**
	 * 설문문항목록답변삭제
	 *
	 * @param List<SrvyQstnVO>
	 * @throws Exception
	 */
	public void srvyQstnListRspnsDelete(List<SrvyQstnVO> list) throws Exception;

}
