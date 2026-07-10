package knou.lms.srvy.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyRspnsVO;

public interface SrvyRspnsService {

	// 설문문항목록답변삭제
	public void srvyQstnListRspnsDelete(List<SrvyQstnVO> list);

	// 설문선택형문항답변현황목록
	public List<EgovMap> srvyChcQstnRspnsStatusList(String sbjctId, String srvyId, String searchType);

	// 설문서술형문항답변현황목록
	public List<EgovMap> srvyTextQstnRspnsStatusList(String sbjctId, String srvyId, String searchType);

	// 설문레벨형문항답변현황목록
	public List<EgovMap> srvyLevelQstnRspnsStatusList(String sbjctId, String srvyId, String searchType);

	// 설문엑셀다운문항목록
	public List<EgovMap> srvyExcelDownQstnList(String srvyId);

	// 설문엑셀다운문항답변목록
	public List<EgovMap> srvyExcelDownQstnRspnsList(String srvyId);

	// 설문강의평가엑셀다운문항답변목록
	public List<EgovMap> srvylctrEvlExcelDownQstnRspnsList(String srvyId);

	// 설문답변목록
	public List<SrvyRspnsVO> srvyRspnsList(String srvyPtcpId, String srvyId, String userId);

	// 설문문항답변분포목록
	public List<EgovMap> srvyQstnRspnsDistributionList(String sbjctId, String srvyId, String srvypprId, String srvyQstnId);

	// 강의평가선택형문항답변현황목록
	public List<EgovMap> lctrEvlChcQstnRspnsStatusList(Map<String, Object> params);

	// 강의평가서술형문항답변현황목록
	public List<EgovMap> lctrEvlTextQstnRspnsStatusList(Map<String, Object> params);

	// 강의평가레벨형문항답변현황목록
	public List<EgovMap> lctrEvlLevelQstnRspnsStatusList(Map<String, Object> params);

	// 전체설문선택형문항답변현황목록
	public List<EgovMap> wholSrvyChcQstnRspnsStatusList(Map<String, Object> params);

	// 전체설문서술형문항답변현황목록
	public List<EgovMap> wholSrvyTextQstnRspnsStatusList(Map<String, Object> params);

	// 전체설문레벨형문항답변현황목록
	public List<EgovMap> wholSrvyLevelQstnRspnsStatusList(Map<String, Object> params);

}
