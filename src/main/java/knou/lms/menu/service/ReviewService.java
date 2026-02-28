package knou.lms.menu.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.crs.term.vo.CrsTermLessonVO;
import knou.lms.menu.vo.ReviewVO;

public interface ReviewService {

    /*****************************************************
     * 복습기간현황 > 복습기간 정보 목록 페이징
     * @param ReviewVO
     * @return ProcessResultVO<ReviewVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultListVO<ReviewVO> reviewListPaging(ReviewVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    
    /*****************************************************
     * 복습기간현황 > 복습기간 정보 엑셀 리스트
     * @param ReviewVO
     * @return List<ReviewVO>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> reviewListExcel(ReviewVO vo) throws Exception;

    /**
     * 복습기간 설정
     * @param ReviewVO
     * @return void
     * @throws Exception
     */
    public void updateReview(ReviewVO vo) throws Exception;
    
    public void updateReviewAll(CrsTermLessonVO crsTermLessonVO) throws Exception;
}
