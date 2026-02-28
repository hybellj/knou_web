package knou.lms.seminar.api.meetings.service.impl;

import java.net.URI;
import java.net.URISyntaxException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import knou.lms.seminar.api.common.ZoomApiUrl;
import knou.lms.seminar.api.common.ZoomRestTemplateSupporter;
import knou.lms.seminar.api.meetings.MeetingsUrl;
import knou.lms.seminar.api.meetings.service.MeetingsService;
import knou.lms.seminar.api.meetings.vo.MeetingVO;
import knou.lms.seminar.api.meetings.vo.MeetingsVO;
import knou.lms.seminar.api.meetings.vo.RegistrantsVO;

@Service("meetingsService")
public class MeetingsServiceImpl implements MeetingsService {

    @Autowired
    private ZoomRestTemplateSupporter restTemplate;

    /*****************************************************
     * <p>
     * TODO 미팅 리스트 조회
     * </p>
     * 미팅 리스트 조회
     * 
     * @param accessToken API 호출 토큰키
     * @param userId      ZOOM에서 생성된 사용자 ID : TC_ID
     * @return MeetingsVO
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public MeetingsVO listMeetings(String accessToken, String userId) throws URISyntaxException {
        ZoomApiUrl apiUrl = MeetingsUrl.LIST_MEETINGS;
        
        URI url = new URI(String.format(apiUrl.getUrl(), userId));
        ResponseEntity<MeetingsVO> response = restTemplate.exchangePageList(accessToken,
                apiUrl, url, MeetingsVO.class);
        
        return response.getBody();
    }
    
    /*****************************************************
     * <p>
     * TODO 미팅 생성
     * </p>
     * 미팅 생성
     * 
     * @param accessToken API 호출 토큰키
     * @param userId      ZOOM에서 생성된 사용자 ID : TC_ID
     * @param requestBody 생성할 미팅 정보
     * @return MeetingVO
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public MeetingVO createAMeeting(String accessToken, String userId, MeetingVO requestBody) throws URISyntaxException {
        ZoomApiUrl apiUrl = MeetingsUrl.CREATE_A_MEETING;
        
        URI url = new URI(String.format(apiUrl.getUrl(), userId));
        ResponseEntity<MeetingVO> response = restTemplate.exchange(accessToken, apiUrl, url,
                requestBody, MeetingVO.class);

        return response.getBody();
    }

    /*****************************************************
     * <p>
     * TODO 미팅 조회
     * </p>
     * 미팅 조회
     * 
     * @param accessToken API 호출 토큰키
     * @param meetingId   미팅 ID
     * @return MeetingVO
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public MeetingVO getAMeeting(String accessToken, long meetingId) throws URISyntaxException {
        ZoomApiUrl apiUrl = MeetingsUrl.GET_A_MEETING;
        
        URI url = new URI(String.format(apiUrl.getUrl(), meetingId));
        ResponseEntity<MeetingVO> response = restTemplate.exchange(accessToken, apiUrl, url,
                MeetingVO.class);

        return response.getBody();
    }
    
    /*****************************************************
     * 지난 미팅 조회
     * @param accessToken API 호출 토큰키
     * @param meetingId   미팅 ID
     * @return MeetingVO
     * @throws URISyntaxException
     ******************************************************/
    public MeetingVO getPastMeeting(String accessToken, long meetingId) throws URISyntaxException {
        ZoomApiUrl apiUrl = MeetingsUrl.GET_PAST_MEETING;
        
        URI url = new URI(String.format(apiUrl.getUrl(), meetingId));
        ResponseEntity<MeetingVO> response = restTemplate.exchange(accessToken, apiUrl, url,
                MeetingVO.class);

        return response.getBody();
    }

