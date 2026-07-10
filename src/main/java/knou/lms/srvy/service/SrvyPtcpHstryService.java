package knou.lms.srvy.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyPtcpHstryVO;

public interface SrvyPtcpHstryService {

	// 설문참여이력목록조회
	public List<EgovMap> srvyPtcpHstryList(SrvyPtcpHstryVO vo);

}
