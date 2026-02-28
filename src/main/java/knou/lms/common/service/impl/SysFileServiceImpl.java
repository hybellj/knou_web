package knou.lms.common.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import javax.activation.MimetypesFileTypeMap;
import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.SerializationUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.util.ConvertToHtml;
import knou.framework.util.FileUtil;
import knou.framework.util.RandomStringUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.dao.SysFileDAO;
import knou.lms.common.dao.SysFileRepoDAO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.common.vo.SysFileRepoVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service("sysFileService")
public class SysFileServiceImpl extends ServiceBase implements SysFileService {

    protected final Log log = LogFactory.getLog(getClass());

    @Resource(name="sysFileDAO")
    private SysFileDAO sysFileDAO;

    @Resource(name="sysFileRepoDAO")
    private SysFileRepoDAO sysFileRepoDAO;

    /**
     * 파일에 대한 정보를 받아서 저장을 위한 랜덤 파일이름을 지정하고 DB에 저장한다.
     *
     * @param vo
     * @return FileVO
     */
    public FileVO addFile(FileVO vo) throws Exception {

        SysFileRepoVO sfrvo = new SysFileRepoVO();
        sfrvo.setRepoCd(StringUtil.nvl(vo.getRepoCd())); // getRepoCd 값이 LECTURE_SCRIPT 인데 TB_SYS_FILE_REPO 에 존재하지 않음.
        sfrvo = sysFileRepoDAO.select(sfrvo);
        String repoPath = sfrvo.getRepoDfltPath();

        // 임시 orgId
        String orgId = CommConst.LOGIN_ORGID;
        if("orgId".equals(orgId)) {
            orgId = "ORG0000001";
        }
        FileVO fvo = new FileVO();
        fvo.setHits(0);

        // 임시 fileType
        fvo.setFileType("file");
        fvo.setRepoPath(repoPath);
        fvo.setOrgId(orgId);
        fvo.setRepoCd(StringUtil.nvl(vo.getRepoCd()));
        fvo.setFilePath(StringUtil.nvl(vo.getFilePath()));
        fvo.setFileBindDataSn(StringUtil.nvl(vo.getFileBindDataSn()));
        fvo.setRgtrId(StringUtil.nvl(vo.getRgtrId()));

        List<FileVO> upFileList = FileUtil.getUploadFileList(vo.getUploadFiles());
        List<FileVO> copyFileList = FileUtil.copyFromFilebox(vo.getCopyFiles(), StringUtil.nvl(vo.getFilePath()));
        List<FileVO> fileList = new ArrayList<FileVO>();
        fileList.addAll(upFileList);
        fileList.addAll(copyFileList);
        List<FileVO> uploadedFileList = new ArrayList<>();

        for(FileVO FileVO : fileList) {
            fvo.setFileNm(FileVO.getFileNm());
            fvo.setFileSize(FileVO.getFileSize());
            String fileName = StringUtil.nvl(fvo.getFileNm());

            if(fileName != null && !"".equals(fileName)) {
                String[] fileNames = fileName.split("\\.");
                List<String> fileNameList = new ArrayList<>();
                for(String name : fileNames) {
                    if(!"".equals(name)) {
                        fileNameList.add(name);
                    }
                }
                fileName = String.join(".", fileNameList);
                fileName = fileName.replaceAll("/", "");
                fileName = fileName.replaceAll("\\\\", "");
                fileName = fileName.replaceAll("[.]{2}", "");
                fileName = fileName.replaceAll("&", "");
                fileName = fileName.replaceAll("%", "");
            }

            String fileExt = StringUtil.getExtNoneDot(fileName).toLowerCase();
            if("copy".equals(StringUtil.nvl(vo.getSubParam()))) {
                String fileSaveNm = RandomStringUtil.getRandomMD5() + "." + fileExt;
                fvo.setFileSaveNm(fileSaveNm);
            } else {
                fvo.setFileSaveNm(FileVO.getFileSaveNm() + "." + fileExt);
            }

            fvo.setFileExt(fileExt);
            fvo.setFileNm(fileName);

            // 파일이름으로 파일의 mime을 가져온다. (파일을 뽑은 뒤에는 파일에서 추출할 수 있는건지 확인.)
            // 2016.05.20 jdk1.7에서의 오류 확인 모든 리튼을 application/octet-stream을 반환하고 있다.
            fvo.setMimeType(new MimetypesFileTypeMap().getContentType(vo.getFileNm()));

            // 파일의 MIME타입을 강제로 설정.
            if(fvo.getFileExt().toLowerCase().equals("png")) {

                fvo.setMimeType("image/png");
            } else if(fvo.getFileExt().toLowerCase().equals("jpg")
                    || fvo.getFileExt().toLowerCase().equals("jpeg")
                    || fvo.getFileExt().toLowerCase().equals("jpe")) {

                fvo.setMimeType("image/jpeg");
            } else if(fvo.getFileExt().toLowerCase().equals("gif")) {

                fvo.setMimeType("image/gif");
            } else if(fvo.getFileExt().toLowerCase().equals("tiff")
                    || fvo.getFileExt().toLowerCase().equals("tif")) {

                fvo.setMimeType("image/tiff");
            } else if(fvo.getFileExt().toLowerCase().equals("bmp")) {

                fvo.setMimeType("image/bmp");
            }

            String fileSn = getNewFileSn(); // -- 파일키를 생성한다.
            fvo.setFileSn(fileSn);
            sysFileDAO.insert(fvo); // 파일을 DB에 저장

            uploadedFileList.add(SerializationUtils.clone(fvo));
        }
        fvo.setFileList(uploadedFileList);

        return fvo;
    }

