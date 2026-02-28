package knou.lms.exam.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.CommonUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.dao.CrecrsDAO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.erp.daoErp.ErpDAO;
import knou.lms.erp.service.ErpService;
import knou.lms.erp.vo.ErpMessageMsgVO;
import knou.lms.exam.dao.ExamAbsentDAO;
import knou.lms.exam.dao.ExamDAO;
import knou.lms.exam.service.ExamAbsentService;
import knou.lms.exam.vo.ExamAbsentVO;
import knou.lms.exam.vo.ExamVO;
import knou.lms.sys.service.SysJobSchService;
import knou.lms.sys.vo.SysJobSchVO;

@Service("examAbsentService")
public class ExamAbsentServiceImpl extends ServiceBase implements ExamAbsentService {
    
    @Resource(name="examAbsentDAO")
    private ExamAbsentDAO examAbsentDAO;
    
    @Autowired
    private SysFileService sysFileService;
    
    @Resource(name="sysJobSchService")
    private SysJobSchService sysJobSchService;
    
    @Resource(name="termService")
    private TermService termService;
    
    @Resource(name="examDAO")
    private ExamDAO examDAO;
    
    @Resource(name="erpService")
    private ErpService erpService;
    
    @Resource(name="crecrsDAO")
    private CrecrsDAO crecrsDAO;
    
    /*****************************************************
     * <p>
     * TODO 결시원 리스트 조회
     * </p>
     * 결시원 리스트 조회
     * 
     * @param ExamAbsentVO
     * @return List<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamAbsentVO> list(ExamAbsentVO vo) throws Exception {
        return examAbsentDAO.list(vo);
    }
    
    /*****************************************************
     * <p>
     * TODO 결시원 리스트 조회 페이징
     * </p>
     * 결시원 리스트 조회 페이징
     * 
     * @param ExamAbsentVO
     * @return ProcessResultVO<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamAbsentVO> listPaging(ExamAbsentVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<ExamAbsentVO> examList = examAbsentDAO.listPaging(vo);
        
        if(examList.size() > 0) {
            paginationInfo.setTotalRecordCount(examList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<ExamAbsentVO> resultVO = new ProcessResultVO<ExamAbsentVO>();
        
        resultVO.setReturnList(examList);
        resultVO.setPageInfo(paginationInfo);
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 결시원 정보 조회
     * </p>
     * 결시원 정보 조회
     * 
     * @param ExamAbsentVO
     * @return ExamAbsentVO
     * @throws Exception
     ******************************************************/
    @Override
    public ExamAbsentVO select(ExamAbsentVO vo) throws Exception {
        vo = examAbsentDAO.select(vo);
        if(vo != null) {
            List<FileVO> fileList = new ArrayList<FileVO>();
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("EXAM_SAMPLE");
            fileVO.setFileBindDataSn(vo.getExamAbsentCd());
            fileList = sysFileService.list(fileVO).getReturnList();
            vo.setFileList(fileList);
        }
        return vo;
    }

