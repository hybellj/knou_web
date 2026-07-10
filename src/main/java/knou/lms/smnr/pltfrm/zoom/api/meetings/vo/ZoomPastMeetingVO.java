package knou.lms.smnr.pltfrm.zoom.api.meetings.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ZoomPastMeetingVO implements Serializable {

	private static final long serialVersionUID = -4990712135275873600L;

	/** 미팅 UUID */
    @JsonProperty("uuid")
    private String uuid;

    /** 미팅 ID */
    @JsonProperty("id")
    private Long id;

    /** 실제 시작일시 (UTC) */
    @JsonProperty("start_time")
    private String startTime;

    /** 실제 종료일시 (UTC) */
    @JsonProperty("end_time")
    private String endTime;

    /** 실제 진행시간 (분) */
    @JsonProperty("duration")
    private int duration;

    /** 총 참가자 수 */
    @JsonProperty("participants_count")
    private int participantsCount;

	public String getUuid() {
		return uuid;
	}

	public Long getId() {
		return id;
	}

	public String getStartTime() {
		return startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public int getDuration() {
		return duration;
	}

	public int getParticipantsCount() {
		return participantsCount;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public void setDuration(int duration) {
		this.duration = duration;
	}

	public void setParticipantsCount(int participantsCount) {
		this.participantsCount = participantsCount;
	}
}
