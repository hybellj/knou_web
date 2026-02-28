package knou.lms.mut.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.mut.vo.MutEvalRltnVO;

@Mapper("mutEvalRltnDAO")
public interface MutEvalRltnDAO {

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
    
    /*****************************************************
     * TODO 평가 연결 삭제
     * @param MutEvalRltnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delMutEvalRltn(MutEvalRltnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 평가 연결 삭제
     * @param MutEvalRltnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delMutEvalRltnByRltnCd(MutEvalRltnVO vo) throws Exception;
}
