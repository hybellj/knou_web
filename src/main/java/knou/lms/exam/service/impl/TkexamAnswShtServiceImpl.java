package knou.lms.exam.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
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
import knou.framework.util.StringUtil;
import knou.lms.exam.dao.TkexamAnswShtDAO;
import knou.lms.exam.dao.TkexamDAO;
import knou.lms.exam.dao.TkexamHstryDAO;
import knou.lms.exam.service.ExampprService;
import knou.lms.exam.service.TkexamAnswShtService;
import knou.lms.exam.vo.TkexamHstryVO;

@Service("tkexamAnswShtService")
public class TkexamAnswShtServiceImpl extends ServiceBase implements TkexamAnswShtService {

	@Resource(name="tkexamAnswShtDAO")
	private TkexamAnswShtDAO tkexamAnswShtDAO;

	@Resource(name="tkexamHstryDAO")
	private TkexamHstryDAO tkexamHstryDAO;

	@Resource(name="tkexamDAO")
	private TkexamDAO tkexamDAO;

	@Resource(name="exampprService")
	private ExampprService exampprService;

	/**
	* 시험응시답안점수수정
	*
	* @param exampprId 			시험지아이디
	* @param qstnId 			문항아이디
	* @param tkexamAnswShtId 	시험응시답안아이디
	* @param userId 			사용자아이디
	*/
	@Override
	public void tkexamAnswShtScrModify(List<Map<String, Object>> list) {
		for(Map<String, Object> map : list) {
			Object tkexamAnswShtId = map.get("tkexamAnswShtId");
			if(tkexamAnswShtId == null || "".equals(String.valueOf(tkexamAnswShtId).trim().toLowerCase())) {
				map.put("tkexamAnswShtId", IdGenUtil.genNewId(IdPrefixType.TKANS));
			}
		}
		tkexamAnswShtDAO.tkexamAnswShtScrModify(list);
	}

	/**
	* 학생단일문항임시저장
	*
	* @param qstnId		문항아이디
    * @param answShtCts	답안내용
    * @param tkexamId	시험응시아이디
	*/
	@Override
	public void stdntSsnlQstnTempSave(Map<String, Object> params) {
		// 학생단일문항임시저장
		tkexamAnswShtDAO.stdntSsnlQstnTempSave(params);

		// 퀴즈시험지정답점수수정
		String examDtlId = quizExampprCransScrModify(params.get("tkexamId").toString(), params.get("userId").toString());
		params.put("examDtlId", examDtlId);

		// 퀴즈시험지이력등록
		quizExampprHstryRegist(params, "EXAMPPR_TMP_SAVE");
	}

	/**
	* 학생문항일괄임시저장
	*
	* @param rspns		답안목록
    * @param tkexamId	시험응시아이디
	*/
	@Override
	public void stdntQstnBulkTempSave(Map<String, Object> params) {
		ObjectMapper mapper = new ObjectMapper();
    	List<Map<String, Object>> rspns = mapper.convertValue(params.get("rspns"), new TypeReference<List<Map<String, Object>>>() {});	// 답안목록
    	params.put("rspns", rspns);
    	// 학생문항일괄임시저장
    	tkexamAnswShtDAO.stdntQstnBulkTempSave(params);

    	// 퀴즈시험지정답점수수정
    	String examDtlId = quizExampprCransScrModify(params.get("tkexamId").toString(), params.get("userId").toString());
    	params.put("examDtlId", examDtlId);

    	// 퀴즈시험지이력등록
		quizExampprHstryRegist(params, "EXAMPPR_TMP_SAVE");
	}

	/**
	* 학생퀴즈시험지제출
	*
	* @param rspns		답안목록
    * @param tkexamId	시험응시아이디
	*/
	@Override
	public void stdntQuizExampprSbmsn(Map<String, Object> params) {
		ObjectMapper mapper = new ObjectMapper();
    	List<Map<String, Object>> rspns = mapper.convertValue(params.get("rspns"), new TypeReference<List<Map<String, Object>>>() {});	// 답안목록
    	params.put("rspns", rspns);
    	// 학생문항일괄임시저장
    	tkexamAnswShtDAO.stdntQstnBulkTempSave(params);

    	// 퀴즈시험지정답점수수정
    	String examDtlId = quizExampprCransScrModify(params.get("tkexamId").toString(), params.get("userId").toString());
    	params.put("examDtlId", examDtlId);

    	// 학생퀴즈시험지제출
    	tkexamDAO.stdntQuizExampprSbmsn(params);

    	// 퀴즈시험지이력등록
    	quizExampprHstryRegist(params, "EXAMPPR_SBMSN");
	}

	// 퀴즈시험지정답점수수정
	private String quizExampprCransScrModify(String tkexamId, String userId) {
		String examDtlId = "";

		// 시험응시시험지답안목록조회
		List<EgovMap> answList = exampprService.tkexamExampprAnswShtList(tkexamId, userId);

		List<Map<String, Object>> modifyList = new ArrayList<Map<String,Object>>();
		for(EgovMap answ : answList) {
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("exampprId", answ.get("exampprId"));
			map.put("qstnId", answ.get("qstnId"));
			map.put("userId", userId);
			map.put("rgtrId", userId);
			if("Y".equals(answ.get("ansrYn"))) {
				map.put("tkexamAnswShtId", answ.get("tkexamAnswShtId"));
				map.put("scr", answ.get("qstnScr"));
				modifyList.add(map);
			} else {
				if(answ.get("tkexamAnswShtId") != null && !"".equals(answ.get("tkexamAnswShtId"))) {
					map.put("tkexamAnswShtId", answ.get("tkexamAnswShtId"));
					map.put("scr", 0);
					modifyList.add(map);
				}
			}
		}
		// 시험응시답안점수수정
		tkexamAnswShtDAO.tkexamAnswShtScrModify(modifyList);

		if(answList.size() > 0) examDtlId = answList.get(0).get("examDtlId").toString();
		return examDtlId;
	}

	// 퀴즈시험지이력등록
	public void quizExampprHstryRegist(Map<String, Object> params, String examHstryGbncd) {
		// 사용자시험응시정보조회
		TkexamHstryVO hstryVO = tkexamHstryDAO.userTkexamInfoSelect(params);

		// 사용자시험응시이력등록
		hstryVO.setRgtrId((String) params.get("userId"));
		hstryVO.setTkexamHstryId(IdGenUtil.genNewId(IdPrefixType.TKHTR));
		hstryVO.setExamHstryGbncd(examHstryGbncd);
		hstryVO.setTkexamIp(StringUtil.nvl(params.get("ip"), "0:0:0:0:0:0:0:1"));
		tkexamHstryDAO.userTkexamHstryRegist(hstryVO);

		// 학생퀴즈응시시간수정
		params.put("tkexamMnts", hstryVO.getTkexamMnts());
		tkexamDAO.stdntQuizTkexamMntsModify(params);
	}

}
