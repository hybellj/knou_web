package knou.lms.smnr.pltfrm.zoom.api.meetings.vo;

import java.io.Serializable;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ZoomBreakoutRoomInfoVO implements Serializable {

	private static final long serialVersionUID = -8956768197909373548L;

	/** 소회의실 이름 */
    @JsonProperty("name")
    private String name;

    /** 사전 배정 참가자 이메일 목록 */
    @JsonProperty("participants")
    private List<String> participants;

	public String getName() {
		return name;
	}

	public List<String> getParticipants() {
		return participants;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setParticipants(List<String> participants) {
		this.participants = participants;
	}

}
