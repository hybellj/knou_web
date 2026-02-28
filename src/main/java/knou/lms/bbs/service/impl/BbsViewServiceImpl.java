package knou.lms.bbs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.bbs.dao.BbsViewDAO;
import knou.lms.bbs.service.BbsViewService;
import knou.lms.bbs.vo.BbsViewVO;
import knou.lms.common.vo.ProcessResultVO;

@Service("bbsViewService")
public class BbsViewServiceImpl extends ServiceBase implements BbsViewService {

    private static final Logger LOGGER = LoggerFactory.getLogger(BbsViewServiceImpl.class);
    
    @Resource(name = "bbsViewDAO")
    private BbsViewDAO bbsViewDAO;
    
    /***************************************************** 
     * 게시판 조회 정보
     * @param vo
     * @return BbsViewVO
     * @throws Exception
     ******************************************************/
    @Override
    public BbsViewVO selectBbsView(BbsViewVO vo) throws Exception {
        return bbsViewDAO.selectBbsView(vo);
    }

    /***************************************************** 
     * 게시판 조회자 목록 수
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int countBbsView(BbsViewVO vo) throws Exception {
        return bbsViewDAO.countBbsView(vo);
    }

    /***************************************************** 
     * 게시판 조회자 목록
     * @param vo
     * @return List<BbsViewVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsViewVO> listBbsView(BbsViewVO vo) throws Exception {
        return bbsViewDAO.listBbsView(vo);
    }

    /***************************************************** 
     * 게시판 조회자 목록 페이징
     * @param vo
     * @return List<BbsViewVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<BbsViewVO> listBbsViewPaging(BbsViewVO vo) throws Exception {
        ProcessResultVO<BbsViewVO> processResultVO = new ProcessResultVO<>();
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        int totCnt = bbsViewDAO.countBbsView(vo);
        
        paginationInfo.setTotalRecordCount(totCnt);
        
        List<BbsViewVO> resultList = bbsViewDAO.listBbsViewPaging(vo);
        
        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);
        
        return processResultVO;
    }

    /***************************************************** 
     * 게시판 조회자 정보 등록
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void insertBbsView(BbsViewVO vo) throws Exception {
        vo.setViewId(IdGenerator.getNewId("BBSV"));
        
        bbsViewDAO.insertBbsView(vo);
    }

    /***************************************************** 
     * 게시판 조회자 정보 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void updateBbsView(BbsViewVO vo) throws Exception {
        bbsViewDAO.updateBbsView(vo);
    }

    /***************************************************** 
     * 수강생별 조회 목록
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int countBbsViewStd(BbsViewVO vo) throws Exception {
        return bbsViewDAO.countBbsViewStd(vo);
    }

    /***************************************************** 
     * 수강생별 조회자 목록 수
     * @param vo
     * @return List<BbsViewVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsViewVO> listBbsViewStd(BbsViewVO vo) throws Exception {
        return bbsViewDAO.listBbsViewStd(vo);
    }

}
