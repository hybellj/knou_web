package knou.lms.crs.home.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonVO;
import knou.lms.std.vo.StdVO;

public interface CrsHomeService {
    
    /**
     * *************************************************** 
     * 평가기준 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     *****************************************************
     */
    public List<EgovMap> listEvalCriteria(DefaultVO vo) throws Exception;
    
    /**
     * *************************************************** 
     * 평가기준 목록 페이징
     * @param vo
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     *****************************************************
     */
    public ProcessResultVO<EgovMap> listEvalCriteriaPaging(DefaultVO vo) throws Exception;
    
    /**
     * *************************************************** 
     * 평가기준 성적반영비율 수정
     * @param vo
     * @return 
     * @throws Exception
     *****************************************************
     */
    public void updateEvalCriteriaScoreRatio(DefaultVO vo, List<String> keyList, List<Integer> scoreRatioList) throws Exception;
    
    /**
     * *************************************************** 
     * 강의실 홈 학습요소 참여현황
     * @param vo
     * @return EgovMap
     * @throws Exception
     *****************************************************
     */
    public EgovMap selectCrsHomeStdJoinStatus(StdVO vo) throws Exception;
    
    /**
     * *************************************************** 
     * 강의실 교수 홈 학습요소 상태
     * @param vo
     * @return EgovMap
     * @throws Exception
     *****************************************************
     */
    public EgovMap selectCrsHomeProfElementStatus(DefaultVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 홈 주차 목록
     * @param vo
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    public List<LessonScheduleVO> listCrsHomeLessonSchedule(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 홈 참여현황
     * @param vo
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap crsHomeScheduleListStatus(EgovMap map) throws Exception;
    
    /*****************************************************
     * 강의실 홈 현재 주차
     * @param vo
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap crsHomeCurrentWeek(LessonScheduleVO vo) throws Exception;
}