    /**
     * 파일 정보 조회. 조회에 대한 정보를 업데이트 할지 결정할 수 있다.
     *
     * @param vo
     * @param updateEnabled
     * @return
     */
    @Override
    public FileVO getFile(FileVO vo, boolean updateEnabled) throws Exception {

        Assert.notNull(vo, "파일 정보가 없습니다.");
        Assert.notNull(vo.getFileSn(), "파일의 주키 정보는 필수값입니다.");

        FileVO resultFile = sysFileDAO.select(vo);
        if(resultFile != null && updateEnabled) {
            // 파일 접근 정보 갱신
            sysFileDAO.updateFileLastInqDttm(vo);
        }
        return resultFile;
    }

    /**
     * 파일정보 조회. 카운트 정보 업데이트 여부를 true로 설정해서 조회한다.
     *
     * @param vo
     */
    @Override
    public FileVO getFile(FileVO vo) throws Exception {
        return getFile(vo, true);
    }

    /**
     * 파일리포지토리에서 조건에 일치하는 파일 목록을 일괄 조회한다.
     *
     * @param vo : repoCd, fileBindDataSn 항목으로 조회할 경우 해당 자료에 연결된 파일 목록을 반환한다.
     * @return
     */
    @Override
    public ProcessResultVO<FileVO> list(FileVO vo) throws Exception {

        // 파일 리파지토리의 정보를 검색
        SysFileRepoVO sfrvo = new SysFileRepoVO();
        sfrvo.setRepoCd(vo.getRepoCd());
        sfrvo = sysFileRepoDAO.select(sfrvo);

        ProcessResultVO<FileVO> resultList = new ProcessResultVO<FileVO>();
        if(sfrvo != null) {
        	vo.setParTableNm(sfrvo.getParTableNm());
        	vo.setParFieldNm(sfrvo.getParFieldNm());

        	List<FileVO> fileList = sysFileDAO.list(vo);

        	for(int i = 0; i < fileList.size(); i++) {
        		fileList.get(i).setFileView(CommConst.WEBDATA_CONTEXT + fileList.get(i).getFilePath() + "/" + fileList.get(i).getFileSaveNm());
        	}
        	resultList.setResult(1);
        	resultList.setReturnList(fileList);
        }

        return resultList;
    }

