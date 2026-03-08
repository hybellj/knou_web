package knou.lms.lecture2.dao;

import knou.lms.common.dto.BaseParam;
import knou.lms.lecture2.vo.LectureScheduleVO;
import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("lectureScheduleDAO")
public interface LectureScheduleDAO {

    public List<EgovMap> lectureScheduleList(BaseParam param) throws Exception;

    public EgovMap thisWeekLectureSelect(BaseParam param) throws Exception;

    public List<EgovMap> profLectureScheduleList(BaseParam param) throws Exception;

    public List<EgovMap> byWeeknoLectureSchdlList(BaseParam param) throws Exception;

    int wknoSchdlForPlandocModify(LectureScheduleVO vo) throws Exception;
}