package knou.lms.file.web;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.ServletContextAware;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import devpia.dextuploadnj.CompressUtil;
import devpia.dextuploadnj.FileItem;
import devpia.dextuploadnj.support.spring.DEXTUploadNJFileDownloadView;

import knou.lms.file.vo.DataUpEntityVO;
import knou.lms.file.vo.DataUpRepository;
import knou.lms.file.vo.FileUpEntityVO;
import knou.lms.file.vo.FileUpRepository;

@Controller
public class FileServiceController implements ServletContextAware {

    private ServletContext servletContext;

    @Override
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    @RequestMapping(value = {"/service/common-upload.do", "/service/upload-oraf.do"}, method = RequestMethod.POST)
    public void commonupload(DEXTUploadX5Request x5, HttpServletResponse response) throws IOException {

        /*
         * DEXTUploadX5Request 클래스는 제품 라이브러리에 포함된 클래스가 아니며, 
         * Spring 모델 바인딩 기능에 의해 DEXTUploadX5로부터 전달되는 폼 정보를 나타내기 위한 예시용 VO 클래스이다.
        */
        FileItem item = null;
        StringBuffer sb = new StringBuffer();

        for(MultipartFile file : x5.getDEXTUploadX5_FileData()) {

            item = (FileItem)file;

            if(item.isEmpty() == false) {

                // 대상이 올바른 파일이라면 실제 저장할 위치로 임시 파일을 저장(복사 혹은 이동)한다.
                // 인자로 주어진 디렉터리 경로가 없다면 Environment#setDefaultRepository 메소드로 설정된 경로로 저장된다.
                item.save();

                // 저장된 파일의 위치를 응답 데이터 버퍼에 기록하여 업로드가 잘 됐는지 확인할 수 있도록 한다.
                sb.append(String.format("F:%1$s\n", item.getFilename()));
            }
        }
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");
        response.getWriter().write(sb.toString());
    }

    @RequestMapping(value = "/service/metadata-upload.do", method = RequestMethod.POST)
    public void metaupload(DEXTUploadX5Request x5, HttpServletResponse response) throws IOException {       

        FileItem file = null;
        String form = null;
        StringBuffer sb = new StringBuffer();

        List<MultipartFile> items = x5.getDEXTUploadX5_FileData();
        List<String> metadata = x5.getDEXTUploadX5_MetaData();

        for(int i=0, len=items.size(); i<len; i++) {

            file = (FileItem)items.get(i);
            form = metadata.get(i);

            if(file.isEmpty() == false) {
                file.save();

                sb.append(String.format("F:%1$s, M:%2$s\n", file.getFilename(), form));
            }
        }

        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");
        response.getWriter().write(sb.toString());
    }

    @RequestMapping(value = "/service/upload-orof.do", method = RequestMethod.POST)
    public void uploadorof(DEXTUploadX5Request x5, HttpServletResponse response) throws IOException {

        FileItem file = (FileItem)x5.getDEXTUploadX5_FileData().get(0);

        if(file.isEmpty() == false) {
            file.save();
            response.setCharacterEncoding("UTF-8");
            response.setContentType("text/plain");
            response.getWriter().write(String.format("F:%1$s", file.getFilename()));
        } else {
            response.setCharacterEncoding("UTF-8");
            response.setContentType("text/plain");
            response.getWriter().write(String.format("X:No file"));
        }
    }

    @RequestMapping(value = "/service/upload-file.do", method = RequestMethod.POST)
    public void uploadfile(DEXTUploadX5Request x5, HttpServletResponse response) throws IOException {

        FileItem item = null;
        StringBuffer sb = new StringBuffer();

        for(MultipartFile next : x5.getDEXTUploadX5_FileData()) {

            item = (FileItem)next;

            if(item.isEmpty() == false) {

                item.save();

                /*
                 * FileUpEntityVO, FileUpRepository 클래스는 DEXTUploadNJ 컴포넌트에서 포함된 클래스가 아니다. 
                 * 파일을 압축하고 압축된 파일을 다운로드 하는 과정의 이해를 돕기 위해 사용되었다.
                */
                FileUpEntityVO file = new FileUpEntityVO();
                file.setFieldName(item.getFieldName());
                file.setFilename(item.getFilename());
                file.setMime(item.getContentType());
                file.setSize(item.getFileSize());
                file.setFile(new File(item.getLastSavedFilePath()));

                // 파일 정보를 DB에 등록했다고 가정하고 키값을 반환한다.
                String key = FileUpRepository.addFileEntity(file);

                sb.append(String.format("%1$s;", key));
            }
        }

        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");
        response.getWriter().write(sb.toString());
    }

