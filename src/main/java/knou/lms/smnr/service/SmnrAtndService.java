package knou.lms.smnr.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.smnr.vo.SmnrAtndVO;
import knou.lms.smnr.vo.SmnrVO;

public interface SmnrAtndService {

	// 세미나참석조회
	public SmnrAtndVO smnrAtndSelect(SmnrVO vo);

	// 세미나참석등록
	public void smnrAtndRegist(SmnrAtndVO vo);

	// 세미나참석수정
	public void smnrAtndModify(SmnrAtndVO vo);

	// 세미나참석목록조회
	public List<EgovMap> smnrAtndList(Map<String, Object> params);

	// 교수세미나평가점수일괄수정
	public void profSmnrEvlScrBulkModify(List<Map<String, Object>> list);

	// 세미나성적엑셀업로드
	public void smnrScrExcelUpload(SmnrAtndVO vo);

	// 세미나참석일괄수정
	public void smnrAtndBulkModify(List<Map<String, Object>> list);

	// 세미나참석자조회
	public EgovMap smnrAtndeSelect(SmnrVO vo);

	// 세미나참석메모일괄수정
	public void smnrAtndMemoBulkModify(List<Map<String, Object>> list);

	// 세미나참석목록조회 ( Ez-Grader )
	public List<EgovMap> smnrAtndListByEzGrader(SmnrVO vo);

	// 대상자세미나참석목록조회 ( Ez-Grader )
	public List<EgovMap> trgtrSmnrAtndListByEzGrader(Map<String, Object> params);

}
