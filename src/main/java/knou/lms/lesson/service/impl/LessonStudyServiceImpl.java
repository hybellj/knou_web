package knou.lms.lesson.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.crs.crecrs.dao.CrecrsDAO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.lesson.dao.LessonScheduleDAO;
import knou.lms.lesson.dao.LessonStudyDAO;
import knou.lms.lesson.service.LessonStudyService;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyDetailVO;
import knou.lms.lesson.vo.LessonStudyPageVO;
import knou.lms.lesson.vo.LessonStudyRecordVO;
import knou.lms.lesson.vo.LessonStudyStateVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.std.dao.StdDAO;
import knou.lms.std.vo.StdVO;

@Service("lessonStudyService")
public class LessonStudyServiceImpl extends ServiceBase implements LessonStudyService {
    
    private static final Logger LOGGER = LoggerFactory.getLogger(LessonStudyServiceImpl.class);
    
    @Resource(name="lessonStudyDAO")
    private LessonStudyDAO lessonStudyDAO;
    
    @Resource(name="lessonStudyService")
    private LessonStudyService lessonStudyService;
    
    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;
    
    @Resource(name="crecrsDAO")
    private CrecrsDAO crecrsDAO;
    
    @Resource(name="stdDAO")
    private StdDAO stdDAO;
    
    @Resource(name="sysFileService")
    private SysFileService sysFileService;
    
    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    /*****************************************************
     * 학습기록 목록 조회 (by 교시)
     * @param LessonStudyRecordVO
     * @return List<LessonStudyRecordVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyRecordVO> listLessonStudyRecordByTime(LessonStudyRecordVO vo) throws Exception {
        return lessonStudyDAO.listLessonStudyRecordByTime(vo);
    }

    /*****************************************************
     * 학습기록 조회
     * @param LessonStudyRecordVO
     * @return LessonStudyRecordVO
     * @throws Exception
     ******************************************************/
    public LessonStudyRecordVO selectLessonStudyRecord(LessonStudyRecordVO vo) throws Exception {
        return lessonStudyDAO.selectLessonStudyRecord(vo);
    }
    
    /*****************************************************
     * 학습상태 조회
     * @param LessonStudyStateVO
     * @return LessonStudyStateVO
     * @throws Exception
     ******************************************************/
    public LessonStudyStateVO selectLessonStudyState(LessonStudyStateVO vo) throws Exception {
        return lessonStudyDAO.selectLessonStudyState(vo);
    }
    
