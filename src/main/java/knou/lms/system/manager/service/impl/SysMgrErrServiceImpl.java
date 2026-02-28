package knou.lms.system.manager.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.system.manager.dao.SysMgrErrDAO;
import knou.lms.system.manager.service.SysMgrErrService;
import knou.lms.system.manager.vo.SysMgrErrVO;

@Service("sysMgrErrService")
public class SysMgrErrServiceImpl extends ServiceBase implements SysMgrErrService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SysMgrErrServiceImpl.class);

    @Resource(name="sysMgrErrDAO")
    private SysMgrErrDAO sysMgrErrDAO;

    /*****************************************************
     * 시스템 오류현황 목록 페이징
     * @param vo
     * @return ProcessResultVO<SysMgrErrVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<SysMgrErrVO> listSysErrPaging(SysMgrErrVO vo) throws Exception {
        ProcessResultVO<SysMgrErrVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = sysMgrErrDAO.countSysErr(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<SysMgrErrVO> resultList = sysMgrErrDAO.listSysErrPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 시스템 오류현황 목록 조회
     * @param vo
     * @return SysMgrErrVO
     * @throws Exception
     ******************************************************/
    @Override
    public List<SysMgrErrVO> listSysErr(SysMgrErrVO vo) throws Exception {
        return sysMgrErrDAO.listSysErr(vo);
    }

    /*****************************************************
     * 시스템 오류현황 상세 조회
     * @param vo
     * @return SysMgrErrVO
     * @throws Exception
     ******************************************************/
    @Override
    public SysMgrErrVO selectSysErrDtl(SysMgrErrVO vo) throws Exception {
        return sysMgrErrDAO.selectSysErrDtl(vo);
    }
}