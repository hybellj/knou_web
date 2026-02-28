package knou.lms.mut.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.mut.vo.MutEvalCmntVO;

@Mapper("mutEvalCmntDAO")
public interface MutEvalCmntDAO {

    /*****************************************************
     * TODO 평가 댓글 삭제
     * @param MutEvalCmntVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delMutEvalCmnt(MutEvalCmntVO vo) throws Exception;
    
}
