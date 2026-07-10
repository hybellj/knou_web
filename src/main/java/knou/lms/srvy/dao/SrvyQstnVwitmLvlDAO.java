package knou.lms.srvy.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyQstnVwitmLvlVO;
import knou.lms.srvy.vo.SrvyVO;

@Mapper("srvyQstnVwitmLvlDAO")
public interface SrvyQstnVwitmLvlDAO {

	// 설문문항목록보기항목레벨삭제
	public void srvyQstnListVwitmLvlDelete(List<SrvyQstnVO> list);

	// 설문문항보기항목레벨일괄등록
	public void srvyQstnVwitmLvlBulkRegist(List<SrvyQstnVwitmLvlVO> list);

	// 설문문항보기항목레벨삭제
	public void srvyQstnVwitmLvlDelete(@Param("srvyQstnId") String srvyQstnId);

	// 설문문항보기항목레벨목록조회
	public List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlList(@Param("srvyQstnId") String srvyQstnId);

	// 설문보기항목가져오기
	public void srvyQstnVwitmLvlCopy(List<Map<String, Object>> list);

	// 설문문항보기항목레벨일괄조회
	public List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlBulkList(@Param("srvyId") String srvyId, @Param("searchType") String searchType);

	// 설문문항목록보기항목레벨전체삭제
	public void srvyQstnListVwitmLvlAllDelete(SrvyVO vo);

}
