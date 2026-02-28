package knou.lms.seminar.api.cloudrecording.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

public class RecordingFileVO {
    
    @JsonProperty("id")
    private String id;
    @JsonProperty("recording_start")
    private String recordingStart;
    @JsonProperty("recording_end")
    private String recordingEnd;
    @JsonProperty("file_type")
    private String fileType;
    @JsonProperty("play_url")
    private String playUrl;
    @JsonProperty("download_url")
    private String downloadUrl;
    @JsonProperty("file_size")
    private int fileSize;
    @JsonProperty("recording_type")
    private String recordingType;
    
    private String topic;
    private String password;
    private String recordingTime;
    
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getRecordingStart() {
        return recordingStart;
    }
    public void setRecordingStart(String recordingStart) {
        this.recordingStart = recordingStart;
    }
    public String getRecordingEnd() {
        return recordingEnd;
    }
    public void setRecordingEnd(String recordingEnd) {
        this.recordingEnd = recordingEnd;
    }
    public String getFileType() {
        return fileType;
    }
    public void setFileType(String fileType) {
        this.fileType = fileType;
    }
    public String getPlayUrl() {
        return playUrl;
    }
    public void setPlayUrl(String playUrl) {
        this.playUrl = playUrl;
    }
    public String getDownloadUrl() {
        return downloadUrl;
    }
    public void setDownloadUrl(String downloadUrl) {
        this.downloadUrl = downloadUrl;
    }
    public int getFileSize() {
        return fileSize;
    }
    public void setFileSize(int fileSize) {
        this.fileSize = fileSize;
    }
    public String getRecordingType() {
        return recordingType;
    }
    public void setRecordingType(String recordingType) {
        this.recordingType = recordingType;
    }
    public String getTopic() {
        return topic;
    }
    public void setTopic(String topic) {
        this.topic = topic;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getRecordingTime() {
        return recordingTime;
    }
    public void setRecordingTime(String recordingTime) {
        this.recordingTime = recordingTime;
    }
    
    @Override
    public String toString() {
        return "RecordingFileVO [id=" + id + ", recordingStart=" + recordingStart + ", recordingEnd=" + recordingEnd
                + ", fileType=" + fileType + ", playUrl=" + playUrl + ", downloadUrl=" + downloadUrl + ", fileSize="
                + fileSize + ", recordingType=" + recordingType + ", topic=" + topic + ", password=" + password
                + ", recordingTime=" + recordingTime + "]";
    }

}
