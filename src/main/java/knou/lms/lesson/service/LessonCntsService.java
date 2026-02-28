package knou.lms.lesson.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lesson.vo.LessonCntsVO;

public interface LessonCntsService {

    /*****************************************************
     * 학습 콘텐츠 정보
     * @param LessonCntsVO
     * @return LessonCntsVO
     * @throws Exception
     ******************************************************/
    public LessonCntsVO select(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습 콘텐츠 목록
     * @param LessonCntsVO
     * @return List<LessonCntsVO>
     * @throws Exception
     ******************************************************/
    public List<LessonCntsVO> list(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습 콘텐츠 등록
     * @param LessonCntsVO
     * @return 
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<LessonCntsVO> insert(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습 콘텐츠 수정
     * @param LessonCntsVO
     * @return 
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<LessonCntsVO> update(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습 콘텐츠 삭제
     * @param LessonCntsVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void delete(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습 콘텐츠 순서 최대값
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public int selectLessonCntsOrderMax(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습 콘텐츠 학습자 수
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public int countLessonCntsStudyRecord(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * TODO 강의실 접속 현황
     * @param LessonCntsVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> selectStdEnterStatusList(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 강의컨텐츠 페이지 저장
     * @param LessonCntsVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void saveLessonPage(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습 콘텐츠 복사
     * @param LessonCntsVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void copyLessonCnts(LessonCntsVO vo) throws Exception;
}
