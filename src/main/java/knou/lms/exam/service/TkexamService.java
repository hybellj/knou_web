package knou.lms.exam.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.exam.vo.ExamDtlVO;

public interface TkexamService {

	// 퀴즈응시목록조회
	public List<EgovMap> quizTkexamList(Map<String, Object> params);

	// 퀴즈응시자조회
	public EgovMap quizExamneeSelect(String examDtlId, String userId);

	// 퀴즈재응시설정
	public void quizRetkexamSetting(List<ExamDtlVO> list);

	// 퀴즈시험지초기화
	public void quizExampprInit(Map<String, Object> params);

	// 사용자시험응시현황조회
	public EgovMap userTkexamStatusSelect(String examBscId, String sbjctId);

	// 학생퀴즈응시
	public ResultDTO<EgovMap> stdntQuizTkexam(Map<String, Object> params);

}
