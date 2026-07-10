package knou.lms.srvy.dao;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyPtcpHstryVO;

@Mapper("srvyPtcpHstryDAO")
public interface SrvyPtcpHstryDAO {

	// 설문참여이력등록
	public void srvyPtcpHstryRegist(SrvyPtcpHstryVO vo);

	// 사용자설문참여정보조회
	public SrvyPtcpHstryVO userSrvyPtcpInfoSelect(Map<String, Object> params);

	// 설문참여이력목록조회
	public List<EgovMap> srvyPtcpHstryList(SrvyPtcpHstryVO vo);

}
