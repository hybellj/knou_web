package knou.lms.lecture2.dao;

import knou.lms.lecture2.vo.LectureScheduleVO;
import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("lectureScheduleDAO")
public interface LectureScheduleDAO {

    public List<EgovMap> lectureScheduleList(String subjectId) throws Exception;

    public EgovMap thisWeekLectureSelect(String subjectId) throws Exception;

    public List<EgovMap> profLectureScheduleList(@Param("subjectId") String subjectId) throws Exception;

    public List<EgovMap> byWeeknoLectureSchdlList(@Param("subjectId") String subjectId) throws Exception;

    int wknoSchdlForPlandocModify(LectureScheduleVO vo) throws Exception;
}