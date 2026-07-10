package knou.lms.smnr.pltfrm.zoom.service.impl;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.jsoup.Jsoup;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.smnr.dao.SmnrTrgtrDAO;
import knou.lms.smnr.pltfrm.service.OnlnMeetngrmService;
import knou.lms.smnr.pltfrm.service.OnlnPltfrmAuthrtService;
import knou.lms.smnr.pltfrm.service.OnlnPltfrmUserService;
import knou.lms.smnr.pltfrm.vo.OnlnMeetngrmVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmAuthrtVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmUserVO;
import knou.lms.smnr.pltfrm.zoom.api.common.ZoomDateUtils;
import knou.lms.smnr.pltfrm.zoom.api.meetings.service.ZoomMeetingService;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomBreakoutRoomInfoVO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomBreakoutRoomVO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomMeetingVO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomPastMeetingVO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomRegistrantVO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomSettingsVO;
import knou.lms.smnr.pltfrm.zoom.service.ZoomApiService;
import knou.lms.smnr.service.SmnrAtndHstryService;
import knou.lms.smnr.service.SmnrAtndService;
import knou.lms.smnr.service.SmnrService;
import knou.lms.smnr.vo.SmnrAtndVO;
import knou.lms.smnr.vo.SmnrTeamVO;
import knou.lms.smnr.vo.SmnrTrgtrVO;
import knou.lms.smnr.vo.SmnrVO;

