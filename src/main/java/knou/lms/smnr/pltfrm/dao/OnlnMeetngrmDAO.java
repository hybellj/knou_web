package knou.lms.smnr.pltfrm.dao;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.smnr.pltfrm.vo.OnlnMeetngrmVO;

@Mapper("onlnMeetngrmDAO")
public interface OnlnMeetngrmDAO {

	// 온라인회의실등록
	public void onlnMeetngrmRegist(OnlnMeetngrmVO vo);

	// 온라인회의실수정
	public void onlnMeetngrmModify(OnlnMeetngrmVO vo);

	// 온라인회의실삭제
	public void onlnMeetngrmDelete(@Param("smnrId") String smnrId, @Param("meetngrmId") String meetngrmId);

	// 생성ZOOM수조회
	public int createZoomCntSelect(@Param("onlnPltfrmStngId") String onlnPltfrmStngId);

	// 온라인회의실일괄삭제
	public void onlnMeetngrmBulkDelete(@Param("onlnPltfrmStngId") String onlnPltfrmStngId);

}
