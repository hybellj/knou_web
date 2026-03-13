package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExamDtlVO;

@Mapper("tkexamAnswShtDAO")
public interface TkexamAnswShtDAO {

	/**
	 * 사용자목록응시답안삭제
	 *
	 * @param List<ExamDtlVO>
	 * @throws Exception
	 */
	public void userListTkexamAnswShtDelete(List<ExamDtlVO> list) throws Exception;

	/**
	 * 사용자응시답안삭제
	 *
	 * @param Map<String, Object>
	 * @throws Exception
	 */
	public void userTkexamAnswShtDelete(Map<String, Object> params) throws Exception;

	/**
	 * 시험응시답안점수수정
	 *
	 * @param List<Map<String, Object>> list
	 * @throws Exception
	 */
	public void tkexamAnswShtScrModify(List<Map<String, Object>> list) throws Exception;

	/**
	 * 시험응시답안점수수정
	 *
	 * @param qstnId	문항아이디
	 * @param exampprId 시험지아이디
	 * @return 시험응시답안목록
	 * @throws Exception
	 */
	public List<EgovMap> qstnTkexamAnswShtCtsList(@Param("qstnId") String qstnId, @Param("exampprId") String exampprId) throws Exception;

}
