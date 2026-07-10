package knou.lms.mrk.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.mrk.vo.MarkItemSettingVO;

public interface MarkService {
	
	List<EgovMap> markActivityEvalRateSelect(MarkItemSettingVO vo);
}