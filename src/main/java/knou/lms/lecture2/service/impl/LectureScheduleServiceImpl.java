package knou.lms.lecture2.service.impl;

import knou.lms.common.dto.BaseParam;
import knou.lms.lecture2.dao.LectureScheduleDAO;
import knou.lms.lecture2.service.LectureScheduleService;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service("lectureScheduleService")
public class LectureScheduleServiceImpl implements LectureScheduleService {

    @Autowired
    private LectureScheduleDAO lectureScheduleDAO;


    /*****************************************************
     * 강의일정목록조회, 강의주차일정목록조회
     * @param    subjectId
     * @return    List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> lectureScheduleList(BaseParam param) throws Exception {
        return lectureScheduleDAO.lectureScheduleList(param);
    }

    /*****************************************************
     * 금주강의조회, 이번주강의조회
     * @param    subjectId
     * @return    EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap thisWeekLectureSelect(BaseParam param) throws Exception {
        return lectureScheduleDAO.thisWeekLectureSelect(param);
    }

    /*****************************************************
     * 교수강의일정목록조회, 교수강의주차일정목록조회
     * @param    subjectId
     * @return    List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> profLectureScheduleList(BaseParam param) throws Exception {
        return lectureScheduleDAO.profLectureScheduleList(param);
    }

    /*****************************************************
     * 주차별강의일정목록조회, 교수강의주차일정목록조회
     * @param    subjectId
     * @return    List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> byWeeknoLectureSchdlList(BaseParam param) throws Exception {
        return lectureScheduleDAO.byWeeknoLectureSchdlList(param);
    }
}
