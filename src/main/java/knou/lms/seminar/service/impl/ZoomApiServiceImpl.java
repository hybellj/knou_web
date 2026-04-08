package knou.lms.seminar.service.impl;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.CommonUtil;
import knou.framework.util.CryptoUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.seminar.api.cloudrecording.RecordingFileType;
import knou.lms.seminar.api.cloudrecording.RecordingType;
import knou.lms.seminar.api.cloudrecording.service.CloudRecordingService;
import knou.lms.seminar.api.cloudrecording.vo.RecordingFileVO;
import knou.lms.seminar.api.cloudrecording.vo.RecordingVO;
import knou.lms.seminar.api.cloudrecording.vo.RecordingsVO;
import knou.lms.seminar.api.common.CustomKey;
import knou.lms.seminar.api.common.CustomKeyLocationValue;
import knou.lms.seminar.api.common.ZoomOAuthAppType;
import knou.lms.seminar.api.common.ZoomOAuthManager;
import knou.lms.seminar.api.common.oauth.JwtClientManager;
import knou.lms.seminar.api.common.util.DateUtils;
import knou.lms.seminar.api.common.vo.CustomKeyVO;
import knou.lms.seminar.api.common.vo.TokenVO;
import knou.lms.seminar.api.meetings.AutoRecord;
import knou.lms.seminar.api.meetings.TimeZone;
import knou.lms.seminar.api.meetings.service.MeetingsService;
import knou.lms.seminar.api.meetings.vo.MeetingVO;
import knou.lms.seminar.api.meetings.vo.MeetingsVO;
import knou.lms.seminar.api.meetings.vo.RegistrantsVO;
import knou.lms.seminar.api.meetings.vo.SettingsVO;
import knou.lms.seminar.api.reports.service.ReportsService;
import knou.lms.seminar.api.reports.vo.ParticipantsVO;
import knou.lms.seminar.api.users.Action;
import knou.lms.seminar.api.users.Language;
import knou.lms.seminar.api.users.UserType;
import knou.lms.seminar.api.users.service.UsersService;
import knou.lms.seminar.api.users.vo.ReqUserVO;
import knou.lms.seminar.api.users.vo.UsersInfoVO;
import knou.lms.seminar.api.users.vo.UsersVO;
import knou.lms.seminar.dao.SeminarRegDAO;
import knou.lms.seminar.service.ZoomApiService;
import knou.lms.seminar.vo.SeminarRegVO;
import knou.lms.seminar.vo.SeminarVO;
import knou.lms.std.dao.StdDAO;
import knou.lms.std.vo.StdVO;
import knou.lms.user.dao.UsrUserInfoDAO;
import knou.lms.user.vo.UsrUserInfoVO;

@Service("zoomApiService")
public class ZoomApiServiceImpl extends ServiceBase implements ZoomApiService {
    
    private static final Logger LOGGER = LoggerFactory.getLogger(ZoomApiService.class);
    
    @Resource(name="zoomJwtManager")
    private JwtClientManager jwtManager;
    
    @Resource(name="zoomOAuthAppType")
    private ZoomOAuthAppType oAuthAppType;
    
    @Resource(name="usersService")
    private UsersService usersService;
    
    @Resource(name="meetingsService")
    private MeetingsService meetingsService;
    
    @Resource(name="reportsService")
    private ReportsService reportsService;
    
    @Resource(name="cloudRecordingService")
    private CloudRecordingService cloudRecordingService;
    
    @Resource(name="crecrsService")
    private CrecrsService crecrsService;
    
    @Resource(name="usrUserInfoDAO")
    private UsrUserInfoDAO usrUserInfoDAO;
    
    @Resource(name="stdDAO")
    private StdDAO stdDAO;
    
    @Resource(name="seminarRegDAO")
    private SeminarRegDAO seminarRegDAO;
    
    /*****************************************************
     * <p>
     * TODO 사용자 정보 호출 API
     * </p>
     * 사용자 정보 호출 API
     * 
     * id           : TB_HOME_USER_INFO.TC_ID ( ZOOM 사용자 아이디 )
     * email        : TB_HOME_USER_INFO.TC_EMAIL ( ZOOM 사용자 이메일 )
     * type         : 라이센스 여부 ( Basic : 1, Licensed : 2, ssoCreate 시 99 )
     * firstName    : 이름
     * lastName     : 성
     * verified     : 사용자 인증여부 ( 1 : 인증완료, 0 : 미인증 )
     * timezone     : 사용자 시간대
     * language     : 언어
     * loginTypes   : 로그인타입
     * (
     *  0  : Facebook OAuth,  1 : Google OAuth,      24 : Apple OAuth,  27  : Microsoft OAuth
     *  97 : Mobile Device,  98 : RingCentral OAuth, 99 : API user,     100 : Zoom Work Email, 101 : Single Sing-On (SSO)
     *  중국만 사용 가능
     *  11 : Phone number, 21 : WeChat, 23 : Alipay
     * )
     * 
     * @param UsrUserInfoVO
     * @return UsersInfoVO
     * @throws Exception
     ******************************************************/
    @Override
    public UsersInfoVO selectUser(String tcEmail) throws Exception {
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc("ADM");
        
        return usersService.getAUser(tokenVO.getAccessToken(), tcEmail);
    }

