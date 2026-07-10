package knou.lms.exam.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.ExrcsSddnQstnBscVO;
import knou.lms.exam.web.view.QuizPageInfo;

@Mapper("exrcsSddnQstnBscDAO")
public interface ExrcsSddnQstnBscDAO {

	// 교수연습돌발문항기본목록페이징
	public List<EgovMap> profExrcsSddnQstnBscListPaging(QuizPageInfo pageInfo);

	// 연습돌발문항기본조회
	public EgovMap exrcsSddnQstnBscSelect(ExrcsSddnQstnBscVO vo);

	// 연습돌발문항기본일괄등록
	public void exrcsSddnQstnBscBulkRegist(List<ExrcsSddnQstnBscVO> list);

	// 연습돌발문항기본수정
	public void exrcsSddnQstnBscModify(ExrcsSddnQstnBscVO vo);

	// 연습돌발문항기본동일그룹목록조회
	public List<ExrcsSddnQstnBscVO> exrcsSddnQstnBscListByGrpId(@Param("exrcsSddnQstnBscId") String exrcsSddnQstnBscId);

	// 문제가져오기연습문제목록조회
	public List<ExrcsSddnQstnBscVO> qstnCopyExrcsQstnList(@Param("sbjctId") String sbjctId);

	// 연습문제출제완료여부일괄수정
	public void exrcsQstnscmptnynBulkModify(List<ExrcsSddnQstnBscVO> vo);

	// 돌발퀴즈등록
	public void sddnQuizRegist(ExrcsSddnQstnBscVO vo);

	// 관리자연습돌발문항기본목록페이징
	public List<EgovMap> admExrcsSddnQstnBscListPaging(QuizPageInfo pageInfo);
}
