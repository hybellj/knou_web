package knou.lms.smnr.pltfrm.zoom.api.users.service;

import knou.lms.smnr.pltfrm.zoom.api.users.vo.ZoomUserListVO;

public interface ZoomUserService {

	// ZOOM사용자목록조회
	public ZoomUserListVO zoomUserList(String authrtTkn) throws Exception;

}
