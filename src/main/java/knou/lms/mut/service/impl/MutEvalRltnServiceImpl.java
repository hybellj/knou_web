package knou.lms.mut.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.mut.dao.MutEvalRltnDAO;
import knou.lms.mut.service.MutEvalRltnService;
import knou.lms.mut.vo.MutEvalRltnVO;

@Service("mutEvalRltnService")
public class MutEvalRltnServiceImpl extends ServiceBase implements MutEvalRltnService {
    
    @Resource(name="mutEvalRltnDAO")
    private MutEvalRltnDAO mutEvalRltnDAO;

    /*****************************************************
     * <p>
     * TODO 평가 연결 조회
     * </p>
     * 평가 연결 조회
     * 
     * @param MutEvalRltnVO
     * @return MutEvalRltnVO
     * @throws Exception
     ******************************************************/
    @Override
    public MutEvalRltnVO selectMutEvalRltn(MutEvalRltnVO vo) throws Exception {
        return mutEvalRltnDAO.selectMutEvalRltn(vo);
    }

    /*****************************************************
     * <p>
     * TODO 평가 연결 등록
     * </p>
     * 평가 연결 등록
     * 
     * @param MutEvalRltnVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insertMutEvalRltn(MutEvalRltnVO vo) throws Exception {
        mutEvalRltnDAO.insertMutEvalRltn(vo);
    }
    
}
