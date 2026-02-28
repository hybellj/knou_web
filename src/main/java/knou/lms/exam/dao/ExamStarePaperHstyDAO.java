package knou.lms.exam.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.exam.vo.ExamStarePaperHstyVO;
import knou.lms.exam.vo.ExamVO;

@Mapper("examStarePaperHstyDAO")
public interface ExamStarePaperHstyDAO {

    /*****************************************************
     * TODO 응시 시험지 이력 등록
     * @param ExamStarePaperHstyVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamStarePaperHsty(ExamStarePaperHstyVO vo) throws Exception;
    
    /*****************************************************
     * TODO 응시 시험지 이력 전체 삭제
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteAllPaperHsty(ExamVO vo) throws Exception;
    
    /*****************************************************
     * TODO 응시 시험지 답안 이력
     * @param ExamStarePaperHstyVO
     * @return List<ExamStarePaperHstyVO>
     * @throws Exception
     ******************************************************/
    public List<ExamStarePaperHstyVO> listPaperHstyLog(ExamStarePaperHstyVO vo) throws Exception;
    
}
