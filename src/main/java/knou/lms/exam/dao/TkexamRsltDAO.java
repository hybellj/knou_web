package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

@Mapper("tkexamRsltDAO")
public interface TkexamRsltDAO {

	// 교수메모조회
	public EgovMap profMemoSelect(@Param("tkexamId") String tkexamId, @Param("userId") String userId);

	// 교수메모수정
	public void profMemoModify(Map<String, Object> params);

	// 사용자시험응시결과초기화
	public void userTkexamRsltInit(Map<String, Object> params);

	// 사용자목록평가점수일괄수정
	public void userListEvlScrBulkModify(List<Map<String, Object>> list);

	// 학생시험응시결과조회
	public EgovMap stdntTkexamRsltSelect(Map<String, Object> params);

	// 학생시험응시결과등록
	public void stdntTkexamRsltRegist(Map<String, Object> params);

}