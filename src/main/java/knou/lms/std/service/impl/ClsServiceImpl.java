package knou.lms.std.service.impl;

import knou.framework.common.ServiceBase;
import knou.lms.std.dao.ClsDAO;
import knou.lms.std.service.ClsService;
import knou.lms.std.vo.*;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.ArrayList;
import java.util.Map;

/**
 * 전체수업현황 Service 구현체
 */

@Service("clsService")
public class ClsServiceImpl extends ServiceBase implements ClsService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ClsServiceImpl.class);

    @Resource(name = "clsDAO")
    private ClsDAO clsDAO;

    /*****************************************************
     * 과목 주차 수를 기준으로 주차 목록 기본값을 설정한다.
     * - wkList 가 비어 있으면 과목 상세를 조회하여 실제 주차 수만큼 세팅한다.
     * - 과목 조회 실패 또는 주차 수 0 이하인 경우 15주를 기본값으로 사용한다.
     * @param ClsStdntVO
     ******************************************************/
    private void setDefaultWkList(ClsStdntVO vo) throws Exception {
        if (vo.getWkList() == null || vo.getWkList().isEmpty()) {
            int wkCnt = 15;

            if (vo.getSbjctId() != null && !vo.getSbjctId().isEmpty()) {
                ClsVO clsVO = new ClsVO();
                clsVO.setSbjctId(vo.getSbjctId());
                clsVO.setOrgId(vo.getOrgId());

                ClsVO detail = clsDAO.selectClsDetail(clsVO);
                if (detail != null && detail.getWkCnt() > 0) {
                    wkCnt = detail.getWkCnt();
                }
            }

            vo.setWkList(IntStream.rangeClosed(1, wkCnt).boxed().collect(Collectors.toList()));
        }
    }

    /*****************************************************
     * 과목 상세 정보를 조회한다. (과목명/분반/전체 주차 수 등)
     * @param ClsVO
     * @return ClsVO
     * @throws Exception
     ******************************************************/
    @Override
    public ClsVO selectClsDetail(ClsVO vo) throws Exception {
        return clsDAO.selectClsDetail(vo);
    }

    /*****************************************************
     * 현재 학년도/학기 정보를 조회한다.
     * @param ClsVO
     * @return ClsVO
     * @throws Exception
     ******************************************************/
    @Override
    public ClsVO selectCurrentTerm(ClsVO vo) throws Exception {
        return clsDAO.selectCurrentTerm(vo);
    }

    /*****************************************************
     * 전체수업현황 운영과목 목록 건수를 조회한다.
     * @param ClsVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int selectClsListCnt(ClsVO vo) throws Exception {
        return clsDAO.selectClsListCnt(vo);
    }

    /*****************************************************
     * 전체수업현황 운영과목 목록을 페이징 조회한다.
     * @param ClsVO
     * @return ProcessResultVO<ClsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ClsVO> selectClsListPaging(ClsVO vo) throws Exception {
        ProcessResultVO<ClsVO> out = new ProcessResultVO<>();
        try {
            PagingInfo pi = new PagingInfo();
            pi.setCurrentPageNo(vo.getPageIndex());
            pi.setRecordCountPerPage(vo.getListScale());
            pi.setPageSize(vo.getPageScale());
            vo.setFirstIndex(pi.getFirstRecordIndex());
            vo.setLastIndex(pi.getLastRecordIndex());
            int totCnt = clsDAO.selectClsListCnt(vo);
            pi.setTotalRecordCount(totCnt);
            out.setReturnList(clsDAO.selectClsListPaging(vo));
            out.setPageInfo(pi);
            out.setResult(1);
        } catch (Exception e) {
            LOGGER.error("[selectClsListPaging] fail, vo={}", vo, e);
            out.setResult(-1);
            out.setMessage("에러가 발생하였습니다.");
        }
        return out;
    }

    /*****************************************************
     * 전체수업현황 운영과목 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsVO
     * @return List<ClsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsVO> selectClsList(ClsVO vo) throws Exception {
        return clsDAO.selectClsList(vo);
    }

    /*****************************************************
     * 운영과목 드롭다운 목록을 조회한다.
     * @param ClsVO
     * @return List<ClsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsVO> selectClsSubjectList(ClsVO vo) throws Exception {
        return clsDAO.selectClsSubjectList(vo);
    }

    /*****************************************************
     * 수강생 주차별 학습현황 목록 건수를 조회한다.
     * @param ClsStdntVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int selectClsStdntListCnt(ClsStdntVO vo) throws Exception {
        setDefaultWkList(vo);
        return clsDAO.selectClsStdntListCnt(vo);
    }

    /*****************************************************
     * 수강생 주차별 학습현황 목록을 페이징 조회한다.
     * - 주차별 학습상태 목록을 userId 기준으로 묶어 학생 목록에 세팅한다.
     * @param ClsStdntVO
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ClsStdntVO> selectClsStdntListPaging(ClsStdntVO vo) throws Exception {
        ProcessResultVO<ClsStdntVO> out = new ProcessResultVO<>();
        try {
            setDefaultWkList(vo);
            PagingInfo pi = new PagingInfo();
            pi.setCurrentPageNo(vo.getPageIndex());
            pi.setRecordCountPerPage(vo.getListScale());
            pi.setPageSize(vo.getPageScale());
            vo.setFirstIndex(pi.getFirstRecordIndex());
            vo.setLastIndex(pi.getLastRecordIndex());
            int totCnt = clsDAO.selectClsStdntListCnt(vo);
            pi.setTotalRecordCount(totCnt);

            List<ClsStdntVO> list = clsDAO.selectClsStdntListPaging(vo);
            List<ClsWkStsVO> wkStsList = clsDAO.selectClsStdntWkStsList(vo);

            // 주차별 학습상태 목록을 userId 기준으로 묶어 학생 목록에 세팅
            Map<String, List<ClsWkStsVO>> wkStsMap = wkStsList.stream()
                    .collect(Collectors.groupingBy(ClsWkStsVO::getUserId));
            for (ClsStdntVO item : list) {
                item.setWkStsList(wkStsMap.getOrDefault(item.getUserId(), new ArrayList<>()));
            }

            out.setReturnList(list);
            out.setPageInfo(pi);
            out.setResult(1);
        } catch (Exception e) {
            LOGGER.error("[selectClsStdntListPaging] fail, vo={}", vo, e);
            out.setResult(-1);
            out.setMessage("에러가 발생하였습니다.");
        }
        return out;
    }

    /*****************************************************
     * 수강생 주차별 학습현황 전체 목록을 조회한다. (엑셀 다운로드용)
     * - 주차별 학습상태 목록을 userId 기준으로 묶어 학생 목록에 세팅한다.
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsStdntVO> selectClsStdntList(ClsStdntVO vo) throws Exception {
        setDefaultWkList(vo);

        List<ClsStdntVO> list = clsDAO.selectClsStdntList(vo);
        List<ClsWkStsVO> wkStsList = clsDAO.selectClsStdntWkStsList(vo);

        // 주차별 학습상태 목록을 userId 기준으로 묶어 학생 목록에 세팅
        Map<String, List<ClsWkStsVO>> wkStsMap = wkStsList.stream()
                .collect(Collectors.groupingBy(ClsWkStsVO::getUserId));
        for (ClsStdntVO item : list) {
            item.setWkStsList(wkStsMap.getOrDefault(item.getUserId(), new ArrayList<>()));
        }

        return list;
    }

    /*****************************************************
     * 수강생별 주차 학습상태 목록을 조회한다.
     * - selectClsStdntListPaging 조회 후 userId 기준으로 그룹핑하여 세팅한다.
     * @param ClsStdntVO
     * @return List<ClsWkStsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsWkStsVO> selectClsStdntWkStsList(ClsStdntVO vo) throws Exception {
        return clsDAO.selectClsStdntWkStsList(vo);
    }

    /*****************************************************
     * 주차별 미학습자 비율을 조회한다.
     * - 주차별 수업현황 상단의 미학습자 비율 테이블에 사용된다.
     * @param ClsVO
     * @return List<ClsWklyStatsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsWklyStatsVO> selectClsWklyStats(ClsVO vo) throws Exception {
        return clsDAO.selectClsWklyStats(vo);
    }

    /*****************************************************
     * 학습요소 참여현황 목록을 페이징 조회한다.
     * @param ClsElemStatsVO
     * @return ProcessResultVO<ClsElemStatsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ClsElemStatsVO> selectClsElemStatsListPaging(ClsElemStatsVO vo) throws Exception {
        ProcessResultVO<ClsElemStatsVO> out = new ProcessResultVO<>();
        try {
            PagingInfo pi = new PagingInfo();
            pi.setCurrentPageNo(vo.getPageIndex());
            pi.setRecordCountPerPage(vo.getListScale());
            pi.setPageSize(vo.getPageScale());
            vo.setFirstIndex(pi.getFirstRecordIndex());
            vo.setLastIndex(pi.getLastRecordIndex());
            int totCnt = clsDAO.selectClsElemStatsListCnt(vo);
            pi.setTotalRecordCount(totCnt);
            out.setReturnList(clsDAO.selectClsElemStatsListPaging(vo));
            out.setPageInfo(pi);
            out.setResult(1);
        } catch (Exception e) {
            LOGGER.error("[selectClsElemStatsListPaging] fail, vo={}", vo, e);
            out.setResult(-1);
            out.setMessage("에러가 발생하였습니다.");
        }
        return out;
    }

    /*****************************************************
     * 학습요소 참여현황 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsElemStatsVO
     * @return List<ClsElemStatsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsElemStatsVO> selectClsElemStatsListExcelDown(ClsElemStatsVO vo) throws Exception {
        return clsDAO.selectClsElemStatsList(vo);
    }

    /*****************************************************
     * 학습요소 참여현황 목록을 조회한다.
     * @param ClsElemStatsVO
     * @return List<ClsElemStatsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsElemStatsVO> selectClsElemStatsList(ClsElemStatsVO vo) throws Exception {
        return clsDAO.selectClsElemStatsList(vo);
    }

    /*****************************************************
     * 특정 주차 미학습자 목록을 조회한다.
     * - 학습 이력이 없는 수강생(완전 미접속)도 미학습자로 포함한다.
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsStdntVO> selectClsNoStudyWeek(ClsStdntVO vo) throws Exception {
        return clsDAO.selectClsNoStudyWeek(vo);
    }

    /*****************************************************
     * 수강생 상세 정보를 조회한다. (기관/이름/학번/연락처/이메일)
     * @param ClsStdntInfoVO
     * @return ClsStdntInfoVO
     * @throws Exception
     ******************************************************/
    @Override
    public ClsStdntInfoVO selectClsStdntInfo(ClsStdntInfoVO vo) throws Exception {
        return clsDAO.selectClsStdntInfo(vo);
    }

    /*****************************************************
     * 학습자 주차별 출결 단건 정보를 조회한다.
     * @param ClsStdntVO
     * @return ClsStdntVO
     * @throws Exception
     ******************************************************/
    @Override
    public ClsStdntVO selectClsStdntWeeklyInfo(ClsStdntVO vo) throws Exception {
        setDefaultWkList(vo);

        ClsStdntVO result = clsDAO.selectClsStdntWeeklyInfo(vo);
        if (result != null) {
            List<ClsWkStsVO> wkStsList = clsDAO.selectClsStdntWkStsList(vo);
            result.setWkStsList(wkStsList);
        }
        return result;
    }

    /*****************************************************
     * 수강생 일별 강의실 접속현황 차트 데이터를 조회한다.
     * - 지난달 / 해당 학습자 / 전체 평균 세 계열을 반환한다.
     * @param ClsAccessChartVO
     * @return List<ClsAccessChartVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsAccessChartVO> selectStdntAccessChart(ClsAccessChartVO vo) throws Exception {
        return clsDAO.selectStdntAccessChart(vo);
    }

    /*****************************************************
     * 수강생 활동로그를 페이징 조회한다.
     * @param ClsActivityLogVO
     * @return ProcessResultVO<ClsActivityLogVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ClsActivityLogVO> selectStdntActivityLogPaging(ClsActivityLogVO vo) throws Exception {
        ProcessResultVO<ClsActivityLogVO> out = new ProcessResultVO<>();
        try {
            PagingInfo pi = new PagingInfo();
            pi.setCurrentPageNo(vo.getPageIndex());
            pi.setRecordCountPerPage(vo.getListScale());
            pi.setPageSize(vo.getPageScale());
            vo.setFirstIndex(pi.getFirstRecordIndex());
            vo.setLastIndex(pi.getLastRecordIndex());
            int totCnt = clsDAO.selectStdntActivityLogCnt(vo);
            pi.setTotalRecordCount(totCnt);
            out.setReturnList(clsDAO.selectStdntActivityLogPaging(vo));
            out.setPageInfo(pi);
            out.setResult(1);
        } catch (Exception e) {
            LOGGER.error("[selectStdntActivityLogPaging] fail, vo={}", vo, e);
            out.setResult(-1);
            out.setMessage("에러가 발생하였습니다.");
        }
        return out;
    }

    /*****************************************************
     * 수강생 활동로그 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsActivityLogVO
     * @return List<ClsActivityLogVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsActivityLogVO> selectStdntActivityLogList(ClsActivityLogVO vo) throws Exception {
        return clsDAO.selectStdntActivityLogList(vo);
    }

    /*****************************************************
     * 주차별 학습 요약 정보를 조회한다.
     * - 출결상태/학습시간/학습기간/버튼 노출 여부(atndCertUseYn, lastWkYn) 포함
     * @param ClsWkLrnVO
     * @return ClsWkLrnVO
     * @throws Exception
     ******************************************************/
    @Override
    public ClsWkLrnVO selectStdntWkLrnSummary(ClsWkLrnVO vo) throws Exception {
        return clsDAO.selectStdntWkLrnSummary(vo);
    }

    /*****************************************************
     * 주차별 차시 목록을 조회한다.
     * @param ClsWkLrnVO
     * @return List<ClsChsiLrnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsChsiLrnVO> selectStdntChsiLrnList(ClsWkLrnVO vo) throws Exception {
        return clsDAO.selectStdntChsiLrnList(vo);
    }

    /*****************************************************
     * 차시별 3분 단위 학습로그를 조회한다.
     * @param ClsLrnLogVO
     * @return List<ClsLrnLogVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsLrnLogVO> selectStdntLrnLog(ClsLrnLogVO vo) throws Exception {
        return clsDAO.selectStdntLrnLog(vo);
    }

    /*****************************************************
     * 출석 처리를 수행한다. (LRN_STSCD → ATND, 이전값 BFR_LRN_STSCD 에 백업)
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int updateAtndlcProcess(ClsWkLrnVO vo) throws Exception {
        return clsDAO.updateAtndlcProcess(vo);
    }

    /*****************************************************
     * 출석 처리를 취소한다. (LRN_STSCD → BFR_LRN_STSCD 롤백)
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int updateAtndlcCancel(ClsWkLrnVO vo) throws Exception {
        return clsDAO.updateAtndlcCancel(vo);
    }

    /*****************************************************
     * 학습요소 제출 목록을 조회한다. (elemType: ASMT/QUIZ/QNA/SRVY/DSCC)
     * @param ClsWkLrnVO
     * @return List<ClsChsiLrnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsChsiLrnVO> selectStdntElemSbmsnList(ClsWkLrnVO vo) throws Exception {
        return clsDAO.selectStdntElemSbmsnList(vo);
    }

    /*****************************************************
     * 학습요소 제출 이력을 조회한다.
     * - 과제: 파일명/크기, 퀴즈: 점수/정오답, QNA/설문/토론: 내용 요약
     * @param ClsAsmtSbmsnLogVO
     * @return List<ClsAsmtSbmsnLogVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsAsmtSbmsnLogVO> selectStdntElemSbmsnLog(ClsAsmtSbmsnLogVO vo) throws Exception {
        return clsDAO.selectStdntElemSbmsnLog(vo);
    }


    /* ================================================================
       공통 접근 권한 체크
       ================================================================ */

    /*****************************************************
     * 해당 학습자가 과목 수강생인지 확인한다. (0이면 접근 불가)
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int checkClsStdntAccessCnt(ClsWkLrnVO vo) throws Exception {
        return clsDAO.checkClsStdntAccessCnt(vo);
    }

    /*****************************************************
     * 해당 주차 스케줄이 존재하는지 확인한다. (0이면 접근 불가)
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int checkClsWkSchdlAccessCnt(ClsWkLrnVO vo) throws Exception {
        return clsDAO.checkClsWkSchdlAccessCnt(vo);
    }

}