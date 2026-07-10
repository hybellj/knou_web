package knou.lms.lecture2.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.lecture2.vo.LectureVO;

public interface LectureService {

	List<EgovMap> attandanceList(LectureVO lectureVO);

	List<EgovMap> byWknoStdntAttandanceList(LectureVO lectureVO);
}