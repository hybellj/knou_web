package knou.lms.file.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.SecureUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.FilePathInfoVO;
import knou.lms.crs.crecrs.dao.CrecrsDAO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.dao.TermDAO;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.file.dao.FileBoxInfoDAO;
import knou.lms.file.service.FileBoxInfoService;
import knou.lms.file.vo.FileBoxInfoVO;

@Service("fileBoxInfoService")
public class FileBoxInfoServiceImpl  extends ServiceBase implements FileBoxInfoService {

    @Resource(name = "fileBoxInfoDAO")
    private FileBoxInfoDAO fileBoxInfoDAO;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="termDAO")
    private TermDAO termDAO;

    @Resource(name="crecrsDAO")
    private CrecrsDAO crecrsDAO;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    /***************************************************** 
     * 파일함 트리 조회.
     * @param vo
     * @return List<FileBoxInfoVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<FileBoxInfoVO> listFileBoxTree(FileBoxInfoVO vo) throws Exception {
        return fileBoxInfoDAO.listFileBoxTree(vo);
    }

    /***************************************************** 
     * 선택한 폴더 내의 파일 리스트를 조회한다.
     * @param vo
     * @return List<FileBoxInfoVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<FileBoxInfoVO> listFileBox(FileBoxInfoVO vo) throws Exception {
        List<FileBoxInfoVO> resultList = fileBoxInfoDAO.listFileBox(vo);

        for(FileBoxInfoVO resultVO : resultList) {
            if(resultVO.getFileSize() != null) {
                resultVO.setFileSizeFormatted(FileUtil.fileSizeFormatter(resultVO.getFileSize()));
            }

            String downloadUrl = resultVO.getDownloadUrl();

            if(ValidationUtils.isNotEmpty(downloadUrl)) {
                downloadUrl = SecureUtil.encodeDownPath(downloadUrl);;
                downloadUrl = CommConst.CONTEXT_FILE_DOWNLOAD + "?path=" + downloadUrl;
                resultVO.setDownloadUrl(downloadUrl);
            }

            String contentUrl = resultVO.getContentUrl();

            if(ValidationUtils.isNotEmpty(contentUrl)) {
                contentUrl = CommConst.WEBDATA_CONTEXT + contentUrl;
                resultVO.setContentUrl(contentUrl);
            }
        }
        return resultList;
    }

    @Override
    public List<FileBoxInfoVO> listNoFileSnBox(FileBoxInfoVO vo) throws Exception {
        List<FileBoxInfoVO> resultList = fileBoxInfoDAO.listNoFileSnBox(vo);

        for(FileBoxInfoVO resultVO : resultList) {
            if(resultVO.getFileSize() != null) {
                resultVO.setFileSizeFormatted(FileUtil.fileSizeFormatter(resultVO.getFileSize()));
            }

            String downloadUrl = resultVO.getDownloadUrl();

            if(ValidationUtils.isNotEmpty(downloadUrl)) {
                downloadUrl = SecureUtil.encodeDownPath(downloadUrl);
                downloadUrl = CommConst.CONTEXT_FILE_DOWNLOAD + "?path=" + downloadUrl;
                resultVO.setDownloadUrl(downloadUrl);
            }

            String contentUrl = resultVO.getContentUrl();

            if(ValidationUtils.isNotEmpty(contentUrl)) {
                contentUrl = CommConst.WEBDATA_CONTEXT + contentUrl;
                resultVO.setContentUrl(contentUrl);
            }
        }
        return resultList;
    }
    
    /***************************************************** 
     * 자신의 파일함 사용률 조회
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    @Override
    public FileBoxInfoVO selectFileBoxUseRate(FileBoxInfoVO vo) throws Exception {
        FileBoxInfoVO fileBoxInfoVO = fileBoxInfoDAO.selectFileBoxUseRate(vo);

        if(fileBoxInfoVO != null) {
            Long fileLimitSize = fileBoxInfoVO.getFileLimitSize();
            Long fileUseSize = fileBoxInfoVO.getFileUseSize();

            String fileLimitSizeFormatted = FileUtil.fileSizeFormatter(fileLimitSize);
            String fileUseSizeFormatted = FileUtil.fileSizeFormatter(fileUseSize);

            fileBoxInfoVO.setFileLimitSizeFormatted(fileLimitSizeFormatted);
            fileBoxInfoVO.setFileUseSizeFormatted(fileUseSizeFormatted);
        }
        return fileBoxInfoVO;
    }

    /***************************************************** 
     * 자신의 파일함 남은 용량 조회
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    public long selectFileBoxUnusedByte(FileBoxInfoVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String rgtrId = vo.getRgtrId();

        if(ValidationUtils.isEmpty(orgId) || ValidationUtils.isEmpty(rgtrId)) {
            // 파일함 사용량 정보 체크중 오류가 발생하였습니다.
            throw processException("filebox.error.limit.check.fail");
        }

        // 1.파일함 용량제한 체크
        FileBoxInfoVO fileBoxUseRateVO = new FileBoxInfoVO();
        fileBoxUseRateVO.setOrgId(orgId);
        fileBoxUseRateVO.setRgtrId(rgtrId);
        fileBoxUseRateVO = this.selectFileBoxUseRate(vo);

        if(fileBoxUseRateVO == null) {
            // 파일함 사용량 정보가 존재하지 않습니다.
            throw processException("filebox.error.fileuse.not_exist");
        }

        long fileLimitSize = fileBoxUseRateVO.getFileLimitSize();
        long fileUseSize = fileBoxUseRateVO.getFileUseSize();
        long limitSize = 0;

        // 남은사용량 체크
        limitSize = fileLimitSize - fileUseSize;

        if(limitSize <= 0) {
            limitSize = 0;
        }
        return limitSize;
    }

    /***************************************************** 
     * 폴더생성
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    @Override
    public FileBoxInfoVO createFolder(FileBoxInfoVO vo) throws Exception {

        String rgtrId = vo.getRgtrId();
        String fileBoxNm = vo.getFileBoxNm();

        if(ValidationUtils.isEmpty(rgtrId) || ValidationUtils.isEmpty(fileBoxNm)) {
            // 폴더 생성 중 에러가 발생하였습니다.
            throw processException("filebox.error.folercreate.fail");
        }

        String newFileBoxCd = IdGenerator.getNewId("FB");
        vo.setFileBoxCd(newFileBoxCd);
        vo.setFileBoxTypeCd("FOLDER");

        if("".equals(StringUtil.nvl(vo.getParFileBoxCd()))) {
            vo.setParFileBoxCd(null);
        }

        fileBoxInfoDAO.insertFileBox(vo);

        return vo;
    }

    /***************************************************** 
     * 파일함내의 폴더 또는 파일 삭제처리
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteFileBox(FileBoxInfoVO vo) throws Exception {

        List<String> deleteFileBoxList = vo.getFileBoxCds();
        if(deleteFileBoxList != null && !deleteFileBoxList.isEmpty() && deleteFileBoxList.size() > 0) {
            for(String fileBoxCd : deleteFileBoxList) {
                vo.setFileBoxCd(fileBoxCd);

                // 1. 파일함 삭제
                List<FileBoxInfoVO> listDeleteFileBox = fileBoxInfoDAO.listDeleteFileBox(vo);
                if(listDeleteFileBox != null && !listDeleteFileBox.isEmpty() && listDeleteFileBox.size() > 0) {
                    List<String> fileBoxCds = new ArrayList<>();

                    for(FileBoxInfoVO item : listDeleteFileBox) {
                        fileBoxCds.add(item.getFileBoxCd());
                    }

                    FileBoxInfoVO fileBoxInfoVO = new FileBoxInfoVO();
                    fileBoxInfoVO.setFileBoxCds(fileBoxCds);
                    fileBoxInfoDAO.deleteFileBox(fileBoxInfoVO);
                }

                // 2. 물리적 파일 삭제
                List<FilePathInfoVO> delFileList = fileBoxInfoDAO.listDeleteFile(vo);
                if(delFileList != null && !delFileList.isEmpty() && delFileList.size() > 0) {
                    for (FilePathInfoVO pathVo : delFileList) {
                        sysFileService.removeFile(pathVo.getFileSn());
                    }
                }
            }
        }
    }

    /***************************************************** 
     * 파일 또는 폴더 상세정보 조회
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    @Override
    public FileBoxInfoVO getFileBoxDetailInfo(FileBoxInfoVO vo) throws Exception {
        FileBoxInfoVO resultVo = fileBoxInfoDAO.selectFileBoxDetailInfo(vo);

        if(resultVo != null) {
            if(resultVo.getFileSize() != null) {
                resultVo.setFileSizeFormatted(FileUtil.fileSizeFormatter(resultVo.getFileSize()));
            }

            String downloadUrl = resultVo.getDownloadUrl();

            if(ValidationUtils.isNotEmpty(downloadUrl)) {
                downloadUrl = SecureUtil.encodeDownPath(downloadUrl);
                downloadUrl = CommConst.CONTEXT_FILE_DOWNLOAD + "?path=" + downloadUrl;
                resultVo.setDownloadUrl(downloadUrl);
            }
        }
        return resultVo;
    }

    /***************************************************** 
     * 선택한 폴더의 full 경로 조회
     * @param vo
     * @return String
     * @throws Exception
     ******************************************************/
    @Override
    public List<String> listFullFolderPath(FileBoxInfoVO vo) throws Exception {
        return fileBoxInfoDAO.listFullFolderPath(vo);
    }

    /***************************************************** 
     * 파일함 이름 변경
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void updateFileBoxNm(FileBoxInfoVO vo) throws Exception {
        fileBoxInfoDAO.updateFileBoxNm(vo);

        // 폴더명 변경이 아닌 파일명 변경이면 tb_sys_file의 파일명도 변경 해준다.
        FileBoxInfoVO simpleVo = fileBoxInfoDAO.selectFileBoxSimpleInfo(vo);
        if(!"FOLDER".equals(simpleVo.getFileBoxTypeCd())) {
            vo.setFileSn(simpleVo.getFileSn());
            fileBoxInfoDAO.updateSysFileNm(vo);
        }
    }

    /***************************************************** 
     * 파일함에 추가
     * @param vo
     * @throws Exception
     ******************************************************/
    @SuppressWarnings("unchecked")
    public void addFileBox(FileBoxInfoVO vo) throws Exception {
        String rgtrId = vo.getRgtrId();
        List<FileVO> uploadedFileList = (List<FileVO>) vo.getFileList();
        String parFileBoxCd = StringUtil.nvl(vo.getParFileBoxCd(), "ROOT");

        if(ValidationUtils.isEmpty(rgtrId) || uploadedFileList == null || uploadedFileList.size() == 0) {
            // 등록 처리 중 에러가 발생하였습니다.
            throw processException("filebox.error.addfile.fail");
        }
        
        // 파일 박스 업로드 정보 저장
        String newFileBoxCd;

        for(FileVO uploadFileVO : uploadedFileList) {
            newFileBoxCd = IdGenerator.getNewId("FB");

            FileBoxInfoVO fileBoxInfoVO = new FileBoxInfoVO();
            fileBoxInfoVO.setFileBoxCd(newFileBoxCd);
            fileBoxInfoVO.setFileSn("" + uploadFileVO.getFileSn());
            fileBoxInfoVO.setFileBoxNm(FilenameUtils.getBaseName(uploadFileVO.getFileNm()));

            String ext = uploadFileVO.getFileExt().toLowerCase();
            String[] arrDocExt = CommConst.FILEBOX_EXT_TYPE_DOC.split("\\|");
            String[] arrMovExt = CommConst.FILEBOX_EXT_TYPE_MOV.split("\\|");
            String[] arrImgExt = CommConst.FILEBOX_EXT_TYPE_IMG.split("\\|");

            fileBoxInfoVO.setFileBoxTypeCd("ETC");
            if(Arrays.stream(arrDocExt).anyMatch(ext::equals)) {
                fileBoxInfoVO.setFileBoxTypeCd("DOC");
            } else if(Arrays.stream(arrImgExt).anyMatch(ext::equals)) {
                fileBoxInfoVO.setFileBoxTypeCd("IMG");
            } else if(Arrays.stream(arrMovExt).anyMatch(ext::equals)) {
                fileBoxInfoVO.setFileBoxTypeCd("MOV");
            }
            
            if(!"ROOT".equals(parFileBoxCd)) {
                fileBoxInfoVO.setParFileBoxCd(parFileBoxCd);
            }

            fileBoxInfoVO.setRgtrId(rgtrId);
            fileBoxInfoVO.setMdfrId(rgtrId);

            fileBoxInfoDAO.insertFileBox(fileBoxInfoVO);
        }
    }

    /***************************************************** 
     * 파일함에 파일 추가
     * @param vo
     * @throws Exception
     ******************************************************/
    @SuppressWarnings("unchecked")
    @Override
    public void addFileToFileBox(FileBoxInfoVO vo) throws Exception {
        String parFileBoxCd = vo.getParFileBoxCd();
        String uploadFiles = vo.getUploadFiles();
        String orgId = vo.getOrgId();
        String rgtrId = vo.getRgtrId();
        String uploadPath = vo.getUploadPath();

        try {
            List<FileVO> upFileList = FileUtil.getUploadFileList(vo.getUploadFiles());

            if(ValidationUtils.isEmpty(orgId) || ValidationUtils.isEmpty(rgtrId) || upFileList.size() == 0) {
                // 등록 처리 중 에러가 발생하였습니다.
                throw processException("filebox.error.addfile.fail");
            }

            // 1.파일박스 용량제한 체크
            FileBoxInfoVO fileBoxUseRateVO = new FileBoxInfoVO();
            fileBoxUseRateVO.setOrgId(orgId);
            fileBoxUseRateVO.setRgtrId(rgtrId);
            long unusedByte = this.selectFileBoxUnusedByte(fileBoxUseRateVO);

            // 업로드 용량 체크(byte)
            long uploadByte = 0;

            for(FileVO fileVO : upFileList) {
                uploadByte += fileVO.getFileSize();
            }

            if((unusedByte - uploadByte) <= 0) {
                // 용량을 초과하여 내 파일함에 보낼 수 없습니다.
                throw processException("filebox.error.exceed.limitSize");
            }

            // 파일 업로드 정보 저장
            FileVO fileVO = new FileVO();
            fileVO.setUploadFiles(uploadFiles);
            fileVO.setFilePath(uploadPath);
            fileVO.setRepoCd("FILE_BOX");
            fileVO.setRgtrId(rgtrId);
            fileVO.setFileBindDataSn(null);
            fileVO = sysFileService.addFile(fileVO);

            List<FileVO> uploadedFileList = (List<FileVO>) fileVO.getFileList();

            FileBoxInfoVO fileBoxInfoVO = new FileBoxInfoVO();
            fileBoxInfoVO.setOrgId(orgId);
            fileBoxInfoVO.setRgtrId(rgtrId);
            fileBoxInfoVO.setParFileBoxCd(parFileBoxCd);
            fileBoxInfoVO.setFileList(uploadedFileList);

            this.addFileBox(fileBoxInfoVO);
        } catch (Exception e) {
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
            throw e;
        }
    }

    /***************************************************** 
     * 강의컨텐츠 파일박스 저장 폴더명 가져오기
     * @param vo
     * @return String
     * @throws Exception
     ******************************************************/
    public String getLessonCntsFolderNm(FileBoxInfoVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();

        if(ValidationUtils.isEmpty(crsCreCd)) {
            throw processException("filebox.error.lesson.cnts.folder.nm"); // 학습콘텐츠 폴더명 생성중 오류가 발생하엿습니다.
        }

        TermVO termVO = new TermVO();
        termVO.setCrsCreCd(crsCreCd);
        termVO = termDAO.selectTermByCrsCreCd(termVO);

        if(termVO == null) {
            throw processException("filebox.error.lesson.cnts.folder.nm"); // 학습콘텐츠 폴더명 생성중 오류가 발생하엿습니다.
        }

        termVO = termDAO.select(termVO);

        if(termVO == null) {
            throw processException("filebox.error.lesson.cnts.folder.nm"); // 학습콘텐츠 폴더명 생성중 오류가 발생하엿습니다.
        }

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsDAO.select(creCrsVO);

        if(creCrsVO == null) {
            throw processException("filebox.error.lesson.cnts.folder.nm"); // 학습콘텐츠 폴더명 생성중 오류가 발생하엿습니다.
        }

        String contentFolderNm = termVO.getHaksaYear() + "_" + termVO.getTermNm() + "_" + creCrsVO.getCrsCreNm();

        String restrictChars = "|\\\\?*<\":>/";
        String regExpr = "[" + restrictChars + "]+";

        // 파일명으로 사용 불가능한 특수문자 제거
        String tmpStr = contentFolderNm.replaceAll(regExpr, "");

        // 공백문자 "_"로 치환
        return tmpStr.replaceAll("[ ]", "_");
    }

    /***************************************************** 
     * 자신의 파일함 파일정보 목록
     * @param vo
     * @return List<FileVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<FileVO> listFileBoxFileInfo(FileBoxInfoVO vo) throws Exception {
        return fileBoxInfoDAO.listFileBoxFileInfo(vo);
    }

    /***************************************************** 
     * 자신의 파일함 여부 카운트
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int countUserFileBoxCd(FileBoxInfoVO vo) throws Exception {
        return fileBoxInfoDAO.countUserFileBoxCd(vo);
    }

    /***************************************************** 
     * 파일박스 폴더 정보 가져오기
     * @param vo
     * @return FileBoxInfoVO
     * @throws Exception
     ******************************************************/
    @Override
    public FileBoxInfoVO selectFileBox(FileBoxInfoVO vo) throws Exception {
        return fileBoxInfoDAO.selectFileBox(vo);
    }

    /*****************************************************
     * <p>
     *선택한 폴더의 full경로를 조회한다.
     * <p>
     * 최상위 폴더에서 자신의 폴더까지 경로.
     *
     * @param vo
     * @return List<String>
     * @throws Exception
     ******************************************************/
    @Override
    public List<String> getFullFolderPath(FileBoxInfoVO vo) throws Exception {
        return fileBoxInfoDAO.listFullFolderPath(vo);
    }
}