    /**
     * 파일 삭제.
     * <p>
     * 파일정보를 DB에서 먼저 삭제한 뒤. 실제 파일 삭제를 시도한다. 삭제중 오류가 발생하면 DB정보도 롤백된다.
     */
    @Override
    public void removeFile(FileVO vo) throws Exception {
        FileVO fileEntity = sysFileDAO.select(vo);

        SysFileRepoVO sfrvo = new SysFileRepoVO();
        sfrvo.setRepoCd(fileEntity.getRepoCd());
        sysFileDAO.delete(vo);

        String filePath = CommConst.WEBDATA_PATH;
        String fileType = StringUtil.nvl(fileEntity.getFileType()).toLowerCase();

        if("contents".equals(fileType)) {
            filePath = CommConst.CONTENTS_STORAGE_PATH;

        }
        filePath += fileEntity.getSaveFilePath();

        if(!"clone".equals(fileType)) {
            File file = new File(filePath);
            deleteAbsoluteFileExecute(file);
            removeConvertFile(fileEntity);
        }
    }

    /**
     * 실제 물리 파일의 삭제가 가능할 경우 삭제한다.
     *
     * @param file
     */
    private void deleteAbsoluteFileExecute(File file) {

        if(file.exists() && file.canWrite()) {

            System.out.println("file.getAbsolutePath()_===========================================");
            System.out.println("file.getAbsolutePath() :::" + file.getAbsolutePath());
            System.out.println("file.getAbsolutePath()_===========================================");

            log.debug("파일 삭제 > " + file.getAbsolutePath());
            file.delete(); // 파일의 삭제가 가능하다면 삭제.
        }
    }

    /**
     * 파일 삭제.
     * <p>
     * 파일정보를 DB에서 먼저 삭제한 뒤. 실제 파일 삭제를 시도한다.
     * 삭제중 오류가 발생하면 DB정보도 롤백된다.
     */
    @Override
    public void removeFile(String fileSn) throws Exception {

        FileVO fileVO = new FileVO();
        fileVO.setFileSn(fileSn);
        this.removeFile(fileVO);
    }

    /**
     * 인자로 받은 SysFileVO를 복제해서 새로운 SysFileVO를 반환한다.<br>
     * 물리적인 파일을 포함한다.
     *
     * @param vo 복사 대상 SysFileVO
     * @return 복사된 결과 SysFileVO
     * @throws IOException
     */
    @Override
    public FileVO copyFile(FileVO vo) throws Exception {

        if(vo == null) {
            return vo;
        }

        // 파일 정보를 복사하고 그 결과를 저장
        FileVO tSysFileVO;
        /*
        if("TRANSFER".equals(vo.getRepoPath())) {
            tSysFileVO = copyTransferFileInfo(vo);
            return tSysFileVO;
        }
        */

        vo.setSubParam("copy");
        tSysFileVO = this.addFile(vo);

        String storagePath;
        storagePath = CommConst.WEBDATA_PATH;
        if("contents".equals(vo.getFileType())) {
            storagePath = CommConst.FILE_STORAGE_PATH;
        }

        List<FileVO> oldFileLIst = (List<FileVO>) vo.getFileList();
        List<FileVO> fileList = (List<FileVO>) tSysFileVO.getFileList();

        for(int i = 0; i < fileList.size(); i++) {
            String sourceDirectory = storagePath + File.separator + oldFileLIst.get(i).getSaveDirectoryPath();
            String targetDirectory = storagePath + File.separator + fileList.get(i).getSaveDirectoryPath();

            // DB에 정상적으로 저장이 됐으면 파일을 실제로 복사
            if(tSysFileVO.getFileSn() != null) {
                preparePath(targetDirectory); // 경로가 없으면 만든다.

                File sFile = new File(sourceDirectory + File.separator + oldFileLIst.get(i).getFileSaveNm());
                File tFile = new File(targetDirectory + File.separator + fileList.get(i).getFileSaveNm());

                // log.info(sFile + " copy to -> " + tFile);

                // 파일 복사
                FileUtils.copyFile(sFile, tFile);
            }
        }
        return tSysFileVO;
    }

