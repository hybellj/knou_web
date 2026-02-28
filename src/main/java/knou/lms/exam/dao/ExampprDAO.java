package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamDtlVO;

@Mapper("exampprDAO")
public interface ExampprDAO {

	/**
	* 시험응시시험지답안목록조회
	*
	* @param tkexamId 	시험응시아이디
    * @param userId 	사용자아이디
	* @return 퀴즈응시답안목록
	* @throws Exception
	*/
	public List<EgovMap> tkexamExampprAnswShtList(@Param("tkexamId") String tkexamId, @Param("userId") String userId) throws Exception;

	/**
	 * 사용자목록시험지삭제
	 *
	 * @param List<ExamDtlVO>
	 * @throws Exception
	 */
	public void userListExampprDelete(List<ExamDtlVO> list) throws Exception;

	/**
	 * 사용자목록시험지등록
	 *
	 * @param List<ExamDtlVO>
	 * @throws Exception
	 */
	public void userListExampprRegist(List<ExamDtlVO> list) throws Exception;

	/**
	 * 사용자시험지삭제
	 *
	 * @param tkexamId 	시험응시아이디
     * @param userId 	사용자아이디
	 * @throws Exception
	 */
	public void userExampprDelete(Map<String, Object> params) throws Exception;

	/**
	 * 사용자시험지등록
	 *
	 * @param examBscId 시험기본아이디
	 * @param examDtlId 시험상세아이디
     * @param userId 	사용자아이디
	 * @throws Exception
	 */
	public void userExampprRegist(Map<String, Object> params) throws Exception;

}
