package knou.lms.dashboard.service.impl;

import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.dao.CrecrsDAO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.crecrs.vo.HpIntchVO;
import knou.lms.crs.crs.vo.CrsVO;
import knou.lms.crs.term.dao.TermDAO;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.dao.DashboardDAO;
import knou.lms.dashboard.service.DashboardService;
import knou.lms.dashboard.vo.DashboardVO;
import knou.lms.dashboard.vo.MainCreCrsVO;
import knou.lms.exam.vo.ExamVO;
import knou.lms.lesson.dao.LessonScheduleDAO;
import knou.lms.lesson.dao.LessonStudyDAO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyRecordVO;
import knou.lms.lesson.vo.LessonStudyStateVO;
import knou.lms.resh.vo.ReshVO;
import knou.lms.user.vo.UsrUserInfoVO;

/**
 * *************************************************
 * <pre>
 * 업무 그룹명 : 대시보드
 * 서부 업무명 : 대시보드 서비스
 * 설         명 :
 * 작   성   자 : mediopia
 * 작   성   일 : 2022. 12. 15.
 * Copyright ⓒ Mediopia Tech All Right Reserved
 * ======================================
 * 작성자/작성일 : shil / 2022. 12. 15.
 * 변경사유/내역 : 최초 작성
 * --------------------------------------
 * 변경자/변경일 :
 * 변경사유/내역 :
 * ======================================
 * </pre>
 **************************************************
 */
@Service("dashboardService")
public class DashboardServiceImpl extends ServiceBase implements DashboardService {

    /** dashboardDAO */
    @Resource(name = "dashboardDAO")
    private DashboardDAO dashboardDAO;

    /** crecrsDAO */
    @Resource(name="crecrsDAO")
    private CrecrsDAO crecrsDAO;

    @Resource(name="termDAO")
    private TermDAO termDAO;

