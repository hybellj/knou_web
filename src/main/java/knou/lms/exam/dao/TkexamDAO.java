package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamDtlVO;

@Mapper("tkexamDAO")
public interface TkexamDAO {

	// 퀴즈응시목록조회
	public List<EgovMap> quizTkexamList(Map<String, Object> params);

	// 퀴즈응시자조회
	public EgovMap quizExamneeSelect(@Param("examDtlId") String examDtlId, @Param("userId") String userId);

	// 사용자목록재응시설정
	public void userListRetkexamSetting(List<ExamDtlVO> list);

	// 사용자시험응시등록
	public void userTkexamRegist(Map<String, Object> params);

	// 사용자시험응시초기화
	public void userTkexamInit(Map<String, Object> params);

	// 사용자목록시험응시등록
	public void userListTkexamRegist(List<Map<String, Object>> list);

	// 사용자시험응시현황조회
	public EgovMap userTkexamStatusSelect(@Param("examBscId") String examBscId, @Param("sbjctId") String sbjctId);

	// 학생퀴즈응시정보조회
	public EgovMap stdntQuizTkexamInfoSelect(Map<String, Object> params);

	// 학생퀴즈응시
	public void stdntQuizTkexam(Map<String, Object> params);

	// 학생퀴즈응시시간수정
	public void stdntQuizTkexamMntsModify(Map<String, Object> params);

	// 학생퀴즈시험지제출
	public void stdntQuizExampprSbmsn(Map<String, Object> params);

}
