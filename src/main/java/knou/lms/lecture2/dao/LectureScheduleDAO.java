package knou.lms.lecture2.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.CommonDTO;
import knou.lms.lecture2.vo.LectureScheduleVO;

@Mapper("lectureScheduleDAO")
public interface LectureScheduleDAO {

    public List<EgovMap> lectureScheduleList(CommonDTO cmmnDto);

    public EgovMap thisWeekLectureSelect(CommonDTO cmmnDto);

    public List<EgovMap> profLectureScheduleList(CommonDTO cmmnDto);

    public List<EgovMap> byWeeknoLectureSchdlList(CommonDTO cmmnDto);

    int wknoSchdlForPlandocModify(LectureScheduleVO vo) throws Exception;
}