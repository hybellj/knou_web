package knou.lms.srvy.service;

import java.util.List;
import java.util.Map;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyQstnVwitmLvlVO;

public interface SrvyQstnVwitmLvlService {

	// 설문문항목록보기항목레벨삭제
	public void srvyQstnListVwitmLvlDelete(List<SrvyQstnVO> list);

	// 설문문항보기항목레벨등록
	public void srvyQstnVwitmLvlRegist(SrvyQstnVO vo, List<Map<String, Object>> lvls);

	// 설문문항보기항목레벨삭제
	public void srvyQstnVwitmLvlDelete(String srvyQstnId);

	// 설문문항보기항목레벨목록조회
	public List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlList(String srvyQstnId);

	// 설문문항보기항목레벨일괄조회
	public List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlBulkList(String srvyId, String searchType);

}
