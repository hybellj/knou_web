package knou.framework.vo;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.ibatis.type.Alias;
import org.json.simple.JSONArray;

import knou.framework.util.CryptoUtil;
import knou.framework.util.FileUtil;
import knou.framework.util.SecureUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;

@Alias("fileVO")
public class FileVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String fileId = "";         // 파일ID
    private String fileNm = "";         // 파일명
    private String fileSaveNm = "";     // 저장 파일명
    private String filePath = "";       // 파일경로
    private long fileSize = 0;          // 파일 사이즈

    /** tb_sys_File */
    private String  fileSn;             // 파일 고유번호
    private String  orgId;              // 기관 코드
    private String  repoCd;             // 저장소 코드
    private String  repoPath;           // 저장소 경로
    private String  fileExt;            // 파일 확장자
    private String  fileType;           // 파일 유형
    private String  mimeType;           // MIME 유형
    private Integer hits;               // 조회 수
    private String  lastInqDttm;        // 마지막 조회 일시
    private String  fileBindDataSn;     // 파일 할당 자료 고유번호
    private String  etcInfo1;           // 부가 정보 1 (CMS 변환파일 URL)
    private String  etcInfo2;           // 부가 정보 2
    private String  etcInfo3;           // 부가 정보 3
    private String  objectStoragePath;

    private String  repoNm;             // 저장소명
    private String  parTableNm;         // 상위 테이블명
    private String  parFieldNm;         // 상위 필드명
    private Integer usingCnt;
    private String  fileSizeStr;        // 파일 크기 String
    private String  domainUrl;

    private String  encFileSn;          // AES256으로 암호화된 FILE_SN
    private String  decFileSn;          // AES256으로 복호화된 FILE_SN

    private String  isUsingTable;
    private List<String> fileSnArr;     // 주키의 배열
    private String[] fileSnList;

    private String copyFileBindDataSn;
    private String copyFileSn;
    private String orginDelYn;
    private String fileView;
    private String thumb;               // 썸네일이미지
    private String fileRegDttm;         // 제출날짜

    private JSONArray  jsonArray;
    
    /**
     * 파일사이즈 Byte로 가져오기
     * @return size
     */
    public String getFileSizeByte() {
        return FileUtil.getFileSizeConvertByte(fileSize);
    }
    /**
     * 파일사이즈 KByte로 가져오기
     * @return size
     */
    public String getFileSizeKByte() {
        return FileUtil.getFileSizeConvertKByte(fileSize);
    }
    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }

    /**
     * 파일 다운로드 경로
     * @return path
     * @throws UnsupportedEncodingException 
     */
    public String getDownloadPath() throws UnsupportedEncodingException {
        String downPath = filePath+"/"+fileSaveNm+"|"+fileNm;
        return URLEncoder.encode(SecureUtil.encodeDownPath(downPath), java.nio.charset.StandardCharsets.UTF_8.toString());
    }

    public String getFileId() {
        return fileId;
    }
    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    public String getFileSizeStr() {
        return fileSizeStr;
    }
    public void setFileSizeStr(String fileSizeStr) {
        this.fileSizeStr = fileSizeStr;
    }

    public String getFileSn() {
        return fileSn;
    }
    public void setFileSn(String fileSn) {
        this.fileSn = fileSn;
        this.setEncFileSn(fileSn.toString());
    }

    public String getRepoCd() {
        return repoCd;
    }
    public void setRepoCd(String repoCd) {
        this.repoCd = repoCd;
    }

    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getDomainUrl() {
        return domainUrl;
    }
    public void setDomainUrl(String domainUrl) {
        this.domainUrl = domainUrl;
    }

    public String getRepoPath() {
        return repoPath;
    }
    public void setRepoPath(String repoPath) {
        this.repoPath = repoPath;
    }

    public String getFileNm() {
        return fileNm;
    }
    public void setFileNm(String fileNm) {
        this.fileNm = fileNm;
    }

    public String getFileSaveNm() {
        return fileSaveNm;
    }
    public void setFileSaveNm(String fileSaveNm) {
        this.fileSaveNm = fileSaveNm;
    }

    public String getFilePath() {
        return filePath;
    }
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFileExt() {
        return fileExt;
    }
    public void setFileExt(String fileExt) {
        this.fileExt = fileExt;
    }

    public Long getFileSize() {
        return fileSize;
    }
    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
        this.setFileSizeStr(FileUtils.byteCountToDisplaySize(this.fileSize));
    }

    public String getFileType() {
        return fileType;
    }
    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getMimeType() {
        return mimeType;
    }
    public void setMimeType(String mimeType) {
        this.mimeType = mimeType;
    }

    public String getLastInqDttm() {
        return lastInqDttm;
    }
    public void setLastInqDttm(String lastInqDttm) {
        this.lastInqDttm = lastInqDttm;
    }

    public String getFileBindDataSn() {
        return fileBindDataSn;
    }
    public void setFileBindDataSn(String fileBindDataSn) {
        this.fileBindDataSn = fileBindDataSn;
    }

    public String getEtcInfo1() {
        return etcInfo1;
    }
    public void setEtcInfo1(String etcInfo1) {
        this.etcInfo1 = etcInfo1;
    }

    public String getEtcInfo2() {
        return etcInfo2;
    }
    public void setEtcInfo2(String etcInfo2) {
        this.etcInfo2 = etcInfo2;
    }

    public String getEtcInfo3() {
        return etcInfo3;
    }
    public void setEtcInfo3(String etcInfo3) {
        this.etcInfo3 = etcInfo3;
    }

    public String getRepoNm() {
        return repoNm;
    }
    public void setRepoNm(String repoNm) {
        this.repoNm = repoNm;
    }

    public String getParTableNm() {
        return parTableNm;
    }
    public void setParTableNm(String parTableNm) {
        this.parTableNm = parTableNm;
    }

    public String getParFieldNm() {
        return parFieldNm;
    }
    public void setParFieldNm(String parFieldNm) {
        this.parFieldNm = parFieldNm;
    }

    public Integer getUsingCnt() {
        return usingCnt;
    }
    public void setUsingCnt(Integer usingCnt) {
        this.usingCnt = usingCnt;
    }

    public List<String> getFileSnArr() {
        return fileSnArr;
    }
    public void setFileSnArr(List<String> fileSnArr) {
        this.fileSnArr = fileSnArr;
    }

    /**
     * 파일 이름을 포함한 실제 저장된 경로 전체를 반환.<br>
     * {@code /repo/filepath/filesavename}
     * @return
     */
    public String getSaveFilePath() {
        return this.getSaveDirectoryPath() + File.separator + this.getFileSaveNm();
    }
    /**
     * 파일의 저장 경로 반환
     * @return
     */
    public String getSaveDirectoryPath() {
        return StringUtil.ReplaceAll(this.getFilePath(), "\\", File.separator);
    }

    /**
     * 파일 번호화 파일 확장자를 조합해서 가상의 파일명을 반환
     * @return
     */
    public String getFileSnName() {
        // return this.getFileSn() + "." + StringUtil.nvl(this.getFileExt(), "image");
        // return ""+this.getFileSn();
        return ""+this.getEncFileSn();
    }

    public boolean isMedia() {
        if(this.fileExt == null) return false;
        String mediaExt = "avi|wmv|wma|mpg|asx";
        return mediaExt.indexOf(this.fileExt.toLowerCase()) > -1;
    }

    public boolean isImage() {
        if(this.fileExt == null) return false;
        String imageExt = "jpg|gif|png";
        return imageExt.indexOf(this.fileExt.toLowerCase()) > -1;
    }

    public boolean isFlash() {
        if(this.fileExt == null) return false;
        String imageExt = "swf";
        return imageExt.indexOf(this.fileExt.toLowerCase()) > -1;
    }

    /**
     * 테이블 명칭이 "TB_"로 시작하는 명명규칙을 따르지 않는다면 실제로 존재하지 않는 테이블이라고 판단한다.
     *
     * @return
     */
    public String getIsUsingTable() {
        if(ValidationUtils.isEmpty(this.isUsingTable)) {
            String result = "false";

            if(StringUtil.nvl(this.getParTableNm(),"").indexOf("TB_") == 0)
                result = "true";
            return result;
        } else {
            return this.isUsingTable;
        }
    }
    public void setIsUsingTable(String isUsingTable) {
        this.isUsingTable = isUsingTable;
    }

    /** @return encFileSn 값을 반환한다. */
    public String getEncFileSn() {
        return encFileSn;
    }
    /** @param encFileSn 을 encFileSn 에 저장한다.
     * @throws UnsupportedEncodingException
     **/
    public void setEncFileSn(String fileSn) {
    	
        String encFileSn = "";
        try {
            encFileSn = CryptoUtil.encryptAes256(fileSn, "");
        } catch(NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch(UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch(GeneralSecurityException e) {
            e.printStackTrace();
        }
        this.encFileSn = encFileSn;
    }

    /** @return decFileSn 값을 반환한다. */
    public String getDecFileSn() {
        return decFileSn;
    }
    /** @param decFileSn 을 decFileSn 에 저장한다. */
    public void setDecFileSn(String encFileSn) {

        String decFileSn = "";
        if(ValidationUtils.isNotEmpty(encFileSn)) {
            try {
                decFileSn = CryptoUtil.decryptAes256(encFileSn);
            } catch(NoSuchAlgorithmException e) {
                e.printStackTrace();
            } catch(UnsupportedEncodingException e) {
                e.printStackTrace();
            } catch(GeneralSecurityException e) {
                e.printStackTrace();
            }
        } else {
            decFileSn = "";
        }
        this.decFileSn = decFileSn;
    }

    public String[] getFileSnList() {
        return fileSnList;
    }
    public void setFileSnList(String[] fileSnList) {
        this.fileSnList = fileSnList;
    }

    public String getCopyFileBindDataSn() {
        return copyFileBindDataSn;
    }
    public void setCopyFileBindDataSn(String copyFileBindDataSn) {
        this.copyFileBindDataSn = copyFileBindDataSn;
    }

    public String getOrginDelYn() {
        return orginDelYn;
    }
    public void setOrginDelYn(String orginDelYn) {
        this.orginDelYn = orginDelYn;
    }

    public String getFileView() {
        return fileView;
    }
    public void setFileView(String fileView) {
        this.fileView = fileView;
    }

    public String getThumb() {
        return thumb;
    }
    public void setThumb(String thumb) {
        this.thumb = thumb;
    }

    public JSONArray getJsonArray() {
        return jsonArray;
    }
    public void setJsonArray(JSONArray jsonArray) {
        this.jsonArray = jsonArray;
    }

    public String getFileRegDttm() {
        return fileRegDttm;
    }
    public void setFileRegDttm(String fileRegDttm) {
        this.fileRegDttm = fileRegDttm;
    }
    public Integer getHits() {
        return hits;
    }
    public void setHits(Integer hits) {
        this.hits = hits;
    }
    public String getCopyFileSn() {
        return copyFileSn;
    }
    public void setCopyFileSn(String copyFileSn) {
        this.copyFileSn = copyFileSn;
    }
    public String getObjectStoragePath() {
        return objectStoragePath;
    }
    public void setObjectStoragePath(String objectStoragePath) {
        this.objectStoragePath = objectStoragePath;
    }

}
