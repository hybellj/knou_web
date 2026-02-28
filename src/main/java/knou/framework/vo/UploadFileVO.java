package knou.framework.vo;

import java.io.Serializable;

public class UploadFileVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String fileId;

    private long fileSize;

    private String fileNm;

    public String getFileId() {
        return fileId;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    public String getFileNm() {
        return fileNm;
    }

    public void setFileNm(String fileNm) {
        this.fileNm = fileNm;
    }

    public long getFileSize() {
        return fileSize;
    }

    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }

}
