package knou.lms.exam.service;

import java.util.List;
import java.util.Map;

public interface TkexamAnswShtService {

	// 시험응시답안점수수정
	public void tkexamAnswShtScrModify(List<Map<String, Object>> list);

	// 학생단일문항임시저장
	public void stdntSsnlQstnTempSave(Map<String, Object> params);

	// 학생문항일괄임시저장
	public void stdntQstnBulkTempSave(Map<String, Object> params);

	// 학생퀴즈시험지제출
	public void stdntQuizExampprSbmsn(Map<String, Object> params);

	// 퀴즈시험지이력등록
	public void quizExampprHstryRegist(Map<String, Object> params, String examHstryGbncd);

}
