package knou.lms.exam.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.exam.dao.TkexamDAO;
import knou.lms.exam.dao.TkexamRsltDAO;
import knou.lms.exam.service.TkexamRsltService;

@Service("tkexamRsltService")
public class TkexamRsltServiceImpl extends ServiceBase implements TkexamRsltService {

	@Resource
	private TkexamRsltDAO tkexamRsltDAO;

	@Resource
	private TkexamDAO tkexamDAO;

	/**
	* 교수메모조회
	*
	* @param tkexamId 	시험응시아이디
    * @param userId 	사용자이이디
	* @return 교수메모조회
	* @throws Exception
	*/
	@Override
	public EgovMap profMemoSelect(String tkexamId, String userId) throws Exception {
		return tkexamRsltDAO.profMemoSelect(tkexamId, userId);
	}

	/**
	* 교수메모수정
	*
	* @param examDtlId	 	시험상세아이디
	* @param tkexamRsltId 	시험응시결과아이디
    * @param tkexamId 		시험응시아이디
    * @param userId 		사용자이이디
    * @param profMemo 		교수메모
	* @throws Exception
	*/
	@Override
	public void profMemoModify(Map<String, Object> params) throws Exception {
		// 1. 응시정보 등록
		Object tkexamId = params.get("tkexamId");
		if(tkexamId == null || "null".equals(String.valueOf(tkexamId).trim().toLowerCase())) {
			params.put("tkexamId", IdGenUtil.genNewId(IdPrefixType.TKEXM));
			tkexamDAO.userTkexamRegist(params);
		}

		// 2. 교수메모 수정
		params.put("tkexamRsltId", IdGenUtil.genNewId(IdPrefixType.TKRST));
		tkexamRsltDAO.profMemoModify(params);
	}

	/**
	* 교수퀴즈평가점수일괄수정
	*
	* @param examDtlId 	시험상세아이디
	* @param tkexamId 	시험응시아이디
	* @param userId 	사용자아이디
	* @param scr 		점수
	* @param scoreType  점수유형
	* @throws Exception
	*/
	public void profQuizEvlScrBulkModify(List<Map<String, Object>> list) throws Exception {
		// 1. 응시정보 등록
		for(Map<String, Object> map : list) {
			Object tkexamId = map.get("tkexamId");
			if(tkexamId == null || "null".equals(String.valueOf(tkexamId).trim().toLowerCase())) {
				map.put("tkexamId", IdGenUtil.genNewId(IdPrefixType.TKEXM));
			}
			map.put("tkexamRsltId", IdGenUtil.genNewId(IdPrefixType.TKRST));
		}
		tkexamDAO.userListTkexamRegist(list);

		// 2. 응시결과점수등록
		tkexamRsltDAO.userListEvlScrBulkModify(list);
	}

}