    /*****************************************************
     * <p>
     * TODO 사용자 목록 호출 API (미사용)
     * </p>
     * 사용자 목록 호출 API
     * 
     * @param UsrUserInfoVO
     * @return UsersVO
     * @throws Exception
     ******************************************************/
    @Override
    public UsersVO listUsers(UsrUserInfoVO vo) throws Exception {
        vo = usrUserInfoDAO.selectForCompare(vo);
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc(vo.getTcEmail());
        
        return usersService.listUsers(tokenVO.getAccessToken());
    }

    /*****************************************************
     * <p>
     * TODO 사용자 등록 호출 API (미사용)
     * </p>
     * 사용자 등록 호출 API
     * 
     * @param UsrUserInfoVO
     * @return UsrUserInfoVO
     * @throws Exception
     ******************************************************/
    @Override
    public UsrUserInfoVO insertUser(UsrUserInfoVO vo) throws Exception {
        String userId = StringUtil.nvl(vo.getUserId());
        String tcEmail = StringUtil.nvl(vo.getUserId()) + "@hycu.ac.kr";
        
        if(!userId.equals("")){
            
            vo.setTcEmail(tcEmail);
            
            String firstName = StringUtil.nvl(vo.getUserNm());
            String lastName = "";
            
            vo.setTcPw(CryptoUtil.encryptAes256(StringUtil.nvl(vo.getUserIdEncpswd()), ""));
            
            ReqUserVO reqUserVO = new ReqUserVO();
            UsersInfoVO userInfoVO = new UsersInfoVO();
            
            // SSO 사용시 SSO_CREATE 적용
            //reqUserVO.setAction(Action.SSO_CREATE.getAction());
            reqUserVO.setAction(Action.AUTO_CREATE.getAction());
            userInfoVO.setPassword(StringUtil.nvl(vo.getUserIdEncpswd()));

            userInfoVO.setEmail(StringUtil.nvl(vo.getTcEmail()));
            userInfoVO.setFirstName(firstName);
            userInfoVO.setLastName(lastName);
            
            // 권한이 학생이 아닌경우 라이센스 부여
            if(!"".equals(StringUtil.nvl(vo.getProfAuthGrpCd(),"")) || !"".equals(StringUtil.nvl(vo.getMngAuthGrpCd(),""))) {
                userInfoVO.setType(UserType.LICENSED.getUserType());
            } else {
                userInfoVO.setType(UserType.BASIC.getUserType());
            }
            reqUserVO.setUserInfo(userInfoVO);

            UsrUserInfoVO regVO = new UsrUserInfoVO();
            regVO.setUserId(vo.getRgtrId());
            regVO = usrUserInfoDAO.selectForCompare(regVO);
            ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
            TokenVO tokenVO = oauthManager.getAccessTokenFromVc("ADM");
            
            usersService.createUsers(tokenVO.getAccessToken(), reqUserVO);
            
            userInfoVO = usersService.getAUser(tokenVO.getAccessToken(), vo.getTcEmail());
            vo.setTcId(userInfoVO.getId());
            vo.setTcRole(userInfoVO.getRoleName());
            
            userInfoVO.setLanguage(Language.KOREAN.getValue());
            userInfoVO.setTimezone(TimeZone.ASIA_SEOUL.getValue());
            
            usersService.updateAUser(tokenVO.getAccessToken(),userInfoVO);
        }
        return vo;
    }
    
