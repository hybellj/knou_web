package knou.lms.lesson.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyPageVO;
import knou.lms.lesson.vo.LessonStudyRecordVO;
import knou.lms.lesson.vo.LessonStudyStateVO;

public interface LessonStudyService {

    /*****************************************************
     * 학습기록 목록 조회 (by 교시)
     * @param LessonStudyRecordVO
     * @return List<LessonStudyRecordVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyRecordVO> listLessonStudyRecordByTime(LessonStudyRecordVO vo) throws Exception;
    
    /*****************************************************
     * 학습기록 조회
     * @param LessonStudyRecordVO
     * @return LessonStudyRecordVO
     * @throws Exception
     ******************************************************/
    public LessonStudyRecordVO selectLessonStudyRecord(LessonStudyRecordVO vo) throws Exception;
    
    /*****************************************************
     * 학습상태 조회
     * @param LessonStudyStateVO
     * @return LessonStudyStateVO
     * @throws Exception
     ******************************************************/
    public LessonStudyStateVO selectLessonStudyState(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 페이지 학습 기록 목록 조회 (by scheduleId)
     * @param LessonStudyPageVO
     * @return List<LessonStudyPageVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyPageVO> listLessonStudyPageBySchedule(LessonStudyPageVO vo) throws Exception;
    
    /*****************************************************
     * 학습상태 저장
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertLessonStudyState(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 학습기록 기본값 저장 저장
     * @param List<LessonStudyRecordVO>
     * @return void
     * @throws Exception
     ******************************************************/
    public void saveLessonStudyRecordBasic(List<LessonStudyRecordVO> list) throws Exception;
    
    /*****************************************************
     * 학습기록 저장
     * @param LessonStudyRecordVO
     * @return void
     * @throws Exception
     ******************************************************/
    public String saveLessonStudyRecord(LessonStudyRecordVO vo) throws Exception;
    
    /*****************************************************
     * 학습기록 삭제
     * @param LessonStudyRecordVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteLessonStudyRecord(LessonStudyRecordVO vo) throws Exception;
    
    /*****************************************************
     *  페이지 학습기록 기본값 목록 저장
     * @param List<LessonStudyPageVO>
     * @return void
     * @throws Exception
     ******************************************************/
    public void saveLessonStudyPageBasicList(List<LessonStudyPageVO> list) throws Exception;
    
    /*****************************************************
     * 강제 출석 처리
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void saveForcedAttend(HttpServletRequest request, LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 강제 출석 처리  (일괄)
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void saveForcedAttendBatch(HttpServletRequest request, LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 강제 출석 처리 취소
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void cancelForcedAttend(HttpServletRequest request, LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 강제 출석 처리 취소  (일괄)
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void cancelForcedAttendBath(HttpServletRequest request, LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 수강생 강의 주차 학습상태 목록 조회(시간포함)
     * @param LessonStudyStateVO
     * @return List<LessonStudyStateVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyStateVO> listLessonStudyStateTm(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 출석처리 사유 수정
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateAttendReason(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 수강생별 학습기록 주차 목록 조회
     * @param LectureWeekNoSchedleVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listStdLessonRecord(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 법정교육 학습상태 변경
     * @param LessonCntsVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public void saveLegalStudyStatus(HttpServletRequest request, List<LessonStudyStateVO> list) throws Exception;
}
