package knou.lms.srvy.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.srvy.dao.SrvyPtcpHstryDAO;
import knou.lms.srvy.service.SrvyPtcpHstryService;
import knou.lms.srvy.vo.SrvyPtcpHstryVO;

@Service("srvyPtcpHstryService")
public class SrvyPtcpHstryServiceImpl extends ServiceBase implements SrvyPtcpHstryService {

	@Resource(name="srvyPtcpHstryDAO")
	private SrvyPtcpHstryDAO srvyPtcpHstryDAO;

	/**
	* 설문참여이력목록조회
	*
	* @param srvyId 	설문아이디
    * @param userId 	사용자아이디
	* @return 설문참여이력목록
	*/
	@Override
	public List<EgovMap> srvyPtcpHstryList(SrvyPtcpHstryVO vo) {
		return srvyPtcpHstryDAO.srvyPtcpHstryList(vo);
	}

}