    /**
     * 대상 경로가 없을 경우 생성.
     *
     * @param path
     */
    private void preparePath(String path) {

        if(path != null && !"".equals(path)) {
            path = path.replaceAll("[.]{2}", "");
            path = path.replaceAll("&", "");
            path = path.replaceAll("%", "");
        }
        File savePath = new File(path);
        if(!savePath.exists()) {
            if(!savePath.mkdirs()) {
                log.debug("It did not create the directory.! " + savePath.toString());
            }
        }
    }

    // 파일 DB 저장
    public FileVO insertFileInfo(FileVO vo) throws Exception {
        /*
         * 받아온 VO
         * orgId, repoCd, filePath, fileBindDataSn(연결코드), userId,
         * uploadfiles, copyFiles, copyFileBindDataSn, delFileIds, orginDelYn,
         * audioData, audioFile
         */
        String orgId = StringUtil.nvl(vo.getOrgId());
        String repoCd = StringUtil.nvl(vo.getRepoCd());
        String filePath = StringUtil.nvl(vo.getFilePath());
        String fileBindDataSn = StringUtil.nvl(vo.getFileBindDataSn());
        String userId = StringUtil.nvl(vo.getUserId());

        String uploadFiles = StringUtil.nvl(vo.getUploadFiles()).replaceAll("\\\\", "");
        String copyFiles = StringUtil.nvl(vo.getCopyFiles()).replaceAll("\\\\", "");
        String copyFileBindDataSn = StringUtil.nvl(vo.getCopyFileBindDataSn());
        String[] delFileIds = vo.getDelFileIds();
        String orginDelYn = StringUtil.nvl(vo.getOrginDelYn());
        String audioFile = StringUtil.nvl(vo.getAudioFile());

        // 파일 리파지토리의 정보 조회
        SysFileRepoVO sfrvo = new SysFileRepoVO();
        sfrvo.setRepoCd(repoCd);
        sfrvo = sysFileRepoDAO.select(sfrvo);

        String repoPath = StringUtil.nvl(sfrvo.getRepoDfltPath());

        List<FileVO> fList = new ArrayList<FileVO>();
        List<Path> dList = new ArrayList<Path>();

        // 임시파일 -> DB저장, 랜덤복사, 원본삭제
        if(!"".equals(uploadFiles)) {
            JSONArray fileArray = (JSONArray) JSONSerializer.toJSON(uploadFiles);

            for(int i = 0; i < fileArray.size(); i++) {
                JSONObject fileObj = (JSONObject) fileArray.get(i);

                FileVO fVo = new FileVO();
                String fPath = CommConst.WEBDATA_PATH + filePath + "/";
                String fNm = fileObj.getString("fileNm");
                if(fNm != null && !"".equals(fNm)) {
                    String[] fileNames = fNm.split("\\.");
                    List<String> fileNameList = new ArrayList<>();
                    for(String name : fileNames) {
                        if(!"".equals(name)) {
                            fileNameList.add(name);
                        }
                    }
                    fNm = String.join(".", fileNameList);
                    fNm = fNm.replaceAll("/", "");
                    fNm = fNm.replaceAll("\\\\", "");
                    fNm = fNm.replaceAll("[.]{2}", "");
                    fNm = fNm.replaceAll("&", "");
                    fNm = fNm.replaceAll("%", "");
                }

                // String fExt = StringUtil.getExtNoneDot(fNm).toLowerCase();
                // String fSaveNm = RandomStringUtil.getRandomMD5() + "." + fExt;
                String fExt = FileUtil.getFileExtention(fNm);
                String fSaveNm = fileObj.getString("fileId") + "." + fExt;

                Path file = Paths.get(fPath + fileObj.getString("fileId") + "." + fExt);
                // Path nFile = Paths.get(fPath + fSaveNm);

                // 업로드된 파일의 랜덤이름을 부여하여 복사
                // Files.copy(file, nFile, StandardCopyOption.REPLACE_EXISTING);

                // 과제 제출인 경우 썸네일 이미지가 있는지 체크
                if(filePath.indexOf("/asmt/") > -1) {
                    // 이미지
                    if("jpg".equals(fExt) || "jpeg".equals(fExt) || "png".equals(fExt) || "gif".equals(fExt)) {
                        File thumb = new File(fPath + fileObj.getString("fileId") + "_thumb." + fExt);
                        if(thumb.exists()) {
                            fVo.setThumb(fileObj.getString("fileId") + "_thumb." + fExt);
                        }
                    }
                    // PDF
                    /*
                    else if("pdf".equals(fExt)) {
                        File thumb = new File(fPath + fileObj.getString("fileId") + "_thumb.png");
                        if(thumb.exists()) {
                            fVo.setThumb(fileObj.getString("fileId") + "_thumb.png");
                        }
                    }
                    */
                }

                fVo.setFileSn(getNewFileSn());
                fVo.setFileExt(fExt);
                fVo.setFileNm(fNm);
                fVo.setFileSaveNm(fSaveNm);
                fVo.setFileSize(fileObj.getLong("fileSize"));

                // fVo.setMimeType(Files.probeContentType(nFile));
                fVo.setMimeType(Files.probeContentType(file));
                fVo.setRepoPath(repoPath);
                fVo.setOrgId(orgId);
                fVo.setRepoCd(repoCd);
                fVo.setFilePath(filePath);
                fVo.setFileBindDataSn(fileBindDataSn);
                fVo.setRgtrId(userId);
                fVo.setHits(0);
                fVo.setFileView(CommConst.WEBDATA_CONTEXT + filePath + "/" + fSaveNm);

                fList.add(fVo);
                sysFileDAO.insert(fVo); // 파일정보 DB에 저장
                // dList.add(file); // 삭제를 위해 업로드된 원본파일 PATH 저장
            }
        }

        // 음성파일 -> 랜덤생성, DB저장
        if(!"".equals(audioFile)) {

            FileVO fVo = new FileVO();

            String fPath = CommConst.WEBDATA_PATH + filePath;
            String fExt = StringUtil.getExtNoneDot(vo.getAudioFile()).toLowerCase();
            String fSaveNm = RandomStringUtil.getRandomMD5() + "." + fExt;

            // 파일생성
            File fDir = new File(fPath);
            if(!fDir.exists()) {
                fDir.mkdirs();
            }

            File nFile = new File(fPath, fSaveNm);
            byte[] decodedBytes = Base64.getDecoder().decode(vo.getAudioData());

            nFile.createNewFile();
            FileOutputStream fOut = new FileOutputStream(nFile);
            fOut.write(decodedBytes);
            fOut.flush();
            fOut.close();

            fVo.setFileSn(getNewFileSn());
            fVo.setFileExt(fExt);
            fVo.setFileNm("음성녹음파일_" + new SimpleDateFormat("yyyyMMdd_hhmmss").format(new Date()));
            fVo.setFileSaveNm(fSaveNm);
            fVo.setFileSize(nFile.length());

            fVo.setMimeType(Files.probeContentType(Paths.get(fPath + "/" + fSaveNm)));
            fVo.setRepoPath(repoPath);
            fVo.setOrgId(orgId);
            fVo.setRepoCd(repoCd);
            fVo.setFilePath(filePath);
            fVo.setFileBindDataSn(fileBindDataSn);
            fVo.setRgtrId(userId);
            fVo.setHits(0);
            fVo.setFileView(CommConst.WEBDATA_CONTEXT + filePath + "/" + fSaveNm);

            fList.add(fVo);
            sysFileDAO.insert(fVo); // 파일정보 DB에 저장
        }

        if("Y".equals(orginDelYn)) {
            for(Path dFile : dList) {
                Files.deleteIfExists(dFile);
            }
        }

        // 파일함 -> DB저장, 랜덤복사
        if(!"".equals(copyFiles)) {
            JSONArray fileArray = (JSONArray) JSONSerializer.toJSON(copyFiles);

            for(int i = 0; i < fileArray.size(); i++) {
                JSONObject fileObj = (JSONObject) fileArray.get(i);

                FileVO fVo = new FileVO();

                String fPath = CommConst.WEBDATA_PATH + fileObj.getString("filePath") + "/"; // 파일함 경로
                String nPath = CommConst.WEBDATA_PATH + filePath + "/"; // 파일 저장경로
                String fNm = fileObj.getString("fileNm");
                String fExt = StringUtil.getExtNoneDot(fNm).toLowerCase();
                String fSaveNm = RandomStringUtil.getRandomMD5() + "." + fExt;

                Path file = Paths.get(fPath + fileObj.getString("fileSaveNm"));
                Path nFile = Paths.get(nPath + fSaveNm);

                if(!Files.exists(nFile)) {
                    Files.createDirectories(nFile);
                }

                // 업로드된 파일의 랜덤이름을 부여하여 복사
                Files.copy(file, nFile, StandardCopyOption.REPLACE_EXISTING);

                fVo.setFileSn(getNewFileSn());
                fVo.setFileExt(fExt);
                fVo.setFileNm(fNm);
                fVo.setFileSaveNm(fSaveNm);
                fVo.setFileSize(fileObj.getLong("fileSize"));

                fVo.setMimeType(Files.probeContentType(nFile));
                fVo.setRepoPath(repoPath);
                fVo.setOrgId(orgId);
                fVo.setRepoCd(repoCd);
                fVo.setFilePath(filePath);
                fVo.setFileBindDataSn(fileBindDataSn);
                fVo.setRgtrId(userId);
                fVo.setHits(0);
                fVo.setFileView(CommConst.WEBDATA_CONTEXT + filePath + "/" + fSaveNm);

                fList.add(fVo);
                sysFileDAO.insert(fVo); // 파일정보 DB에 저장
            }
        }

        if(!"".equals(copyFileBindDataSn)) {
            FileVO cVo = new FileVO();
            cVo.setRepoCd(repoCd);
            cVo.setFileBindDataSn(copyFileBindDataSn);

            List<FileVO> gList = sysFileDAO.list(cVo);

            // 이전 파일 중 삭제 파일 제외
            for(FileVO gVo : gList) {
                boolean isChk = true;

                for(String delFileId : delFileIds) {
                    if(gVo.getFileId().equals(delFileId)) {
                        isChk = false;
                    }
                }

                if(isChk) {
                    FileVO fVo = new FileVO();

                    String fPath = CommConst.WEBDATA_PATH + gVo.getFilePath() + "/";
                    String nPath = CommConst.WEBDATA_PATH + filePath + "/";
                    String fExt = gVo.getFileExt();
                    String fSaveNm = RandomStringUtil.getRandomMD5() + "." + fExt;

                    Path file = Paths.get(fPath + gVo.getFileSaveNm());
                    Path nFile = Paths.get(nPath + fSaveNm);

                    if(!Files.exists(nFile)) {
                        Files.createDirectories(nFile);
                    }

                    // 업로드된 파일의 랜덤이름을 부여하여 복사
                    Files.copy(file, nFile, StandardCopyOption.REPLACE_EXISTING);

                    fVo.setFileSn(getNewFileSn());
                    fVo.setFileNm(gVo.getFileNm());
                    fVo.setFileSaveNm(fSaveNm);
                    fVo.setFileExt(fExt);
                    fVo.setFileSize(gVo.getFileSize());

                    fVo.setMimeType(Files.probeContentType(nFile));
                    fVo.setRepoPath(repoPath);
                    fVo.setOrgId(orgId);
                    fVo.setRepoCd(repoCd);
                    fVo.setFilePath(filePath);
                    fVo.setFileBindDataSn(fileBindDataSn);
                    fVo.setRgtrId(userId);
                    fVo.setHits(0);
                    fVo.setFileView(CommConst.WEBDATA_CONTEXT + filePath + "/" + fSaveNm);

                    fList.add(fVo);
                    sysFileDAO.insert(fVo); // 파일정보 DB에 저장
                }
            }
        }

        if(delFileIds.length > 0) {
            List<FileVO> gList = sysFileDAO.list(vo);

            // 이전 파일 중 삭제 파일 제외
            for(FileVO gVo : gList) {
                for(String delFileId : delFileIds) {
                    if(gVo.getFileId().equals(delFileId)) {
                        this.removeFile(gVo);
                    }
                }
            }
        }

        vo.setFileList(fList);
        vo.setRepoPath(repoPath);
        vo.setHits(0);

        return vo;
    }

