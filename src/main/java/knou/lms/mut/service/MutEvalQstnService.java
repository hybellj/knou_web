package knou.lms.mut.service;

import java.util.List;

import knou.lms.mut.vo.MutEvalQstnVO;

public interface MutEvalQstnService {

    /*****************************************************
     * TODO 평가 문제 목록 조회
     * @param MutEvalQstnVO
     * @return List<MutEvalQstnVO>
     * @throws Exception
     ******************************************************/
    public List<MutEvalQstnVO> listMutEvalQstn(MutEvalQstnVO vo) throws Exception;
    
}
