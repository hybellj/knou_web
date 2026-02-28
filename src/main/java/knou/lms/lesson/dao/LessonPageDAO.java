package knou.lms.lesson.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.lesson.vo.LessonPageVO;

@Mapper("lessonPageDAO")
public interface LessonPageDAO {
    
    /*****************************************************
     * 학습페이지 목록
     * @param LessonPageVO
     * @return 
     * @throws Exception
     ******************************************************/
    public List<LessonPageVO> list(LessonPageVO vo) throws Exception;
    
    /*****************************************************
     * 학습페이지 등록
     * @param LessonPageVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void insert(LessonPageVO vo) throws Exception;
    
    /*****************************************************
     * 학습페이지 수정
     * @param LessonPageVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void update(LessonPageVO vo) throws Exception;

    /*****************************************************
     * 학습페이지 삭제
     * @param LessonPageVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void delete(LessonPageVO vo) throws Exception;
    
    /*****************************************************
     * 페이지 학습기록 삭제
     * @param LessonPageVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void deleteLessonStudyPage(LessonPageVO vo) throws Exception;
    
    /*****************************************************
     * 페이지 목록(선수강과목 이관용)
     * @param LessonPageVO
     * @return List<LessonPageVO>
     * @throws Exception
     ******************************************************/
    public List<LessonPageVO> listLessonCntsForTrans(LessonPageVO vo) throws Exception;
    
    /*****************************************************
     * 페이지 목록 저장(선수강과목 이관용)
     * @param List<LessonPageVO>
     * @return 
     * @throws Exception
     ******************************************************/
    public void insertLessonPageListForTrans(List<LessonPageVO> lessonPageList) throws Exception;
    
    /**
     * 콘텐츠페이지정보 목록 저장
     * @param lessonPageList
     * @return void
     * @throws Exception
     */
    public void insertLessonPageList(List<LessonPageVO> lessonPageList) throws Exception;
}
