package knou.lms.mut.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.mut.dao.MutEvalCmntDAO;
import knou.lms.mut.service.MutEvalCmntService;
import knou.lms.mut.vo.MutEvalCmntVO;

@Service("mutEvalCmntService")
public class MutEvalCmntServiceImpl extends ServiceBase implements MutEvalCmntService {
    
    @Resource(name="mutEvalCmntDAO")
    private MutEvalCmntDAO mutEvalCmntDAO;

    /*****************************************************
     * <p>
     * TODO 평가 댓글 삭제
     * </p>
     * 평가 댓글 삭제
     * 
     * @param MutEvalCmntVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void delMutEvalCmnt(MutEvalCmntVO vo) throws Exception {
        mutEvalCmntDAO.delMutEvalCmnt(vo);
    }
    
    

}
