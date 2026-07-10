package knou.lms.exam.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.exam.dao.TkexamHstryDAO;
import knou.lms.exam.service.TkexamHstryService;
import knou.lms.exam.vo.TkexamHstryVO;

@Service("tkexamHstryService")
public class TkexamHstryServiceImpl extends ServiceBase implements TkexamHstryService {

	@Resource
	private TkexamHstryDAO tkexamHstryDAO;

	/**
	* 교수퀴즈응시이력목록조회
	*
	* @param examDtlId 	시험상세아이디
    * @param userId 	사용자아이디
	* @return 퀴즈응시이력목록
	*/
	@Override
	public List<EgovMap> profQuizTkexamHstryList(String examDtlId, String userId) {
		return tkexamHstryDAO.profQuizTkexamHstryList(examDtlId, userId);
	}

	/**
	* 학생퀴즈응시이력조회
	*
	* @param examDtlId 	시험상세아이디
    * @param userId 	사용자아이디
	* @return 퀴즈응시이력
	*/
	@Override
	public List<EgovMap> stdntQuizTkexamHstryList(TkexamHstryVO vo) {
		return tkexamHstryDAO.stdntQuizTkexamHstryList(vo);
	}

}
