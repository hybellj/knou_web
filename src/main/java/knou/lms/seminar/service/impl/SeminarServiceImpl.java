package knou.lms.seminar.service.impl;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.dao.CrecrsDAO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.lesson.service.LessonTimeService;
import knou.lms.lesson.vo.LessonTimeVO;
import knou.lms.score.dao.ScoreConfDAO;
import knou.lms.score.vo.ScoreConfVO;
import knou.lms.seminar.api.meetings.vo.MeetingVO;
import knou.lms.seminar.api.reports.vo.ParticipantVO;
import knou.lms.seminar.api.reports.vo.ParticipantsVO;
import knou.lms.seminar.dao.SeminarAtndDAO;
import knou.lms.seminar.dao.SeminarDAO;
import knou.lms.seminar.dao.SeminarHstyDAO;
import knou.lms.seminar.dao.SeminarRegDAO;
import knou.lms.seminar.service.SeminarAtndService;
import knou.lms.seminar.service.SeminarService;
import knou.lms.seminar.service.ZoomApiService;
import knou.lms.seminar.vo.SeminarAtndVO;
import knou.lms.seminar.vo.SeminarHstyVO;
import knou.lms.seminar.vo.SeminarRegVO;
import knou.lms.seminar.vo.SeminarVO;
import knou.lms.std.dao.StdDAO;
import knou.lms.std.vo.StdVO;
import knou.lms.user.dao.UsrUserInfoDAO;
import knou.lms.user.vo.UsrUserInfoVO;

@Service("seminarService")
public class SeminarServiceImpl extends ServiceBase implements SeminarService {
    
    @Resource(name="seminarDAO")
    private SeminarDAO seminarDAO;
    
    @Resource(name="seminarRegDAO")
    private SeminarRegDAO seminarRegDAO;
    
    @Resource(name="seminarHstyDAO")
    private SeminarHstyDAO seminarHstyDAO;
    
    @Resource(name="seminarAtndDAO")
    private SeminarAtndDAO seminarAtndDAO;
    
    @Resource(name="stdDAO")
    private StdDAO stdDAO;
    
    @Resource(name="usrUserInfoDAO")
    private UsrUserInfoDAO usrUserInfoDAO;
    
    @Resource(name="crecrsDAO")
    private CrecrsDAO crecrsDAO;
    
    @Resource(name="scoreConfDAO")
    private ScoreConfDAO scoreConfDAO;
    
    @Resource(name="sysFileService")
    private SysFileService sysFileService;
    
    @Autowired
    private ZoomApiService zoomApiService;
    
    @Autowired
    private LessonTimeService lessonTimeService;
    
    @Autowired
    private SeminarAtndService seminarAtndService;
    
