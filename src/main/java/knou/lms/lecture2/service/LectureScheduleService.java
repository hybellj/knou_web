package knou.lms.lecture2.service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface LectureScheduleService {
    public List<EgovMap> lectureScheduleList(String subjectId) throws Exception;

    public EgovMap thisWeekLectureSelect(String subjectId) throws Exception;

    public List<EgovMap> profLectureScheduleList(String subjectId) throws Exception;

    public List<EgovMap> byWeeknoLectureSchdlList(String subjectId) throws Exception;
}