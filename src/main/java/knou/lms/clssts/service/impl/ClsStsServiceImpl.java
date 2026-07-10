package knou.lms.clssts.service.impl;

import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.SecureUtil;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.clssts.dao.ClsStsDAO;
import knou.lms.clssts.service.ClsStsService;
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
 * 수업현황 Service 구현체
 */
@Service("clsStsService")
public class ClsStsServiceImpl extends ServiceBase implements ClsStsService {

    @Resource(name = "clsStsDAO")
    private ClsStsDAO clsDAO;

    /*****************************************************
     * 과목 주차 수를 기준으로 주차 목록 기본값을 설정한다.
     * - wkList 가 비어 있으면 과목 상세를 조회하여 실제 주차 수만큼 세팅한다.
     * - 과목 조회 실패 또는 주차 수 0 이하인 경우 15주를 기본값으로 사용한다.
     * @param ClsStdntVO
     ******************************************************/
    private void setDefaultWkList(ClsStdntVO vo) {
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
     ******************************************************/
    @Override
    public ClsVO selectClsDetail(ClsVO vo) {
        return clsDAO.selectClsDetail(vo);
    }

    /*****************************************************
     * 현재 학년도/학기 정보를 조회한다.
     * @param ClsVO
     * @return ClsVO
     ******************************************************/
    @Override
    public ClsVO selectCurrentTerm(ClsVO vo) {
        return clsDAO.selectCurrentTerm(vo);
    }

    /*****************************************************
     * 수업현황 운영과목 목록 건수를 조회한다.
     * @param ClsVO
     * @return int
     ******************************************************/
    @Override
    public int selectClsListCnt(ClsVO vo) {
        return clsDAO.selectClsListCnt(vo);
    }

    /*****************************************************
     * 수업현황 운영과목 목록을 페이징 조회한다.
     * @param ClsVO
     * @return ProcessResultVO<ClsVO>
     ******************************************************/
    @Override
    public ProcessResultVO<ClsVO> selectClsListPaging(ClsVO vo) {
        ProcessResultVO<ClsVO> out = new ProcessResultVO<>();
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
        out.setResultSuccess();
        return out;
    }

    /*****************************************************
     * 수업현황 운영과목 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsVO
     * @return List<ClsVO>
     ******************************************************/
    @Override
    public List<ClsVO> selectClsList(ClsVO vo) {
        return clsDAO.selectClsList(vo);
    }

    /*****************************************************
     * 교수 운영 기관 목록을 조회한다.
     * @param ClsVO
     * @return List<OrgInfoVO>
     ******************************************************/
    @Override
    public List<OrgInfoVO> selectClsOrgList(ClsVO vo) {
        return clsDAO.selectClsOrgList(vo);
    }

    /*****************************************************
     * 교수 운영 학기 목록을 조회한다.
     * @param ClsVO
     * @return List<SmstrChrtVO>
     ******************************************************/
    @Override
    public List<SmstrChrtVO> selectClsTermList(ClsVO vo) {
        return clsDAO.selectClsTermList(vo);
    }

    /*****************************************************
     * 운영과목 드롭다운 목록을 조회한다.
     * @param ClsVO
     * @return List<ClsVO>
     ******************************************************/
    @Override
    public List<ClsVO> selectClsSubjectList(ClsVO vo) {
        return clsDAO.selectClsSubjectList(vo);
    }

    /*****************************************************
     * 수강생 주차별 학습현황 목록 건수를 조회한다.
     * @param ClsStdntVO
     * @return int
     ******************************************************/
    @Override
    public int selectClsStdntListCnt(ClsStdntVO vo) {
        setDefaultWkList(vo);
        return clsDAO.selectClsStdntListCnt(vo);
    }

    /*****************************************************
     * 수강생 주차별 학습현황 목록을 페이징 조회한다.
     * - 주차별 학습상태 목록을 userId 기준으로 묶어 학생 목록에 세팅한다.
     * @param ClsStdntVO
     * @return ProcessResultVO<ClsStdntVO>
     ******************************************************/
    @Override
    public ProcessResultVO<ClsStdntVO> selectClsStdntListPaging(ClsStdntVO vo) {
        ProcessResultVO<ClsStdntVO> out = new ProcessResultVO<>();
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
        out.setResultSuccess();
        return out;
    }

    /*****************************************************
     * 수강생 주차별 학습현황 전체 목록을 조회한다. (엑셀 다운로드용)
     * - 주차별 학습상태 목록을 userId 기준으로 묶어 학생 목록에 세팅한다.
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     ******************************************************/
    @Override
    public List<ClsStdntVO> selectClsStdntList(ClsStdntVO vo) {
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
     ******************************************************/
    @Override
    public List<ClsWkStsVO> selectClsStdntWkStsList(ClsStdntVO vo) {
        return clsDAO.selectClsStdntWkStsList(vo);
    }

    /*****************************************************
     * 주차별 미학습자 비율을 조회한다.
     * - 주차별 수업현황 상단의 미학습자 비율 테이블에 사용된다.
     * @param ClsVO
     * @return List<ClsWklyStatsVO>
     ******************************************************/
    @Override
    public List<ClsWklyStatsVO> selectClsWklyStats(ClsVO vo) {
        return clsDAO.selectClsWklyStats(vo);
    }

    /*****************************************************
     * 학습요소 참여현황 목록을 페이징 조회한다.
     * @param ClsElemStatsVO
     * @return ProcessResultVO<ClsElemStatsVO>
     ******************************************************/
    @Override
    public ProcessResultVO<ClsElemStatsVO> selectClsElemStatsListPaging(ClsElemStatsVO vo) {
        ProcessResultVO<ClsElemStatsVO> out = new ProcessResultVO<>();
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
        out.setResultSuccess();
        return out;
    }

    /*****************************************************
     * 학습요소 참여현황 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsElemStatsVO
     * @return List<ClsElemStatsVO>
     ******************************************************/
    @Override
    public List<ClsElemStatsVO> selectClsElemStatsListExcelDown(ClsElemStatsVO vo) {
        return clsDAO.selectClsElemStatsList(vo);
    }

    /*****************************************************
     * 학습요소 참여현황 목록을 조회한다.
     * @param ClsElemStatsVO
     * @return List<ClsElemStatsVO>
     ******************************************************/
    @Override
    public List<ClsElemStatsVO> selectClsElemStatsList(ClsElemStatsVO vo) {
        return clsDAO.selectClsElemStatsList(vo);
    }

    /*****************************************************
     * 특정 주차 미학습자 목록을 조회한다.
     * - 학습 이력이 없는 수강생(완전 미접속)도 미학습자로 포함한다.
     * @param ClsStdntVO
     * @return List<ClsStdntVO>
     ******************************************************/
    @Override
    public List<ClsStdntVO> selectClsNoStudyWeek(ClsStdntVO vo) {
        return clsDAO.selectClsNoStudyWeek(vo);
    }

    /*****************************************************
     * 수강생 상세 정보를 조회한다. (기관/이름/학번/연락처/이메일)
     * @param ClsStdntInfoVO
     * @return ClsStdntInfoVO
     ******************************************************/
    @Override
    public ClsStdntInfoVO selectClsStdntInfo(ClsStdntInfoVO vo) {
        return clsDAO.selectClsStdntInfo(vo);
    }

    /*****************************************************
     * 학습자 주차별 출결 단건 정보를 조회한다.
     * @param ClsStdntVO
     * @return ClsStdntVO
     ******************************************************/
    @Override
    public ClsStdntVO selectClsStdntWeeklyInfo(ClsStdntVO vo) {
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
     ******************************************************/
    @Override
    public List<ClsAccessChartVO> selectStdntAccessChart(ClsAccessChartVO vo) {
        return clsDAO.selectStdntAccessChart(vo);
    }

    /*****************************************************
     * 수강생 활동로그를 페이징 조회한다.
     * @param ClsActivityLogVO
     * @return ProcessResultVO<ClsActivityLogVO>
     ******************************************************/
    @Override
    public ProcessResultVO<ClsActivityLogVO> selectStdntActivityLogPaging(ClsActivityLogVO vo) {
        ProcessResultVO<ClsActivityLogVO> out = new ProcessResultVO<>();
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
        out.setResultSuccess();
        return out;
    }

    /*****************************************************
     * 수강생 활동로그 전체 목록을 조회한다. (엑셀 다운로드용)
     * @param ClsActivityLogVO
     * @return List<ClsActivityLogVO>
     ******************************************************/
    @Override
    public List<ClsActivityLogVO> selectStdntActivityLogList(ClsActivityLogVO vo) {
        return clsDAO.selectStdntActivityLogList(vo);
    }

    /*****************************************************
     * 주차별 학습 요약 정보를 조회한다.
     * - 출결상태/학습시간/학습기간/버튼 노출 여부(atndCertUseYn, lastWkYn) 포함
     * @param ClsWkLrnVO
     * @return ClsWkLrnVO
     ******************************************************/
    @Override
    public ClsWkLrnVO selectStdntWkLrnSummary(ClsWkLrnVO vo) {
        return clsDAO.selectStdntWkLrnSummary(vo);
    }

    /*****************************************************
     * 주차별 차시 목록을 조회한다.
     * @param ClsWkLrnVO
     * @return List<ClsChsiLrnVO>
     ******************************************************/
    @Override
    public List<ClsChsiLrnVO> selectStdntChsiLrnList(ClsWkLrnVO vo) {
        return clsDAO.selectStdntChsiLrnList(vo);
    }

    /*****************************************************
     * 차시별 3분 단위 학습로그를 조회한다.
     * @param ClsLrnLogVO
     * @return List<ClsLrnLogVO>
     ******************************************************/
    @Override
    public List<ClsLrnLogVO> selectStdntLrnLog(ClsLrnLogVO vo) {
        return clsDAO.selectStdntLrnLog(vo);
    }

    /*****************************************************
     * 출석 처리를 수행한다. (LRN_STSCD → CMPTN, 이전값 BFR_LRN_STSCD 에 백업)
     * @param ClsWkLrnVO
     * @return int
     ******************************************************/
    @Override
    public int updateAtndlcProcess(ClsWkLrnVO vo) {
        return clsDAO.updateAtndlcProcess(vo);
    }

    /*****************************************************
     * 출석 처리를 취소한다. (LRN_STSCD → BFR_LRN_STSCD 롤백)
     * @param ClsWkLrnVO
     * @return int
     ******************************************************/
    @Override
    public int updateAtndlcCancel(ClsWkLrnVO vo) {
        return clsDAO.updateAtndlcCancel(vo);
    }

    /*****************************************************
     * 학습요소 제출 목록을 조회한다. (elemType: ASMT/QUIZ/QNA/SRVY/DSCS)
     * @param ClsWkLrnVO
     * @return List<ClsChsiLrnVO>
     ******************************************************/
    @Override
    public List<ClsChsiLrnVO> selectStdntElemSbmsnList(ClsWkLrnVO vo) {
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
        List<ClsAsmtSbmsnLogVO> list = clsDAO.selectStdntElemSbmsnLog(vo);
        setDownloadEncParam(list);
        return list;
    }

    /**
     * 과제 첨부파일이 있는 제출 이력에 공통 다운로드 암호화 파라미터를 세팅한다.
     *
     * @param list
     * @throws Exception
     */
    private void setDownloadEncParam(List<ClsAsmtSbmsnLogVO> list) throws Exception {
        if (list == null || list.isEmpty()) {
            return;
        }

        Date expireDate = Date.from(new Date().toInstant().plus(1, ChronoUnit.HOURS));
        String downDttm = DateTimeUtil.dateToString(expireDate, "yyyyMMddHHmmss");

        for (ClsAsmtSbmsnLogVO logVO : list) {
            if (!hasText(logVO.getFileNm()) || !hasText(logVO.getFileSavnm()) || !hasText(logVO.getFilePath())) {
                continue;
            }

            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("filenm", logVO.getFileNm());
            paramMap.put("fileSavnm", logVO.getFileSavnm());
            paramMap.put("filePath", logVO.getFilePath());
            paramMap.put("downDttm", downDttm);
            logVO.setEncDownParam(SecureUtil.encodeStr(JsonUtil.getJsonStringFromMap(paramMap).toString()));
        }
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    /* ================================================================
       공통 접근 권한 체크
       ================================================================ */

    /*****************************************************
     * 해당 학습자가 과목 수강생인지 확인한다. (0이면 접근 불가)
     * @param ClsWkLrnVO
     * @return int
     ******************************************************/
    @Override
    public int checkClsStdntAccessCnt(ClsWkLrnVO vo) {
        return clsDAO.checkClsStdntAccessCnt(vo);
    }

    /*****************************************************
     * 해당 주차 스케줄이 존재하는지 확인한다. (0이면 접근 불가)
     * @param ClsWkLrnVO
     * @return int
     ******************************************************/
    @Override
    public int checkClsWkSchdlAccessCnt(ClsWkLrnVO vo) {
        return clsDAO.checkClsWkSchdlAccessCnt(vo);
    }
}
