package knou.lms.exam.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.exam.vo.QstnVO;

public interface QstnService {

	// 문항목록조회
	public List<QstnVO> qstnList(QstnVO vo);

	// 문항개수조회
	public int qstnCntSelect(QstnVO vo);

	// 퀴즈문항등록
	public void quizQstnRegist(QstnVO vo, String qstnsStr);

	// 퀴즈문항수정
	public void quizQstnModify(QstnVO vo, String qstnsStr);

	// 문항순번수정
	public void qstnSeqnoModify(QstnVO vo);

	// 문항후보순번수정
	public void qstnCnddtSeqnoModify(QstnVO vo);

	// 문항조회
	public QstnVO qstnSelect(QstnVO vo);

	// 퀴즈문항삭제
	public void quizQstnDelete(QstnVO vo);

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

	// 퀴즈문항분포바차트
	public ResultDTO<EgovMap> quizQstnDistributionBarChart(Map<String, Object> params);

	// 퀴즈문항정답현황파이차트
	public ResultDTO<EgovMap> quizQstnCransStatusPieChart(Map<String, Object> params);

	// 문항엑셀샘플데이터
	public HashMap<String, Object> qstnExcelSampleData(QstnVO vo);

	// 문항엑셀업로드
	public ResultDTO<EgovMap> qstnExcelUpload(QstnVO vo);

	// 퀴즈문항옵션수정
	public void quizQstnOptionModify(QstnVO vo, String qstnsStr);

	// 연습문제일괄문항등록
	public void exrcsQstnBulkQstnRegist(QstnVO vo, String qstnsStr);

	// 연습문제일괄문항수정
	public void exrcsQstnBulkQstnModify(QstnVO vo, String qstnsStr);

	// 연습문제일괄문항순번수정
	public void exrcsQstnBulkQstnSeqnoModify(QstnVO vo);

	// 연습문제일괄문항삭제
	public void exrcsQstnBulkQstnDelete(QstnVO vo);

	// 교수문항복사연습문제목록조회
	public List<EgovMap> profQstnCopyExrcsQstnList(QstnVO vo);

	// 연습문제일괄가져오기
	public void exrcsQstnBulkCopy(List<Map<String, Object>> list);

	// 강의주차등록문항수조회
	public int lctrWknoRegistQstnCntSelect(Map<String, Object> params);

	// 교수미리보기문항목록조회
	public List<QstnVO> profPreviewQstnList(Map<String, Object> params);
}
