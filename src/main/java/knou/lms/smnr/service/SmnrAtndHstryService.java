package knou.lms.smnr.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.smnr.vo.SmnrAtndHstryVO;
import knou.lms.smnr.vo.SmnrVO;

public interface SmnrAtndHstryService {

	// 세미나참석이력등록
	public void smnrAtndHstryRegist(SmnrVO vo);

	// 세미나참석이력목록
	public List<EgovMap> smnrAtndHstryList(SmnrVO vo);

	// 사용자세미나참석이력목록
	public List<EgovMap> userSmnrAtndHstryList(SmnrAtndHstryVO vo);

	// 대상자세미나참석이력목록조회 ( Ez-Grader )
	public List<EgovMap> trgtrSmnrAtndHstryListByEzGrader(Map<String, Object> params);

}
