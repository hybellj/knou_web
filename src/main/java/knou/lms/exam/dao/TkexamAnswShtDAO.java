package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

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

}
