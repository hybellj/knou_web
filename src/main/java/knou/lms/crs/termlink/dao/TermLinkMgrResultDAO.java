package knou.lms.crs.termlink.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.crs.termlink.vo.TermLinkMgrResultVO;

@Mapper("termLinkMgrResultDAO")
public interface TermLinkMgrResultDAO {
    
    /**
     * 학사연동 로그 목록
     * @param TermLinkMgrResultVO
     * @return List<TermLinkMgrResultVO>
     * @throws Exception
     */
    public List<TermLinkMgrResultVO> list(TermLinkMgrResultVO vo) throws Exception;
    
    /**
     * 학사연동 로그 목록 페이징
     * @param TermLinkMgrResultVO
     * @return List<TermLinkMgrResultVO>
     * @throws Exception
     */
    public List<TermLinkMgrResultVO> listPaging(TermLinkMgrResultVO vo) throws Exception;
    
    /**
     * 학사연동 로그 목록 개수
     * @param TermLinkMgrResultVO
     * @return int
     * @throws Exception
     */
    public int count(TermLinkMgrResultVO vo) throws Exception;

}
