package knou.lms.clssts.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.clssts.vo.ClsAccessChartVO;
import knou.lms.clssts.vo.ClsActivityLogVO;
import knou.lms.clssts.vo.ClsAsmtSbmsnLogVO;
import knou.lms.clssts.vo.ClsChsiLrnVO;
import knou.lms.clssts.vo.ClsElemStatsVO;
import knou.lms.clssts.vo.ClsLrnLogVO;
import knou.lms.clssts.vo.ClsStdntInfoVO;
import knou.lms.clssts.vo.ClsStdntVO;
import knou.lms.clssts.vo.ClsVO;
import knou.lms.clssts.vo.ClsWkLrnVO;
import knou.lms.clssts.vo.ClsWkStsVO;
import knou.lms.clssts.vo.ClsWklyStatsVO;

/**
 * 수업현황 Service 인터페이스
 * 화면ID : KNOU_MN_B0102060101, KNOU_MN_B0102060102
 */
public interface ClsStsService {

    /*****************************************************
     * 과목 상세 정보를 조회한다. (과목명/분반/전체 주차 수 등)
     * @param ClsVO
     * @return ClsVO
     ******************************************************/
    public ClsVO selectClsDetail(ClsVO vo);

    /*****************************************************
     * 현재 학년도/학기 정보를 조회한다.
     * @param ClsVO
     * @return ClsVO
     ******************************************************/
    public ClsVO selectCurrentTerm(ClsVO vo);

    /*****************************************************
     * 수업현황 운영과목 목록 건수를 조회한다.
     * @param ClsVO
     * @return int
     ******************************************************/
    public int selectClsListCnt(ClsVO vo);

    /*****************************************************
     * 수업현황 운영과목 목록을 페이징 조회한다.
     * @param ClsVO
     * @return ProcessResultVO<ClsVO>
     ******************************************************/
    public ProcessResultVO<ClsVO> selectClsListPaging(ClsVO vo);

    /*****************************************************
     * 수업현황 운영과목 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsVO
     * @return List<ClsVO>
     ******************************************************/
    public List<ClsVO> selectClsList(ClsVO vo);

    /*****************************************************
     * 교수 운영 기관 목록을 조회한다.
     * @param ClsVO
     * @return List<OrgInfoVO>
     ******************************************************/
    public List<OrgInfoVO> selectClsOrgList(ClsVO vo);

    /*****************************************************
     * 교수 운영 학기 목록을 조회한다.
     * @param ClsVO
     * @return List<SmstrChrtVO>
     ******************************************************/
    public List<SmstrChrtVO> selectClsTermList(ClsVO vo);

    /*****************************************************
     * 운영과목 드롭다운 목록을 조회한다.
     * @param ClsVO
     * @return List<ClsVO>
     ******************************************************/
    public List<ClsVO> selectClsSubjectList(ClsVO vo);

    /*****************************************************
     * 수강생 주차별 학습현황 목록 건수를 조회한다.
     * @param ClsStdntVO
     * @return int
     ******************************************************/
    public int selectClsStdntListCnt(ClsStdntVO vo);

    /*****************************************************
     * 수강생 주차별 학습현황 목록을 페이징 조회한다.
     * @param ClsStdntVO
     * @return ProcessResultVO<ClsStdntVO>
     ******************************************************/
    public ProcessResultVO<ClsStdntVO> selectClsStdntListPaging(ClsStdntVO vo);

    /*****************************************************
     * 수강생 주차별 학습현황 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     ******************************************************/
    public List<ClsStdntVO> selectClsStdntList(ClsStdntVO vo);

    /*****************************************************
     * 수강생별 주차 학습상태 목록을 조회한다.
     * - selectClsStdntListPaging 조회 후 userId 기준으로 그룹핑하여 세팅한다.
     * @param ClsStdntVO
     * @return List<ClsWkStsVO>
     ******************************************************/
    public List<ClsWkStsVO> selectClsStdntWkStsList(ClsStdntVO vo);

    /*****************************************************
     * 주차별 미학습자 비율을 조회한다.
     * - 주차별 수업현황 상단의 미학습자 비율 테이블에 사용된다.
     * @param ClsVO
     * @return List<ClsWklyStatsVO>
     ******************************************************/
    public List<ClsWklyStatsVO> selectClsWklyStats(ClsVO vo);

    /*****************************************************
     * 학습요소 참여현황 목록을 페이징 조회한다.
     * @param ClsElemStatsVO
     * @return ProcessResultVO<ClsElemStatsVO>
     ******************************************************/
    public ProcessResultVO<ClsElemStatsVO> selectClsElemStatsListPaging(ClsElemStatsVO vo);

    /*****************************************************
     * 학습요소 참여현황 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsElemStatsVO
     * @return List<ClsElemStatsVO>
     ******************************************************/
    public List<ClsElemStatsVO> selectClsElemStatsListExcelDown(ClsElemStatsVO vo);

    /*****************************************************
     * 학습요소 참여현황 목록을 조회한다.
     * @param ClsElemStatsVO
     * @return List<ClsElemStatsVO>
     ******************************************************/
    public List<ClsElemStatsVO> selectClsElemStatsList(ClsElemStatsVO vo);

