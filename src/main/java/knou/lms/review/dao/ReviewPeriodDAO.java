package knou.lms.review.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.review.vo.ReviewPeriodListVO;
import knou.lms.review.vo.ReviewPeriodVO;

@Mapper("reviewPeriodDAO")
public interface ReviewPeriodDAO {

    /*****************************************************
     * 복습기간설정 목록 총건수 조회
     * @param vo
     * @return int
     ******************************************************/
    public int countReviewPeriod(ReviewPeriodListVO vo);

    /*****************************************************
     * 복습기간설정 목록 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    public List<EgovMap> listReviewPeriod(ReviewPeriodListVO vo);

    /*****************************************************
     * 복습기간설정 상세 조회
     * @param vo
     * @return EgovMap
     ******************************************************/
    public EgovMap selectReviewPeriod(ReviewPeriodVO vo);

    /*****************************************************
     * 복습기간설정 저장
     * @param vo
     * @return int
     ******************************************************/
    public int updateReviewPeriod(ReviewPeriodVO vo);
}
