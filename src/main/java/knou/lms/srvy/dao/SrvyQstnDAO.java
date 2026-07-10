package knou.lms.srvy.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyVO;

@Mapper("srvyQstnDAO")
public interface SrvyQstnDAO {

	// 설문문항목록조회
	public List<EgovMap> srvyQstnList(@Param("srvyId") String srvyId, @Param("searchType") String searchType);

	// 설문지문항목록조회
	public List<SrvyQstnVO> srvypprQstnList(@Param("srvypprId") String srvypprId);

	// 설문지문항삭제
	public void srvypprQstnDelete(@Param("srvypprId") String srvypprId);

	// 설문문항등록
	public void srvyQstnRegist(SrvyQstnVO vo);

	// 설문문항수정
	public void srvyQstnModify(SrvyQstnVO vo);

	// 설문문항미삭제순번수정
	public void srvyQstnDelNSeqnoModify(SrvyQstnVO vo);

	// 설문문항조회
	public SrvyQstnVO srvyQstnSelect(SrvyQstnVO vo);

	// 문항순번수정
	public void qstnSeqnoModify(SrvyQstnVO vo);

	// 교수문항복사설문문항목록조회
	public List<EgovMap> profQstnCopySrvyQstnList(SrvyQstnVO vo);

	// 설문문항가져오기
	public void srvyQstnCopy(List<Map<String, Object>> list);

	// 설문문항전체삭제
	public void srvyQstnAllDelete(SrvyVO vo);

	// 설문문항일괄등록
	public void srvyQstnBulkRegist(List<SrvyQstnVO> list);

}
