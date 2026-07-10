package knou.lms.review.service.impl;

import java.util.Collections;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.review.dao.ReviewPeriodDAO;
import knou.lms.review.service.ReviewPeriodService;
import knou.lms.review.vo.ReviewPeriodListVO;
import knou.lms.review.vo.ReviewPeriodVO;

@Service("reviewPeriodService")
public class ReviewPeriodServiceImpl implements ReviewPeriodService {

    @Resource(name = "reviewPeriodDAO")
    private ReviewPeriodDAO reviewPeriodDAO;

    /*****************************************************
     * 복습기간설정 목록 조회
     * @param vo
     * @return ResultDTO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ResultDTO<EgovMap> listReviewPeriod(ReviewPeriodListVO vo) throws Exception {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>(vo);

        setDefaultPaging(vo);

        int totalCount = reviewPeriodDAO.countReviewPeriod(vo);
        resultDTO.getPageInfo().setTotalRecordCount(totalCount);

        if (totalCount == 0) {
            resultDTO.setReturnList(Collections.<EgovMap>emptyList());
            return resultDTO;
        }

        resultDTO.setReturnList(reviewPeriodDAO.listReviewPeriod(vo));
        return resultDTO;
    }

    /*****************************************************
     * 복습기간설정 상세 조회
     * @param vo
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectReviewPeriod(ReviewPeriodVO vo) throws Exception {
        return reviewPeriodDAO.selectReviewPeriod(vo);
    }

    /*****************************************************
     * 복습기간설정 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void saveReviewPeriod(ReviewPeriodVO vo) throws Exception {
        if (isBlank(vo.getSbjctId())) {
            throw new IllegalArgumentException("과목을 선택해 주세요.");
        }
        if (isBlank(vo.getOrgId())) {
            throw new IllegalArgumentException("기관 정보를 확인할 수 없습니다.");
        }

        String reviewStatus = normalizeReviewStatus(vo.getReviewStatus());
        vo.setReviewStatus(reviewStatus);

        if ("PRD_STNG".equals(reviewStatus)) {
            String startDttm = normalizeDttm(vo.getReviewStartDttm(), "000000");
            String endDttm = normalizeDttm(vo.getReviewEndDttm(), "235900");
            if (isBlank(startDttm) || isBlank(endDttm)) {
                throw new IllegalArgumentException("복습기간 시작일과 종료일을 입력해 주세요.");
            }
            if (startDttm.compareTo(endDttm) > 0) {
                throw new IllegalArgumentException("복습기간 시작일이 종료일보다 클 수 없습니다.");
            }
            vo.setReviewStartDttm(startDttm);
            vo.setReviewEndDttm(endDttm);
        } else {
            vo.setReviewStartDttm("");
            vo.setReviewEndDttm("");
        }

        if (reviewPeriodDAO.updateReviewPeriod(vo) == 0) {
            throw new IllegalArgumentException("복습기간을 저장할 과목 정보를 확인할 수 없습니다.");
        }
    }

    /*****************************************************
     * 복습 가능 상태 코드 정규화
     * @param reviewStatus
     * @return String
     ******************************************************/
    private String normalizeReviewStatus(String reviewStatus) {
        String status = StringUtil.nvl(reviewStatus, "RVW_IMPSBL");
        if ("RVW_IMPSBL".equals(status)) {
            return "RVW_IMPSBL";
        }
        if ("RVW_PSBL".equals(status)) {
            return "RVW_PSBL";
        }
        if ("PRD_STNG".equals(status)) {
            return "PRD_STNG";
        }
        throw new IllegalArgumentException("복습기간 설정값을 확인해 주세요.");
    }

    /*****************************************************
     * 목록 기본 페이징 값 보정
     * @param vo
     ******************************************************/
    private void setDefaultPaging(ReviewPeriodListVO vo) {
        if (isBlank(vo.getLangCd())) {
            vo.setLangCd("ko");
        }
        if (vo.getCurrentPageNo() <= 0) {
            vo.setCurrentPageNo(vo.getPageIndex() > 0 ? vo.getPageIndex() : 1);
        }
        if (vo.getRecordCountPerPage() <= 0) {
            vo.setRecordCountPerPage(vo.getListScale() > 0 ? vo.getListScale() : 10);
        }
        if (vo.getPageSize() <= 0) {
            vo.setPageSize(vo.getPageScale() > 0 ? vo.getPageScale() : 10);
        }
        vo.setPageIndex(vo.getCurrentPageNo());
        vo.setListScale(vo.getRecordCountPerPage());
        vo.setPageScale(vo.getPageSize());
    }

    /*****************************************************
     * 복습기간 일시값을 YYYYMMDDHH24MISS 형식으로 정규화
     * @param value
     * @param defaultTime
     * @return String
     ******************************************************/
    private String normalizeDttm(String value, String defaultTime) {
        String digits = StringUtil.nvl(value).replaceAll("[^0-9]", "");
        if (digits.length() == 8) {
            digits += defaultTime;
        } else if (digits.length() == 12) {
            digits += "00";
        } else if (digits.length() > 14) {
            digits = digits.substring(0, 14);
        }
        return digits.length() == 14 ? digits : "";
    }

    /*****************************************************
     * 공백 문자열 여부 확인
     * @param value
     * @return boolean
     ******************************************************/
    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }
}
