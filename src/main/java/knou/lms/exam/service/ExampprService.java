package knou.lms.exam.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamBscVO;

public interface ExampprService {

	// 시험응시시험지답안목록조회
	public List<EgovMap> tkexamExampprAnswShtList(String tkexamId, String userId);

	// 시험지일괄엑셀다운퀴즈문항목록
	public List<EgovMap> exampprBulkExcelDownQuizQstnList(ExamBscVO vo);

}
