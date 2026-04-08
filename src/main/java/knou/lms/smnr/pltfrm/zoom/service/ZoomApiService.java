package knou.lms.smnr.pltfrm.zoom.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.smnr.pltfrm.vo.OnlnMeetngrmVO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomMeetingVO;
import knou.lms.smnr.vo.SmnrTeamVO;
import knou.lms.smnr.vo.SmnrVO;

public interface ZoomApiService {

	// ZOOM사용자일괄등록
	public void zoomUserBulkRegist(String orgId, String userId) throws Exception;

	// ZOOM회의실등록
	public ProcessResultVO<OnlnMeetngrmVO> zoomMeetingRegist(SmnrVO vo, List<SmnrTeamVO> teamList) throws Exception;

	// ZOOM회의실수정
	public ProcessResultVO<OnlnMeetngrmVO> zoomMeetingModify(SmnrVO vo, String meetngrmId, List<SmnrTeamVO> teamList) throws Exception;

	// ZOOM회의실삭제
	public void zoomMeetingDelete(SmnrVO vo, String meetngrmId) throws Exception;

	// ZOOM회의실조회
	public ProcessResultVO<ZoomMeetingVO> zoomMeetingSelect(SmnrVO vo) throws Exception;

}
