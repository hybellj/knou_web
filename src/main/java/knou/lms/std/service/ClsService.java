package knou.lms.std.service;

import knou.lms.std.vo.*;
import knou.lms.common.vo.ProcessResultVO;

import java.util.List;

public interface ClsService {

    /*****************************************************
     * 과목 상세 정보를 조회한다.
     * @param ClsVO
     * @return ClsVO
     * @throws Exception
     ******************************************************/
    public ClsVO selectClsDetail(ClsVO vo) throws Exception;

    /*****************************************************
     * 현재 학년도/학기 정보를 조회한다.
     * @param ClsVO
     * @return ClsVO
     * @throws Exception
     ******************************************************/
    public ClsVO selectCurrentTerm(ClsVO vo) throws Exception;

    /*****************************************************
     * 전체 수업현황 목록 건수를 조회한다.
     * @param ClsVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectClsListCnt(ClsVO vo) throws Exception;

    /*****************************************************
     * 전체 수업현황 목록을 조회한다.
     * @param ClsVO
     * @return List<ClsVO>
     * @throws Exception
     ******************************************************/
    public List<ClsVO> selectClsList(ClsVO vo) throws Exception;

    /*****************************************************
     * 전체 수업현황 목록을 페이징 조회한다.
     * @param ClsVO
     * @return ProcessResultVO<ClsVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ClsVO> selectClsListPaging(ClsVO vo) throws Exception;

    /*****************************************************
     * 운영 과목 드롭다운 목록을 조회한다.
     * @param ClsVO
     * @return List<ClsVO>
     * @throws Exception
     ******************************************************/
    public List<ClsVO> selectClsSubjectList(ClsVO vo) throws Exception;

    /*****************************************************
     * 수강생 주차별 학습현황 목록 건수를 조회한다.
     * @param ClsStdntVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectClsStdntListCnt(ClsStdntVO vo) throws Exception;

    /*****************************************************
     * 수강생 주차별 학습현황 목록을 조회한다.
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     * @throws Exception
     ******************************************************/
    public List<ClsStdntVO> selectClsStdntList(ClsStdntVO vo) throws Exception;

    /*****************************************************
     * 수강생 주차별 학습현황 목록을 페이징 조회한다.
     * @param ClsStdntVO
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ClsStdntVO> selectClsStdntListPaging(ClsStdntVO vo) throws Exception;

    /*****************************************************
     * 주차별 미학습 비율을 조회한다.
     * @param ClsVO
     * @return List<ClsWklyStatsVO>
     * @throws Exception
     ******************************************************/
    public List<ClsWklyStatsVO> selectClsWklyStats(ClsVO vo) throws Exception;

    /*****************************************************
     * 특정 주차 미학습자 목록을 조회한다.
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     * @throws Exception
     ******************************************************/
    public List<ClsStdntVO> selectClsNoStudyWeek(ClsStdntVO vo) throws Exception;

    /*****************************************************
     * 학습요소 참여현황 목록을 조회한다.
     * @param ClsElemStatsVO
     * @return List<ClsElemStatsVO>
     * @throws Exception
     ******************************************************/
    public List<ClsElemStatsVO> selectClsElemStatsList(ClsElemStatsVO vo) throws Exception;

    /*****************************************************
     * 학습요소 참여현황 전체 목록을 조회한다.
     * @param ClsElemStatsVO
     * @return List<ClsElemStatsVO>
     * @throws Exception
     ******************************************************/
    public List<ClsElemStatsVO> selectClsElemStatsListExcelDown(ClsElemStatsVO vo) throws Exception;

    /*****************************************************
     * 수강생 상세 정보를 조회한다.
     * @param ClsStdntInfoVO
     * @return ClsStdntInfoVO
     * @throws Exception
     ******************************************************/
    public ClsStdntInfoVO selectClsStdntInfo(ClsStdntInfoVO vo) throws Exception;

