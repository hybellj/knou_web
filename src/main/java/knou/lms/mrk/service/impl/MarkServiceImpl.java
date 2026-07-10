package knou.lms.mrk.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.lms.mrk.dao.MarkDAO;
import knou.lms.mrk.service.MarkService;
import knou.lms.mrk.vo.MarkItemSettingVO;

@Service("markService")
public class MarkServiceImpl implements MarkService{
	
	@Resource(name="markDAO")
    private MarkDAO markDAO;
	
	@Override
	public List<EgovMap> markActivityEvalRateSelect(MarkItemSettingVO vo) {		
		return markDAO.markActivityEvalRateSelect(vo);
	}
}