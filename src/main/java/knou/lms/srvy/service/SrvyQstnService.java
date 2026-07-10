package knou.lms.srvy.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyVO;

public interface SrvyQstnService {

	// 설문문항목록조회
	public List<EgovMap> srvyQstnList(String srvyId, String searchType);

	// 설문지문항목록조회
	public List<SrvyQstnVO> srvypprQstnList(String srvypprId);

	// 설문지문항삭제
	public void srvypprQstnDelete(String srvypprId);

	// 설문문항등록
	public SrvyQstnVO srvyQstnRegist(SrvyQstnVO vo);

	// 설문문항수정
	public void srvyQstnModify(SrvyQstnVO vo);

	// 설문문항삭제
	public void srvyQstnDelete(SrvyQstnVO vo);

	// 설문문항조회
	public SrvyQstnVO srvyQstnSelect(SrvyQstnVO vo);

	// 문항순번수정
	public void qstnSeqnoModify(SrvyQstnVO vo);

	// 교수문항복사설문문항목록조회
	public List<EgovMap> profQstnCopySrvyQstnList(SrvyQstnVO vo);

	// 설문문항가져오기
	public void srvyQstnCopy(List<Map<String, Object>> list);

	// 설문문항엑셀샘플데이터
	public HashMap<String, Object> srvyQstnExcelSampleData(SrvyVO vo);

	// 설문문항엑셀업로드
	public ResultDTO<SrvyVO> srvyQstnExcelUpload(SrvyVO vo);

}
