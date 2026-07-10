package knou.lms.smnr.dao;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.smnr.vo.SmnrAtndVO;
import knou.lms.smnr.vo.SmnrVO;

@Mapper("smnrAtndDAO")
public interface SmnrAtndDAO {

	// 세미나참석조회
	public SmnrAtndVO smnrAtndSelect(SmnrVO vo);

	// 세미나참석등록
	public void smnrAtndRegist(SmnrAtndVO vo);

	// 세미나참석수정
	public void smnrAtndModify(SmnrAtndVO vo);

	// 세미나참석목록조회
	public List<EgovMap> smnrAtndList(Map<String, Object> params);

	// 사용자목록평가점수일괄수정
	public void userListEvlScrBulkModify(List<Map<String, Object>> list);

	// 사용자목록참석일괄수정
	public void userListAtndBulkModify(List<Map<String, Object>> list);

	// 세미나참석자조회
	public EgovMap smnrAtndeSelect(SmnrVO vo);

	// 사용자목록참석메모일괄수정
	public void userListAtndMemoBulkModify(List<Map<String, Object>> list);

	// 세미나참석목록조회 ( Ez-Grader )
	public List<EgovMap> smnrAtndListByEzGrader(SmnrVO vo);

	// 대상자세미나참석목록조회 ( Ez-Grader )
	public List<EgovMap> trgtrSmnrAtndListByEzGrader(Map<String, Object> params);

}
