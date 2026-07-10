package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.TkexamAnswShtVO;

@Mapper("tkexamAnswShtDAO")
public interface TkexamAnswShtDAO {

	// 사용자목록응시답안삭제
	public void userListTkexamAnswShtDelete(List<ExamDtlVO> list);

	// 사용자응시답안삭제
	public void userTkexamAnswShtDelete(Map<String, Object> params);

	// 시험응시답안점수수정
	public void tkexamAnswShtScrModify(List<Map<String, Object>> list);

	// 시험응시답안점수수정
	public List<EgovMap> qstnTkexamAnswShtCtsList(@Param("qstnId") String qstnId, @Param("exampprId") String exampprId);

	// 학생시험지응시답안목록조회
	public List<TkexamAnswShtVO> stdntExampprAnswShtList(Map<String, Object> params);

	// 학생단일문항임시저장
	public void stdntSsnlQstnTempSave(Map<String, Object> params);

	// 학생문항일괄임시저장
	public void stdntQstnBulkTempSave(Map<String, Object> params);

}
