package knou.lms.exam.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamDtlVO;

public interface TkexamService {

	/**
	* 퀴즈응시목록조회
	*
	* @param examBscId 		시험기본아이디
    * @param tkexamCmptnyn 	응시여부
    * @param evlyn 			평가여부
    * @param searchValue 	검색어(학과, 학번, 이름)
    * @param userId		 	사용자아이디
	* @return 퀴즈응시목록
	* @throws Exception
	*/
	public List<EgovMap> quizTkexamList(Map<String, Object> params) throws Exception;

	/**
	* 퀴즈응시자조회
	*
	* @param examDtlId 	시험상세아이디
    * @param userId 	사용자이이디
	* @return 퀴즈응시자조회
	* @throws Exception
	*/
	public EgovMap quizExamneeSelect(String examDtlId, String userId) throws Exception;

	/**
	* 퀴즈재응시설정
	*
	* @param List<ExamDtlVO>
	* @throws Exception
	*/
	public void quizRetkexamSetting(List<ExamDtlVO> list) throws Exception;

	/**
	* 퀴즈시험지초기화
	*
	* @param tkexamId 	시험응시아이디
	* @param examBscId 	시험기본아이디
	* @param examDtlId 	시험상세아이디
	* @param userId 	사용자아이디
	* @throws Exception
	*/
	public void quizExampprInit(Map<String, Object> params) throws Exception;

	/**
	* 사용자시험응시현황조회
	*
	* @param examBscId 	시험기본아이디
    * @param sbjctId 	과목이이디
	* @return 퀴즈응시현황조회
	* @throws Exception
	*/
	public EgovMap userTkexamStatusSelect(String examBscId, String sbjctId) throws Exception;

}
