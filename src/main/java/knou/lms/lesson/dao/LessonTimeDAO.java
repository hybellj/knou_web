package knou.lms.lesson.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.lesson.vo.LessonTimeVO;

@Mapper("lessonTimeDAO")
public interface LessonTimeDAO {

    /*****************************************************
     * 교시 조회
     * @param vo
     * @return LessonTimeVO
     * @throws Exception
     ******************************************************/
    public LessonTimeVO select(LessonTimeVO vo) throws Exception;
    
    /*****************************************************
     * 교시 등록
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void insert(LessonTimeVO vo) throws Exception;
    
    /*****************************************************
     * 교시 수정
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void update(LessonTimeVO vo) throws Exception;
    
    /*****************************************************
     * 교시 삭제
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void delete(LessonTimeVO vo) throws Exception;
    
    /*****************************************************
     * 교시 순서 최대값
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public int selectLessonTimeOrderMax(LessonTimeVO vo) throws Exception;
    
    /*****************************************************
     * 교시 목록 조회
     * @param vo
     * @return LessonTimeVO
     * @throws Exception
     ******************************************************/
    public List<LessonTimeVO> list(LessonTimeVO vo) throws Exception;
    
    /*****************************************************
     * 교시  복사
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void copyLessonTime(LessonTimeVO vo) throws Exception;
    
    /*****************************************************
     * 교시목록 저장(선수강과목 이관용)
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void insertLessonTimeListForTrans(List<LessonTimeVO> lessonTimeList) throws Exception;
}
