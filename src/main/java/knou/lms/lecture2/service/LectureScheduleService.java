package knou.lms.lecture2.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.BaseParam;

public interface LectureScheduleService {
    public List<EgovMap> lectureScheduleList(BaseParam param) throws Exception;

    public EgovMap thisWeekLectureSelect(BaseParam param) throws Exception;

    public List<EgovMap> profLectureScheduleList(BaseParam param) throws Exception;

    public List<EgovMap> byWeeknoLectureSchdlList(BaseParam param) throws Exception;
}