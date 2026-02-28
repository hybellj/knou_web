package knou.lms.common.service;

import java.util.List;

import knou.lms.common.vo.OrgOrgInfoVO;
import knou.lms.common.vo.ProcessResultVO;

public interface OrgOrgInfoService {

    /**
     * 기관 정보의 상세 정보를 조회한다. 
     * @param  OrgOrgInfoVO 
     * @return OrgOrgInfoVO
     * @throws Exception
     */
    public OrgOrgInfoVO select(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 정보의 전체 목록을 조회한다. 
     * @param  OrgOrgInfoVO 
     * @return List
     * @throws Exception
     */
    public List<OrgOrgInfoVO> list(OrgOrgInfoVO vo) throws Exception;
    
    /**
     * 기관 정보의 페이징 목록을 조회한다. 
     * @param  OrgOrgInfoVO 
     * @return ProcessResultVO
     * @throws Exception
     */
    public ProcessResultVO<OrgOrgInfoVO> listPaging(OrgOrgInfoVO vo) throws Exception ;
    
}
