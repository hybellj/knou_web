package knou.lms.srvy.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.srvy.dao.SrvyRspnsDAO;
import knou.lms.srvy.service.SrvyRspnsService;
import knou.lms.srvy.vo.SrvyQstnVO;

@Service("srvyRspnsService")
public class SrvyRspnsServiceImpl extends ServiceBase implements SrvyRspnsService {

	@Resource(name="srvyRspnsDAO")
	private SrvyRspnsDAO srvyRspnsDAO;

	/**
	 * 설문문항목록답변삭제
	 *
	 * @param List<SrvyQstnVO>
	 * @throws Exception
	 */
	@Override
	public void srvyQstnListRspnsDelete(List<SrvyQstnVO> list) throws Exception {
		srvyRspnsDAO.srvyQstnListRspnsDelete(list);
	}

}
