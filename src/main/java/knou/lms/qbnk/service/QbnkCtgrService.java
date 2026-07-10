package knou.lms.qbnk.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.qbnk.vo.QbnkCtgrVO;
import knou.lms.qbnk.web.view.QbnkPageInfo;

public interface QbnkCtgrService {

	// 교수문제은행분류목록조회
	public List<QbnkCtgrVO> profQbnkCtgrList(QbnkCtgrVO vo);

	// 교수문제은행분류전체목록조회
	public ResultDTO<EgovMap> profQbnkCtgrAllList(QbnkPageInfo pageInfo);

	// 교수문제은행과목조회
	public EgovMap profQbnkSbjctSelect(String sbjctId);

	// 문제은행다음분류순번조회
	public int qbnkNextCtgrSeqnoSelect(QbnkCtgrVO vo);

	// 문제은행분류등록
	public void qbnkCtgrRegist(QbnkCtgrVO vo);

	// 문제은행분류조회
	public QbnkCtgrVO qbnkCtgrSelect(String qbnkCtgrId);

	// 문제은행분류사용수조회
	public EgovMap qbnkCtgrUseCntSelect(String qbnkCtgrId);

	// 문제은행분류삭제
	public void qbnkCtgrDelete(QbnkCtgrVO vo);

	// 문제은행검색과목목록
	public List<EgovMap> qbnkSearchSbjctList(String sbjctId);

	// 문제은행검색교수목록
	public List<EgovMap> qbnkSearchProfList();

}
