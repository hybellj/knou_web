package knou.framework.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.FileChannel;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.activation.MimetypesFileTypeMap;
import javax.servlet.http.HttpServletRequest;

import knou.framework.common.CommConst;
import knou.framework.vo.FileVO;
import knou.framework.vo.UploadFileVO;
import knou.lms.file.vo.AtflVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

/**
 * 파일 유틸리티
 */
public class FileUtil {

    static long result = 0;

    public FileUtil() {

    }

    /**
     * 업로드 디렉토리 세팅
     */
    public static boolean setDirectory( String directory) {
        File wantedDirectory = new File(directory);
        if(wantedDirectory.isDirectory())
            return true;

        return wantedDirectory.mkdirs();
    }

    /**
     * 디렉토리 삭제
     * @param path
     */
    public static void delDirectory(String path) {
        File dirFile = new File(path);
        String[] fileList = dirFile.list();

        String lastStr = "/";
        if(path.lastIndexOf("\\") > -1) {
            lastStr = "\\";
        }
        if(!path.substring(path.length()-1).equals(lastStr)) {
            path += lastStr;
        }

        if(dirFile.exists()) {
            for (int i = 0; i < fileList.length; i++) {
                File subFile = new File(path+fileList[i]);

                if(subFile.isDirectory()) {
                    delDirectory(path+fileList[i]);
                } else {
                    subFile.delete();
                }
            }
            dirFile.delete();
        }
    }

    /**
     * 파일 사이즈 변환 (KB로 표시)
     * @param fileSize
     * @return
     */
    public static String getFileSizeConvertKByte(long fileSize) {
        String iStr = "";
        String fileSizeStr = "";

        if(fileSize == 0) {
            fileSizeStr = "0";
        } else if(fileSize > 0 && fileSize < 1024) {
            fileSizeStr = "1";
        } else {
            fileSize = (long)Math.round(fileSize / 1024.0);
            if(fileSize < 1) {
                fileSize = 1;
            }

            iStr = String.valueOf(fileSize);
            int len = iStr.length();

            if(len > 3) {
                int dNum = len / 3;
                int mNum = len % 3;
                if(mNum > 0) {
                    fileSizeStr = iStr.substring(0,mNum);
                }
                for (int i=0; i<dNum; i++) {
                    int idx = mNum + (i*3);
                    if(i==0 && mNum==0) {
                        fileSizeStr += iStr.substring(idx,idx+3);
                    } else {
                        fileSizeStr += ","+iStr.substring(idx,idx+3);
                    }
                }
            } else {
                fileSizeStr = iStr;
            }
        }
        return fileSizeStr + "KB";
    }

    /**
     * 파일 사이즈 변환 (Byte로 표시)
     * @param fileSize
     * @return
     */
    public static String getFileSizeConvertByte(long fileSize) {
        String fileSizeStr = "";
        String size = fileSize+"";

        while (size.length() > 0) {
            if(size.length() > 3) {
                String a = size.substring(size.length()-3);
                fileSizeStr = "," + a + fileSizeStr;
                size = size.substring(0, size.length()-3);
            } else {
                fileSizeStr = size + fileSizeStr;
                size = "";
            }
        }
        return fileSizeStr + " Byte";
    }

    /**
     * 파일 삭제
     * @param path
     */
    public static void delFile(String path) {
        File delFile = new File(StringUtil.filePatternRemove(path));

        if(delFile.exists()) {
            delFile.delete();
        }
    }

    /**
     *  파일을 삭제해준다.
     * @param path (pull path)
     * @param filename
     */
    public static  void	 delFile(String  path, String filename ) {
        String dir = path +"/"+filename;
        File cFile = new File(dir);
        if(cFile.exists()) cFile.delete();
    }

    /**
     * 데이터 파일 삭제 (첨부파일)
     * @param path
     */
    public static void delDataFile(String path) {
        delFile(CommConst.WEBDATA_PATH + path);
    }

