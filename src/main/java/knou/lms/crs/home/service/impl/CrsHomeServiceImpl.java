package knou.lms.crs.home.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.util.StringUtil;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.home.dao.CrsHomeDAO;
import knou.lms.crs.home.service.CrsHomeService;
import knou.lms.lesson.dao.LessonScheduleDAO;
import knou.lms.lesson.dao.LessonStudyDAO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyStateVO;
import knou.lms.lesson.vo.LessonVO;
import knou.lms.seminar.dao.SeminarDAO;
import knou.lms.std.vo.StdVO;

/**
 *  <b>
 * @aut
 * hor Jamfam
 *
 */
@Service("crsHomeService")
public class CrsHomeServiceImpl extends EgovAbstractServiceImpl implements CrsHomeService {

    protected final Log log = LogFactory.getLog(getClass());
    
    @Autowired
    private CrsHomeDAO crsHomeDAO; 

    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;
    
    @Resource(name="lessonStudyDAO")
    private LessonStudyDAO lessonStudyDAO;
    
    @Resource(name="seminarDAO")
    private SeminarDAO seminarDAO;
    
    @Resource(name="sysFileService")
    private SysFileService sysFileService;
    
    /**
     * <p>
     * 평가기준 목록
     *
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     */
    @Override
    public List<EgovMap> listEvalCriteria(DefaultVO vo) throws Exception {
        return crsHomeDAO.listEvalCriteria(vo);
    }

    /**
     * <p>
     * 평가기준 목록 페이징
     *
     * @param vo
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> listEvalCriteriaPaging(DefaultVO vo) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();
        
        try {
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getPageScale());
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            int totCnt = crsHomeDAO.countEvalCriteria(vo);
            
            paginationInfo.setTotalRecordCount(totCnt);
            
            List<EgovMap> resultList = crsHomeDAO.listEvalCriteriaPaging(vo);
            
            processResultVO.setReturnList(resultList);
            processResultVO.setPageInfo(paginationInfo);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return processResultVO;
    }

    /**
     * <p>
     * 평가기준 성적반영비율 수정
     *
     * @param vo
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     */
    @Override
    public void updateEvalCriteriaScoreRatio(DefaultVO vo, List<String> keyList, List<Integer> scoreRatioList) throws Exception {
        String searchKey    = vo.getSearchKey();
        String mdfrId        = vo.getMdfrId();
        
        // 1. 성적반영비율 대상 목록 조회
        vo.setSearchValue(null);
        List<EgovMap> listScoreAppyY = crsHomeDAO.listEvalCriteriaScoreAppyY(vo);
        
        if(listScoreAppyY == null) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw processException("common.system.error");
        }
        
        // 2. 합계 100 체크
        Map<String, Integer> scoreRatioMap = new HashMap<>();
        
        for(int i = 0; i < keyList.size(); i++) {
            scoreRatioMap.put(keyList.get(i), scoreRatioList.get(i));
        }
        
        int scroeRatio = 0;
        
        for(EgovMap item : listScoreAppyY) {
            String key = "";
            
            if("ASMNT".equals(searchKey)) {
                key = item.get("asmntCd").toString();
            } else if("FORUM".equals(searchKey)) {
                key = item.get("forumCd").toString();
            } else if("EXAM".equals(searchKey)) {
                key = item.get("examCd").toString();
            } else if("QUIZ".equals(searchKey)) {
                key = item.get("examCd").toString();
            } else if("RESCH".equals(searchKey)) {
                key = item.get("reschCd").toString();
            }
            
            if(scoreRatioMap.containsKey(key)) {
                // 페이지 입력 값
                scroeRatio += scoreRatioMap.get(key);
                
                log.debug("성적반영 비율 Input : " + scoreRatioMap.get(key));
            } else {
                // DB 값
                if(item.get("scroeRatio") != null) {
                    scroeRatio += (int) item.get("scroeRatio");
                    log.debug("성적반영 비율 : " + item.get("scroeRatio"));
                }
            }
        }
        
