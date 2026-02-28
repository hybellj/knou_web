package knou.lms.mut.service;

import java.util.List;

import knou.lms.mut.vo.MutEvalGradeVO;

public interface MutEvalGradeService {

    /*****************************************************
     * TODO 평가 등급 목록 조회
     * @param MutEvalGradeVO
     * @return List<MutEvalGradeVO>
     * @throws Exception
     ******************************************************/
    public List<MutEvalGradeVO> listMutEvalGrade(MutEvalGradeVO vo) throws Exception;
    
}
