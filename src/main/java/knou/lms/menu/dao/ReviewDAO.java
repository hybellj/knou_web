package knou.lms.menu.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.crs.term.vo.CrsTermLessonVO;
import knou.lms.menu.vo.ReviewVO;

@Mapper("reviewDAO")
public interface ReviewDAO {

    /*****************************************************
     * 복습기간현황 > 복습기간 정보 목록 페이징
     * @param ReviewVO
     * @return List<ContentsVO>
     * @throws Exception
     ******************************************************/
    public List<ReviewVO> reviewListPaging(ReviewVO vo) throws Exception;
    
    /*****************************************************
     * 복습기간현황 > 복습기간 정보 목록 수
     * @param ContentsVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int countReviewInfo(ReviewVO vo) throws Exception;
    
    /*****************************************************
     * 복습기간현황 > 복습기간 정보 엑셀 리스트
     * @param ContentsVO
     * @return List<ContentsVO>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> reviewListExcel(ReviewVO vo) throws Exception;
    
    /**
     * 복습기간현황 > 복습기간 정보 수정
     * @param CreCrsTchRltnVO
     * @return void
     * @throws Exception
     */
    public void updateReview(ReviewVO vo) throws Exception;
    
    
    /**
     * 복습기간현황 > 복습기간 정보 수정
     * @param CreCrsTchRltnVO
     * @return void
     * @throws Exception
     */
    public void updateReviewAll(CrsTermLessonVO crsTermLessonVO) throws Exception;
}
