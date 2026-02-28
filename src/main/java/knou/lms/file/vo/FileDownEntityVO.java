package knou.lms.file.vo;

public class FileDownEntityVO {
    
    private String originalFilename;
    private String savedFileName;
    private long fileSize;
    private String mimeType;
    private String filePath;
	private String fieldName;
	private String key;

	public String getOriginalFilename() {
		return originalFilename;
	}
	public void setOriginalFilename(String originalFilename) {
		this.originalFilename = originalFilename;
	}

    public String getSavedFileName() {
        return savedFileName;
    }
    public void setSavedFileName(String savedFileName) {
        this.savedFileName = savedFileName;
    }
	
	public long getFileSize() {
		return fileSize;
	}
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	public String getMimeType() {
		return mimeType;
	}
	public void setMimeType(String mimeType) {
		this.mimeType = mimeType;
	}

	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getFieldName() {
		return fieldName;
	}
	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}

    public String getKey() {
        return key;
    }
    public void setKey(String key) {
        this.key = key;
    }

}
