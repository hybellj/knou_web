package knou.lms.common.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Service;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.lms.common.dao.OrgOrgInfoDAO;
import knou.lms.common.service.OrgOrgInfoService;
import knou.lms.common.vo.OrgOrgInfoVO;
import knou.lms.common.vo.ProcessResultVO;

@Service("orgOrgInfoService")
public class OrgOrgInfoServiceImpl extends ServiceBase implements OrgOrgInfoService {

    @Resource(name="orgOrgInfoDAO")
    private OrgOrgInfoDAO orgOrgInfoDAO;

    /**
     * 기관 정보의 상세 정보를 조회한다. 
     * @param  OrgOrgInfoVO 
     * @return OrgOrgInfoVO
     * @throws Exception
     */
    @Override
    public OrgOrgInfoVO select(OrgOrgInfoVO vo) throws Exception {
        return orgOrgInfoDAO.select(vo);
    }

    /**
     * 기관 정보의 전체 목록을 조회한다. 
     * @param  OrgOrgInfoVO 
     * @return List
     * @throws Exception
     */
    @Override
    public List<OrgOrgInfoVO> list(OrgOrgInfoVO vo) throws Exception {
        return orgOrgInfoDAO.list(vo);
    }

    /**
     * 기관 정보의 페이징 목록을 조회한다. 
     * @param  OrgOrgInfoVO 
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<OrgOrgInfoVO> listPaging(OrgOrgInfoVO vo) throws Exception {
        ProcessResultVO<OrgOrgInfoVO> processResultVO = new ProcessResultVO<>();
        
        try {
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getPageScale());
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            int totCnt = orgOrgInfoDAO.count(vo);
            
            paginationInfo.setTotalRecordCount(totCnt);
            
            List<OrgOrgInfoVO> resultList = orgOrgInfoDAO.listPaging(vo);
            
            processResultVO.setReturnList(resultList);
            processResultVO.setPageInfo(paginationInfo);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return processResultVO;
    }

}
