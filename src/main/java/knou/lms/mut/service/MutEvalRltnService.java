package knou.lms.mut.service;

import knou.lms.mut.vo.MutEvalRltnVO;

public interface MutEvalRltnService {

    /*****************************************************
     * TODO 평가 연결 조회
     * @param MutEvalRltnVO
     * @return MutEvalRltnVO
     * @throws Exception
     ******************************************************/
    public MutEvalRltnVO selectMutEvalRltn(MutEvalRltnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 평가 연결 등록
     * @param MutEvalRltnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertMutEvalRltn(MutEvalRltnVO vo) throws Exception;
    
}
