package knou.lms.exam.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.exam.vo.TkexamHstryVO;

public interface TkexamHstryService {

	// 교수퀴즈응시이력목록조회
	public List<EgovMap> profQuizTkexamHstryList(String examDtlId, String userId);

	// 학생퀴즈응시이력조회
	public List<EgovMap> stdntQuizTkexamHstryList(TkexamHstryVO vo);

}
