package knou.lms.smnr.pltfrm.zoom.api.meetings.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ZoomSettingsVO implements Serializable {

	private static final long serialVersionUID = -4181912690925899292L;

	/** 자동녹화 none=안함, local=로컬, cloud=클라우드 */
    @JsonProperty("auto_recording")
    private String autoRecording = "none";

    /** 소회의실 설정 */
    @JsonProperty("breakout_room")
    private ZoomBreakoutRoomVO breakoutRoom;

	public String getAutoRecording() {
		return autoRecording;
	}
	public void setAutoRecording(String autoRecording) {
		this.autoRecording = autoRecording;
	}
	public ZoomBreakoutRoomVO getBreakoutRoom() {
		return breakoutRoom;
	}
	public void setBreakoutRoom(ZoomBreakoutRoomVO breakoutRoom) {
		this.breakoutRoom = breakoutRoom;
	}

}