    /*****************************************************
     * 페이지 학습 기록 목록 조회 (by scheduleId)
     * @param LessonStudyPageVO
     * @return List<LessonStudyPageVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyPageVO> listLessonStudyPageBySchedule(LessonStudyPageVO vo) throws Exception {
        return lessonStudyDAO.listLessonStudyPageBySchedule(vo);
    }
    
    /*****************************************************
     * 학습상태 저장
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertLessonStudyState(LessonStudyStateVO vo) throws Exception {
        lessonStudyDAO.insertLessonStudyState(vo);
    }
    
    /*****************************************************
     * 학습기록 기본값 저장 저장
     * @param List<LessonStudyRecordVO>
     * @return void
     * @throws Exception
     ******************************************************/
    public void saveLessonStudyRecordBasic(List<LessonStudyRecordVO> list) throws Exception {
        lessonStudyDAO.insertLessonStudyRecordBasic(list);
    }
    
    
    /*****************************************************
     * 학습기록 저장
     * @param LessonStudyRecordVO
     * @return void
     * @throws Exception
     ******************************************************/
    public String saveLessonStudyRecord(LessonStudyRecordVO vo) throws Exception {
        String status = "";
        String today = new SimpleDateFormat("yyyyMMdd").format(new Date(System.currentTimeMillis()));
        
        // 학습인정 최대일을 지난경우 학습기록 하지않음
        String ltDetmToDtMax = vo.getLtDetmToDtMax();
        if (today.compareTo(ltDetmToDtMax) > 0) {
            return status;
        }
        
        // 학습상태 정보 조회
        boolean isCompleteLesson = false;
        String LessonEndDt = vo.getLessonEndDt();
        int lbnTm = vo.getLbnTm();
        String prgnYn = vo.getPrgrYn();
        int studySumTm = vo.getStudySumTm();
        int studyTotalTm = vo.getStudyTotalTm();
        int studyAfterTm = vo.getStudyAfterTm();
        int otherCntsStudyTotalTm = 0;
        int otherCntsStudyAfterTm = 0;
        
        LessonStudyStateVO stateVO = new LessonStudyStateVO();
        stateVO.setStdId(vo.getStdId());
        stateVO.setLessonScheduleId(vo.getLessonScheduleId());
        stateVO = lessonStudyDAO.selectLessonStudyState(stateVO);
        
        LessonScheduleVO scheduleVO = new LessonScheduleVO();
        scheduleVO.setLessonScheduleId(vo.getLessonScheduleId());
        scheduleVO.setLessonCntsId(vo.getLessonCntsId());
        scheduleVO = lessonStudyDAO.selectLessonSchedule(scheduleVO);
        
        int prgrVideoCnt = scheduleVO.getPrgrVideoCnt();
        
        // 출석인정 콘텐츠 여러개일경우
    	if(prgrVideoCnt > 1) {
    		// 이전 학습시간 계산
    		LessonScheduleVO otherCntsStudyTmVO = new LessonScheduleVO();
    		otherCntsStudyTmVO.setLessonScheduleId(vo.getLessonScheduleId());
    		otherCntsStudyTmVO.setLessonCntsId(vo.getLessonCntsId());
    		otherCntsStudyTmVO.setStdId(vo.getStdId());
    		otherCntsStudyTmVO = lessonStudyDAO.selectOtherCntsStudyTm(otherCntsStudyTmVO);
    	
    		if(otherCntsStudyTmVO != null) {
    			otherCntsStudyTotalTm = otherCntsStudyTmVO.getStudyTotalTm();
    			otherCntsStudyAfterTm = otherCntsStudyTmVO.getStudyAfterTm();
    		}
    	}
        
        // 주차 학습상태가 있는경우
        if(stateVO != null && !"".equals(StringUtil.nvl(stateVO.getStdId()))) {
            status = StringUtil.nvl(stateVO.getStudyStatusCd());
            
            // 완료 OR 지각 한경우 더이상 학습기록 하지않음
            if("COMPLETE".equals(status) || "LATE".equals(status)) {
                isCompleteLesson = true;
            }
        }
        
        if (scheduleVO != null) {
            LessonEndDt = StringUtil.nvl(scheduleVO.getLtDetmToDt(), scheduleVO.getLessonEndDt());
            lbnTm = scheduleVO.getLbnTm();
            ltDetmToDtMax = scheduleVO.getLtDetmToDtMax();
            prgnYn = scheduleVO.getPrgrYn();
            if (today.compareTo(ltDetmToDtMax) > 0) {
                return status;
            }
        }
        
        LessonStudyStateVO lessonStudyStateVO = new LessonStudyStateVO();
        lessonStudyStateVO.setStdId(vo.getStdId());
        lessonStudyStateVO.setLessonScheduleId(vo.getLessonScheduleId());
        lessonStudyStateVO.setCrsCreCd(vo.getCrsCreCd());
        lessonStudyStateVO.setUserId(vo.getUserId());
        lessonStudyStateVO.setStudyStatusCd(status);
        
        if (vo.getStudySessionTm() > 0) {
            int stdTm = studySumTm + studyAfterTm + vo.getStudySessionTm();
            int vidTm = (lbnTm * 60) / 2;
            
            if(prgrVideoCnt > 1) {
            	stdTm += otherCntsStudyTotalTm + otherCntsStudyAfterTm;
            }
            
            // 배속 적용할 경우 100로 계산위해 (예, 법정교육 과목)
            if ("true".equals(vo.getSpeedPlayTime())) {
                vidTm = (lbnTm * 60);
            }
            
            double ratio = (Double.valueOf(stdTm) / Double.valueOf(vidTm)) * 100.0;
            
            // 진도체크 Y인 경우만 학습상태, 총학습시간 계산
            if (!"N".equalsIgnoreCase(prgnYn)) {
                // 현재날짜가 학습기간인지 체크
                if (today.compareTo(LessonEndDt) <= 0) { // 기간내
                    studyTotalTm = studyTotalTm + vo.getStudySessionTm();
                    vo.setStudyTotalTm(studyTotalTm);
                    
                    if (!isCompleteLesson) {
                        if (ratio >= 99.0) {
                            status = "COMPLETE";
                        }
                        else {
                            status = "STUDY";
                        }
                        
                        // 학습상태 저장
                        lessonStudyStateVO.setStudyStatusCd(status);
                        lessonStudyDAO.saveLessonStudyState(lessonStudyStateVO);
                    }
                }
                else { // 기간외
                    studyAfterTm = studyAfterTm + vo.getStudySessionTm();
                    vo.setStudyAfterTm(studyAfterTm);
                    
                    if (!isCompleteLesson) {
                        if (ratio >= 99.0) {
                            status = "LATE";
                        }
                        else {
                            status = "STUDY";
                        }
                        
                        // 학습상태 저장
                        lessonStudyStateVO.setStudyStatusCd(status);
                        lessonStudyDAO.saveLessonStudyState(lessonStudyStateVO);
                    }
                }
            }
            
            if (vo.getCntsRatio() != 0) {
                vo.setPrgrRatio(vo.getCntsRatio());
            }
            
            System.out.println(DateTimeUtil.getCurrentDateText()+" SAVE STUDY RECORD ---> userId:"+vo.getUserId() + ", crsCd:"+vo.getCrsCreCd()
                + ", schId:"+vo.getLessonScheduleId()+", totalTime:"+studyTotalTm+", afterTime:"+studyAfterTm+", sessionTime:"+vo.getStudySessionTm()
                + ", status:"+status);
            
            // 학습기록 저장
            lessonStudyDAO.saveLessonStudyRecord(vo);
        }

        // 학습기록 상세 저장
        LessonStudyDetailVO lessonStudyDetailVO = new LessonStudyDetailVO();
        lessonStudyDetailVO.setStudyDetailId(IdGenerator.getNewId("LEDT"));
        lessonStudyDetailVO.setStdId(vo.getStdId());
        lessonStudyDetailVO.setLessonCntsId(vo.getLessonCntsId());
        lessonStudyDetailVO.setCrsCreCd(vo.getCrsCreCd());
        lessonStudyDetailVO.setUserId(vo.getUserId());
        lessonStudyDetailVO.setStudyTm(vo.getStudySessionTm());
        lessonStudyDetailVO.setStudyBrowserCd(vo.getBrowserCd());
        lessonStudyDetailVO.setStudyDeviceCd(vo.getDeviceCd());
        lessonStudyDetailVO.setRegIp(vo.getUserIp());
        //lessonStudyDetailVO.setStudyClientEnv(StringUtil.cropByte(vo.getAgent(),197));
        lessonStudyDetailVO.setStudyCnt(vo.getStudyCnt());
        lessonStudyDAO.insertLessonStudyDetail(lessonStudyDetailVO);
        
        // 학습페이지 정보 기록 저장
        if (!"".equals(StringUtil.nvl(vo.getPageCnt())) && !"-1".equals(vo.getPageCnt()) && vo.getStudySessionTm() > 0) {
            LessonStudyPageVO lessonStudyPageVO = new LessonStudyPageVO();
            lessonStudyPageVO.setLessonCntsId(vo.getLessonCntsId());
            lessonStudyPageVO.setStdId(vo.getStdId());
            lessonStudyPageVO.setPageCnt(Integer.parseInt(vo.getPageCnt()));
            lessonStudyPageVO.setCrsCreCd(vo.getCrsCreCd());
            lessonStudyPageVO.setStudyCnt(vo.getPageStudyCnt());
            lessonStudyPageVO.setStudySessionTm(vo.getPageStudyTm() + vo.getPageSessionTm());
            lessonStudyPageVO.setStudySessionLoc(vo.getStudySessionLoc());
            lessonStudyPageVO.setUserId(vo.getUserId());
            lessonStudyPageVO.setPrgrRatio(vo.getPageRatio());
            
            lessonStudyDAO.saveLessonStudyPage(lessonStudyPageVO);
        }

        return status;
    }
    
