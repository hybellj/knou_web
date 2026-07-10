package knou.lms.srvy.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyRspnsVO;

@Mapper("srvyRspnsDAO")
public interface SrvyRspnsDAO {

	// 설문문항목록답변삭제
	public void srvyQstnListRspnsDelete(List<SrvyQstnVO> list);

	// 설문선택형문항답변현황목록
	public List<EgovMap> srvyChcQstnRspnsStatusList(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId, @Param("searchType") String searchType);

	// 설문서술형문항답변현황목록
	public List<EgovMap> srvyTextQstnRspnsStatusList(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId, @Param("searchType") String searchType);

	// 설문레벨형문항답변현황목록
	public List<EgovMap> srvyLevelQstnRspnsStatusList(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId, @Param("searchType") String searchType);

	// 설문엑셀다운문항목록
	public List<EgovMap> srvyExcelDownQstnList(@Param("srvyId") String srvyId);

	// 설문엑셀다운문항답변목록
	public List<EgovMap> srvyExcelDownQstnRspnsList(@Param("srvyId") String srvyId);

	// 설문강의평가엑셀다운문항답변목록
	public List<EgovMap> srvylctrEvlExcelDownQstnRspnsList(@Param("srvyId") String srvyId);

	// 설문답변목록
	public List<SrvyRspnsVO> srvyRspnsList(@Param("srvyPtcpId") String srvyPtcpId, @Param("srvyId") String srvyId, @Param("userId") String userId);

	// 설문문항답변분포목록
	public List<EgovMap> srvyQstnRspnsDistributionList(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId, @Param("srvypprId") String srvypprId, @Param("srvyQstnId") String srvyQstnId);

	// 설문답변일괄저장
	public void srvyRspnsBulkSave(Map<String, Object> params);

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
