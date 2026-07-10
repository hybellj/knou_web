package knou.lms.exam.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.QstnVO;

@Mapper("qstnDAO")
public interface QstnDAO {

	// 문항목록조회
	public List<QstnVO> qstnList(QstnVO vo);

	// 문항개수조회
	public int qstnCntSelect(QstnVO vo);

	// 문항등록
	public void qstnRegist(QstnVO vo);

	// 문항수정
	public void qstnModify(QstnVO vo);

	// 문항순번수정
	public void qstnSeqnoModify(QstnVO vo);

	// 문항후보순번수정
	public void qstnCnddtSeqnoModify(QstnVO vo);

	// 문항조회
	public QstnVO qstnSelect(QstnVO vo);

	// 문항삭제여부수정
	public void qstnDelynModify(QstnVO vo);

	// 문항미삭제순번수정
	public void qstnDelNSeqnoModify(QstnVO vo);

	// 퀴즈문항점수수정
	public void quizQstnScrModify(QstnVO vo);

	// 퀴즈문항점수일괄수정
	public void quizQstnScrBulkModify(QstnVO vo);

	// 출제완료퀴즈문항점수일괄수정
	public void cmptnYQuizQstnScrBulkModify(List<Map<String, Object>> list);

	// 교수문항복사퀴즈문항목록조회
	public List<EgovMap> profQstnCopyQuizQstnList(QstnVO vo);

	// 퀴즈문항가져오기
	public void quizQstnCopy(List<Map<String, Object>> list);

	// 문항전체삭제
	public void qstnAllDelete(QstnVO vo);

	// 문항일괄등록
	public void qstnBulkRegist(List<QstnVO> list);

	// 연습돌발문항일괄수정
	public void exrcsSddnQstnBulkModify(List<QstnVO> list);

	// 연습문제일괄문항순번수정
	public void exrcsQstnBulkQstnSeqnoModify(List<QstnVO> list);

	// 연습문제일괄삭제여부수정
	public void exrcsQstnBulkDelynModify(List<QstnVO> list);

	// 연습문제일괄미삭제순번수정
	public void exrcsQstnBulkDelNSeqnoModify(List<QstnVO> list);

	// 연습돌발문항아이디목록
	public List<String> exrcsSddnQstnIdList(List<QstnVO> list);

	// 교수문항복사연습문제목록조회
	public List<EgovMap> profQstnCopyExrcsQstnList(QstnVO vo);

	// 연습문제가져오기
	public void exrcsQstnCopy(List<Map<String, Object>> list);

	// 강의주차등록문항수조회
	public int lctrWknoRegistQstnCntSelect(Map<String, Object> params);

	// 학생시험지문항목록조회
	public List<QstnVO> stdntExampprQstnList(Map<String, Object> params);

	// 문항목록전체삭제
	public void qstnListAllDelete(@Param("id") String id);

	// 교수미리보기문항목록조회
	public List<QstnVO> profPreviewQstnList(Map<String, Object> params);
}
