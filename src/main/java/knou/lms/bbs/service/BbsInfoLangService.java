package knou.lms.bbs.service;

import knou.lms.bbs.vo.BbsInfoLangVO;

public interface BbsInfoLangService {
    
    /***************************************************** 
     * 게시판 언어 정보
     * @param vo
     * @return BbsInfoLangVO
     * @throws Exception
     ******************************************************/
    public BbsInfoLangVO selectBbsInfoLang(BbsInfoLangVO vo) throws Exception;
    
}
