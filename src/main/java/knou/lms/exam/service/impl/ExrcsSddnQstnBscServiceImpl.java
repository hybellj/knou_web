package knou.lms.exam.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.exam.dao.ExamDAO;
import knou.lms.exam.dao.ExrcsSddnQstnBscDAO;
import knou.lms.exam.dao.QstnDAO;
import knou.lms.exam.dao.QstnVwitmDAO;
import knou.lms.exam.service.ExrcsSddnQstnBscService;
import knou.lms.exam.vo.ExamGrpVO;
import knou.lms.exam.vo.ExrcsSddnQstnBscVO;
import knou.lms.exam.vo.QstnVO;
import knou.lms.exam.vo.QstnVwitmVO;
import knou.lms.exam.web.view.QuizPageInfo;

@Service("exrcsSddnQstnBscService")
public class ExrcsSddnQstnBscServiceImpl extends ServiceBase implements ExrcsSddnQstnBscService {

	@Resource(name="exrcsSddnQstnBscDAO")
	private ExrcsSddnQstnBscDAO exrcsSddnQstnBscDAO;

	@Resource(name="examDAO")
	private ExamDAO examDAO;

	@Resource(name="qstnDAO")
	private QstnDAO qstnDAO;

	@Resource(name="qstnVwitmDAO")
	private QstnVwitmDAO qstnVwitmDAO;

