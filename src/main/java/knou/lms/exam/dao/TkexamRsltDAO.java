package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

@Mapper("tkexamRsltDAO")
public interface TkexamRsltDAO {

	/**
	* 교수메모조회
	*
	* @param tkexamId 	시험응시아이디
    * @param userId 	사용자이이디
	* @return 교수메모조회
	* @throws Exception
	*/
	public EgovMap profMemoSelect(@Param("tkexamId") String tkexamId, @Param("userId") String userId) throws Exception;

	/**
	* 교수메모수정
	*
	* @param tkexamRsltId 	시험응시결과아이디
    * @param tkexamId 		시험응시아이디
    * @param userId 		사용자이이디
    * @param profMemo 		교수메모
	* @throws Exception
	*/
	public void profMemoModify(Map<String, Object> params) throws Exception;

	/**
	* 사용자시험응시결과초기화
	*
    * @param tkexamId 		시험응시아이디
    * @param userId 		사용자이이디
	* @throws Exception
	*/
	public void userTkexamRsltInit(Map<String, Object> params) throws Exception;

	/**
	 * 사용자목록평가점수일괄수정
	 *
	 * @param tkexamRsltId 	시험응시결과아이디
	 * @param tkexamId 		시험응시아이디
	 * @param userId 		사용자아이디
	 * @param scr 			점수
	 * @param scoreType 	점수유형
	 * @throws Exception
	 */
	public void userListEvlScrBulkModify(List<Map<String, Object>> list) throws Exception;

}