    /*****************************************************
     * <p>
     * TODO 사용자 수정 호출 API (미사용)
     * </p>
     * 사용자 수정 호출 API
     * 
     * @param UsrUserInfoVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateUser(UsrUserInfoVO vo) throws Exception {
        // 사용시 userInfoChgDivCd 를 searchKey에 set 후 사용
        // AE : 관리자가 수정, UE : 사용자가 수정
        if("AE".equals(StringUtil.nvl(vo.getSearchKey()))) {
            UsrUserInfoVO regVO = new UsrUserInfoVO();
            regVO.setUserId(StringUtil.nvl(vo.getRgtrId()));
            regVO = usrUserInfoDAO.selectForCompare(regVO);
            if(!"".equals(StringUtil.nvl(regVO.getTcId()))) {
                ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(oAuthAppType.getAppType(regVO.getTcRole()));
                TokenVO tokenVO = oauthManager.getAccessTokenFromVc(regVO.getTcEmail());
                String firstName = StringUtil.nvl(vo.getUserNm());
                String lastName = "";
                UsrUserInfoVO uuivo = new UsrUserInfoVO();
                uuivo.setUserId(vo.getUserId());
                uuivo = usrUserInfoDAO.selectForCompare(uuivo);
                UsersInfoVO userInfoVO = usersService.getAUser(tokenVO.getAccessToken(), StringUtil.nvl(uuivo.getTcEmail(), vo.getUserId()+"@hycu.ac.kr"));
                userInfoVO.setFirstName(firstName);
                userInfoVO.setLastName(lastName);
                usersService.updateAUser(tokenVO.getAccessToken(), userInfoVO);
            }
        } else if("UE".equals(StringUtil.nvl(vo.getSearchKey()))) {
            UsrUserInfoVO uuivo = new UsrUserInfoVO();
            uuivo.setUserId(vo.getUserId());
            uuivo = usrUserInfoDAO.selectForCompare(uuivo);
            if(!"".equals(StringUtil.nvl(uuivo.getTcId()))) {
                ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(oAuthAppType.getAppType(uuivo.getTcRole()));
                TokenVO tokenVO = oauthManager.getAccessTokenFromVc(uuivo.getTcEmail());
                String firstName = StringUtil.nvl(vo.getUserNm());
                String lastName = "";
                UsersInfoVO userInfoVO = usersService.getAUser(tokenVO.getAccessToken(), "me");
                userInfoVO.setFirstName(firstName);
                userInfoVO.setLastName(lastName);
                usersService.updateAUser(tokenVO.getAccessToken(), userInfoVO);
            }
        }
    }
    
    /*****************************************************
     * <p>
     * TODO 사용자 삭제 호출 API (미사용)
     * </p>
     * 사용자 삭제 호출 API
     * 
     * @param UsrUserInfoVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteUser(UsrUserInfoVO vo) throws Exception {
        UsrUserInfoVO uuivo = new UsrUserInfoVO();
        uuivo.setUserId(StringUtil.nvl(vo.getMdfrId()));
        uuivo = usrUserInfoDAO.selectForCompare(uuivo);
        vo = usrUserInfoDAO.selectForCompare(vo);
        if(!"".equals(StringUtil.nvl(vo.getTcId()))) {
            ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(oAuthAppType.getAppType(uuivo.getTcRole()));
            TokenVO tokenVO = oauthManager.getAccessTokenFromVc(uuivo.getTcEmail());
            usersService.deleteAUser(tokenVO.getAccessToken(), StringUtil.nvl(vo.getTcId()));
            usrUserInfoDAO.updateWithdrawal(vo);
        }
    }

    /*****************************************************
     * <p>
     * TODO 미팅 정보 호출 API
     * </p>
     * 미팅 정보 호출 API
     * 
     * id           : TB_LMS_SEMINAR.ZOOM_ID ( ZOOM 회의 아이디 )
     * topic        : ZOOM에서 노출되는 제목
     * type         : 반복회의 유형 ( 1 : Daily, 2 : Weekly, 3 : Monthly )
     * startTime    : TB_LMS_SEMINAR.SEMINAR_START_DTTM ( ZOOM 회의 시작 일시 )
     * duration     : TB_LMS_SEMINAR.SEMINAR_TIME ( ZOOM 회의 시간 )
     * agenda       : TB_LMS_SEMINAR.SEMINAR_CTS ( ZOOM 회의 설명 )
     * startUrl     : TB_LMS_SEMINAR_HOST_URL ( ZOOM 호스트용 시작 URL )
     * joinUrl      : TB_LMS_SEMINAR_JOIN_URL ( ZOOM 사용자용 참여 URL )
     * password     : TB_LMS_SEMINAR_ZOOM_PW ( ZOOM 참여 비밀번호 )
     * uuid         : ZOOM 회의 고유 식별자
     * timezone     : 사용자 시간대
     * host_id      : TB_HOME_USER_INFO.TC_ID ( 회의 호스트 아이디 )
     * settings     : 회의 옵션
     * (
     *  alternative_hosts       : 대체 호스트 이메일 ( 2개 이상 구분자 = ';' ex : test1@test.com;test2@test.com )
     *  authentication_domains  : 인증 도메인 ( 도메인 주소  ex : hycu.co.kr ) 이메일 주소에 해당 도메인이 포함된 사용자만 회의 참여 가능
     *  authentication_option   : 인증 옵션 ( meeting_authentication이 true 일 경우 사용자가 회의 참여 시 필요한 인증 유형 ) : tcId값을 이용하여 usersService.getUserSetting 실행시 얻을 수 있음
     *  auto_recording          : 자동 녹화 ( local : 회의를 로컬에 녹화, cloud : 회의를 클라우드에 녹화, none : 자동 녹화 비활성화(기본 값) )
     *  custom_keys             : 맞춤 키 ( 회의에 할당된 사용자 정의 키 및 값( 최대 개수 10개 ) )
     * )
     * 
     * @param SeminarVO
     * @return MeetingVO
     * @throws Exception
     ******************************************************/
    @Override
    public MeetingVO selectMeeting(String zoomId) throws Exception {
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc("ADM");
        long tcId = Long.valueOf(zoomId);
        
        return meetingsService.getAMeeting(tokenVO.getAccessToken(), tcId);
    }