    /*****************************************************
     * 특정 주차 미학습자 목록을 조회한다.
     * - 학습 이력이 없는 수강생(완전 미접속)도 미학습자로 포함한다.
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     ******************************************************/
    public List<ClsStdntVO> selectClsNoStudyWeek(ClsStdntVO vo);

    /*****************************************************
     * 수강생 상세 정보를 조회한다. (기관/이름/학번/연락처/이메일)
     * @param ClsStdntInfoVO
     * @return ClsStdntInfoVO
     ******************************************************/
    public ClsStdntInfoVO selectClsStdntInfo(ClsStdntInfoVO vo);

    /*****************************************************
     * 학습자 주차별 출결 단건 정보를 조회한다.
     * @param ClsStdntVO
     * @return ClsStdntVO
     ******************************************************/
    public ClsStdntVO selectClsStdntWeeklyInfo(ClsStdntVO vo);

    /*****************************************************
     * 수강생 일별 강의실 접속현황 차트 데이터를 조회한다.
     * - 지난달 / 해당 학습자 / 전체 평균 세 계열을 반환한다.
     * @param ClsAccessChartVO
     * @return List<ClsAccessChartVO>
     ******************************************************/
    public List<ClsAccessChartVO> selectStdntAccessChart(ClsAccessChartVO vo);

    /*****************************************************
     * 수강생 활동로그를 페이징 조회한다.
     * @param ClsActivityLogVO
     * @return ProcessResultVO<ClsActivityLogVO>
     ******************************************************/
    public ProcessResultVO<ClsActivityLogVO> selectStdntActivityLogPaging(ClsActivityLogVO vo);

    /*****************************************************
     * 수강생 활동로그 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsActivityLogVO
     * @return List<ClsActivityLogVO>
     ******************************************************/
    public List<ClsActivityLogVO> selectStdntActivityLogList(ClsActivityLogVO vo);

    /*****************************************************
     * 주차별 학습 요약 정보를 조회한다.
     * - 출결상태/학습시간/학습기간/버튼 노출 여부(atndCertUseYn, lastWkYn) 포함
     * @param ClsWkLrnVO
     * @return ClsWkLrnVO
     ******************************************************/
    public ClsWkLrnVO selectStdntWkLrnSummary(ClsWkLrnVO vo);

    /*****************************************************
     * 주차별 차시 목록을 조회한다.
     * @param ClsWkLrnVO
     * @return List<ClsChsiLrnVO>
     ******************************************************/
    public List<ClsChsiLrnVO> selectStdntChsiLrnList(ClsWkLrnVO vo);

    /*****************************************************
     * 차시별 3분 단위 학습로그를 조회한다.
     * @param ClsLrnLogVO
     * @return List<ClsLrnLogVO>
     ******************************************************/
    public List<ClsLrnLogVO> selectStdntLrnLog(ClsLrnLogVO vo);

    /*****************************************************
     * 출석 처리를 수행한다. (LRN_STSCD → CMPTN, 이전값 BFR_LRN_STSCD 에 백업)
     * @param ClsWkLrnVO
     * @return int
     ******************************************************/
    public int updateAtndlcProcess(ClsWkLrnVO vo);

    /*****************************************************
     * 출석 처리를 취소한다. (LRN_STSCD → BFR_LRN_STSCD 롤백)
     * @param ClsWkLrnVO
     * @return int
     ******************************************************/
    public int updateAtndlcCancel(ClsWkLrnVO vo);

    /*****************************************************
     * 학습요소 제출 목록을 조회한다. (elemType: ASMT/QUIZ/QNA/SRVY/DSCS)
     * @param ClsWkLrnVO
     * @return List<ClsChsiLrnVO>
     ******************************************************/
    public List<ClsChsiLrnVO> selectStdntElemSbmsnList(ClsWkLrnVO vo);

    /*****************************************************
     * 학습요소 제출 이력을 조회한다.
     * - 과제: 파일명/크기, 퀴즈: 점수/정오답, QNA/설문/토론: 내용 요약
     * @param ClsAsmtSbmsnLogVO
     * @return List<ClsAsmtSbmsnLogVO>
     * @throws Exception
     ******************************************************/
    public List<ClsAsmtSbmsnLogVO> selectStdntElemSbmsnLog(ClsAsmtSbmsnLogVO vo) throws Exception;

    /* ================================================================
       공통 접근 권한 체크
       ================================================================ */

    /*****************************************************
     * 해당 학습자가 과목 수강생인지 확인한다. (0이면 접근 불가)
     * @param ClsWkLrnVO
     * @return int
     ******************************************************/
    public int checkClsStdntAccessCnt(ClsWkLrnVO vo);

    /*****************************************************
     * 해당 주차 스케줄이 존재하는지 확인한다. (0이면 접근 불가)
     * @param ClsWkLrnVO
     * @return int
     ******************************************************/
    public int checkClsWkSchdlAccessCnt(ClsWkLrnVO vo);
}
