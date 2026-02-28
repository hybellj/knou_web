package knou.lms.mut.service;

import knou.lms.mut.vo.MutEvalCmntVO;

public interface MutEvalCmntService {

    /*****************************************************
     * TODO 평가 댓글 삭제
     * @param MutEvalCmntVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delMutEvalCmnt(MutEvalCmntVO vo) throws Exception;
    
}
