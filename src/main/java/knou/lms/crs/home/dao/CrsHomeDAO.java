package knou.lms.crs.home.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.DefaultVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonVO;
import knou.lms.std.vo.StdVO;

@Mapper("crsHomeDAO")
public interface CrsHomeDAO {
    
    /**
     * *************************************************** 
     * 평가기준 목록 수
     * @param vo
     * @return int
     * @throws Exception
     *****************************************************
     */
    public int countEvalCriteria(DefaultVO vo) throws Exception;
    
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
     * @return List<EgovMap>
     * @throws Exception
     *****************************************************
     */
    public List<EgovMap> listEvalCriteriaPaging(DefaultVO vo) throws Exception;
    
    /**
     * *************************************************** 
     * 평가기준 성적반영비율 대상
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     *****************************************************
     */
    public List<EgovMap> listEvalCriteriaScoreAppyY(DefaultVO vo) throws Exception;
    
    /**
     * *************************************************** 
     * 평가기준 성적반영비율 수정
     * @param vo
     * @return 
     * @throws Exception
     *****************************************************
     */
    public void updateEvalCriteriaScoreRatio(EgovMap vo) throws Exception;
    
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
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listCrsHomeAExam(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 홈 주차 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listCrsHomeQuiz(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 홈 주차 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listCrsHomeAsmnt(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 홈 주차 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listCrsHomeForum(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 홈 주차 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listCrsHomeResch(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 홈 주차 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listCrsHomeExam(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 홈 주차 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listCrsHomeSeminar(LessonVO vo) throws Exception;
    
    /*****************************************************
     * 강의실 홈 학생 참여현황
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
