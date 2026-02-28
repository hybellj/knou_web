package knou.lms.log.lesson.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log.lesson.vo.LogLessonActnHstyVO;

public interface LogLessonActnHstyService {
    
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
     * @return ProcessResultVO<LogLessonActnHstyVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<LogLessonActnHstyVO> listLessonActnHstyPaging(LogLessonActnHstyVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 활동 로그 등록
     * @param crsCreCd
     * @param userId
     * @param actnHstyCd
     * @param actnHstyCts
     * @return 
     * @throws Exception
     ******************************************************/
    public void saveLessonActnHsty(HttpServletRequest request, String crsCreCd, String actnHstyCd, String actnHstyCts) throws Exception;

    /*****************************************************
     * 강의실 활동 로그 등록 (학습창용)
     * @param crsCreCd
     * @param userId
     * @param actnHstyCd
     * @param actnHstyCts
     * @return 
     * @throws Exception
     ******************************************************/
    public void saveLessonActnHstyForStudy(HttpServletRequest request, String crsCreCd, String actnHstyCd, String actnHstyCts) throws Exception;
}
