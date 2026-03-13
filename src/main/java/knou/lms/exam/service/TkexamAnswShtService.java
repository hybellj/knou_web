package knou.lms.exam.service;

import java.util.List;
import java.util.Map;

public interface TkexamAnswShtService {

	/**
	* 시험응시답안점수수정
	*
	* @param exampprId 			시험지아이디
	* @param qstnId 			문항아이디
	* @param tkexamAnswShtId 	시험응시답안아이디
	* @param userId 			사용자아이디
	* @throws Exception
	*/
	public void tkexamAnswShtScrModify(List<Map<String, Object>> list) throws Exception;

}
