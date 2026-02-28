package knou.lms.crs.termlink.service;

import knou.lms.crs.termlink.vo.TermLinkVO;

public interface TermLinkService {

    /*****************************************************
     * TODO 학사 연동 처리 서비스
     * @param TermLinkVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void runLink(TermLinkVO vo) throws Exception;
    
}
