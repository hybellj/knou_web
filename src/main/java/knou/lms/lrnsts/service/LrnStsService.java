package knou.lms.lrnsts.service;

import java.util.List;

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
 * 나의 학습현황 Service
 */
public interface LrnStsService {

    /**
     * 나의 학습현황 목록 건수를 조회한다.
     */
    int selectLrnStsListCnt(LrnStsVO vo);

    /**
     * 나의 학습현황 목록을 조회한다.
     */
    List<LrnStsVO> selectLrnStsList(LrnStsVO vo);

    /**
     * 학습현황 검색용 기관 목록을 조회한다.
     */
    List<OrgInfoVO> selectLrnStsOrgList(LrnStsVO vo);

    /**
     * 학습현황 검색용 학기 목록을 조회한다.
     */
    List<SmstrChrtVO> selectLrnStsSmstrChrtList(LrnStsVO vo);

    /**
     * 학습현황 검색용 과목 목록을 조회한다.
     */
    List<LrnStsVO> selectLrnStsSubjectList(LrnStsVO vo);

    /**
     * 학습자 학습현황 상세 기본 정보를 조회한다.
     */
    LrnStsDetailVO selectLrnStsDetail(LrnStsDetailVO vo);

    /**
     * 학습자 주차별 출결/학습 상태 목록을 조회한다.
     */
    List<LrnStsDetailVO> selectLrnStsWkStsList(LrnStsDetailVO vo);

    /**
     * 학습자 접속현황 차트 데이터를 조회한다.
     */
    List<LrnStsAccessChartVO> selectLrnStsAccessChartList(LrnStsAccessChartVO vo);

    /**
     * 강의실 활동기록 목록 건수를 조회한다.
     */
    int selectLrnStsActivityLogListCnt(LrnStsActivityLogVO vo);

    /**
     * 강의실 활동기록 전체 목록을 조회한다.
     */
    List<LrnStsActivityLogVO> selectLrnStsActivityLogList(LrnStsActivityLogVO vo);

    /**
     * 강의실 활동기록 페이징 목록을 조회한다.
     */
    List<LrnStsActivityLogVO> selectLrnStsActivityLogPaging(LrnStsActivityLogVO vo);

    /**
     * 주차별 학습현황 팝업 요약 정보를 조회한다.
     */
    LrnStsWkLrnVO selectLrnStsWkLrnSummary(LrnStsWkLrnVO vo);

    /**
     * 주차별 차시 학습 목록을 조회한다.
     */
    List<LrnStsChsiLrnVO> selectLrnStsChsiLrnList(LrnStsChsiLrnVO vo);

    /**
     * 차시별 학습 로그 목록을 조회한다.
     */
    List<LrnStsLrnLogVO> selectLrnStsLrnLogList(LrnStsLrnLogVO vo);
}
