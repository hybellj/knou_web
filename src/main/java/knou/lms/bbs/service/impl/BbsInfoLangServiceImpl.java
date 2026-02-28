package knou.lms.bbs.service.impl;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.bbs.dao.BbsInfoLangDAO;
import knou.lms.bbs.service.BbsInfoLangService;
import knou.lms.bbs.vo.BbsInfoLangVO;

@Service("bbsInfoLangService")
public class BbsInfoLangServiceImpl extends ServiceBase implements BbsInfoLangService {

    private static final Logger LOGGER = LoggerFactory.getLogger(BbsInfoLangServiceImpl.class);
    
    @Resource(name = "bbsInfoLangDAO")
    private BbsInfoLangDAO bbsInfoLangDAO;

    /***************************************************** 
     * 게시판 언어 정보
     * @param vo
     * @return BbsInfoLangVO
     * @throws Exception
     ******************************************************/
    @Override
    public BbsInfoLangVO selectBbsInfoLang(BbsInfoLangVO vo) throws Exception {
        return bbsInfoLangDAO.selectBbsInfoLang(vo);
    }
    
}
