package knou.lms.smnr.pltfrm.zoom.service;

import java.util.List;

import knou.lms.common.dto.ResultDTO;
import knou.lms.smnr.pltfrm.vo.OnlnMeetngrmVO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomMeetingVO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomPastMeetingVO;
import knou.lms.smnr.vo.SmnrTeamVO;
import knou.lms.smnr.vo.SmnrTrgtrVO;
import knou.lms.smnr.vo.SmnrVO;

public interface ZoomApiService {

	// ZOOM사용자일괄등록
	public int zoomUserBulkRegist(String orgId, String userId);

	// ZOOM회의실등록
	public ResultDTO<OnlnMeetngrmVO> zoomMeetingRegist(SmnrVO vo, List<SmnrTeamVO> teamList);

	// ZOOM회의실수정
	public ResultDTO<OnlnMeetngrmVO> zoomMeetingModify(SmnrVO vo, String meetngrmId, List<SmnrTeamVO> teamList);

	// ZOOM회의실삭제
	public void zoomMeetingDelete(SmnrVO vo, String meetngrmId);

	// ZOOM회의실조회
	public ResultDTO<ZoomMeetingVO> zoomMeetingSelect(SmnrVO vo);

	// ZOOM참여자URL조회
	public ResultDTO<SmnrTrgtrVO> zoomUserUrlSelect(SmnrVO vo);

	// ZOOM과거미팅조회
	public ResultDTO<ZoomPastMeetingVO> zoomPastMeetingSelect(SmnrVO vo);

}
