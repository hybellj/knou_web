package knou.lms.seminar.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.exception.ServiceProcessException;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.lesson.dao.LessonScheduleDAO;
import knou.lms.lesson.dao.LessonStudyDAO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyStateVO;
import knou.lms.seminar.dao.SeminarAtndDAO;
import knou.lms.seminar.dao.SeminarDAO;
import knou.lms.seminar.dao.SeminarLogDAO;
import knou.lms.seminar.service.SeminarAtndService;
import knou.lms.seminar.vo.SeminarAtndVO;
import knou.lms.seminar.vo.SeminarLogVO;
import knou.lms.seminar.vo.SeminarVO;

@Service("seminarAtndService")
public class SeminarAtndServiceImpl extends ServiceBase implements SeminarAtndService {
    
    @Resource(name="seminarAtndDAO")
    private SeminarAtndDAO seminarAtndDAO;
    
    @Resource(name="seminarLogDAO")
    private SeminarLogDAO seminarLogDAO;
    
    @Resource(name="seminarDAO")
    private SeminarDAO seminarDAO;
    
    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;
    
    @Resource(name="lessonStudyDAO")
    private LessonStudyDAO lessonStudyDAO;
    
    @Resource(name="sysFileService")
    private SysFileService sysFileService;
    
    /*****************************************************
     * <p>
     * TODO 세미나 참석 수강생 리스트 조회
     * </p>
     * 세미나 참석 수강생 리스트 조회
     *
     * @param SeminarAtndVO
     * @return List<SeminarAtndVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<SeminarAtndVO> listStd(SeminarAtndVO vo) throws Exception {
        return seminarAtndDAO.listStd(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 참석 수강생 정보 조회
     * </p>
     * 세미나 참석 수강생 정보 조회
     *
     * @param SeminarAtndVO
     * @return SeminarAtndVO
     * @throws Exception
     ******************************************************/
    @Override
    public SeminarAtndVO selectStd(SeminarAtndVO vo) throws Exception {
        return seminarAtndDAO.selectStd(vo);
    }
    
    /*****************************************************
     * <p>
     * TODO 세미나 수강생 출결 관리 등록, 수정
     * </p>
     * 세미나 수강생 출결 관리 등록, 수정
     *
     * @param SeminarAtndVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void update(SeminarAtndVO vo) throws Exception {
        String seminarId = vo.getSeminarId();
        SeminarVO seminarVO = new SeminarVO();
        seminarVO.setSeminarId(seminarId);
        seminarVO = seminarDAO.select(seminarVO);
        
        String seminarStatus = seminarVO.getSeminarStatus();
        
        if(!"완료".equals(seminarStatus)) {
            // 세미나가 종료되지 않았습니다.
            throw processException("seminar.alert.seminar.not.over");
        }
        
        for(String stdList : vo.getAttendStdList()) {
            vo.setUserId(stdList.split("\\|")[0]);
            vo.setStdNo(stdList.split("\\|")[1]);
            vo.setAtndCd(stdList.split("\\|")[2]);
            if(stdList.split("\\|").length == 3) {
                vo.setSeminarAtndId(IdGenerator.getNewId("SMRA"));
                vo.setAtndDttm("-");
                vo.setAtndTime(0);
            } else {
                vo.setSeminarAtndId(stdList.split("\\|")[3]);
                SeminarAtndVO atndVO = seminarAtndDAO.select(vo);
                vo.setAtndTime(atndVO.getAtndTime());
            }
            /*
            if("ATTEND".equals(StringUtil.nvl(vo.getAtndCd())) && ValidationUtils.isEmpty(vo.getAtndMemo())) {
                // 출석인정 사유를 입력하세요.
                throw processException("seminar.message.empty.attent.reason");
            }
            */
            seminarAtndDAO.update(vo);
            
