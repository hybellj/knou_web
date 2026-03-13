package knou.lms.common.web;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import devpia.dextuploadnj.support.spring.DEXTUploadNJFileDownloadView;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.CommonUtil;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.vo.AtflVO;


/**
 * 파일 업로드/다운로드 Controller
 */
@Controller
@RequestMapping(value="/common")
public class FileUpDownController extends ControllerBase {
	private static Log log = LogFactory.getLog(FileUpDownController.class);

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    /**
     * 파일 업로드
     *
     * @param multiRequest
     * @param request
     * @param response
     * @param modelMap
     * @return
     */
    @RequestMapping(value="/uploadFile.do")
    public String uploadFile(MultipartHttpServletRequest multiRequest, HttpServletRequest request,
                             HttpServletResponse response, ModelMap modelMap) throws Exception {
        try {
            String path = StringUtil.nvl(request.getParameter("path"));
            String fileId = request.getParameter("fileId");
            String dataPath = CommConst.WEBDATA_PATH;
            //String type = StringUtil.nvl(request.getParameter("type"));

            // 업로드금지 확장자
            String[] noExts = CommConst.UPLOAD_NO_EXTS;

            // 경로 위변조 방지
            if(path.indexOf("..") > -1) {
                return null;
            }

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

            String uploadPath = dataPath + path;
            final Map<String, MultipartFile> fileMap = multiRequest.getFileMap();

            if(!fileMap.isEmpty()) {
                Object[] keys = fileMap.keySet().toArray();
                MultipartFile multiFile = fileMap.get(keys[0]);

                int idx = multiFile.getOriginalFilename().lastIndexOf("\\");
                if(idx == -1) {
                    idx = multiFile.getOriginalFilename().lastIndexOf("/");
                }

                String fileName = multiFile.getOriginalFilename().substring(idx + 1);
                String fileExt = FileUtil.getFileExtention(fileName);

                if(!Arrays.asList(noExts).contains(fileExt)) {
                    FileUtil.setDirectory(uploadPath);
                    File saveFile = new File(uploadPath, fileId + "." + fileExt);
                    multiFile.transferTo(saveFile);
                }
            }
        } catch(Exception e) {
            log.error(e.getMessage());
            throw e;
        }
        return null;
    }