    /**
     * 다운로드용 파일명 가져오기
     * @param fileName
     * @param request
     * @return fileName
     */
    public static String getDownloadFileName(String fileName, HttpServletRequest request) {

        try {
            String browser = CommonUtil.getBrowser(request);
            String agent = request.getHeader("User-Agent");

            if(agent.indexOf("hycuapp") > -1 && (agent.indexOf("iPhone") > -1 || agent.indexOf("iPad") > -1)) {
                browser = "safari";
            }
            if(browser.equals("msie") || browser.equals("trident")) {
                //fileName = URLEncoder.encode(fileName, "utf-8").replaceAll("\\+", "%20");
            } else if(browser.equals("safari")) {
                fileName = new String("KNOU_"+ DateTimeUtil.getCurrentString() + "." + FileUtil.getFileExtention(fileName));
                // fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
            } else {
                // fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return fileName;
    }

    /**
     * 파일을  카피해준다. (풀페스)
     * sourcedir : 원본 파일이 들어가 있는 디렉토리 예) file1/lmcourse
     * targetdir   :   새로 생성할  파일이 들어가 있는 디렉토리 예) file1/lmsystem
     * sourcefilename : 원본 파일명 예) lmcourse_00000000.gif
     * targetfilename : 새로 생성할  파일명 예) lmsystem_00000000.gif
     * @param sourcedir
     * @param targetdir
     * @param sourefilename
     * @param targetfilename
     * @return
     */
    public static boolean fileCopy(String sourcePath, String targetPath){
        // 복사 대상 파일 생성
        File sourceFile = new File(sourcePath);

        // 스트림 체널 선언
        FileInputStream inputStream = null;
        FileOutputStream outputStream = null;
        FileChannel inFileChannel = null;
        FileChannel outFileChannel = null;

        try {
            // 스트림 생성
            inputStream = new FileInputStream(sourceFile);
            outputStream = new FileOutputStream(targetPath);

            // 채널생성
            inFileChannel = inputStream.getChannel();
            outFileChannel = outputStream.getChannel();

            // 채널을 통한 스트림 전송
            long size =  inFileChannel.size();
            inFileChannel.transferTo(0, size, outFileChannel);
            return true;
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            // 자원해제
            try {
                outFileChannel.close();
            } catch(IOException ioe) {}
            try {
                inFileChannel.close();
            } catch(IOException ioe) {}
            try {
                outputStream.close();
            } catch(IOException ioe) {}
            try {
                inputStream.close();
            } catch(IOException ioe) {}
        }
       return false;
    }


    /**
     * 파일 확장명에 따른 이미지 출력 함수
     * @param fname
     * @param fwhere
     * @return
     */
    public static String getFileIcon(String fname, String fwhere) {
        String ext = null;
        String type_img;
        if(!fname.equals("")) {
            ext = getFileExtention(fname);

            if(ext.equals("gz") || ext.equals("zip") || ext.equals("rar") || ext.equals("arj") || ext.equals("lzh") || ext.equals("tar")) {
                type_img   = "compressed";
            } else if(ext.equals("gif") || ext.equals("jpg") || ext.equals("bmp") || ext.equals("pcx") || ext.equals("tif")) {
                type_img   = "image";
            } else if(ext.equals("exe") || ext.equals("com") || ext.equals("dll")) {
                type_img   = "exe";
            } else if(ext.equals("htm") || ext.equals("html")) {
                type_img   = "html";
            } else if(ext.equals("hwp")) {
                type_img   = "hwp";
            } else if(ext.equals("mov") || ext.equals("avi") || ext.equals("mpg") || ext.equals("mpeg")) {
                type_img   = "movie";
            } else if(ext.equals("mp3")) {
                type_img   = "mp3";
            } else if(ext.equals("rm") || ext.equals("ra") || ext.equals("ram")) {
                type_img   = "ra";
            } else if(ext.equals("wav") || ext.equals("mod") || ext.equals("mid")) {
                type_img   = "sound";
            } else if(ext.equals("txt") || ext.equals("log") || ext.equals("dat") || ext.equals("ini")) {
                type_img   = "text";
            } else if(ext.equals("xls") || ext.equals("csv")) {
                type_img   = "excel";
            } else if(ext.equals("doc")) {
                type_img   = "word";
            } else if(ext.equals("ppt")) {
                type_img   = "ppt";
            } else if(ext.equals("rlt")) {
                type_img   = "rlt";
            } else {
                type_img   = "unknown";
            }
            return  fwhere+"common/file_type/"+ type_img + ".gif";
        }        else {
            return "";
        }
    }


    /**
     * 주어진 클래스의 인스턴스를 만들어 반환
     *
     * @param className
     * @return
     */
    public static Object newInstance(String className) {
        Object instance = null;

        ClassLoader loader = FileUtil.class.getClassLoader();
        try {
            //instance = Class.forName(className).newInstance();
            instance = loader.loadClass(className).newInstance();
        } catch(ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
        } catch(IllegalAccessException iae) {
            iae.printStackTrace();
        } catch(InstantiationException ie) {
            ie.printStackTrace();
        }
        return instance;
    }

    /**
     * 파일 확장자를 리턴, 확장자가 없으면 "" 를 리턴
     * @param fileName
     * @return extention
     */
    public static String getFileExtention(String fileName) {
        String ext = "";

        if(fileName != null && !fileName.equals("")) {
            int idx = fileName.lastIndexOf('.');
            if(idx > 0) {
                ext = fileName.substring(idx+1).toLowerCase();
            }
        }
        return ext;
    }

    /**
     * 파일명을 리턴, 확장자가 없으면 "" 를 리턴
     *
     * @param file 파일
     * @return filename 파일명 스트링
     */
    public static String getFileName(String file) {
        String filename = "";

        if(file != null) {
            int sepIndex = file.lastIndexOf(".");
            if(sepIndex > 0 )
                filename = file.substring(0,sepIndex);
        }
        return filename;
    }

    /**
     * 파일전체 경로중 파일명을 제외한 경로만 가져온다.
     * @param filePath
     * @return
     */
    public static String getFileDir(String filePath) {
        String dirName = "";

        if(filePath != null) {
            int sepIndex = filePath.lastIndexOf("/");
            if(sepIndex > 0 )
                dirName = filePath.substring(0,sepIndex);
        }
        return dirName;
    }

    public static void saveToFileParameter(HttpServletRequest request, String filename) {
        request.setAttribute("output", "file");
        request.setAttribute("inline", "false");
        request.setAttribute("filename", filename);
    }

    /**
     *
     * @param path
     * @param filename
     * @param msg
     */
    public static void createFile(String path, String filename, String msg) {
        OutputStream out = null;
        try {
            setDirectory(path);
            out = new FileOutputStream(path+"/"+filename, false);
            out.write(msg.getBytes());
            out.close();
        } catch(Exception e) {
            System.out.println(e);
        } finally {
            if(out != null) {
                try {
                    out.close();
                } catch(Exception e) {
                    System.out.println(e);
                }
            }
        }
    }

    public static void createDirectory(String path) {
        setDirectory(path);
    }

    /**
     * 파일 압축 풀기
     * target을 입력하지 않을경우 source 경로에 압축을 푼다.
     * @param source
     * @param target
     * @return
     */
    public static boolean unZipFile(String source, String target) {
        try {

            ZipUtil zipUtil = new ZipUtil();
            File sourceFile = new File(source);
            File targetFile = new File(target);
            zipUtil.unzip(sourceFile, targetFile,"UTF-8");
            // zipUtil.unzip(sourceFile, targetFile,"KSC5601");
        } catch(Exception e) {
            return false;
        }
        return true;
    }

    /**
     * 파일 압축 풀기 encoding 추가
     * target을 입력하지 않을경우 source 경로에 압축을 푼다.
     * @param source
     * @param target
     * @param encoding
     * @return
     */
    public static boolean unZipFile(String source, String target, String encoding) {
        try {

            ZipUtil zipUtil = new ZipUtil();
            File sourceFile = new File("");
            File targetFile = new File("");

            if(source != null && !"".equals(source)) {
                source = source.replaceAll("/", "");
                source = source.replaceAll("\\\\", "");
                source = source.replaceAll("[.]{2}", "");
                source = source.replaceAll("&", "");
                source = source.replaceAll("%", "");
                sourceFile = new File(source);
            }

            if(target != null && !"".equals(target)) {
                target = target.replaceAll("/", "");
                target = target.replaceAll("\\\\", "");
                target = target.replaceAll("[.]{2}", "");
                target = target.replaceAll("&", "");
                target = target.replaceAll("%", "");
                targetFile = new File(target);
            }
            zipUtil.unzip(sourceFile, targetFile, encoding);
        } catch(Exception e) {
            return false;
        }
        return true;
    }

    /**
     * 디렉토리, 파일 복사
     * 지정된 위치에 있는 디렉토리와 파일들을 대상 위치로 모두 복사한다.
     * @param source
     * @param target
     * @return
     */
    public static boolean copyDirectoryFile(String source, String target) {
        boolean result = true;
        int bufSize = 4096;
        byte buf[] = new byte[bufSize];

        String delimeter = "/";
        if(source.lastIndexOf("\\") > -1) {
            delimeter = "\\";
        }

        setDirectory(target);

        File sourceFile = new File(source);
        if(sourceFile.isDirectory()) {

            File sourceFileList[] = sourceFile.listFiles();
            for (int i = 0; i < sourceFileList.length; i++) {
                File sFile = sourceFileList[i];
                String newSource = sFile.getPath();
                String newTarget = target + delimeter + sFile.getName();

                // 디렉토리
                if(sFile.isDirectory()) {
                    copyDirectoryFile(newSource, newTarget);
                } else if(sFile.isFile()) {
                    // 파일
                    InputStream in = null;
                    OutputStream out = null;

                    try {
                        in = new FileInputStream(sFile);
                        out = new FileOutputStream(newTarget, true);
                        int read = 0;

                        while ((read = in.read(buf, 0, bufSize)) > 0) {
                            out.write(buf, 0, read);
                        }

                        in.close();
                        out.close();
                    } catch(IOException e) {
                        result = false;
                    } finally {
                        try {
                            if(in != null) { in.close(); }
                            if(out != null) { out.close(); }
                        } catch(IOException e) {
                            result = false;
                        }
                    }
                }
            }
        } else if(sourceFile.isFile()) {
            InputStream in = null;
            OutputStream out = null;

            try {
                String newTarget = target + delimeter + sourceFile.getName();
                in = new FileInputStream(sourceFile);
                out = new FileOutputStream(newTarget, true);
                int read = 0;

                while((read = in.read(buf, 0, bufSize)) > 0) {
                    out.write(buf, 0, read);
                }
                in.close();
                out.close();
            } catch(IOException e) {
                result = false;
            } finally {
                try {
                    if(in != null) { in.close(); }
                    if(out != null) {	out.close(); }
                } catch(IOException e) {
                    result = false;
                }
            }
        }
        return result;
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
    public static void sort(File[] filterResult) {
        Arrays.sort(filterResult, new Comparator() {
            public int compare(Object arg0, Object arg1) {
                File file1 = (File)arg0;
                File file2 = (File)arg1;
                return file1.getName().compareToIgnoreCase(file2.getName());
            }
        });
    }

    /**
     * 입력한 디렉토리의 사이즈를 구하여 반환한다.
     * 파일을 입력시 단일 파일의 사이즈를 구하여 반환한다.
     * @param dir
     * @return
     */
    public static long getTotalSize(String dir) {
        result = 0;
        File tf = new File(dir);
        if(tf.isDirectory()) {
            // -- 디렉토리일 경우에만 하위 파일 목록 찾아 길이 반환
            dirSize(tf);
        } else {
            //-- 파일의 경우에는 단일 파일의 사이즈만 반환
            result += tf.length();
        }
        return result;
    }

    /**
     * 디렉토리 하위의 파일을 검색하여 사이즈를 증가 시킴.
     * 제귀 호출을 통해 하위 디렉토리의 파일 사이즈까지 중가 시킬 수 있도록 구현.
     * @param tarFile
     */
    public static void dirSize(File tarFile) {

        try {

            File[] fileList = tarFile.listFiles();
            for(int i=0; i < fileList.length; i++) {
                if(fileList[i].isFile()) {
                    result += fileList[i].length();
                } else {
                    dirSize(fileList[i]);
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Bytes 단위를 크기를 받아 KB, MB, GB, TB 형태로 변경하여 반환한다.
     * @param bytes
     * @return
     */
    public static String fileSizeFormatter(long bytes) {
        String[] s = {"Bytes", "KB", "MB", "GB", "TB", "PB"};
        int e = (int)Math.floor(Math.log(bytes)/Math.log(1024));
        String fileSizeStr = "";
        if(bytes <= 0) fileSizeStr = "0 Bytes";
        else fileSizeStr = Math.round((bytes/Math.pow(1024, Math.floor(e))))+" "+s[e];

        return fileSizeStr;
    }

    /**
     * ***************************************************
     * 폼에서 업로드된 파일목록을 가져온다.  --- TODO 삭제 예정
     * @param uploadFiles
     * @return
     *****************************************************
     */
    public static List<FileVO> getUploadFileList(String uploadFiles) {
        List<FileVO> fileList = new ArrayList<FileVO>();
        uploadFiles = StringUtil.nvl(uploadFiles).replaceAll("\\\\", "");

        if(!"".equals(uploadFiles)) {
            JSONArray fileArray = (JSONArray) JSONSerializer.toJSON(uploadFiles);
            FileVO fileVO = null;

            for(int i=0; i<fileArray.size(); i++) {
                JSONObject fileObj = (JSONObject) fileArray.get(i);

                fileVO = new FileVO();
                if(fileObj.containsKey("encFileSn")) {
                    fileVO.setEncFileSn(fileObj.getString("encFileSn"));
                    fileVO.setDecFileSn(fileObj.getString("encFileSn"));
                }
                fileVO.setFileSaveNm(fileObj.getString("fileId"));
                fileVO.setFileNm(fileObj.getString("fileNm"));
                fileVO.setFileSize(fileObj.getLong("fileSize"));
                fileVO.setFilePath(fileVO.getFileSaveNm() + "." + FileUtil.getFileExtention(fileVO.getFileNm()));
                fileList.add(fileVO);
            }
        }
        return fileList;
    }

    /**
     * ***************************************************
     * 폼에서 업로드된 파일목록을 가져온다. v2
     * @param uploadFiles
     * @return
     *****************************************************
     */
    public static List<UploadFileVO> getUploadFileListV2(String uploadFiles) {
        List<UploadFileVO> fileList = new ArrayList<>();
        uploadFiles = StringUtil.nvl(uploadFiles).replaceAll("\\\\", "");

        if(!"".equals(uploadFiles)) {
            JSONArray fileArray = (JSONArray) JSONSerializer.toJSON(uploadFiles);
            UploadFileVO fileVO = null;

            for(int i=0; i < fileArray.size(); i++) {
                JSONObject fileObj = (JSONObject) fileArray.get(i);

                fileVO = new UploadFileVO();
                fileVO.setFileId(fileObj.getString("fileId"));
                fileVO.setFileSize(fileObj.getLong("fileSize"));
                fileVO.setFileNm(fileObj.getString("fileNm"));
                fileList.add(fileVO);
            }
        }
        return fileList;
    }

    /**
     * ***************************************************
     * 폼에서 업로드된 파일목록을 Json String 가져온다.
     * @param uploadFileList
     * @return
     *****************************************************
     */
    public static String getUploadFileListToJsonString(List<UploadFileVO> uploadFileList) {
        JSONArray fileObjArray = new JSONArray();
        JSONObject fileObj = null;

        for(UploadFileVO uploadFileVO : uploadFileList) {
            fileObj = new JSONObject();
            fileObj.put("fileNm", uploadFileVO.getFileNm());
            fileObj.put("fileId", uploadFileVO.getFileId());
            fileObj.put("fileSize", uploadFileVO.getFileSize());
            fileObjArray.add(fileObj);
        }

        return fileObjArray.toString();
    }

    /**
     * ***************************************************
     * Base64 인코딩 데이터를 파일로 저장
     *
     * @param data
     * @param fileName
     * @param savePath
     * @return boolean
     * @throws Exception
     *****************************************************
     */
    public static boolean base64ToFile(String data, String fileName, String savePath) throws Exception {

        try {

            File dir = new File(savePath);
            if(!dir.exists()) {
                dir.mkdirs();
            }

            File file = new File(savePath, fileName);
            byte[] decodedBytes = Base64.getDecoder().decode(data);

            file.createNewFile();
            FileOutputStream fOut = new FileOutputStream(file);
            fOut.write(decodedBytes);
            fOut.close();

            return true;
        } catch(FileNotFoundException e) {
            e.printStackTrace();
            return false;
        } catch(IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ***************************************************
     * Base64 인코딩 데이터를 파일로 저장
     *
     * @param data
     * @param fileName
     * @param savePath
     * @return boolean
     * @throws Exception
     *****************************************************
     */
    public static long base64ToAudio(String data, String fileName, String savePath) throws Exception {
        try {
            File dir = new File(savePath);
            if(!dir.exists()) {
                dir.mkdirs();
            }

            File file = new File(savePath, fileName);
            byte[] decodedBytes = Base64.getDecoder().decode(data);

            file.createNewFile();
            FileOutputStream fOut = new FileOutputStream(file);
            fOut.write(decodedBytes);
            fOut.close();

            return file.length();
        } catch(FileNotFoundException e) {
            e.printStackTrace();
            return -1;
        } catch(IOException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public static String fileRandomCopy(String fileName, String fileSaveNm, String path) throws Exception {
        String filePath = CommConst.WEBDATA_PATH;

        String fileExt = StringUtil.getExtNoneDot(fileName).toLowerCase();
        String newfileNm = RandomStringUtil.getRandomMD5() + "." + fileExt;

        Path file = Paths.get(filePath + path + "\\" + fileSaveNm);
        Path newFile = Paths.get(filePath + path + "\\" + newfileNm);

        Files.copy(file, newFile, StandardCopyOption.REPLACE_EXISTING);

        return newfileNm;
    }

    public static void deleteFile(String fileSaveNm, String path) throws Exception {
        String filePath = CommConst.WEBDATA_PATH;
        filePath += path + "\\" + fileSaveNm;

        Files.deleteIfExists(Paths.get(filePath));
    }

    public static void delUploadFileList(String uploadFiles, String path) throws Exception {
        uploadFiles = StringUtil.nvl(uploadFiles).replaceAll("\\\\", "");

        if(!"".equals(uploadFiles)) {
            JSONArray fileArray = (JSONArray) JSONSerializer.toJSON(uploadFiles);

            for(int i=0; i<fileArray.size(); i++) {
                JSONObject fileObj = (JSONObject) fileArray.get(i);

                String fileExt = StringUtil.getExtNoneDot(fileObj.getString("fileNm")).toLowerCase();
                String fileSaveNm = fileObj.getString("fileId") + "." + fileExt;

                deleteFile(fileSaveNm, path);
            }
        }
    }

    /**
     * 파일함에서 전달받은 파일 복사
     * @param copyFiles
     * @param path
     * @return fileList
     */
    public static List<FileVO> copyFromFilebox(String copyFiles, String path) {
        List<FileVO> fileList = new ArrayList<FileVO>();
        copyFiles = StringUtil.nvl(copyFiles).replaceAll("\\\\", "");

        if(!"".equals(copyFiles)) {
            JSONArray fileArray = (JSONArray) JSONSerializer.toJSON(copyFiles);
            FileVO fileVO = null;

            for(int i=0; i<fileArray.size(); i++) {
                JSONObject fileObj = (JSONObject) fileArray.get(i);

                String ext = getFileExtention(fileObj.getString("fileSaveNm"));
                String saveNm = fileObj.getString("fileId") + "." + ext;
                String sourcePath = CommConst.WEBDATA_PATH + fileObj.getString("filePath") + "/" + fileObj.getString("fileSaveNm");
                String targetPath = CommConst.WEBDATA_PATH + path + "/" + saveNm;

                createDirectory(CommConst.WEBDATA_PATH + path);

                try {
                    fileCopy(sourcePath, targetPath);
                } catch (Exception e) {

                }

                fileVO = new FileVO();
                fileVO.setFileSaveNm(fileObj.getString("fileId"));
                fileVO.setFileNm(fileObj.getString("fileNm"));
                fileVO.setFileSize(fileObj.getLong("fileSize"));
                fileList.add(fileVO);
            }
        }
        return fileList;
    }

    public static String saveFileId() {

        String[] digits = {
                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
                "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
                "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
        };

        String newId = digits[(int) Math.round(Math.random() * 52)];

        newId += digits[(Integer.parseInt(DateTimeUtil.getYear()) % 100)-1];
        newId += digits[Integer.parseInt(DateTimeUtil.getMonth())];
        newId += digits[Integer.parseInt(DateTimeUtil.getDay())];
        newId += digits[Integer.parseInt(DateTimeUtil.getHours())];
        newId += digits[Integer.parseInt(DateTimeUtil.getMinutes())];
        newId += digits[Integer.parseInt(DateTimeUtil.getSeconds())];

        String randStr;
                randStr =  new RandomStringBuilder().putLimitedChar(RandomStringBuilder.ALPHABET).setLength(16).build();

        return newId + randStr;
    }

    /**
     * 파일목록 json array 형식 리턴
     * @param list
     * @return String
     */
    public static String getUploadFilesByFileList(List<FileVO> list) {
        if(list != null && !list.isEmpty() & list.size() > 0) {
            List<Map<String, String>> uploadFiles = new ArrayList<>();

            for(FileVO fvo2 : list) {
                Map<String, String> map = new HashMap<>();
                map.put("fileNm", fvo2.getFileNm());
                map.put("fileId", fvo2.getFileId());
                map.put("fileSize", fvo2.getFileSize().toString());
                uploadFiles.add(map);
            }

            JSONArray uploadFile = JSONArray.fromObject(uploadFiles);

            return uploadFile.toString();
        } else {
            return null;
        }
    }


    /**
     * 폼에서 업로드된 첨부파일목록을 가져온다. (new)
     * @param uploadFiles
     * @return
     */
    public static List<AtflVO> getUploadAtflList(String uploadFiles, String filePath) {
        List<AtflVO> fileList = new ArrayList<>();
        uploadFiles = StringUtil.nvl(uploadFiles).replaceAll("\\\\", "");

        if(!"".equals(uploadFiles)) {
            JSONArray fileArray = (JSONArray) JSONSerializer.toJSON(uploadFiles);
            AtflVO atflVO = null;
            String ext = null;
            String fileName = null;
            JSONObject fileObj = null;

            for(int i=0; i<fileArray.size(); i++) {
                fileObj = (JSONObject) fileArray.get(i);
                fileName = fileObj.getString("fileNm");
                ext = getFileExtention(fileName);

                atflVO = new AtflVO();
                atflVO.setAtflId(IdGenerator.getNewId("ATFL"));
                atflVO.setFileSavnm(fileObj.getString("fileId") + (!"".equals(ext) ? "." + ext : ""));
                atflVO.setFilenm(fileName);
                atflVO.setFileSize(fileObj.getLong("fileSize"));
                atflVO.setFilePath(filePath);
                atflVO.setFileExt(ext);
                atflVO.setFileTycd(getFileType(fileName));
                atflVO.setMimeTycd(getFileMimeType(fileName));
                atflVO.setAtflSeqno(i+1);
                atflVO.setDwldCnt(0);
        		atflVO.setDelyn("N");
                fileList.add(atflVO);
            }
        }

        return fileList;
    }


    /**
     * 파일유형 반환
     * @param fileName
     * @return fileType
     */
    public static String getFileType(String fileName) {
    	String fileType = "ETC";
    	String ext = getFileExtention(fileName);

    	if (!"".equals(ext)) {
    		if (Arrays.asList(CommConst.FILE_TYPE_IMG_EXT).contains(ext)) {
    			fileType = CommConst.FILE_TYPE_IMG;
    		}
    		else if (Arrays.asList(CommConst.FILE_TYPE_VIDEO_EXT).contains(ext)) {
    			fileType = CommConst.FILE_TYPE_VIDEO;
    		}
    		else if (Arrays.asList(CommConst.FILE_TYPE_AUDIO_EXT).contains(ext)) {
    			fileType = CommConst.FILE_TYPE_AUDIO;
    		}
    		else if (Arrays.asList(CommConst.FILE_TYPE_DOC_EXT).contains(ext)) {
    			fileType = CommConst.FILE_TYPE_DOC;
    		}
    		else if (Arrays.asList(CommConst.FILE_TYPE_TXT_EXT).contains(ext)) {
    			fileType = CommConst.FILE_TYPE_TXT;
    		}
    	}

    	return fileType;
    }

    /**
     * 파일 마입타입 반환
     * @param fileName
     * @return mimeType
     */
    public static String getFileMimeType(String fileName) {
    	return new MimetypesFileTypeMap().getContentType(fileName);
    }
}
