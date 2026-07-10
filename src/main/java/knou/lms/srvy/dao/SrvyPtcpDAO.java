package knou.lms.srvy.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyVO;

@Mapper("srvyPtcpDAO")
public interface SrvyPtcpDAO {

	// 설문참여목록조회
	public List<EgovMap> srvyPtcpList(Map<String, Object> params);

	// 설문참여자조회
	public EgovMap srvyPtcpntSelect(@Param("srvyId") String srvyId, @Param("userId") String userId);

	// 교수메모조회
	public EgovMap profMemoSelect(@Param("srvyPtcpId") String srvyPtcpId, @Param("userId") String userId);

	// 교수메모수정
	public void profMemoModify(Map<String, Object> params);

	// 사용자목록평가점수일괄수정
	public void userListEvlScrBulkModify(List<Map<String, Object>> list);

	// 설문참여장치별현황목록
	public List<EgovMap> srvyPtcpDvcStatusList(@Param("srvyId") String srvyId, @Param("sbjctId") String sbjctId);

	// 설문참여수조회
	public EgovMap srvyPtcpCntSelect(@Param("srvyId") String srvyId, @Param("sbjctId") String sbjctId);

	// 설문참여목록조회 ( Ez-Grader )
	public List<EgovMap> srvyPtcpListByEzGrader(SrvyVO vo);

	// 교수메모일괄수정
	public void profMemoBulkModify(List<Map<String, Object>> list);

	// 설문참여정보조회
	public EgovMap srvyPtcpInfoSelect(Map<String, Object> params);

	// 설문참여등록
	public void srvyPtcpRegist(Map<String, Object> params);

	// 설문참여
	public void srvyPtcp(Map<String, Object> params);

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
	public EgovMap stdntLctrEvlPtcpCntSelect(@Param("srvyId") String srvyId, @Param("sbjctId") String sbjctId);

	// 전체설문참여대상조회
	public EgovMap wholSrvyPtcpTrgtSelect(Map<String, Object> params);

}