    /**
     * 업로드 파일 체크 (업로드된 파일이 실제로 저장되었는지 체크하고 저장된 파일목록 반환)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileVO>
     * @throws Exception
     */
    @RequestMapping(value="/uploadFileCheck.do")
    @ResponseBody
    public ProcessResultVO<AtflVO> uploadFileCheck(AtflVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<AtflVO> resultVO = new ProcessResultVO<>();

        try {
            String message = "Y";
            List<AtflVO> upFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
            List<AtflVO> fileList = new ArrayList<>();
            fileList.addAll(upFileList);

            for(AtflVO atflVO : fileList) {
                File file = new File(CommConst.WEBDATA_PATH + atflVO.getFilePath() + "/" + atflVO.getFileSavnm());
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
        	log.error(e.getMessage());
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }


    /**
     * 에디터 파일 업로드
     *
     * @param multiRequest
     * @param request
     * @param response
     * @param modelMap
     * @return
     */
    @RequestMapping(value="/editorUpload.do")
    @ResponseBody
    public Map<String, String> editorUpload(MultipartHttpServletRequest multiRequest, HttpServletRequest request,
                                            HttpServletResponse response, ModelMap modelMap) {
        Map<String, String> resultMap = new HashMap<String, String>();

        try {
            String path = StringUtil.nvl(request.getParameter("path"));
            String dataPath = CommConst.EDITOR_DATA_PATH;
            String[] fileTypes   = CommConst.EDITOR_FILE_TYPES;

            // 경로 위변조 방지
            if(path.indexOf("..") > -1) {
                return null;
            }

            if("".equals(path)) {
                path = "/common";
            }

            if(!dataPath.equals("") && (dataPath.substring(dataPath.length() - 1).equals("/")
                    || dataPath.substring(dataPath.length() - 1).equals("\\"))) {

                dataPath = dataPath.substring(0, dataPath.length() - 1);
            }

            path = path.replace("/\\/g", "/");
            if (!path.equals("") && !path.substring(0, 1).equals("/")) {
                path = "/" + path;
            }
            if (!path.equals("") && !path.substring(path.length() - 1).equals("/")) {
                path += "/";
            }

            String uploadPath = dataPath + path;
            final Map<String, MultipartFile> fileMap = multiRequest.getFileMap();

            if (!fileMap.isEmpty()) {
                Object[] keys = fileMap.keySet().toArray();
                MultipartFile multiFile = fileMap.get(keys[0]);

                int idx = multiFile.getOriginalFilename().lastIndexOf("\\");
                if(idx == -1) {
                    idx = multiFile.getOriginalFilename().lastIndexOf("/");
                }

                String fileName = multiFile.getOriginalFilename().substring(idx + 1);
                String fileExt = FileUtil.getFileExtention(fileName);
                String newFileName = "";
                String url = "";

                if (Arrays.asList(fileTypes).contains(fileExt)) {
	                newFileName = IdGenerator.getNewId("EDT") + "." + fileExt;
	                url = CommConst.EDITOR_CONTEXT + path + newFileName;

	                FileUtil.setDirectory(uploadPath);
	                File file = new File(uploadPath, newFileName);
	                multiFile.transferTo(file);

	                resultMap.put("uploadPath", url);
                }
            }
        } catch(Exception e) {
        	log.error(e.getMessage());
        }
        return resultMap;
    }


    /**
     * 파일 다운로드
     *
     * @param request
     * @param response
     * @param modelMap
     * @return
     */
    @RequestMapping(value="/downloadFile.do")
    public ModelAndView downloadFile(AtflVO atflVO, HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {

        // DEXT File Download
        DEXTUploadNJFileDownloadView view = new DEXTUploadNJFileDownloadView();

        String fileName = atflVO.getFilenm();
        String path = CommConst.WEBDATA_PATH + atflVO.getFilePath();
        path = path.replace("/\\/g", "/").replace("../", "");

        String mimeType = CommonUtil.getMimeType(fileName);
        fileName = FileUtil.getDownloadFileName(fileName, request).replaceAll("[`~!@#$%^&*|+=?;:'\",<>]", "");

        try {
            fileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
        } catch(UnsupportedEncodingException e) {
        }

        File file = new File(path, atflVO.getFileSavnm());

        // 파일이 없을경우 추가 체크
        if(!file.exists()) {
            if(fileName.indexOf(".") == -1) {
                boolean exFile = false;
                String ext = fileName.substring(fileName.length() - 3);
                if("hwp".equals(ext) || "pdf".equals(ext) || "ppt".equals(ext) || "doc".equals(ext) || "xls".equals(ext)) {
                    fileName = fileName.substring(0, fileName.length() - 3) + "." + ext;
                    exFile = true;
                } else {
                    ext = fileName.substring(fileName.length() - 4);
                    if("hwpx".equals(ext) || "pptx".equals(ext) || "docx".equals(ext) || "xlsx".equals(ext)) {
                        fileName = fileName.substring(0, fileName.length() - 4) + "." + ext;
                        exFile = true;
                    }
                }
                if(exFile) {
                    if(".".equals(path.substring(path.length() - 1))) {
                        path = path.substring(0, path.length() - 1);
                        path += "." + ext;
                    }

                    path = CommConst.WEBDATA_PATH + path;
                    path = path.replace("/\\/g", "/");

                    mimeType = CommonUtil.getMimeType(fileName);
                    fileName = FileUtil.getDownloadFileName(fileName, request).replaceAll("[`~!@#$%^&*|+=?;:'\",<>]", "");

                    try {
                        fileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
                    } catch(UnsupportedEncodingException e) {
                    }

                    file = new File(path);
                }
            }
        }

        if(file.exists() && file.length() > 0) {
            view.setFile(file);
            view.setFilename(fileName);
            view.setMime(mimeType);
            view.setCharsetName("utf-8");

            // 다운로드 시작
            return new ModelAndView(view);
        } else {
            // 다운로드 오류
        	log.error("File download error...");
            ModelAndView modelAndView = new ModelAndView("common/error_download");
            modelAndView.addObject("msg_code", "common.file.not_download");
            return modelAndView;
        }
    }


    /*****************************************************
     * 파일 다운로드 url 호출
     * @param FileVO
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/fileInfoView.do")
    @ResponseBody
    public String fileInfoView(FileVO vo, ModelMap map, HttpServletRequest request, HttpServletResponse response) throws Exception {
        vo.setUserId(SessionInfo.getUserId(request));
        String downloadUrl = "";

        FileVO fvo = sysFileService.getFile(vo);
        if(fvo != null) {
            downloadUrl = CommConst.CONTEXT_FILE_DOWNLOAD + "?path=" + fvo.getDownloadPath();
        }

        return downloadUrl;
    }

    /**
     * 문서 보기
     *
     * @param request
     * @param response
     * @param modelMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/docView.do")
    public String docView(FileVO vo, HttpServletRequest request, ModelMap model) throws Exception {

        String encFileSn = request.getParameter("encFileSn");
        vo.setDecFileSn(encFileSn);
        String fileSn = vo.getDecFileSn();

        FileVO fileVO = new FileVO();
        fileVO.setFileSn(fileSn);
        fileVO = sysFileService.getFile(fileVO);

        String fileSaveNm = fileVO.getFileSaveNm();

        String outputDirPath = CommConst.WEBDATA_PATH + CommConst.DOC_CONVERT_DIR_PATH;
        String outputFileNm = CommConst.DOC_CONVERT_FILE_NAME_PREFIX + fileSaveNm;

        File xmlFile = new File(outputDirPath + File.separator + outputFileNm + ".xml");
        if(xmlFile.isFile() == false) {
            /*
            try {
                sysFileService.convertToHtmlViewerFile(fileVO);
            } catch (Exception e) {
                e.printStackTrace();

                model.addAttribute("fileVO", fileVO);
                return "common/doc_view_fail";
            }

            xmlFile = new File(outputDirPath + File.separator + outputFileNm + ".xml");
            if(xmlFile.isFile() == false) {
                model.addAttribute("fileVO", fileVO);
                return "common/doc_view_fail";
            }
            */

            model.addAttribute("fileVO", fileVO);
            return "common/doc_convert_proc";
        }

        // 스킨으로 리다이렉트(옵션)
        final String contextPath = CommConst.WEBDATA_CONTEXT + CommConst.DOC_CONVERT_DIR_PATH; // 스킨에서 변환 결과에 접근할 수 있는 경로
        final String retString = String.format("redirect:/webdoc/skin/doc.html?fn=%s&rs=%s", outputFileNm, contextPath);

        return retString;
    }

    /**
     * 문서  변환
     *
     * @param request
     * @param response
     * @param modelMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/docConvert.do", method=RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<FileVO> docConvert(FileVO vo, HttpServletRequest request, ModelMap model) throws Exception {
        ProcessResultVO<FileVO> resultVO = new ProcessResultVO<>();
        String goUrl = "";
        String encFileSn = request.getParameter("encFileSn");
        boolean isConverted = false;

        try {
            vo.setDecFileSn(encFileSn);
            String fileSn = vo.getDecFileSn();

            FileVO fileVO = new FileVO();
            fileVO.setFileSn(fileSn);
            fileVO = sysFileService.getFile(fileVO);

            String fileSaveNm = fileVO.getFileSaveNm();

            String outputDirPath = CommConst.WEBDATA_PATH + CommConst.DOC_CONVERT_DIR_PATH;
            String outputFileNm = CommConst.DOC_CONVERT_FILE_NAME_PREFIX + fileSaveNm;

            File xmlFile = new File(outputDirPath + File.separator + outputFileNm + ".xml");
            if(xmlFile.isFile() == false) {
                try {
                    int convertResult = sysFileService.convertToHtmlViewerFile(fileVO);

                    if(convertResult == 0) {
                        xmlFile = new File(outputDirPath + File.separator + outputFileNm + ".xml");
                        if(xmlFile.isFile() == true) {
                            isConverted = true;
                        }
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                }
            } else {
                isConverted = true;
            }

            if(isConverted) {
                final String contextPath = CommConst.WEBDATA_CONTEXT + CommConst.DOC_CONVERT_DIR_PATH; // 스킨에서 변환 결과에 접근할 수 있는 경로
                goUrl = String.format("/webdoc/skin/doc.html?fn=%s&rs=%s", outputFileNm, contextPath);
            }

            // 스킨으로 리다이렉트(옵션)
            vo.setGoUrl(goUrl);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setReturnVO(vo);
            resultVO.setResult(-1);
        }

        return resultVO;
    }

    /**
     * 문서 변환 실패
     *
     * @param request
     * @param response
     * @param modelMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/docViewFail.do")
    public String docViewFail(FileVO vo, HttpServletRequest request, ModelMap model) throws Exception {
        String encFileSn = request.getParameter("encFileSn");

        if(ValidationUtils.isNotEmpty(encFileSn)) {
            vo.setDecFileSn(encFileSn);
            String fileSn = vo.getDecFileSn();

            FileVO fileVO = new FileVO();
            fileVO.setFileSn(fileSn);
            fileVO = sysFileService.getFile(fileVO);

            model.addAttribute("fileVO", fileVO);
        }

        return "common/doc_view_fail";
    }
}
