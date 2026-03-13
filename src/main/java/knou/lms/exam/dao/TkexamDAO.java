package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamDtlVO;

@Mapper("tkexamDAO")
public interface TkexamDAO {

	/**
	* 퀴즈응시목록조회
	*
	* @param examBscId 		시험기본아이디
    * @param tkexamCmptnyn 	응시여부
    * @param evlyn 			평가여부
    * @param searchValue 	검색어(학과, 학번, 이름)
    * @param userId 		사용자아이디
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
	public EgovMap quizExamneeSelect(@Param("examDtlId") String examDtlId, @Param("userId") String userId) throws Exception;

	/**
	 * 사용자목록재응시설정
	 *
	 * @param List<ExamDtlVO>
	 * @throws Exception
	 */
	public void userListRetkexamSetting(List<ExamDtlVO> list) throws Exception;

	/**
	 * 사용자시험응시등록
	 *
	 * @param tkexamId 		시험응시아이디
	 * @param examDtlId 	시험상세아이디
	 * @param userId 		사용자아이디
	 * @throws Exception
	 */
	public void userTkexamRegist(Map<String, Object> params) throws Exception;

	/**
	 * 사용자시험응시초기화
	 *
	 * @param tkexamId 		시험응시아이디
	 * @param examDtlId 	시험상세아이디
	 * @param userId 		사용자아이디
	 * @throws Exception
	 */
	public void userTkexamInit(Map<String, Object> params) throws Exception;

	/**
	 * 사용자목록시험응시등록
	 *
	 * @param tkexamId 		시험응시아이디
	 * @param examDtlId 	시험상세아이디
	 * @param userId 		사용자아이디
	 * @throws Exception
	 */
	public void userListTkexamRegist(List<Map<String, Object>> list) throws Exception;

	/**
	* 사용자시험응시현황조회
	*
	* @param examBscId 	시험기본아이디
    * @param sbjctId 	과목이이디
	* @return 퀴즈응시현황조회
	* @throws Exception
	*/
	public EgovMap userTkexamStatusSelect(@Param("examBscId") String examBscId, @Param("sbjctId") String sbjctId) throws Exception;

}
