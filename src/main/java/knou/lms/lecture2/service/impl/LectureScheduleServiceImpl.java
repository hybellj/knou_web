package knou.lms.lecture2.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import knou.lms.common.dto.CommonDTO;
import knou.lms.lecture2.dao.LectureScheduleDAO;
import knou.lms.lecture2.service.LectureScheduleService;


@Service("lectureScheduleService")
public class LectureScheduleServiceImpl implements LectureScheduleService {

    @Autowired
    private LectureScheduleDAO lectureScheduleDAO;


    /*****************************************************
     * 강의일정목록조회, 강의주차일정목록조회
     * @param    sbjctId
     * @return    List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> lectureScheduleList(CommonDTO cmmnDto){
        return lectureScheduleDAO.lectureScheduleList(cmmnDto);
    }

    /*****************************************************
     * 금주강의조회, 이번주강의조회
     * @param    sbjctId
     * @return    EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap thisWeekLectureSelect(CommonDTO cmmnDto){
        return lectureScheduleDAO.thisWeekLectureSelect(cmmnDto);
    }

    /*****************************************************
     * 교수강의일정목록조회, 교수강의주차일정목록조회
     * @param    sbjctId
     * @return    List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> profLectureScheduleList(CommonDTO cmmnDto){
        return lectureScheduleDAO.profLectureScheduleList(cmmnDto);
    }

    /*****************************************************
     * 주차별강의일정목록조회, 교수강의주차일정목록조회
     * @param    sbjctId
     * @return    List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> byWeeknoLectureSchdlList(CommonDTO cmmnDto) {
        return lectureScheduleDAO.byWeeknoLectureSchdlList(cmmnDto);
    }
}