    /*****************************************************
     * 학습기록 삭제
     * @param LessonStudyRecordVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteLessonStudyRecord(LessonStudyRecordVO vo) throws Exception {
        String lessonCntsId = vo.getLessonCntsId();
        
        // 수강생 학습기록 상세 삭제
        LessonStudyDetailVO lessonStudyDetailVO = new LessonStudyDetailVO();
        lessonStudyDetailVO.setLessonCntsId(lessonCntsId);
        lessonStudyDAO.deleteLessonStudyDetail(lessonStudyDetailVO);
        
        // 수강생 페이지 학습기록 삭제
        LessonStudyPageVO lessonStudyPageVO = new LessonStudyPageVO();
        lessonStudyPageVO.setLessonCntsId(lessonCntsId);
        lessonStudyDAO.deleteLessonStudyPage(lessonStudyPageVO);
        
        // 수강생 학습기록 삭제
        LessonStudyRecordVO lessonStudyRecordVO = new LessonStudyRecordVO();
        lessonStudyRecordVO.setLessonCntsId(lessonCntsId);
        lessonStudyDAO.deleteLessonStudyRecord(lessonStudyRecordVO);
    }
    
    /*****************************************************
     *  페이지 학습기록 기본값 목록 저장
     * @param List<LessonStudyPageVO>
     * @return void
     * @throws Exception
     ******************************************************/
    public void saveLessonStudyPageBasicList(List<LessonStudyPageVO> list) throws Exception {
        lessonStudyDAO.saveLessonStudyPageBasicList(list);
    }
    