@Service("zoomApiService2")
public class ZoomApiServiceImpl extends ServiceBase implements ZoomApiService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ZoomApiService.class);

	@Resource(name="smnrService")
	private SmnrService smnrService;

	@Resource(name="onlnPltfrmAuthrtService")
	private OnlnPltfrmAuthrtService onlnPltfrmAuthrtService;

	@Resource(name="onlnPltfrmUserService")
	private OnlnPltfrmUserService onlnPltfrmUserService;

	@Resource(name="onlnMeetngrmService")
	private OnlnMeetngrmService onlnMeetngrmService;

	@Resource(name="zoomMeetingService")
	private ZoomMeetingService zoomMeetingService;

	@Resource(name="smnrTrgtrDAO")
	private SmnrTrgtrDAO smnrTrgtrDAO;

	@Resource(name="smnrAtndHstryService")
	private SmnrAtndHstryService smnrAtndHstryService;

	@Resource(name="smnrAtndService")
	private SmnrAtndService smnrAtndService;

	// ZOOM사용자일괄등록 (라이센스인 사용자)
	@Override
	public int zoomUserBulkRegist(String orgId, String userId) {
		// 온라인플랫폼권한갱신
		OnlnPltfrmAuthrtVO authrtVO = onlnPltfrmAuthrtService.onlnPltfrmAuthrtUpdt("ZOOM", orgId, userId);

		// 온라인플랫폼사용자일괄등록
		return onlnPltfrmUserService.onlnPltfrmUserBulkRegist(authrtVO, userId);
	}

	// ZOOM회의실등록
	@Override
	public ResultDTO<OnlnMeetngrmVO> zoomMeetingRegist(SmnrVO vo, List<SmnrTeamVO> teamList) {
		ResultDTO<OnlnMeetngrmVO> resultVO = new ResultDTO<OnlnMeetngrmVO>();

		// 온라인플랫폼권한갱신
		OnlnPltfrmAuthrtVO authrtVO = onlnPltfrmAuthrtService.onlnPltfrmAuthrtUpdt("ZOOM", vo.getOrgId(), vo.getRgtrId());

		ZoomMeetingVO meeting = new ZoomMeetingVO();
		ZoomSettingsVO setting = new ZoomSettingsVO();
		// ZOOM회의제목 길이제한시 수정 ( MAX 200자 )
		String topic = StringUtil.nvl(vo.getSmnrnm());
		if(topic.length() >= 190) {
			topic = topic.substring(0, 190) + "...";
		}
		meeting.setTopic(topic);
		// ZOOM회의비밀번호 ( yyMMdd 자동설정 )
		LocalDate today = LocalDate.now();
		meeting.setPassword(today.format(DateTimeFormatter.ofPattern("yyMMdd")));
		// ZOOM회의설명
		meeting.setAgenda(Jsoup.parse(StringUtil.nvl(vo.getSmnrCts())).text());
		// ZOOM회의시작일시
		meeting.setStartTime(ZoomDateUtils.convertToIsoLocalDateTime(vo.getSmnrSdttm()));
		// ZOOM회의시간
		meeting.setDuration(vo.getSmnrMnts());
		// ZOOM회의녹화 ( cloud : 클라우드, none : 미녹화 )
		setting.setAutoRecording("Y".equals(vo.getAutoRcdyn()) ? "cloud" : "none");
		// 팀 세미나인경우 소회의실
		if("Y".equals(vo.getByteamSubsmnrUseyn())) {
			// 세미나대상수강생목록
			List<EgovMap> userList = smnrService.smnrTrgtAtndlcUserList(vo);

			// 소회의실 생성
			List<ZoomBreakoutRoomInfoVO> rooms = teamList.stream()
			    .map(team -> {
			        ZoomBreakoutRoomInfoVO room = new ZoomBreakoutRoomInfoVO();
			        room.setName(team.getSubParam());
			        List<String> participants = userList.stream()
			            .filter(user -> user.get("teamId").toString().equals(team.getTeamId()))
			            .map(user -> (String) user.get("userId") + "@knou.ac.kr")
			            .collect(Collectors.toList());
			        room.setParticipants(participants);
			        return room;
			    })
			    .collect(Collectors.toList());

			ZoomBreakoutRoomVO breakoutRoom = new ZoomBreakoutRoomVO();
			breakoutRoom.setEnable(true);
			breakoutRoom.setRooms(rooms);

			setting.setBreakoutRoom(breakoutRoom);
		}
		// ZOOM회의옵션
		meeting.setSettings(setting);

		OnlnPltfrmUserVO userVO = onlnPltfrmUserService.pendingOnlnPltfrmUserSelect(authrtVO.getOnlnPltfrmStngId(), vo.getSmnrSdttm(), vo.getSmnrEdttm());
		userVO.setRgtrId(vo.getRgtrId());

		// ZOOM회의등록
		ZoomMeetingVO regist = zoomMeetingService.zoomMeetingRegist(authrtVO.getAuthrtTkn(), userVO.getPltfrmUserEml(), meeting);
		if(regist.getPassword() == null) regist.setPassword(meeting.getPassword());

		try {
			// 온라인회의실등록
			OnlnMeetngrmVO meetngrm = onlnMeetngrmService.onlnMeetngrmRegist("ZOOM", vo.getSmnrId(), userVO, regist);

			// 세미나대상수강생목록
			List<EgovMap> userList = smnrService.smnrTrgtAtndlcUserList(vo);
			// 일괄등록용 사용자목록
	        List<SmnrTrgtrVO> trgtrList = new ArrayList<SmnrTrgtrVO>();
			for(EgovMap map : userList) {
				String smnrId = map.get("smnrId").toString();
				String userId = map.get("userId").toString();
				// ZOOM미팅참여자사전등록 ( pro기능 )
				ZoomRegistrantVO registrantVO = new ZoomRegistrantVO();
				registrantVO.setEmail(userId + "@knou.ac.kr");
				registrantVO.setFirstName(map.get("usernm").toString().substring(0, 1));
				registrantVO.setLastName(map.get("usernm").toString().substring(1));
				ZoomRegistrantVO respVO = zoomMeetingService.zoomRegistrantRegist(authrtVO.getAuthrtTkn(), regist.getId().toString(), registrantVO);

				SmnrTrgtrVO trgtr = new SmnrTrgtrVO();
				trgtr.setSmnrTrgtrId(IdGenUtil.genNewId(IdPrefixType.SMTGT));
				trgtr.setSmnrId(smnrId);
				trgtr.setUserId(userId);
				trgtr.setOnlnMeetngrmId(meetngrm.getOnlnMeetngrmId());
				trgtr.setTrgtrCntnUrl(respVO.getJoinUrl());
				trgtr.setPreregyn("Y");
				trgtr.setRgtrId(vo.getRgtrId());
				trgtrList.add(trgtr);
			}
			if(trgtrList.size() > 0) smnrTrgtrDAO.smnrTrgtrBulkRegist(trgtrList);	// 세미나대상자일괄등록
			resultVO.setData(meetngrm);
			resultVO.setResultSuccess();
		} catch(Exception e) {
			// ZOOM회의삭제
			zoomMeetingService.zoomMeetingDelete(authrtVO.getAuthrtTkn(), regist.getId().toString());
			resultVO.setMessage("온라인회의실 등록 중 에러가 발생하였습니다.");
			resultVO.setResultFailed();
		}

		return resultVO;
	}

	// ZOOM회의실수정
	@Override
	public ResultDTO<OnlnMeetngrmVO> zoomMeetingModify(SmnrVO vo, String meetngrmId, List<SmnrTeamVO> teamList) {
		// 온라인플랫폼권한갱신
		OnlnPltfrmAuthrtVO authrtVO = onlnPltfrmAuthrtService.onlnPltfrmAuthrtUpdt("ZOOM", vo.getOrgId(), vo.getRgtrId());

		ZoomMeetingVO meeting = new ZoomMeetingVO();
		ZoomSettingsVO setting = new ZoomSettingsVO();
		// ZOOM회의제목 길이제한시 수정 ( MAX 200자 )
		String topic = StringUtil.nvl(vo.getSmnrnm());
		if(topic.length() >= 190) {
			topic = topic.substring(0, 190) + "...";
		}
		meeting.setTopic(topic);
		// ZOOM회의설명
		meeting.setAgenda(Jsoup.parse(StringUtil.nvl(vo.getSmnrCts())).text());
		// ZOOM회의시작일시
		meeting.setStartTime(ZoomDateUtils.convertToIsoLocalDateTime(vo.getSmnrSdttm()));
		// ZOOM회의시간
		meeting.setDuration(vo.getSmnrMnts());
		// ZOOM회의녹화 ( cloud : 클라우드, none : 미녹화 )
		//setting.setAutoRecording("Y".equals(vo.getAutoRcdyn()) ? "cloud" : "none");
		setting.setAutoRecording("none");
		// 팀 세미나인경우 소회의실 활성화
		if("Y".equals(vo.getByteamSubsmnrUseyn())) {
			// 세미나대상수강생목록
			List<EgovMap> userList = smnrService.smnrTrgtAtndlcUserList(vo);

			// 소회의실 생성
			List<ZoomBreakoutRoomInfoVO> rooms = teamList.stream()
			    .map(team -> {
			        ZoomBreakoutRoomInfoVO room = new ZoomBreakoutRoomInfoVO();
			        room.setName(team.getSubParam());
			        List<String> participants = userList.stream()
			            .filter(user -> user.get("teamId").toString().equals(team.getTeamId()))
			            .map(user -> (String) user.get("userId") + "@knou.ac.kr")
			            .collect(Collectors.toList());
			        room.setParticipants(participants);
			        return room;
			    })
			    .collect(Collectors.toList());

			ZoomBreakoutRoomVO breakoutRoom = new ZoomBreakoutRoomVO();
			breakoutRoom.setEnable(true);
			breakoutRoom.setRooms(rooms);

			setting.setBreakoutRoom(breakoutRoom);
		// 일반 세미나인경우 소회의실 비활성화
		} else {
			ZoomBreakoutRoomVO breakoutRoom = new ZoomBreakoutRoomVO();
			breakoutRoom.setEnable(false);
			breakoutRoom.setRooms(new ArrayList<>());

			setting.setBreakoutRoom(breakoutRoom);
		}
		// ZOOM회의옵션
		meeting.setSettings(setting);

		OnlnPltfrmUserVO userVO = onlnPltfrmUserService.pendingOnlnPltfrmUserSelect(authrtVO.getOnlnPltfrmStngId(), vo.getSmnrSdttm(), vo.getSmnrEdttm());
		userVO.setRgtrId(vo.getRgtrId());

		// ZOOM회의수정
		zoomMeetingService.zoomMeetingModify(authrtVO.getAuthrtTkn(), meetngrmId, meeting);

		// 온라인회의실수정
		onlnMeetngrmService.onlnMeetngrmModify("ZOOM", vo);

		return new ResultDTO<OnlnMeetngrmVO>().setResultSuccess();
	}

	// ZOOM회의실삭제
	@Override
	public void zoomMeetingDelete(SmnrVO vo, String meetngrmId) {
		// 온라인플랫폼권한갱신
		OnlnPltfrmAuthrtVO authrtVO = onlnPltfrmAuthrtService.onlnPltfrmAuthrtUpdt("ZOOM", vo.getOrgId(), vo.getRgtrId());

		// ZOOM회의삭제
		zoomMeetingService.zoomMeetingDelete(authrtVO.getAuthrtTkn(), meetngrmId);
	}

	// ZOOM회의실조회
	@Override
	public ResultDTO<ZoomMeetingVO> zoomMeetingSelect(SmnrVO vo) {
		// 온라인플랫폼권한갱신
		OnlnPltfrmAuthrtVO authrtVO = onlnPltfrmAuthrtService.onlnPltfrmAuthrtUpdt("ZOOM", vo.getOrgId(), vo.getRgtrId());

		// 세미나정보조회
		EgovMap smnr = smnrService.smnrSelect(vo);

		// ZOOM미팅조회
		return new ResultDTO<ZoomMeetingVO>().setData(zoomMeetingService.zoomMeetingSelect(authrtVO.getAuthrtTkn(), (String) smnr.get("meetngrmId")));
	}

	// ZOOM참여자URL조회
	@Override
	public ResultDTO<SmnrTrgtrVO> zoomUserUrlSelect(SmnrVO vo) {
		// 세미나정보조회
		EgovMap smnr = smnrService.smnrSelect(vo);

		// 세미나참석조회
		SmnrAtndVO atndVO = smnrAtndService.smnrAtndSelect(vo);
		LocalDateTime now = LocalDateTime.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		if(atndVO == null) {
			// 세미나참석등록
			atndVO = new SmnrAtndVO();
			atndVO.setSmnrId(smnrService.smnrIdSelect(vo));
			atndVO.setAtndeId(vo.getUserId());
			atndVO.setAtndeIp(vo.getRegIp());
	        atndVO.setAtndSdttm(now.format(formatter));
	        atndVO.setCntnDvcTycd(vo.getSubParam());
	        atndVO.setRgtrId(vo.getUserId());
			smnrAtndService.smnrAtndRegist(atndVO);
		} else {
			if(atndVO.getAtndSdttm() == null || atndVO.getAtndSdttm().trim().isEmpty()) {
				// 세미나참석수정
		        atndVO.setAtndSdttm(now.format(formatter));
		        atndVO.setAtndeIp(vo.getRegIp());
		        atndVO.setCntnDvcTycd(vo.getSubParam());
		        atndVO.setMdfrId(vo.getUserId());
		        smnrAtndService.smnrAtndModify(atndVO);
			}
		}

		// 세미나참석이력등록
		smnrAtndHstryService.smnrAtndHstryRegist(vo);

		// 세미나대상자접속URL조회
		SmnrTrgtrVO trgtr = smnrTrgtrDAO.smnrTrgtrCntnUrlSelect(vo);
		if(trgtr != null && !"".equals(StringUtil.nvl(trgtr.getTrgtrCntnUrl()))) {
			return new ResultDTO<SmnrTrgtrVO>().setData(trgtr);
		}

		// 온라인플랫폼권한갱신
		OnlnPltfrmAuthrtVO authrtVO = onlnPltfrmAuthrtService.onlnPltfrmAuthrtUpdt("ZOOM", vo.getOrgId(), vo.getUserId());

		// ZOOM미팅참여자사전등록 ( pro기능 )
		ZoomRegistrantVO registrantVO = new ZoomRegistrantVO();
		registrantVO.setEmail(vo.getUserId() + "@knou.ac.kr");
		registrantVO.setFirstName(smnr.get("usernm").toString().substring(0, 1));
		registrantVO.setLastName(smnr.get("usernm").toString().substring(1));
		ZoomRegistrantVO respVO = zoomMeetingService.zoomRegistrantRegist(authrtVO.getAuthrtTkn(), smnr.get("meetngrmId").toString(), registrantVO);

		// 세미나대상자등록
		if(trgtr != null) {
			trgtr = new SmnrTrgtrVO();
			trgtr.setSmnrTrgtrId(IdGenUtil.genNewId(IdPrefixType.SMTGT));
			trgtr.setSmnrId(vo.getSmnrId());
			trgtr.setUserId(vo.getUserId());
			trgtr.setOnlnMeetngrmId((String) smnr.get("onlnMeetngrmId"));
		}
		trgtr.setTrgtrCntnUrl(respVO.getJoinUrl());
		trgtr.setPreregyn("Y");
		trgtr.setRgtrId(vo.getRgtrId());
		smnrTrgtrDAO.smnrTrgtrRegist(trgtr);

		return new ResultDTO<SmnrTrgtrVO>().setData(trgtr);
	}

	// ZOOM과거미팅조회
	@Override
	public ResultDTO<ZoomPastMeetingVO> zoomPastMeetingSelect(SmnrVO vo) {
		ResultDTO<ZoomPastMeetingVO> resultVO = new ResultDTO<ZoomPastMeetingVO>();

		// 온라인플랫폼권한갱신
		OnlnPltfrmAuthrtVO authrtVO = onlnPltfrmAuthrtService.onlnPltfrmAuthrtUpdt("ZOOM", vo.getOrgId(), vo.getRgtrId());

		// 세미나정보조회
		EgovMap smnr = smnrService.smnrSelect(vo);

		// ZOOM미팅조회
		ZoomPastMeetingVO pastMeetingVO = zoomMeetingService.zoomPastMeetingSelect(authrtVO.getAuthrtTkn(), (String) smnr.get("meetngrmId"));
		if(pastMeetingVO != null) {
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");
			LocalDateTime startTime = LocalDateTime.parse(pastMeetingVO.getStartTime(), formatter);
			LocalDateTime endTime   = LocalDateTime.parse(pastMeetingVO.getEndTime(), formatter);

			// 초 단위 계산
			long durationSeconds = ChronoUnit.SECONDS.between(startTime, endTime);
			pastMeetingVO.setDuration((int) durationSeconds);
			resultVO.setData(pastMeetingVO);
		}

		return resultVO;
	}

}
