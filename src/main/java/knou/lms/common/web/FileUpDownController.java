package knou.lms.common.web;

import devpia.dextuploadnj.support.spring.DEXTUploadNJFileDownloadView;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.*;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.imgscalr.Scalr;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.*;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.util.*;

/**
 * 파일 업로드/다운로드 Controller
 */
@Controller
@RequestMapping(value="/common")
public class FileUpDownController extends ControllerBase {
    private static Log log = LogFactory.getLog(FileUpDownController.class);

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="attachFileService")
    private AttachFileService attachFileService;

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
     *
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<FileVO>
     * @throws Exception
     */
    @RequestMapping(value = {"/uploadFileCheck.do", "/admUploadFileCheck.do"})
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
            String[] fileTypes = CommConst.EDITOR_FILE_TYPES;

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
                String newFileName = "";
                String url = "";

                if(Arrays.asList(fileTypes).contains(fileExt)) {
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

    /**
     * 첨부파일을 사이냅 서버 문서뷰어로 연다.
     * 화면에서는 atflId만 넘기고, 실제 파일 경로/저장명은 서버에서 다시 조회한다.
     */
    @RequestMapping(value="/synapView.do")
    public String synapView(AtflVO atflVO, HttpServletRequest request, HttpServletResponse response) {
        try {
            // 1. 요청 파라미터에서 첨부파일 ID를 꺼낸다.
            String atflId = getSynapAtflId(atflVO);
            if(ValidationUtils.isEmpty(atflId)) {
                log.error("Synap view error - empty atflId");
                return "redirect:/common/synapViewFail.do";
            }

            // 2. 클라이언트가 보낸 경로를 신뢰하지 않고, DB에서 첨부파일 정보를 다시 조회한다.
            AtflVO param = new AtflVO();
            param.setAtflId(atflId);
            AtflVO fileVO = attachFileService.selectAtfl(param);
            if(fileVO == null) {
                log.error("Synap view error - file metadata not found : " + atflId);
                return "redirect:/common/synapViewFail.do";
            }

            // 3. LMS 서버 기준 실제 파일 경로를 만든다.
            String path = CommConst.WEBDATA_PATH + fileVO.getFilePath();
            path = path.replace('\\', '/').replace("../", "");
            File file = new File(path, fileVO.getFileSavnm());

            if(!file.exists() || file.length() == 0) {
                log.error("Synap view error - file not found : " + file.getAbsolutePath());
                return "redirect:/common/synapViewFail.do";
            }

            String synapBaseUrl = getSynapBaseUrl();
            String fid = ValidationUtils.isNotEmpty(fileVO.getAtflId()) ? fileVO.getAtflId() : fileVO.getFileSavnm();

            /*
             * 운영/AS-IS 방식(jobJson)
             * - 사이냅 서버가 filePath를 직접 읽는다.
             * - LMS 파일 저장소와 사이냅 서버 파일시스템이 같은 경로를 볼 수 있어야 한다.
             */
            // ResponseEntity<String> resp = requestSynapJobJson(synapBaseUrl, fileVO, fid);

            /*
             * 로컬-원격 테스트 방식(jobFile)
             * - LMS가 원본 파일을 multipart로 사이냅 서버에 전송한다.
             * - 로컬 LMS + 개발 사이냅 서버처럼 파일시스템을 공유하지 않는 경우 테스트할 수 있다.
             */
            ResponseEntity<String> resp = requestSynapJobFile(synapBaseUrl, file, fid, StringUtil.nvl(fileVO.getFilenm()));

            if(resp.getStatusCode().is3xxRedirection() && resp.getHeaders().getLocation() != null) {
                return "redirect:" + resp.getHeaders().getLocation().toString();
            }

            if(resp.getStatusCode().is2xxSuccessful() || resp.getStatusCode().is3xxRedirection()) {
                Map<String, Object> resultMap = JsonUtil.jsonToMap(resp.getBody());
                Object viewUrlPath = resultMap.get("viewUrlPath");
                if(viewUrlPath != null && ValidationUtils.isNotEmpty(viewUrlPath.toString())) {
                    return "redirect:" + synapBaseUrl + "/" + viewUrlPath.toString();
                }
            }

            log.error("Synap view error - unexpected response : " + resp.getStatusCode());
            return "redirect:/common/synapViewFail.do";

        } catch(Exception e) {
            log.error("Synap view error : " + e.getMessage());
            return "redirect:/common/synapViewFail.do";
        }
    }

    /**
     * 사이냅 서버 기본 URL을 조합한다.
     */
    private String getSynapBaseUrl() {
        String synapBaseUrl = StringUtil.nvl(CommConst.SYNAP_VIEWER_URL);
        String synapContext = StringUtil.nvl(CommConst.SYNAP_VIEWER_CONTEXT);
        if(synapBaseUrl.endsWith("/")) {
            synapBaseUrl = synapBaseUrl.substring(0, synapBaseUrl.length() - 1);
        }
        if(ValidationUtils.isNotEmpty(synapContext) && !synapContext.startsWith("/")) {
            synapContext = "/" + synapContext;
        }
        return synapBaseUrl + synapContext;
    }

    /**
     * jobJson(Local file) 방식으로 사이냅 변환을 요청한다.
     * 사이냅 서버가 filePath를 직접 읽으므로 파일 저장소가 공유된 환경에서 사용한다.
     */
    private ResponseEntity<String> requestSynapJobJson(String synapBaseUrl, AtflVO fileVO, String fid) throws Exception {
        String filePath = CommConst.WEBDATA_PATH + fileVO.getFilePath() + "/" + URLEncoder.encode(fileVO.getFileSavnm(), "UTF-8");
        filePath = filePath.replace('\\', '/');

        StringBuilder jobUrl = new StringBuilder();
        jobUrl.append(synapBaseUrl).append("/jobJson")
                .append("?fid=").append(URLEncoder.encode(fid, "UTF-8"))
                .append("&filePath=").append(filePath)
                .append("&fileType=Local")
                .append("&convertType=1")
                .append("&title=").append(URLEncoder.encode(StringUtil.nvl(fileVO.getFilenm()), "UTF-8"));

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));

        HttpEntity<String> reqEntity = new HttpEntity<>(headers);
        return restTemplate.exchange(jobUrl.toString(), HttpMethod.GET, reqEntity, String.class);
    }

    /**
     * jobFile 방식으로 사이냅 변환을 요청한다.
     * LMS가 원본 파일을 multipart로 전송하므로 파일 저장소가 공유되지 않은 환경에서 테스트할 수 있다.
     */
    private ResponseEntity<String> requestSynapJobFile(String synapBaseUrl, File file, String fid, String title) {
        String jobUrl = synapBaseUrl + "/jobFile";

        RestTemplate restTemplate = createNoRedirectRestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("file", new FileSystemResource(file));
        body.add("fid", fid);
        body.add("convertType", "1");
        body.add("sync", "true");
        body.add("title", title);
        HttpEntity<MultiValueMap<String, Object>> reqEntity = new HttpEntity<>(body, headers);
        return restTemplate.exchange(jobUrl, HttpMethod.POST, reqEntity, String.class);
    }

    /**
     * 사이냅 뷰어에 사용할 첨부파일 ID를 가져온다.
     * 다운로드용 encParams에는 atflId가 없으므로 사이냅 뷰어는 atflId를 직접 받는다.
     */
    private String getSynapAtflId(AtflVO atflVO) {
        return atflVO == null ? "" : StringUtil.nvl(atflVO.getAtflId());
    }

    /**
     * 사이냅 보기 실패 → 기존 실패 화면 재활용
     */
    @RequestMapping(value="/synapViewFail.do")
    public String synapViewFail(ModelMap model) {
        model.addAttribute("msg_code", "common.file.not_view");
        return "common/doc_view_fail"; // 기존 실패 JSP 재활용 (없으면 common/error_download)
    }

    /**
     * 302 자동 추적을 끈 RestTemplate
     * 기본 RestTemplate 은 302 를 자동으로 따라가 Location 을 못 읽으므로 필수.
     */
    private RestTemplate createNoRedirectRestTemplate() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory() {
            @Override
            protected void prepareConnection(HttpURLConnection connection, String httpMethod) throws IOException {
                super.prepareConnection(connection, httpMethod);
                connection.setInstanceFollowRedirects(false);
            }
        };
        factory.setConnectTimeout(5000);
        factory.setReadTimeout(60000); // 변환 시간 고려
        return new RestTemplate(factory);
    }


    // 썸네일 이미지 저장
    // 참조 boolean result = saveThumbnail(saveFile, fileId+"_thumb."+fileExt, 300, 300);
    private boolean saveThumbnail(File saveFile, String thumbFileName, int width, int height) {
        boolean result = false;
        BufferedImage srcImg = null;
        BufferedImage thumbImg = null;

        try {
            System.out.println("Image thubmail convert start --> " + saveFile.getPath());

            srcImg = ImageIO.read(saveFile);

            if(srcImg.getWidth() < width) {
                width = srcImg.getWidth();
            }
            if(srcImg.getHeight() < height) {
                height = srcImg.getHeight();
            }

            thumbImg = Scalr.resize(srcImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_WIDTH, width);
            if(thumbImg.getHeight() > height) {
                thumbImg = Scalr.resize(thumbImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT, height);
            }

            // 이미지 저장
            String thumbName = saveFile.getParent() + "/" + thumbFileName;
            File thumbFile = new File(thumbName);
            result = ImageIO.write(thumbImg, FileUtil.getFileExtention(saveFile.getName()), thumbFile);
            System.out.println("Image thubmail convert end --> " + saveFile.getPath());

            thumbImg.flush();
            srcImg.flush();

        } catch(Exception e) {
            System.out.println(e.toString());
        } finally {
            if(thumbImg != null) try {
                thumbImg.flush();
            } catch(Exception e2) {
            }
            if(srcImg != null) try {
                srcImg.flush();
            } catch(Exception e2) {
            }
        }
        return result;
    }

    // PDF 썸네일 이미지 저장
    private boolean savePdfThumbnail(File saveFile, String thumbFileName, int width, int height) {
        boolean result = false;
        PDDocument pdfDoc = null;

        try {
            InputStream is = new FileInputStream(saveFile);
            pdfDoc = PDDocument.load(is);
            PDFRenderer pdfRenderer = new PDFRenderer(pdfDoc);

            if(pdfDoc.getPages().getCount() > 0) {
                BufferedImage thumbImg = pdfRenderer.renderImageWithDPI(0, 72, ImageType.RGB);

                if(thumbImg.getWidth() < width) {
                    width = thumbImg.getWidth();
                }
                if(thumbImg.getHeight() < height) {
                    height = thumbImg.getHeight();
                }

                thumbImg = Scalr.resize(thumbImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_WIDTH, width);
                if(thumbImg.getHeight() > height) {
                    thumbImg = Scalr.resize(thumbImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT, height);
                }

                // 이미지 저장
                String thumbName = saveFile.getParent() + "/" + thumbFileName;
                File thumbFile = new File(thumbName);
                result = ImageIO.write(thumbImg, FileUtil.getFileExtention(thumbFile.getName()), thumbFile);
            }
            pdfDoc.close();
        } catch(Exception e) {
            //System.out.println(e.toString());
        } finally {
            if(pdfDoc != null) {
                try {
                    pdfDoc.close();
                } catch(IOException e) {
                }
            }
        }
        return result;
    }
}
