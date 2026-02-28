package knou.lms.std.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.exception.ServiceProcessException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.asmt.vo.AsmtVO;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.erp.daoErp.ErpDAO;
import knou.lms.erp.vo.ErpEnrollmentVO;
import knou.lms.exam.service.ExamStareService;
import knou.lms.exam.vo.ExamVO;
import knou.lms.lesson.dao.LessonScheduleDAO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.std.dao.StdDAO;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.LearnStopRiskIndexVO;
import knou.lms.std.vo.StdVO;
import knou.lms.user.dao.UsrUserInfoDAO;
import knou.lms.user.vo.UsrUserInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;
import java.util.stream.Collectors;

@Service("stdService")
public class StdServiceImpl extends ServiceBase implements StdService {

    private static final Logger LOGGER = LoggerFactory.getLogger(StdServiceImpl.class);

    @Resource(name="stdDAO")
    private StdDAO stdDAO;

    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;

    @Resource(name="examStareService")
    private ExamStareService examStareService;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="erpDAO")
    private ErpDAO erpDAO;

    @Resource(name="usrUserInfoDAO")
    private UsrUserInfoDAO usrUserInfoDAO;

    /*****************************************************
     * <p>
     *학습자 정보 조회
     *
     * @param StdVO
     * @return StdVO
     * @throws Exception
     ******************************************************/
    @Override
    public StdVO select(StdVO vo) throws Exception {
        return stdDAO.select(vo);
    }

    /*****************************************************
     * <p>
     *학습자 목록 조회
     *
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<StdVO> list(StdVO vo) throws Exception {
        return stdDAO.list(vo);
    }

    /*****************************************************
     * </p>
     * 학습자 목록 조회 페이징
     *
     * @param StdVO
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<StdVO> listPageing(StdVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<StdVO> examList = stdDAO.listPageing(vo);

        if(examList.size() > 0) {
            paginationInfo.setTotalRecordCount(examList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<StdVO>();

        resultVO.setReturnList(examList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    // 해당과목 학습자 수
    @Override
    public int count(StdVO vo) throws Exception {
        return stdDAO.count(vo);
    }

    // 수강생 목록
    @Override
    public ProcessResultVO<StdVO> stdList(StdVO vo) throws Exception {
        ProcessResultVO<StdVO> resultList = new ProcessResultVO<StdVO>();
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        if(!"".equals(StringUtil.nvl(vo.getSearchKey()))) {
            vo.setSqlForeach(StringUtil.split(StringUtil.nvl(vo.getSearchKey(), ""), ","));
        }

        List<StdVO> teamList = stdDAO.stdList(vo);
        resultList.setReturnList(teamList);
        resultList.setPageInfo(paginationInfo);

        return resultList;
    }

    /*****************************************************
     * 강의실 학생 조회
     * @param StdVO
     * @return StdVO
     * @throws Exception
     ******************************************************/
    @Override
    public StdVO selectStd(StdVO vo) throws Exception {
        return stdDAO.selectStd(vo);
    }

    /*****************************************************
     * 수강정보 > 수강생 정보 목록
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<StdVO> listStudentInfo(StdVO vo) throws Exception {
        return stdDAO.listStudentInfo(vo);
    }

    /*****************************************************
     * 수강정보 > 수강생 정보 목록 페이징
     * @param StdVO
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<StdVO> listStudentInfoPaging(StdVO vo) throws Exception {
        ProcessResultVO<StdVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        if("".equals(StringUtil.nvl(vo.getOrgId()))) {
            vo.setOrgId(CommConst.KNOU_ORG_ID);
        }

        int totCnt = stdDAO.countStudentInfo(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<StdVO> resultList = stdDAO.listStudentInfoPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 수강정보 > 장애학생 정보 목록 페이징
     * @param StdVO
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<StdVO> listDisablilityStudentInfoPaging(StdVO vo) throws Exception {
        ProcessResultVO<StdVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = stdDAO.countDisablilityStudentInfo(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<StdVO> resultList = stdDAO.listDisablilityStudentInfoPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 수강정보 > 수강생 정보 엑셀 리스트
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listStudentInfoExcel(StdVO vo) throws Exception {
        return stdDAO.listStudentInfoExcel(vo);
    }

    /*****************************************************
     * 수강생 학습현황 > 이전, 다음 수강생 정보
     * @param StdVO
     * @return StdVO
     * @throws Exception
     ******************************************************/
    @Override
    public StdVO prevNextStudentInfo(StdVO vo) throws Exception {
        return stdDAO.prevNextStudentInfo(vo);
    }

    /*****************************************************
     * 수강생 학습현황 > 수강생 정보
     * @param StdVO
     * @return StdVO
     * @throws Exception
     ******************************************************/
    @Override
    public StdVO selectStudentInfo(StdVO vo) throws Exception {
        return stdDAO.selectStudentInfo(vo);
    }

    /*****************************************************
     * 강의실 학습요소 참여현황 목록
     * @param StdVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listStdJoinStatus(StdVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();

        List<EgovMap> listStdJoinStatus = stdDAO.listStdJoinStatus(vo);

        try {
            // 학생 시험점수 조회
            ExamVO examVO = new ExamVO();
            examVO.setCrsCreCd(crsCreCd);

            // stdNo ',' 구분자 설정
            String[] stdNoList = new String[listStdJoinStatus.size()];
            String stdNos;

            for(int i = 0; i < listStdJoinStatus.size(); i++) {
                stdNoList[i] = listStdJoinStatus.get(i).get("stdNo").toString();
            }

            stdNos = String.join(",", stdNoList);

            examVO.setStdIds(stdNos);

            // 학생 시험 점수 목록 조회
            List<EgovMap> listExamStareStatus = examStareService.listExamStareStatus(examVO);
            Map<String, String> midExamScoreMap = new HashMap<>();     // 중간
            Map<String, String> finalExamScoreMap = new HashMap<>();   // 기말

            Map<String, String> midScoreMap = new HashMap<>();         // 중간 (실시간)
            Map<String, String> midReplaceScoreMap = new HashMap<>();  // 중간 (대체)
            Map<String, String> midEtcScoreMap = new HashMap<>();      // 중간 (기타)
            Map<String, String> endScoreMap = new HashMap<>();         // 기말 (실시간)
            Map<String, String> endReplaceScoreMap = new HashMap<>();  // 기말 (대체)
            Map<String, String> endEtcScoreMap = new HashMap<>();      // 기말 (기타)

            // 학생별 시험점수 get
            for(EgovMap map : listExamStareStatus) {
                String stdNo = map.get("stdNo").toString();

                // 중간점수
                String midScore = map.get("midScore").toString();
                String midReplaceScore = map.get("midReplaceScore").toString();
                String midEtcScore = map.get("midEtcScore").toString();

                // 기말점수
                String endScore = map.get("endScore").toString();
                String endReplaceScore = map.get("endReplaceScore").toString();
                String endEtcScore = map.get("endEtcScore").toString();

                // 중간점수 1개 선택
                if(!"-".equals(StringUtil.nvl(midScore))) {
                    // 실시간
                    midExamScoreMap.put(stdNo, midScore);
                } else if(!"-".equals(StringUtil.nvl(midReplaceScore))) {
                    // 대체
                    midExamScoreMap.put(stdNo, midReplaceScore);
                } else if(!"-".equals(StringUtil.nvl(midEtcScore))) {
                    // 기타
                    midExamScoreMap.put(stdNo, midEtcScore);
                }

                // 기말점수 1개 선택
                if(!"-".equals(StringUtil.nvl(endScore))) {
                    // 실시간
                    finalExamScoreMap.put(stdNo, endScore);
                } else if(!"-".equals(StringUtil.nvl(endReplaceScore))) {
                    // 대체
                    finalExamScoreMap.put(stdNo, endReplaceScore);
                } else if(!"-".equals(StringUtil.nvl(endEtcScore))) {
                    // 기타
                    finalExamScoreMap.put(stdNo, endEtcScore);
                }

                // 중간(실시간, 대체, 기타)
                midScoreMap.put(stdNo, midScore);
                midReplaceScoreMap.put(stdNo, midReplaceScore);
                midEtcScoreMap.put(stdNo, midEtcScore);

                // 기말(실시간, 대체, 기타)
                endScoreMap.put(stdNo, endScore);
                endReplaceScoreMap.put(stdNo, endReplaceScore);
                endEtcScoreMap.put(stdNo, endEtcScore);
            }

            // 학생별 시험점수 set
            for(EgovMap joinStatusMap : listStdJoinStatus) {
                String stdNo = joinStatusMap.get("stdNo").toString();

                // 중간고사 점수 세팅
                if(midExamScoreMap.containsKey(stdNo)) {
                    joinStatusMap.put("midExamScore", midExamScoreMap.get(stdNo));
                } else {
                    joinStatusMap.put("midExamScore", "-");
                }

                // 기말고사 점수 세팅
                if(finalExamScoreMap.containsKey(stdNo)) {
                    joinStatusMap.put("finalExamScore", finalExamScoreMap.get(stdNo));
                } else {
                    joinStatusMap.put("finalExamScore", "-");
                }

                // 중간 (실시간)
                if(midScoreMap.containsKey(stdNo)) {
                    joinStatusMap.put("midScore", midScoreMap.get(stdNo));
                } else {
                    joinStatusMap.put("midScore", "-");
                }
                // 중간 (대체)
                if(midReplaceScoreMap.containsKey(stdNo)) {
                    joinStatusMap.put("midReplaceScore", midReplaceScoreMap.get(stdNo));
                } else {
                    joinStatusMap.put("midReplaceScore", "-");
                }
                // 중간 (기타)
                if(midEtcScoreMap.containsKey(stdNo)) {
                    joinStatusMap.put("midEtcScore", midEtcScoreMap.get(stdNo));
                } else {
                    joinStatusMap.put("midEtcScore", "-");
                }

                // 기말 (실시간)
                if(endScoreMap.containsKey(stdNo)) {
                    joinStatusMap.put("endScore", endScoreMap.get(stdNo));
                } else {
                    joinStatusMap.put("endScore", "-");
                }
                // 기말 (대체)
                if(endReplaceScoreMap.containsKey(stdNo)) {
                    joinStatusMap.put("endReplaceScore", endReplaceScoreMap.get(stdNo));
                } else {
                    joinStatusMap.put("endReplaceScore", "-");
                }
                // 기말 (기타)
                if(endEtcScoreMap.containsKey(stdNo)) {
                    joinStatusMap.put("endEtcScore", endEtcScoreMap.get(stdNo));
                } else {
                    joinStatusMap.put("endEtcScore", "-");
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
            LOGGER.debug("시험 정보가 없음");
        }

        return listStdJoinStatus;
    }

    /*****************************************************
     * 주차별 학생 출석현황
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     ******************************************************/
    public List<StdVO> listAttendByLessonSchedule(StdVO vo) throws Exception {
        return stdDAO.listAttendByLessonSchedule(vo);
    }

    /*****************************************************
     * 강의실 출석현황
     * @param StdVO
     * @return List<Map<String, Object>>
     * @throws Exception
     ******************************************************/
    @Override
    public List<Map<String, Object>> listAttend(StdVO vo) throws Exception {
        // 과목의 주차 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(vo.getCrsCreCd());
        List<LessonScheduleVO> listLessonSchedule = lessonScheduleDAO.list(lessonScheduleVO);

        List<String> listLessonScheduleId = new ArrayList<>();
        // 결석 주차용
        List<String> listLessonScheduleId2 = new ArrayList<>();

        for(LessonScheduleVO lessonScheduleVO2 : listLessonSchedule) {
            String examStareTypeCd = lessonScheduleVO2.getExamStareTypeCd();

            // 결석 주차 선택시 해당 주차 체크
            if(!"".equals(StringUtil.nvl(vo.getSearchTo())) && !"".equals(StringUtil.nvl(vo.getSearchFrom()))) {
                boolean isTrue = lessonScheduleVO2.getLessonScheduleOrder() >= Integer.parseInt(vo.getSearchTo()) && lessonScheduleVO2.getLessonScheduleOrder() <= Integer.parseInt(vo.getSearchFrom());
                if("".equals(StringUtil.nvl(examStareTypeCd)) && isTrue) {
                    String lessonScheduleId = lessonScheduleVO2.getLessonScheduleId();
                    listLessonScheduleId2.add(lessonScheduleId);
                }
            }
            // 시험기간 제외
            if("".equals(StringUtil.nvl(examStareTypeCd))) {
                String lessonScheduleId = lessonScheduleVO2.getLessonScheduleId();
                listLessonScheduleId.add(lessonScheduleId);
            }
        }

        if(listLessonScheduleId.size() > 0) {
            vo.setSqlForeach(listLessonScheduleId.toArray(new String[listLessonScheduleId.size()]));
        }
        if(listLessonScheduleId2.size() > 0) {
            vo.setSqlForeach2(listLessonScheduleId2.toArray(new String[listLessonScheduleId2.size()]));
        }

        return stdDAO.listAttend(vo);
    }

    /*****************************************************
     * 강의실 출석현황 (엑셀)
     * @param StdVO
     * @return List<Map<String, Object>>
     * @throws Exception
     ******************************************************/
    public List<Map<String, Object>> listAttendExcel(StdVO vo) throws Exception {
        // 과목의 주차 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(vo.getCrsCreCd());
        List<LessonScheduleVO> listLessonSchedule = lessonScheduleDAO.list(lessonScheduleVO);

        List<String> listLessonScheduleId = new ArrayList<>();

        for(LessonScheduleVO lessonScheduleVO2 : listLessonSchedule) {
            String lessonScheduleId = lessonScheduleVO2.getLessonScheduleId();
            String startDtYn = lessonScheduleVO2.getStartDtYn();
            String wekClsfGbn = lessonScheduleVO2.getWekClsfGbn();
            boolean isExam = "04".equals(wekClsfGbn) || "05".equals(wekClsfGbn); // 시험 주차
            boolean isSeminar = "02".equals(wekClsfGbn) || "03".equals(wekClsfGbn); // 세미나 주차
            int prgrVideoCnt = lessonScheduleVO2.getPrgrVideoCnt(); // 출결체크 동영상 강의

            /// 진행 주차만 체크, 시험기간 제외, 세미나 주차 or 출결체크 동영강 강의 주차
            if("Y".equals(startDtYn) && !isExam && (isSeminar || prgrVideoCnt > 0)) {
                listLessonScheduleId.add(lessonScheduleId);
            }
        }

        if(listLessonScheduleId.size() > 0) {
            vo.setSqlForeach(listLessonScheduleId.toArray(new String[listLessonScheduleId.size()]));
        }

        List<Map<String, Object>> list = stdDAO.listAttend(vo);

        for(Map<String, Object> map : list) {
            int completeCnt = 0;
            int lateCnt = 0;
            int noStudyCnt = 0;

            for(LessonScheduleVO lessonScheduleVO3 : listLessonSchedule) {
                String lessonScheduleId = lessonScheduleVO3.getLessonScheduleId();

                String startDtYn = lessonScheduleVO3.getStartDtYn();
                String endDtYn = lessonScheduleVO3.getEndDtYn();
                String wekClsfGbn = lessonScheduleVO3.getWekClsfGbn();
                boolean isExam = "04".equals(wekClsfGbn) || "05".equals(wekClsfGbn); // 시험 주차
                boolean isSeminar = "02".equals(wekClsfGbn) || "03".equals(wekClsfGbn); // 세미나 주차
                int prgrVideoCnt = lessonScheduleVO3.getPrgrVideoCnt(); // 출결체크 동영상 강의

                String key = "stuSttCd" + convertLessonScheduleId(lessonScheduleId);
                String studyStatusCd = StringUtil.nvl(map.get(key));
                String studyStatusIconId = "studyStatusIcon" + convertLessonScheduleId(lessonScheduleId);

                if(isExam) {
                    map.put(studyStatusIconId, "-");
                } else {
                    if(prgrVideoCnt == 0 && !isSeminar) {
                        if("Y".equals(startDtYn)) {
                            map.put(studyStatusIconId, "-");
                        } else {
                            map.put(studyStatusIconId, "/");
                        }
                    } else if("COMPLETE".equals(studyStatusCd)) {
                        map.put(studyStatusIconId, "○");
                        completeCnt++;
                    } else if("LATE".equals(studyStatusCd)) {
                        map.put(studyStatusIconId, "△");
                        lateCnt++;
                    } else {
                        if("N".equals(startDtYn)) {
                            map.put(studyStatusIconId, "/");
                        } else if("Y".equals(startDtYn) && "N".equals(endDtYn)) {
                            map.put(studyStatusIconId, "-");
                        } else {
                            map.put(studyStatusIconId, "☓");
                            noStudyCnt++;
                        }
                    }
                }
            }

            map.put("completeCnt", completeCnt);
            map.put("lateCnt", lateCnt);
            map.put("noStudyCnt", noStudyCnt);
        }

        return list;
    }

    /*****************************************************
     * 주차별 미학습자 비율
     * @param StdVO
     * @return Map<String, Object>
     * @throws Exception
     ******************************************************/
    @Override
    public Map<String, Object> noAttendRateByWeek(StdVO vo) throws Exception {
        // 과목의 주차 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(vo.getCrsCreCd());
        List<LessonScheduleVO> listLessonSchedule = lessonScheduleDAO.list(lessonScheduleVO);

        List<String> listLessonScheduleId = new ArrayList<>();

        for(LessonScheduleVO lessonScheduleVO2 : listLessonSchedule) {
            String startDtYn = lessonScheduleVO2.getStartDtYn();
            String examStareTypeCd = lessonScheduleVO2.getExamStareTypeCd();

            // 시작된 주차만 체크, 시험기간 제외
            if("Y".equals(startDtYn) && "".equals(StringUtil.nvl(examStareTypeCd))) {
                String lessonScheduleId = lessonScheduleVO2.getLessonScheduleId();
                listLessonScheduleId.add(lessonScheduleId);
            }
        }

        Map<String, Object> map = null;
        if(listLessonScheduleId.size() > 0) {
            vo.setSqlForeach(listLessonScheduleId.toArray(new String[listLessonScheduleId.size()]));
            map = stdDAO.noAttendRateByWeek(vo);
        }

        return map;
    }

    /*****************************************************
     * 주차 미학습자 목록
     * @param StdVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listNoStudyWeek(StdVO vo) throws Exception {
        return stdDAO.listNoStudyWeek(vo);
    }

    /*****************************************************
     * 학생 학습 진도율
     * @param StdVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectStdLessonProgress(StdVO vo) throws Exception {
        // 과목의 주차 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(vo.getCrsCreCd());
        List<LessonScheduleVO> listLessonSchedule = lessonScheduleDAO.list(lessonScheduleVO);

        List<String> listLessonScheduleId = new ArrayList<>();

        for(LessonScheduleVO lessonScheduleVO2 : listLessonSchedule) {
            String startDtYn = lessonScheduleVO2.getStartDtYn();
            String wekClsfGbn = lessonScheduleVO2.getWekClsfGbn();
            boolean isExam = "04".equals(wekClsfGbn) || "05".equals(wekClsfGbn); // 시험 주차
            boolean isSeminar = "02".equals(wekClsfGbn) || "03".equals(wekClsfGbn); // 세미나 주차
            int prgrVideoCnt = lessonScheduleVO2.getPrgrVideoCnt(); // 출결체크 동영상 강의

            // 시작된 주차만 체크, 시험기간 제외
            if("Y".equals(startDtYn) && !isExam && (isSeminar || prgrVideoCnt > 0)) {
                String lessonScheduleId = lessonScheduleVO2.getLessonScheduleId();
                listLessonScheduleId.add(lessonScheduleId);
            }
        }

        EgovMap egovMap = null;

        if(listLessonScheduleId.size() > 0) {
            vo.setSqlForeach(listLessonScheduleId.toArray(new String[listLessonScheduleId.size()]));
            egovMap = stdDAO.selectStdLessonProgress(vo);
        }

        return egovMap;
    }

    /*****************************************************
     * 제출/참여 이력 목록 (과제)
     * @param StdVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listSubmitHistoryAsmnt(StdVO vo) throws Exception {
        List<EgovMap> list = stdDAO.listSubmitHistoryAsmnt(vo);

        AsmtVO asmtVo;

        for(EgovMap map : list) {
            List<FileVO> listAsmntSbmtFile = null;
            List<EgovMap> listAsmntJoinHsty = null;

            String asmntCd = (String) map.get("asmntCd");
            String asmntSendCd = (String) map.get("asmntSendCd");

            if(ValidationUtils.isNotEmpty(asmntSendCd)) {
                asmtVo = new AsmtVO();
                asmtVo.setAsmtId(asmntCd);
                asmtVo.setAsmtSbmsnId(asmntSendCd);

                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("ASMNT");
                fileVO.setFileBindDataSn(asmntSendCd);
                listAsmntSbmtFile = sysFileService.list(fileVO).getReturnList();

                // 제출/참여 이력 목록 (과제 활동이력)
                listAsmntJoinHsty = stdDAO.listAsmntJoinHsty(asmtVo);
            }

            map.put("listAsmntSbmtFile", listAsmntSbmtFile);
            map.put("listAsmntJoinHsty", listAsmntJoinHsty);
        }

        return list;
    }

    /*****************************************************
     * 제출/참여 이력 목록 (퀴즈)
     * @param StdVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listSubmitHistoryQuiz(StdVO vo) throws Exception {
        return stdDAO.listSubmitHistoryQuiz(vo);
    }

    /*****************************************************
     * 제출/참여 이력 목록 (설문)
     * @param StdVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listSubmitHistoryResch(StdVO vo) throws Exception {
        return stdDAO.listSubmitHistoryResch(vo);
    }

    /*****************************************************
     * 제출/참여 이력 목록 (토론)
     * @param StdVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listSubmitHistoryForum(StdVO vo) throws Exception {
        return stdDAO.listSubmitHistoryForum(vo);
    }

    // Std_No 얻기
    @Override
    public String selectStdNo(String crsCreCd, String userId) throws Exception {
        StdVO vo = new StdVO();
        vo.setCrsCreCd(crsCreCd);
        vo.setUserId(userId);

        vo = stdDAO.selectStd(vo);
        if(ValidationUtils.isEmpty(vo)) {
            return "";
        }
        return vo.getStdId();
    }

    // 수강생수 조회
    @Override
    public int countStudentInfo(StdVO vo) throws Exception {
        return stdDAO.countStudentInfo(vo);
    }

    /**
     * 학습자 페이지 목록 정보를 조회한다.
     *
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<StdVO> listPaging(StdVO vo) throws Exception {
        ProcessResultVO<StdVO> resultList = new ProcessResultVO<>();

        /** start of paging */
        PagingInfo paginationInfo = new PagingInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        /** 팀 추가 전용 로직 Start : 해당 stdNo 제외*/
        vo.setSqlForeach(StringUtil.split(StringUtil.nvl(vo.getSearchKey(), ""), ","));
        /** 팀 추가 전용 로직 End */

        List<StdVO> userInfoList = stdDAO.listPaging(vo);
        if(userInfoList != null) {

            // 전체 목록 수
            if(userInfoList.size() > 0) {
                paginationInfo.setTotalRecordCount(userInfoList.get(0).getTotalCnt());
            } else {
                paginationInfo.setTotalRecordCount(0);
            }
        }

        resultList.setResult(1);
        resultList.setReturnList(userInfoList);
        resultList.setPageInfo(paginationInfo);

        return resultList;
    }

    /**
     * 학습자 목록 정보를 조회
     *
     * @param StdVO
     * @return List<StdVO>
     * @throws Exception
     */
    @Override
    public List<StdVO> exList(StdVO vo) throws Exception {
        return stdDAO.exList(vo);
    }

    @Override
    public List<CreCrsVO> listCrsCre(CreCrsVO vo) throws Exception {
        if("".equals(StringUtil.nvl(vo.getOrgId()))) {
            vo.setOrgId(CommConst.KNOU_ORG_ID);
        }
        return stdDAO.listCrsCre(vo);
    }

    /**
     * 강의실 수강생 사용자목록(by stdNo)
     *
     * @return List<StdVO>
     * @throws Exception
     */
    @Override
    public List<StdVO> listUserByStdNo(StdVO vo) throws Exception {
        return stdDAO.listUserByStdNo(vo);
    }

    /**
     * 임시 수강생 등록
     *
     * @param StdVO
     * @return
     * @throws Exception
     */
    public void insertTmpStd(StdVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();
        String userId = vo.getUserId();

        // 과목정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setOrgId(orgId);
        creCrsVO = crecrsService.select(creCrsVO);

        if(creCrsVO == null) {
            throw processException("std.error.insert.tmpuser"); // 임시학생 생성중 오류가 발생하였습니다.
        }

        String year = creCrsVO.getCreYear();
        String term = creCrsVO.getCreTerm();
        String crsCd = creCrsVO.getCrsCd();
        String declsNo = creCrsVO.getDeclsNo();

        if(ValidationUtils.isEmpty(year) || ValidationUtils.isEmpty(term) || ValidationUtils.isEmpty(crsCd) || ValidationUtils.isEmpty(declsNo)) {
            throw processException("std.error.insert.tmpuser"); // 임시학생 생성중 오류가 발생하였습니다.
        }

        String stdNo = crsCreCd + "tmpuser";

        StdVO stdVO = new StdVO();
        stdVO.setStdId(stdNo);
        stdVO.setOrgId(orgId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(userId);
        stdDAO.insertTmpStd(stdVO);
    }

    /**
     * 수강생 학사 미연동 체크
     *
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    public Map<String, Object> listHaksaStdCheck(ErpEnrollmentVO vo) throws Exception {
        Map<String, Object> resultMap = new HashMap<>();

        // 학사 수강생 목록
        List<ErpEnrollmentVO> erpEnrollList = erpDAO.selectCourseEnrollmentAll(vo);

        // 검색조건
        StdVO stdVO = new StdVO();
        stdVO.setCreYear(vo.getYear());
        stdVO.setCreTerm(vo.getSemester());
        stdVO.setSearchValue(vo.getSearchValue());

        // LMS 수강생 목록
        List<StdVO> stdList = stdDAO.selectStdAll(stdVO);
        Map<String, String> stdMap = new HashMap<>();
        for(StdVO sdtVO2 : stdList) {
            stdMap.put(sdtVO2.getCrsCreCd() + ":" + sdtVO2.getUserId(), "S".equals(sdtVO2.getEnrlSts()) ? "Y" : "N");
        }

        Map<String, String> enrlMap = new HashMap<>();
        String key = "";
        int checkCount = 0;
        List<ErpEnrollmentVO> enrollList = new ArrayList<>();
        for(ErpEnrollmentVO enVO : erpEnrollList) {
            key = enVO.getYear() + enVO.getSemester() + enVO.getCourseCode() + enVO.getSection() + ":" + enVO.getStudentId();
            if(enrlMap.containsKey(key)) {
                continue;
            } else {
                enrlMap.put(key, enVO.getStudentId());
            }

            if(stdMap.containsKey(key)) {
                if(!stdMap.get(key).equals(enVO.getEnrollYn())) {
                    if(enrollList.size() < 1000) {
                        enrollList.add(enVO);
                    }
                    checkCount++;
                }
            } else {
                if("Y".equals(enVO.getEnrollYn())) {
                    if(enrollList.size() < 1000) {
                        enrollList.add(enVO);
                    }
                    checkCount++;
                }
            }
            
            /*
            // 데이터 1000건만 출력
            if (enrollList.size() >= 1000) {
                break;
            }
            */
        }

        resultMap.put("ernollList", enrollList);
        resultMap.put("checkCount", checkCount);

        return resultMap;
    }

    /**
     * 수강생 학사 미연동 체크
     *
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    public List<ErpEnrollmentVO> listHaksaStdCheckExcel(ErpEnrollmentVO vo) throws Exception {

        // 학사 수강생 목록
        List<ErpEnrollmentVO> erpEnrollList = erpDAO.selectCourseEnrollmentAll(vo);

        // 검색조건
        StdVO stdVO = new StdVO();
        stdVO.setCreYear(vo.getYear());
        stdVO.setCreTerm(vo.getSemester());
        stdVO.setSearchValue(vo.getSearchValue());
        // stdVO.setCrsCd(vo.getCourseCode());
        // stdVO.setUserId(vo.getStudentId());

        // LMS 수강생 목록
        List<StdVO> stdList = stdDAO.selectStdAll(stdVO);
        Map<String, String> stdMap = new HashMap<>();
        for(StdVO sdtVO2 : stdList) {
            stdMap.put(sdtVO2.getCrsCreCd() + ":" + sdtVO2.getUserId(), "S".equals(sdtVO2.getEnrlSts()) ? "Y" : "N");
        }

        String key = "";
        int checkCount = 0;
        int no = 1;
        List<ErpEnrollmentVO> enrollList = new ArrayList<>();
        for(ErpEnrollmentVO enVO : erpEnrollList) {
            key = enVO.getYear() + enVO.getSemester() + enVO.getCourseCode() + enVO.getSection() + ":" + enVO.getStudentId();

            if(stdMap.containsKey(key)) {

                if(!stdMap.get(key).equals(enVO.getEnrollYn())) {
                    //if(enrollList.size() < 1000) {
                    enrollList.add(enVO);
                    //}
                    checkCount++;
                    enVO.setOrder(no++);
                }
            } else {

                if("Y".equals(enVO.getEnrollYn())) {

                    if(enVO.getInsertAt() != null && !enVO.getInsertAt().equals("")) {
                        String insertAt = (DateTimeUtil.dateToString(enVO.getInsertAt(), "yyyy-MM-dd HH:mm"));
                        enVO.setInsertExcelAt(insertAt);
                    }

                    if(enVO.getModifyAt() != null && !enVO.getModifyAt().equals("")) {
                        String modifyAt = (DateTimeUtil.dateToString(enVO.getModifyAt(), "yyyy-MM-dd HH:mm"));
                        enVO.setModifyExcelAt(modifyAt);
                    }
                    //if(enrollList.size() < 1000) {
                    enrollList.add(enVO);
                    //}
                    checkCount++;
                    enVO.setOrder(no++);
                }
            }
            
            /*
            // 데이터 1000건만 출력
            if (enrollList.size() >= 1000) {
                break;
            }
            */
        }
        return enrollList;
    }

    /*****************************************************
     * 강의평가 참여여부 조회
     * @param StdVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectLectEvalJoinCnt(StdVO vo) throws Exception {
        return stdDAO.selectLectEvalJoinCnt(vo);
    }

    /*****************************************************
     * 학업중단 위험지수 페이징 목록
     * @param vo
     * @return ProcessResultVO<LearnStopRiskIndexVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<LearnStopRiskIndexVO> listPagingLearnStopRiskIndex(LearnStopRiskIndexVO vo) throws Exception {
        ProcessResultVO<LearnStopRiskIndexVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = stdDAO.countLearnStopRiskIndex(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<LearnStopRiskIndexVO> resultList = stdDAO.listPagingLearnStopRiskIndex(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 학업중단 위험지수 등록
     * @param vo
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public void mergeLearnStopRiskIndex(LearnStopRiskIndexVO vo, List<Map<String, Object>> list) throws Exception {
        String orgId = vo.getOrgId();
        String rgtrId = vo.getRgtrId();
        String mdfrId = vo.getMdfrId();

        List<LearnStopRiskIndexVO> mergeList = null;
        int line = 4;  // 샘플 엑셀파일 row 시작위치
        String errPrefix;

        int batchSize = 500;
        for(int i = 0; i < list.size(); i += batchSize) {
            int endIndex = Math.min(i + batchSize, list.size());
            List<Map<String, Object>> sublist = list.subList(i, endIndex);

            // 엑셀의 사용자번호로 사용자 조회
            String[] userIdList = new String[sublist.size()];
            for(int j = 0; j < sublist.size(); j++) {
                userIdList[j] = StringUtil.nvl(sublist.get(j).get("A"));
            }

            UsrUserInfoVO usrUserInfoVO = new UsrUserInfoVO();
            usrUserInfoVO.setOrgId(orgId);
            usrUserInfoVO.setSqlForeach(userIdList);
            List<UsrUserInfoVO> listAvailableUser = usrUserInfoDAO.listAvailableUser(usrUserInfoVO);
            Set<String> userIdSet = listAvailableUser.stream().map(UsrUserInfoVO::getUserId).collect(Collectors.toCollection(HashSet::new));

            mergeList = new ArrayList<>();
            for(Map<String, Object> subMap : sublist) {
                errPrefix = line + "번 행의 ";

                String userId = StringUtil.nvl(subMap.get("A"));
                String creYearTerm = StringUtil.nvl(subMap.get("B"));
                String pubYearTerm = StringUtil.nvl(subMap.get("C"));
                String riskIndexStr = StringUtil.nvl(subMap.get("D")).replace("%", "");
                String riskGrade = StringUtil.nvl(subMap.get("E"));

                // 1.공백 체크
                Map<String, Object> emptyCheckMap = new HashMap<String, Object>();
                emptyCheckMap.put("학번", userId);
                emptyCheckMap.put("학습년도-학기", creYearTerm);
                emptyCheckMap.put("게시년도-학기", pubYearTerm);
                emptyCheckMap.put("위험지수", riskIndexStr);
                emptyCheckMap.put("위험등급", riskGrade);

                for(Map.Entry<String, Object> elem : emptyCheckMap.entrySet()) {
                    if("".equals(StringUtil.nvl(elem.getValue()))) {
                        throw new ServiceProcessException(errPrefix + "'" + elem.getKey() + "' (은)는 필수입력항목입니다.");
                    }
                }

                // 2.학번 유효성 체크
                if(!userIdSet.contains(userId)) {
                    throw new ServiceProcessException(errPrefix + "학번" + " [" + userId + "] " + "등록된 사용자가 아닙니다.");
                }

                // 3.학습년도-학기 유효성 체크
                String[] creYearTermList = creYearTerm.split("-");
                if(creYearTermList.length != 2) {
                    throw new ServiceProcessException(errPrefix + "학습년도-학기 형식이 유효하지 않습니다.");
                }

                String creYear = creYearTermList[0];
                String creTerm = creYearTermList[1];

                if(creYear.length() != 4) {
                    throw new ServiceProcessException(errPrefix + "학습년도-학기의  [학습년도] 형식이 유효하지 않습니다.");
                }

                if(!("1".equals(creTerm) || "2".equals(creTerm))) {
                    throw new ServiceProcessException(errPrefix + "학습년도-학기의  [학기] 형식이 유효하지 않습니다.");
                }

                if(creTerm.length() == 1) {
                    creTerm = creTerm + "0";
                }

                // 4.게시년도-학기 유효성 체크
                String[] pubYearTermList = pubYearTerm.split("-");
                if(pubYearTermList.length != 2) {
                    throw new ServiceProcessException(errPrefix + "게시년도-학기 형식이 유효하지 않습니다.");
                }

                String pubYear = pubYearTermList[0];
                String pubTerm = pubYearTermList[1];

                if(pubYear.length() != 4) {
                    throw new ServiceProcessException(errPrefix + "게시년도-학기의  [게시년도] 형식이 유효하지 않습니다.");
                }

                if(!("1".equals(pubTerm) || "2".equals(pubTerm))) {
                    throw new ServiceProcessException(errPrefix + "게시년도-학기의  [학기] 형식이 유효하지 않습니다.");
                }

                if(pubTerm.length() == 1) {
                    pubTerm = pubTerm + "0";
                }

                // 5.위험지수 유효성 체크
                Float riskIndex = null;

                try {
                    riskIndex = Float.parseFloat(riskIndexStr);
                } catch(Exception e) {
                    throw new ServiceProcessException(errPrefix + "위험지수 형식이 유효하지 않습니다.");
                }

                LearnStopRiskIndexVO learnStopRiskIndexVO = new LearnStopRiskIndexVO();
                learnStopRiskIndexVO.setUserId(userId);
                learnStopRiskIndexVO.setCreYear(creYear);
                learnStopRiskIndexVO.setCreTerm(creTerm);
                learnStopRiskIndexVO.setPubYear(pubYear);
                learnStopRiskIndexVO.setPubTerm(pubTerm);
                learnStopRiskIndexVO.setRiskIndex(riskIndex);
                learnStopRiskIndexVO.setRiskGrade(riskGrade);
                learnStopRiskIndexVO.setRgtrId(rgtrId);
                learnStopRiskIndexVO.setMdfrId(mdfrId);

                mergeList.add(learnStopRiskIndexVO);
                line++;
            }

            stdDAO.mergeLearnStopRiskIndex(mergeList);
        }
    }

    /*****************************************************
     * <p>
     * 수강생별 학습기록 수강생 조회
     *
     * @param StdVO
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<StdVO> listStudentRecord(StdVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<StdVO> stdList = stdDAO.listStudentRecord(vo);

        if(stdList.size() > 0) {
            paginationInfo.setTotalRecordCount(stdList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<StdVO>();

        resultVO.setReturnList(stdList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /*****************************************************
     * <p>
     * 수강생별 과목 목록 조회
     *
     * @param StdVO
     * @return ProcessResultVO<StdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<StdVO> listStudentCreCrs(StdVO vo) throws Exception {
        ProcessResultVO<StdVO> resultVO = new ProcessResultVO<StdVO>();

        try {
            List<StdVO> creCrsList = stdDAO.listStudentCreCrs(vo);
            resultVO.setReturnList(creCrsList);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }

        return resultVO;
    }

    public String convertLessonScheduleId(String lessonScheduleId) {
        String[] parts = lessonScheduleId.split("_");

        String first = parts[0].substring(0, 1).toUpperCase() + parts[0].substring(1).toLowerCase();
        String second = parts[1].toLowerCase();

        return first + second;
    }
}