    /*****************************************************
     * <p>
     * TODO 미팅 목록 호출 API
     * </p>
     * 미팅 목록 호출 API
     * 
     * @param String
     * @return MeetingsVO
     * @throws Exception
     ******************************************************/
    @Override
    public MeetingsVO listMeetings(String tcEmail) throws Exception {
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc("ADM");
        
        return meetingsService.listMeetings(tokenVO.getAccessToken(), tcEmail);
    }

    /*****************************************************
     * <p>
     * TODO 미팅 등록 호출 API
     * </p>
     * 미팅 등록 호출 API
     * 
     * @param SeminarVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    @Override
    public SeminarVO insertMeeting(SeminarVO vo) throws Exception {
        // 대표교수 정보 조회
        CreCrsVO cvo = new CreCrsVO();
        cvo.setCrsCreCd(vo.getCrsCreCd());
        cvo = crecrsService.selectTchCreCrs(cvo);
        
        // ZOOM에 등록된 사용자 역할로 호출할 OAuth 설정
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
        // DB에 저장된 AccessToken 정보 조회
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc("ADM");
        
        MeetingVO meetingVo = new MeetingVO();
        SettingsVO settings = new SettingsVO();

        // ZOOM 회의 제목
        String topic = StringUtil.nvl(vo.getSeminarNm());
        if (topic.length() >= 120) {
            //128자가 MAX이나 120으로 함
            topic = topic.substring(0, 120) + "...";
        }
        meetingVo.setTopic(topic);
        // ZOOM 회의 비밀번호 ( 4~6 자리 숫자 ) ( 오늘 날짜 yyMMdd로 자동 설정 )
        LocalDate today = LocalDate.now();
        meetingVo.setPassword(today.format(DateTimeFormatter.ofPattern("yyMMdd")));
        // ZOOM 회의 시작일시
        meetingVo.setStartTime(DateUtils.convertToIsoLocalDateTime(vo.getSeminarStartDttm()));
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        LocalDateTime startDate = LocalDateTime.parse(StringUtil.nvl(vo.getSeminarStartDttm()), formatter);
        LocalDateTime endDate = LocalDateTime.parse(StringUtil.nvl(vo.getSeminarEndDttm()), formatter);
        // ZOOM 회의 시간
        Long duration = ChronoUnit.MINUTES.between(startDate, endDate);
        meetingVo.setDuration(Long.toString(duration));
        // ZOOM 표준 시간대
        meetingVo.setTimezone(TimeZone.ASIA_SEOUL.getValue());
        // ZOOM 회의 설명
        meetingVo.setAgenda(StringUtil.nvl(vo.getSeminarCts()));
        
        // ZOOM 자동 녹화 여부 ( none : 미녹화, cloud : 클라우드 저장 )
        if("N".equals(vo.getAutoRecordYn())){
            settings.setAutoRecording(AutoRecord.NONE.getValue());
        } else {
            settings.setAutoRecording(AutoRecord.CLOUD.getValue());
        }
        
        meetingVo.setSettings(settings);

        // ZOOM 회의 등록 API 호출
        meetingVo = meetingsService.createAMeeting(tokenVO.getAccessToken(), cvo.getUserId()+"@hycu.ac.kr", meetingVo);
        
        /*
         * VC에서 API를 사용하여 만들어진 미팅인지 구분 할 수 있는 custom key를 세팅.
         * Create a meeting API에는 custom key를 추가 할 수 없기때문에 Update a meeting API를 사용하여 custom key를 추가해준다.
         * 추후에 Create a meeting API에서 custom key 추가가 가능하게 된다면 미팅 갱신을 제거 하고 미팅 생성 시에 custom key를 추가하도록 한다.
         */
        List<CustomKeyVO> customKeyList = new ArrayList<>();
        CustomKeyVO customKey = new CustomKeyVO();
        customKey.setKey(CustomKey.LOCATION.name());
        customKey.setValue(CustomKeyLocationValue.VC.name());
        customKeyList.add(customKey);

        settings = meetingVo.getSettings();
        settings.setCustomKeys(customKeyList);
        meetingVo.setSettings(settings);
        // ZOOM 회의 수정 API 호출
        meetingsService.updateAMeeting(tokenVO.getAccessToken(), meetingVo.getId(), meetingVo);
        
        // ZOOM 회의 정보 조회 API 호출
        MeetingVO mtVO = meetingsService.getAMeeting(tokenVO.getAccessToken(), meetingVo.getId());
        // 세미나 등록용 정보 리턴
        vo.setZoomId(StringUtil.nvl(mtVO.getId()));
        vo.setHostUrl(mtVO.getStartUrl());
        vo.setJoinUrl(mtVO.getJoinUrl());
        vo.setZoomPw(mtVO.getPassword());
        
