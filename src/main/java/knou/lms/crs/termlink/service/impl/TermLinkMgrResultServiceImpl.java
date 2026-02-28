package knou.lms.crs.termlink.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.termlink.dao.TermLinkMgrResultDAO;
import knou.lms.crs.termlink.service.TermLinkMgrResultService;
import knou.lms.crs.termlink.vo.TermLinkMgrResultVO;

@Service("termLinkMgrResultService")
public class TermLinkMgrResultServiceImpl extends ServiceBase implements TermLinkMgrResultService {
    
    @Resource(name="termLinkMgrResultDAO")
    private TermLinkMgrResultDAO termLinkMgrResultDAO;

    @Override
    public ProcessResultVO<TermLinkMgrResultVO> list(TermLinkMgrResultVO vo) throws Exception {
        ProcessResultVO<TermLinkMgrResultVO> resultList = new ProcessResultVO<TermLinkMgrResultVO>();
        List<TermLinkMgrResultVO> termLinkList = termLinkMgrResultDAO.list(vo);
        resultList.setReturnList(termLinkList);
        return resultList;
    }

    @Override
    public ProcessResultVO<TermLinkMgrResultVO> listPaging(TermLinkMgrResultVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<TermLinkMgrResultVO> termLinkList = termLinkMgrResultDAO.listPaging(vo);

        if(termLinkList.size() > 0) {
            paginationInfo.setTotalRecordCount(termLinkMgrResultDAO.count(vo));
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<TermLinkMgrResultVO> resultVO = new ProcessResultVO<TermLinkMgrResultVO>();

        resultVO.setReturnList(termLinkList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

}
