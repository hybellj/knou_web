package knou.lms.lesson.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyDetailVO;
import knou.lms.lesson.vo.LessonStudyPageVO;
import knou.lms.lesson.vo.LessonStudyRecordVO;
import knou.lms.lesson.vo.LessonStudyStateVO;

@Mapper("lessonStudyDAO")
public interface LessonStudyDAO {

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
     * 학습기록 기본값 저장
     * @param List<LessonStudyRecordVO>
     * @throws Exception
     ******************************************************/
    public void insertLessonStudyRecordBasic(List<LessonStudyRecordVO> list) throws Exception;
    
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
     * 학습상태 기본값 저장
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertLessonStudyState(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 학습기록 저장
     * @param LessonStudyRecordVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void saveLessonStudyRecord(LessonStudyRecordVO vo) throws Exception;
    
    /*****************************************************
     * 주차 학습상태 저장
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void saveLessonStudyState(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     *  페이지 학습기록 저장
     * @param LessonStudyPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void saveLessonStudyPage(LessonStudyPageVO vo) throws Exception;
    
    /*****************************************************
     *  페이지 학습기록 기본값 목록 저장
     * @param List<LessonStudyPageVO>
     * @return void
     * @throws Exception
     ******************************************************/
    public void saveLessonStudyPageBasicList(List<LessonStudyPageVO> list) throws Exception;
    
    /*****************************************************
     * 학습기록 상세 저장
     * @param LessonStudyDetailVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertLessonStudyDetail(LessonStudyDetailVO vo) throws Exception;
    
    /*****************************************************
     * 수강생 학습기록 삭제
     * @param LessonStudyRecordVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteLessonStudyRecord(LessonStudyRecordVO vo) throws Exception;
    
    /*****************************************************
     * 수강생 학습기록 상세 삭제
     * @param LessonStudyDetailVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteLessonStudyDetail(LessonStudyDetailVO vo) throws Exception;
    
    /*****************************************************
     * 수강생 페이지 학습기록 삭제
     * @param LessonStudyPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteLessonStudyPage(LessonStudyPageVO vo) throws Exception;
    
    /*****************************************************
     * 강제 출석 처리 저장
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertForcedAttend(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 출석 사유 수정
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateAttendReason(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 강제 출석 처리 수정
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateForcedAttend(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 강제 출석 처리 취소
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void cancelForcedAttend(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 법정교육 강제 이수,미이수 처리
     * @param List<LessonStudyStateVO>
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateForcedAttendLegal(List<LessonStudyStateVO> list) throws Exception;
    
    /*****************************************************
     * 수강생 강의 주차 학습상태 목록 조회(시간포함)
     * @param LessonStudyStateVO
     * @return List<LessonStudyStateVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyStateVO> listLessonStudyStateTm(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 수강생 강의 주차 학습상태 조회(시간포함)
     * @param LessonStudyStateVO
     * @return LessonStudyStateVO
     * @throws Exception
     ***************************************************listLessonStudyDetail***/
    public LessonStudyStateVO selectLessonStudyStateTm(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 수강생 강의 주차 학습상태 조회(세미나)
     * @param LessonStudyStateVO
     * @return LessonStudyStateVO
     * @throws Exception
     ******************************************************/
    public LessonStudyStateVO selectLessonStudySeminar(LessonStudyStateVO vo) throws Exception;

    /*****************************************************
     * 수강생 주차 학습기록
     * @param LessonCntsVO
     * @return List<LessonStudyRecordVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyRecordVO> listLessonStudyRecord(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 수강생 주차 학습기록 상세
     * @param LessonCntsVO
     * @return List<LessonStudyDetailVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyDetailVO> listLessonStudyDetail(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 수강생 페이지 학습 기록
     * @param LessonCntsVO
     * @return List<LessonStudyPageVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyPageVO> listLessonStudyPage(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습주차 조회(학습기록 참조용)
     * @param LectureWeekNoSchedleVO
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    public LessonScheduleVO selectLessonSchedule(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 주차의 현재콘텐츠 제외 학습기록 조회
     * @param LectureWeekNoSchedleVO
     * @return LessonScheduleVO
     * @throws Exception
     ******************************************************/
    public LessonScheduleVO selectOtherCntsStudyTm(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 수강생별 학습기록 주차 목록 조회
     * @param LectureWeekNoSchedleVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listStdLessonRecord(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 강의실별 수강생 학습기록 목록 조회
     * @param LessonStudyRecordVO
     * @return List<LessonStudyRecordVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyRecordVO> listStdRecordByCrs(LessonStudyRecordVO vo) throws Exception;
    
    /*****************************************************
     * 학습기록 목록 조회(선수강과목 이관용)
     * @param LessonStudyRecordVO
     * @return List<LessonStudyRecordVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyRecordVO> listStdRecordForTrans(LessonStudyRecordVO vo) throws Exception;
    
    /*****************************************************
     * 학습기록 목록 저장(선수강과목 이관용)
     * @param List<LessonStudyRecordVO>
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertStdRecordListForTrans(List<LessonStudyRecordVO> studyRecordList) throws Exception;
    
    /*****************************************************
     * 학습상태 목록 조회(선수강과목 이관용)
     * @param LessonStudyStateVO
     * @return List<LessonStudyStateVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyStateVO> listStdStateForTrans(LessonStudyStateVO vo) throws Exception;
    
    /*****************************************************
     * 학습상태 목록 저장(선수강과목 이관용)
     * @param List<LessonStudyStateVO>
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertStdStateListForTrans(List<LessonStudyStateVO> studyStateList) throws Exception;
    
    /*****************************************************
     * 페이지 학습 기록 목록 조회(선수강과목 이관용)
     * @param LessonStudyPageVO
     * @return List<LessonStudyPageVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyPageVO> listLessonStudyPageForTrans(LessonStudyPageVO vo) throws Exception;
    
    /*****************************************************
     * 페이지 학습 기록 목록 저장(선수강과목 이관용)
     * @param List<LessonStudyPageVO>
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertLessonStudyPageListForTrans(List<LessonStudyPageVO> studyPageList) throws Exception;

}
