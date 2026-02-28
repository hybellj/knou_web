package knou.lms.lesson.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.crs.crecrs.dao.CrecrsDAO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.lesson.dao.LessonScheduleDAO;
import knou.lms.lesson.dao.LessonStudyDAO;
import knou.lms.lesson.service.LessonScheduleService;
import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyDetailVO;
import knou.lms.lesson.vo.LessonStudyPageVO;
import knou.lms.lesson.vo.LessonStudyRecordVO;
import knou.lms.lesson.vo.LessonStudyStateVO;
import knou.lms.lesson.vo.LessonTimeVO;

@Service("lessonScheduleService")
public class LessonScheduleServiceImpl extends ServiceBase implements LessonScheduleService {
    
    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;
    
    @Resource(name="lessonStudyDAO")
    private LessonStudyDAO lessonStudyDAO;
    
    @Resource(name="crecrsDAO")
    private CrecrsDAO crecrsDAO;
    
    /*****************************************************
     * 강의실 학습주차 조회
     * @param LectureWeekNoSchedleVO
     * @return LessonScheduleVO
     * @throws Exception
     ******************************************************/
    @Override
    public LessonScheduleVO select(LessonScheduleVO vo) throws Exception {
        return lessonScheduleDAO.select(vo);
    }
    
    /*****************************************************
     * 강의실 학습주차 조회
     * @param LectureWeekNoSchedleVO
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LessonScheduleVO> list(LessonScheduleVO vo) throws Exception {
        return lessonScheduleDAO.list(vo);
    }
    
    /*****************************************************
     * 강의실 학습주차 등록
     * @param LectureWeekNoSchedleVO
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void insert(LessonScheduleVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        String wekClsfGbn = vo.getWekClsfGbn();
        Integer lessonScheduleOrder = vo.getLessonScheduleOrder();
        String lessonStartDt = vo.getLessonStartDt();
        String lessonEndDt = vo.getLessonEndDt();
        String rgtrId = vo.getRgtrId();
        
        if(ValidationUtils.isEmpty(crsCreCd)
            || ValidationUtils.isEmpty(wekClsfGbn)
            || ValidationUtils.isEmpty(lessonScheduleOrder)
            || ValidationUtils.isEmpty(lessonStartDt)
            || ValidationUtils.isEmpty(lessonEndDt)
            || ValidationUtils.isEmpty(rgtrId)) {
            throw processException("common.system.error"); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        // 강의실 정보 조회
        CreCrsVO crsCreVO = new CreCrsVO();
        crsCreVO.setCrsCreCd(crsCreCd);
        crsCreVO = crecrsDAO.select(crsCreVO);
        
        String erpLessonYn = crsCreVO.getErpLessonYn();
        
        if("Y".equals(erpLessonYn)) {
            throw processException("lesson.error.impossible.erp.lesson.y"); // ERP 주차 연동 미사용 강의실만 가능합니다.
        }
        
        // 주차 중복 체크
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        List<LessonScheduleVO> list = lessonScheduleDAO.list(lessonScheduleVO);
        
        boolean hasMidExam = false;
        boolean hasLastExam = false;
        
        for(LessonScheduleVO lessonScheduleVO2 : list) {
            if(lessonScheduleVO2.getLessonScheduleOrder() == lessonScheduleOrder) {
                throw processException("lesson.error.dup.lesson.schedule.order"); // 입력한 주차가 이미 존재합니다.
            }
            
            if("04".equals(lessonScheduleVO2.getWekClsfGbn())) {
                hasMidExam = true;
            }
            
            if("05".equals(lessonScheduleVO2.getWekClsfGbn())) {
                hasLastExam = true;
            }
        }
        
        if(hasMidExam && "04".equals(wekClsfGbn)) {
            throw processException("lesson.error.dup.lesson.schedule.exam.m"); // 중간고사 주차가 이미 존재합니다.
        }
        
        if(hasLastExam && "05".equals(wekClsfGbn)) {
            throw processException("lesson.error.dup.lesson.schedule.order"); // 기말고사 주차가 이미 존재합니다.
        }
        
        if("".equals(StringUtil.nvl(vo.getLtDetmFrDt()))) {
            vo.setLtDetmFrDt(null);
        }
        
        if("".equals(StringUtil.nvl(vo.getLtDetmToDt()))) {
            vo.setLtDetmToDt(null);
        }
        
        // 주차 ID 생성
        String lessonScheduleId = IdGenerator.getNewId("LS");
        
        vo.setLessonScheduleId(lessonScheduleId);
        vo.setLessonScheduleNm(lessonScheduleOrder + "주차");
        vo.setDelYn("N");
        lessonScheduleDAO.insert(vo);
    }
    
    /*****************************************************
     * 강의실 학습주차 수정
     * @param LectureWeekNoSchedleVO
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void update(LessonScheduleVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        String wekClsfGbn = vo.getWekClsfGbn();
        String mdfrId = vo.getMdfrId();
        
        if(ValidationUtils.isEmpty(crsCreCd)
            || ValidationUtils.isEmpty(lessonScheduleId)
            || ValidationUtils.isEmpty(mdfrId)) {
            throw processException("common.system.error"); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        // 강의실 정보 조회
        CreCrsVO crsCreVO = new CreCrsVO();
        crsCreVO.setCrsCreCd(crsCreCd);
        crsCreVO = crecrsDAO.select(crsCreVO);
        
        String erpLessonYn = crsCreVO.getErpLessonYn();
        
        if("Y".equals(erpLessonYn)) {
            throw processException("lesson.error.impossible.erp.lesson.y"); // ERP 주차 연동 미사용 강의실만 가능합니다.
        }
        
        // 주차 중복 체크
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        List<LessonScheduleVO> list = lessonScheduleDAO.list(lessonScheduleVO);
        
        boolean hasMidExam = false;
        boolean hasLastExam = false;
        
        for(LessonScheduleVO lessonScheduleVO2 : list) {
            if("04".equals(lessonScheduleVO2.getWekClsfGbn())) {
                hasMidExam = true;
            }
            
            if("05".equals(lessonScheduleVO2.getWekClsfGbn())) {
                hasLastExam = true;
            }
        }
        
        if(hasMidExam && "04".equals(wekClsfGbn)) {
            throw processException("lesson.error.dup.lesson.schedule.exam.m"); // 중간고사 주차가 이미 존재합니다.
        }
        
        if(hasLastExam && "05".equals(wekClsfGbn)) {
            throw processException("lesson.error.dup.lesson.schedule.order"); // 기말고사 주차가 이미 존재합니다.
        }
        
        if("04".equals(wekClsfGbn) || "05".equals(wekClsfGbn)) {
            int cntsCnt = lessonScheduleDAO.countLessonScheduleCnts(vo);
            
            if(cntsCnt > 0) {
                throw processException("lesson.error.exists.cnts.exam.week"); // 강의 컨텐츠가 등록되어있어 시험주차로 변경할 수 없습니다.
            }
        }
        
        lessonScheduleDAO.update(vo);
    }
    
    /*****************************************************
     * 강의실 학습주차 삭제
     * @param LectureWeekNoSchedleVO
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void delete(LessonScheduleVO vo) throws Exception {
        lessonScheduleDAO.updateDelN(vo);
    }

    /*****************************************************
     * 주차, 교시, 강의컨텐츠 조회
     * @param LectureWeekNoSchedleVO
     * @return LessonScheduleVO
     * @throws Exception
     ******************************************************/
    @Override
    public LessonScheduleVO selectLessonScheduleAll(LessonScheduleVO vo) throws Exception {
        return lessonScheduleDAO.selectLessonScheduleAll(vo);
    }
    
