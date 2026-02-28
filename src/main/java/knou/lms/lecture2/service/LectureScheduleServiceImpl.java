package knou.lms.lecture2.service;

import knou.lms.lecture2.dao.LectureScheduleDAO;
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
    public List<EgovMap> lectureScheduleList(String subjectId) throws Exception {
        return lectureScheduleDAO.lectureScheduleList(subjectId);
    }

    /*****************************************************
     * 금주강의조회, 이번주강의조회
     * @param    subjectId
     * @return    EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap thisWeekLectureSelect(String subjectId) throws Exception {
        return lectureScheduleDAO.thisWeekLectureSelect(subjectId);
    }

    /*****************************************************
     * 교수강의일정목록조회, 교수강의주차일정목록조회
     * @param    subjectId
     * @return    List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> profLectureScheduleList(String subjectId) throws Exception {
        return lectureScheduleDAO.profLectureScheduleList(subjectId);
    }

    /*****************************************************
     * 주차별강의일정목록조회, 교수강의주차일정목록조회
     * @param    subjectId
     * @return    List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> byWeeknoLectureSchdlList(String subjectId) throws Exception {
        return lectureScheduleDAO.byWeeknoLectureSchdlList(subjectId);
    }
}
