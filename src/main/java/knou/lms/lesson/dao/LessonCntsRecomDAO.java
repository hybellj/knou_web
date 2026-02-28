package knou.lms.lesson.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.lesson.vo.LessonCntsRecomVO;

@Mapper("lessonCntsRecomDAO")
public interface LessonCntsRecomDAO {
    
    /*****************************************************
     * 학습페이지 삭제
     * @param LessonCntsRecomVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void delete(LessonCntsRecomVO vo) throws Exception;
}