        return vo;
    }

    /*****************************************************
     * <p>
     * TODO 미팅 수정 호출 API
     * </p>
     * 미팅 수정 호출 API
     * 
     * @param SeminarVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    @Override
    public SeminarVO updateMeeting(SeminarVO vo) throws Exception {
        // ZOOM에 등록된 사용자 역할로 호출할 OAuth 설정
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
        // DB에 저장된 AccessToken 정보 조회
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc("ADM");

        // ZOOM 회의 정보 조회 API 호출
        MeetingVO meetingVo = meetingsService.getAMeeting(tokenVO.getAccessToken(), Long.parseLong(vo.getZoomId()));

        // ZOOM 회의 제목
        String uuid = CommonUtil.getUUID();
        String topic = "[" + uuid + "] " + StringUtil.nvl(vo.getSeminarNm());
        if (topic.length() >= 120) {
            // 128자가 MAX이나 120으로 함
            topic = topic.substring(0, 120) + "...";
        }
        meetingVo.setTopic(topic);
        // ZOOM 회의 비밀번호 ( 4~6 자리 숫자 )
        meetingVo.setPassword(vo.getZoomPw());
        // ZOOM 회의 시작일시
        meetingVo.setStartTime(DateUtils.convertToIsoLocalDateTime(vo.getSeminarStartDttm()));
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        LocalDateTime startDate = LocalDateTime.parse(vo.getSeminarStartDttm(), formatter);
        LocalDateTime endDate = LocalDateTime.parse(vo.getSeminarEndDttm(), formatter);
        // ZOOM 회의 시간
        Long duration = ChronoUnit.MINUTES.between(startDate, endDate);
        meetingVo.setDuration(Long.toString(duration));
        meetingVo.setAgenda(vo.getSeminarCts());
        SettingsVO settings = meetingVo.getSettings();
        
        // ZOOM 자동 녹화 여부 ( NONE : 미녹화, CLOUD : 클라우드 저장 )
        if("N".equals(StringUtil.nvl(vo.getAutoRecordYn()))) {
            settings.setAutoRecording(AutoRecord.NONE.getValue());
        } else {
            settings.setAutoRecording(AutoRecord.CLOUD.getValue());
        }
        
        meetingVo.setSettings(settings);

        // ZOOM 회의 수정 API 호출
        meetingsService.updateAMeeting(tokenVO.getAccessToken(), meetingVo.getId(), meetingVo);

        vo.setHostUrl(meetingVo.getStartUrl());
        return vo;
    }

    /*****************************************************
     * <p>
     * TODO 미팅 삭제 호출 API
     * </p>
     * 미팅 삭제 호출 API
     * 
     * @param SeminarVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    @Override
    public SeminarVO deleteMeeting(SeminarVO vo) throws Exception {
        // ZOOM에 등록된 사용자 역할로 호출할 OAuth 설정
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
        // DB에 저장된 AccessToken 정보 조회
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc("ADM");
        // ZOOM 미팅 삭제 API 호출
        meetingsService.deleteAMeeting(tokenVO.getAccessToken(), Long.valueOf(vo.getZoomId()));
        vo.setZoomId("");
        vo.setZoomPw("");
        vo.setHostUrl("");
        vo.setJoinUrl("");
        
        return vo;
    }
    
    /*****************************************************
     * <p>
     * TODO 미팅 사전 참여자 등록 호출 API
     * </p>
     * 미팅 사전 참여자 등록 호출 API
     * 
     * @param SeminarVO
     * @return RegistrantsVO
     * @throws Exception
     ******************************************************/
    @Override
    public void addMeetingRegistrant(SeminarVO vo) throws Exception {
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
        // DB에 저장된 AccessToken 정보 조회
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc("ADM");
        
        List<StdVO> stdList = new ArrayList<StdVO>();
        // 학습자 사전등록 ( 학습자 번호를 갖고 호출하면 특정 학습자만 사전 등록 )
        if(StringUtil.nvl(vo.getAuthrtGrpcd()).contains("USR")) {
            // 해당 과목 전체 학습자 사전 등록시
            StdVO stdVO = new StdVO();
            stdVO.setCrsCreCd(vo.getCrsCreCd());
            stdList = stdDAO.list(stdVO);
            // 특정 학습자 사전 등록시
            if(!"".equals(StringUtil.nvl(vo.getStdNo()))) {
                stdList.clear();
                StdVO stdvo = new StdVO();
                stdvo.setStdId(vo.getStdNo());
                stdvo = stdDAO.select(stdvo);
                stdList.add(stdvo);
            }
        // 교수 사전등록 ( 호스트를 제외한 교수가 ZOOM 회의 참여시 )
        } else {
            // 사용자번호는 호스트 교수 번호, 참여하는 교수는 searchKey에 저장해서 호출
            UsrUserInfoVO profUserVO = new UsrUserInfoVO();
            profUserVO.setUserId(vo.getSearchKey());
            profUserVO = usrUserInfoDAO.selectForCompare(profUserVO);
            StdVO stdVO = new StdVO();
            stdVO.setStdId("PROF");
            stdVO.setUserId(StringUtil.nvl(profUserVO.getUserId()));
            stdVO.setUserNm(StringUtil.nvl(profUserVO.getUserNm()));
            stdVO.setDeptNm(StringUtil.nvl(profUserVO.getDeptNm()));
            stdList.add(stdVO);
        }
        
        for(StdVO svo : stdList) {
            // ZOOM 사전 등록 참가자 등록
            RegistrantsVO regiVO = new RegistrantsVO();
            // 출결 처리를 위해 학습자학번@hycu.ac.kr 로 설정
            regiVO.setEmail(StringUtil.nvl(vo.getTcEmail(), svo.getUserId()+ "@hycu.ac.kr"));
            regiVO.setFirstName(StringUtil.nvl(svo.getUserNm()));
            regiVO.setLastName("["+StringUtil.nvl(svo.getDeptNm())+"]");
            // ZOOM 회의 사전 참가자 등록 API 호출
            RegistrantsVO rvo = meetingsService.addMeetingRegistrant(tokenVO.getAccessToken(), Long.valueOf(StringUtil.nvl(vo.getZoomId())), regiVO);
            
            // 사전 등록 참가자 DB 등록
            SeminarRegVO seminarRegVO = new SeminarRegVO();
            String seminarRegId = IdGenerator.getNewId("SMRR");
            seminarRegVO.setSeminarRegId(seminarRegId);
            seminarRegVO.setSeminarId(StringUtil.nvl(vo.getSeminarId()));
            seminarRegVO.setCrsCreCd(StringUtil.nvl(vo.getCrsCreCd()));
            seminarRegVO.setZoomId(StringUtil.nvl(vo.getZoomId()));
            seminarRegVO.setStdNo(StringUtil.nvl(svo.getStdId()));
            seminarRegVO.setUserId(StringUtil.nvl(svo.getUserId()));
            seminarRegVO.setRegistantId(rvo.getRegistrantId());
            seminarRegVO.setJoinUrl(rvo.getJoinUrl());
            seminarRegVO.setTcEmail(regiVO.getEmail());
            seminarRegVO.setRgtrId(StringUtil.nvl(vo.getUserId()));
            seminarRegDAO.insert(seminarRegVO);
        }
    }

    /*****************************************************
     * <p>
     * TODO 미팅 참여자 목록 호출 API
     * </p>
     * 미팅 참여자 목록 호출 API
     * 
     * @param SeminarVO
     * @return ParticipantsVO
     * @throws Exception
     ******************************************************/
    @Override
    public ParticipantsVO getMeetingParticipantReports(SeminarVO vo) throws Exception {
        // admin 이상 참여 목록 조회 가능하므로 AccessToken 조회용 정보 설정
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc("ADM");
        
        return reportsService.getMeetingParticipantReports(tokenVO.getAccessToken(), StringUtil.nvl(vo.getZoomId()));
    }

    /*****************************************************
     * <p>
     * TODO 일정 기간 미팅 녹화 목록 호출 API (미사용)
     * </p>
     * 일정 기간 미팅 녹화 목록 호출 API
     * 
     * @param UsrUserInfoVO
     * @return List<RecordingVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<RecordingVO> listRecordingsOfAnAccount(UsrUserInfoVO vo) throws Exception {
        UsrUserInfoVO uuivo = usrUserInfoDAO.selectForCompare(vo);
        String from = StringUtil.nvl(vo.getSearchFrom()).substring(0, 8);
        String to = StringUtil.nvl(vo.getSearchTo()).substring(0, 8);
        SimpleDateFormat dtFormat = new SimpleDateFormat("yyyyMMdd");
        SimpleDateFormat stFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date fromDt = dtFormat.parse(from);
        Date toDt = dtFormat.parse(to);
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(oAuthAppType.getAppType(uuivo.getTcRole()));
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc(uuivo.getTcEmail());
        List<RecordingVO> recordingList = cloudRecordingService.listRecordingsOfAnAccount(tokenVO.getAccessToken(), "me", stFormat.format(fromDt), stFormat.format(toDt));
        
        return recordingList;
    }

    /*****************************************************
     * <p>
     * TODO 특정 미팅 녹화 목록 호출 API
     * </p>
     * 특정 미팅 녹화 목록 호출 API
     * 
     * @param SeminarVO
     * @return List<RecordingFileVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<RecordingFileVO> listMeetingRecordingFiles(SeminarVO vo) throws Exception {
        List<RecordingFileVO> resultList = new ArrayList<RecordingFileVO>();
        
        // ZOOM에 등록된 사용자 역할로 호출할 OAuth 설정
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
        // DB에 저장된 AccessToken 정보 조회
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc("ADM");
        RecordingVO recordingVO = new RecordingVO();
        try {
            // 특정 과목 녹화 목록 조회 API 호출
            recordingVO = cloudRecordingService.getMeetingRecordings(tokenVO.getAccessToken(), vo.getZoomId());
        } catch(Exception e) {
            System.out.println("녹화 목록 없음");
        }
        if(recordingVO.getRecordingFiles() != null) {
            Comparator<RecordingFileVO> comparator = Comparator.comparing(RecordingFileVO::getRecordingStart, Comparator.naturalOrder());
            List<RecordingFileVO> fileList = recordingVO.getRecordingFiles();
            fileList.sort(comparator);
            
            LinkedHashSet<String> recordingStartTimeSet = new LinkedHashSet<String>(
                    fileList.stream().map(RecordingFileVO::getRecordingStart).collect(Collectors.toList()));
            
            int count = 1;
            Iterator<String> iterator = recordingStartTimeSet.iterator();
            while(iterator.hasNext()) {
                String recordingStartTime = iterator.next();
                List<RecordingFileVO> recordingFileList = fileList.stream()
                        .filter(e -> RecordingFileType.MP4.name().equals(e.getFileType())
                                && recordingStartTime.equals(e.getRecordingStart())).collect(Collectors.toList());

                /*
                 * 파일 찾는 순서 : 자막이 포함된 화면공유가 있는 발표자 보기 - >화면공유가 있는 발표자 보기 -> 화면공유가 있는 겔러리 보기 -> 화면공유 -> 현재 발표자 ->
                 *               발표자 보기 -> 겔러리 보기 -> 예외 발생
                 */
                RecordingFileVO recordingFile = recordingFileList.stream()
                        .filter(e -> RecordingType.SHARED_SCREEN_WITH_SPEAKER_VIEW_CC.getValue().equals(e.getRecordingType())).findFirst()
                        .orElseGet(() -> recordingFileList.stream()
                                .filter(e -> RecordingType.SHARED_SCREEN_WITH_SPEAKER_VIEW.getValue().equals(e.getRecordingType())).findFirst()
                                .orElseGet(() -> recordingFileList.stream()
                                        .filter(e -> RecordingType.SHARED_SCREEN_WITH_GALLERY_VIEW.getValue().equals(e.getRecordingType()))
                                        .findFirst()
                                        .orElseGet(() -> recordingFileList.stream()
                                                .filter(e -> RecordingType.SHARED_SCREEN.getValue().equals(e.getRecordingType())).findFirst()
                                                .orElseGet(() -> recordingFileList.stream()
                                                        .filter(e -> RecordingType.ACTIVE_SPEAKER.getValue().equals(e.getRecordingType()))
                                                        .findFirst()
                                                        .orElseGet(() -> recordingFileList.stream()
                                                                .filter(e -> RecordingType.SPEAKER_VIEW.getValue().equals(e.getRecordingType()))
                                                                .findFirst()
                                                                .orElseGet(() -> recordingFileList.stream()
                                                                        .filter(e -> RecordingType.GALLERY_VIEW.getValue()
                                                                                .equals(e.getRecordingType()))
                                                                        .findFirst()
                                                                        .orElseGet(() -> null)))))));

                if(recordingFile == null) {
                    LOGGER.error("Unexpected Recording Type : MeetingId={}", vo.getZoomId());
                    continue;
                } else {
                    LocalDateTime endDate = DateUtils.convertGmtToLocalDateTime(recordingFile.getRecordingEnd());
                    recordingFile.setTopic(recordingVO.getTopic() + " " + endDate.format(DateTimeFormatter.ofPattern("yyyyMMdd HHmm")) + "-" + count++);
                    recordingFile.setPassword(recordingVO.getPassword());
                    recordingFile.setRecordingTime(Long.toString(DateUtils.getDurationFromGmt(recordingFile.getRecordingStart(), recordingFile.getRecordingEnd(), ChronoUnit.SECONDS)));
                    resultList.add(recordingFile);
                }
            }
        }
        
        return resultList;
    }
    
    /*****************************************************
     * <p>
     * 전체 미팅 녹화 영상 목록 조회
     * </p>
     * 전체 미팅 녹화 영상 목록 조회
     * 
     * @param SeminarVO
     * @return List<RecordingVO>
     * @throws Exception
     ******************************************************/
    public List<RecordingVO> listAllRecording(SeminarVO vo) throws Exception {
        List<RecordingVO> resultList = new ArrayList<>();
        String zoomId = vo.getZoomId();
        
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc("ADM");
        long tcId = Long.valueOf(zoomId);
        
        // 지난 미팅 정보 api 호출
        MeetingVO meetingVO = meetingsService.getPastMeeting(tokenVO.getAccessToken(), tcId);
        
        if(meetingVO != null) {
            String hostId = meetingVO.getHostId();
            String from = StringUtil.nvl(vo.getSearchFrom()).substring(0, 8);
            String to = StringUtil.nvl(vo.getSearchTo()).substring(0, 8);
            SimpleDateFormat dtFormat = new SimpleDateFormat("yyyyMMdd");
            SimpleDateFormat stFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date fromDt = dtFormat.parse(from);
            Date toDt = dtFormat.parse(to);
            
            // host의 전체 기록 호출
            RecordingsVO recordingsVO = cloudRecordingService.getListAllRecordings(tokenVO.getAccessToken(), hostId, stFormat.format(fromDt), stFormat.format(toDt));
            if(recordingsVO != null && recordingsVO.getRecordings() != null) {
                resultList = recordingsVO.getRecordings();
                
                for(RecordingVO recordingVO : recordingsVO.getRecordings()) {
                    if(recordingVO.getRecordingFiles() != null) {
                        List<RecordingFileVO> filterdList = new ArrayList<>();
                        Comparator<RecordingFileVO> comparator = Comparator.comparing(RecordingFileVO::getRecordingStart, Comparator.naturalOrder());
                        List<RecordingFileVO> fileList = recordingVO.getRecordingFiles();
                        fileList.sort(comparator);
                        
                        LinkedHashSet<String> recordingStartTimeSet = new LinkedHashSet<String>(
                                fileList.stream().map(RecordingFileVO::getRecordingStart).collect(Collectors.toList()));
                        
                        int count = 1;
                        Iterator<String> iterator = recordingStartTimeSet.iterator();
                        while(iterator.hasNext()) {
                            String recordingStartTime = iterator.next();
                            List<RecordingFileVO> recordingFileList = fileList.stream()
                                    .filter(e -> RecordingFileType.MP4.name().equals(e.getFileType())
                                            && recordingStartTime.equals(e.getRecordingStart())).collect(Collectors.toList());

                            /*
                             * 파일 찾는 순서 : 자막이 포함된 화면공유가 있는 발표자 보기 - >화면공유가 있는 발표자 보기 -> 화면공유가 있는 겔러리 보기 -> 화면공유 -> 현재 발표자 ->
                             *               발표자 보기 -> 겔러리 보기 -> 예외 발생
                             */
                            RecordingFileVO recordingFile = recordingFileList.stream()
                                    .filter(e -> RecordingType.SHARED_SCREEN_WITH_SPEAKER_VIEW_CC.getValue().equals(e.getRecordingType())).findFirst()
                                    .orElseGet(() -> recordingFileList.stream()
                                            .filter(e -> RecordingType.SHARED_SCREEN_WITH_SPEAKER_VIEW.getValue().equals(e.getRecordingType())).findFirst()
                                            .orElseGet(() -> recordingFileList.stream()
                                                    .filter(e -> RecordingType.SHARED_SCREEN_WITH_GALLERY_VIEW.getValue().equals(e.getRecordingType()))
                                                    .findFirst()
                                                    .orElseGet(() -> recordingFileList.stream()
                                                            .filter(e -> RecordingType.SHARED_SCREEN.getValue().equals(e.getRecordingType())).findFirst()
                                                            .orElseGet(() -> recordingFileList.stream()
                                                                    .filter(e -> RecordingType.ACTIVE_SPEAKER.getValue().equals(e.getRecordingType()))
                                                                    .findFirst()
                                                                    .orElseGet(() -> recordingFileList.stream()
                                                                            .filter(e -> RecordingType.SPEAKER_VIEW.getValue().equals(e.getRecordingType()))
                                                                            .findFirst()
                                                                            .orElseGet(() -> recordingFileList.stream()
                                                                                    .filter(e -> RecordingType.GALLERY_VIEW.getValue()
                                                                                            .equals(e.getRecordingType()))
                                                                                    .findFirst()
                                                                                    .orElseGet(() -> null)))))));

                            if(recordingFile == null) {
                                LOGGER.error("Unexpected Recording Type : MeetingId={}", vo.getZoomId());
                                continue;
                            } else {
                                LocalDateTime endDate = DateUtils.convertGmtToLocalDateTime(recordingFile.getRecordingEnd());
                                recordingFile.setTopic(recordingVO.getTopic() + " " + endDate.format(DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm")) + "-" + count++);
                                recordingFile.setRecordingTime(Long.toString(DateUtils.getDurationFromGmt(recordingFile.getRecordingStart(), recordingFile.getRecordingEnd(), ChronoUnit.SECONDS)));
                                filterdList.add(recordingFile);
                            }
                        }
                        
                        recordingVO.setRecordingFiles(filterdList);
                    }
                }
            }
        }
        
        return resultList;
    }

    /*****************************************************
     * <p>
     * TODO 사용자 테이블 ZOOM 정보 수정
     * </p>
     * 사용자 테이블 ZOOM 정보 수정
     * 
     * @param UsrUserInfoVO
     * @return UsrUserInfoVO
     * @throws Exception
     ******************************************************/
    @Override
    public UsrUserInfoVO updateUserTcInfo(UsrUserInfoVO vo) throws Exception {
        // 사용자 정보 조회
        vo = usrUserInfoDAO.selectForCompare(vo);
        
        // Owner 계정으로 사용자 정보 호출
        ZoomOAuthManager oauthManager = oAuthAppType.getOAuthManager(ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
        TokenVO tokenVO = oauthManager.getAccessTokenFromVc("ADM");
        UsersInfoVO uuivo = new UsersInfoVO();
        
        try {
            // 사번으로 사용자 정보 조회
            uuivo = usersService.getAUser(tokenVO.getAccessToken(), StringUtil.nvl(vo.getUserId()+"@hycu.ac.kr"));
        } catch(Exception e) {
            System.out.println("사용자 사번에 해당하는 사용자 정보 없음");
        }
        
        // 사용자 ZOOM 정보 수정
        vo.setTcId(uuivo.getId());
        vo.setTcEmail(uuivo.getEmail());
        vo.setTcRole(uuivo.getRoleName());
        usrUserInfoDAO.update(vo);
        
        return vo;
    }
    
}