    /*****************************************************
     * 주차, 교시, 강의컨텐츠 목록 조회
     * @param LectureWeekNoSchedleVO
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LessonScheduleVO> listLessonScheduleAll(LessonScheduleVO vo) throws Exception {
    	vo.setLcdmsLinkYn(null);
        return lessonScheduleDAO.listLessonScheduleAll(vo);
    }

    /*****************************************************
     * 주차, 교시, 강의컨텐츠, (학습시간) 조회 (학생)
     * @param LectureWeekNoSchedleVO
     * @return LessonScheduleVO
     * @throws Exception
     ******************************************************/
    @Override
    public LessonScheduleVO selectLessonScheduleAllStd(LessonScheduleVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        String stdNo = vo.getStdId();
        String lessonScheduleId = vo.getLessonScheduleId();
        
        LessonScheduleVO lessonScheduleVO = lessonScheduleDAO.selectLessonScheduleAll(vo);
        
        // 주차 학생 학습상태 설정
        LessonStudyStateVO lessonStudyStateVO = new LessonStudyStateVO();
        lessonStudyStateVO.setCrsCreCd(crsCreCd);
        lessonStudyStateVO.setStdId(stdNo);
        lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
        LessonStudyStateVO lessonStdyStateVO = lessonStudyDAO.selectLessonStudyStateTm(lessonStudyStateVO);
        if(lessonStdyStateVO == null) lessonStudyDAO.selectLessonStudySeminar(lessonStudyStateVO);
        
        if(lessonStdyStateVO != null) {
            String endDtYn = lessonScheduleVO.getEndDtYn();
            int studyTotalTm = lessonStdyStateVO.getStudyTotalTm();
            int studyAfterTm = lessonStdyStateVO.getStudyAfterTm();
            String studyStatusCd = lessonStdyStateVO.getStudyStatusCd();
            String studyStatusCdBak = lessonStdyStateVO.getStudyStatusCdBak();
            
            lessonScheduleVO.setStudyTotalTm(studyTotalTm);
            lessonScheduleVO.setStudyAfterTm(studyAfterTm);
            
            if("Y".equals(StringUtil.nvl(endDtYn)) && "STUDY".equals(studyStatusCd)) {
                lessonScheduleVO.setStudyStatusCd("NOSTUDY");
            } else {
                lessonScheduleVO.setStudyStatusCd(studyStatusCd);
            }
            
            lessonScheduleVO.setStudyStatusCdBak(studyStatusCdBak);
        } else {
            lessonScheduleVO.setStudyTotalTm(0);
            lessonScheduleVO.setStudyAfterTm(0);
            lessonScheduleVO.setStudyStatusCd("NOSTUDY");
            lessonScheduleVO.setStudyStatusCdBak(null);
        }
        
        // 학습기록 조회
        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setCrsCreCd(crsCreCd);
        lessonCntsVO.setStdId(stdNo);
        lessonCntsVO.setLessonScheduleId(lessonScheduleId);
        List<LessonStudyRecordVO> listLessonStudyRecord = lessonStudyDAO.listLessonStudyRecord(lessonCntsVO);
        Map<String, LessonStudyRecordVO> studyRecordMap = new HashMap<>();
        
        if(listLessonStudyRecord != null && listLessonStudyRecord.size() > 0) {
            
            // 1.학습기록 상세 조회
            lessonCntsVO = new LessonCntsVO();
            lessonCntsVO.setCrsCreCd(crsCreCd);
            lessonCntsVO.setStdId(stdNo);
            lessonCntsVO.setLessonScheduleId(lessonScheduleId);
            List<LessonStudyDetailVO> listLessonStudyDetail = lessonStudyDAO.listLessonStudyDetail(lessonCntsVO);
            Map<String, List<LessonStudyDetailVO>> studyDetailMap = new HashMap<>();
            
            for(LessonStudyDetailVO lessonStudyDetailVO : listLessonStudyDetail) {
                String lessonCntsId = lessonStudyDetailVO.getLessonCntsId();
                
                if(!studyDetailMap.containsKey(lessonCntsId)) {
                    studyDetailMap.put(lessonCntsId, new ArrayList<>());
                }
                
                studyDetailMap.get(lessonCntsId).add(lessonStudyDetailVO);
            }
            
            // 2.페이지별 학습기록 조회
            lessonCntsVO = new LessonCntsVO();
            lessonCntsVO.setCrsCreCd(crsCreCd);
            lessonCntsVO.setStdId(stdNo);
            lessonCntsVO.setLessonScheduleId(lessonScheduleId);
            List<LessonStudyPageVO> listLessonStudyPage = lessonStudyDAO.listLessonStudyPage(lessonCntsVO);
            Map<String, List<LessonStudyPageVO>> studyPageMap = new HashMap<>();
            
            for(LessonStudyPageVO lessonStudyPageVO : listLessonStudyPage) {
                String lessonCntsId = lessonStudyPageVO.getLessonCntsId();
                
                if(!studyPageMap.containsKey(lessonCntsId)) {
                    studyPageMap.put(lessonCntsId, new ArrayList<>());
                }
                
                studyPageMap.get(lessonCntsId).add(lessonStudyPageVO);
            }
            
            // 3.학습기록 세팅
            for(LessonStudyRecordVO lessonStudyRecordVO : listLessonStudyRecord) {
                String lessonCntsId = lessonStudyRecordVO.getLessonCntsId();
                
                // 학습기록 상세 세팅
                if(studyDetailMap.containsKey(lessonCntsId)) {
                    lessonStudyRecordVO.setListLessonStudyDetail(studyDetailMap.get(lessonCntsId));
                }
                
                // 페이지별 학습기록 세팅
                if(studyPageMap.containsKey(lessonCntsId)) {
                    lessonStudyRecordVO.setListLessonStudyPage(studyPageMap.get(lessonCntsId));
                }
                
                studyRecordMap.put(lessonCntsId, lessonStudyRecordVO);
            }
        }
        
        List<LessonTimeVO> listLessonTime = lessonScheduleVO.getListLessonTime();
        if(listLessonTime != null) {
            for(LessonTimeVO lessonTimeVO : listLessonTime) {
                List<LessonCntsVO> listLessonCnts = lessonTimeVO.getListLessonCnts();
                
                for(LessonCntsVO lessonCntsVO2 : listLessonCnts) {
                    String lessonCntsId = lessonCntsVO2.getLessonCntsId();
                    
                    // 컨텐츠별 학습기록 세팅
                    if(studyRecordMap.containsKey(lessonCntsId)) {
                        lessonCntsVO2.setLessonStudyRecordVO(studyRecordMap.get(lessonCntsId));
                    }
                }
            }
        }
        
        return lessonScheduleVO;
    }

    /*****************************************************
     * 강의구분별 주차 목록 조회
     * @param LectureWeekNoSchedleVO
     * @return List<LessonScheduleVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LessonScheduleVO> listLessonScheduleByGbn(LessonScheduleVO vo) throws Exception {
        return lessonScheduleDAO.listLessonScheduleByGbn(vo);
    }
}