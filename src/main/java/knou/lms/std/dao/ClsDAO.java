package knou.lms.std.dao;

import knou.lms.std.vo.*;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

/**
 * 전체수업현황 DAO
 * 화면ID : KNOU_MN_B0102060101, KNOU_MN_B0102060102
 * XML Mapper : knou/lms/std/dao/ClsDAO.xml
 */
@Mapper("clsDAO")
public interface ClsDAO {
    /*****************************************************
     * 과목 상세 정보를 조회한다. (과목명/분반/전체 주차 수 등)
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
     * 전체수업현황 운영과목 목록 건수를 조회한다.
     * @param ClsVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectClsListCnt(ClsVO vo) throws Exception;

    /*****************************************************
     * 전체수업현황 운영과목 목록을 페이징 조회한다.
     * @param ClsVO
     * @return List<ClsVO>
     * @throws Exception
     ******************************************************/
    public List<ClsVO> selectClsListPaging(ClsVO vo) throws Exception;

    /*****************************************************
     * 전체수업현황 운영과목 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsVO
     * @return List<ClsVO>
     * @throws Exception
     ******************************************************/
    public List<ClsVO> selectClsList(ClsVO vo) throws Exception;

    /*****************************************************
     * 운영과목 드롭다운 목록을 조회한다.
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
     * 수강생 주차별 학습현황 목록을 페이징 조회한다.
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     * @throws Exception
     ******************************************************/
    public List<ClsStdntVO> selectClsStdntListPaging(ClsStdntVO vo) throws Exception;

    /*****************************************************
     * 수강생 주차별 학습현황 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     * @throws Exception
     ******************************************************/
    public List<ClsStdntVO> selectClsStdntList(ClsStdntVO vo) throws Exception;

    /*****************************************************
     * 수강생별 주차 학습상태 목록을 조회한다.
     * - selectClsStdntListPaging 조회 후 userId 기준으로 그룹핑하여 세팅한다.
     * @param ClsStdntVO
     * @return List<ClsWkStsVO>
     * @throws Exception
     ******************************************************/
    List<ClsWkStsVO> selectClsStdntWkStsList(ClsStdntVO vo) throws Exception;

    /*****************************************************
     * 주차별 미학습자 비율을 조회한다.
     * - 주차별 수업현황 상단의 미학습자 비율 테이블에 사용된다.
     * @param ClsVO
     * @return List<ClsWklyStatsVO>
     * @throws Exception
     ******************************************************/
    public List<ClsWklyStatsVO> selectClsWklyStats(ClsVO vo) throws Exception;

    /*****************************************************
     * 학습요소 참여현황 목록 건수를 조회한다.
     * @param ClsElemStatsVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectClsElemStatsListCnt(ClsElemStatsVO vo) throws Exception;

    /*****************************************************
     * 학습요소 참여현황 목록을 페이징 조회한다.
     * @param ClsElemStatsVO
     * @return List<ClsElemStatsVO>
     * @throws Exception
     ******************************************************/
    public List<ClsElemStatsVO> selectClsElemStatsListPaging(ClsElemStatsVO vo) throws Exception;

    /*****************************************************
     * 학습요소 참여현황 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsElemStatsVO
     * @return List<ClsElemStatsVO>
     * @throws Exception
     ******************************************************/
    public List<ClsElemStatsVO> selectClsElemStatsList(ClsElemStatsVO vo) throws Exception;

    /*****************************************************
     * 특정 주차 미학습자 목록을 조회한다.
     * - 학습 이력이 없는 수강생(완전 미접속)도 미학습자로 포함한다.
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     * @throws Exception
     ******************************************************/
    public List<ClsStdntVO> selectClsNoStudyWeek(ClsStdntVO vo) throws Exception;

    /*****************************************************
     * 수강생 상세 정보를 조회한다. (기관/이름/학번/연락처/이메일)
     * @param ClsStdntInfoVO
     * @return ClsStdntInfoVO
     * @throws Exception
     ******************************************************/
    public ClsStdntInfoVO selectClsStdntInfo(ClsStdntInfoVO vo) throws Exception;

    /*****************************************************
     * 학습자 주차별 출결 단건 정보를 조회한다.
     * @param ClsStdntVO
     * @return ClsStdntVO
     * @throws Exception
     ******************************************************/
    public ClsStdntVO selectClsStdntWeeklyInfo(ClsStdntVO vo) throws Exception;

