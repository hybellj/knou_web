package knou.lms.exam.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface TkexamHstryService {

	/**
	* 교수퀴즈응시이력목록조회
	*
	* @param examDtlId 	시험상세아이디
    * @param userId 	사용자아이디
	* @return 퀴즈응시이력목록
	* @throws Exception
	*/
	public List<EgovMap> profQuizTkexamHstryList(String examDtlId, String userId) throws Exception;

}
