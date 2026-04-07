package knou.lms.log.lesson.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.log.lesson.vo.LogLessonActnHstyVO;

@Mapper("logLessonActnHstyDAO")
public interface LogLessonActnHstyDAO {

    /*****************************************************
     * 강의실 활동 로그 목록
     * @param LogLessonActnHstyVO
     * @return List<LogLessonActnHstyVO>
     * @throws Exception
     ******************************************************/
    public List<LogLessonActnHstyVO> listLessonActnHsty(LogLessonActnHstyVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 활동 로그 목록 페이징
     * @param LogLessonActnHstyVO
     * @return List<LogLessonActnHstyVO>
     * @throws Exception
     ******************************************************/
    public List<LogLessonActnHstyVO> listLessonActnHstyPaging(LogLessonActnHstyVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 활동 로그 등록
     * @param LogLessonActnHstyVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void insertLessonActnHsty(LogLessonActnHstyVO vo) throws Exception;

}