    /*****************************************************
     * 수강생 일별 강의실 접속현황 차트 데이터를 조회한다.
     * - 지난달 / 해당 학습자 / 전체 평균 세 계열을 반환한다.
     * @param ClsAccessChartVO
     * @return List<ClsAccessChartVO>
     * @throws Exception
     ******************************************************/
    public List<ClsAccessChartVO> selectStdntAccessChart(ClsAccessChartVO vo) throws Exception;

    /*****************************************************
     * 수강생 활동로그 건수를 조회한다.
     * @param ClsActivityLogVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectStdntActivityLogCnt(ClsActivityLogVO vo) throws Exception;

    /*****************************************************
     * 수강생 활동로그를 페이징 조회한다.
     * @param ClsActivityLogVO
     * @return List<ClsActivityLogVO>
     * @throws Exception
     ******************************************************/
    public List<ClsActivityLogVO> selectStdntActivityLogPaging(ClsActivityLogVO vo) throws Exception;

    /*****************************************************
     * 수강생 활동로그 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsActivityLogVO
     * @return List<ClsActivityLogVO>
     * @throws Exception
     ******************************************************/
    public List<ClsActivityLogVO> selectStdntActivityLogList(ClsActivityLogVO vo) throws Exception;

    /*****************************************************
     * 주차별 학습 요약 정보를 조회한다.
     * - 출결상태/학습시간/학습기간/버튼 노출 여부(atndCertUseYn, lastWkYn) 포함
     * @param ClsWkLrnVO
     * @return ClsWkLrnVO
     * @throws Exception
     ******************************************************/
    public ClsWkLrnVO selectStdntWkLrnSummary(ClsWkLrnVO vo) throws Exception;

    /*****************************************************
     * 주차별 차시 목록을 조회한다.
     * @param ClsWkLrnVO
     * @return List<ClsChsiLrnVO>
     * @throws Exception
     ******************************************************/
    public List<ClsChsiLrnVO> selectStdntChsiLrnList(ClsWkLrnVO vo) throws Exception;

    /*****************************************************
     * 차시별 3분 단위 학습로그를 조회한다.
     * @param ClsLrnLogVO
     * @return List<ClsLrnLogVO>
     * @throws Exception
     ******************************************************/
    public List<ClsLrnLogVO> selectStdntLrnLog(ClsLrnLogVO vo) throws Exception;

    /*****************************************************
     * 출석 처리를 수행한다. (LRN_STSCD → ATND, 이전값 BFR_LRN_STSCD 에 백업)
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int updateAtndlcProcess(ClsWkLrnVO vo) throws Exception;

    /*****************************************************
     * 출석 처리를 취소한다. (LRN_STSCD → BFR_LRN_STSCD 롤백)
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int updateAtndlcCancel(ClsWkLrnVO vo) throws Exception;

    /*****************************************************
     * 학습요소 제출 목록을 조회한다. (elemType: ASMT/QUIZ/QNA/SRVY/DSCC)
     * @param ClsWkLrnVO
     * @return List<ClsChsiLrnVO>
     * @throws Exception
     ******************************************************/
    public List<ClsChsiLrnVO> selectStdntElemSbmsnList(ClsWkLrnVO vo) throws Exception;

    /*****************************************************
     * 학습요소 제출 이력을 조회한다.
     * - 과제: 파일명/크기, 퀴즈: 점수/정오답, QNA/설문/토론: 내용 요약
     * @param ClsAsmtSbmsnLogVO
     * @return List<ClsAsmtSbmsnLogVO>
     * @throws Exception
     ******************************************************/
    public List<ClsAsmtSbmsnLogVO> selectStdntElemSbmsnLog(ClsAsmtSbmsnLogVO vo) throws Exception;

    /*****************************************************
     * 해당 학습자가 과목 수강생인지 확인한다. (0이면 접근 불가)
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int checkClsStdntAccessCnt(ClsWkLrnVO vo) throws Exception;

    /*****************************************************
     * 해당 주차 스케줄이 존재하는지 확인한다. (0이면 접근 불가)
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int checkClsWkSchdlAccessCnt(ClsWkLrnVO vo) throws Exception;

}