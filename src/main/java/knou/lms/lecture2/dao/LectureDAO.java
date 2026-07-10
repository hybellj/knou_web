package knou.lms.lecture2.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.lecture2.vo.LectureVO;

@Mapper("lectureDAO")
public interface LectureDAO {
	List<EgovMap> attandanceList(LectureVO lectureVO);

	List<EgovMap> byWknoStdntAttandanceList(LectureVO lectureVO);
}