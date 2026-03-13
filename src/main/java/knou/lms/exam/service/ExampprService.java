package knou.lms.exam.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamBscVO;

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

	/**
	* 시험지일괄엑셀다운퀴즈문항목록
	*
	* @param examBscId 	시험기본아이디
    * @param sbjctId 	과목아이디
	* @return 시험지일괄엑셀다운퀴즈문항목록
	* @throws Exception
	*/
	public List<EgovMap> exampprBulkExcelDownQuizQstnList(ExamBscVO vo) throws Exception;

}
