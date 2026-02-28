package knou.lms.file.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class FileBoxInfoVO extends DefaultVO {

    private static final long serialVersionUID = 2998650969170456004L;

    // 조회
    private String selectedFileBoxCd;

    // 트리 목록 결과
    private Integer depth;
    private String fileBoxCd;
    private String parFileBoxCd;
    private String folderNm;
    private String path;
    private Integer childrenCnt;
    private String firstChild;
    private String lastChild;

    // 파일함 내 파일 목록 결과
    private String downloadDomain;

    private String fileSn;
    private String fileNm;
    private String fileSaveNm;
    private String encFileSn;
    private String fileBoxTypeCd;
    private String fileBoxTypeNm;
    private String fileBoxNm;
    private String fileBoxFullNm;
    private String fileExt;
    private String regDt;
    private String downloadUrl;
    private String contentUrl;
    private Long fileSize;
    private String fileSizeFormatted;
    private String folderPath;

    private String fileType;
    private String mimeType;

    // 사용량
    private Long fileLimitSize;
    private Long fileUseSize;
    private Long fileUseRate;

    private String fileLimitSizeFormatted;
    private String fileUseSizeFormatted;

    private List<String> fileBoxCds;

    private String rgtrId;

    public String getSelectedFileBoxCd() {
        return selectedFileBoxCd;
    }
    public void setSelectedFileBoxCd(String selectedFileBoxCd) {
        this.selectedFileBoxCd = selectedFileBoxCd;
    }

    public Integer getDepth() {
        return depth;
    }
    public void setDepth(Integer depth) {
        this.depth = depth;
    }

    public String getFileBoxCd() {
        return fileBoxCd;
    }
    public void setFileBoxCd(String fileBoxCd) {
        this.fileBoxCd = fileBoxCd;
    }

    public String getParFileBoxCd() {
        return parFileBoxCd;
    }
    public void setParFileBoxCd(String parFileBoxCd) {
        this.parFileBoxCd = parFileBoxCd;
    }

    public String getFolderNm() {
        return folderNm;
    }
    public void setFolderNm(String folderNm) {
        this.folderNm = folderNm;
    }

    public String getPath() {
        return path;
    }
    public void setPath(String path) {
        this.path = path;
    }

    public Integer getChildrenCnt() {
        return childrenCnt;
    }
    public void setChildrenCnt(Integer childrenCnt) {
        this.childrenCnt = childrenCnt;
    }

    public String getFirstChild() {
        return firstChild;
    }
    public void setFirstChild(String firstChild) {
        this.firstChild = firstChild;
    }

    public String getLastChild() {
        return lastChild;
    }
    public void setLastChild(String lastChild) {
        this.lastChild = lastChild;
    }

    public String getDownloadDomain() {
        return downloadDomain;
    }
    public void setDownloadDomain(String downloadDomain) {
        this.downloadDomain = downloadDomain;
    }

    public String getFileSn() {
        return fileSn;
    }
    public void setFileSn(String fileSn) {
        this.fileSn = fileSn;
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
    
    public String getEncFileSn() {
        return encFileSn;
    }
    public void setEncFileSn(String encFileSn) {
        this.encFileSn = encFileSn;
    }

    public String getFileBoxTypeCd() {
        return fileBoxTypeCd;
    }
    public void setFileBoxTypeCd(String fileBoxTypeCd) {
        this.fileBoxTypeCd = fileBoxTypeCd;
    }

    public String getFileBoxTypeNm() {
        return fileBoxTypeNm;
    }
    public void setFileBoxTypeNm(String fileBoxTypeNm) {
        this.fileBoxTypeNm = fileBoxTypeNm;
    }

    public String getFileBoxNm() {
        return fileBoxNm;
    }
    public void setFileBoxNm(String fileBoxNm) {
        this.fileBoxNm = fileBoxNm;
    }

    public String getFileBoxFullNm() {
        return fileBoxFullNm;
    }
    public void setFileBoxFullNm(String fileBoxFullNm) {
        this.fileBoxFullNm = fileBoxFullNm;
    }

    public String getFileExt() {
        return fileExt;
    }
    public void setFileExt(String fileExt) {
        this.fileExt = fileExt;
    }

    public String getRegDt() {
        return regDt;
    }
    public void setRegDt(String regDt) {
        this.regDt = regDt;
    }

    public String getDownloadUrl() {
        return downloadUrl;
    }
    public void setDownloadUrl(String downloadUrl) {
        this.downloadUrl = downloadUrl;
    }

    public String getContentUrl() {
        return contentUrl;
    }
    public void setContentUrl(String contentUrl) {
        this.contentUrl = contentUrl;
    }

    public Long getFileSize() {
        return fileSize;
    }
    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileSizeFormatted() {
        return fileSizeFormatted;
    }
    public void setFileSizeFormatted(String fileSizeFormatted) {
        this.fileSizeFormatted = fileSizeFormatted;
    }

    public String getFolderPath() {
        return folderPath;
    }
    public void setFolderPath(String folderPath) {
        this.folderPath = folderPath;
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

    public Long getFileLimitSize() {
        return fileLimitSize;
    }
    public void setFileLimitSize(Long fileLimitSize) {
        this.fileLimitSize = fileLimitSize;
    }

    public Long getFileUseSize() {
        return fileUseSize;
    }
    public void setFileUseSize(Long fileUseSize) {
        this.fileUseSize = fileUseSize;
    }

    public Long getFileUseRate() {
        return fileUseRate;
    }
    public void setFileUseRate(Long fileUseRate) {
        this.fileUseRate = fileUseRate;
    }

    public String getFileLimitSizeFormatted() {
        return fileLimitSizeFormatted;
    }
    public void setFileLimitSizeFormatted(String fileLimitSizeFormatted) {
        this.fileLimitSizeFormatted = fileLimitSizeFormatted;
    }

    public String getFileUseSizeFormatted() {
        return fileUseSizeFormatted;
    }
    public void setFileUseSizeFormatted(String fileUseSizeFormatted) {
        this.fileUseSizeFormatted = fileUseSizeFormatted;
    }

    public List<String> getFileBoxCds() {
        return fileBoxCds;
    }
    public void setFileBoxCds(List<String> fileBoxCds) {
        this.fileBoxCds = fileBoxCds;
    }
	public String getRgtrId() {
		return rgtrId;
	}
	public void setRgtrId(String rgtrId) {
		this.rgtrId = rgtrId;
	}
    
}