        if(scroeRatio != 100) {
            log.debug("성적반영 비율 Sum : " + scroeRatio);
            // 성적반영 비율 합이 100%이여야 합니다.
            throw processException("crs.message.error.score_apply_sum");
        }
        
        // 3. 성적반영비율 수정
        EgovMap egovMap;
        
        for(int i = 0; i < keyList.size(); i++) {
            egovMap = new EgovMap();
            egovMap.put("searchKey", searchKey);
            egovMap.put("scoreRatio", scoreRatioList.get(i));
            egovMap.put("mdfrId", mdfrId);
            
            if("ASMNT".equals(searchKey)) {
                egovMap.put("asmntCd", keyList.get(i));
            } else if("FORUM".equals(searchKey)) {
                egovMap.put("forumCd", keyList.get(i));
            } else if("EXAM".equals(searchKey)) {
                egovMap.put("examCd", keyList.get(i));
            } else if("QUIZ".equals(searchKey)) {
                egovMap.put("examCd", keyList.get(i));
            } else if("RESCH".equals(searchKey)) {
                egovMap.put("reschCd", keyList.get(i));
            }
            
            crsHomeDAO.updateEvalCriteriaScoreRatio(egovMap);
        }
    }

    /**
     * <p>
     * 강의실 홈 학습요소 참여현황
     *
     * @param vo
     * @return EgovMap
     * @throws Exception
     */
    @Override
    public EgovMap selectCrsHomeStdJoinStatus(StdVO vo) throws Exception {
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
            
            // 진행 주차만 체크, 시험기간 제외, 세미나 주차 or 출결체크 동영강 강의 주차
            if("Y".equals(startDtYn) && !isExam && (isSeminar || prgrVideoCnt > 0)) {
                String lessonScheduleId = lessonScheduleVO2.getLessonScheduleId();
                listLessonScheduleId.add(lessonScheduleId);
            }
        }
        
        if(listLessonScheduleId.size() > 0) {
            vo.setSqlForeach(listLessonScheduleId.toArray(new String[listLessonScheduleId.size()]));
        }
        
        return crsHomeDAO.selectCrsHomeStdJoinStatus(vo);
    }
    
    /**
     * *************************************************** 
     * 강의실 교수 홈 학습요소 상태
     * @param vo
     * @return EgovMap
     * @throws Exception
     *****************************************************
     */
    public EgovMap selectCrsHomeProfElementStatus(DefaultVO vo) throws Exception {
        return crsHomeDAO.selectCrsHomeProfElementStatus(vo);
    }
    
    /*****************************************************
     * 강의실 홈 주차 목록
     * @param vo
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LessonScheduleVO> listCrsHomeLessonSchedule(LessonVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        
        // 주차, 교시, 학습자료 포함 목록 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLcdmsLinkYn(vo.getLcdmsLinkYn());
        List<LessonScheduleVO> listLessonScheduleAll = lessonScheduleDAO.listLessonScheduleAll(lessonScheduleVO);
        
        List<EgovMap> listCrsHomeAExam = crsHomeDAO.listCrsHomeAExam(vo);       // 상시시험
        List<EgovMap> listCrsHomeQuiz = crsHomeDAO.listCrsHomeQuiz(vo);         // 퀴즈
        List<EgovMap> listCrsHomeAsmnt = crsHomeDAO.listCrsHomeAsmnt(vo);       // 과제
        List<EgovMap> listCrsHomeForum = crsHomeDAO.listCrsHomeForum(vo);       // 토론
        List<EgovMap> listCrsHomeResch = crsHomeDAO.listCrsHomeResch(vo);       // 설문
        List<EgovMap> listCrsHomeExam = crsHomeDAO.listCrsHomeExam(vo);         // 시험
        List<EgovMap> listCrsHomeSeminar = crsHomeDAO.listCrsHomeSeminar(vo);  // 세미나
        
        HashMap<String, ArrayList<EgovMap>> crsHomeAExamMap = new HashMap<>();
        HashMap<String, ArrayList<EgovMap>> crsHomeQuizMap = new HashMap<>();
        HashMap<String, ArrayList<EgovMap>> crsHomeAsmntMap = new HashMap<>();
        HashMap<String, ArrayList<EgovMap>> crsHomeForumMap = new HashMap<>();
        HashMap<String, ArrayList<EgovMap>> crsHomeReschMap = new HashMap<>();
        HashMap<String, ArrayList<EgovMap>> crsHomeExamMap = new HashMap<>();
        HashMap<String, ArrayList<EgovMap>> crsHomeSeminarMap = new HashMap<>();
        
        // 주차 학습현황 조회
        LessonStudyStateVO stateVO = new LessonStudyStateVO();
        stateVO.setCrsCreCd(vo.getCrsCreCd());
        stateVO.setStdId(vo.getUserId());
        stateVO.setUserId(vo.getUserId());
        
        List<LessonStudyStateVO> stateList = lessonStudyDAO.listLessonStudyStateTm(stateVO); 
        HashMap<String, LessonStudyStateVO> stateMap = new HashMap<>();
        
        for (LessonStudyStateVO stateVO2 : stateList) {
            stateMap.put(stateVO2.getLessonScheduleId(), stateVO2);
        }
        
        String lessonScheduleId;
        
        // 시험
        for(EgovMap map : listCrsHomeExam) {
            String examStareTypeCd = map.get("examStareTypeCd").toString();
            
            if(!crsHomeExamMap.containsKey(examStareTypeCd)) {
                crsHomeExamMap.put(examStareTypeCd, new ArrayList<EgovMap>());
            }
            
            crsHomeExamMap.get(examStareTypeCd).add(map);
        }
        
        // 상시시험
        for(EgovMap map : listCrsHomeAExam) {
            lessonScheduleId = map.get("lessonScheduleId").toString();
            
            if(!crsHomeAExamMap.containsKey(lessonScheduleId)) {
                crsHomeAExamMap.put(lessonScheduleId, new ArrayList<EgovMap>());
            }
            
            crsHomeAExamMap.get(lessonScheduleId).add(map);
        }
        
        // 과제
        for(EgovMap map : listCrsHomeAsmnt) {
            lessonScheduleId = map.get("lessonScheduleId").toString();
            
            if(!crsHomeAsmntMap.containsKey(lessonScheduleId)) {
                crsHomeAsmntMap.put(lessonScheduleId, new ArrayList<EgovMap>());
            }
            
            crsHomeAsmntMap.get(lessonScheduleId).add(map);
        }
        
        // 토론
        for(EgovMap map : listCrsHomeForum) {
            lessonScheduleId = map.get("lessonScheduleId").toString();
            
            if(!crsHomeForumMap.containsKey(lessonScheduleId)) {
                crsHomeForumMap.put(lessonScheduleId, new ArrayList<EgovMap>());
            }
            
            crsHomeForumMap.get(lessonScheduleId).add(map);
        }
        
        // 퀴즈
        for(EgovMap map : listCrsHomeQuiz) {
            lessonScheduleId = map.get("lessonScheduleId").toString();
            
            if(!crsHomeQuizMap.containsKey(lessonScheduleId)) {
                crsHomeQuizMap.put(lessonScheduleId, new ArrayList<EgovMap>());
            }
            
            crsHomeQuizMap.get(lessonScheduleId).add(map);
        }
        
        // 설문
        for(EgovMap map : listCrsHomeResch) {
            lessonScheduleId = map.get("lessonScheduleId").toString();
            
            if(!crsHomeReschMap.containsKey(lessonScheduleId)) {
                crsHomeReschMap.put(lessonScheduleId, new ArrayList<EgovMap>());
            }
            
            crsHomeReschMap.get(lessonScheduleId).add(map);
        }
        
        // 세미나
        for(EgovMap map : listCrsHomeSeminar) {
            lessonScheduleId = map.get("lessonScheduleId").toString();
            if(!crsHomeSeminarMap.containsKey(lessonScheduleId)) {
                crsHomeSeminarMap.put(lessonScheduleId, new ArrayList<EgovMap>());
            }
            
            crsHomeSeminarMap.get(lessonScheduleId).add(map);
        }
        
        // 주차 리스트에 통합
        HashMap<String, Object> map;
        for(LessonScheduleVO lessonScheduleVO2 : listLessonScheduleAll) {
            map = new HashMap<>();
            
            lessonScheduleId = lessonScheduleVO2.getLessonScheduleId();
            String examStareTypeCd = StringUtil.nvl(lessonScheduleVO2.getExamStareTypeCd());
            
            // 시험
            if("M".equals(examStareTypeCd) && crsHomeExamMap.containsKey("M")) {
                map.put("listCrsHomeExam", crsHomeExamMap.get("M"));
            } else if("L".equals(examStareTypeCd) && crsHomeExamMap.containsKey("L")) {
                map.put("listCrsHomeExam", crsHomeExamMap.get("L"));
            } else {
                map.put("listCrsHomeExam", new ArrayList<EgovMap>());
            }
            
            // 상시시험
            if(crsHomeAExamMap.containsKey(lessonScheduleId)) {
                map.put("listCrsHomeAExam", crsHomeAExamMap.get(lessonScheduleId));
            } else {
                map.put("listCrsHomeAExam", new ArrayList<EgovMap>());
            }
            
            // 과제
            if(crsHomeAsmntMap.containsKey(lessonScheduleId)) {
                map.put("listCrsHomeAsmnt", crsHomeAsmntMap.get(lessonScheduleId));
            } else {
                map.put("listCrsHomeAsmnt", new ArrayList<EgovMap>());
            }
            
            // 토론
            if(crsHomeForumMap.containsKey(lessonScheduleId)) {
                map.put("listCrsHomeForum", crsHomeForumMap.get(lessonScheduleId));
            } else {
                map.put("listCrsHomeForum", new ArrayList<EgovMap>());
            }
            
            // 퀴즈
            if(crsHomeQuizMap.containsKey(lessonScheduleId)) {
                map.put("listCrsHomeQuiz", crsHomeQuizMap.get(lessonScheduleId));
            } else {
                map.put("listCrsHomeQuiz", new ArrayList<EgovMap>());
            }
            
            // 설문
            if(crsHomeReschMap.containsKey(lessonScheduleId)) {
                map.put("listCrsHomeResch", crsHomeReschMap.get(lessonScheduleId));
            } else {
                map.put("listCrsHomeResch", new ArrayList<EgovMap>());
            }
            
            // 세미나
            if(crsHomeSeminarMap.containsKey(lessonScheduleId)) {
                map.put("listCrsHomeSeminar", crsHomeSeminarMap.get(lessonScheduleId));
            } else {
                map.put("listCrsHomeSeminar", new ArrayList<EgovMap>());
            }
            
            // 주차 학습상태,학습시간
            if (stateMap.containsKey(lessonScheduleVO2.getLessonScheduleId())) {
                stateVO = stateMap.get(lessonScheduleVO2.getLessonScheduleId());
                lessonScheduleVO2.setStudyStatusCd(stateVO.getStudyStatusCd());
                lessonScheduleVO2.setStudyTotalTm(stateVO.getStudyTotalTm());
                lessonScheduleVO2.setStudyAfterTm(stateVO.getStudyAfterTm());
            }
            else {
                lessonScheduleVO2.setStudyStatusCd("NOSTUDY");
                lessonScheduleVO2.setStudyTotalTm(0);
                lessonScheduleVO2.setStudyAfterTm(0);
            }
            
            lessonScheduleVO2.setStudyElementMap(map);
        }
        
        return listLessonScheduleAll;
    }

    /*****************************************************
     * 강의실 홈 참여현황
     * @param vo
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap crsHomeScheduleListStatus(EgovMap map) throws Exception {
        return crsHomeDAO.crsHomeScheduleListStatus(map);
    }

    /*****************************************************
     * 강의실 홈 현재 주차
     * @param vo
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap crsHomeCurrentWeek(LessonScheduleVO vo) throws Exception {
        return crsHomeDAO.crsHomeCurrentWeek(vo);
    }
}