    @RequestMapping(value = "/service/multiple-upload.do", method = RequestMethod.POST)
    public void multipleupload(DEXTUploadX5Request x5, HttpServletResponse response) throws IOException {

        FileItem file = null;
        String ctr = null;
        String fid = null;
        StringBuffer sb = new StringBuffer();

        List<MultipartFile> items = x5.getDEXTUploadX5_FileData();
        List<String> controls = x5.getDEXTUploadX5_ControlId();
        List<String> ids = x5.getDEXTUploadX5_UniqueId();

        for(int i=0, len=items.size(); i<len; i++) {

            file = (FileItem)items.get(i);
            ctr = controls.get(i);
            fid = ids.get(i);

            if(file.isEmpty() == false) {
                file.save();

                sb.append(String.format("%1$s|%2$s|%3$s\n", ctr, fid, file.getFilename()));
            }
        }

        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");
        response.getWriter().write(sb.toString());
    }

    @RequestMapping(value = "/service/folder-upload.do")
    public void folderupload(DEXTUploadX5Request x5, HttpServletResponse response) throws IOException {     

        FileItem file = null;
        String sub = null;
        File dir = null;
        StringBuffer sb = new StringBuffer();

        List<MultipartFile> items = x5.getDEXTUploadX5_FileData();
        List<String> folders = x5.getDEXTUploadX5_Folder();

        for(int i = 0, len = items.size(); i < len; i++) {
            file = (FileItem)items.get(i);

            if(file.isEmpty()) {
                continue;
            }

            sub = folders.get(i);

            // 디렉터리(폴더) 정보를 포함하여 저장될 경로를 얻는다.
            dir = new File(file.getEnviroment().getDefaultRepository(), sub);

            // 폴더 구조를 생성한다.
            if(dir.exists() == false) {
                dir.mkdirs();
            }
            // 대상 폴더로 저장한다.
            file.save(dir.getCanonicalPath());
            sb.append(String.format("F:%1$s\n", file.getLastSavedFilePath()));
        }

        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");
        response.getWriter().write(sb.toString());
    }

    @RequestMapping(value = "/service/exif-upload.do")
    public void exifupload(DEXTUploadX5Request x5, HttpServletResponse response) throws IOException {

        FileItem file = null;
        String form = null;
        String[] tokens = null;
        StringBuffer sb = new StringBuffer();
        StringBuffer exif = new StringBuffer();

        List<MultipartFile> items = x5.getDEXTUploadX5_FileData();
        List<String> exifs = x5.getDEXTUploadX5_EXIFData();

        for(int i=0, len= items.size(); i<len; i++) {

            file = (FileItem)items.get(i);
            form = exifs.get(i);

            if(file.isEmpty() == false) {
                file.save();

                tokens = form.split("\\[SPLT\\]");

                exif.delete(0, exif.length());
                for(int k=0, klen=tokens.length; (k + 1)<klen; k+=2) {
                    exif.append(String.format("%1$s:%2$s\n", tokens[k], tokens[k + 1]));
                }
                sb.append(String.format("F:%1$s\n%2$s\n", file.getLastSavedFilename(), exif.toString()));
            }
        }

        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");
        response.getWriter().write(sb.toString());
    }

    @RequestMapping(value = "/service/common-download.do")
    public ModelAndView commondownload(@RequestParam(value = "key") String key, HttpServletRequest request, HttpServletResponse response) throws IOException {

        File target = null;
        String fileRoot = servletContext.getRealPath("/files/attach");

        if(key.equals("FID0001")) {
            target = new File(fileRoot, "서강대교_509147.jpg");
        } else if(key.equals("FID0002")) {
            target = new File(fileRoot, "우도해변_239826.jpg");
        } else if(key.equals("FID0003")) {
            target = new File(fileRoot, "코스모스 (빈공간) 195779.jpg");
        }

        // 인코딩을 UTF-8로 설정한다.
        response.setCharacterEncoding("UTF-8");

        if (target == null  || target.exists() == false || target.isFile() == false) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "주어진 키에 해당하는 파일 정보가 없습니다.");

