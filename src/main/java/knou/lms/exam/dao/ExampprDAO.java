package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamBscVO;
import knou.lms.exam.vo.ExamDtlVO;

@Mapper("exampprDAO")
public interface ExampprDAO {

	// 시험응시시험지답안목록조회
	public List<EgovMap> tkexamExampprAnswShtList(@Param("tkexamId") String tkexamId, @Param("userId") String userId);

	// 사용자목록시험지삭제
	public void userListExampprDelete(List<ExamDtlVO> list);

	// 사용자목록시험지등록
	public void userListExampprRegist(List<ExamDtlVO> list);

	// 사용자시험지삭제
	public void userExampprDelete(Map<String, Object> params);

	// 사용자시험지등록
	public void userExampprRegist(Map<String, Object> params);

	// 시험지일괄엑셀다운퀴즈문항목록
	public List<EgovMap> exampprBulkExcelDownQuizQstnList(ExamBscVO vo);

}
