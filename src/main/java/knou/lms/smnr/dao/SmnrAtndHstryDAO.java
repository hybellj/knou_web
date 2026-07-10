package knou.lms.smnr.dao;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.smnr.vo.SmnrAtndHstryVO;
import knou.lms.smnr.vo.SmnrVO;

@Mapper("smnrAtndHstryDAO")
public interface SmnrAtndHstryDAO {

	// 세미나참석이력등록
	public void smnrAtndHstryRegist(SmnrAtndHstryVO vo);

	// 세미나참석이력목록
	public List<EgovMap> smnrAtndHstryList(SmnrVO vo);

	// 사용자목록참석이력일괄등록
	public void userListAtndHstryBulkRegist(List<Map<String, Object>> list);

	// 사용자세미나참석이력목록
	public List<EgovMap> userSmnrAtndHstryList(SmnrAtndHstryVO vo);

	// 대상자세미나참석이력목록조회 ( Ez-Grader )
	public List<EgovMap> trgtrSmnrAtndHstryListByEzGrader(Map<String, Object> params);

}
