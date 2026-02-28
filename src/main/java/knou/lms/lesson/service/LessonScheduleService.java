package knou.lms.lesson.service;

import java.util.List;

import knou.lms.lesson.vo.LessonScheduleVO;

public interface LessonScheduleService {
    
    /*****************************************************
     * 강의실 학습주차 조회
     * @param LectureWeekNoSchedleVO
     * @return LessonScheduleVO
     * @throws Exception
     ******************************************************/
    public LessonScheduleVO select(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 학습주차 목록 조회
     * @param LectureWeekNoSchedleVO
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    public List<LessonScheduleVO> list(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 학습주차 등록
     * @param LectureWeekNoSchedleVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void insert(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 학습주차 수정
     * @param LectureWeekNoSchedleVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void update(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 학습주차 삭제
     * @param LectureWeekNoSchedleVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void delete(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 주차, 교시, 강의컨텐츠 조회
     * @param LectureWeekNoSchedleVO
     * @return LessonScheduleVO
     * @throws Exception
     ******************************************************/
    public LessonScheduleVO selectLessonScheduleAll(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 주차, 교시, 강의컨텐츠 목록 조회
     * @param LectureWeekNoSchedleVO
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    public List<LessonScheduleVO> listLessonScheduleAll(LessonScheduleVO vo) throws Exception;

    /*****************************************************
     * 주차, 교시, 강의컨텐츠, (학습시간) 조회 (학생)
     * @param LectureWeekNoSchedleVO
     * @return LessonScheduleVO
     * @throws Exception
     ******************************************************/
    public LessonScheduleVO selectLessonScheduleAllStd(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 강의구분별 주차 목록 조회
     * @param LectureWeekNoSchedleVO
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    public List<LessonScheduleVO> listLessonScheduleByGbn(LessonScheduleVO vo) throws Exception;
}
