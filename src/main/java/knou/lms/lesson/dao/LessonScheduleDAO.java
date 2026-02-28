package knou.lms.lesson.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.lesson.vo.LessonScheduleVO;

@Mapper("lessonScheduleDAO")
public interface LessonScheduleDAO {
    
    /*****************************************************
     * 강의실 학습주차 조회
     * @param LectureWeekNoSchedleVO
     * @return LessonScheduleVO
     * @throws Exception
     ******************************************************/
    public LessonScheduleVO select(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 학습주차 조회
     * @param LectureWeekNoSchedleVO
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    public List<LessonScheduleVO> list(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 학습주차 저장
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
    public void updateDelN(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 주차 학습시간 수정 
     * @param LectureWeekNoSchedleVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void updateLbnTm(LessonScheduleVO vo) throws Exception;

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
     * 강의구분별 주차 목록 조회
     * @param LectureWeekNoSchedleVO
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    public List<LessonScheduleVO> listLessonScheduleByGbn(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 주차 학습콘텐츠 수 조회
     * @param LectureWeekNoSchedleVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int countLessonScheduleCnts(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 주차 목록 조회(선수강과목 이관용)
     * @param LectureWeekNoSchedleVO
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    public List<LessonScheduleVO> listLessonScheduleForTrans(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 주차 목록 저장(선수강과목 이관용)
     * @param List<LessonScheduleVO>
     * @return 
     * @throws Exception
     ******************************************************/
    public void insertLessonScheduleListForTrans(List<LessonScheduleVO> scheduleList) throws Exception;
    
    /*****************************************************
     * 분반 주차 조회
     * @param LectureWeekNoSchedleVO
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    public List<LessonScheduleVO> listDeclsLessonSchedule(LessonScheduleVO vo) throws Exception;
}
