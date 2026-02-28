package knou.lms.mut.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.mut.vo.MutEvalRsltVO;

public interface MutEvalRsltService {

    /*****************************************************
     * TODO 평가 결과 목록 조회
     * @param MutEvalRsltVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listMutEvalRslt(MutEvalRsltVO vo) throws Exception;
    
    /*****************************************************
     * TODO 평가 결과 삭제
     * @param MutEvalRsltVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delMutEvalRslt(MutEvalRsltVO vo) throws Exception;
    
}
