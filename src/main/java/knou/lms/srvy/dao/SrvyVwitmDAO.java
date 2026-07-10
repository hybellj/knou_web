package knou.lms.srvy.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvyVwitmVO;

@Mapper("srvyVwitmDAO")
public interface SrvyVwitmDAO {

	// 설문문항목록보기항목삭제
	public void srvyQstnListVwitmDelete(List<SrvyQstnVO> list);

	// 설문보기항목일괄등록
	public void srvyVwitmBulkRegist(List<SrvyVwitmVO> list);

	// 설문보기항목삭제
	public void srvyVwitmDelete(@Param("srvyQstnId") String srvyQstnId);

	// 설문보기항목목록조회
	public List<SrvyVwitmVO> srvyVwitmList(@Param("srvyQstnId") String srvyQstnId);

	// 설문보기항목가져오기
	public void srvyVwitmCopy(List<Map<String, Object>> list);

	// 설문보기항목일괄조회
	public List<SrvyVwitmVO> srvyVwitmBulkList(@Param("srvyId") String srvyId, @Param("qstnRspnsTycd") String qstnRspnsTycd, @Param("searchType") String searchType);

	// 설문문항목록보기항목전체삭제
	public void srvyQstnListVwitmAllDelete(SrvyVO vo);

	// 설문보기항목설문지이동아이디수정
	public void srvyVwitmMvmnSrvypprIdModify(@Param("srvyId") String srvyId);

}