    /*****************************************************
     * <p>
     * TODO 미팅 갱신
     * </p>
     * 미팅 갱신
     * 
     * @param accessToken API 호출 토큰키
     * @param meetingId   미팅 ID
     * @param requestBody 갱신할 미팅 정보
     * @return int
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public int updateAMeeting(String accessToken, long meetingId, MeetingVO requestBody) throws URISyntaxException {
        ZoomApiUrl apiUrl = MeetingsUrl.UPDATE_A_MEETING;
        
        URI url = new URI(String.format(apiUrl.getUrl(), meetingId));
        ResponseEntity<MeetingVO> response = restTemplate.exchange(accessToken, apiUrl, url,
                requestBody, MeetingVO.class);

        return response.getStatusCodeValue();
    }
    
    /*****************************************************
     * <p>
     * TODO 미팅 삭제
     * </p>
     * 미팅 삭제
     * 
     * @param accessToken API 호출 토큰키
     * @param meetingId   미팅 ID
     * @return int
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public int deleteAMeeting(String accessToken, long meetingId) throws URISyntaxException {
        ZoomApiUrl apiUrl = MeetingsUrl.DELETE_A_MEETING;
        
        URI url = new URI(String.format(apiUrl.getUrl(), meetingId));
        UriComponents uriComponents = UriComponentsBuilder.fromUri(url)
                .queryParam("schedule_for_reminder", false)
                .build();
        ResponseEntity<Object> response = restTemplate.exchange(accessToken,
                apiUrl, uriComponents.toUri(), Object.class);
        
        return response.getStatusCodeValue();
    }
    
    /*****************************************************
     * <p>
     * TODO 미팅 참여자 정보
     * </p>
     * 미팅 참여자 정보
     * 
     * @param accessToken API 호출 토큰키
     * @param meetingId   미팅 ID
     * @param registrantId 사전 참여자 등록 ID
     * @return RegistrantsVO
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public RegistrantsVO getAMeetingRegistrant(String accessToken, long meetingId, String registrantId)
            throws URISyntaxException {
        ZoomApiUrl apiUrl = MeetingsUrl.GET_A_MEETING_REGISTRANT;
        
        URI url = new URI(String.format(apiUrl.getUrl(), meetingId, registrantId));
        ResponseEntity<RegistrantsVO> response = restTemplate.exchange(accessToken, apiUrl, url, RegistrantsVO.class);
        
        return response.getBody();
    }
    
    /*****************************************************
     * <p>
     * TODO 미팅 참여자 등록
     * </p>
     * 미팅 참여자 등록
     * 
     * @param accessToken API 호출 토큰키
     * @param meetingId   미팅 ID
     * @param requestBody 추가할 참여자 정보
     * @return RegistrantsVO
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public RegistrantsVO addMeetingRegistrant(String accessToken, long meetingId, RegistrantsVO requestBody) throws URISyntaxException {
        ZoomApiUrl apiUrl = MeetingsUrl.ADD_MEETING_REGISTRANT;
        
        URI url = new URI(String.format(apiUrl.getUrl(), meetingId));
        ResponseEntity<RegistrantsVO> response = restTemplate.exchange(accessToken, apiUrl, url,
                requestBody, RegistrantsVO.class);

        return response.getBody();
    }

    /*****************************************************
     * <p>
     * TODO 미팅 참여자 삭제
     * </p>
     * 미팅 참여자 삭제
     * 
     * @param accessToken   API 호출 토큰키
     * @param meetingId     미팅 ID
     * @param registrantId  삭제할 사전등록 ID
     * @return int
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public int deleteMeetingRegistrant(String accessToken, long meetingId, String registrantId) throws URISyntaxException {
        ZoomApiUrl apiUrl = MeetingsUrl.DELETE_A_MEETING_REGISTRANT;

        URI url = new URI(String.format(apiUrl.getUrl(), meetingId, registrantId));
        ResponseEntity<Object> response = restTemplate.exchange(accessToken, apiUrl, url, Object.class);
        return response.getStatusCodeValue();
    }

}