    /*****************************************************
     * <p>
     * TODO 내 강의에 등록된 결시원 리스트 조회
     * </p>
     * 내 강의에 등록된 결시원 리스트 조회
     * 
     * @param ExamAbsentVO
     * @return ProcessResultVO<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamAbsentVO> listMyCreCrsExamAbsent(ExamAbsentVO vo) throws Exception {
        List<ExamAbsentVO> examList = examAbsentDAO.listMyCreCrsExamAbsent(vo);
        ProcessResultVO<ExamAbsentVO> resultVO = new ProcessResultVO<ExamAbsentVO>();
        resultVO.setReturnList(examList);
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 결시원 신청
     * </p>
     * 결시원 신청
     * 
     * @param ExamAbsentVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> examAbsentApplicate(HttpServletRequest request, ExamAbsentVO vo) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();
        String stdNo = vo.getStdId();
        
        if(ValidationUtils.isEmpty(stdNo)) {
            throw processException("exam.error.not.exists.std"); // 학생정보를 찾을 수 없습니다.
        }
        
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsDAO.select(creCrsVO);
        
        if(creCrsVO == null) {
            throw processException("exam.error.not.exists.crs"); // 과목정보를 찾을 수 없습니다.
        }
        
        // 학기 코드 조회
        TermVO termVO = new TermVO();
        termVO.setCrsCreCd(crsCreCd);
        termVO = termService.selectTermByCrsCreCd(termVO);
        
        String termCd = termVO.getTermCd();
        
        ExamVO examVO = new ExamVO();
        examVO.setExamCd(vo.getExamCd());
        examVO = examDAO.select(examVO);
        
        if(examVO == null) {
            throw processException("exam.error.not.exists.exam"); // 시험정보를 찾을 수 없습니다.
        }
        
        // 결시원 승인기간 체크
        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setOrgId(orgId);
        sysJobSchVO.setUseYn("Y");
        sysJobSchVO.setTermCd(termCd);
        sysJobSchVO.setCalendarCtgr("00190901");
        sysJobSchVO = sysJobSchService.select(sysJobSchVO);
        
        if(sysJobSchVO == null || !"Y".equals(StringUtil.nvl(sysJobSchVO.getSysjobSchdlPeriodYn()))) {
            throw processException("exam.alert.absent.applicate.not.datetime"); // 결시원 신청은 신청기간 안에만 가능합니다.
        }
        
        // 재신청 여부 체크
        ExamAbsentVO absentVO = new ExamAbsentVO();
        absentVO.setExamCd(examVO.getExamCd());
        absentVO.setCrsCreCd(crsCreCd);
        absentVO.setStdId(stdNo);
        absentVO = examAbsentDAO.select(absentVO);
        String examAbsentCd = IdGenerator.getNewId("ABS");
        vo.setExamAbsentCd(examAbsentCd);
        if(absentVO != null) {
            String apprStat = absentVO.getApprStat();
            
            if(!"COMPANION".equals(apprStat)) {
                throw processException("exam.alert.already.absent"); // 이미 결시원을 신청하셨습니다.
            }
            
            vo.setApprStat("RAPPLICATE");
        } else {
            vo.setApprStat("APPLICATE");
        }
        examAbsentDAO.insertAbsent(vo);
        this.addFile(vo);
        
        try {
            String examStr = "M".equals(StringUtil.nvl(examVO.getExamStareTypeCd())) ? "중간고사" : "기말고사";
            
            // 대표교수 정보 조회
            creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsVO = crecrsDAO.selectTchCreCrs(creCrsVO);
            
            if(creCrsVO != null) {
                String repUserId = creCrsVO.getUserId(); // 대표교수 번호
                String repUserNm = creCrsVO.getUserNm(); // 대표교수명
                
                // 교수에게 쪽지발송 처리
                String msgCtnt = "<b>["+examStr+"] 결시원 신청합니다.</b>";
                
                ErpMessageMsgVO erpMessageMsgVO = new ErpMessageMsgVO();
                erpMessageMsgVO.setUserId(repUserId);
                erpMessageMsgVO.setUserNm(repUserNm);
                erpMessageMsgVO.setCtnt(msgCtnt);
                erpMessageMsgVO.setCrsCreCd(crsCreCd);
                
                // 쪽지발송 저장 // 쪽지발송 기능 주석처리
                // erpService.insertSysMessageMsg(request, erpMessageMsgVO, "결시원 신청 쪽지 발송");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 결시원 수정
     * </p>
     * 결시원 수정
     * 
     * @param ExamAbsentVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateAbsent(HttpServletRequest request, ExamAbsentVO vo) throws Exception {
        try {
            examAbsentDAO.updateAbsent(vo);
            
            // 결시원 정보조회
            String examAbsentCd = vo.getExamAbsentCd();
            ExamAbsentVO absentVO = new ExamAbsentVO();
            absentVO.setExamAbsentCd(examAbsentCd);
            absentVO = examAbsentDAO.select(absentVO);
            
            String examStareTypeCd = absentVO.getExamStareTypeCd();
            String examStr = "M".equals(StringUtil.nvl(examStareTypeCd)) ? "중간고사" : "기말고사";
            
            String apprStat = StringUtil.nvl(vo.getApprStat());
            String msgCtnt = null;
            String logDesc = null;
            
            if("APPROVE".equals(apprStat)) {
                msgCtnt = "<b>["+examStr+"] 결시원 승인되었습니다.</b>";
                logDesc = "결시원 승인 쪽지 발송";
            } else if("COMPANION".equals(apprStat)) {
                msgCtnt = "<b>["+examStr+"] 결시원 반려되었습니다.</b><br/>반려 사유는 강의실에서 확인하세요.";
                logDesc = "결시원 반려 쪽지 발송";
            } 
            
            if(msgCtnt != null) {
                String stdUserId = absentVO.getUserId(); // 수강생 번호
                String stdUserNm = absentVO.getUserNm(); // 수강생명
                
                // 교수에게 쪽지발송 처리
                ErpMessageMsgVO erpMessageMsgVO = new ErpMessageMsgVO();
                erpMessageMsgVO.setUserId(stdUserId);
                erpMessageMsgVO.setUserNm(stdUserNm);
                erpMessageMsgVO.setCtnt(msgCtnt);
                erpMessageMsgVO.setCrsCreCd(absentVO.getCrsCreCd());
                
                // 쪽지발송 저장 // 쪽지발송 주석
                // erpService.insertSysMessageMsg(request, erpMessageMsgVO, logDesc);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    /*****************************************************
     * <p>
     * TODO 결시원 정리
     * </p>
     * 결시원 정리
     * 
     * @param ExamAbsentVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateAllCompanion(ExamAbsentVO vo) throws Exception {
        examAbsentDAO.updateAllCompanion(vo);
    }
    
    /*****************************************************
     * 결시원 정리 (교수)
     * @param ExamAbsentVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateAllCompanionProf(ExamAbsentVO vo) throws Exception {
        examAbsentDAO.updateAllCompanionProf(vo);
    }
    
    // 첨부파일 등록
    private FileVO addFile(ExamAbsentVO vo) throws Exception {
        FileVO fileVO = new FileVO();
        if(!"".equals(StringUtil.nvl(vo.getUploadFiles()))) {
            fileVO.setUploadFiles(StringUtil.nvl(vo.getUploadFiles()));
            fileVO.setCopyFiles(StringUtil.nvl(vo.getCopyFiles()));
            fileVO.setFilePath(StringUtil.nvl(vo.getUploadPath()));
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setRgtrId(vo.getRgtrId());
            fileVO.setFileBindDataSn(vo.getExamAbsentCd());
            fileVO = sysFileService.addFile(fileVO);
        }
        return fileVO;
    }

    /*****************************************************
     * <p>
     * TODO 관리자 > 결시원 리스트 조회
     * </p>
     * 관리자 > 결시원 리스트 조회
     * 
     * @param ExamAbsentVO
     * @return ProcessResultVO<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamAbsentVO> listAdminExamAbsent(ExamAbsentVO vo) throws Exception {
        ProcessResultVO<ExamAbsentVO> returnList = new ProcessResultVO<ExamAbsentVO>();
        List<ExamAbsentVO> absentList = examAbsentDAO.listAdminExamAbsent(vo);
        if("excelDown".equals(StringUtil.nvl(vo.getSearchMenu()))) {
            for(ExamAbsentVO absentVO : absentList) {
                absentVO.setDeclsNo(absentVO.getDeclsNo().length() == 1 ? "0"+absentVO.getDeclsNo() : absentVO.getDeclsNo());
                SimpleDateFormat dtFormat = new SimpleDateFormat("yyyyMMddHHmmss");
                SimpleDateFormat newDtFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date formatDate = dtFormat.parse(StringUtil.nvl(absentVO.getRegDttm()));
                absentVO.setRegDttm(newDtFormat.format(formatDate));
                formatDate = dtFormat.parse(StringUtil.nvl(absentVO.getModDttm()));
                absentVO.setMdfrNm("APPLICATE".equals(absentVO.getApprStat()) || "RAPPLICATE".equals(absentVO.getApprStat()) ? "" : absentVO.getMdfrNm());
                absentVO.setModDttm("APPLICATE".equals(absentVO.getApprStat()) || "RAPPLICATE".equals(absentVO.getApprStat()) ? "" : newDtFormat.format(formatDate));
            }
        }
        returnList.setReturnList(absentList);
        return returnList;
    }

    /*****************************************************
     * <p>
     * TODO 관리자 > 실시간시험 과목 결시원 미신청 목록 조회
     * </p>
     * 관리자 > 실시간시험 과목 결시원 미신청 목록 조회
     * 
     * @param ExamAbsentVO
     * @return ProcessResultVO<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamAbsentVO> listCreCrsNotAbsent(ExamAbsentVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<ExamAbsentVO> examList = examAbsentDAO.listCreCrsNotAbsent(vo);
        
        if(examList.size() > 0) {
            paginationInfo.setTotalRecordCount(examList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<ExamAbsentVO> resultVO = new ProcessResultVO<ExamAbsentVO>();
        
        resultVO.setReturnList(examList);
        resultVO.setPageInfo(paginationInfo);
        
        return resultVO;
    }
    
    /*****************************************************
     * 학생 전체 결시원 대상 시험 리스트 조회
     * @param ExamAbsentVO
     * @return List<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    public List<ExamAbsentVO> listAllStuAbsentExam(ExamAbsentVO vo) throws Exception {
        return examAbsentDAO.listAllStuAbsentExam(vo);
    }

    /*****************************************************
     * 학생 결시원 신청내역 체크
     * @param ExamAbsentVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectExamAbsentApplicateYn(ExamAbsentVO vo) throws Exception {
        return examAbsentDAO.selectExamAbsentApplicateYn(vo);
    }
}
