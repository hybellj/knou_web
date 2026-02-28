package knou.lms.score.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.LocaleUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.dao.TermDAO;
import knou.lms.crs.term.vo.CrsTermLessonVO;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.score.dao.ScoreDAO;
import knou.lms.score.service.ScoreService;
import knou.lms.score.vo.OprScoreAssistVO;
import knou.lms.score.vo.OprScoreProfVO;
import knou.lms.score.vo.ScoreVO;

@Service("scoreService")
public class ScoreServiceImpl extends ServiceBase implements ScoreService {
    @Resource(name="scoreDAO")
    private ScoreDAO scoreDAO;
    
    @Resource(name="termDAO")
    private TermDAO termDAO;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    /**
     * TODO 성적 항목 설정을 등록한다.
     * 성적 항목 설정을 등록한다.
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<ScoreVO> copyScoreItemConf(ScoreVO vo) throws Exception
    {
        ProcessResultVO<ScoreVO> resultVO = new ProcessResultVO<ScoreVO>();
        int crsCreCdChk = 0;
        try
        {
            crsCreCdChk = scoreDAO.selectScoreItemChk(vo);
            
            if(crsCreCdChk == 0) {
                //평가기준이 해당과목으로 등록이 안되있을때만 INSERT 2023-06-16 jsw 수정
                scoreDAO.copyScoreItemConf(vo);
            }
            
            resultVO.setResult(1);
        } catch (Exception e)
        {
            e.printStackTrace();
            resultVO.setResult(-1);
            throw e;
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 수업운영 점수
     * @param vo
     * @return OprScoreProfVO
     * @throws Exception
     ******************************************************/
    public OprScoreProfVO selectOprScoreProf(OprScoreProfVO vo) throws Exception {
        return scoreDAO.selectOprScoreProf(vo);
    }
    
    /***************************************************** 
     * 수업운영 점수합  (교수)
     * @param vo
     * @return OprScoreProfVO
     * @throws Exception
     ******************************************************/
    public OprScoreProfVO selectOprScoreProfTotal(OprScoreProfVO vo) throws Exception {
        return scoreDAO.selectOprScoreProfTotal(vo);
    }