    @Resource(name="lessonStudyDAO")
    private LessonStudyDAO lessonStudyDAO;

    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    /**
     * 대시보드 전체설문
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<ReshVO> listSysReschRecent(ReshVO vo) throws Exception {
        ProcessResultVO<ReshVO> processResultVO = new ProcessResultVO<>();

        try {
            List<ReshVO> resultList = dashboardDAO.listSysReschRecent(vo);
            processResultVO.setReturnList(resultList);

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

        return processResultVO;
    }

    /**
     *
     * 현재 학기 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<TermVO> listCurTerm(TermVO vo) throws Exception {
        ProcessResultVO<TermVO> processResultVO = new ProcessResultVO<>();

        try {
            List<TermVO> resultList = dashboardDAO.listCurTerm(vo);
            processResultVO.setReturnList(resultList);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

        return processResultVO;
    }

    /**
     * 수강생 학기목록 조회
     */
    @Override
    public ProcessResultVO<TermVO> listStdTerm(TermVO vo) throws Exception {
        ProcessResultVO<TermVO> processResultVO = new ProcessResultVO<>();

        try {
            List<TermVO> resultList = dashboardDAO.listStdTerm(vo);
            processResultVO.setReturnList(resultList);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

        return processResultVO;
    }

    /**
     * <p>
     * 수강생의 과목 정보
     *
     * @param dashboardVO
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DashboardVO> stdCourseInfo(DashboardVO dashboardVO) throws Exception {
        ProcessResultVO<DashboardVO> resultVO = new ProcessResultVO<>();

        try {

            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setTermCd(dashboardVO.getTermCd());
            creCrsVO.setTermStatus(null);
            creCrsVO.setUserId(dashboardVO.getUserId());

            if(!"".equals(StringUtil.nvl(dashboardVO.getSearchFrom()))) {
                creCrsVO.setCrsTypeCd(dashboardVO.getSearchFrom());
            }

            List<CreCrsVO> creCrsList;
            // 과목 목록
            if(dashboardVO.getTermCd() == null) {
                creCrsList = new ArrayList<>();
            } else {
                creCrsList = crecrsDAO.listMainMypageStd(creCrsVO);
            }

            HpIntchVO hpIntchVO = new HpIntchVO();
            hpIntchVO.setYy(dashboardVO.getHaksaYear());
            hpIntchVO.setTmGbn(dashboardVO.getHaksaTerm());
            hpIntchVO.setStuno(dashboardVO.getUserId());

            // 학점교류과목 목록
            List<HpIntchVO> hpIntchList = crecrsDAO.listHpIntch(hpIntchVO);
            dashboardVO.setHpIntchList(hpIntchList);

            MainCreCrsVO mainCreCrsVO = null;
            List<String> corList = new ArrayList<>();
            List<MainCreCrsVO> mainCrsList = new ArrayList<>();

            for(CreCrsVO crsVO : creCrsList) {
                corList.add(crsVO.getCrsCreCd());

                mainCreCrsVO = new MainCreCrsVO();
                mainCreCrsVO.setCrsCreCd(crsVO.getCrsCreCd());
                mainCreCrsVO.setCrsCreNm(crsVO.getCrsCreNm());
                mainCreCrsVO.setCrsCreNmEng(crsVO.getCrsCreNmEng());
                mainCreCrsVO.setDeclsNo(crsVO.getDeclsNo());
                mainCreCrsVO.setStdCnt(crsVO.getStdCnt());
                mainCreCrsVO.setCrsCd(crsVO.getCrsCd());
                mainCreCrsVO.setAuditYn(crsVO.getAuditYn());
                mainCreCrsVO.setRepeatYn(crsVO.getRepeatYn());
                mainCreCrsVO.setTmswPreScYn(crsVO.getTmswPreScYn());
                mainCreCrsVO.setGvupYn(crsVO.getGvupYn());
                mainCreCrsVO.setPreScYn(crsVO.getPreScYn());
                mainCreCrsVO.setSuppScYn(crsVO.getSuppScYn());
                mainCreCrsVO.setEnrlStartDttm(crsVO.getEnrlStartDttm());
                mainCreCrsVO.setEnrlEndDttm(crsVO.getEnrlEndDttm());
                mainCreCrsVO.setLessonScheduleId(crsVO.getLessonScheduleId());
                mainCreCrsVO.setLessonTimeId(crsVO.getLessonTimeId());
                mainCreCrsVO.setUniCd(crsVO.getUniCd());
                mainCreCrsVO.setUnivGbn(crsVO.getUnivGbn());
                mainCreCrsVO.setGrdtScYn(crsVO.getGrdtScYn());

                mainCrsList.add(mainCreCrsVO);
            }

            if(corList.size() > 0) {
                // 수강생 과목 부가자료 조회
                mainCreCrsVO = new MainCreCrsVO();
                mainCreCrsVO.setUserId(dashboardVO.getUserId());
                mainCreCrsVO.setCorList(corList);
                mainCreCrsVO.setExamStareSearchYn(StringUtil.nvl(dashboardVO.getSearchType()));
                List<MainCreCrsVO> corsDataList = dashboardDAO.listStdCorsData(mainCreCrsVO);

                HashMap<String, MainCreCrsVO> corsDataMap = new HashMap<>();
                for(MainCreCrsVO vo : corsDataList) {
                    corsDataMap.put(vo.getCrsCreCd(), vo);
                }

                // 시험정보 조회
                List<ExamVO> examDataList = dashboardDAO.listCorExamData(mainCreCrsVO);
                HashMap<String, ExamVO> examMap = new HashMap<>();
                for(ExamVO vo : examDataList) {
                    String key = vo.getCrsCreCd()+"_"+vo.getExamStareTypeCd();
                    if(!examMap.containsKey(key)) {
                        examMap.put(key, vo);
                    }
                }

                // 주차 학습상태 조회
                List<LessonStudyStateVO> studyList = dashboardDAO.listLessonStudyState(mainCreCrsVO);
                HashMap<String, LessonStudyStateVO> studyMap = new HashMap<>();
                for(LessonStudyStateVO vo : studyList) {
                    studyMap.put(vo.getLessonScheduleId(), vo);
                }

                // 강의 주차 목록 조회
                LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
                lessonScheduleVO.setSqlForeach(corList.toArray(new String[corList.size()]));
                List<LessonScheduleVO> lessonList = lessonScheduleDAO.list(lessonScheduleVO);

                // 학습기록 조회
                HashMap<String, LessonStudyRecordVO> studyRecordMap = new HashMap<>();
                if("LEGAL".equals(StringUtil.nvl(dashboardVO.getSearchFrom()))) {
                    LessonStudyRecordVO lessonStudyRecordVO = new LessonStudyRecordVO();
                    lessonStudyRecordVO.setUserId(dashboardVO.getUserId());
                    lessonStudyRecordVO.setSqlForeach(corList.toArray(new String[corList.size()]));
                    List<LessonStudyRecordVO> listStdRecordByCrs = lessonStudyDAO.listStdRecordByCrs(lessonStudyRecordVO);
                    for(LessonStudyRecordVO vo : listStdRecordByCrs) {
                        studyRecordMap.put(vo.getCrsCreCd(), vo);
                    }
                }

                HashMap<String, List<LessonScheduleVO>> lessonMap = new HashMap<>();

                for(LessonScheduleVO vo : lessonList) {
                    String lessonScheduleProgress = vo.getLessonScheduleProgress();

                    if(lessonMap.containsKey(vo.getCrsCreCd())) {
                        lessonMap.get(vo.getCrsCreCd()).add(vo);
                    }
                    else {
                        List<LessonScheduleVO> list = new ArrayList<>();
                        list.add(vo);
                        lessonMap.put(vo.getCrsCreCd(), list);
                    }

                    if(studyMap.containsKey(vo.getLessonScheduleId())) {
                        vo.setStudyStatusCd(studyMap.get(vo.getLessonScheduleId()).getStudyStatusCd());
                    } else {
                        /*
                        if("END".equals(lessonScheduleProgress)) {
                            vo.setStudyStatusCd("NOSTUDY");
                        } else if("PROGRESS".equals(lessonScheduleProgress)) {
                            vo.setStudyStatusCd("OPEN");
                        } else {
                            vo.setStudyStatusCd("WAIT");
                        }
                        */
                        if("END".equals(lessonScheduleProgress) || "PROGRESS".equals(lessonScheduleProgress)) {
                            vo.setStudyStatusCd("NOSTUDY");
                        } else {
                            vo.setStudyStatusCd("WAIT");
                        }
                    }
                }

                for(MainCreCrsVO vo : mainCrsList) {
                    if(corsDataMap.containsKey(vo.getCrsCreCd())) {
                        MainCreCrsVO crsVO = corsDataMap.get(vo.getCrsCreCd());
                        vo.setProfNo(crsVO.getProfNo());
                        vo.setProfNm(crsVO.getProfNm());
                        vo.setProfNmEng(crsVO.getProfNmEng());
                        vo.setProfTel(crsVO.getProfTel());
                        vo.setAssistNo(crsVO.getAssistNo());
                        vo.setAssistNm(crsVO.getAssistNm());
                        vo.setAssistNmEng(crsVO.getAssistNmEng());
                        vo.setAssistTel(crsVO.getAssistTel());
                        //vo.setLessonCnt(crsVO.getLessonCnt());
                        //vo.setCompleteCnt(crsVO.getCompleteCnt());
                        vo.setAsmntCnt(crsVO.getAsmntCnt());
                        vo.setAsmntSbmtCnt(crsVO.getAsmntSbmtCnt());
                        vo.setQnaCnt(crsVO.getQnaCnt());
                        vo.setQnaAnsCnt(crsVO.getQnaAnsCnt());
                        vo.setSecretCnt(crsVO.getSecretCnt());
                        vo.setSecretAnsCnt(crsVO.getSecretAnsCnt());
                        vo.setExamCnt(crsVO.getExamCnt());
                        vo.setExamAnsCnt(crsVO.getExamAnsCnt());
                        vo.setAlwaysExamCnt(crsVO.getAlwaysExamCnt());
                        vo.setAlwaysExamAnsCnt(crsVO.getAlwaysExamAnsCnt());
                        vo.setSeminarCnt(crsVO.getSeminarCnt());
                        vo.setSeminarAnsCnt(crsVO.getSeminarAnsCnt());
                        vo.setForumCnt(crsVO.getForumCnt());
                        vo.setForumAnsCnt(crsVO.getForumAnsCnt());
                        vo.setNoticeCnt(crsVO.getNoticeCnt());
                        vo.setNoticeReadCnt(crsVO.getNoticeReadCnt());
                        vo.setQuizCnt(crsVO.getQuizCnt());
                        vo.setQuizAnsCnt(crsVO.getQuizAnsCnt());
                        vo.setReschCnt(crsVO.getReschCnt());
                        vo.setReschAnsCnt(crsVO.getReschAnsCnt());
                        vo.setExamCnt(crsVO.getExamCnt());
                        vo.setExamAnsCnt(crsVO.getExamAnsCnt());
                        vo.setNoticeBbsId(crsVO.getNoticeBbsId());
                        vo.setQnaBbsId(crsVO.getQnaBbsId());
                        vo.setSecretBbsId(crsVO.getSecretBbsId());
                    }

                    if(examMap.containsKey(vo.getCrsCreCd()+"_M")) {
                        vo.setExamMid(examMap.get(vo.getCrsCreCd()+"_M"));
                    }
                    if(examMap.containsKey(vo.getCrsCreCd()+"_L")) {
                        vo.setExamLast(examMap.get(vo.getCrsCreCd()+"_L"));
                    }

                    if(lessonMap.containsKey(vo.getCrsCreCd())) {
                        List<LessonScheduleVO> lesnList = lessonMap.get(vo.getCrsCreCd());
                        vo.setLessonScheduleList(lesnList);
                    }

                    if(studyRecordMap.containsKey(vo.getCrsCreCd())) {
                        LessonStudyRecordVO lessonStudyRecordVO = studyRecordMap.get(vo.getCrsCreCd());
                        float lbnTm = lessonStudyRecordVO.getLbnTm();
                        float studySumTm = lessonStudyRecordVO.getStudySumTm();
                        float prgrRatio = studySumTm / lbnTm * 100;
                        if(prgrRatio > 100) {
                            prgrRatio = 100;
                        }

                        vo.setPrgrRatio((int) prgrRatio);
                    }
                }
            }

            dashboardVO.setCreCrsList(mainCrsList);
            resultVO.setReturnVO(dashboardVO);

        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            throw e;
        }

        return resultVO;
    }

    /**
     * <p>
     * 수강생의 과목 정보(1과목)
     *
     * @param dashboardVO
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DashboardVO> stdCourseInfoOne(CreCrsVO creCrsVO) throws Exception {
        ProcessResultVO<DashboardVO> resultVO = new ProcessResultVO<>();

        try {
            String userId = creCrsVO.getUserId();

            // 과목 목록
            creCrsVO = crecrsDAO.select(creCrsVO);
            creCrsVO.setUserId(userId);
            List<CreCrsVO> creCrsList = new ArrayList<>();
            creCrsList.add(creCrsVO);

            MainCreCrsVO mainCreCrsVO = null;
            List<String> corList = new ArrayList<>();
            List<MainCreCrsVO> mainCrsList = new ArrayList<>();

            for(CreCrsVO crsVO : creCrsList) {
                corList.add(crsVO.getCrsCreCd());

                mainCreCrsVO = new MainCreCrsVO();
                mainCreCrsVO.setCrsCreCd(crsVO.getCrsCreCd());
                mainCreCrsVO.setCrsCreNm(crsVO.getCrsCreNm());
                mainCreCrsVO.setDeclsNo(crsVO.getDeclsNo());
                mainCreCrsVO.setStdCnt(crsVO.getStdCnt());
                mainCreCrsVO.setCrsCd(crsVO.getCrsCd());
                mainCreCrsVO.setAuditYn(crsVO.getAuditYn());

                mainCrsList.add(mainCreCrsVO);
            }

            if(corList.size() > 0) {
                // 수강생 과목 부가자료 조회
                mainCreCrsVO = new MainCreCrsVO();
                mainCreCrsVO.setUserId(creCrsVO.getUserId());
                mainCreCrsVO.setCorList(corList);
                mainCreCrsVO.setExamStareSearchYn("Y");
                List<MainCreCrsVO> corsDataList = dashboardDAO.listStdCorsData(mainCreCrsVO);

                HashMap<String, MainCreCrsVO> corsDataMap = new HashMap<>();
                for(MainCreCrsVO vo : corsDataList) {
                    corsDataMap.put(vo.getCrsCreCd(), vo);
                }

                // 시험정보 조회
                List<ExamVO> examDataList = dashboardDAO.listCorExamData(mainCreCrsVO);
                HashMap<String, ExamVO> examMap = new HashMap<>();
                for(ExamVO vo : examDataList) {
                    String key = vo.getCrsCreCd()+"_"+vo.getExamStareTypeCd();
                    if(!examMap.containsKey(key)) {
                        examMap.put(key, vo);
                    }
                }

                // 주차 학습상태 조회
                List<LessonStudyStateVO> studyList = dashboardDAO.listLessonStudyState(mainCreCrsVO);
                HashMap<String, LessonStudyStateVO> studyMap = new HashMap<>();
                for(LessonStudyStateVO vo : studyList) {
                    studyMap.put(vo.getLessonScheduleId(), vo);
                }

                // 강의 주차 목록 조회
                LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
                lessonScheduleVO.setSqlForeach(corList.toArray(new String[corList.size()]));
                List<LessonScheduleVO> lessonList = lessonScheduleDAO.list(lessonScheduleVO);

                HashMap<String, List<LessonScheduleVO>> lessonMap = new HashMap<>();

                for(LessonScheduleVO vo : lessonList) {
                    String lessonScheduleProgress = vo.getLessonScheduleProgress();

                    if(lessonMap.containsKey(vo.getCrsCreCd())) {
                        lessonMap.get(vo.getCrsCreCd()).add(vo);
                    }
                    else {
                        List<LessonScheduleVO> list = new ArrayList<>();
                        list.add(vo);
                        lessonMap.put(vo.getCrsCreCd(), list);
                    }

                    if(studyMap.containsKey(vo.getLessonScheduleId())) {
                        vo.setStudyStatusCd(studyMap.get(vo.getLessonScheduleId()).getStudyStatusCd());
                    } else {
                        /*
                        if("END".equals(lessonScheduleProgress)) {
                            vo.setStudyStatusCd("NOSTUDY");
                        } else if("PROGRESS".equals(lessonScheduleProgress)) {
                            vo.setStudyStatusCd("OPEN");
                        } else {
                            vo.setStudyStatusCd("WAIT");
                        }
                        */
                        if("END".equals(lessonScheduleProgress) || "PROGRESS".equals(lessonScheduleProgress)) {
                            vo.setStudyStatusCd("NOSTUDY");
                        } else {
                            vo.setStudyStatusCd("WAIT");
                        }
                    }
                }

                for(MainCreCrsVO vo : mainCrsList) {
                    if(corsDataMap.containsKey(vo.getCrsCreCd())) {
                        MainCreCrsVO crsVO = corsDataMap.get(vo.getCrsCreCd());
                        vo.setProfNo(crsVO.getProfNo());
                        vo.setProfNm(crsVO.getProfNm());
                        vo.setProfTel(crsVO.getProfTel());
                        vo.setAssistNo(crsVO.getAssistNo());
                        vo.setAssistNm(crsVO.getAssistNm());
                        vo.setAssistTel(crsVO.getAssistTel());
                        //vo.setLessonCnt(crsVO.getLessonCnt());
                        //vo.setCompleteCnt(crsVO.getCompleteCnt());
                        vo.setAsmntCnt(crsVO.getAsmntCnt());
                        vo.setAsmntSbmtCnt(crsVO.getAsmntSbmtCnt());
                        vo.setQnaCnt(crsVO.getQnaCnt());
                        vo.setQnaAnsCnt(crsVO.getQnaAnsCnt());
                        vo.setSecretCnt(crsVO.getSecretCnt());
                        vo.setSecretAnsCnt(crsVO.getSecretAnsCnt());
                        vo.setExamCnt(crsVO.getExamCnt());
                        vo.setExamAnsCnt(crsVO.getExamAnsCnt());
                        vo.setAlwaysExamCnt(crsVO.getAlwaysExamCnt());
                        vo.setAlwaysExamAnsCnt(crsVO.getAlwaysExamAnsCnt());
                        vo.setSeminarCnt(crsVO.getSeminarCnt());
                        vo.setSeminarAnsCnt(crsVO.getSeminarAnsCnt());
                        vo.setForumCnt(crsVO.getForumCnt());
                        vo.setForumAnsCnt(crsVO.getForumAnsCnt());
                        vo.setNoticeCnt(crsVO.getNoticeCnt());
                        vo.setNoticeReadCnt(crsVO.getNoticeReadCnt());
                        vo.setQuizCnt(crsVO.getQuizCnt());
                        vo.setQuizAnsCnt(crsVO.getQuizAnsCnt());
                        vo.setReschCnt(crsVO.getReschCnt());
                        vo.setReschAnsCnt(crsVO.getReschAnsCnt());
                        vo.setExamCnt(crsVO.getExamCnt());
                        vo.setExamAnsCnt(crsVO.getExamAnsCnt());
                        vo.setNoticeBbsId(crsVO.getNoticeBbsId());
                        vo.setQnaBbsId(crsVO.getQnaBbsId());
                        vo.setSecretBbsId(crsVO.getSecretBbsId());
                    }

                    if(examMap.containsKey(vo.getCrsCreCd()+"_M")) {
                        vo.setExamMid(examMap.get(vo.getCrsCreCd()+"_M"));
                    }
                    if(examMap.containsKey(vo.getCrsCreCd()+"_L")) {
                        vo.setExamLast(examMap.get(vo.getCrsCreCd()+"_L"));
                    }

                    if(lessonMap.containsKey(vo.getCrsCreCd())) {
                        List<LessonScheduleVO> lesnList = lessonMap.get(vo.getCrsCreCd());
                        vo.setLessonScheduleList(lesnList);
                    }
                }
            }

            DashboardVO dashboardVO = new DashboardVO();
            dashboardVO.setCreCrsList(mainCrsList);
            resultVO.setReturnVO(dashboardVO);

        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            throw e;
        }

        return resultVO;
    }


    /**
     * 교수학기목록조회 - ASIS
     */
    @Override
    public ProcessResultVO<TermVO> listProfTerm(TermVO vo) throws Exception {
        return profSmstrList(vo);
    }

    /**
     * 교수학기목록조회 - TOBE
     * @param TermVO
     * @return ProcessResultVO
     * @throws Exception
     * @author 260123 jinkoon
     */
    @Override
    public ProcessResultVO<TermVO> profSmstrList(TermVO vo) throws Exception {
        return new ProcessResultVO<TermVO>(dashboardDAO.profSmstrList(vo));
    }

    /**
     * <p>
     * 교수의 과목 정보
     *
     * @param dashboardVO
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DashboardVO> profCourseInfo(DashboardVO dashboardVO) throws Exception {

        ProcessResultVO<DashboardVO> resultVO = new ProcessResultVO<>();
        try {

            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setTermCd(dashboardVO.getTermCd());
            creCrsVO.setTermStatus(null);
            creCrsVO.setUserId(dashboardVO.getUserId());
            creCrsVO.setUniCd(dashboardVO.getUniCd());

            if("tchType".equals(StringUtil.nvl(dashboardVO.getSearchKey()))) {
                creCrsVO.setTchType("MONITORING");
            }
            if(!"".equals(StringUtil.nvl(dashboardVO.getSearchFrom()))) {
                creCrsVO.setCrsTypeCd(dashboardVO.getSearchFrom());
            }

            // 과목 목록
            List<CreCrsVO> creCrsList = crecrsDAO.listMainMypageTch(creCrsVO);

            MainCreCrsVO mainCreCrsVO = null;
            List<String> corList = new ArrayList<>();
            List<MainCreCrsVO> mainCrsList = new ArrayList<>();

            for(CreCrsVO crsVO : creCrsList) {
                corList.add(crsVO.getCrsCreCd());

                mainCreCrsVO = new MainCreCrsVO();
                mainCreCrsVO.setCrsCreCd(crsVO.getCrsCreCd());
                mainCreCrsVO.setCrsCreNm(crsVO.getCrsCreNm());
                mainCreCrsVO.setOrgId(crsVO.getOrgId());
                mainCreCrsVO.setUniCd(crsVO.getUniCd());
                mainCreCrsVO.setUnivGbn(crsVO.getUnivGbn());
                mainCreCrsVO.setDeclsNo(crsVO.getDeclsNo());
                mainCreCrsVO.setEnrlStartDttm(crsVO.getEnrlStartDttm());
                mainCreCrsVO.setEnrlEndDttm(crsVO.getEnrlEndDttm());
                mainCreCrsVO.setLessonScheduleId(crsVO.getLessonScheduleId());
                mainCreCrsVO.setLessonTimeId(crsVO.getLessonTimeId());

                mainCrsList.add(mainCreCrsVO);
            }

            if(corList.size() > 0) {
                // 교수의 과목 부가자료 검색
                mainCreCrsVO = new MainCreCrsVO();
                mainCreCrsVO.setUserId(dashboardVO.getUserId());
                mainCreCrsVO.setCorList(corList);
                if("MONITORING".equals(StringUtil.nvl(creCrsVO.getTchType()))) {
                    mainCreCrsVO.setTchType("MONITORING");
                }
                List<MainCreCrsVO> corsDataList = dashboardDAO.listProfCorsData(mainCreCrsVO);

                HashMap<String, MainCreCrsVO> corsDataMap = new HashMap<>();
                for(MainCreCrsVO vo : corsDataList) {
                    corsDataMap.put(vo.getCrsCreCd(), vo);
                }

                // 시험정보 조회
                List<ExamVO> examDataList = dashboardDAO.listCorExamData(mainCreCrsVO);
                HashMap<String, ExamVO> examMap = new HashMap<>();
                for(ExamVO vo : examDataList) {
                    String key = vo.getCrsCreCd()+"_"+vo.getExamStareTypeCd();
                    if(!examMap.containsKey(key)) {
                        examMap.put(key, vo);
                    }
                }

                for(MainCreCrsVO vo : mainCrsList) {
                    if(corsDataMap.containsKey(vo.getCrsCreCd())) {
                        MainCreCrsVO crsVO = corsDataMap.get(vo.getCrsCreCd());
                        vo.setProfNo(crsVO.getProfNo());
                        vo.setProfNm(crsVO.getProfNm());
                        vo.setAssistNm(crsVO.getAssistNm());
                        vo.setAssistTel(crsVO.getAssistTel());
                        vo.setAsmntCnt(crsVO.getAsmntCnt());
                        vo.setAsmntSbmtCnt(crsVO.getAsmntSbmtCnt());
                        vo.setAsmntEvalCnt(crsVO.getAsmntEvalCnt());
                        vo.setQnaCnt(crsVO.getQnaCnt());
                        vo.setQnaAnsCnt(crsVO.getQnaAnsCnt());
                        vo.setSecretCnt(crsVO.getSecretCnt());
                        vo.setSecretAnsCnt(crsVO.getSecretAnsCnt());
                        vo.setExamCnt(crsVO.getExamCnt());
                        vo.setExamAnsCnt(crsVO.getExamAnsCnt());
                        vo.setExamEvalCnt(crsVO.getExamEvalCnt());
                        vo.setForumCnt(crsVO.getForumCnt());
                        vo.setForumAnsCnt(crsVO.getForumAnsCnt());
                        vo.setForumEvalCnt(crsVO.getForumEvalCnt());
                        vo.setNoticeCnt(crsVO.getNoticeCnt());
                        vo.setQuizCnt(crsVO.getQuizCnt());
                        vo.setQuizAnsCnt(crsVO.getQuizAnsCnt());
                        vo.setQuizEvalCnt(crsVO.getQuizEvalCnt());
                        vo.setReschCnt(crsVO.getReschCnt());
                        vo.setStdCnt(crsVO.getStdCnt());
                        vo.setAuditCnt(crsVO.getAuditCnt());
                        vo.setNoticeBbsId(crsVO.getNoticeBbsId());
                        vo.setQnaBbsId(crsVO.getQnaBbsId());
                        vo.setSecretBbsId(crsVO.getSecretBbsId());
                        vo.setCredit(crsVO.getCredit());
                        vo.setSeminarCnt(crsVO.getSeminarCnt());
                        vo.setTotalRate(crsVO.getTotalRate());

                        vo.setConnCnt(0); // 접속자수
                        vo.setWarnCnt(0); // 이수위험 수
                    }

                    if(examMap.containsKey(vo.getCrsCreCd()+"_M")) {
                        vo.setExamMid(examMap.get(vo.getCrsCreCd()+"_M"));
                    }
                    if(examMap.containsKey(vo.getCrsCreCd()+"_L")) {
                        vo.setExamLast(examMap.get(vo.getCrsCreCd()+"_L"));
                    }
                }
            }

            dashboardVO.setCreCrsList(mainCrsList);
            resultVO.setReturnVO(dashboardVO);

        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            throw e;
        }

        return resultVO;
    }

    /**
     * 미완료 강의 조회
     *
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     */
    @Override
    public List<EgovMap> listStdUncompletedLesson(DefaultVO vo) throws Exception {
        return dashboardDAO.listStdUncompletedLesson(vo);
    }

    /**
     * ***************************************************
     * 대시보드 현황 (교수)
     * @param vo
     * @return EgovMap
     * @throws Exception
     *****************************************************
     */
    public EgovMap dashboardStatProf(DefaultVO vo) throws Exception {
        return dashboardDAO.dashboardStatProf(vo);
    }

    /**
     * ***************************************************
     * 대시보드 현황 (학생)
     * @param vo
     * @return EgovMap
     * @throws Exception
     *****************************************************
     */
    public EgovMap dashboardStatStu(DefaultVO vo) throws Exception {
        return dashboardDAO.dashboardStatStu(vo);
    }

    /**
     * 관리자메인 학기정보 정보
     */
    @Override
    public ProcessResultVO<TermVO> listAdminTerm(TermVO vo) throws Exception {
        ProcessResultVO<TermVO> processResultVO = new ProcessResultVO<>();

        try {
            List<TermVO> resultList = dashboardDAO.listAdminTerm(vo);
            processResultVO.setReturnList(resultList);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

        return processResultVO;
    }

    /**
     * 대시보드 현재 주차
     * @param vo
     * @return EgovMap
     * @throws Exception
     */
    public EgovMap dashboardCurrentWeek(TermVO vo) throws Exception {
        return dashboardDAO.dashboardCurrentWeek(vo);
    }

    /**
     * 수업운영 정보 조회
     * @param vo
     * @return EgovMap
     * @throws Exception
     */
    @Override
    public EgovMap selectLessonManageInfo(HttpServletRequest request, UsrUserInfoVO vo) throws Exception {
        String userType = SessionInfo.getAuthrtCd(request);
        EgovMap returnMap = new EgovMap();
        String[] sqlForeach = vo.getSqlForeach();

        // 사용자 로그인수 정보 조회
        EgovMap loginCntMap = dashboardDAO.selectLoginCntInfo(vo);
        returnMap.putAll(loginCntMap);

        if(sqlForeach != null && sqlForeach.length > 0) {
            // 수업운영 게시판 답변 현황 조회
            EgovMap bbsAnsStatusMap = dashboardDAO.selectBbsAnsStatus(vo);
            returnMap.putAll(bbsAnsStatusMap);

            if(userType.contains("PFS")) {
                // 수업운영 점수 현황 (교수)
                EgovMap OprScoreStatusMap = dashboardDAO.selectOprScoreProfStatus(vo);

                if(OprScoreStatusMap != null) {
                    returnMap.putAll(OprScoreStatusMap);
                }
            } else if(userType.contains("TUT")) {
                // 수업운영 점수 현황 (조교)
                EgovMap OprScoreStatusMap = dashboardDAO.selectOprScoreAssistStatus(vo);
                if(OprScoreStatusMap != null) {
                    returnMap.putAll(OprScoreStatusMap);
                }
            }
        }

        return returnMap;
    }

    /*****************************************************
     * 관리자 메인 > 과목별 학습현황
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listLessonStatusByCrs(DashboardVO vo) throws Exception {
        List<EgovMap> list = dashboardDAO.listLessonStatusByCrs(vo);

        for(EgovMap map : list) {
            String crsCd = StringUtil.nvl(map.get("crsCd"));
            String declsNo = StringUtil.nvl(map.get("declsNo"));
            String creYear = StringUtil.nvl(map.get("creYear"));
            String creTerm = StringUtil.nvl(map.get("creTerm"));

            // 수업계획서 링크생성
            String sSmt = creTerm.length() < 2 ? creTerm+"0" : creTerm;
            String sCuriCls = declsNo.length() < 2 ? "0"+declsNo : declsNo;
            String plnParam = "{\"sYear\":\""+creYear+"\",\"sSmt\":\""+sSmt+"\",\"sCuriNum\":\""+crsCd+"\",\"sCuriCls\":\""+sCuriCls+"\"}";
            String lsnPlanUrl = CommConst.LSNPLAN_POP_URL_STD + new String((Base64.getEncoder()).encode(plnParam.getBytes()));

            map.put("lsnPlanUrl", lsnPlanUrl);
        }

        return list;
    }

    /*****************************************************
     * 관리자 메인 > 과목별 학습현황 (엑셀)
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listLessonStatusByCrsExcel(HttpServletRequest request, DashboardVO vo) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        List<EgovMap> list = dashboardDAO.listLessonStatusByCrs(vo);

        String etcText = messageSource.getMessage("dashboard.cor.etc", null, locale); // 기타
        String asmntText = messageSource.getMessage("dashboard.cor.asmnt", null, locale); // 과제
        String forumText = messageSource.getMessage("dashboard.cor.forum", null, locale); // 토론
        String quizText = messageSource.getMessage("dashboard.cor.quiz", null, locale); // 퀴즈
        String minuteText = messageSource.getMessage("date.minute", null, locale); // 분
        String scoreOpenYText = messageSource.getMessage("dashboard.label.score.open.y", null, locale); // 성적공개
        String scoreOpenNText = messageSource.getMessage("dashboard.label.score.open.n", null, locale); // 성적비공개
        String gradeOpenYText = messageSource.getMessage("dashboard.label.score.open.y", null, locale); // 시험지공개
        String gradeOpenNText = messageSource.getMessage("dashboard.label.score.open.n", null, locale); // 시험지비공개

        for(EgovMap map : list) {
            map.put("assistOfceTelno", StringUtil.getPhoneNumber(StringUtil.nvl(map.get("assistOfceTelno"))));

            String midExamInfo = "-";
            String midExamTypeCd = StringUtil.nvl(map.get("midExamTypeCd"));

            if("EXAM".equals(midExamTypeCd)) {
                String midExamStartDttm = StringUtil.nvl(map.get("midExamStartDttm"));
                String midExamStartDttmFmt = "";
                String examStartTm = StringUtil.nvl(map.get("midExamStartTm"), "-") + minuteText;
                String scoreOpenYn = "Y".equals(StringUtil.nvl(map.get("midExamStartDttm"))) ? scoreOpenYText : scoreOpenNText; // 성적공개, 성적비공개
                String midGradeViewYn = "Y".equals(StringUtil.nvl(map.get("midGradeViewYn"))) ? gradeOpenYText : gradeOpenNText; // 시험지공개, 시험지비공개

                if(midExamStartDttm.length() == 14) {
                    midExamStartDttmFmt = midExamStartDttm.substring(0, 4) + "." + midExamStartDttm.substring(4, 6) + "." + midExamStartDttm.substring(6, 8) + " " + midExamStartDttm.substring(8, 10) + ":" + midExamStartDttm.substring(10, 12);
                }

                midExamInfo = midExamStartDttmFmt + "/" + examStartTm + "/" + scoreOpenYn + "/" + midGradeViewYn;
            } else {
                String midInsRefCd = StringUtil.nvl(map.get("midInsRefCd"));

                if(!"".equals(midInsRefCd)) {
                    String midExamCnt = StringUtil.nvl(map.get("midExamCnt"), "-");

                    if("ASMNT".equals(midExamTypeCd)) {
                        midExamInfo = etcText + " (" + asmntText + ": " + midExamCnt + ")";
                    } else if("FORUM".equals(midExamTypeCd)) {
                        midExamInfo = etcText + " (" + forumText + ": " + midExamCnt + ")";
                    } else if("QUIZ".equals(midExamTypeCd)) {
                        midExamInfo = etcText + " (" + quizText + ": " + midExamCnt + ")";
                    }
                } else {
                    midExamInfo = etcText + " (-)";
                }
            }

            String lastExamInfo = "-";
            String lastExamTypeCd = StringUtil.nvl(map.get("lastExamTypeCd"));

            if("EXAM".equals(lastExamTypeCd)) {
                String lastExamStartDttm = StringUtil.nvl(map.get("lastExamStartDttm"));
                String lastExamStartDttmFmt = "";
                String examStartTm = StringUtil.nvl(map.get("lastExamStartTm"), "-") + minuteText;
                String scoreOpenYn = "Y".equals(StringUtil.nvl(map.get("lastExamStartDttm"))) ? scoreOpenYText : scoreOpenNText; // 성적공개, 성적비공개
                String gradeViewYn = "Y".equals(StringUtil.nvl(map.get("lastGradeViewYn"))) ? gradeOpenYText : gradeOpenNText; // 시험지공개, 시험지비공개

                if(lastExamStartDttm.length() == 14) {
                    lastExamStartDttmFmt = lastExamStartDttm.substring(0, 4) + "." + lastExamStartDttm.substring(4, 6) + "." + lastExamStartDttm.substring(6, 8) + " " + lastExamStartDttm.substring(8, 10) + ":" + lastExamStartDttm.substring(10, 12);
                }

                lastExamInfo = lastExamStartDttmFmt + "/" + examStartTm + "/" + scoreOpenYn + "/" + gradeViewYn;
            } else {
                String lastInsRefCd = StringUtil.nvl(map.get("lastInsRefCd"));

                if(!"".equals(lastInsRefCd)) {
                    String lastExamCnt = StringUtil.nvl(map.get("lastExamCnt"), "-");

                    if("ASMNT".equals(lastExamTypeCd)) {
                        lastExamInfo = etcText + " (" + asmntText + ": " + lastExamCnt + ")";
                    } else if("FORUM".equals(lastExamTypeCd)) {
                        lastExamInfo = etcText + " (" + forumText + ": " + lastExamCnt + ")";
                    } else if("QUIZ".equals(lastExamTypeCd)) {
                        lastExamInfo = etcText + " (" + quizText + ": " + lastExamCnt + ")";
                    }
                } else {
                    lastExamInfo = etcText + " (-)";
                }
            }

            map.put("midExamInfo", midExamInfo);
            map.put("lastExamInfo", lastExamInfo);
        }

        return list;
    }

    /*****************************************************
     * 관리자 메인 > 학생별 학습현황
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listLessonStatusByStd(DashboardVO vo) throws Exception {
        return dashboardDAO.listLessonStatusByStd(vo);
    }

    /*****************************************************
     * 관리자 메인 > 사용자 검색
     * @param vo
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> listAdminDashUser(DashboardVO vo) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();

        try {
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getPageScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

            int totCnt = dashboardDAO.countAdminDashUser(vo);

            paginationInfo.setTotalRecordCount(totCnt);

            List<EgovMap> resultList = dashboardDAO.listPagingAdminDashUser(vo);

            processResultVO.setReturnList(resultList);
            processResultVO.setPageInfo(paginationInfo);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

        return processResultVO;
    }

    /**
     * 위젯 설정 팝업
     *
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<DashboardVO> listWidgetSettingPop(DashboardVO vo) throws Exception {
        ProcessResultVO<DashboardVO> resultVO = new ProcessResultVO<>();

        try {
            List<DashboardVO> list = dashboardDAO.listWidgetSettingPop(vo);
            resultVO.setReturnList(list);   // returnList 세팅
            resultVO.setResult(list.size()); // 성공 여부용 result 값
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

        return resultVO;
    }

    @Override
    public void delete(DashboardVO vo) throws Exception {
		/*
		 * dashboardDAO.delete(vo); // USER WIDGET
		 */
    	dashboardDAO.deleteSub(vo); // USER WIDGET
    }

    /*****************************************************
     * <p>
     * TODO 위젯 설정 변경
     * </p>
     * 위젯 설정 변경
     *
     * @param DashboardVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void widgetStngChange(DashboardVO vo) throws Exception {
    	dashboardDAO.widgetStngChange(vo);
    }

    @Override
    public EgovMap widgetStngSelect(DashboardVO vo) throws Exception {
    	// 로그인한 사용자가 변경한 내역이 있으면,
        int cnt = dashboardDAO.widgetStngUseCntSelect(vo);

        if (cnt > 0) {
        	return dashboardDAO.widgetStngSelect(vo);
        } else {
        	return dashboardDAO.widgetDefaultStngSelect(vo);
        }
    }

    @Override
    public EgovMap widgetStngColrSelect(DashboardVO vo) throws Exception {
        return dashboardDAO.widgetStngColrSelect(vo);
    }

    @Override
    public String getUserId(DashboardVO vo) throws Exception {
    	return dashboardDAO.getUserId(vo);
    }

    @Override
    public EgovMap widgetStngPopView(DashboardVO vo) throws Exception {
        return dashboardDAO.widgetStngPopView(vo);
    }

    @Override
    public EgovMap widgetStngColrPopView(DashboardVO vo) throws Exception {
        return dashboardDAO.widgetStngColrPopView(vo);
    }

    /*****************************************************
     * 관리자 메인 > 학생별 학습현황
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public EgovMap lgnUsrCntSelect(DashboardVO vo) throws Exception {
        return dashboardDAO.lgnUsrCntSelect(vo);
    }
    public EgovMap totStdntCntSelect(DashboardVO vo) throws Exception {
        return dashboardDAO.totStdntCntSelect(vo);
    }

    /*****************************************************
     * 관리자 메인 > 학생별 학습현황
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> sbjctList(DashboardVO vo) throws Exception {
        return dashboardDAO.sbjctList(vo);
    }

    /*****************************************************
     * 위젯 초기화 - user 테이블 삭제
     *
     * @param DashboardVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void widgetStngReset(DashboardVO vo) throws Exception {
    	dashboardDAO.widgetStngReset(vo);
    }
}
