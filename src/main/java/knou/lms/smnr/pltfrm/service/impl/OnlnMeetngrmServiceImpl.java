package knou.lms.smnr.pltfrm.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.smnr.pltfrm.dao.OnlnMeetngrmDAO;
import knou.lms.smnr.pltfrm.service.OnlnMeetngrmService;
import knou.lms.smnr.pltfrm.vo.OnlnMeetngrmVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmUserVO;
import knou.lms.smnr.pltfrm.zoom.api.common.ZoomDateUtils;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomMeetingVO;
import knou.lms.smnr.vo.SmnrVO;

@Service("onlnMeetngrmService")
public class OnlnMeetngrmServiceImpl extends ServiceBase implements OnlnMeetngrmService {

	@Resource(name="onlnMeetngrmDAO")
	private OnlnMeetngrmDAO onlnMeetngrmDAO;

	/**
     * 온라인회의실등록
     *
     * @param pltfrmGbncd		플랫폼구분코드
     * @param smnrId			세미나아이디
     * @param OnlnPltfrmUserVO	온라인플랫폼사용자
     * @param Object
     * @throws Exception
     */
	public OnlnMeetngrmVO onlnMeetngrmRegist(String pltfrmGbncd, String smnrId, OnlnPltfrmUserVO user, Object obj) throws Exception {
		OnlnMeetngrmVO vo = new OnlnMeetngrmVO();
		vo.setOnlnMeetngrmId(IdGenUtil.genNewId(IdPrefixType.OPLMT));
		vo.setOnlnPltfrmUserId(user.getOnlnPltfrmUserId());
		vo.setRgtrId(user.getRgtrId());
		vo.setSmnrId(smnrId);

		if("ZOOM".equals(pltfrmGbncd)) {
			ZoomMeetingVO meeting = (ZoomMeetingVO) obj;
			vo.setMeetngrmUrl(meeting.getStartUrl());
			vo.setMeetngrmId(meeting.getId().toString());
			vo.setMeetngrmUuid(meeting.getUuid());
			vo.setMeetngrmPswd(meeting.getPassword());
			vo.setMeetngrmSdttm(ZoomDateUtils.convertToKstLocalDateTime(meeting.getStartTime()));
			vo.setMeetngrmEdttm(ZoomDateUtils.convertToKstEndDateTime(meeting.getStartTime(), meeting.getDuration()));
		}

		// 온라인회의실등록
		onlnMeetngrmDAO.onlnMeetngrmRegist(vo);

		return vo;
	}

	/**
     * 온라인회의실수정
     *
     * @param pltfrmGbncd		플랫폼구분코드
     * @param SmnrVO			세미나정보
     * @throws Exception
     */
	@Override
	public void onlnMeetngrmModify(String pltfrmGbncd, SmnrVO vo) throws Exception {
		OnlnMeetngrmVO meeting = new OnlnMeetngrmVO();
		meeting.setSmnrId(vo.getSmnrId());
		meeting.setMdfrId(vo.getMdfrId());

		if("ZOOM".equals(pltfrmGbncd)) {
			meeting.setMeetngrmSdttm(vo.getSmnrSdttm());
			meeting.setMeetngrmEdttm(vo.getSmnrEdttm());
		}

		// 온라인회의실수정
		onlnMeetngrmDAO.onlnMeetngrmModify(meeting);
	}

}