    /*****************************************************
     * 강제 출석 처리
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void saveForcedAttend(HttpServletRequest request, LessonStudyStateVO vo) throws Exception {
        String lessonScheduleId = vo.getLessonScheduleId();
        String stdNo = vo.getStdId();
        String crsCreCd = vo.getCrsCreCd();
        String rgtrId = vo.getRgtrId();
        String mdfrId = vo.getMdfrId();
        String attendReason = vo.getAttendReason();
        String studyStatusCdParam = vo.getStudyStatusCd();
        
        if(!("COMPLETE".equals(studyStatusCdParam) || "LATE".equals(studyStatusCdParam))) {
            throw processException("system.fail.data.process.msg"); // 데이터 처리 중 오류가 발생하였습니다.
        }
        
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO = lessonScheduleDAO.select(lessonScheduleVO);
        
        int lessonScheduleOrder = lessonScheduleVO.getLessonScheduleOrder();
        
        // 출석 상태 조회
        LessonStudyStateVO lessonStudyStateVO = new LessonStudyStateVO();
        lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
        lessonStudyStateVO.setStdId(stdNo);
        lessonStudyStateVO = lessonStudyDAO.selectLessonStudyState(lessonStudyStateVO);

        if(lessonStudyStateVO == null) {
            // 학습 기록이 없는경우
            if(ValidationUtils.isEmpty(lessonScheduleId) 
                    || ValidationUtils.isEmpty(stdNo) 
                    || ValidationUtils.isEmpty(crsCreCd) 
                    || ValidationUtils.isEmpty(rgtrId)) {
                throw processException("system.fail.data.process.msg"); // 데이터 처리 중 오류가 발생하였습니다.
            }
            
            lessonStudyStateVO = new LessonStudyStateVO();
            lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
            lessonStudyStateVO.setStdId(stdNo);
            lessonStudyStateVO.setCrsCreCd(crsCreCd);
            lessonStudyStateVO.setRgtrId(rgtrId);
            lessonStudyStateVO.setAttendReason(attendReason);
            lessonStudyStateVO.setStudyStatusCd(studyStatusCdParam);
            lessonStudyDAO.insertForcedAttend(lessonStudyStateVO);
            
            String logText = lessonScheduleOrder + "주차 출석처리[EMPTY > " + studyStatusCdParam + "]";
            logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_FORCE_ATTEND, logText);
        } else {
            // 학습 기록이 있는경우
            String studyStatusCd = StringUtil.nvl(lessonStudyStateVO.getStudyStatusCd()).toUpperCase();
            String studyStatusCdBak = lessonStudyStateVO.getStudyStatusCdBak();
            
            if("COMPLETE".equals(studyStatusCdParam)) {
                if(!"COMPLETE".equals(studyStatusCd) && ValidationUtils.isEmpty(studyStatusCdBak)) {
                    if(ValidationUtils.isEmpty(lessonScheduleId) || ValidationUtils.isEmpty(stdNo)) {
                        throw processException("system.fail.data.process.msg"); // 데이터 처리 중 오류가 발생하였습니다.
                    }
                    
                    lessonStudyStateVO = new LessonStudyStateVO();
                    lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
                    lessonStudyStateVO.setStdId(stdNo);
                    lessonStudyStateVO.setStudyStatusCdBak(studyStatusCd);
                    lessonStudyStateVO.setAttendReason(attendReason);
                    lessonStudyStateVO.setMdfrId(mdfrId);
                    lessonStudyStateVO.setStudyStatusCd(studyStatusCdParam);
                    lessonStudyDAO.updateForcedAttend(lessonStudyStateVO);
                    
                    String logText = lessonScheduleOrder + "주차 출석처리[" + studyStatusCd + " > " + studyStatusCdParam + "]";
                    logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_FORCE_ATTEND, logText);
                }
            } else if("LATE".equals(studyStatusCdParam)) {
                if((!"COMPLETE".equals(studyStatusCd) && !"LATE".equals(studyStatusCd)) && ValidationUtils.isEmpty(studyStatusCdBak)) {
                    if(ValidationUtils.isEmpty(lessonScheduleId) || ValidationUtils.isEmpty(stdNo)) {
                        throw processException("system.fail.data.process.msg"); // 데이터 처리 중 오류가 발생하였습니다.
                    }
                    
                    lessonStudyStateVO = new LessonStudyStateVO();
                    lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
                    lessonStudyStateVO.setStdId(stdNo);
                    lessonStudyStateVO.setStudyStatusCdBak(studyStatusCd);
                    lessonStudyStateVO.setAttendReason(attendReason);
                    lessonStudyStateVO.setMdfrId(mdfrId);
                    lessonStudyStateVO.setStudyStatusCd(studyStatusCdParam);
                    lessonStudyDAO.updateForcedAttend(lessonStudyStateVO);
                    
                    String logText = lessonScheduleOrder + "주차 출석처리[" + studyStatusCd + " > " + studyStatusCdParam + "]";
                    logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_FORCE_ATTEND, logText);
                }
            }
        }
        
        String uploadPath = vo.getUploadPath();
        String uploadFiles = vo.getUploadFiles();
        
        List<FileVO> uploadFileList = FileUtil.getUploadFileList(vo.getUploadFiles());
        List<FileVO> copyFileList = FileUtil.getUploadFileList(vo.getCopyFiles());
        
        try {
            String fileBindDataSn = lessonScheduleId + "_" + stdNo;
            
            if(uploadFileList.size() > 0 || copyFileList.size() > 0) {
                // 파일 업로드
                if(uploadFileList.size() > 0) {
                    FileVO fileVO = new FileVO();
                    fileVO.setUploadFiles(uploadFiles);
                    fileVO.setFilePath(uploadPath);
                    fileVO.setRepoCd("ATTEND");
                    fileVO.setRgtrId(vo.getRgtrId());
                    fileVO.setFileBindDataSn(fileBindDataSn);
                    try {
                        fileVO = sysFileService.addFile(fileVO);
                    } catch (Exception e) {
                        throw processException("common.file.upload.fail"); // 파일 업로드 정보 저장중 오류가 발생하였습니다.
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            
            if(uploadFileList.size() > 0) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
            
            throw e;
        }
    }
    
    /*****************************************************
     * 강제 출석 처리  (일괄)
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void saveForcedAttendBatch(HttpServletRequest request, LessonStudyStateVO vo) throws Exception {
        String lessonScheduleId = vo.getLessonScheduleId();
        String crsCreCd = vo.getCrsCreCd();
        String rgtrId = vo.getRgtrId();
        String mdfrId = vo.getMdfrId();
        String[] sqlForeach = vo.getSqlForeach();
        String attendReason = vo.getAttendReason();
        String studyStatusCd = vo.getStudyStatusCd();
        
        if(ValidationUtils.isEmpty(lessonScheduleId)
                || ValidationUtils.isEmpty(crsCreCd)
                || ValidationUtils.isEmpty(rgtrId)
                || ValidationUtils.isEmpty(mdfrId)
                || ValidationUtils.isEmpty(studyStatusCd)) {
            throw processException("system.fail.data.process.msg"); // 데이터 처리 중 오류가 발생하였습니다.
        }
        
        LessonStudyStateVO lessonStudyStateVO;
        
        for(String stdNo : sqlForeach) {
            lessonStudyStateVO = new LessonStudyStateVO();
            lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
            lessonStudyStateVO.setCrsCreCd(crsCreCd);
            lessonStudyStateVO.setRgtrId(rgtrId);
            lessonStudyStateVO.setMdfrId(mdfrId);
            lessonStudyStateVO.setStdId(stdNo);
            lessonStudyStateVO.setAttendReason(attendReason);
            lessonStudyStateVO.setStudyStatusCd(studyStatusCd);
            this.saveForcedAttend(request, lessonStudyStateVO);
        }
    }

    /*****************************************************
     * 강제 출석 처리 취소
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void cancelForcedAttend(HttpServletRequest request, LessonStudyStateVO vo) throws Exception {
        String lessonScheduleId = vo.getLessonScheduleId();
        String stdNo = vo.getStdId();
        String mdfrId = vo.getMdfrId();
        
        if(ValidationUtils.isEmpty(lessonScheduleId) || ValidationUtils.isEmpty(stdNo)) {
            throw processException("system.fail.data.process.msg"); // 데이터 처리 중 오류가 발생하였습니다.
        }
        
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(vo.getCrsCreCd());
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO = lessonScheduleDAO.select(lessonScheduleVO);
        
        int lessonScheduleOrder = lessonScheduleVO.getLessonScheduleOrder();
        
        // 출석 상태 조회
        LessonStudyStateVO lessonStudyStateVO = new LessonStudyStateVO();
        lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
        lessonStudyStateVO.setStdId(stdNo);
        lessonStudyStateVO = lessonStudyDAO.selectLessonStudyState(lessonStudyStateVO);
        
        // 학습 기록이 있는경우
        if(lessonStudyStateVO != null) {
            String studyStatusCd = StringUtil.nvl(lessonStudyStateVO.getStudyStatusCd()).toUpperCase();
            String studyStatusCdBak = lessonStudyStateVO.getStudyStatusCdBak();
            
            if(("COMPLETE".equals(studyStatusCd) || "LATE".equals(studyStatusCd)) && ValidationUtils.isNotEmpty(studyStatusCdBak)) {
                lessonStudyStateVO = new LessonStudyStateVO();
                lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
                lessonStudyStateVO.setStdId(stdNo);
                lessonStudyStateVO.setMdfrId(mdfrId);
                lessonStudyStateVO.setStudyStatusCd(studyStatusCdBak);
                
                lessonStudyDAO.cancelForcedAttend(lessonStudyStateVO);
                
                String logText = lessonScheduleOrder + "주차 출석취소[" + studyStatusCd + " > " + studyStatusCdBak + "]";
                logLessonActnHstyService.saveLessonActnHsty(request, vo.getCrsCreCd(), CommConst.ACTN_HSTY_FORCE_ATTEND, logText);
                
                String fileBindDataSn = vo.getLessonScheduleId() + "_" + vo.getStdId();
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("ATTEND");
                fileVO.setFileBindDataSn(fileBindDataSn);
                List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
                
                if(fileList.size() > 0) {
                    for(FileVO fileVO2 : fileList) {
                        sysFileService.removeFile(fileVO2.getFileSn());
                    }
                }
            }
        }
    }

    /*****************************************************
     * 강제 출석 처리 취소  (일괄)
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void cancelForcedAttendBath(HttpServletRequest request, LessonStudyStateVO vo) throws Exception {
        String lessonScheduleId = vo.getLessonScheduleId();
        String crsCreCd = vo.getCrsCreCd();
        String mdfrId = vo.getMdfrId();
        String[] sqlForeach = vo.getSqlForeach();
        
        if(ValidationUtils.isEmpty(lessonScheduleId)
                || ValidationUtils.isEmpty(crsCreCd)
                || ValidationUtils.isEmpty(mdfrId)) {
            throw processException("system.fail.data.process.msg"); // 데이터 처리 중 오류가 발생하였습니다.
        }
        
        LessonStudyStateVO lessonStudyStateVO;
        
        for(String stdNo : sqlForeach) {
            lessonStudyStateVO = new LessonStudyStateVO();
            lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
            lessonStudyStateVO.setCrsCreCd(crsCreCd);
            lessonStudyStateVO.setMdfrId(mdfrId);
            lessonStudyStateVO.setStdId(stdNo);
            this.cancelForcedAttend(request, lessonStudyStateVO);
        }
    }

    
    /*****************************************************
     * 수강생 강의 주차 학습상태 목록 조회(시간포함)
     * @param LessonStudyStateVO
     * @return List<LessonStudyStateVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyStateVO> listLessonStudyStateTm(LessonStudyStateVO vo) throws Exception {
        return lessonStudyDAO.listLessonStudyStateTm(vo);
    }
    
    /*****************************************************
     * 출석처리 사유 수정
     * @param LessonStudyStateVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateAttendReason(LessonStudyStateVO vo) throws Exception {
        lessonStudyDAO.updateAttendReason(vo);
        
        String uploadPath = vo.getUploadPath();
        String uploadFiles = vo.getUploadFiles();
        
        String fileBindDataSn = vo.getLessonScheduleId() + "_" + vo.getStdId();
        List<FileVO> uploadFileList = FileUtil.getUploadFileList(vo.getUploadFiles());
        
        if(uploadFileList.size() > 0) {
            try {
                // 파일 업로드
                if(uploadFileList.size() > 0) {
                    FileVO fileVO = new FileVO();
                    fileVO.setUploadFiles(uploadFiles);
                    fileVO.setFilePath(uploadPath);
                    fileVO.setRepoCd("ATTEND");
                    fileVO.setRgtrId(vo.getRgtrId());
                    fileVO.setFileBindDataSn(fileBindDataSn);
                    try {
                        fileVO = sysFileService.addFile(fileVO);
                    } catch (Exception e) {
                        throw processException("common.file.upload.fail"); // 파일 업로드 정보 저장중 오류가 발생하였습니다.
                    }
                }
            } catch (Exception e) {
                LOGGER.debug("e: ", e);
                
                if(uploadFileList.size() > 0) {
                    FileUtil.delUploadFileList(uploadFiles, uploadPath);
                }
            }
        }
        
        // 파일삭제
        String[] delFileIds = vo.getDelFileIds();
        if(delFileIds != null && delFileIds.length > 0) {
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("ATTEND");
            fileVO.setFileBindDataSn(fileBindDataSn);
            List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
            
            for(String delFileId : delFileIds) {
                for(FileVO fvo : fileList) {
                    if(delFileId.equals(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")))) {
                        sysFileService.removeFile(fvo.getFileSn());
                        break;
                    }
                }
            }
        }
    }

    /*****************************************************
     * 수강생별 학습기록 주차 목록 조회
     * @param LectureWeekNoSchedleVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listStdLessonRecord(LessonScheduleVO vo) throws Exception {
        return lessonStudyDAO.listStdLessonRecord(vo);
    }
    
    /*****************************************************
     * 법정교육 학습상태 변경
     * @param HttpServletRequest
     * @param List<LessonStudyStateVO>
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void saveLegalStudyStatus(HttpServletRequest request, List<LessonStudyStateVO> list) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String mdfrId = SessionInfo.getUserId(request);
        
        // 강의실 정보
        CreCrsVO creCrsVO = new CreCrsVO();
        Map<String, CreCrsVO> creCrsMap = new HashMap<>();
        
        // 수강생별 학습기록
        List<String> stdNoList = new ArrayList<>();
        StdVO stdVO = new StdVO();
        stdVO.setOrgId(orgId);
        
        for(LessonStudyStateVO lessonStudyStateVO : list) {
            String crsCreCd = lessonStudyStateVO.getCrsCreCd();
            String stdNo = lessonStudyStateVO.getStdId();
            
            if(!creCrsMap.containsKey(crsCreCd)) {
                creCrsVO = new CreCrsVO();
                creCrsVO.setCrsCreCd(crsCreCd);
                creCrsVO.setCrsTypeCd("LEGAL");
                creCrsVO = crecrsDAO.select(creCrsVO);
                
                creCrsVO = creCrsMap.put(crsCreCd, creCrsVO);
            }
            
            stdNoList.add(stdNo);
        }
        
        stdVO.setStdIdArr(stdNoList.toArray(new String[stdNoList.size()]));
        
        Map<String, StdVO> studentRecordMap = new HashMap<>();
        List<StdVO> listStudentRecord = stdDAO.listStudentRecord(stdVO);
        for(StdVO stdVO2 : listStudentRecord) {
            studentRecordMap.put(stdVO2.getStdId(), stdVO2);
        }
        
        // 학습상태변경
        List<LessonStudyStateVO> updateList = new ArrayList<>();
        for(LessonStudyStateVO lessonStudyStateVO : list) {
            String crsCreCd = lessonStudyStateVO.getCrsCreCd();
            String userId = lessonStudyStateVO.getUserId();
            String stdNo = lessonStudyStateVO.getStdId();
            String studyStatusCd = lessonStudyStateVO.getStudyStatusCd();
            
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(userId) || ValidationUtils.isEmpty(stdNo) || ValidationUtils.isEmpty(studyStatusCd)) {
                throw processException("system.title.do.not.access"); // 잘못된 접근입니다.
            }
            
            if(!("COMPLETE".equals(studyStatusCd) || "NOSTUDY".equals(studyStatusCd))) {
                throw processException("system.title.do.not.access"); // 잘못된 접근입니다.
            }
            
            // 법정교육 체크
            creCrsVO = creCrsMap.get(crsCreCd);
            
            if(creCrsVO == null) {
                throw processException("lesson.error.only.legal"); // 법정교육 수강생만 가능합니다.
            }
            
            String lessonScheduleId = creCrsVO.getLessonScheduleId();
            
            // 학습기록 체크
            stdVO = studentRecordMap.get(stdNo);
            
            if(stdVO != null) {
                String originStudyStatusCd = stdVO.getStudyStatusCd();
                
                if("COMPLETE".equals(studyStatusCd) && "COMPLETE".equals(originStudyStatusCd)) {
                    continue;
                } else if("NOSTUDY".equals(studyStatusCd) && ("NOSTUDY".equals(originStudyStatusCd) || "STUDY".equals(originStudyStatusCd))) {
                    continue;
                }
            }
            
            String attendReason;
            if("COMPLETE".equals(studyStatusCd)) {
                attendReason = "강제 이수 처리";
            } else {
                attendReason = "강제 미이수 처리";
            }
            
            lessonStudyStateVO = new LessonStudyStateVO();
            lessonStudyStateVO.setLessonScheduleId(lessonScheduleId);
            lessonStudyStateVO.setStdId(stdNo);
            lessonStudyStateVO.setCrsCreCd(crsCreCd);
            lessonStudyStateVO.setUserId(userId);
            lessonStudyStateVO.setStudyStatusCd(studyStatusCd);
            lessonStudyStateVO.setAttendReason(attendReason);
            lessonStudyStateVO.setMdfrId(mdfrId);
            updateList.add(lessonStudyStateVO);
        }
        
        if(updateList.size() > 0) {
            lessonStudyDAO.updateForcedAttendLegal(updateList);
        }
    }
}