package knou.lms.bbs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.bbs.dao.BbsRltnDAO;
import knou.lms.bbs.service.BbsRltnService;
import knou.lms.bbs.vo.BbsRltnVO;

@Service("bbsRltnService")
public class BbsRltnServiceImpl extends ServiceBase implements BbsRltnService {
    
    private static final Logger LOGGER = LoggerFactory.getLogger(BbsRltnServiceImpl.class);
    
    @Resource(name = "bbsRltnDAO")
    private BbsRltnDAO bbsRltnDAO;
    
    /***************************************************** 
     * 게시판 정보 연결 목록
     * @param vo
     * @return List<BbsRltnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsRltnVO> listBbsRltn(BbsRltnVO vo) throws Exception {
        return bbsRltnDAO.listBbsRltn(vo);
    }

    /***************************************************** 
     * 게시판 정보 연결 등록
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void insertBbsRltn(BbsRltnVO vo) throws Exception {
        bbsRltnDAO.insertBbsRltn(vo);
    }

    /***************************************************** 
     * 게시판 정보 연결 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteBbsRltn(BbsRltnVO vo) throws Exception {
        bbsRltnDAO.deleteBbsRltn(vo);
    }

    /***************************************************** 
     * 게시판 정보 연결 전체 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteBbsRltnAll(BbsRltnVO vo) throws Exception {
        bbsRltnDAO.deleteBbsRltnAll(vo);
    }

}
