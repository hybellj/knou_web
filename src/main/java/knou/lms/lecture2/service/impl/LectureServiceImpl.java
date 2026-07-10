package knou.lms.lecture2.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.lms.lecture2.dao.LectureDAO;
import knou.lms.lecture2.service.LectureService;
import knou.lms.lecture2.vo.LectureVO;

@Service("lectureService")
public class LectureServiceImpl implements LectureService {

	
	@Resource(name="lectureDAO")
    private LectureDAO lectureDAO;
	
	@Override
	public List<EgovMap> attandanceList(LectureVO lectureVO) {
		return lectureDAO.attandanceList(lectureVO);
	}

	@Override
	public List<EgovMap> byWknoStdntAttandanceList(LectureVO lectureVO) {
		return lectureDAO.byWknoStdntAttandanceList(lectureVO);
	}
}