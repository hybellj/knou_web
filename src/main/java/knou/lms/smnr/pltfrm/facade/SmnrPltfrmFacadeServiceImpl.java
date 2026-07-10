package knou.lms.smnr.pltfrm.facade;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.org.service.OrgService;
import knou.lms.smnr.pltfrm.service.OnlnMeetngrmService;
import knou.lms.smnr.pltfrm.service.OnlnPltfrmAuthrtService;
import knou.lms.smnr.pltfrm.service.OnlnPltfrmStngService;
import knou.lms.smnr.pltfrm.service.OnlnPltfrmUserService;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmStngVO;
import knou.lms.smnr.pltfrm.web.view.SmnrPltfrmMainView;
import knou.lms.smnr.pltfrm.zoom.service.ZoomApiService;
import knou.lms.smnr.web.view.SmnrPageInfo;

@Service("smnrPltfrmFacadeService")
public class SmnrPltfrmFacadeServiceImpl extends ServiceBase implements SmnrPltfrmFacadeService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SmnrPltfrmFacadeServiceImpl.class);

	@Resource(name="onlnPltfrmStngService")
	private OnlnPltfrmStngService onlnPltfrmStngService;

	@Resource(name="onlnPltfrmAuthrtService")
	private OnlnPltfrmAuthrtService onlnPltfrmAuthrtService;

	@Resource(name="onlnPltfrmUserService")
	private OnlnPltfrmUserService onlnPltfrmUserService;

	@Resource(name="onlnMeetngrmService")
	private OnlnMeetngrmService onlnMeetngrmService;

	@Resource(name="orgService")
	private OrgService orgService;

	@Resource(name="zoomApiService2")
	private ZoomApiService zoomApiService;

	@Override
	public SmnrPltfrmMainView loadAdmZoomAuthrtUserMngView() {
		SmnrPltfrmMainView smnrPltfrmMainView = new SmnrPltfrmMainView();

		// 기관목록조회
		smnrPltfrmMainView.setOrgList(orgService.orgListSelect());

		return smnrPltfrmMainView;
	}

	@Override
	public SmnrPltfrmMainView getOnlnPltfrmAuthrtList(OnlnPltfrmStngVO vo, SmnrPageInfo pageInfo) {
		SmnrPltfrmMainView smnrPltfrmMainView = new SmnrPltfrmMainView();

		// 온라인플랫폼권한목록조회
		smnrPltfrmMainView.setOnlnPltfrmAuthrtList(onlnPltfrmAuthrtService.onlnPltfrmAuthrtList(vo));

		// 온라인플랫폼기관사용자목록
		smnrPltfrmMainView.setResultDTO(onlnPltfrmUserService.onlnPltfrmOrgUserList(pageInfo));

		return smnrPltfrmMainView;
	}

	@Override
	public SmnrPltfrmMainView loadAdmAcntRegistPopup() {
		SmnrPltfrmMainView smnrPltfrmMainView = new SmnrPltfrmMainView();

		// 기관목록조회
		smnrPltfrmMainView.setOrgList(orgService.orgListSelect());

		return smnrPltfrmMainView;
	}

	@Override
	public SmnrPltfrmMainView admAcntRegist(OnlnPltfrmStngVO vo) {
		SmnrPltfrmMainView smnrPltfrmMainView = new SmnrPltfrmMainView();

		// 온라인플랫폼설정등록
		smnrPltfrmMainView.setResultDTO(onlnPltfrmStngService.onlnPltfrmStngRegist(vo));

		return smnrPltfrmMainView;
	}

	@Override
	public void admAtncDelete(OnlnPltfrmStngVO vo) {
		// 온라인회의실일괄삭제
		onlnMeetngrmService.onlnMeetngrmBulkDelete(vo.getOnlnPltfrmStngId());

		// 온라인플랫폼사용자일괄삭제
		onlnPltfrmUserService.onlnPltfrmUserBulkDelete(vo.getOnlnPltfrmStngId());

		// 온라인플랫폼권한일괄삭제
		onlnPltfrmAuthrtService.onlnPltfrmAuthrtBulkDelete(vo.getOnlnPltfrmStngId());

		// 온라인플랫폼설정삭제
		onlnPltfrmStngService.onlnPltfrmStngDelete(vo);
	}

	@Override
	public int createZoomCntSelect(OnlnPltfrmStngVO vo) {
		// 생성ZOOM수조회
		return onlnMeetngrmService.createZoomCntSelect(vo.getOnlnPltfrmStngId());
	}

	@Override
	public SmnrPltfrmMainView loadAdmZoomAuthrtListSyncPopup(OnlnPltfrmStngVO vo) {
		SmnrPltfrmMainView smnrPltfrmMainView = new SmnrPltfrmMainView();

		// 온라인플랫폼권한목록
		smnrPltfrmMainView.setOnlnPltfrmAuthrtList(onlnPltfrmAuthrtService.onlnPltfrmAuthrtList(vo));

		return smnrPltfrmMainView;
	}

	@Override
	public int getPendingOnlnPltfrmUserCntSelect(List<Map<String, Object>> subSmnrs) {
		// 대기중온라인플랫폼사용자수조회
		return onlnPltfrmUserService.pendingOnlnPltfrmUserCntSelect(subSmnrs);
	}

	@Override
	public int zoomUserBulkRegist(OnlnPltfrmStngVO vo) {
		// ZOOM사용자일괄등록
		return zoomApiService.zoomUserBulkRegist(vo.getOrgId(), vo.getUserId());
	}

}
