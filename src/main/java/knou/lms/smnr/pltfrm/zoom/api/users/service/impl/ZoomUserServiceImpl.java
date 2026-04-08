package knou.lms.smnr.pltfrm.zoom.api.users.service.impl;

import java.net.URI;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.smnr.pltfrm.zoom.api.common.ZoomRestTemplateSupporter;
import knou.lms.smnr.pltfrm.zoom.api.users.UsersUrl;
import knou.lms.smnr.pltfrm.zoom.api.users.service.ZoomUserService;
import knou.lms.smnr.pltfrm.zoom.api.users.vo.ZoomUserListVO;

@Service("zoomUserService")
public class ZoomUserServiceImpl extends ServiceBase implements ZoomUserService {

	@Autowired
	private ZoomRestTemplateSupporter zoomRestTemplateSupporter;

	// ZOOM사용자목록조회
	@Override
	public ZoomUserListVO zoomUserList(String authrtTkn) throws Exception {
		URI uri = URI.create(UsersUrl.LIST_USERS.getUrl());

        ResponseEntity<ZoomUserListVO> response = zoomRestTemplateSupporter.exchangePageList(
        		authrtTkn, UsersUrl.LIST_USERS, uri, ZoomUserListVO.class);

        if (response.getStatusCode() != HttpStatus.OK) {
            throw new RuntimeException("사용자 목록 조회 실패 [" + response.getStatusCode() + "]");
        }

        return response.getBody();
	}

}
