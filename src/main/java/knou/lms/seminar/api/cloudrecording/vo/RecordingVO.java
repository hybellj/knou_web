package knou.lms.seminar.api.cloudrecording.vo;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public class RecordingVO {
    
    @JsonProperty("id")
    private Long id;
    @JsonProperty("uuid")
    private String uuid;
    @JsonProperty("host_id")
    private String hostId;
    @JsonProperty("topic")
    private String topic;
    @JsonProperty("recording_files")
    private List<RecordingFileVO> recordingFiles;
    @JsonProperty("host_email")
    private String hostEmail;
    @JsonProperty("password")
    private String password;
    @JsonProperty("share_url")
    private String shareUrl;
    @JsonProperty("recording_play_passcode")
    private String recordingPlayPasscode;
    
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public String getUuid() {
        return uuid;
    }
    public void setUuid(String uuid) {
        this.uuid = uuid;
    }
    public String getHostId() {
        return hostId;
    }
    public void setHostId(String hostId) {
        this.hostId = hostId;
    }
    public String getTopic() {
        return topic;
    }
    public void setTopic(String topic) {
        this.topic = topic;
    }
    public List<RecordingFileVO> getRecordingFiles() {
        return recordingFiles;
    }
    public void setRecordingFiles(List<RecordingFileVO> recordingFiles) {
        this.recordingFiles = recordingFiles;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getShareUrl() {
        return shareUrl;
    }
    public void setShareUrl(String shareUrl) {
        this.shareUrl = shareUrl;
    }
    public String getRecordingPlayPasscode() {
        return recordingPlayPasscode;
    }
    public void setRecordingPlayPasscode(String recordingPlayPasscode) {
        this.recordingPlayPasscode = recordingPlayPasscode;
    }
    
    @Override
    public String toString() {
        return "RecordingVO [id=" + id + ", uuid=" + uuid + ", hostId=" + hostId + ", topic=" + topic
                + ", recordingFiles=" + recordingFiles + ", hostEmail=" + hostEmail + ", password=" + password
                + ", shareUrl=" + shareUrl + ", recordingPlayPasscode=" + recordingPlayPasscode + "]";
    }

}
