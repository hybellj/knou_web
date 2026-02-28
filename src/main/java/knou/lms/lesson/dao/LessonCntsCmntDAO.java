package knou.lms.lesson.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.lesson.vo.LessonCntsCmntVO;

@Mapper("lessonCntsCmntDAO")
public interface LessonCntsCmntDAO {

    /*****************************************************
     * 학습콘텐츠 댓글 삭제
     * @param LessonCntsCmntVO
     * @return 
     * @throws Exception
     ******************************************************/
    public void delete(LessonCntsCmntVO vo) throws Exception;
}
