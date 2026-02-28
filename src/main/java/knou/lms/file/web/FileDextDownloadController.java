package knou.lms.file.web;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import devpia.dextuploadnj.FileItem;
import devpia.dextuploadnj.FileResponseContentDisposition;
import devpia.dextuploadnj.support.spring.DEXTUploadNJDirectoryToZipDownloadView;
import devpia.dextuploadnj.support.spring.DEXTUploadNJFileDownloadView;
import devpia.dextuploadnj.support.spring.DEXTUploadNJFilesToZipDownloadView;
import devpia.dextuploadnj.support.spring.DEXTUploadNJStreamDownloadView;

import knou.lms.file.vo.FileDownEntityVO;
import knou.lms.file.vo.FileDownRepository;

@Controller
public class FileDextDownloadController {   

    @RequestMapping(value = "/download/download-up.do", method = RequestMethod.POST)
    public String upload(
            @RequestParam(value = "file1") MultipartFile file1,
            @RequestParam(value = "inline", required = false) boolean inline) {

        String key = "NONE";

        FileItem item = (FileItem)file1;

        if(item != null && item.isEligibleFile()) {
            item.save();

            FileDownEntityVO entity = new FileDownEntityVO();
            entity.setFieldName(item.getFieldName());
            entity.setOriginalFilename(item.getFilename());
            entity.setFileSize(item.getFileSize());
            entity.setMimeType(item.getContentType());
            entity.setFilePath(item.getLastSavedFilePath());
            
            key = FileDownRepository.addFileEntity(entity);
        }
        return "redirect:/download/view-single.do?key=".concat(key).concat("&inline=").concat(Boolean.toString(inline));
    }
    
    @RequestMapping(value = "/download/view-single.do", method = RequestMethod.GET)
    public ModelAndView viewSingle(
            @RequestParam(value = "key") String key,
            @RequestParam(value = "inline") boolean inline) {

        FileDownEntityVO entity = FileDownRepository.getFileEntity(key);
        ModelAndView mv = new ModelAndView("/download/view-single", "file", entity);
        mv.addObject("file", entity);
        mv.addObject("inline", Boolean.valueOf(inline));

        return mv;
    }

    @RequestMapping(value = "/download/download-get.do", method = RequestMethod.GET)
    public ModelAndView getFile(
            @RequestParam(value = "key") String key,
            @RequestParam(value = "inline") boolean inline) {

        FileDownEntityVO entity = FileDownRepository.getFileEntity(key);

        // 파일을 다운로드 하기 위해서 DEXTUploadNJFileDownloadView 객체를 생성한다.
        DEXTUploadNJFileDownloadView view = new DEXTUploadNJFileDownloadView();

        view.setFile(new File(entity.getFilePath()));   // 파일의 서버 경로
        view.setFilename(entity.getOriginalFilename()); // 다운로드할 파일명
        view.setMime(entity.getMimeType());             // 파일의 MIME 형식 값
        view.setCharsetName("UTF-8");
        view.setContentDisposition(inline ? FileResponseContentDisposition.Inline : FileResponseContentDisposition.AttachmentWithName);

        // ModelAndView 객체의 뷰로 지정하여 반환하면 다운로드가 시작된다.
        return new ModelAndView(view);
    }

    @RequestMapping(value = "/download/download-stream.do", method = RequestMethod.GET)
    public ModelAndView getStream() throws Exception {

        StringBuffer sb = new StringBuffer();
        for(int i = 0; i < 1000; i++) {
            sb.append("0123456789\r\n");
        }

        InputStream is = new ByteArrayInputStream(sb.toString().getBytes("UTF-8"));

        // 스트림 형식으로 다운로드 하기 위해서 DEXTUploadNJStreamDownloadView 객체를 생성한다.
        DEXTUploadNJStreamDownloadView view = new DEXTUploadNJStreamDownloadView();

        // 입력 스트림을 설정한다.
        view.setInputStream(is);
        view.setFilename("stream.txt");
        view.setMime("text/plain");
        view.setCharsetName("UTF-8");

        // 스트림이 자동으로 닫히도록 설정한다.
        view.setAutoClosingStream(true);

        return new ModelAndView(view);
    }

    @Autowired
    private ServletContext context;

    @RequestMapping(value = "/download/download-zip.do", method = RequestMethod.GET)
    public ModelAndView getZip(@RequestParam(value = "type") String type) throws Exception {

        String rootPath = context.getRealPath("/");

        if(type.equals("1")) {

            // 파일 목록으로부터 압축 파일을 생성하고 다운로드를 수행한다.
            List<File> files = new ArrayList<File>();
            files.add(new File(rootPath, "/files/attach/compress/sub_B/코스모스 (빈공간) 195779.jpg"));
            files.add(new File(rootPath, "/files/attach/compress/서강대교_509147.jpg"));
            files.add(new File(rootPath, "/files/attach/compress/우도해변_239826.jpg"));

            DEXTUploadNJFilesToZipDownloadView view = new DEXTUploadNJFilesToZipDownloadView();

            view.setEntries(files);
            view.setCharsetName("UTF-8");

            return new ModelAndView(view);

        } else if(type.equals("2")) {

            // 디렉터리를 압축 파일로 생성하여 다운로드를 수행한다.
            String targetDirPath = new File(rootPath, "/files/attach/compress/").getAbsolutePath();

            DEXTUploadNJDirectoryToZipDownloadView view = new DEXTUploadNJDirectoryToZipDownloadView();

            view.setTargetDirPath(targetDirPath);
            view.setIncludeTargetDirName(true);
            view.setCharsetName("UTF-8");

            return new ModelAndView(view);

        } else {

            throw new Exception("The compress-type parameter is not set."); 
        }
    }

    @RequestMapping(value = "/download/exam-001.do", method = RequestMethod.GET)
    public String exam0001() { return "/download/001"; }

    @RequestMapping(value = "/download/exam-002.do", method = RequestMethod.GET)
    public String exam0002() { return "/download/002"; }

    @RequestMapping(value = "/download/exam-003.do", method = RequestMethod.GET)
    public String exam0003() { return "/download/003"; }

    @RequestMapping(value = "/download/exam-004.do", method = RequestMethod.GET)
    public String exam0004() { return "/download/004"; }

}