	/**
	* 교수연습돌발문항기본목록페이징
	*
	* @param sbjctId 		과목아이디
	* @param qstnGbncd 		문항구분코드
	* @param searchValue 	검색내용(제목)
	* @param listScale	 	페이지크기
	* @return 연습돌발문항기본목록 페이징
	*/
	@Override
	public ResultDTO<EgovMap> profExrcsSddnQstnBscListPaging(QuizPageInfo pageInfo) {
        ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(exrcsSddnQstnBscDAO.profExrcsSddnQstnBscListPaging(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
	* 연습돌발문항기본조회
	*
	* @param sbjctId 				과목아이디
	* @param qstnGbncd 				문항구분코드
	* @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
	* @return 연습돌발문항기본
	*/
	@Override
	public EgovMap exrcsSddnQstnBscSelect(ExrcsSddnQstnBscVO vo) {
		return exrcsSddnQstnBscDAO.exrcsSddnQstnBscSelect(vo);
	}

	/**
	 * 연습문제등록
	 *
	 * @param ExrcsSddnQstnBscVO
	 */
	@Override
	public ExrcsSddnQstnBscVO exrcsQstnRegist(ExrcsSddnQstnBscVO vo) {
		ObjectMapper mapper = new ObjectMapper();
		List<String> sbjctIds = new ArrayList<>(Arrays.asList(vo.getSubParam().split(",")));	// 분반과목아이디목록
		sbjctIds.removeIf(item -> item.equals(vo.getSbjctId()));	// 등록분반제거

		String examGrpId = IdGenUtil.genNewId(IdPrefixType.EXGRP);
		if(sbjctIds.size() > 0) {
			ExamGrpVO grpVO = new ExamGrpVO();
            grpVO.setExamGrpId(examGrpId);
            grpVO.setExamGrpnm("연습문제그룹");
            grpVO.setRgtrId(vo.getRgtrId());
            examDAO.examGrpRegist(grpVO); // 문항분류그룹등록
		}

		// 일괄등록용 목록
		List<ExrcsSddnQstnBscVO> exrcsQstnList = new ArrayList<ExrcsSddnQstnBscVO>();

		vo.setExrcsSddnQstnBscId(IdGenUtil.genNewId(IdPrefixType.EXQSB));
		if(sbjctIds.size() > 0) vo.setQstnGrpId(examGrpId);
		exrcsQstnList.add(vo);

		// 분반정보추가
		for(String sbjctId : sbjctIds) {
			ExrcsSddnQstnBscVO subQstnVO = mapper.convertValue(vo, ExrcsSddnQstnBscVO.class);
			subQstnVO.setExrcsSddnQstnBscId(IdGenUtil.genNewId(IdPrefixType.EXQSB));
			subQstnVO.setSbjctId(sbjctId);
			subQstnVO.setQstnGrpId(examGrpId);
			exrcsQstnList.add(subQstnVO);
		}

		if(exrcsQstnList.size() > 0) exrcsSddnQstnBscDAO.exrcsSddnQstnBscBulkRegist(exrcsQstnList);	// 연습돌발문항기본일괄등록

		return vo;
	}

	/**
	 * 연습문제수정
	 *
	 * @param ExrcsSddnQstnBscVO
	 */
	public ExrcsSddnQstnBscVO exrcsQstnModify(ExrcsSddnQstnBscVO vo) {
		exrcsSddnQstnBscDAO.exrcsSddnQstnBscModify(vo);
		return vo;
	}

	/**
	* 문제가져오기연습문제목록조회
	*
	* @param sbjctId 	과목아이디
	* @return 문제가져오기연습문제목록
	*/
	@Override
	public List<ExrcsSddnQstnBscVO> qstnCopyExrcsQstnList(String sbjctId) {
		return exrcsSddnQstnBscDAO.qstnCopyExrcsQstnList(sbjctId);
	}

	/**
     * 연습문제출제완료수정
     *
     * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
     * @param searchGubun 			수정상태 ( save, edit )
     */
	@Override
	public void exrcsQstnsCmptnModify(ExrcsSddnQstnBscVO vo) {
		String qstnsCmptyn = "edit".equals(vo.getSearchGubun()) ? "M" : "Y";

		List<ExrcsSddnQstnBscVO> exrcsSddnQstnList = exrcsSddnQstnBscDAO.exrcsSddnQstnBscListByGrpId(vo.getExrcsSddnQstnBscId());	// 연습돌발문항기본동일그룹목록조회
		exrcsSddnQstnList.forEach(exrcs -> {
			exrcs.setMdfrId(vo.getMdfrId());
			exrcs.setQstnsCmptnyn(qstnsCmptyn);
		});

		exrcsSddnQstnBscDAO.exrcsQstnscmptnynBulkModify(exrcsSddnQstnList);	// 연습문제출제완료여부일괄수정
	}

	/**
	 * 돌발퀴즈등록
	 *
	 * @param ExrcsSddnQstnBscVO	연습돌발문항기본정보
	 * @param QstnVO				문항정보
	 * @param qstnsStr				문항보기항복정보목록
	 */
	public void sddnQuizRegist(ExrcsSddnQstnBscVO vo, QstnVO qstn, String qstnsStr) {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> qstns = new ArrayList<Map<String,Object>>();
		try {
			qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});	// 문항보기항목정보
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		// 돌발퀴즈등록
		vo.setExrcsSddnQstnBscId(IdGenUtil.genNewId(IdPrefixType.EXQSB));
		exrcsSddnQstnBscDAO.sddnQuizRegist(vo);

		// 문항등록
		qstn.setQstnId(IdGenUtil.genNewId(IdPrefixType.QSTN));
		qstn.setExrcsSddnQstnBscId(vo.getExrcsSddnQstnBscId());
		qstn.setRgtrId(vo.getRgtrId());
		qstnDAO.qstnRegist(qstn);

		List<QstnVwitmVO> vwitmList = new ArrayList<QstnVwitmVO>();		// 문항보기항목목록
		for (Map<String, Object> map : qstns) {
            QstnVwitmVO vwitm = new QstnVwitmVO();
            vwitm.setQstnId(qstn.getQstnId());
            vwitm.setQstnVwitmGbncd("TXT");
            vwitm.setRgtrId(vo.getRgtrId());
            vwitm.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
            vwitm.setQstnVwitmCts((String) map.get("qstnVwitmCts"));
            vwitm.setCransYn((String) map.get("cransYn"));
            vwitm.setQstnVwitmSeqno((Integer) map.get("qstnVwitmSeqno"));
            vwitmList.add(vwitm);
        }

		if(vwitmList.size() > 0) qstnVwitmDAO.qstnVwitmBulkRegist(vwitmList);	// 문항보기항목일괄등록
	}

	/**
	 * 돌발퀴즈수정
	 *
	 * @param ExrcsSddnQstnBscVO	연습돌발문항기본정보
	 * @param QstnVO				문항정보
	 * @param qstnsStr				문항보기항복정보목록
	 */
	public void sddnQuizModify(ExrcsSddnQstnBscVO vo, QstnVO qstn, String qstnsStr) {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> qstns = new ArrayList<Map<String,Object>>();
		try {
			qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});	// 문항보기항목정보
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		// 연습돌발문항기본수정
		exrcsSddnQstnBscDAO.exrcsSddnQstnBscModify(vo);

		// 문항수정
		qstn.setMdfrId(vo.getMdfrId());
    	qstnDAO.qstnModify(qstn);

    	// 기존 문항보기항목 삭제
    	QstnVwitmVO vwitmDeleteVO = new QstnVwitmVO();
    	vwitmDeleteVO.setQstnId(qstn.getQstnId());
    	qstnVwitmDAO.qstnVwitmDelete(vwitmDeleteVO);

		List<QstnVwitmVO> vwitmList = new ArrayList<QstnVwitmVO>();		// 문항보기항목목록
		for (Map<String, Object> map : qstns) {
			QstnVwitmVO vwitm = new QstnVwitmVO();
			vwitm.setQstnId(qstn.getQstnId());
			vwitm.setQstnVwitmGbncd("TXT");
			vwitm.setRgtrId(vo.getRgtrId());
			vwitm.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
			vwitm.setQstnVwitmCts((String) map.get("qstnVwitmCts"));
			vwitm.setCransYn((String) map.get("cransYn"));
			vwitm.setQstnVwitmSeqno((Integer) map.get("qstnVwitmSeqno"));
			vwitmList.add(vwitm);
		}

		if(vwitmList.size() > 0) qstnVwitmDAO.qstnVwitmBulkRegist(vwitmList);	// 문항보기항목일괄등록
	}

	/**
	* 관리자연습돌발문항기본목록페이징
	*
	* @param sbjctId     	과목아이디
	* @param dgrsYr			학위연도
    * @param smstrChrtId	학기기수아이디
    * @param orgId     		기관아이디
	* @param qstnGbncd 		문항구분코드
	* @param searchValue 	검색내용(제목)
	* @param listScale	 	페이지크기
	* @return 연습돌발문항기본목록 페이징
	*/
	@Override
	public ResultDTO<EgovMap> admExrcsSddnQstnBscListPaging(QuizPageInfo pageInfo) {
        ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(exrcsSddnQstnBscDAO.admExrcsSddnQstnBscListPaging(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

}
