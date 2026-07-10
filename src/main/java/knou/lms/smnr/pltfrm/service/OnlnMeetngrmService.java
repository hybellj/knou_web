package knou.lms.smnr.pltfrm.service;

import knou.lms.smnr.pltfrm.vo.OnlnMeetngrmVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmUserVO;
import knou.lms.smnr.vo.SmnrVO;

public interface OnlnMeetngrmService {

	// 온라인회의실등록
	public OnlnMeetngrmVO onlnMeetngrmRegist(String pltfrmGbncd, String smnrId, OnlnPltfrmUserVO user, Object obj);

	// 온라인회의실수정
	public void onlnMeetngrmModify(String pltfrmGbncd, SmnrVO vo);

	// 생성ZOOM수조회
	public int createZoomCntSelect(String onlnPltfrmStngId);

	// 온라인회의실일괄삭제
	public void onlnMeetngrmBulkDelete(String onlnPltfrmStngId);

}
