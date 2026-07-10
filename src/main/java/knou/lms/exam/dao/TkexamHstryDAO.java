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

	// 교수퀴즈응시이력목록조회
	public List<EgovMap> profQuizTkexamHstryList(@Param("examDtlId") String examDtlId, @Param("userId") String userId);

	// 사용자목록재응시이력등록
	public void userListRetkexamHstryRegist(List<ExamDtlVO> list);

	// 사용자시험응시이력등록
	public void userTkexamHstryRegist(TkexamHstryVO vo);

	// 사용자시험응시정보조회
	public TkexamHstryVO userTkexamInfoSelect(Map<String, Object> params);

	// 학생퀴즈응시이력조회
	public List<EgovMap> stdntQuizTkexamHstryList(TkexamHstryVO vo);

}
