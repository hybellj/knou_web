package knou.lms.lecture2.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.CommonDTO;

public interface LectureScheduleService {
    public List<EgovMap> lectureScheduleList(CommonDTO cmmnDto);

    public EgovMap thisWeekLectureSelect(CommonDTO cmmnDto);

    public List<EgovMap> profLectureScheduleList(CommonDTO cmmnDto);

    public List<EgovMap> byWeeknoLectureSchdlList(CommonDTO cmmnDto);
}