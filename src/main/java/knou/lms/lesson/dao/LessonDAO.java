package knou.lms.lesson.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.lesson.vo.LessonPageVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonTimeVO;
import knou.lms.lesson.vo.LessonVO;
import knou.lms.subject.vo.SubjectVO;

@Mapper("lessonDAO")
public interface LessonDAO {
    
    /*****************************************************
     * 주차 전체 목록 조회
     * @param LectureWeekNoSchedleVO
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    public List<LessonScheduleVO> listLessonScheduleAll(LessonScheduleVO vo) throws Exception;
    
    /*****************************************************
     * 주차 교시 전체 목록 조회
     * @param LessonTimeVO
     * @return List<LessonTimeVO>
     * @throws Exception
     ******************************************************/
    public List<LessonTimeVO> listLessonTimeAll(LessonTimeVO vo) throws Exception;
    
    /*****************************************************
     * 주차 교시 목록 (by lessonScheduleId)
     * @param LessonTimeVO
     * @return List<LessonTimeVO>
     * @throws Exception
     ******************************************************/
    public List<LessonTimeVO> listLessonTimeByScheduleId(LessonTimeVO vo) throws Exception;
    
    /*****************************************************
     * 주차 콘텐츠 전체 목록 조회
     * @param LessonCntsVO
     * @return List<LessonCntsVO>
     * @throws Exception
     ******************************************************/
    public List<LessonCntsVO> listLessonCntsAll(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 주차 교시 정보 조회
     * @param LessonTimeVO
     * @return LessonTimeVO
     * @throws Exception
     ******************************************************/
    public LessonTimeVO selectLessonTime(LessonTimeVO vo) throws Exception;
    
    /*****************************************************
     * 주차, 교시의 콘텐츠 목록 조회
     * @param LessonCntsVO
     * @return List<LessonCntsVO>
     * @throws Exception
     ******************************************************/
    public List<LessonCntsVO> listLessonCntsByLessonTime(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 주차 콘텐츠 페이지 목록 조회
     * @param LessonPageVO
     * @return List<LessonPageVO>
     * @throws Exception
     ******************************************************/
    public List<LessonPageVO> listLessonPageBySchedule(LessonPageVO vo) throws Exception;
    
    /*****************************************************
     * 학습여부 목록 조회
     * @param LessonCntsVO
     * @return List<LessonCntsVO>
     * @throws Exception
     ******************************************************/
    public List<LessonCntsVO> listLessonCntsViewYn(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습 콘텐츠 정보 조회
     * @param LessonCntsVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectLessonCnts(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습진도관리 현황 목록 조회
     * @param LessonVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listLessonProgress(SubjectVO vo) throws Exception;
    public List<LessonVO> listLessonProgressExcel(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 학습진도관리 수강생, 평균 진도율 조회
     * @param LessonVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public EgovMap selectLessonProgress(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 학습진도관리 전체현황
     * @param LessonVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public EgovMap selectLessonProgressTotalStatus(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 학습진도관리 목록 (배치)
     * @param LessonVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listLessonProgressStatusBatch(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 학습진도관리 목록 주차별 (배치)
     * @param LessonVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listLessonProgressStatusWeekBatch(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 콘텐츠 현황 목록
     * @param LessonVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listCntsUsage(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 콘텐츠 현황 목록 수
     * @param LessonVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int countCntsUsage(LessonVO vo) throws Exception;
}
