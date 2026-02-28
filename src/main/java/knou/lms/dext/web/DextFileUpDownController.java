package knou.lms.dext.web;

import devpia.dextuploadnj.Environment;
import devpia.dextuploadnj.FileItem;
import devpia.dextuploadnj.media.ImageTool;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ZipUtil;
import knou.lms.api.service.ApiService;
import knou.lms.api.vo.ZipcontentUploadVO;
import knou.lms.common.service.SysFileService;
import knou.lms.file.web.DEXTUploadX5Request;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.io.File;
import java.util.Arrays;
import java.util.Base64;


@EnableWebMvc
@Controller
@RequestMapping(value="/dext")
public class DextFileUpDownController extends ControllerBase {

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="apiService")
    private ApiService apiService;

    /***************************************************** 
     * 일반 파일 업로드(덱스트)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileVO>
     * @throws Exception
     ******************************************************/
    @SuppressWarnings("unchecked")
    @RequestMapping(value={"/uploadFileDext.up"})
    public void uploadFileDext(DEXTUploadX5Request x5,
                               HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {

        Environment env = new Environment();
        FileItem item = null;
        JSONArray arr = new JSONArray();

        // 파일저장경로
        String path = StringUtil.nvl(request.getParameter("path"));

        // 업로드파일 저장시 파일저장명 FILE_SAVE_NM
        String fileId = request.getParameter("fileId");
        String fileArray[] = fileId.split(",");

        // 웹 경로_webdata path
        String dataPath = CommConst.WEBDATA_PATH;

        // type // PRACTICE
        String type = StringUtil.nvl(request.getParameter("type"));

        // 업로드 금지 확장자
        String[] noExts = CommConst.UPLOAD_NO_EXTS;

        // 경로 위변조 방지
        if(path.indexOf("..") > -1) {
        }

        if(!dataPath.equals("") && (dataPath.substring(dataPath.length() - 1).equals("/") || dataPath.substring(dataPath.length() - 1).equals("\\"))) {
            dataPath = dataPath.substring(0, dataPath.length() - 1);
        }

        // 경로 마지막에 / 추가!
        path = path.replace("/\\/g", "/");
        if(!path.equals("") && !path.substring(0, 1).equals("/")) {
            path = "/" + path;
        }
        if(!path.equals("") && !path.substring(path.length() - 1).equals("/")) {
            path += "/";
        }

        // 파일 저장시 업로드 경로
        String uploadPath = dataPath + path;

        int i = 0;
        if(x5.getDEXTUploadX5_FileData().size() > 0) {
            for(MultipartFile file : x5.getDEXTUploadX5_FileData()) {

                // DEXTUploadNJMultipartFile
                item = (FileItem) file;

                if(item.isEmpty() == false) {

                    String fileName = item.getFilename();

                    // 파일 확장자
                    String fileExt = FileUtil.getFileExtention(fileName);

                    if(!Arrays.asList(noExts).contains(fileExt)) {

                        // 디렉토리 생성
                        FileUtil.setDirectory(uploadPath);
                        env.setAutoMakingDirectory(true);

                        // 저장되는 파일명
                        String saveFolder = uploadPath;
                        String saveFile = fileArray[i] + "." + fileExt;

                        // 파일저장
                        item.saveAs(saveFolder, saveFile);

                        // 실기과제 제출인 경우 이미지, PDF 썸네일 이미지 생성
                        if("PRACTICE".equals(type) && path.indexOf("/asmt/") > -1) {
                            boolean isImage = ImageTool.isImage(item.getLastSavedFilePath());

                            // 이미지 썸네일 생성 (20M이하만 변환)
                            if(isImage && saveFile.length() < 20 * 1024 * 1024) {
                                File svFile = new File(item.getLastSavedFilePath());
                                boolean result = saveThumbnail(svFile, fileId + "_thumb." + fileExt, 300, 300);
                            }
                        }
                    }

                    JSONObject obj = new JSONObject();
                    obj.put("fileId", fileArray[i]);
                    obj.put("fileNm", item.getFilename());
                    obj.put("fileSize", item.getFileSize());
                    // obj.put("path", path);
                    arr.add(obj);
                }
                i++;
            }
        }

        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");
        response.getWriter().write(arr.toJSONString());

        // System.out.println("arr.toJSONString() :::"+arr.toJSONString());
    }

    /***************************************************** 
     * 대용량 파일 업로드(덱스트)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileVO>
     * @throws Exception
     ******************************************************/
    @SuppressWarnings("unchecked")
    @RequestMapping(value={"/uploadBulkFileDexts.up"}, method=RequestMethod.POST)
    public void uploadBulkFileDexts(DEXTUploadX5Request x5,
                                    MultipartFile file, HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {

        Environment env = new Environment();
        FileItem item = null;
        JSONArray arr = new JSONArray();

        // 파일저장경로
        String path = StringUtil.nvl(request.getParameter("path"));
        String itemIndexStr = StringUtil.nvl(request.getParameter("itemIndex"), "0");
        int itemIndex = Integer.valueOf(itemIndexStr);

        // 업로드파일 저장시 파일저장명 FILE_SAVE_NM
        String fileId = request.getParameter("fileId");
        String fileArray[] = fileId.split(",");

        // 웹 경로_webdata path
        String dataPath = CommConst.WEBDATA_PATH;

        // 업로드 금지 확장자
        String[] noExts = CommConst.UPLOAD_NO_EXTS;
        ;

        // 경로 위변조 방지
        if(path.indexOf("..") > -1) {
        }

        if(!dataPath.equals("") && (dataPath.substring(dataPath.length() - 1).equals("/") || dataPath.substring(dataPath.length() - 1).equals("\\"))) {
            dataPath = dataPath.substring(0, dataPath.length() - 1);
        }

        // 경로 마지막에 / 추가!
        path = path.replace("/\\/g", "/");
        if(!path.equals("") && !path.substring(0, 1).equals("/")) {
            path = "/" + path;
        }
        if(!path.equals("") && !path.substring(path.length() - 1).equals("/")) {
            path += "/";
        }

        // 파일 저장시 업로드 경로
        String uploadPath = dataPath + path;

        if(x5.getDEXTUploadX5_FileData().size() > 0) {
            for(MultipartFile next : x5.getDEXTUploadX5_FileData()) {

                // DEXTUploadNJMultipartFile
                item = (FileItem) next;

                if(item.isEmpty() == false) {

                    String fileName = item.getFilename();

                    // 파일 확장자
                    String fileExt = FileUtil.getFileExtention(fileName);

                    if(!Arrays.asList(noExts).contains(fileExt)) {

                        // 디렉토리 생성
                        FileUtil.setDirectory(uploadPath);
                        env.setAutoMakingDirectory(true);

                        // 저장되는 파일명
                        String saveFolder = uploadPath;
                        String saveFile = fileArray[itemIndex] + "." + fileExt;

                        // 파일저장
                        item.saveAs(saveFolder, saveFile);
                    }

                    JSONObject obj = new JSONObject();
                    obj.put("fileId", fileArray[itemIndex]);
                    obj.put("fileNm", item.getFilename());
                    obj.put("fileSize", item.getFileSize());
                    // obj.put("path", path);
                    arr.add(obj);
                }
            }
        }

        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");
        response.getWriter().write(arr.toJSONString());

        // System.out.println("arr.toJSONString() :::"+arr.toJSONString());
    }


    // 썸네일 이미지 저장
    private boolean saveThumbnail(File saveFile, String thumbFileName, int width, int height) {
        boolean result = false;

        try {
            System.out.println("Image thubmail convert start --> " + saveFile.getPath());

            ImageTool oimg = ImageTool.getInstance(saveFile);
            ImageTool dimg = oimg.resizeUniform(width, height, RenderingHints.VALUE_INTERPOLATION_BILINEAR, true);

            File svFile = new File(saveFile.getParent() + "/" + thumbFileName);
            dimg.save(svFile, oimg.getFormat());

            result = true;

        } catch(Exception e) {
            System.out.println(e.toString());
        } finally {

        }
        return result;
    }


    /**
     * 콘텐츠 ZIP 파일 업로드(Dext 업로드 적용 API)
     *
     * @param multiRequest
     * @param request
     * @param response
     * @param modelMap
     * @return
     */
    @RequestMapping(value="/zipContentUploadDext.up")
    public void zipContentUploadDext(DEXTUploadX5Request x5, HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {
        String uploadPath = "";

        try {
            FileItem item = null;
            String userId = StringUtil.nvl(request.getParameter("pId"));
            String path = StringUtil.nvl(request.getParameter("path"));
            String dataPath = CommConst.WEBDATA_PATH;

            userId = new String(Base64.getDecoder().decode(userId));

            if(!dataPath.equals("") && (dataPath.substring(dataPath.length() - 1).equals("/")
                    || dataPath.substring(dataPath.length() - 1).equals("\\"))) {

                dataPath = dataPath.substring(0, dataPath.length() - 1);
            }

            path = path.replace("/\\/g", "/");
            if(!path.equals("") && !path.substring(0, 1).equals("/")) {
                path = "/" + path;
            }

            if(!path.equals("") && !path.substring(path.length() - 1).equals("/")) {
                path += "/";
            }

            uploadPath = dataPath + "/hycuso" + path;

            if(x5.getDEXTUploadX5_FileData().size() > 0) {
                File upPath = new File(uploadPath);

                if(upPath.exists()) {
                    // 기존폴더 삭제하지 않는것으로 변경
                    //FileUtil.delDirectory(uploadPath);
                }

                long uploadSize = 0;

                for(MultipartFile file : x5.getDEXTUploadX5_FileData()) {
                    item = (FileItem) file;

                    if(item.isEmpty() == false) {
                        FileUtil.setDirectory(uploadPath);
                        uploadSize = item.getFileSize();

                        // 파일저장
                        item.saveAs(uploadPath, item.getFilename());

                        File saveFile = new File(uploadPath, item.getFilename());
                        ZipUtil zipUtil = new ZipUtil();
                        zipUtil.unzip(saveFile);

                        // 압축푼 후 파일 삭제
                        saveFile.delete();

                        String params[] = path.substring(1).split("/");
                        String week = Integer.parseInt(params[params.length - 2]) + "";
                        String pageSeq = Integer.parseInt(params[params.length - 1]) + "";

                        ZipcontentUploadVO uploadVO = new ZipcontentUploadVO();
                        uploadVO.setZipcontentLogSn(IdGenerator.getNewId("ZPUP"));
                        uploadVO.setRgtrId(userId);
                        uploadVO.setCurriCode(params[1]);
                        uploadVO.setWeek(week);
                        uploadVO.setPageSeq(pageSeq);
                        uploadVO.setUploadSize(uploadSize);
                        uploadVO.setUploadPath(path);
                        uploadVO.setUploadFileNm(item.getFilename());

                        // 로그기록
                        apiService.insertZipcontUploadLog(uploadVO);
                    }
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}
