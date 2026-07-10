package knou.lms.exam.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.exam.vo.ExrcsSddnQstnBscVO;
import knou.lms.exam.vo.QstnVO;
import knou.lms.exam.web.view.QuizPageInfo;

public interface ExrcsSddnQstnBscService {

	// 교수연습돌발문항기본목록페이징
	public ResultDTO<EgovMap> profExrcsSddnQstnBscListPaging(QuizPageInfo pageInfo);

	// 연습돌발문항기본조회
	public EgovMap exrcsSddnQstnBscSelect(ExrcsSddnQstnBscVO vo);

	// 연습문제등록
	public ExrcsSddnQstnBscVO exrcsQstnRegist(ExrcsSddnQstnBscVO vo);

	// 연습문제수정
	public ExrcsSddnQstnBscVO exrcsQstnModify(ExrcsSddnQstnBscVO vo);

	// 문제가져오기연습문제목록조회
	public List<ExrcsSddnQstnBscVO> qstnCopyExrcsQstnList(String sbjctId);

	// 연습문제출제완료수정
	public void exrcsQstnsCmptnModify(ExrcsSddnQstnBscVO vo);

	// 돌발퀴즈등록
	public void sddnQuizRegist(ExrcsSddnQstnBscVO vo, QstnVO qstn, String qstnsStr);

	// 돌발퀴즈수정
	public void sddnQuizModify(ExrcsSddnQstnBscVO vo, QstnVO qstn, String qstnsStr);

	// 관리자연습돌발문항기본목록페이징
	public ResultDTO<EgovMap> admExrcsSddnQstnBscListPaging(QuizPageInfo pageInfo);

}
