package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.exam.vo.QstnVO;
import knou.lms.exam.vo.QstnVwitmVO;

@Mapper("qstnVwitmDAO")
public interface QstnVwitmDAO {

	// 문항보기항목목록조회
	public List<QstnVwitmVO> qstnVwitmList(QstnVwitmVO vo);

	// 문항보기항목일괄등록
	public void qstnVwitmBulkRegist(List<QstnVwitmVO> list);

	// 문항보기항목삭제
	public void qstnVwitmDelete(QstnVwitmVO vo);

	// 문항보기항목일괄목록조회
	public List<QstnVwitmVO> qstnVwitmBulkList(QstnVO vo);

	// 퀴즈문항보기항목가져오기
	public void qstnVwitmCopy(List<Map<String, Object>> list);

	// 문항보기항목전체삭제
	public void qstnVwitmAllDelete(QstnVO vo);

	// 문항보기항목일괄수정
	public void qstnVwitmBulkModify(List<QstnVwitmVO> list);

	// 연습돌발문항보기항목일괄삭제
	public void exrcsSddnQstnVwitmBulkDelete(List<QstnVO> list);

	// 학생시험지문항보기항목목록조회
	public List<QstnVwitmVO> stdntExampprQstnVwitmList(Map<String, Object> params);

	// 문항보기항목목록전체삭제
	public void qstnVwitmListAllDelete(@Param("id") String id);

	// 교수미리보기문항보기항목목록조회
	public List<QstnVwitmVO> profPreviewQstnVwitmList(List<Map<String, Object>> list);
}
