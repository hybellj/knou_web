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

@Service("clsService")
public class ClsServiceImpl extends ServiceBase implements ClsService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ClsServiceImpl.class);

    @Resource(name = "clsDAO")
    private ClsDAO clsDAO;

    /*****************************************************
     * 주차 필터가 없을 때 기본 주차 목록을 설정한다.
     * @param ClsStdntVO
     ******************************************************/
    private void setDefaultWkList(ClsStdntVO vo) {
        if (vo.getWkList() == null || vo.getWkList().isEmpty()) {
            vo.setWkList(IntStream.rangeClosed(1, 15).boxed().collect(Collectors.toList()));
        }
    }

    /*****************************************************
     * 과목 상세 정보를 조회한다.
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
     * 전체 수업현황 목록 건수를 조회한다.
     * @param ClsVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int selectClsListCnt(ClsVO vo) throws Exception {
        return clsDAO.selectClsListCnt(vo);
    }

    /*****************************************************
     * 전체 수업현황 목록을 조회한다.
     * @param ClsVO
     * @return List<ClsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsVO> selectClsList(ClsVO vo) throws Exception {
        return clsDAO.selectClsList(vo);
    }

    /*****************************************************
     * 전체 수업현황 목록을 페이징 조회한다.
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
            // 페이징 조회 실패 로그 출력
            LOGGER.error("[selectClsListPaging] fail, vo={}", vo, e);
            out.setResult(-1);
            out.setMessage("에러가 발생하였습니다.");
        }
        return out;
    }

    /*****************************************************
     * 운영 과목 드롭다운 목록을 조회한다.
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
     * 수강생 주차별 학습현황 목록을 조회한다.
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsStdntVO> selectClsStdntList(ClsStdntVO vo) throws Exception {
        setDefaultWkList(vo);

        List<ClsStdntVO> list = clsDAO.selectClsStdntList(vo);
        List<ClsWkStsVO> wkStsList = clsDAO.selectClsStdntWkStsList(vo);

        Map<String, List<ClsWkStsVO>> wkStsMap = wkStsList.stream()
                .collect(Collectors.groupingBy(ClsWkStsVO::getUserId));

        for (ClsStdntVO item : list) {
            item.setWkStsList(wkStsMap.getOrDefault(item.getUserId(), new ArrayList<>()));
        }

        return list;
    }

    /*****************************************************
     * 수강생 주차별 학습현황 목록을 페이징 조회한다.
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

            Map<String, List<ClsWkStsVO>> wkStsMap = wkStsList.stream()
                    .collect(Collectors.groupingBy(ClsWkStsVO::getUserId));

            for (ClsStdntVO item : list) {
                item.setWkStsList(wkStsMap.getOrDefault(item.getUserId(), new ArrayList<>()));
            }
            // 주차별 학습상태 목록을 userId 기준으로 묶어 학생 목록에 세팅
            out.setReturnList(list);
            out.setPageInfo(pi);
            out.setResult(1);
        } catch (Exception e) {
            // 페이징 조회 실패 로그 출력
            LOGGER.error("[selectClsStdntListPaging] fail, vo={}", vo, e);
            out.setResult(-1);
            out.setMessage("에러가 발생하였습니다.");
        }
        return out;
    }

    /*****************************************************
     * 주차별 미학습 비율을 조회한다.
     * @param ClsVO
     * @return List<ClsWklyStatsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsWklyStatsVO> selectClsWklyStats(ClsVO vo) throws Exception {
        return clsDAO.selectClsWklyStats(vo);
    }

    /*****************************************************
     * 특정 주차 미학습자 목록을 조회한다.
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsStdntVO> selectClsNoStudyWeek(ClsStdntVO vo) throws Exception {
        return clsDAO.selectClsNoStudyWeek(vo);
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
     * 학습요소 참여현황 전체 목록을 조회한다.
     * @param ClsElemStatsVO
     * @return List<ClsElemStatsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsElemStatsVO> selectClsElemStatsListExcelDown(ClsElemStatsVO vo) throws Exception {
        return clsDAO.selectClsElemStatsList(vo);
    }

    /*****************************************************
     * 수강생별 주차 학습상태 목록을 조회한다.
     * @param ClsStdntVO
     * @return List<ClsWkStsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsWkStsVO> selectClsStdntWkStsList(ClsStdntVO vo) throws Exception {
        return clsDAO.selectClsStdntWkStsList(vo);
    }

    /*****************************************************
     * 수강생 상세 정보를 조회한다.
     * @param ClsStdntInfoVO
     * @return ClsStdntInfoVO
     * @throws Exception
     ******************************************************/
    @Override
    public ClsStdntInfoVO selectClsStdntInfo(ClsStdntInfoVO vo) throws Exception {
        return clsDAO.selectClsStdntInfo(vo);
    }

    /*****************************************************
     * 수강생 접속현황 차트 데이터를 조회한다.
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
            // 페이징 조회 실패 로그 출력
            LOGGER.error("[selectStdntActivityLogPaging] fail, vo={}", vo, e);
            out.setResult(-1);
            out.setMessage("에러가 발생하였습니다.");
        }
        return out;
    }

    /*****************************************************
     * 수강생 활동로그 전체 목록을 조회한다.
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
     * @param ClsWkLrnVO
     * @return ClsWkLrnVO
     * @throws Exception
     ******************************************************/
    @Override
    public ClsWkLrnVO selectStdntWkLrnSummary(ClsWkLrnVO vo) throws Exception {
        return clsDAO.selectStdntWkLrnSummary(vo);
    }

    /*****************************************************
     * 학습 항목 목록을 조회한다.
     * @param ClsWkLrnVO
     * @return List<ClsChsiLrnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsChsiLrnVO> selectStdntChsiLrnList(ClsWkLrnVO vo) throws Exception {
        return clsDAO.selectStdntChsiLrnList(vo);
    }

    /*****************************************************
     * 학습 로그를 조회한다.
     * @param ClsLrnLogVO
     * @return List<ClsLrnLogVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsLrnLogVO> selectStdntLrnLog(ClsLrnLogVO vo) throws Exception {
        return clsDAO.selectStdntLrnLog(vo);
    }

    /*****************************************************
     * 출석 처리를 수행한다.
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int updateAtndlcProcess(ClsWkLrnVO vo) throws Exception {
        return clsDAO.updateAtndlcProcess(vo);
    }

    /*****************************************************
     * 출석 처리를 취소한다.
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int updateAtndlcCancel(ClsWkLrnVO vo) throws Exception {
        return clsDAO.updateAtndlcCancel(vo);
    }

    /*****************************************************
     * 학습요소 제출 목록을 조회한다.
     * @param ClsWkLrnVO
     * @return List<ClsChsiLrnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsChsiLrnVO> selectStdntElemSbmsnList(ClsWkLrnVO vo) throws Exception {
        return clsDAO.selectStdntElemSbmsnList(vo);
    }

    /*****************************************************
     * 학습요소 제출 로그를 조회한다.
     * @param ClsAsmtSbmsnLogVO
     * @return List<ClsAsmtSbmsnLogVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ClsAsmtSbmsnLogVO> selectStdntElemSbmsnLog(ClsAsmtSbmsnLogVO vo) throws Exception {
        return clsDAO.selectStdntElemSbmsnLog(vo);
    }

    /*****************************************************
     * 학습자 주차별 학습현황 단건 정보를 조회한다.
     * @param ClsStdntVO
     * @return ClsStdntVO
     * @throws Exception
     ******************************************************/
    @Override
    public ClsStdntVO selectClsStdntWeeklyInfo(ClsStdntVO vo) throws Exception {
        // 주차 리스트 기본값 설정
        setDefaultWkList(vo);
        return clsDAO.selectClsStdntWeeklyInfo(vo);
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
            // 페이징 조회 실패 로그 출력
            LOGGER.error("[selectClsElemStatsListPaging] fail, vo={}", vo, e);
            out.setResult(-1);
            out.setMessage("에러가 발생하였습니다.");
        }
        return out;
    }

    /*****************************************************
     * cls 학생 접근 가능 여부를 체크한다.
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int checkClsStdntAccessCnt(ClsWkLrnVO vo) throws Exception {
        return clsDAO.checkClsStdntAccessCnt(vo);
    }

    /*****************************************************
     * cls 주차 스케줄 접근 가능 여부를 체크한다.
     * @param ClsWkLrnVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int checkClsWkSchdlAccessCnt(ClsWkLrnVO vo) throws Exception {
        return clsDAO.checkClsWkSchdlAccessCnt(vo);
    }
}