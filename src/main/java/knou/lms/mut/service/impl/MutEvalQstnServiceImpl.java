package knou.lms.mut.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.mut.dao.MutEvalQstnDAO;
import knou.lms.mut.service.MutEvalQstnService;
import knou.lms.mut.vo.MutEvalQstnVO;

@Service("mutEvalQstnService")
public class MutEvalQstnServiceImpl extends ServiceBase implements MutEvalQstnService {
    
    @Resource(name="mutEvalQstnDAO")
    private MutEvalQstnDAO mutEvalQstnDAO;

    /*****************************************************
     * <p>
     * TODO 평가 문제 목록 조회
     * </p>
     * 평가 문제 목록 조회
     * 
     * @param MutEvalQstnVO
     * @return List<MutEvalQstnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<MutEvalQstnVO> listMutEvalQstn(MutEvalQstnVO vo) throws Exception {
        return mutEvalQstnDAO.listMutEvalQstn(vo);
    }
    
}
