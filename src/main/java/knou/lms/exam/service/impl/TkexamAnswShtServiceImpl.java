package knou.lms.exam.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.exam.dao.TkexamAnswShtDAO;
import knou.lms.exam.service.TkexamAnswShtService;

@Service("tkexamAnswShtService")
public class TkexamAnswShtServiceImpl extends ServiceBase implements TkexamAnswShtService {

	@Resource
	private TkexamAnswShtDAO tkexamAnswShtDAO;

	/**
	* 시험응시답안점수수정
	*
	* @param exampprId 			시험지아이디
	* @param qstnId 			문항아이디
	* @param tkexamAnswShtId 	시험응시답안아이디
	* @param userId 			사용자아이디
	* @throws Exception
	*/
	@Override
	public void tkexamAnswShtScrModify(List<Map<String, Object>> list) throws Exception {
		for(Map<String, Object> map : list) {
			Object tkexamAnswShtId = map.get("tkexamAnswShtId");
			if(tkexamAnswShtId == null || "".equals(String.valueOf(tkexamAnswShtId).trim().toLowerCase())) {
				map.put("tkexamAnswShtId", IdGenUtil.genNewId(IdPrefixType.TKANS));
			}
		}
		tkexamAnswShtDAO.tkexamAnswShtScrModify(list);
	}

}
