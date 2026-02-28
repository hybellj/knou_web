package knou.lms.exam.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface ExampprService {

	/**
	* 시험응시시험지답안목록조회
	*
	* @param tkexamId 	시험응시아이디
    * @param userId 	사용자아이디
	* @return 퀴즈응시답안목록
	* @throws Exception
	*/
	public List<EgovMap> tkexamExampprAnswShtList(String tkexamId, String userId) throws Exception;

}
