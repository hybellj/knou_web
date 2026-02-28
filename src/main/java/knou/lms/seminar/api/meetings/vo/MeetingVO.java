package knou.lms.seminar.api.meetings.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

import knou.framework.util.StringUtil;

public class MeetingVO implements Serializable {

    private static final long serialVersionUID = -7131014984219750921L;
    @JsonProperty("id")
    private long id;
    @JsonProperty("topic")
    private String topic;
    @JsonProperty("type")
    private String type;
    @JsonProperty("start_time")
    private String startTime;
    @JsonProperty("duration")
    private String duration;
    @JsonProperty("agenda")
    private String agenda;
    @JsonProperty("start_url")
    private String startUrl;
    @JsonProperty("join_url")
    private String joinUrl;
    @JsonProperty("password")
    private String password;
    @JsonProperty("uuid")
    private String uuid;
    @JsonProperty("settings")
    private SettingsVO settings;

    @JsonProperty("timezone")
    private String timezone;
    @JsonProperty("end_time")
    private String endTime;
    @JsonProperty("host_id")
    private String hostId;
        
    
    public String getTimezone() {
        return timezone;
    }

    public void setTimezone(String timezone) {
        this.timezone = timezone;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getHostId() {
        return hostId;
    }

    public void setHostId(String hostId) {
        this.hostId = hostId;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getAgenda() {
        return agenda;
    }

    public void setAgenda(String agenda) {
        this.agenda = agenda;
    }

    public String getStartUrl() {
        return startUrl;
    }

    public void setStartUrl(String startUrl) {
        this.startUrl = startUrl;
    }

    public String getJoinUrl() {
        return joinUrl;
    }

    public void setJoinUrl(String joinUrl) {
        this.joinUrl = joinUrl;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public SettingsVO getSettings() {
        return settings;
    }

    public void setSettings(SettingsVO settings) {
        this.settings = settings;
    }

    // Error 로그출력용
    @Override
    public String toString() {
        return "MeetingVO [id=" + id + ", topic=" + topic + ", type=" + type + ", startTime=" + startTime
                + ", duration=" + duration + ", agenda=" + agenda + ", startUrl=" + startUrl + ", joinUrl=" + joinUrl
                + ", password=" + password + ", uuid=" + uuid + ", settings=" + StringUtil.nvl(settings).toString() + ", timezone=" + timezone
                + ", endTime=" + endTime + ", hostId=" + hostId + "]";
    }

}