    /***************************************************** 
     * 관리자 > 수업운영도구 > 수업운영 점수등록(교수) 목록
     * @param vo
     * @return List<OprScoreProfVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<OprScoreProfVO> listOprScoreProfWrite(OprScoreProfVO vo) throws Exception {
        return scoreDAO.listOprScoreProfWrite(vo);
    }

    /***************************************************** 
     * 관리자 > 수업운영도구 > 수업운영 점수전체(교수) 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listOprScoreProfTotal(OprScoreProfVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String haksaYear = vo.getHaksaYear();
        String haksaTerm = vo.getHaksaTerm();
        String termCd = vo.getTermCd();
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO.setHaksaYear(haksaYear);
        termVO.setHaksaTerm(haksaTerm);
        termVO.setTermCd(termCd);
        
        List<CrsTermLessonVO> listTermLesson = termDAO.listTermLesson(termVO);
        List<String> listLsnOdr = new ArrayList<>();
        
        for(CrsTermLessonVO crsTermLessonVO : listTermLesson) {
            Integer lsnOdr = crsTermLessonVO.getLsnOdr();
            
            if(lsnOdr != null) {
                listLsnOdr.add(lsnOdr.toString());
            }
        }
        
        if(listLsnOdr.size() > 0) {
            vo.setSqlForeach(listLsnOdr.toArray(new String[listLsnOdr.size()]));
        }
        
        return scoreDAO.listOprScoreProfTotal(vo);
    }
    
    /***************************************************** 
     * 관리자 > 수업운영도구 > 수업운영 점수(교수) 벌점원인 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listOprScoreProfPanaltyReason(OprScoreProfVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String haksaYear = vo.getHaksaYear();
        String haksaTerm = vo.getHaksaTerm();
        String termCd = vo.getTermCd();
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO.setHaksaYear(haksaYear);
        termVO.setHaksaTerm(haksaTerm);
        termVO.setTermCd(termCd);
        
        List<CrsTermLessonVO> listTermLesson = termDAO.listTermLesson(termVO);
        List<String> listLsnOdr = new ArrayList<>();
        
        for(CrsTermLessonVO crsTermLessonVO : listTermLesson) {
            Integer lsnOdr = crsTermLessonVO.getLsnOdr();
            
            if(lsnOdr != null) {
                listLsnOdr.add(lsnOdr.toString());
            }
        }
        
        if(listLsnOdr.size() > 0) {
            vo.setSqlForeach(listLsnOdr.toArray(new String[listLsnOdr.size()]));
        }
        
        return scoreDAO.listOprScoreProfPanaltyReason(vo);
    }
    
    /***************************************************** 
     * 관리자 > 수업운영도구 > 수업운영 점수(교수) 교수별 통계 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listOprScoreStatusByProf(OprScoreProfVO vo) throws Exception {
        return scoreDAO.listOprScoreStatusByProf(vo);
    }
    
    /***************************************************** 
     * 수업운영점수등록(교수)
     * @param request
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void updateOprScoreProf(HttpServletRequest request, List<OprScoreProfVO> list) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String userId = SessionInfo.getUserId(request);
        
        for(OprScoreProfVO oprScoreProfVO : list) {
            //String lineNo = oprScoreProfVO.getLineNo();
            
            float score01 = oprScoreProfVO.getScore01(); // (-) 수업계획서 입력기간 준수 감점
            float score02 = oprScoreProfVO.getScore02(); // (-) 종합성적 산출기간 미준수 감점
            float score03 = oprScoreProfVO.getScore03(); // (+) 평가기준 활용 가점
            float score04 = oprScoreProfVO.getScore04(); // (-) 평가기준 정정 감점
            float score05 = oprScoreProfVO.getScore05(); // (+) 공지사항 건당 가점
            float score06 = oprScoreProfVO.getScore06(); // (-) 강의QnA 72시간 미답변 건당 감점
            float score07 = oprScoreProfVO.getScore07(); // (-) 1:1상담 72시간 미답변 건당 감점
            float score08 = oprScoreProfVO.getScore08(); // (+) 학습독려 메일발송 건당 가점
            float score09 = oprScoreProfVO.getScore09(); // (+) 학습독려 SMS발송 건당 가점
            float score10 = oprScoreProfVO.getScore10(); // (+) 학습독려 PUSH발송 건당 가점
            float score11 = oprScoreProfVO.getScore11(); // (-) 시험출제 및 검수지연 감점
            float score12 = oprScoreProfVO.getScore12(); // (+) 시험배수출제 가점
            float score13 = oprScoreProfVO.getScore13(); // (-) 시험중복출제 감점
            float score14 = oprScoreProfVO.getScore14(); // (+) 학습독려 쪽지발송 건당 가점
            
            // 감점 : score01, score02, score04, score06, score07, score11, score13
            // 가점 : score03, score05, score08, score09, score10, score12, score14
            
            // 감점 체크 (양수 불가)
            if(score01 > 0) {
                // 수업계획서 입력기간 준수
                String title = messageSource.getMessage("score.label.prof.oper.score01", null, locale);
                throw processException("score.errors.input.zero.minus", new String[] {title});
            }
            if(score02 > 0) {
                // 종합성적 산출기간 준수
                String title = messageSource.getMessage("score.label.prof.oper.score02", null, locale);
                throw processException("score.errors.input.zero.minus", new String[] {title});
            }
            if(score04 > 0) {
                // 평가기준정정
                String title = messageSource.getMessage("score.label.prof.oper.score04", null, locale);
                throw processException("score.errors.input.zero.minus", new String[] {title});
            }
            if(score06 > 0) {
                // 강의Q&A
                String title = messageSource.getMessage("score.label.prof.oper.score06", null, locale);
                throw processException("score.errors.input.zero.minus", new String[] {title});
            }
            if(score07 > 0) {
                // 1:1상담
                String title = messageSource.getMessage("score.label.prof.oper.score07", null, locale);
                throw processException("score.errors.input.zero.minus", new String[] {title});
            }
            if(score11 > 0) {
                // 중간/기말 시험출제 및 검수일 준수
                String title = messageSource.getMessage("score.label.prof.oper.score11", null, locale);
                throw processException("score.errors.input.zero.minus", new String[] {title});
            }
            if(score13 > 0) {
                // 시험중복출제
                String title = messageSource.getMessage("score.label.prof.oper.score13", null, locale);
                throw processException("score.errors.input.zero.minus", new String[] {title});
            }
            
            // 가점 체크 (음수 불가)
            if(score03 < 0) {
                // 평가기준활용
                String title = messageSource.getMessage("score.label.prof.oper.score03", null, locale);
                throw processException("score.errors.input.zero.plus", new String[] {title});
            }
            if(score05 < 0) {
                // 공지사항
                String title = messageSource.getMessage("score.label.prof.oper.score05", null, locale);
                throw processException("score.errors.input.zero.plus", new String[] {title});
            }
            if(score08 < 0) {
                // 메일발송
                String title = messageSource.getMessage("score.label.prof.oper.score08", null, locale);
                throw processException("score.errors.input.zero.plus", new String[] {title});
            }
            if(score09 < 0) {
                // SMS발송
                String title = messageSource.getMessage("score.label.prof.oper.score09", null, locale);
                throw processException("score.errors.input.zero.plus", new String[] {title});
            }
            if(score10 < 0) {
                // PUSH발송
                String title = messageSource.getMessage("score.label.prof.oper.score10", null, locale);
                throw processException("score.errors.input.zero.plus", new String[] {title});
            }
            if(score12 < 0) {
                // 시험배수출제
                String title = messageSource.getMessage("score.label.prof.oper.score12", null, locale);
                throw processException("score.errors.input.zero.plus", new String[] {title});
            }
            
            if(score14 < 0) {
                // 시험배수출제
                String title = messageSource.getMessage("score.label.prof.oper.score14", null, locale);
                throw processException("score.errors.input.zero.plus", new String[] {title});
            }
            
            float totScore = score01 + score02 + score03 + score04 + score05
                    + score06 + score07 + score08 + score09 + score10
                    + score11 + score12 + score13 + score14;
            
            oprScoreProfVO.setTotScore(totScore);
            oprScoreProfVO.setRgtrId(userId);
            oprScoreProfVO.setMdfrId(userId);
        }
        
        int batchSize = 500;
        for (int i = 0; i < list.size(); i += batchSize) {
            int endIndex = Math.min(i + batchSize, list.size());
            List<OprScoreProfVO> sublist = list.subList(i, endIndex);
            
            scoreDAO.updateOprScoreProf(sublist);
        }
    }
    
    /***************************************************** 
     * 수업운영점수삭제(교수)
     * @param request
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void deleteOprScoreProf(HttpServletRequest request, List<OprScoreProfVO> list) throws Exception {
        String userId = SessionInfo.getUserId(request);
        
        for(OprScoreProfVO oprScoreProfVO : list) {
            oprScoreProfVO.setRgtrId(userId);
            oprScoreProfVO.setMdfrId(userId);
        }
     
        int batchSize = 500;
        for (int i = 0; i < list.size(); i += batchSize) {
            int endIndex = Math.min(i + batchSize, list.size());
            List<OprScoreProfVO> sublist = list.subList(i, endIndex);
            
            scoreDAO.deleteOprScoreProf(sublist);
        }
    }
    
    /***************************************************** 
     * 수업운영 점수 (조교)
     * @param vo
     * @return OprScoreAssistVO
     * @throws Exception
     ******************************************************/
    public OprScoreAssistVO selectOprScoreAssist(OprScoreAssistVO vo) throws Exception {
        return scoreDAO.selectOprScoreAssist(vo);
    }
    
