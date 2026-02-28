package knou.lms.crs.termlink.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.crs.termlink.vo.TermLinkMgrVO;

@Mapper("termLinkMgrDAO")
public interface TermLinkMgrDAO {

    /**
     * 학사연동 관리 조회
     * @param TermLinkMgrVO
     * @return TermLinkMgrVO
     * @throws Exception
     */
    public TermLinkMgrVO select(TermLinkMgrVO vo) throws Exception;
    
    /**
     * 학사연동 관리 수정
     * @param TermLinkMgrVO
     * @return void
     * @throws Exception
     */
    public void update(TermLinkMgrVO vo) throws Exception;
    
}
