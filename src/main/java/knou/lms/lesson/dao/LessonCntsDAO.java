package knou.lms.lesson.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.lesson.vo.LessonCntsVO;

@Mapper("lessonCntsDAO")
public interface LessonCntsDAO {

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
    public void insert(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습 콘텐츠 수정
     * @param LessonCntsVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void update(LessonCntsVO vo) throws Exception;
    
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
     * 순차 학습 정렬순서 수정
     * @param LessonCntsVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public void updateSeqLessonCntsOrder(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습 콘텐츠명 수정
     * @param LessonCntsVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void updateCntsNm(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
     * 학습 콘텐츠 복사
     * @param LessonCntsVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void copyLessonCnts(LessonCntsVO vo) throws Exception;
    
    /*****************************************************
    * 콘텐츠정보 목록 저장(선수강과목 이관용)
    * @param List<LessonCntsVO>
    * @return 
    * @throws Exception
    ******************************************************/
   public void insertLessonCntsListForTrans(List<LessonCntsVO> lessonCntsList) throws Exception;
    
}
