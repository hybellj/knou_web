package knou.lms.srvy.service;

import java.util.List;
import java.util.Map;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyVwitmVO;

public interface SrvyVwitmService {

	// 설문문항목록보기항목삭제
	public void srvyQstnListVwitmDelete(List<SrvyQstnVO> list);

	// 설문보기항목등록
	public void srvyVwitmRegist(SrvyQstnVO vo, List<Map<String, Object>> qstns);

	// 설문보기항목수정
	public void srvyVwitmModify(SrvyQstnVO vo, List<Map<String, Object>> qstns);

	// 설문보기항목목록조회
	public List<SrvyVwitmVO> srvyVwitmList(String srvyQstnId);

	// 설문보기항목일괄조회
	public List<SrvyVwitmVO> srvyVwitmBulkList(String srvyId, String qstnRspnsTycd, String searchType);

}
