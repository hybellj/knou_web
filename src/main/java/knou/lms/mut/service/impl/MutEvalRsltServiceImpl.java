package knou.lms.mut.service.impl;


import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.ServiceBase;
import knou.lms.mut.dao.MutEvalRsltDAO;
import knou.lms.mut.service.MutEvalRsltService;
import knou.lms.mut.vo.MutEvalRsltVO;

@Service("mutEvalRsltService")
public class MutEvalRsltServiceImpl extends ServiceBase implements MutEvalRsltService {
    
    @Resource(name="mutEvalRsltDAO")
    private MutEvalRsltDAO mutEvalRsltDAO;

    /*****************************************************
     * <p>
     * TODO 평가 결과 목록 조회
     * </p>
     * 평가 결과 목록 조회
     * 
     * @param MutEvalRsltVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listMutEvalRslt(MutEvalRsltVO vo) throws Exception {
        return mutEvalRsltDAO.listMutEvalRslt(vo);
    }

    /*****************************************************
     * <p>
     * TODO 평가 결과 삭제
     * </p>
     * 평가 결과 삭제
     * 
     * @param MutEvalRsltVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void delMutEvalRslt(MutEvalRsltVO vo) throws Exception {
        mutEvalRsltDAO.delMutEvalRslt(vo);
    }

}
