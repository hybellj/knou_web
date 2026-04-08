package knou.lms.smnr.pltfrm.zoom.api.meetings.service.impl;

import java.net.URI;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.smnr.pltfrm.zoom.api.common.ZoomRestTemplateSupporter;
import knou.lms.smnr.pltfrm.zoom.api.meetings.MeetingsUrl;
import knou.lms.smnr.pltfrm.zoom.api.meetings.service.ZoomMeetingService;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomMeetingVO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomRegistrantVO;

@Service("zoomMeetingService")
public class ZoomMeetingServiceImpl extends ServiceBase implements ZoomMeetingService {

	@Autowired
	private ZoomRestTemplateSupporter zoomRestTemplateSupporter;

	// ZOOM미팅등록
	@Override
	public ZoomMeetingVO zoomMeetingRegist(String authrtTkn, String hostEml, ZoomMeetingVO meeting) throws Exception {
		URI uri = URI.create(MeetingsUrl.CREATE_A_MEETING.getUrl(hostEml));

	    ResponseEntity<ZoomMeetingVO> response = zoomRestTemplateSupporter.exchange(
	    		authrtTkn, MeetingsUrl.CREATE_A_MEETING, uri, meeting, ZoomMeetingVO.class);

	    if (response.getStatusCode() != HttpStatus.CREATED) {
	        throw new RuntimeException("미팅 생성 실패 [" + response.getStatusCode() + "]");
	    }

	    return response.getBody();
	}

	// ZOOM미팅수정
	public void zoomMeetingModify(String authrtTkn, String meetngrmId, ZoomMeetingVO reqVO) {
	    URI uri = URI.create(MeetingsUrl.UPDATE_A_MEETING.getUrl(meetngrmId));

	    ResponseEntity<Void> response = zoomRestTemplateSupporter.exchange(
	    		authrtTkn, MeetingsUrl.UPDATE_A_MEETING, uri, reqVO, Void.class);

	    if (response.getStatusCode() != HttpStatus.NO_CONTENT) {
	        throw new RuntimeException("미팅 수정 실패 [" + response.getStatusCode() + "]");
	    }
	}

	// ZOOM미팅삭제
	@Override
	public void zoomMeetingDelete(String authrtTkn, String meetngrmId) throws Exception {
		URI uri = URI.create(MeetingsUrl.DELETE_A_MEETING.getUrl(meetngrmId));

	    ResponseEntity<Void> response = zoomRestTemplateSupporter.exchange(
	    		authrtTkn, MeetingsUrl.DELETE_A_MEETING, uri, Void.class);

	    if (response.getStatusCode() != HttpStatus.NO_CONTENT) {
	        throw new RuntimeException("미팅 삭제 실패 [" + response.getStatusCode() + "]");
	    }
	}

	// ZOOM미팅참여자사전등록
	@Override
	public ZoomRegistrantVO zoomRegistrantRegist(String authrtTkn, String meetngrmId, ZoomRegistrantVO reqVO) throws Exception {
	    URI uri = URI.create(MeetingsUrl.ADD_MEETING_REGISTRANT.getUrl(meetngrmId));

	    ResponseEntity<ZoomRegistrantVO> response = zoomRestTemplateSupporter.exchange(
	    		authrtTkn, MeetingsUrl.ADD_MEETING_REGISTRANT, uri, reqVO, ZoomRegistrantVO.class);

	    if (response.getStatusCode() != HttpStatus.CREATED) {
	        throw new RuntimeException("사전등록 실패 [" + response.getStatusCode() + "]");
	    }

	    return response.getBody();
	}

	// ZOOM미팅조회
	@Override
	public ZoomMeetingVO zoomMeetingSelect(String authrtTkn, String meetngrmId) throws Exception {
		URI uri = URI.create(MeetingsUrl.GET_A_MEETING.getUrl(meetngrmId));

	    ResponseEntity<ZoomMeetingVO> response = zoomRestTemplateSupporter.exchange(
	            authrtTkn, MeetingsUrl.GET_A_MEETING, uri, null, ZoomMeetingVO.class);

	    if (response.getStatusCode() != HttpStatus.OK) {
	        throw new RuntimeException("미팅 조회 실패 [" + response.getStatusCode() + "]");
	    }

	    return response.getBody();
	}

}