    /*****************************************************
     * <p>
     * TODO 세미나 정보 조회
     * </p>
     * 세미나 정보 조회
     * 
     * @param SeminarVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    @Override
    public SeminarVO select(SeminarVO vo) throws Exception {
        vo = seminarDAO.select(vo);
        if(vo != null) {
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("SEMINAR");
            fileVO.setFileBindDataSn(vo.getSeminarId());
            vo.setFileList(sysFileService.list(fileVO).getReturnList());
        }
        return vo;
    }

    /*****************************************************
     * <p>
     * TODO 세미나 목록 조회
     * </p>
     * 세미나 목록 조회
     * 
     * @param SeminarVO
     * @return List<SeminarVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<SeminarVO> list(SeminarVO vo) throws Exception {
        return seminarDAO.list(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 목록 조회 페이징
     * </p>
     * 세미나 목록 조회 페이징
     * 
     * @param SeminarVO
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<SeminarVO> listPaging(SeminarVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<SeminarVO> seminarList = seminarDAO.listPaging(vo);

        if(seminarList.size() > 0) {
            paginationInfo.setTotalRecordCount(seminarList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<SeminarVO> resultVO = new ProcessResultVO<SeminarVO>();

        resultVO.setReturnList(seminarList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 세미나 등록
     * </p>
     * 세미나 등록
     * 
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insertSeminar(SeminarVO vo) throws Exception {
        // 새로운 교시 생성
        addLessonTime(vo);
        int idx = 1;
        String lessonScheduleId = StringUtil.nvl(vo.getLessonScheduleId());
        String lessonTimeId     = StringUtil.nvl(vo.getLessonTimeId());
        for(String crsCreCd : vo.getCrsCreCds()) {
            vo.setLessonScheduleId(crsCreCd.equals(vo.getCrsCreCd()) ? lessonScheduleId : "");
            vo.setLessonTimeId(crsCreCd.equals(vo.getCrsCreCd()) ? lessonTimeId : "");
            String seminarId = IdGenerator.getNewId("SMR");
            vo.setSeminarId(seminarId);
            vo.setCrsCreCd(crsCreCd);
            seminarDAO.insert(vo);
            
            // 파일저장
            this.insertFileInfo(vo, vo.getSeminarId(), StringUtil.nvl(vo.getSearchTo()), idx == vo.getCrsCreCds().size() ? "Y" : "N");
            idx++;
        }
    }

    /*****************************************************
     * <p>
     * TODO 세미나 수정
     * </p>
     * 세미나 수정
     * 
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateSeminar(SeminarVO vo) throws Exception {
        // 새로운 교시 생성
        addLessonTime(vo);
        // 세미나 정보 조회
        SeminarVO beforeSeminarVO = seminarDAO.select(vo);
        // 수정 전 세미나 구분
        if("online".equals(StringUtil.nvl(beforeSeminarVO.getSeminarCtgrCd())) || "free".equals(StringUtil.nvl(beforeSeminarVO.getSeminarCtgrCd()))) {
            if("online".equals(StringUtil.nvl(vo.getSeminarCtgrCd())) || "free".equals(StringUtil.nvl(vo.getSeminarCtgrCd()))) {
                // ZOOM 미팅 수정 API 호출
                vo = zoomApiService.updateMeeting(vo);
            // 오프라인은 zoom이 없으므로 삭제
            } else {
                List<SeminarVO> seminarList = seminarDAO.listSeminarByZoom(vo);
                if(seminarList.size() == 1) {
                    // ZOOM 미팅 삭제 API 호출
                    vo = zoomApiService.deleteMeeting(vo);
                } else {
                    vo.setZoomId("");
                    vo.setZoomPw("");
                    vo.setHostUrl("");
                    vo.setJoinUrl("");
                }
                // 줌 사전 등록 참가자 DB 정보 삭제
                SeminarRegVO seminarRegVO = new SeminarRegVO();
                seminarRegVO.setZoomId(vo.getZoomId());
                seminarRegVO.setSeminarId(vo.getSeminarId());
                seminarRegDAO.delete(seminarRegVO);
            }
        }
        vo.setAttProcYn("N");
        // 분반 같이 수정
        if("online".equals(StringUtil.nvl(beforeSeminarVO.getSeminarCtgrCd())) && "online".equals(StringUtil.nvl(vo.getSeminarCtgrCd()))) {
            int idx = 1;
            List<SeminarVO> seminarList = seminarDAO.listSeminarByZoom(vo);
            for(SeminarVO svo : seminarList) {
                vo.setSeminarId(svo.getSeminarId());
                seminarDAO.update(vo);
                
                // 파일저장
                this.insertFileInfo(vo, vo.getSeminarId(), StringUtil.nvl(vo.getSearchTo()), idx == seminarList.size() ? "Y" : "N");
                idx++;
            }
        } else {
            seminarDAO.update(vo);
            
            // 파일저장
            this.insertFileInfo(vo, vo.getSeminarId(), StringUtil.nvl(vo.getSearchTo()), "Y");
        }
    }
    
    // 교시 생성
    public void addLessonTime(SeminarVO vo) throws Exception {
        if("ADD".equals(StringUtil.nvl(vo.getLessonTimeId()))) {
            LessonTimeVO timeVO = new LessonTimeVO();
            timeVO.setCrsCreCd(vo.getCrsCreCd());
            timeVO.setLessonScheduleId(vo.getLessonScheduleId());
            timeVO.setLessonTimeOrder(vo.getLessonTimeOrder());
            timeVO.setStdyMethod("RND");
            timeVO.setLessonTimeNm("화상세미나");
            timeVO.setRgtrId(vo.getRgtrId());
            timeVO.setMdfrId(vo.getMdfrId());
            lessonTimeService.insert(timeVO);
            vo.setLessonTimeId(StringUtil.nvl(timeVO.getLessonTimeId()));
        }
    }

    /*****************************************************
     * <p>
     * TODO 세미나 삭제
     * </p>
     * 세미나 삭제
     * 
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteSeminar(SeminarVO vo) throws Exception {
        SeminarVO seminarVO = seminarDAO.select(vo);
        if("online".equals(StringUtil.nvl(seminarVO.getSeminarCtgrCd()))) {
            List<SeminarVO> seminarList = seminarDAO.listSeminarByZoom(seminarVO);
            if(seminarList.size() == 1 && !"".equals(StringUtil.nvl(seminarVO.getZoomId()))) {
                // 줌 회의 삭제
                vo.setZoomId(seminarVO.getZoomId());
                vo = zoomApiService.deleteMeeting(vo);
            }
            if(!"".equals(StringUtil.nvl(seminarVO.getZoomId()))) {
                // 줌 사전 등록 참가자 DB 정보 삭제
                SeminarRegVO seminarRegVO = new SeminarRegVO();
                seminarRegVO.setZoomId(seminarVO.getZoomId());
                seminarRegVO.setSeminarId(seminarVO.getSeminarId());
                seminarRegDAO.delete(seminarRegVO);
            }
        }
        seminarDAO.delete(vo);
    }
    
    // 파일 등록
    public FileVO insertFileInfo(SeminarVO vo, String nSn, String oSn, String delYn) throws Exception {
        FileVO fVo = new FileVO();
        fVo.setOrgId(vo.getOrgId());
        fVo.setUserId(vo.getUserId());
        fVo.setRepoCd("SEMINAR");
        fVo.setFilePath(vo.getUploadPath());

        fVo.setFileBindDataSn(nSn);
        fVo.setCopyFileBindDataSn(oSn);
        fVo.setUploadFiles(vo.getUploadFiles());
        fVo.setCopyFiles(vo.getCopyFiles());
        fVo.setDelFileIds(vo.getDelFileIds());

        fVo.setAudioData(vo.getAudioData());
        fVo.setAudioFile(vo.getAudioFile());

        fVo.setOrginDelYn(delYn);
        sysFileService.insertFileInfo(fVo);

        return fVo;
    }

    /*****************************************************
     * <p>
     * TODO 세미나 ZOOM 호스트 URL 조회
     * </p>
     * 세미나 ZOOM 호스트 URL 조회
     * 
     * @param SeminarAtndVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    @Override
    public SeminarVO getHostUrl(SeminarAtndVO vo) throws Exception {
        // 세미나 정보 조회
        SeminarVO seminarVO = new SeminarVO();
        seminarVO.setSeminarId(vo.getSeminarId());
        seminarVO = seminarDAO.select(seminarVO);
        seminarVO.setUserId(vo.getUserId());
        
        // ZOOM 회의 정보 조회 API 호출
        MeetingVO meetingVO = zoomApiService.selectMeeting(seminarVO.getZoomId());
        seminarVO.setHostUrl(StringUtil.nvl(meetingVO.getStartUrl()));
        
        // 참여 로그 등록
        SeminarAtndVO atndVO = seminarAtndDAO.select(vo);
        if(atndVO == null) {
            String seminarAtndId = IdGenerator.getNewId("SMRA");
            vo.setSeminarAtndId(seminarAtndId);
            if(StringUtil.nvl(vo.getAuthrtGrpcd()).contains("USR")) {
                StdVO stdVO = new StdVO();
                stdVO.setUserId(vo.getUserId());
                stdVO.setCrsCreCd(vo.getCrsCreCd());
                stdVO = stdDAO.selectStd(stdVO);
                vo.setStdNo(stdVO.getStdId());
            } else {
                vo.setStdNo("PROF");
            }
            seminarAtndDAO.update(vo);
        } else {
            vo.setStdNo(atndVO.getStdNo());
        }
        
        SeminarHstyVO seminarHstyVO = new SeminarHstyVO();
        String seminarHstyId = IdGenerator.getNewId("SMRH");
        seminarHstyVO.setSeminarHstyId(seminarHstyId);
        seminarHstyVO.setStdNo(vo.getStdNo());
        seminarHstyVO.setSeminarId(vo.getSeminarId());
        seminarHstyVO.setUserId(vo.getUserId());
        seminarHstyVO.setRegIp(vo.getRegIp());
        seminarHstyVO.setDeviceTypeCd(vo.getDeviceTypeCd());
        seminarHstyVO.setRgtrId(vo.getRgtrId());
        seminarHstyDAO.insert(seminarHstyVO);
        
        return seminarVO;
    }

    /*****************************************************
     * <p>
     * TODO 세미나 ZOOM 학습자 URL 조회
     * </p>
     * 세미나 ZOOM 학습자 URL 조회
     * 
     * @param SeminarAtndVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    @Override
    public SeminarVO getJoinUrl(SeminarAtndVO vo) throws Exception {
        // 세미나 정보 조회
        SeminarVO seminarVO = new SeminarVO();
        seminarVO.setSeminarId(StringUtil.nvl(vo.getSeminarId()));
        seminarVO.setCrsCreCd(StringUtil.nvl(vo.getCrsCreCd()));
        seminarVO = seminarDAO.select(seminarVO);
        // 사전 등록용 정보 설정
        SeminarVO addVO = new SeminarVO();
        addVO.setZoomId(seminarVO.getZoomId());
        addVO.setUserId(vo.getUserId());
        addVO.setAuthrtGrpcd(vo.getAuthrtGrpcd());
        addVO.setSeminarId(vo.getSeminarId());
        addVO.setCrsCreCd(vo.getCrsCreCd());
        addVO.setTcEmail(StringUtil.nvl(vo.getUserId())+"@hycu.ac.kr");
        addVO.setStdNo(StringUtil.nvl(vo.getStdNo()));
        // DB에 저장된 ZOOM 사전 등록 정보 조회
        SeminarRegVO seminarRegVO = new SeminarRegVO();
        seminarRegVO.setZoomId(seminarVO.getZoomId());
        seminarRegVO.setSeminarId(vo.getSeminarId());
        seminarRegVO.setUserId(vo.getUserId());
        seminarRegVO = seminarRegDAO.select(seminarRegVO);
        // 사전 등록 했으면 url 리턴
        if(seminarRegVO != null) {
            seminarVO.setJoinUrl(seminarRegVO.getJoinUrl());
        // 사전 등록 안되있으면 사전 등록 호출
        } else {
            // 해당 과목 교수 정보 조회 ( 사전 등록은 교수 토큰으로 가능 )
            CreCrsVO crecrsVO = new CreCrsVO();
            crecrsVO.setCrsCreCd(vo.getCrsCreCd());
            crecrsVO = crecrsDAO.selectTchCreCrs(crecrsVO);
            addVO.setSearchKey(vo.getUserId());
            addVO.setUserId(crecrsVO.getUserId());
            // ZOOM 미팅 사전 참여자 등록 API 호출
            zoomApiService.addMeetingRegistrant(addVO);
            seminarRegVO = new SeminarRegVO();
            seminarRegVO.setZoomId(seminarVO.getZoomId());
            seminarRegVO.setSeminarId(vo.getSeminarId());
            seminarRegVO.setUserId(vo.getUserId());
            seminarRegVO = seminarRegDAO.select(seminarRegVO);
            seminarVO.setJoinUrl(seminarRegVO.getJoinUrl());
        }
        
        // 참여 로그 등록
        SeminarAtndVO atndVO = seminarAtndDAO.select(vo);
        // 세미나 참여일시 체크
        LocalDateTime startDt = LocalDateTime.parse(seminarVO.getSeminarStartDttm(), DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        LocalDateTime now = LocalDateTime.now();
        String atndDttm = "";
        
        if(atndVO == null) {
            atndDttm = now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
            if(now.isAfter(startDt)) {
                atndDttm = seminarVO.getSeminarStartDttm();
            }
            String seminarAtndId = IdGenerator.getNewId("SMRA");
            vo.setSeminarAtndId(seminarAtndId);
            
            if(StringUtil.nvl(vo.getAuthrtGrpcd()).contains("USR")) {
                StdVO stdVO = new StdVO();
                stdVO.setUserId(vo.getUserId());
                stdVO.setCrsCreCd(vo.getCrsCreCd());
                stdVO = stdDAO.selectStd(stdVO);
                vo.setStdNo(stdVO.getStdId());
            } else {
                vo.setStdNo("PROF");
            }
            vo.setAtndDttm(atndDttm);
            seminarAtndDAO.update(vo);
        } else {
            vo.setStdNo(atndVO.getStdNo());
        }
        
        SeminarHstyVO seminarHstyVO = new SeminarHstyVO();
        String seminarHstyId = IdGenerator.getNewId("SMRH");
        seminarHstyVO.setSeminarHstyId(seminarHstyId);
        seminarHstyVO.setStdNo(vo.getStdNo());
        seminarHstyVO.setSeminarId(vo.getSeminarId());
        seminarHstyVO.setUserId(vo.getUserId());
        seminarHstyVO.setRegIp(vo.getRegIp());
        seminarHstyVO.setDeviceTypeCd(vo.getDeviceTypeCd());
        seminarHstyVO.setAtndDttm(atndDttm);
        seminarHstyVO.setRgtrId(vo.getRgtrId());
        seminarHstyDAO.insert(seminarHstyVO);
        
        return seminarVO;
    }

    /*****************************************************
     * <p>
     * TODO 세미나 ZOOM 출결 처리
     * </p>
     * 세미나 ZOOM 출결 처리
     * 
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void seminarAttendSet(SeminarVO vo) throws Exception {
        SeminarVO seminarVO = seminarDAO.select(vo);
        ParticipantsVO psVO = new ParticipantsVO();
        try {
            psVO = zoomApiService.getMeetingParticipantReports(vo);
        } catch(Exception e) {
            System.out.println("출석 인원 없음");
        }
        
        int tchStudyTime = 0;
        if(psVO.getTotalRecords() > 0) {
            SeminarAtndVO resetVO = new SeminarAtndVO();
            resetVO.setSeminarId(vo.getSeminarId());
            seminarAtndDAO.atndTimeReset(resetVO);
            
            // 출결 처리용 시작 시간
            LocalDateTime attendStartDt = LocalDateTime.parse(seminarVO.getSeminarStartDttm(), DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
            // 출결 처리용 종료 시간
            LocalDateTime attendEndDt = LocalDateTime.parse(seminarVO.getSeminarEndDttm(), DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
            
            // 담당교수 정보 조회
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsVO = crecrsDAO.selectTchCreCrs(creCrsVO);
            LocalDateTime startDt = LocalDateTime.now();
            LocalDateTime endDt   = LocalDateTime.now();
            String temp = "";
            int duration = 0;
            
            // 담당교수 실제 참여 시간 체크 (세미나 시작시간 이후 종료시간 이전)
            for(ParticipantVO pvo : psVO.getParticipants()) {
                String userId = pvo.getUserEmail().split("@")[0];
                String email  = pvo.getUserEmail();
                if(userId.equalsIgnoreCase(StringUtil.nvl(creCrsVO.getUserId())) || email.equalsIgnoreCase(StringUtil.nvl(creCrsVO.getUserId())+"@hycu.ac.kr")) {
                    // 처음만 저장
                    if("".equals(temp)) {
                        // 실제 시작 시간
                        startDt = LocalDateTime.from(Instant.from(DateTimeFormatter.ISO_DATE_TIME.parse(pvo.getJoinTime())).atZone(ZoneId.of("Asia/Seoul")));
                    }
                    // 실제 종료 시간
                    endDt = LocalDateTime.from(Instant.from(DateTimeFormatter.ISO_DATE_TIME.parse(pvo.getLeaveTime())).atZone(ZoneId.of("Asia/Seoul")));
                    duration += Integer.valueOf(pvo.getDuration());
                    temp = "1";
                }
            }
            
            /*
             * 세미나 출결처리용 시간 기준 설정
             * 
             * 세미나 시작시간보다 ZOOM 접속이 빠르며 세미나 종료시간보다 ZOOM 종료가 빠른 경우 : 세미나 시작시간 ~ ZOOM 종료 시간
             * 세미나 시작시간보다 ZOOM 접속이 빠르며 세미나 종료시간보다 ZOOM 종료가 느린 경우 : 세미나 시작시간 ~ 세미나 종료 시간
             * 세미나 시작시간보다 ZOOM 접속이 느리며 세미나 종료시간보다 ZOOM 종료가 빠른 경우 : ZOOM 접속시간 ~ ZOOM 종료 시간
             * 세미나 시작시간보다 ZOOM 접속이 느리며 세미나 종료시간보다 ZOOM 종료가 느린 경우 : ZOOM 접속시간 ~ 최대 세미나 진행시간 이내 (세미나 진행시간이 1시간일 경우 접속 ~ 종료는 1시간 까지만 적용)
             */
            // 세미나 시작시간보다 ZOOM 접속 시간이 빠르며 세미나 종료시간보다 ZOOM 종료가 빠른 경우
            if(attendStartDt.isAfter(startDt) && attendEndDt.isAfter(endDt)) {
                attendEndDt   = endDt;
            // 세미나 시작시간보다 ZOOM 접속이 느리며 세미나 종료시간보다 ZOOM 종료가 빠른 경우
            } else if(startDt.isAfter(attendStartDt) && attendEndDt.isAfter(endDt)) {
                attendStartDt = startDt;
                attendEndDt   = endDt;
            // 세미나 시작시간보다 ZOOM 접속이 느리며 세미나 종료시간보다 ZOOM 종료가 느린 경우
            } else if(startDt.isAfter(attendStartDt) && endDt.isAfter(attendEndDt)) {
                attendStartDt = startDt;
                int st = Integer.valueOf(seminarVO.getSeminarTime()) * 60;
                int zt = (int) ChronoUnit.SECONDS.between(attendStartDt, endDt);
                
                // 세미나 진행시간보다 ZOOM 진행 시간이 긴 경우 짜르기
                if(st < zt) {
                    attendEndDt = attendStartDt.plusMinutes(Long.valueOf(seminarVO.getSeminarTime()));
                } else {
                    attendEndDt = attendStartDt;
                    attendEndDt = attendEndDt.plusMinutes(duration / 60);
                    attendEndDt = attendEndDt.plusSeconds(duration % 60);
                }
            }
            
