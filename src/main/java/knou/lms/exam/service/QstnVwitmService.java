package knou.lms.exam.service;

import java.util.List;
import java.util.Map;

import knou.lms.exam.vo.QstnVO;
import knou.lms.exam.vo.QstnVwitmVO;

public interface QstnVwitmService {

	// 문항보기항목목록조회
	public List<QstnVwitmVO> qstnVwitmList(QstnVwitmVO vo);

	// 문항보기항목일괄목록조회
	public List<QstnVwitmVO> qstnVwitmBulkList(QstnVO VO);

	// 교수미리보기문항보기항목목록조회
	public List<QstnVwitmVO> profPreviewQstnVwitmList(List<Map<String, Object>> list);
}
