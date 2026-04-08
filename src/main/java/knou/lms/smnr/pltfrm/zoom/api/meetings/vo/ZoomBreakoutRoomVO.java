package knou.lms.smnr.pltfrm.zoom.api.meetings.vo;

import java.io.Serializable;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ZoomBreakoutRoomVO implements Serializable {

	private static final long serialVersionUID = -1350812010408118013L;

	/** 소회의실 활성화 여부 */
    @JsonProperty("enable")
    private boolean enable;

    /** 소회의실 목록 */
    @JsonProperty("rooms")
    private List<ZoomBreakoutRoomInfoVO> rooms;

	public boolean isEnable() {
		return enable;
	}

	public List<ZoomBreakoutRoomInfoVO> getRooms() {
		return rooms;
	}

	public void setEnable(boolean enable) {
		this.enable = enable;
	}

	public void setRooms(List<ZoomBreakoutRoomInfoVO> rooms) {
		this.rooms = rooms;
	}

}