            // 교수 총 참여 시간
            tchStudyTime += (int) ChronoUnit.SECONDS.between(attendStartDt, attendEndDt);
            
            // 교수 시간 저장
            SeminarAtndVO profAtndVO = new SeminarAtndVO();
            profAtndVO.setSeminarId(vo.getSeminarId());
            profAtndVO.setUserId(StringUtil.nvl(creCrsVO.getUserId()));
            profAtndVO = seminarAtndDAO.select(profAtndVO);
            if(profAtndVO != null) {
                profAtndVO.setMdfrId(vo.getMdfrId());
                profAtndVO.setAtndCd("ATTEND");
                profAtndVO.setAtndTime(tchStudyTime);
                seminarAtndDAO.update(profAtndVO);
            }
            
            for(ParticipantVO pvo : psVO.getParticipants()) {
                startDt = LocalDateTime.from(Instant.from(DateTimeFormatter.ISO_DATE_TIME.parse(pvo.getJoinTime())).atZone(ZoneId.of("Asia/Seoul")));
                endDt   = LocalDateTime.from(Instant.from(DateTimeFormatter.ISO_DATE_TIME.parse(pvo.getLeaveTime())).atZone(ZoneId.of("Asia/Seoul")));
                // 출결 처리용 시작 시간보다 ZOOM 종료 시간이 늦으며 ZOOM 시작 시간이 출결 처리용 종료 시간보다 빠를경우
                if(endDt.isAfter(attendStartDt) && attendEndDt.isAfter(startDt)) {
                    SeminarAtndVO atndVO = new SeminarAtndVO();
                    atndVO.setSeminarId(vo.getSeminarId());
                    atndVO.setUserId(StringUtil.nvl(pvo.getUserEmail()).split("@")[0]);
                    atndVO = seminarAtndDAO.select(atndVO);
                    
                    UsrUserInfoVO uuivo = new UsrUserInfoVO();
                    if(atndVO == null) {
                        uuivo.setTcId(StringUtil.nvl(pvo.getId()));
                        uuivo = usrUserInfoDAO.selectByTcId(uuivo);
                        if(uuivo != null) {
                            atndVO = new SeminarAtndVO();
                            atndVO.setSeminarId(vo.getSeminarId());
                            atndVO.setUserId(uuivo.getUserId());
                            atndVO = seminarAtndDAO.select(atndVO);
                        }
                    }
                    
                    // 과목 학생인지 조회
                    StdVO stdVO = new StdVO();
                    stdVO.setCrsCreCd(vo.getCrsCreCd());
                    stdVO.setUserId(StringUtil.nvl(pvo.getUserEmail()).split("@")[0]);
                    stdVO = stdDAO.selectStd(stdVO);
                    
                    // 사전 등록 되있으면서 해당 과목 학생이거나 호스트의 아이디와 같은 경우 처리
                    if(atndVO != null && (stdVO != null || uuivo != null) && !creCrsVO.getUserId().equals(atndVO.getUserId())) {
                        atndVO.setMdfrId(vo.getMdfrId());
                        // 세미나 결석 비율 조회
                        ScoreConfVO attendVO = new ScoreConfVO();
                        attendVO = scoreConfDAO.selectSeminarAbsentRatio(attendVO);
                        
                        // 출석 인정 시간
                        int attendTime = Integer.valueOf(seminarVO.getSeminarTime()) * 60 * Integer.valueOf(attendVO.getSeminarAbsentRatioVal()) / 100;
                        // 실제 진행 시간과 정해진 시간이 다른 경우 실 진행 시간으로 변경
                        if(tchStudyTime != Integer.valueOf(seminarVO.getSeminarTime()) * 60) {
                            attendTime = tchStudyTime * Integer.valueOf(attendVO.getSeminarAbsentRatioVal()) / 100;
                        }
                        
                        // 학습 시간
                        int studyTime  = atndVO.getAtndTime();
                        
                        // 출결인정 시작 시간보다 ZOOM 접속 시간이 빠르며 출결인정 종료 시간보다 ZOOM 종료가 빠른 경우
                        if(attendStartDt.isAfter(startDt) && attendEndDt.isAfter(endDt)) {
                            startDt = attendStartDt;
                        // 출결인정 시작 시간보다 ZOOM 접속 시간이 빠르며 울결인정 종료 시간보다 ZOOM 종료가 느린 경우
                        } else if(attendStartDt.isAfter(startDt) && endDt.isAfter(attendEndDt)) {
                            startDt = attendStartDt;
                            endDt   = attendEndDt;
                        // 출결인정 시작 시간보다 ZOOM 접속이 느리며 출결인정 종료 시간보다 ZOOM 종료가 느린 경우
                        } else if(startDt.isAfter(attendStartDt) && endDt.isAfter(attendEndDt)) {
                            endDt   = attendEndDt;
                        }
                        
                        studyTime += (int) ChronoUnit.SECONDS.between(startDt, endDt);
                        
                        atndVO.setAtndTime(studyTime);
                        // 출석 인정 시간보다 적으면 결석 처리
                        if(studyTime < attendTime) {
                            atndVO.setAtndCd("ABSENT");
                        } else {
                            // 지각 입장 시
                            if(startDt.isAfter(attendStartDt)) {
                                // 시작 시간 ~ 참석 시간 차이
                                int lateTime = (int) ChronoUnit.SECONDS.between(attendStartDt, startDt);
                                // 세미나 참여 인정 시간 조회
                                ScoreConfVO timeVO = new ScoreConfVO();
                                timeVO = scoreConfDAO.selectSeminarTm(timeVO);
                                
                                // 시작 후 출석 인정 시간 이내 입장 시
                                if(lateTime < (Integer.valueOf(timeVO.getSeminarAtndTmVal())*60)) {
                                    atndVO.setAtndCd("ATTEND");
                                // 시작 후 출석 인정 시간 이후 입장 시
                                } else {
                                    atndVO.setAtndCd("LATE");
                                }
                                // 시작 시간 이전 입장 시
                            } else {
                                atndVO.setAtndCd("ATTEND");
                            }
                        }
                        // 참여 수정
                        seminarAtndDAO.update(atndVO);
                    }
                }
            }
        }
        
        StdVO stdVO = new StdVO();
        stdVO.setCrsCreCd(vo.getCrsCreCd());
        List<StdVO> stdList = stdDAO.list(stdVO);
        for(StdVO svo : stdList) {
            SeminarAtndVO avo = new SeminarAtndVO();
            avo.setSeminarId(vo.getSeminarId());
            avo.setUserId(svo.getUserId());
            avo = seminarAtndDAO.select(avo);
            if(avo == null) {
                avo = new SeminarAtndVO();
                avo.setSeminarAtndId(IdGenerator.getNewId("SMRA"));
                avo.setSeminarId(vo.getSeminarId());
                avo.setStdNo(svo.getStdId());
                avo.setUserId(svo.getUserId());
                avo.setAtndDttm("-");
                avo.setAtndTime(0);
                avo.setAtndCd("ABSENT");
                avo.setRgtrId(vo.getUserId());
                seminarAtndDAO.update(avo);
                // 주차 출결 수정
                seminarAtndService.updateLessonStudyStatus(avo);
            } else {
                ScoreConfVO attendVO = new ScoreConfVO();
                attendVO = scoreConfDAO.selectSeminarAbsentRatio(attendVO);
                // 출석 인정 시간
                int attendTime = Integer.valueOf(seminarVO.getSeminarTime()) * 60 * Integer.valueOf(attendVO.getSeminarAbsentRatioVal()) / 100;
                if(tchStudyTime != Integer.valueOf(seminarVO.getSeminarTime()) * 60) {
                    attendTime = tchStudyTime * Integer.valueOf(attendVO.getSeminarAbsentRatioVal()) / 100;
                }
                if(avo.getAtndTime() > attendTime) {
                    avo.setAtndCd("ATTEND");
                } else {
                    avo.setAtndCd("ABSENT");
                }
                seminarAtndDAO.update(avo);
                // 주차 출결 수정
                seminarAtndService.updateLessonStudyStatus(avo);
            }
        }
        
        // 세미나 출결 여부 수정
        seminarDAO.updateSeminarAttProc(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 ZOOM 출결 목록
     * </p>
     * 세미나 ZOOM 출결 목록
     * 
     * @param SeminarVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> seminarAttendList(SeminarVO vo) throws Exception {
        List<EgovMap> eMapList = new ArrayList<EgovMap>();
        ParticipantsVO psVO = new ParticipantsVO();
        try {
            psVO = zoomApiService.getMeetingParticipantReports(vo);
        } catch(Exception e) {
            System.out.println("출석 인원 없음");
        }
        if(psVO.getTotalRecords() > 0) {
            for(ParticipantVO pvo : psVO.getParticipants()) {
                LocalDateTime startDt = LocalDateTime.from(Instant.from(DateTimeFormatter.ISO_DATE_TIME.parse(pvo.getJoinTime())).atZone(ZoneId.of("Asia/Seoul")));
                LocalDateTime endDt = LocalDateTime.from(Instant.from(DateTimeFormatter.ISO_DATE_TIME.parse(pvo.getLeaveTime())).atZone(ZoneId.of("Asia/Seoul")));
                String startDttm = startDt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                String endDttm   = endDt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                int min = Integer.parseInt(pvo.getDuration()) / 60;
                String time = min > 0 ? min + "분 " + (Integer.parseInt(pvo.getDuration()) - (min * 60)) + "초" : pvo.getDuration() + "초";
                String typeNm = "";
                if("in_meeting".equals(StringUtil.nvl(pvo.getStatus()))) typeNm = "ZOOM 입장";
                if("in_waiting_room".equals(StringUtil.nvl(pvo.getStatus()))) typeNm = "ZOOM 대기실 입장";
                EgovMap eMap = new EgovMap();
                eMap.put("email", StringUtil.nvl(pvo.getUserEmail()));
                eMap.put("name", StringUtil.nvl(pvo.getName()));
                eMap.put("startDt", startDttm);
                eMap.put("endDt", endDttm);
                eMap.put("time", time);
                eMap.put("typeNm", typeNm);
                eMapList.add(eMap);
            }
        }
        
        return eMapList;
    }

    /*****************************************************
     * <p>
     * TODO 특정 주차 세미나 개설 여부
     * </p>
     * 특정 주차 세미나 개설 여부
     * 
     * @param SeminarVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    @Override
    public Integer countBySchedule(SeminarVO vo) throws Exception {
        return seminarDAO.countBySchedule(vo);
    }
    
}
