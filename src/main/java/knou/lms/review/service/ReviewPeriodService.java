package knou.lms.review.service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.review.vo.ReviewPeriodListVO;
import knou.lms.review.vo.ReviewPeriodVO;

public interface ReviewPeriodService {

    /*****************************************************
     * 복습기간설정 목록 조회
     * @param vo
     * @return ResultDTO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ResultDTO<EgovMap> listReviewPeriod(ReviewPeriodListVO vo) throws Exception;

    /*****************************************************
     * 복습기간설정 상세 조회
     * @param vo
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectReviewPeriod(ReviewPeriodVO vo) throws Exception;

    /*****************************************************
     * 복습기간설정 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    public void saveReviewPeriod(ReviewPeriodVO vo) throws Exception;
}
