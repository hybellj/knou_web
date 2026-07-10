package knou.lms.srvy.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.srvy.vo.SrvyPtcpVO;
import knou.lms.srvy.vo.SrvyVO;

public interface SrvyPtcpService {

	// 설문참여목록조회
	public List<EgovMap> srvyPtcpList(Map<String, Object> params);

	// 설문참여자조회
	public EgovMap srvyPtcpntSelect(String srvyId, String userId);

	// 교수메모조회
	public EgovMap profMemoSelect(String srvyPtcpId, String userId);

	// 교수메모수정
	public void profMemoModify(Map<String, Object> params);

	// 교수설문평가점수일괄수정
	public void profSrvyEvlScrBulkModify(List<Map<String, Object>> list);

	// 설문참여장치별현황목록
	public List<EgovMap> srvyPtcpDvcStatusList(String srvyId, String sbjctId);

	// 설문참여수조회
	public EgovMap srvyPtcpCntSelect(String srvyId, String sbjctId);

	// 설문참여목록조회 ( Ez-Grader )
	public List<EgovMap> srvyPtcpListByEzGrader(SrvyVO vo);

	// 설문성적엑셀업로드
	public void srvyScrExcelUpload(SrvyPtcpVO vo);

	// 교수메모일괄수정
	public void profMemoBulkModify(List<Map<String, Object>> list);

	// 학생설문참여
	public ResultDTO<EgovMap> stdntSrvyPtcp(Map<String, Object> params);

	// 설문지제출
	public void srvypprSbmsn(Map<String, Object> params);

	// 강의평가참여장치별현황목록
	public List<EgovMap> lctrEvlPtcpDvcStatusList(Map<String, Object> params);

	// 강의평가참여수조회
	public EgovMap lctrEvlPtcpCntSelect(Map<String, Object> params);

	// 전체설문참여장치별현황목록
	public List<EgovMap> wholSrvyPtcpDvcStatusList(Map<String, Object> params);

	// 전체설문참여수조회
	public EgovMap wholSrvyPtcpCntSelect(Map<String, Object> params);

	// 학생강의평가참여수조회
	public EgovMap stdntLctrEvlPtcpCntSelect(String srvyId, String sbjctId);

	// 대상전체설문참여
	public ResultDTO<EgovMap> trgtWholSrvyPtcp(Map<String, Object> params);

}