            SeminarAtndVO atndVO = seminarAtndDAO.select(vo);
            // 출결 변경 로그 등록
            SeminarLogVO logVO = new SeminarLogVO();
            logVO.setSeminarLogId(IdGenerator.getNewId("SMRL"));
            logVO.setSeminarId(atndVO.getSeminarId());
            logVO.setStdNo(atndVO.getStdNo());
            logVO.setStartDttm(atndVO.getAtndDttm() == null ? "-" : atndVO.getAtndDttm());
            String endDttm = "-";
            if(!"-".equals(logVO.getStartDttm())) {
                LocalDateTime endDt = LocalDateTime.parse(logVO.getStartDttm(), DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
                endDt = endDt.plusSeconds(atndVO.getAtndTime());
                endDttm = endDt.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
            }
            logVO.setEndDttm(endDttm);
            logVO.setDeviceTypeCd(atndVO.getDeviceTypeCd());
            logVO.setAtndTime(atndVO.getAtndTime());
            logVO.setAtndCd(atndVO.getAtndCd());
            logVO.setUserId(atndVO.getUserId());
            logVO.setRegIp(atndVO.getRegIp());
            logVO.setRgtrId(vo.getRgtrId());
            seminarLogDAO.insert(logVO);
            
            // 주차 출결 수정
            updateLessonStudyStatus(atndVO);
        }
    }

    /*****************************************************
     * <p>
     * TODO 세미나 메모 수정
     * </p>
     * 세미나 메모 수정
     *
     * @param SeminarAtndVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateMemo(SeminarAtndVO vo) throws Exception {
        for(String stdList : vo.getAttendStdList()) {
            vo.setUserId(stdList.split("\\|")[0]);
            vo.setStdNo(stdList.split("\\|")[1]);
            if(stdList.split("\\|").length == 2) {
                vo.setSeminarAtndId(IdGenerator.getNewId("SMRA"));
            } else {
                vo.setSeminarAtndId(stdList.split("\\|")[2]);
            }
            seminarAtndDAO.updateMemo(vo);
        }
    }
    
    /*****************************************************
     * 세미나 메모 단건 수정
     * @param SeminarAtndVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateMemoOne(SeminarAtndVO vo) throws Exception {
        this.updateMemo(vo);
        
        String uploadPath = vo.getUploadPath();
        String uploadFiles = vo.getUploadFiles();
        String copyFiles = vo.getCopyFiles();
        
        List<FileVO> uploadFileList = FileUtil.getUploadFileList(vo.getUploadFiles());
        List<FileVO> copyFileList = FileUtil.getUploadFileList(vo.getCopyFiles());
        
        if(uploadFileList.size() > 0 || copyFileList.size() > 0) {
            // 파일 업로드
            if(uploadFileList.size() > 0) {
                FileVO fileVO = new FileVO();
                fileVO.setUploadFiles(uploadFiles);
                fileVO.setFilePath(uploadPath);
                fileVO.setRepoCd("SEMINAR");
                fileVO.setRgtrId(vo.getRgtrId());
                fileVO.setFileBindDataSn(vo.getSeminarAtndId());
                try {
                    fileVO = sysFileService.addFile(fileVO);
                } catch (Exception e) {
                    throw new ServiceProcessException("파일 업로드 정보 저장중 오류가 발생하였습니다.");
                }
            }
            
            // 파일함 복사
            if(copyFileList.size() > 0) {
                FileVO fileVO = new FileVO();
                fileVO.setCopyFiles(copyFiles);
                fileVO.setFilePath(uploadPath);
                fileVO.setRepoCd("SEMINAR");
                fileVO.setRgtrId(vo.getRgtrId());
                fileVO.setFileBindDataSn(vo.getSeminarAtndId());
                try {
                    fileVO = sysFileService.addFile(fileVO);
                } catch (Exception e) {
                    throw new ServiceProcessException("파일복사중 오류가 발생하였습니다.");
                }
            }
        }
        
        // 파일삭제
        String[] delFileIds = vo.getDelFileIds();
        if(delFileIds != null && delFileIds.length > 0) {
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("SEMINAR");
            fileVO.setFileBindDataSn(vo.getSeminarAtndId());
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
     * <p>
     * TODO 주차 출결 수정
     * </p>
     * 주차 출결 수정
     *
     * @param SeminarAtndVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateLessonStudyStatus(SeminarAtndVO vo) throws Exception {
        SeminarVO seminarVO = new SeminarVO();
        seminarVO.setSeminarId(vo.getSeminarId());
        seminarVO = seminarDAO.select(seminarVO);
        LessonScheduleVO lsvo = new LessonScheduleVO();
        lsvo.setCrsCreCd(seminarVO.getCrsCreCd());
        lsvo.setLessonScheduleId(seminarVO.getLessonScheduleId());
        lsvo = lessonScheduleDAO.select(lsvo);
        if(lsvo != null) {
            // 세미나 주차일 시
            if("02".equals(lsvo.getWekClsfGbn()) || "03".equals(lsvo.getWekClsfGbn())) {
                boolean isInsert = false;
                
                LessonStudyStateVO lssvo = new LessonStudyStateVO();
                lssvo.setLessonScheduleId(seminarVO.getLessonScheduleId());
                lssvo.setStdId(vo.getStdNo());
                lssvo = lessonStudyDAO.selectLessonStudyState(lssvo);
                if(lssvo == null) {
                    lssvo = new LessonStudyStateVO();
                    lssvo.setRgtrId(vo.getRgtrId());
                    lssvo.setUserId(vo.getUserId());
                    lssvo.setCrsCreCd(seminarVO.getCrsCreCd());
                    
                    isInsert = true;
                }
                String studyStatusCd = "NOSTUDY";
                if("ATTEND".equals(vo.getAtndCd())) studyStatusCd = "COMPLETE";
                if("LATE".equals(vo.getAtndCd())) studyStatusCd = "LATE";
                lssvo.setLessonScheduleId(seminarVO.getLessonScheduleId());
                lssvo.setStudyStatusCd(studyStatusCd);
                lssvo.setStdId(vo.getStdNo());
                lssvo.setMdfrId(vo.getMdfrId());
                
                if(isInsert) {
                    lessonStudyDAO.insertLessonStudyState(lssvo);
                } else {
                    lessonStudyDAO.saveLessonStudyState(lssvo);
                }
            }
        }
    }

}
