package knou.lms.lrnsts.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.lms.lrnsts.dao.LrnStsDAO;
import knou.lms.lrnsts.service.LrnStsService;
import knou.lms.lrnsts.vo.LrnStsAccessChartVO;
import knou.lms.lrnsts.vo.LrnStsActivityLogVO;
import knou.lms.lrnsts.vo.LrnStsChsiLrnVO;
import knou.lms.lrnsts.vo.LrnStsDetailVO;
import knou.lms.lrnsts.vo.LrnStsLrnLogVO;
import knou.lms.lrnsts.vo.LrnStsVO;
import knou.lms.lrnsts.vo.LrnStsWkLrnVO;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.org.vo.OrgInfoVO;

/**
 * 나의 학습현황 Service 구현체
 */
@Service("lrnStsService")
public class LrnStsServiceImpl implements LrnStsService {

    @Resource(name = "lrnStsDAO")
    private LrnStsDAO lrnStsDAO;

    /**
     * 나의 학습현황 목록 건수를 조회한다.
     */
    @Override
    public int selectLrnStsListCnt(LrnStsVO vo) {
        return lrnStsDAO.selectLrnStsListCnt(vo);
    }

    /**
     * 나의 학습현황 목록을 조회한다.
     */
    @Override
    public List<LrnStsVO> selectLrnStsList(LrnStsVO vo) {
        return lrnStsDAO.selectLrnStsList(vo);
    }

    /**
     * 학습현황 검색용 기관 목록을 조회한다.
     */
    @Override
    public List<OrgInfoVO> selectLrnStsOrgList(LrnStsVO vo) {
        return lrnStsDAO.selectLrnStsOrgList(vo);
    }

    /**
     * 학습현황 검색용 학기 목록을 조회한다.
     */
    @Override
    public List<SmstrChrtVO> selectLrnStsSmstrChrtList(LrnStsVO vo) {
        return lrnStsDAO.selectLrnStsSmstrChrtList(vo);
    }

    /**
     * 학습현황 검색용 과목 목록을 조회한다.
     */
    @Override
    public List<LrnStsVO> selectLrnStsSubjectList(LrnStsVO vo) {
        return lrnStsDAO.selectLrnStsSubjectList(vo);
    }

    /**
     * 학습자 학습현황 상세 기본 정보를 조회한다.
     */
    @Override
    public LrnStsDetailVO selectLrnStsDetail(LrnStsDetailVO vo) {
        return lrnStsDAO.selectLrnStsDetail(vo);
    }

    /**
     * 학습자 주차별 출결/학습 상태 목록을 조회한다.
     */
    @Override
    public List<LrnStsDetailVO> selectLrnStsWkStsList(LrnStsDetailVO vo) {
        return lrnStsDAO.selectLrnStsWkStsList(vo);
    }

    /**
     * 학습자 접속현황 차트 데이터를 조회한다.
     */
    @Override
    public List<LrnStsAccessChartVO> selectLrnStsAccessChartList(LrnStsAccessChartVO vo) {
        return lrnStsDAO.selectLrnStsAccessChartList(vo);
    }

    /**
     * 강의실 활동기록 목록 건수를 조회한다.
     */
    @Override
    public int selectLrnStsActivityLogListCnt(LrnStsActivityLogVO vo) {
        return lrnStsDAO.selectLrnStsActivityLogListCnt(vo);
    }

    /**
     * 강의실 활동기록 전체 목록을 조회한다.
     */
    @Override
    public List<LrnStsActivityLogVO> selectLrnStsActivityLogList(LrnStsActivityLogVO vo) {
        return lrnStsDAO.selectLrnStsActivityLogList(vo);
    }

    /**
     * 강의실 활동기록 페이징 목록을 조회한다.
     */
    @Override
    public List<LrnStsActivityLogVO> selectLrnStsActivityLogPaging(LrnStsActivityLogVO vo) {
        return lrnStsDAO.selectLrnStsActivityLogPaging(vo);
    }

    /**
     * 주차별 학습현황 팝업 요약 정보를 조회한다.
     */
    @Override
    public LrnStsWkLrnVO selectLrnStsWkLrnSummary(LrnStsWkLrnVO vo) {
        LrnStsWkLrnVO resultVO = lrnStsDAO.selectLrnStsWkLrnSummary(vo);

        LrnStsChsiLrnVO chsiVO = new LrnStsChsiLrnVO();
        chsiVO.setOrgId(vo.getOrgId());
        chsiVO.setSbjctId(vo.getSbjctId());
        chsiVO.setUserId(vo.getUserId());
        chsiVO.setWkNo(vo.getWkNo());

        List<LrnStsChsiLrnVO> chsiList = lrnStsDAO.selectLrnStsChsiLrnList(chsiVO);
        if (resultVO == null) {
            // 미학습 주차도 차시 목록은 표시할 수 있도록 기본 VO를 만든다.
            if (chsiList == null || chsiList.isEmpty()) {
                return null;
            }
            resultVO = new LrnStsWkLrnVO();
            resultVO.setWkNo(vo.getWkNo());
        }

        resultVO.setChsiList(chsiList);
        return resultVO;
    }

    /**
     * 주차별 차시 학습 목록을 조회한다.
     */
    @Override
    public List<LrnStsChsiLrnVO> selectLrnStsChsiLrnList(LrnStsChsiLrnVO vo) {
        return lrnStsDAO.selectLrnStsChsiLrnList(vo);
    }

    /**
     * 차시별 학습 로그 목록을 조회한다.
     */
    @Override
    public List<LrnStsLrnLogVO> selectLrnStsLrnLogList(LrnStsLrnLogVO vo) {
        return lrnStsDAO.selectLrnStsLrnLogList(vo);
    }
}
