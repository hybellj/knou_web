package knou.lms.seminar.api.meetings.service;

import java.net.URISyntaxException;

import com.fasterxml.jackson.core.JsonProcessingException;

import knou.lms.seminar.api.meetings.vo.MeetingVO;
import knou.lms.seminar.api.meetings.vo.MeetingsVO;
import knou.lms.seminar.api.meetings.vo.RegistrantsVO;

public interface MeetingsService {

    /*****************************************************
     * TODO 미팅 리스트 조회
     * @param accessToken API 호출 토큰키
     * @param userId      ZOOM에서 생성된 사용자 ID : TC_ID
     * @return MeetingsVO
     * @throws URISyntaxException
     ******************************************************/
    public MeetingsVO listMeetings(String accessToken, String userId) throws URISyntaxException;

    /*****************************************************
     * TODO 미팅 생성
     * @param accessToken API 호출 토큰키
     * @param userId      ZOOM에서 생성된 사용자 ID : TC_ID
     * @param requestBody 생성할 미팅 정보
     * @return MeetingVO
     * @throws URISyntaxException, JsonProcessingException
     ******************************************************/
    public MeetingVO createAMeeting(String accessToken, String userId, MeetingVO requestBody)
            throws URISyntaxException, JsonProcessingException;

    /*****************************************************
     * TODO 미팅 조회
     * @param accessToken API 호출 토큰키
     * @param meetingId   미팅 ID
     * @return MeetingVO
     * @throws URISyntaxException
     ******************************************************/
    public MeetingVO getAMeeting(String accessToken, long meetingId) throws URISyntaxException;
    
    /*****************************************************
     * 지난 미팅 조회
     * @param accessToken API 호출 토큰키
     * @param meetingId   미팅 ID
     * @return MeetingVO
     * @throws URISyntaxException
     ******************************************************/
    public MeetingVO getPastMeeting(String accessToken, long meetingId) throws URISyntaxException;

    /*****************************************************
     * TODO 미팅 갱신
     * @param accessToken API 호출 토큰키
     * @param meetingId   미팅 ID
     * @param requestBody 갱신할 미팅 정보
     * @return int
     * @throws URISyntaxException
     ******************************************************/
    public int updateAMeeting(String accessToken, long meetingId, MeetingVO requestBody)
            throws URISyntaxException;

    /*****************************************************
     * TODO 미팅 삭제
     * @param accessToken API 호출 토큰키
     * @param meetingId   미팅 ID
     * @return int
     * @throws URISyntaxException
     ******************************************************/
    public int deleteAMeeting(String accessToken, long meetingId) throws URISyntaxException;

    /*****************************************************
     * TODO 미팅 참여자 정보
     * @param accessToken API 호출 토큰키
     * @param meetingId   미팅 ID
     * @param registrantId 사전 참여자 등록 ID
     * @return RegistrantsVO
     * @throws URISyntaxException
     ******************************************************/
    public RegistrantsVO getAMeetingRegistrant(String accessToken, long meetingId, String registrantId)
            throws URISyntaxException;
    
    /*****************************************************
     * TODO 미팅 참여자 등록
     * @param accessToken API 호출 토큰키
     * @param meetingId   미팅 ID
     * @param requestBody 추가할 참여자 정보
     * @return RegistrantsVO
     * @throws URISyntaxException
     ******************************************************/
    public RegistrantsVO addMeetingRegistrant(String accessToken, long meetingId, RegistrantsVO requestBody)
            throws URISyntaxException;

    /*****************************************************
     * TODO 미팅 참여자 삭제
     * @param accessToken   API 호출 토큰키
     * @param meetingId     미팅 ID
     * @param registrantId  삭제할 사전등록 ID
     * @return int
     * @throws URISyntaxException
     ******************************************************/
    public int deleteMeetingRegistrant(String accessToken, long meetingId, String registrantId)
            throws URISyntaxException;
    
}
