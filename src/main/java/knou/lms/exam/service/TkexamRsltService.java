package knou.lms.exam.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamBscVO;

public interface TkexamRsltService {

	// 교수메모조회
	public EgovMap profMemoSelect(String tkexamId, String userId);

	// 교수메모수정
	public void profMemoModify(Map<String, Object> params);

	// 교수퀴즈평가점수일괄수정
	public void profQuizEvlScrBulkModify(List<Map<String, Object>> list);

	// 퀴즈성적엑셀업로드
	public void quizScrExcelUpload(ExamBscVO vo);

	// 학생시험응시결과조회
	public EgovMap stdntTkexamRsltSelect(Map<String, Object> params);

}
