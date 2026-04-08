package knou.lms.smnr.pltfrm.zoom.api.meetings.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ZoomMeetingVO implements Serializable {

	private static final long serialVersionUID = -1753213825454248216L;

	/** 미팅 ID (응답) */
    @JsonProperty("id")
    private Long id;

    /** 미팅 UUID (응답) */
    @JsonProperty("uuid")
    private String uuid;

    /** 호스트 ID (응답) */
    @JsonProperty("host_id")
    private String hostId;

    /** 호스트 이메일 (응답) */
    @JsonProperty("host_email")
    private String hostEmail;

    /** 미팅 제목 */
    @JsonProperty("topic")
    private String topic;

    /** 미팅 타입 2=예약미팅 (고정) */
    @JsonProperty("type")
    private int type = 2;

    /** 시작일시 (yyyy-MM-dd'T'HH:mm:ss) */
    @JsonProperty("start_time")
    private String startTime;

    /** 진행시간 (분) */
    @JsonProperty("duration")
    private int duration;

    /** 비밀번호 */
    @JsonProperty("password")
    private String password;

    /** 표준시간대 */
    @JsonProperty("timezone")
    private String timezone = "Asia/Seoul";

    /** 설명 */
    @JsonProperty("agenda")
    private String agenda;

    /** 참가 URL (응답) */
    @JsonProperty("join_url")
    private String joinUrl;

    /** 호스트 시작 URL (응답) */
    @JsonProperty("start_url")
    private String startUrl;

    /** 설정 */
    @JsonProperty("settings")
    private ZoomSettingsVO settings;

	public Long getId() {
		return id;
	}

	public String getUuid() {
		return uuid;
	}

	public String getHostId() {
		return hostId;
	}

	public String getHostEmail() {
		return hostEmail;
	}

	public String getTopic() {
		return topic;
	}

	public int getType() {
		return type;
	}

	public String getStartTime() {
		return startTime;
	}

	public int getDuration() {
		return duration;
	}

	public String getPassword() {
		return password;
	}

	public String getTimezone() {
		return timezone;
	}

	public String getAgenda() {
		return agenda;
	}

	public String getJoinUrl() {
		return joinUrl;
	}

	public String getStartUrl() {
		return startUrl;
	}

	public ZoomSettingsVO getSettings() {
		return settings;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public void setHostId(String hostId) {
		this.hostId = hostId;
	}

	public void setHostEmail(String hostEmail) {
		this.hostEmail = hostEmail;
	}

	public void setTopic(String topic) {
		this.topic = topic;
	}

	public void setType(int type) {
		this.type = type;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public void setDuration(int duration) {
		this.duration = duration;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setTimezone(String timezone) {
		this.timezone = timezone;
	}

	public void setAgenda(String agenda) {
		this.agenda = agenda;
	}

	public void setJoinUrl(String joinUrl) {
		this.joinUrl = joinUrl;
	}

	public void setStartUrl(String startUrl) {
		this.startUrl = startUrl;
	}

	public void setSettings(ZoomSettingsVO settings) {
		this.settings = settings;
	}

}