    /*****************************************************
     * 수강생 접속현황 차트 데이터를 조회한다.
     * @param ClsAccessChartVO
     * @return List<ClsAccessChartVO>
     * @throws Exception
     ******************************************************/
    public List<ClsAccessChartVO> selectStdntAccessChart(ClsAccessChartVO vo) throws Exception;

    /*****************************************************
     * 수강생 활동로그를 페이징 조회한다.
     * @param ClsActivityLogVO
     * @return ProcessResultVO<ClsActivityLogVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ClsActivityLogVO> selectStdntActivityLogPaging(ClsActivityLogVO vo) throws Exception;

    /*****************************************************
     * 수강생 활동로그 전체 목록을 조회한다.
     * @param ClsActivityLogVO
     * @return List<ClsActivityLogVO>
     * @throws Exception
     ******************************************************/
    public List<ClsActivityLogVO> selectStdntActivityLogList(ClsActivityLogVO vo) throws Exception;

    /*****************************************************
     * 주차별 학습 요약 정보를 조회한다.
     * @param ClsWkLrnVO
     * @return ClsWkLrnVO
     * @throws Exception
     ******************************************************/
    public ClsWkLrnVO selectStdntWkLrnSummary(ClsWkLrnVO vo) throws Exception;

    /*****************************************************
     * 학습 항목 목록을 조회한다.
     * @param ClsWkLrnVO
     * @return List<ClsChsiLrnVO>
     * @throws Exception
     ******************************************************/
    public List<ClsChsiLrnVO> selectStdntChsiLrnList(ClsWkLrnVO vo) throws Exception;

    /*****************************************************
     * 학습 로그를 조회한다.
     * @param ClsLrnLogVO
     * @return List<ClsLrnLogVO>
     * @throws Exception
     ******************************************************/
    public List<ClsLrnLogVO> selectStdntLrnLog(ClsLrnLogVO vo) throws Exception;

    /*****************************************************
     * 출석 처리를 수행한다.
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int updateAtndlcProcess(ClsWkLrnVO vo) throws Exception;

    /*****************************************************
     * 출석 처리를 취소한다.
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int updateAtndlcCancel(ClsWkLrnVO vo) throws Exception;

    /*****************************************************
     * 학습요소 제출 목록을 조회한다.
     * @param ClsWkLrnVO
     * @return List<ClsChsiLrnVO>
     * @throws Exception
     ******************************************************/
    public List<ClsChsiLrnVO> selectStdntElemSbmsnList(ClsWkLrnVO vo) throws Exception;

    /*****************************************************
     * 학습요소 제출 로그를 조회한다.
     * @param ClsAsmtSbmsnLogVO
     * @return List<ClsAsmtSbmsnLogVO>
     * @throws Exception
     ******************************************************/
    public List<ClsAsmtSbmsnLogVO> selectStdntElemSbmsnLog(ClsAsmtSbmsnLogVO vo) throws Exception;

    /*****************************************************
     * 학습자 주차별 학습현황 단건 정보를 조회한다.
     * @param ClsStdntVO
     * @return ClsStdntVO
     * @throws Exception
     ******************************************************/
    public ClsStdntVO selectClsStdntWeeklyInfo(ClsStdntVO vo) throws Exception;

    /*****************************************************
     * 학습요소 참여현황 목록을 페이징 조회한다.
     * @param ClsElemStatsVO
     * @return ProcessResultVO<ClsElemStatsVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ClsElemStatsVO> selectClsElemStatsListPaging(ClsElemStatsVO vo) throws Exception;

    /*****************************************************
     * cls 학생 접근 가능 여부 체크
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int checkClsStdntAccessCnt(ClsWkLrnVO vo) throws Exception;

    /*****************************************************
     * cls 주차 스케줄 접근 가능 여부 체크
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int checkClsWkSchdlAccessCnt(ClsWkLrnVO vo) throws Exception;


}
