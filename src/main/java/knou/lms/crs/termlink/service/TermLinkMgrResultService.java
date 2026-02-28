package knou.lms.crs.termlink.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.termlink.vo.TermLinkMgrResultVO;

public interface TermLinkMgrResultService {

    /**
     * 학사연동 로그 목록
     * @param TermLinkMgrResultVO
     * @return ProcessResultVO<TermLinkMgrResultVO>
     * @throws Exception
     */
    public ProcessResultVO<TermLinkMgrResultVO> list(TermLinkMgrResultVO vo) throws Exception;
    
    /**
     * 학사연동 로그 목록 페이징
     * @param TermLinkMgrResultVO
     * @return ProcessResultVO<TermLinkMgrResultVO>
     * @throws Exception
     */
    public ProcessResultVO<TermLinkMgrResultVO> listPaging(TermLinkMgrResultVO vo) throws Exception;
    
}