    public void zipFileDown(String fileDownNm, List<FileVO> list, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String zipFileName = fileDownNm + ".zip";

        response.setHeader("Content-Type", "application/octet-stream");
        response.setHeader("Content-Transfer-Coding", "binary");
        response.setHeader("Pragma", "no-cache;");
        response.setHeader("Expires", "-1;");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + java.net.URLEncoder.encode(zipFileName, "UTF-8").replaceAll("\\+", "%20") + "\";charset=\"UTF-8\"");

        ServletOutputStream binaryOut = response.getOutputStream();

        ZipArchiveOutputStream zos = new ZipArchiveOutputStream(binaryOut);
        zos.setEncoding(Charset.defaultCharset().name());
        FileInputStream fis = null;

        try {
            int length;
            ZipArchiveEntry ze;
            byte[] buf = new byte[8 * 1024];

            String fileNm;

            for(FileVO fileVO : list) {
                String path = CommConst.WEBDATA_PATH + fileVO.getFilePath() + "/" + fileVO.getFileSaveNm();
                path = path.replace("/\\/g", "/");

                File file = new File(path);

                if(!file.isDirectory()) {
                    fileNm = fileVO.getFileNm();

                    ze = new ZipArchiveEntry(fileNm);
                    zos.putArchiveEntry(ze);
                    fis = new FileInputStream(file);
                    while((length = fis.read(buf, 0, buf.length)) >= 0) {
                        zos.write(buf, 0, length);
                    }
                    fis.close();
                    zos.closeArchiveEntry();
                }
            }

            zos.flush();
            zos.close();
            binaryOut.flush();
            binaryOut.close();
        } catch(Exception e) {
        } finally {
            if(fis != null) try {
                fis.close();
            } catch(Exception e) {
            }
            if(zos != null) try {
                zos.flush();
                zos.close();
            } catch(Exception e) {
            }
            if(binaryOut != null) try {
                binaryOut.flush();
                binaryOut.close();
            } catch(Exception e) {
            }
        }
    }

    @Override
    public void copyFileInfoFromOrigin(FileVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String repoCd = vo.getRepoCd();
        String fileBindDataSn = vo.getFileBindDataSn();
        String copyFileSn = vo.getCopyFileSn();
        String copyFileBindDataSn = vo.getCopyFileBindDataSn();
        String rgtrId = vo.getRgtrId();
        String lineNo = vo.getLineNo();

        if(ValidationUtils.isEmpty(orgId)
                || ValidationUtils.isEmpty(repoCd)
                || !(ValidationUtils.isNotEmpty(copyFileSn) || ValidationUtils.isNotEmpty(copyFileBindDataSn))
                || ValidationUtils.isEmpty(rgtrId)) {
            throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
        }

        // 파일 리파지토리의 정보 조회
        SysFileRepoVO sfrvo = new SysFileRepoVO();
        sfrvo.setRepoCd(repoCd);
        sfrvo = sysFileRepoDAO.select(sfrvo);

        if(sfrvo == null) {
            throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
        }

        String fileSn = getNewFileSn();

        FileVO copyFileVO = new FileVO();
        copyFileVO.setOrgId(orgId);
        copyFileVO.setRepoCd(repoCd);
        copyFileVO.setFileSn(fileSn);
        copyFileVO.setFileBindDataSn(fileBindDataSn);
        copyFileVO.setRgtrId(rgtrId);
        copyFileVO.setLineNo(lineNo);

        if(ValidationUtils.isNotEmpty(copyFileSn)) {
            copyFileVO.setCopyFileSn(copyFileSn);
            sysFileDAO.copyFileInfoFromOrigin(copyFileVO);
        } else {
            copyFileVO.setCopyFileBindDataSn(copyFileBindDataSn);
            sysFileDAO.copyFileInfoFromOrigin(copyFileVO);
        }
    }

    private String getNewFileSn() {

        String uuid = UUID.randomUUID().toString();
        String fileSn = System.currentTimeMillis() + (uuid.substring(uuid.length() - 7));
        return fileSn;
    }

    @Override
    public int convertToHtmlViewerFile(FileVO vo) throws Exception {
        // 뷰어 지원 포멧
        //List<String> msOfficeOldFormatList = Arrays.asList("DOC", "DOT", "DOTX", "PPT", "POT", "PPS", "XLS", "XLT");
        //List<String> msOfficeNewFormatList = Arrays.asList("DOCX", "DOCM", "DOTM", "PPTX", "PPTM", "POTX", "POTM", "PPSX",
        //List<String> hwpOldFormatList = Arrays.asList("HWP", "HWT", "HML");
        //List<String> hwpNewFormatList = Arrays.asList("HWPX");
        //List<String> libreOfficeFormatList = Arrays.asList("ODT");
        //List<String> acrobatFormatList = Arrays.asList("PDF");
        //List<String> textFormatList = Arrays.asList("TXT", "XML", "XML", "CSV");
        //List<String> imageFormatList = Arrays.asList("BMP", "GIF", "JPG", "PNG", "TIFF", "WEBP", "JP2", "J2K", "JPC", "J2C");

        int result = 0;

        // 변환대상 포멧
        Set<String> convertExtSet = new HashSet<>(Arrays.asList(CommConst.DOC_CONVERT_EXTS));

        String inputFilePath; // 변환대상 파일 절대경로
        String outputDirPath; // 변환파일 저장 폴더
        String outputFileNm;  // 변환될 파일명

        String fileExt = vo.getFileExt();
        String filePath = vo.getFilePath();
        String fileSaveNm = vo.getFileSaveNm();

        if(fileExt != null && convertExtSet.contains(fileExt.toLowerCase())
                && ValidationUtils.isNotEmpty(filePath)
                && ValidationUtils.isNotEmpty(fileSaveNm)) {

            inputFilePath = CommConst.WEBDATA_PATH + filePath + File.separator + fileSaveNm;
            outputDirPath = CommConst.WEBDATA_PATH + CommConst.DOC_CONVERT_DIR_PATH;
            outputFileNm = CommConst.DOC_CONVERT_FILE_NAME_PREFIX + fileSaveNm;

            Path outputFilePath = Paths.get(outputDirPath + File.separator + outputFileNm);

            // 변환 파일이 없는경우 실행
            if(Files.exists(Paths.get(inputFilePath)) && !Files.exists(outputFilePath)) {
                Path outPathDir = Paths.get(outputDirPath);

                // 변환파일 저장 폴더가 없는경우 생성
                if(!Files.exists(outPathDir)) {
                    Files.createDirectories(outPathDir);
                }

                ConvertToHtml convertToHtml = new ConvertToHtml();
                result = convertToHtml.convertToHtml(inputFilePath, outputDirPath, outputFileNm);
            }
        }

        return result;
    }

    @Override
    public void convertToHtmlViewerFileList(List<FileVO> list) throws Exception {
        for(FileVO fileVO : list) {
            this.convertToHtmlViewerFile(fileVO);
        }
    }

    @Override
    public void removeConvertFile(FileVO vo) throws Exception {
        String filePath = vo.getFilePath();
        String fileSaveNm = vo.getFileSaveNm();

        if(ValidationUtils.isNotEmpty(filePath) && ValidationUtils.isNotEmpty(fileSaveNm)) {
            String outputDirPath = CommConst.WEBDATA_PATH + CommConst.DOC_CONVERT_DIR_PATH;
            String outputFileNm = CommConst.DOC_CONVERT_FILE_NAME_PREFIX + fileSaveNm;

            try(DirectoryStream<Path> stream = Files.newDirectoryStream(Paths.get(outputDirPath))) {
                for(Path convertFilePath : stream) {
                    String convertFileName = convertFilePath.getFileName().toString();
                    if(convertFileName.startsWith(outputFileNm)) {
                        if(Files.isDirectory(convertFilePath)) {
                            FileUtil.delDirectory(convertFilePath.toString());
                        } else {
                            FileUtil.delFile(convertFilePath.toString());
                        }
                    }
                }
            } catch(IOException e) {
                e.printStackTrace();
            }
        }
    }
}