    /***************************************************** 
     * 수업운영 점수합  (조교)
     * @param vo
     * @return OprScoreProfVO
     * @throws Exception
     ******************************************************/
    public OprScoreAssistVO selectOprScoreAssistTotal(OprScoreAssistVO vo) throws Exception {
        return scoreDAO.selectOprScoreAssistTotal(vo);
    }

    /***************************************************** 
     * 관리자 > 수업운영도구 > 수업운영 점수등록(조교) 목록
     * @param vo
     * @return List<OprScoreAssistVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<OprScoreAssistVO> listOprScoreAssistWrite(OprScoreAssistVO vo) throws Exception {
        return scoreDAO.listOprScoreAssistWrite(vo);
    }

    /***************************************************** 
     * 관리자 > 수업운영도구 > 수업운영 점수전체(조교) 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listOprScoreAssistTotal(OprScoreAssistVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String haksaYear = vo.getHaksaYear();
        String haksaTerm = vo.getHaksaTerm();
        String termCd = vo.getTermCd();
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO.setHaksaYear(haksaYear);
        termVO.setHaksaTerm(haksaTerm);
        termVO.setTermCd(termCd);
        
        List<CrsTermLessonVO> listTermLesson = termDAO.listTermLesson(termVO);
        List<String> listLsnOdr = new ArrayList<>();
        
        for(CrsTermLessonVO crsTermLessonVO : listTermLesson) {
            Integer lsnOdr = crsTermLessonVO.getLsnOdr();
            
            if(lsnOdr != null) {
                listLsnOdr.add(lsnOdr.toString());
            }
        }
        
        if(listLsnOdr.size() > 0) {
            vo.setSqlForeach(listLsnOdr.toArray(new String[listLsnOdr.size()]));
        }
        
        return scoreDAO.listOprScoreAssistTotal(vo);
    }
    
    /***************************************************** 
     * 수업운영점수등록(조교)
     * @param request
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void updateOprScoreAssist(HttpServletRequest request, List<OprScoreAssistVO> list) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String userId = SessionInfo.getUserId(request);
        
        for(OprScoreAssistVO oprScoreAssistVO : list) {
            //String lineNo = oprScoreAssistVO.getLineNo();
            
            float score01 = oprScoreAssistVO.getScore01(); // (-) 주간운영 보고서
            float score02 = oprScoreAssistVO.getScore02(); // (-) 콘텐츠 검수
            float score03 = oprScoreAssistVO.getScore03(); // (-) 강의Q&A
            float score04 = oprScoreAssistVO.getScore04(); // (-) 1:1상담
            float score05 = oprScoreAssistVO.getScore05(); // (+) 강의자료실
            float score06 = oprScoreAssistVO.getScore06(); // (+) 메일발송
            float score07 = oprScoreAssistVO.getScore07(); // (+) SMS발송
            float score08 = oprScoreAssistVO.getScore08(); // (+) PUSH발송
            float score09 = oprScoreAssistVO.getScore09(); // (+) 쪽지발송
            
            // 감점 : score01, score02, score03, score04
            // 가점 : score05, score06, score07, score08, score09
            
            // 감점 체크 (양수 불가)
            if(score01 > 0) {
                // 주간운영 보고서
                String title = messageSource.getMessage("score.label.assist.oper.score01", null, locale);
                throw processException("score.errors.input.zero.minus", new String[] {title});
            }
            if(score02 > 0) {
                // 콘텐츠 검수
                String title = messageSource.getMessage("score.label.assist.oper.score02", null, locale);
                throw processException("score.errors.input.zero.minus", new String[] {title});
            }
            if(score03 > 0) {
                // 강의Q&A
                String title = messageSource.getMessage("score.label.assist.oper.score03", null, locale);
                throw processException("score.errors.input.zero.minus", new String[] {title});
            }
            if(score04 > 0) {
                // 1:1상담
                String title = messageSource.getMessage("score.label.assist.oper.score04", null, locale);
                throw processException("score.errors.input.zero.minus", new String[] {title});
            }
            
            
            // 가점 체크 (음수 불가)
            if(score05 < 0) {
                // 강의자료실
                String title = messageSource.getMessage("score.label.assist.oper.score05", null, locale);
                throw processException("score.errors.input.zero.plus", new String[] {title});
            }
            if(score06 < 0) {
                // 메일발송
                String title = messageSource.getMessage("score.label.assist.oper.score06", null, locale);
                throw processException("score.errors.input.zero.plus", new String[] {title});
            }
            if(score07 < 0) {
                // SMS발송
                String title = messageSource.getMessage("score.label.assist.oper.score07", null, locale);
                throw processException("score.errors.input.zero.plus", new String[] {title});
            }
            if(score08 < 0) {
                // PUSH발송
                String title = messageSource.getMessage("score.label.assist.oper.score08", null, locale);
                throw processException("score.errors.input.zero.plus", new String[] {title});
            }
            if(score09 < 0) {
                // 쪽지발송
                String title = messageSource.getMessage("score.label.assist.oper.score09", null, locale);
                throw processException("score.errors.input.zero.plus", new String[] {title});
            }
            
            float totScore = score01 + score02 + score03 + score04 + score05
                    + score06 + score07 + score08 + score09;
            
            oprScoreAssistVO.setTotScore(totScore);
            oprScoreAssistVO.setRgtrId(userId);
            oprScoreAssistVO.setMdfrId(userId);
        }
        
        int batchSize = 500;
        for (int i = 0; i < list.size(); i += batchSize) {
            int endIndex = Math.min(i + batchSize, list.size());
            List<OprScoreAssistVO> sublist = list.subList(i, endIndex);
            
            scoreDAO.updateOprScoreAssist(sublist);
        }
    }
    
    /***************************************************** 
     * 수업운영점수삭제(조교)
     * @param request
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void deleteOprScoreAssist(HttpServletRequest request, List<OprScoreAssistVO> list) throws Exception {
        String userId = SessionInfo.getUserId(request);
        
        for(OprScoreAssistVO oprScoreAssistVO : list) {
            oprScoreAssistVO.setRgtrId(userId);
            oprScoreAssistVO.setMdfrId(userId);
        }
        
        int batchSize = 500;
        for (int i = 0; i < list.size(); i += batchSize) {
            int endIndex = Math.min(i + batchSize, list.size());
            List<OprScoreAssistVO> sublist = list.subList(i, endIndex);
            
            scoreDAO.deleteOprScoreAssist(sublist);
        }
    }

    /***************************************************** 
     * 테스트
     * @param request
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void profCalcScore() throws Exception {
        Map<String, Object> map = new HashMap<>();
        
        // 테스트
        map.put("orgId", "ORG0000001");
        map.put("haksaYear", "2023");
        map.put("haksaTerm", "10");
        map.put("lessonScheduleOrder", "7");
        map.put("tchTypeList", new String[] {"PROF", "ASSOCIATE"});
        
        
        List<OprScoreProfVO> listOprScoreProf = scoreDAO.listOprScoreProf(map);
        
        // SCORE03 - 평가기준 활용 가점 (4개 +0.1 OR 5개 +0.2)
        List<Map<String, Object>> score03List = scoreDAO.listProfScoreItemConf(map);
        Map<String, Float> score03Map = new HashMap<>();
        for(Map<String, Object> resultMap : score03List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score03Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        // SCORE05 - 공지사항 건당 가점 (+0.1/건)
        map.put("bbsCd", "NOTICE");
        List<Map<String, Object>> score05List = scoreDAO.listOperAtclCount(map);
        Map<String, Float> score05Map = new HashMap<>();
        for(Map<String, Object> resultMap : score05List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score05Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        // SCORE06 - 강의Q&A 72시간 미답변 건당 감점  (-0.2/건)
        map.put("bbsCd", "QNA");
        List<Map<String, Object>> score06List = scoreDAO.listOperNoAnsAtclCount(map);
        Map<String, Float> score06Map = new HashMap<>();
        for(Map<String, Object> resultMap : score06List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score06Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        // SCORE07 - 1:1상담 72시간 미답변 건당 감점  (-0.2/건)
        map.put("bbsCd", "SECRET");
        List<Map<String, Object>> score07List = scoreDAO.listOperNoAnsAtclCount(map);
        Map<String, Float> score07Map = new HashMap<>();
        for(Map<String, Object> resultMap : score07List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score07Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        map.remove("bbsCd");
        
        // SCORE08 - 학습독려 메일발송 (+0.1/건)
        map.put("msgDivCd", "EMAIL");
        List<Map<String, Object>> score08List = scoreDAO.listOperMessageCount(map);
        Map<String, Float> score08Map = new HashMap<>();
        for(Map<String, Object> resultMap : score08List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score08Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        // SCORE09 - 학습독려 SMS발송 (+0.1/건)
        map.put("msgDivCd", "SMS");
        List<Map<String, Object>> score09List = scoreDAO.listOperMessageCount(map);
        Map<String, Float> score09Map = new HashMap<>();
        for(Map<String, Object> resultMap : score09List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score09Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        // SCORE10 - 학습독려 PUSH발송 (+0.1/건)
        map.put("msgDivCd", "PUSH");
        List<Map<String, Object>> score10List = scoreDAO.listOperMessageCount(map);
        Map<String, Float> score10Map = new HashMap<>();
        for(Map<String, Object> resultMap : score10List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score10Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        for(OprScoreProfVO oprScoreProfVO : listOprScoreProf) {
            String key = oprScoreProfVO.getUserId() + "_" + oprScoreProfVO.getLessonScheduleId();
            
            // SCORE03 - 평가기준 활용 가점 (4개 +0.1 OR 5개 +0.2)
            if(score03Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score03Map.get(key);
                
                if(cnt > 5) {
                    score = 0.2f;
                } else if(cnt > 4) {
                    score = 0.1f;
                }
                
                oprScoreProfVO.setScore03(score);
            } else {
                oprScoreProfVO.setScore03(0);
            }
            
            // SCORE05 - 공지사항 건당 가점 (+0.1/건)
            if(score05Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score05Map.get(key);
                
                score = cnt * 0.1f;
                
                oprScoreProfVO.setScore05(score);
            } else {
                oprScoreProfVO.setScore05(0);
            }
            
            // SCORE06 - 강의Q&A 72시간 미답변 건당 감점  (-0.2/건)
            if(score06Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score06Map.get(key);
                
                score = cnt * -0.2f;
                
                oprScoreProfVO.setScore06(score);
            } else {
                oprScoreProfVO.setScore06(0);
            }
            
            // SCORE07 - 1:1상담 72시간 미답변 건당 감점  (-0.2/건)
            if(score07Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score07Map.get(key);
                
                score = cnt * -0.2f;
                
                oprScoreProfVO.setScore07(score);
            } else {
                oprScoreProfVO.setScore07(0);
            }
            
            // SCORE08 - 학습독려 메일발송 (+0.1/건)
            if(score08Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score08Map.get(key);
                
                score = cnt * 0.1f;
                
                oprScoreProfVO.setScore08(score);
            } else {
                oprScoreProfVO.setScore08(0);
            }
            
            // SCORE09 - 학습독려 SMS발송 (+0.1/건)
            if(score09Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score09Map.get(key);
                
                score = cnt * 0.1f;
                
                oprScoreProfVO.setScore09(score);
            } else {
                oprScoreProfVO.setScore09(0);
            }
            
            // SCORE10 - 학습독려 PUSH발송 (+0.1/건)
            if(score10Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score10Map.get(key);
                
                score = cnt * 0.1f;
                
                oprScoreProfVO.setScore10(score);
            } else {
                oprScoreProfVO.setScore10(0);
            }
            
            float score01 = oprScoreProfVO.getScore01();
            float score02 = oprScoreProfVO.getScore02();
            float score03 = oprScoreProfVO.getScore03();
            float score04 = oprScoreProfVO.getScore04();
            float score05 = oprScoreProfVO.getScore05();
            float score06 = oprScoreProfVO.getScore06();
            float score07 = oprScoreProfVO.getScore07();
            float score08 = oprScoreProfVO.getScore08();
            float score09 = oprScoreProfVO.getScore09();
            float score10 = oprScoreProfVO.getScore10();
            float score11 = oprScoreProfVO.getScore11();
            float score12 = oprScoreProfVO.getScore12();
            float score13 = oprScoreProfVO.getScore13();
            float totScore = score01 + score02 + score03 + score04 + score05
                    + score06 + score07 + score08 + score09 + score10
                    + score11 + score12 + score13;
            
            oprScoreProfVO.setTotScore(totScore);
            oprScoreProfVO.setRgtrId("system");
            oprScoreProfVO.setMdfrId("system");
        }
        
        int batchSize = 500;
        for (int i = 0; i < listOprScoreProf.size(); i += batchSize) {
            int endIndex = Math.min(i + batchSize, listOprScoreProf.size());
            List<OprScoreProfVO> sublist = listOprScoreProf.subList(i, endIndex);
            
            scoreDAO.updateOprScoreProf(sublist);
        }
    }
    
    /***************************************************** 
     * 수업운영 점수 산정 (조교)
     * @param request
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void assistCalcScore() throws Exception {
        Map<String, Object> map = new HashMap<>();
        
        // 테스트
        map.put("orgId", "ORG0000001");
        map.put("haksaYear", "2023");
        map.put("haksaTerm", "10");
        map.put("lessonScheduleOrder", "7");
        map.put("tchTypeList", new String[] {"ASSISTANT"});
        
        List<OprScoreAssistVO> listOprScoreAssist = scoreDAO.listOprScoreAssist(map);
    
        // SCORE03 - 강의Q&A 72시간 미답변 건당 감점  (-0.1/건)
        map.put("bbsCd", "QNA");
        List<Map<String, Object>> score03List = scoreDAO.listOperNoAnsAtclCount(map);
        Map<String, Float> score03Map = new HashMap<>();
        for(Map<String, Object> resultMap : score03List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score03Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        // SCORE04 - 1:1상담 72시간 미답변 건당 감점  (-0.1/건)
        map.put("bbsCd", "SECRET");
        List<Map<String, Object>> score04List = scoreDAO.listOperNoAnsAtclCount(map);
        Map<String, Float> score04Map = new HashMap<>();
        for(Map<String, Object> resultMap : score04List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score04Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        // SCORE05 - 강의자료실  (+0.1/건)
        map.put("bbsCd", "PDS");
        List<Map<String, Object>> score05List = scoreDAO.listOperAtclCount(map);
        Map<String, Float> score05Map = new HashMap<>();
        for(Map<String, Object> resultMap : score05List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score05Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        map.remove("bbsCd");
        
        // SCORE06 - 학습독려 메일발송 (+0.1/건)
        map.put("msgDivCd", "EMAIL");
        List<Map<String, Object>> score06List = scoreDAO.listOperMessageCount(map);
        Map<String, Float> score06Map = new HashMap<>();
        for(Map<String, Object> resultMap : score06List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score06Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        // SCORE07 - 학습독려 SMS발송 (+0.1/건)
        map.put("msgDivCd", "SMS");
        List<Map<String, Object>> score07List = scoreDAO.listOperMessageCount(map);
        Map<String, Float> score07Map = new HashMap<>();
        for(Map<String, Object> resultMap : score07List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score07Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        // SCORE08 - 학습독려 PUSH발송 (+0.1/건)
        map.put("msgDivCd", "PUSH");
        List<Map<String, Object>> score08List = scoreDAO.listOperMessageCount(map);
        Map<String, Float> score08Map = new HashMap<>();
        for(Map<String, Object> resultMap : score08List) {
            String key = resultMap.get("userId") + "_" + resultMap.get("lessonScheduleId");
                    
            score08Map.put(key, (float) resultMap.get("totalCnt"));
        }
        
        for(OprScoreAssistVO oprScoreAssistVO : listOprScoreAssist) {
            String key = oprScoreAssistVO.getUserId() + "_" +oprScoreAssistVO.getLessonScheduleId();
            
            // SCORE03 - 강의Q&A 72시간 미답변 건당 감점  (-0.1/건)
            if(score03Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score03Map.get(key);
                
                score = cnt * -0.1f;
                
                oprScoreAssistVO.setScore03(score);
            } else {
                oprScoreAssistVO.setScore03(0);
            }
            
            // SCORE04 - 1:1상담 72시간 미답변 건당 감점  (-0.1/건)
            if(score04Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score04Map.get(key);
                
                score = cnt * -0.1f;
                
                oprScoreAssistVO.setScore04(score);
            } else {
                oprScoreAssistVO.setScore04(0);
            }
            
            // SCORE05 - 강의자료실  (+0.1/건)
            if(score05Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score05Map.get(key);
                
                score = cnt * 0.1f;
                
                oprScoreAssistVO.setScore05(score);
            } else {
                oprScoreAssistVO.setScore05(0);
            }
            
            // SCORE06 - 학습독려 메일발송 (+0.1/건)
            if(score06Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score06Map.get(key);
                
                score = cnt * 0.1f;
                
                oprScoreAssistVO.setScore06(score);
            } else {
                oprScoreAssistVO.setScore06(0);
            }
            
            // SCORE07 - 학습독려 SMS발송 (+0.1/건)
            if(score07Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score07Map.get(key);
                
                score = cnt * 0.1f;
                
                oprScoreAssistVO.setScore07(score);
            } else {
                oprScoreAssistVO.setScore07(0);
            }
            
            // SCORE08 - 학습독려 PUSH발송 (+0.1/건)
            if(score08Map.containsKey(key)) {
                float score = 0;
                
                float cnt = score08Map.get(key);
                
                score = cnt * 0.1f;
                
                oprScoreAssistVO.setScore08(score);
            } else {
                oprScoreAssistVO.setScore08(0);
            }
            
            float score01 = oprScoreAssistVO.getScore01();
            float score02 = oprScoreAssistVO.getScore02();
            float score03 = oprScoreAssistVO.getScore03();
            float score04 = oprScoreAssistVO.getScore04();
            float score05 = oprScoreAssistVO.getScore05();
            float score06 = oprScoreAssistVO.getScore06();
            float score07 = oprScoreAssistVO.getScore07();
            float score08 = oprScoreAssistVO.getScore08();
       
            float totScore = score01 + score02 + score03 + score04 + score05
                    + score06 + score07 + score08;
            
            oprScoreAssistVO.setTotScore(totScore);
            oprScoreAssistVO.setRgtrId("system");
            oprScoreAssistVO.setMdfrId("system");
        }
        
        int batchSize = 500;
        for (int i = 0; i < listOprScoreAssist.size(); i += batchSize) {
            int endIndex = Math.min(i + batchSize, listOprScoreAssist.size());
            List<OprScoreAssistVO> sublist = listOprScoreAssist.subList(i, endIndex);
            
            scoreDAO.updateOprScoreAssist(sublist);
        }
    }
}
