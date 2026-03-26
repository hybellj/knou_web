package knou.lms.lesson.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.lesson.vo.LessonPageVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonTimeVO;
import knou.lms.lesson.vo.LessonVO;
import knou.lms.subject.vo.SubjectVO;

public interface LessonService {

    /**
     * 강의주차 전체 목록 조회 (세부 콘텐츠 포함)
     * @param vo
     * @return
     * @throws Exception
     */
    public List<LessonScheduleVO> listLessonScheduleAll(LessonScheduleVO vo) throws Exception;

    /*****************************************************
     * 주차 교시 정보 조회
     * @param LessonTimeVO
     * @return List<LessonTimeVO>
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
     * 주차 교시 목록 (by lessonScheduleId)
     * @param LessonTimeVO
     * @return List<LessonTimeVO>
     * @throws Exception
     ******************************************************/
    public List<LessonTimeVO> listLessonTimeByScheduleId(LessonTimeVO vo) throws Exception;
    
    /*****************************************************
     * 학습진도관리 현황 목록 조회
     * @param LessonVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listLessonProgress(SubjectVO vo) throws Exception;
    public List<LessonVO> listLessonProgressExcel(LessonVO vo) throws Exception;
    
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
     * 콘텐츠 현황 목록
     * @param LessonVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> listCntsUsage(LessonVO vo) throws Exception;
    public List<EgovMap> listCntsUsageExc(LessonVO vo) throws Exception;
}