            return null;
        } else {
            DEXTUploadNJFileDownloadView dextnj = new DEXTUploadNJFileDownloadView(target);
            if (request.getHeader("User-Agent").indexOf("DEXTUploadX5") >= 0) {
                dextnj.setAllowingWeakRange(true);
            } else {
                dextnj.setUseClientCache(false);
            }

            return new ModelAndView(dextnj);
        }
    }
    
    @RequestMapping(value = "/service/common-open.do")
    public ModelAndView commonopen(@RequestParam(value = "key") String key, HttpServletResponse response) throws IOException {

        File target = null;
        String fileRoot = servletContext.getRealPath("/files/attach");

        if(key.equals("FID0001")) {
            target = new File(fileRoot, "서강대교_509147.jpg");
        } else if(key.equals("FID0002")) {
            target = new File(fileRoot, "우도해변_239826.jpg");
        } else if(key.equals("FID0003")) {
            target = new File(fileRoot, "코스모스 (빈공간) 195779.jpg");
        }

        // 인코딩을 UTF-8로 설정한다.
        response.setCharacterEncoding("UTF-8");

        if(target == null  || target.exists() == false || target.isFile() == false) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "주어진 키에 해당하는 파일 정보가 없습니다.");

            return null;
        } else {
            DEXTUploadNJFileDownloadView dextnj = new DEXTUploadNJFileDownloadView(target);
            dextnj.setMime("image/jpg");
            dextnj.setInline(true);

            return new ModelAndView(dextnj);
        }
    }

    @RequestMapping(value = "/service/compress.do", method = RequestMethod.POST)
    public void makeCompressedFile(@RequestParam(value = "DEXTUploadX5_VIndexes") String vindices, HttpServletRequest request, HttpServletResponse response) throws IOException {

        String fileRoot = servletContext.getRealPath("/files");

        List<File> files = new ArrayList<File>();
        String[] tokens = vindices.split(",");

        for(int i = 0; i < tokens.length; i++) {
            if(tokens[i].equals("IDX0003")) {
                files.add(new File(fileRoot, "attach/서강대교_509147.jpg"));
            }
            if(tokens[i].equals("IDX0004")) {
                files.add(new File(fileRoot, "attach/우도해변_239826.jpg"));
            }
            if(tokens[i].equals("IDX0005")) {
                files.add(new File(fileRoot, "attach/코스모스 (빈공간) 195779.jpg"));
            }
        }

        // 임시 위치에 압축 파일을 생성한다.
        CompressUtil cu = new CompressUtil();
        File zipped = cu.zip(files, new File(fileRoot, "/temp/"), "UTF-8", false, false);

        FileUpEntityVO target = new FileUpEntityVO();
        target.setMime("application/x-zip-compressed");
        target.setFilename(zipped.getName());
        target.setFile(zipped);
        target.setSize(zipped.length());

        String compresskey = FileUpRepository.addFileEntity(target);

        response.setContentType("text/plain");
        response.getWriter().write(request.getRequestURL().append("?compresskey=".concat(compresskey)).toString());
    }

    @RequestMapping(value = "/service/compress.do", method = RequestMethod.GET)
    public ModelAndView downloadCompressedFile(@RequestParam(value = "compresskey") String key, HttpServletResponse response) throws IOException {

        FileUpEntityVO target = FileUpRepository.getFileEntity(key);

        if (target != null) {
            DEXTUploadNJFileDownloadView dextnj = new DEXTUploadNJFileDownloadView();
            dextnj.setFile(target.getFile());
            dextnj.setCharsetName("UTF-8");
            dextnj.setAllowingWeakRange(false);
            dextnj.setUseClientCache(false);
            dextnj.setRemoveAfterDownloading(true);
            return new ModelAndView(dextnj);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "주어진 키에 해당하는 파일 정보가 없습니다.");
            return null;
        }
    }

    @RequestMapping(value = "/service/hdevent.do")
    public void hdevent(@RequestParam(value = "action") String action, @RequestParam(value = "key") String key) throws IOException {

        // 테스트를 위해 표준 출력으로 요청 내역을 출력한다.
        System.out.println(String.format("Action: %s, Key: %s", action, key));
    }
}
