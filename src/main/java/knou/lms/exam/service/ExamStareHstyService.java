package knou.lms.exam.service;

import java.util.List;

import knou.lms.exam.vo.ExamStareHstyVO;

public interface ExamStareHstyService {

    /*****************************************************
     * TODO 시험 참여 이력 조회
     * @param ExamStareHstyVO
     * @return List<ExamStareHstyVO>
     * @throws Exception
     ******************************************************/
    public List<ExamStareHstyVO> listExamStareHsty(ExamStareHstyVO vo) throws Exception;
    
}
