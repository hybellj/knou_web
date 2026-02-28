package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.TkexamHstryVO;

@Mapper("tkexamHstryDAO")
public interface TkexamHstryDAO {

	/**
	* 교수퀴즈응시이력목록조회
	*
	* @param examDtlId 	시험상세아이디
    * @param userId 	사용자아이디
	* @return 퀴즈응시이력목록
	* @throws Exception
	*/
	public List<EgovMap> profQuizTkexamHstryList(@Param("examDtlId") String examDtlId, @Param("userId") String userId) throws Exception;

	/**
	 * 사용자목록재응시이력등록
	 *
	 * @param List<ExamDtlVO>
	 * @throws Exception
	 */
	public void userListRetkexamHstryRegist(List<ExamDtlVO> list) throws Exception;

	/**
	 * 사용자시험응시이력등록
	 *
	 * @param TkexamHstryVO
	 * @throws Exception
	 */
	public void userTkexamHstryRegist(TkexamHstryVO vo) throws Exception;

	/**
	* 사용자시험응시정보조회
	*
	* @param tkexamId 	시험응시아이디
	* @param examDtlId 	시험상세아이디
    * @param userId 	사용자아이디
	* @return 사용자시험응시정보
	* @throws Exception
	*/
	public TkexamHstryVO userTkexamInfoSelect(Map<String, Object> params) throws Exception;

}
