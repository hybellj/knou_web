package knou.lms.exam.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface TkexamRsltService {

	/**
	* 교수메모조회
	*
	* @param tkexamId 	시험응시아이디
    * @param userId 	사용자이이디
	* @return 교수메모조회
	* @throws Exception
	*/
	public EgovMap profMemoSelect(String tkexamId, String userId) throws Exception;

	/**
	* 교수메모수정
	*
	* @param examDtlId	 	시험상세아이디
	* @param tkexamRsltId 	시험응시결과아이디
    * @param tkexamId 		시험응시아이디
    * @param userId 		사용자이이디
    * @param profMemo 		교수메모
	* @throws Exception
	*/
	public void profMemoModify(Map<String, Object> params) throws Exception;

	/**
	* 교수퀴즈평가점수일괄수정
	*
	* @param examBscId 	시험기본아이디
	* @param examDtlId 	시험상세아이디
	* @param tkexamId 	시험응시아이디
	* @param userId 	사용자아이디
	* @param scr 		점수
	* @param scoreType  점수유형
	* @throws Exception
	*/
	public void profQuizEvlScrBulkModify(List<Map<String, Object>> list) throws Exception;

}
