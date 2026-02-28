package knou.lms.file.web;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.exception.SessionBrokenException;
import knou.framework.util.FileUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.FileBoxInfoService;
import knou.lms.file.vo.FileBoxInfoVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;

@Controller
@RequestMapping(value = {"/file/fileHome"})
public class FileHomeController extends ControllerBase {
    
    private static final Logger LOGGER = LoggerFactory.getLogger(FileHomeController.class);
    
    @Resource(name="fileBoxInfoService")
    private FileBoxInfoService fileBoxInfoService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;
    
    @Resource(name="sysFileService")
    private SysFileService sysFileService;
    
    /***************************************************** 
     * 파일함
     * @param vo
     * @param model
     * @param request
     * @return "file/file_box"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/Form/fileBox.do")
    public String fileBoxForm(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String userId = SessionInfo.getUserId(request);
        
        if(ValidationUtils.isEmpty(userId)) {
            // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            throw new SessionBrokenException(getMessage("common.system.no_auth"));
        }
        
        if(StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request)).contains("USR")) {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME, "개인자료실 이용");
        }
        
        model.addAttribute("vo", vo);
        
        return "file/file_box";
    }
    
    /***************************************************** 
     * 파일함
     * @param vo
     * @param model
     * @param request
     * @return "file/file_box"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/Form/crsFileBox.do")
    public String crsFileBoxForm(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = SessionInfo.getUserId(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd = vo.getCrsCreCd();
        
        if(ValidationUtils.isEmpty(userId)) {
            // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            throw new SessionBrokenException(getMessage("common.system.no_auth"));
        }
        
        if(menuType.contains("USR")) {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_LECTURE_HOME, "개인자료실 이용");
        }
        
        model.addAttribute("vo", vo);
        model.addAttribute("crsFile", "Y");
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", crsCreCd);
        
        return "file/crs_file_box";
    }
    
    /***************************************************** 
     * 파일함 폴터 트리 화면 조회.
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileBoxInfoVO>
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/listFileBoxTree.do")
    @ResponseBody
    public ProcessResultVO<FileBoxInfoVO> listFileBoxTree(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<FileBoxInfoVO> resultVO = new ProcessResultVO<>();
        String userId = SessionInfo.getUserId(request);
        
        try {
            
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }
            
            vo.setRgtrId(userId);
            List<FileBoxInfoVO> returnList = fileBoxInfoService.listFileBoxTree(vo);
            resultVO.setReturnList(returnList);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }

        return resultVO;
    }
    
    /***************************************************** 
     * 파일함 폴터 내용 조회.
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileBoxInfoVO>
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/listFileBox.do")
    @ResponseBody
    public ProcessResultVO<FileBoxInfoVO> listFileBox(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<FileBoxInfoVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }
            
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            
            List<FileBoxInfoVO> returnList = fileBoxInfoService.listFileBox(vo);
            resultVO.setReturnList(returnList);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 자신의 파일함 사용률 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileBoxInfoVO>
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/fileBoxUseRate.do")
    @ResponseBody
    public ProcessResultVO<FileBoxInfoVO> fileBoxUseRate(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<FileBoxInfoVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {

            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }
            
            vo.setRgtrId(userId);
            vo.setOrgId(orgId);
            
            FileBoxInfoVO fileBoxInfoVO = fileBoxInfoService.selectFileBoxUseRate(vo);
            resultVO.setReturnVO(fileBoxInfoVO);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 폴더생성
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileBoxInfoVO>
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/createFolder.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<FileBoxInfoVO> createFolder(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<FileBoxInfoVO> resultVO = new ProcessResultVO<>();
        String userId = SessionInfo.getUserId(request);
        String fileBoxNm = vo.getFileBoxNm();
        String parFileBoxCd = StringUtil.nvl(vo.getParFileBoxCd(), "ROOT");
        
        try {
            
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }
            
            if(ValidationUtils.isEmpty(fileBoxNm)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            
            // 사용자의 폴더 여부 체크
            if(!"ROOT".equals(parFileBoxCd)) {
                FileBoxInfoVO fileBoxInfoVO = new FileBoxInfoVO();
                fileBoxInfoVO.setFileBoxCd(parFileBoxCd);
                fileBoxInfoVO.setRgtrId(userId);
                fileBoxInfoVO.setFileBoxTypeCd("FOLDER");
                
                int count = fileBoxInfoService.countUserFileBoxCd(fileBoxInfoVO);
                
                if(count != 1) {
                    // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                    throw new AccessDeniedException(getMessage("common.system.error"));
                }
            }
            vo.setRgtrId(userId);
            
            fileBoxInfoService.createFolder(vo);
            resultVO.setResult(1);

        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /***************************************************** 
     * 파일함내의 폴더 또는 파일 삭제처리
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileBoxInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/deleteFileBox.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<FileBoxInfoVO> deleteFileBox(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<FileBoxInfoVO> resultVO = new ProcessResultVO<>();
        String userId = SessionInfo.getUserId(request);
        List<String> fileBoxCds = vo.getFileBoxCds();
        
        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }
            
            if(fileBoxCds == null || fileBoxCds.isEmpty() || fileBoxCds.size() == 0) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            
            fileBoxInfoService.deleteFileBox(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 파일함내의 폴더 또는 파일 삭제처리
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileBoxInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/updateFileBoxNm.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<FileBoxInfoVO> updateFileBoxNm(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<FileBoxInfoVO> resultVO = new ProcessResultVO<>();
        String userId = SessionInfo.getUserId(request);
        String fileBoxCd = vo.getFileBoxCd();
        String fileBoxNm = vo.getFileBoxNm();
        
        try {
            
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }
            
            if(ValidationUtils.isEmpty(fileBoxCd) || ValidationUtils.isEmpty(fileBoxNm)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            
            // 사용자 파일(폴더) 여부 체크
            FileBoxInfoVO fileBoxInfoVO = new FileBoxInfoVO();
            fileBoxInfoVO.setFileBoxCd(fileBoxCd);
            fileBoxInfoVO.setRgtrId(userId);
            
            int count = fileBoxInfoService.countUserFileBoxCd(fileBoxInfoVO);
            
            if(count != 1) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            
            fileBoxInfoService.updateFileBoxNm(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 파일 또는 폴더 상세정보 조회
     * @param vo
     * @param model
     * @param request
     * @return "file/popup/file_box_detail"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/popup/fileBoxDetail.do")
    public String fileBoxDetailPopup(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String userId = SessionInfo.getUserId(request);
        vo.setRgtrId(userId);

        FileBoxInfoVO resultVo = fileBoxInfoService.getFileBoxDetailInfo(vo);
        List<String> fullFolderPath = fileBoxInfoService.listFullFolderPath(vo);
        
        model.addAttribute("vo", vo);
        model.addAttribute("resultVo", resultVo);
        model.addAttribute("fullFolderPath", fullFolderPath);

        return "file/popup/file_box_detail";
    }

    /***************************************************** 
     * 파일박스 파일 업로드 팝업
     * @param vo
     * @param model
     * @param request
     * @return "file/popup/file_box_upload"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/popup/fileBoxUpload.do")
    public String fileBoxUploadPopup(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        if(ValidationUtils.isEmpty(userId)) {
            // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            throw new SessionBrokenException(getMessage("common.system.no_auth"));
        }
        
        vo.setRgtrId(userId);
        vo.setOrgId(orgId);
        FileBoxInfoVO fileBoxUseRateInfo = fileBoxInfoService.selectFileBoxUseRate(vo);
        
        Long fileLimitSize = fileBoxUseRateInfo.getFileLimitSize();
        Long fileUseSize = fileBoxUseRateInfo.getFileUseSize();
        int limitSize = 0;
        
        limitSize = Math.round((fileLimitSize - fileUseSize) / 1024 / 1024);
        
        model.addAttribute("vo", vo);
        model.addAttribute("fileBoxUseRateInfo", fileBoxUseRateInfo);
        model.addAttribute("limitSize", limitSize);
        model.addAttribute("userId", userId);
        
        return "file/popup/file_box_upload";
    }
    
    /***************************************************** 
     * 파일함에 업로드
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileBoxInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addFileToFileBox.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<FileBoxInfoVO> addFileToFileBox(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<FileBoxInfoVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String parFileBoxCd = StringUtil.nvl(vo.getParFileBoxCd(), "ROOT");
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();
        
        try {
            
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }
            
            if(ValidationUtils.isEmpty(uploadFiles)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            // 사용자의 폴더 여부 체크
            if(!"ROOT".equals(parFileBoxCd)) {
                FileBoxInfoVO fileBoxInfoVO = new FileBoxInfoVO();
                fileBoxInfoVO.setFileBoxCd(parFileBoxCd);
                fileBoxInfoVO.setRgtrId(userId);
                fileBoxInfoVO.setFileBoxTypeCd("FOLDER");
                
                int count = fileBoxInfoService.countUserFileBoxCd(fileBoxInfoVO);
                
                if(count != 1) {
                    // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                    throw new AccessDeniedException(getMessage("common.system.error"));
                }
            }
            
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            
            fileBoxInfoService.addFileToFileBox(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
            
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
            
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("filebox.error.addfile.fail")); // 등록 처리 중 에러가 발생하였습니다.
            
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 파일 박스 가져오기 팝업
     * @param vo
     * @param model
     * @param request
     * @return "file/popup/file_box_copy"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/popup/fileBoxCopy.do")
    public String fileBoxCopyPopup(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String userId = SessionInfo.getUserId(request);

        if(ValidationUtils.isEmpty(userId)) {
            // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            throw new SessionBrokenException(getMessage("common.system.no_auth"));
        }
        
        model.addAttribute("vo", vo);

        return "file/popup/file_box_copy";
    }
    
    /***************************************************** 
     * 자신의 파일함 파일 정보 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/listFileBoxFileInfo.do")
    @ResponseBody
    public ProcessResultVO<FileVO> listFileBoxFileInfo(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<FileVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }
            
            FileBoxInfoVO fileBoxInfoVO = new FileBoxInfoVO();
            fileBoxInfoVO.setOrgId(orgId);
            fileBoxInfoVO.setRgtrId(userId);
            fileBoxInfoVO.setFileBoxCds(vo.getFileBoxCds());
            
            List<FileVO> list = fileBoxInfoService.listFileBoxFileInfo(fileBoxInfoVO);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 파일목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listFileInfo.do")
    @ResponseBody
    public ProcessResultVO<FileVO> listFileInfo(FileVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<FileVO> resultVO = new ProcessResultVO<>();
        
        String repoCd = vo.getRepoCd();
        String fileBindDataSn = vo.getFileBindDataSn();
        
        try {
            if(ValidationUtils.isEmpty(repoCd) || ValidationUtils.isEmpty(fileBindDataSn)) {
                throw new BadRequestUrlException(getMessage("common.system.error")); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd(repoCd);
            fileVO.setFileBindDataSn(fileBindDataSn);
            List<FileVO> fileList = (List<FileVO>) sysFileService.list(fileVO).getReturnList();
            
            resultVO.setReturnList(fileList);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다! 
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * zip파일 다운로드
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/zipFileDown.do")
    @ResponseBody
    public void zipFileDown(FileVO vo, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String fileNamePattern = "[:\\\\/%*?:|\"<>]";
        
        String repoCd = vo.getRepoCd();
        String fileBindDataSn = vo.getFileBindDataSn();
        String fileNm = StringUtil.nvl(vo.getFileNm()).replaceAll(fileNamePattern, "");
        
        if(fileNm.length() > 20) {
            fileNm = fileNm.substring(0, 20);
        }
     
        if(ValidationUtils.isNotEmpty(repoCd) || ValidationUtils.isNotEmpty(fileBindDataSn)) {
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd(repoCd);
            fileVO.setFileBindDataSn(fileBindDataSn);
            List<FileVO> fileList = (List<FileVO>) sysFileService.list(fileVO).getReturnList();
            
            sysFileService.zipFileDown(fileNm, fileList, request, response);
        }
    }
    
    /***************************************************** 
     * 파일 업로드 정보 저장
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileBoxInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addFileInfo.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<FileBoxInfoVO> addFileInfo(FileVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<FileBoxInfoVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String repoCd = vo.getRepoCd();
        String fileBindDataSn = vo.getFileBindDataSn();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();
        String[] delFileIds = vo.getDelFileIds();
        
        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }
            
            if(ValidationUtils.isEmpty(repoCd) || ValidationUtils.isEmpty(fileBindDataSn) || ValidationUtils.isEmpty(uploadPath)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }
            
            if(ValidationUtils.isNotEmpty(uploadFiles)) {
                List<FileVO> uploadFileList = FileUtil.getUploadFileList(uploadFiles);
                
                if(uploadFileList.size() > 0) {
                    FileVO uploadFileVO = new FileVO();
                    uploadFileVO.setOrgId(orgId);
                    uploadFileVO.setUploadFiles(uploadFiles);
                    uploadFileVO.setFilePath(uploadPath);
                    uploadFileVO.setRepoCd(repoCd);
                    uploadFileVO.setRgtrId(userId);
                    uploadFileVO.setFileBindDataSn(fileBindDataSn);
                    uploadFileVO = sysFileService.addFile(uploadFileVO);
                }
            }
            
            // 선택 파일삭제
            if(delFileIds != null && delFileIds.length > 0) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd(repoCd);
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
            
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
            
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("filebox.error.addfile.fail")); // 등록 처리 중 에러가 발생하였습니다.
            
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
        }

        return resultVO;
    }
    
    /***************************************************** 
     * 물리파일 확인
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/saveFileInfo.do")
    @ResponseBody
    public ProcessResultVO<FileVO> saveFileInfo(FileVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<FileVO> resultVO = new ProcessResultVO<>();
        
        try {
            String message = "Y";
            List<FileVO> upFileList = FileUtil.getUploadFileList(vo.getUploadFiles());
            //List<FileVO> copyFileList = FileUtil.copyFromFilebox(vo.getCopyFiles(), StringUtil.nvl(vo.getUploadPath()));
            List<FileVO> fileList = new ArrayList<FileVO>();
            fileList.addAll(upFileList);
            //fileList.addAll(copyFileList);

            for(FileVO FileVO : fileList) {
                String fileDir = CommConst.WEBDATA_PATH + vo.getUploadPath() + "/" + FileVO.getFileSaveNm() + "." + StringUtil.getExtNoneDot(FileVO.getFileNm()).toLowerCase();
                File file = new File(fileDir);
                if(!file.exists()) {
                    message = "N";
                }
            }
            
            if("N".equals(message)) {
                resultVO.setResult(-1);
            } else {
                resultVO.setResult(1);
            }
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다! 
        }
        return resultVO;
    }
    
    @RequestMapping(value = "/Form/fileBoxMainInfo.do")
    public String getFileBoxMainView(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = SessionInfo.getUserId(request);
        if(ValidationUtils.isEmpty(userId)) {
            // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            throw new SessionBrokenException(getMessage("common.system.no_auth"));
        }

        if(StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request)).contains("USR")) {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME, "개인자료실 이용");
        } 
        request.setAttribute("vo", vo);

        return "file/file_box_main";
    }

    /***************************************************** 
     *자신의 파일함 사용률 조회
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/fileUseRate.do")
    public String getFileUseRate(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<DefaultVO>();

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        String userId = SessionInfo.getUserId(request);
        vo.setRgtrId(userId);

        try {
            FileBoxInfoVO resultVo = fileBoxInfoService.selectFileBoxUseRate(vo);
            returnVo.setReturnVO(resultVo);
            returnVo.setResultSuccess();
        } catch (Exception e) {
            e.printStackTrace();
            returnVo.setResultFailed();
        }

        return JsonUtil.responseJson(response, returnVo);
    }
    
    /***************************************************** 
     *파일함 폴터 트리 화면 조회.
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return file/file_box_tree
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/fileBoxTree")
    public String getFileBoxTreeView(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = SessionInfo.getUserId(request);
        vo.setRgtrId(userId);

        List<FileBoxInfoVO> resultList = fileBoxInfoService.listFileBoxTree(vo);
        request.setAttribute("vo", vo);
        request.setAttribute("resultList", resultList);

        return "file/file_box_tree";
    }
    
    /***************************************************** 
     *파일함 내의 파일 리스트 화면 조회.
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return file/file_box_list
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/fileBoxList.do")
    public String getFileBoxListView(FileBoxInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = SessionInfo.getUserId(request);
        vo.setRgtrId(userId);
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        
        vo.setDownloadDomain(request.getRequestURL().toString().replace(request.getRequestURI(),"") + request.getContextPath());

        List<FileBoxInfoVO> resultList = fileBoxInfoService.listFileBox(vo);
        List<String> fullFolderPath = fileBoxInfoService.getFullFolderPath(vo);
        if("ROOT".equals(vo.getSelectedFileBoxCd())) {
            vo.setSelectedFileBoxCd(null);
        }
        request.setAttribute("vo", vo);
        request.setAttribute("resultList", resultList);
        request.setAttribute("fullFolderPath", fullFolderPath);
        
        // 파일변환
        // String transServerUseYn = CommConst.TRANSFER_SERVER_USE_YN;
        // request.setAttribute("transServerUseYn", transServerUseYn);
        
        return "file/file_box_list";
    }    
}