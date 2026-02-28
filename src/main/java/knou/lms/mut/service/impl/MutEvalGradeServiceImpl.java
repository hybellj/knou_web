package knou.lms.mut.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.mut.dao.MutEvalGradeDAO;
import knou.lms.mut.service.MutEvalGradeService;
import knou.lms.mut.vo.MutEvalGradeVO;

@Service("mutEvalGradeService")
public class MutEvalGradeServiceImpl extends ServiceBase implements MutEvalGradeService {
    
    @Resource(name="mutEvalGradeDAO")
    private MutEvalGradeDAO mutEvalGradeDAO;

    
    /*****************************************************
     * <p>
     * TODO 평가 등급 목록 조회
     * </p>
     * 평가 등급 목록 조회
     * 
     * @param MutEvalGradeVO
     * @return List<MutEvalGradeVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<MutEvalGradeVO> listMutEvalGrade(MutEvalGradeVO vo) throws Exception {
        return mutEvalGradeDAO.listMutEvalGrade(vo);
    }
    
}
