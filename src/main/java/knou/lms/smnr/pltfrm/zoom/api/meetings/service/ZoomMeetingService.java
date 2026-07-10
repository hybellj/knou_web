package knou.lms.smnr.pltfrm.zoom.api.meetings.service;

import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomMeetingVO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomPastMeetingVO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomRegistrantVO;

public interface ZoomMeetingService {

	// ZOOM미팅등록
	public ZoomMeetingVO zoomMeetingRegist(String authrtTkn, String hostEml, ZoomMeetingVO reqVO);

	// ZOOM미팅수정
	public void zoomMeetingModify(String authrtTkn, String meetngrmId, ZoomMeetingVO reqVO);

	// ZOOM미팅삭제
	public void zoomMeetingDelete(String authrtTkn, String meetngrmId);

	// ZOOM미팅참여자사전등록
	public ZoomRegistrantVO zoomRegistrantRegist(String authrtTkn, String meetngrmId, ZoomRegistrantVO reqVO);

	// ZOOM미팅조회
	public ZoomMeetingVO zoomMeetingSelect(String authrtTkn, String meetngrmId);

	// ZOOM과거미팅조회
	public ZoomPastMeetingVO zoomPastMeetingSelect(String authrtTkn, String meetngrmId);

}