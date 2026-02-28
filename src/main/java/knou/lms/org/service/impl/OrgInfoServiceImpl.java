package knou.lms.org.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.util.FileUtil;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.org.dao.OrgInfoDAO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrUserInfoVO;

@Service("orgInfoService")
public class OrgInfoServiceImpl implements OrgInfoService {

    private static final Logger LOGGER = LoggerFactory.getLogger(OrgInfoServiceImpl.class);
    
	@Resource(name="orgInfoDAO")
	private OrgInfoDAO orgInfoDAO;
	
	@Resource(name="sysFileService")
    private SysFileService sysFileService;
	
	@Resource(name="usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;

	/*****************************************************
     * 소속(테넌시)관리 정보
     * @param vo
     * @return OrgInfoVO
     * @throws Exception
     ******************************************************/
	@Override
    public OrgInfoVO select(OrgInfoVO vo) throws Exception {
        return orgInfoDAO.select(vo);
    }
	
	/*****************************************************
     * 소속(테넌시)관리 목록
     * @param vo
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
	@Override
    public List<OrgInfoVO> list(OrgInfoVO vo) throws Exception {
        return orgInfoDAO.list(vo);
    }
	
	/*****************************************************
     * 소속(테넌시)관리 페이징 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<OrgInfoVO> listPaging(OrgInfoVO vo) throws Exception {
        ProcessResultVO<OrgInfoVO> resultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        int totalCnt = orgInfoDAO.count(vo);
        
        paginationInfo.setTotalRecordCount(totalCnt);
        
        List<OrgInfoVO> list = orgInfoDAO.listPaging(vo);
     
        resultVO.setReturnList(list);
        resultVO.setPageInfo(paginationInfo);
        resultVO.setResult(1);
        
        return resultVO;
    }
    
    /*****************************************************
     * 소속(테넌시)관리 등록
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void insert(OrgInfoVO vo) throws Exception {
        String rgtrId = vo.getRgtrId();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();
        String copyFiles = vo.getCopyFiles();
        
        // 기관 등록
        orgInfoDAO.insert(vo);
        
        String orgId = vo.getOrgId();
        String userId = vo.getUserId();
        String userPass = vo.getUserPass();
        String userNm = vo.getUserNm();
        String email = vo.getEmail();
        String ofceTelno = vo.getOfcTelno();
        String mobileNo = vo.getMobileNo();
        
        // 기본관리자 등록
        UsrUserInfoVO usrUserInfoVO = new UsrUserInfoVO();
        usrUserInfoVO.setOrgId(orgId);
        usrUserInfoVO.setUserId(userId);
        usrUserInfoVO.setUserId(userId);
        usrUserInfoVO.setUserIdEncpswd(userPass);
        usrUserInfoVO.setUserNm(userNm);
        usrUserInfoVO.setEmail(email);
        usrUserInfoVO.setOfceTelno(ofceTelno);
        usrUserInfoVO.setMobileNo(mobileNo);
        usrUserInfoVO.setMngAuthGrpCd("/DEV");
        usrUserInfoVO.setRgtrId(rgtrId);
        usrUserInfoVO.setMdfrId(rgtrId);
        usrUserInfoVO.setDeptCd(orgId);
        usrUserInfoVO.setDeptNm("KNOU");
        usrUserInfoVO.setUserConf("{\"lang\":\"ko\"}");
        usrUserInfoService.addUserInfo(usrUserInfoVO, "AI");
        
        List<FileVO> uploadFileList = null;
        List<FileVO> copyFileList = null;
        try {
            uploadFileList = FileUtil.getUploadFileList(vo.getUploadFiles());
            copyFileList = FileUtil.getUploadFileList(vo.getCopyFiles());
         
            // 파일 업로드
            if(uploadFileList.size() > 0) {
                FileVO fileVO = new FileVO();
                fileVO.setUploadFiles(uploadFiles);
                fileVO.setFilePath(uploadPath);
                fileVO.setRepoCd("ORGINFO");
                fileVO.setRgtrId(rgtrId);
                fileVO.setFileBindDataSn(orgId);
                sysFileService.addFile(fileVO);
            }
            
            // 파일함 복사
            if(copyFileList.size() > 0) {
                FileVO fileVO = new FileVO();
                fileVO.setCopyFiles(copyFiles);
                fileVO.setFilePath(uploadPath);
                fileVO.setRepoCd("ORGINFO");
                fileVO.setRgtrId(rgtrId);
                fileVO.setFileBindDataSn(orgId);
                fileVO = sysFileService.addFile(fileVO);
            }
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            
            if(uploadFileList.size() > 0) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
            
            if(copyFileList.size() > 0) {
                FileUtil.delUploadFileList(copyFiles, uploadPath);
            }
            
            throw e;
        }
    }
    
    /*****************************************************
     * 소속(테넌시)관리 수정
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void update(OrgInfoVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();
        String copyFiles = vo.getCopyFiles();
        
        orgInfoDAO.update(vo);
        
        List<FileVO> uploadFileList = null;
        List<FileVO> copyFileList = null;
        try {
            uploadFileList = FileUtil.getUploadFileList(vo.getUploadFiles());
            copyFileList = FileUtil.getUploadFileList(vo.getCopyFiles());
         
            // 파일 업로드
            if(uploadFileList.size() > 0) {
                FileVO fileVO = new FileVO();
                fileVO.setUploadFiles(uploadFiles);
                fileVO.setFilePath(uploadPath);
                fileVO.setRepoCd("ORGINFO");
                fileVO.setRgtrId(vo.getMdfrId());
                fileVO.setFileBindDataSn(orgId);
                sysFileService.addFile(fileVO);
            }
            
            // 파일함 복사
            if(copyFileList.size() > 0) {
                FileVO fileVO = new FileVO();
                fileVO.setCopyFiles(copyFiles);
                fileVO.setFilePath(uploadPath);
                fileVO.setRepoCd("ORGINFO");
                fileVO.setRgtrId(vo.getMdfrId());
                fileVO.setFileBindDataSn(orgId);
                fileVO = sysFileService.addFile(fileVO);
            }
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            
            if(uploadFileList.size() > 0) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
            
            if(copyFileList.size() > 0) {
                FileUtil.delUploadFileList(copyFiles, uploadPath);
            }
            
            throw e;
        }
        
        // 파일삭제
        String[] delFileIds = vo.getDelFileIds();
        if(delFileIds != null && delFileIds.length > 0) {
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("ORGINFO");
            fileVO.setFileBindDataSn(vo.getOrgId());
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
     * 소속(테넌시)관리 사용안함
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void updateUseN(OrgInfoVO vo) throws Exception {
        // 기관 정보 삭제 업데이트
        orgInfoDAO.updateUseN(vo);
    }

    /*****************************************************
     * 소속(테넌시)관리 전체운영자 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listOrgAdmUser(OrgInfoVO vo) throws Exception {
        return orgInfoDAO.listOrgAdmUser(vo);
    }

    /*****************************************************
     * 운영 기관 전체 조회
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<OrgInfoVO> listActiveOrg() throws Exception {
        return orgInfoDAO.listActiveOrg();
    }
}