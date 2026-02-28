package knou.lms.menu.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.ServiceBase;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.vo.CrsTermLessonVO;
import knou.lms.menu.dao.ReviewDAO;
import knou.lms.menu.service.ReviewService;
import knou.lms.menu.vo.ReviewVO;

@Service("reviewService")
public class ReviewServiceImpl extends ServiceBase implements ReviewService {

    private static final Logger logger = LoggerFactory.getLogger(ReviewServiceImpl.class);
    
    @Resource(name="reviewDAO")
    private ReviewDAO reviewDAO;
    
    /*****************************************************
     * 복습기간현황 > 복습기간 정보 목록 페이징
     * @param ReviewVO
     * @return ProcessResultVO<ReviewVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultListVO<ReviewVO> reviewListPaging(ReviewVO vo, int pageIndex, int listScale, int pageScale) throws Exception {
        
        ProcessResultListVO<ReviewVO> resultList = new ProcessResultListVO<ReviewVO>(); 
        try {

            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getPageScale());
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totCnt = reviewDAO.countReviewInfo(vo);
            paginationInfo.setTotalRecordCount(totCnt);
            
            List<ReviewVO> reviewList = reviewDAO.reviewListPaging(vo);
            resultList.setResult(1);
            resultList.setReturnList(reviewList); 
            resultList.setPageInfo(paginationInfo);

        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    
    /*****************************************************
     * 복습기간현황 > 복습기간 정보 엑셀 리스트
     * @param ReviewVO
     * @return List<ReviewVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> reviewListExcel(ReviewVO vo) throws Exception {
        return reviewDAO.reviewListExcel(vo);
    }

    /**
     * 복습기간 설정
     * 
     * @param CreCrsTchRltnVO
     * @return void
     * @throws Exception
     */
    @Override
    public void updateReview(ReviewVO vo) throws Exception {
        reviewDAO.updateReview(vo);
    }

    public void updateReviewAll(CrsTermLessonVO crsTermLessonVO) throws Exception {
        reviewDAO.updateReviewAll(crsTermLessonVO);
    }
}
