package knou.lms.seminar.api.cloudrecording.service;

import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.util.List;

import knou.lms.seminar.api.cloudrecording.vo.RecordingSettingsVO;
import knou.lms.seminar.api.cloudrecording.vo.RecordingVO;
import knou.lms.seminar.api.cloudrecording.vo.RecordingsVO;

public interface CloudRecordingService {
    
    /*****************************************************
     * TODO 녹화 영상 설정 조회
     * @param accessToken   API 호출 토큰키
     * @param meetingId     미팅 ID
     * @return RecordingSettingsVO
     * @throws URISyntaxException, UnsupportedEncodingException
     ******************************************************/
    public RecordingSettingsVO getMeetingRecordingSettings(String accessToken, String meetingId) throws URISyntaxException, UnsupportedEncodingException;
    
    /*****************************************************
     * TODO 계정의 모든 녹화 영상 조회
     * @param accessToken   API 호출 토큰키
     * @param accountId     계정 ID
     * @param from          시작일자
     * @param to            종료일자
     * @return List<RecordingVO>
     * @throws URISyntaxException, UnsupportedEncodingException
     ******************************************************/
    public List<RecordingVO> listRecordingsOfAnAccount(String accessToken, String accountId, String from, String to)
            throws URISyntaxException, UnsupportedEncodingException;
    
    /*****************************************************
     * TODO 특정 미팅 녹화 영상 목록 조회
     * @param accessToken   API 호출 토큰키
     * @param meetingId     미팅 ID
     * @return RecordingVO
     * @throws URISyntaxException, UnsupportedEncodingException
     ******************************************************/
    public RecordingVO getMeetingRecordings(String accessToken, String meetingId) throws URISyntaxException, UnsupportedEncodingException;
    
    /*****************************************************
     * 전체 미팅 녹화 영상 목록 조회
     * @param accessToken   API 호출 토큰키
     * @param hostId     미팅 hostId
     * @return RecordingsVO
     * @throws URISyntaxException, UnsupportedEncodingException
     ******************************************************/
    public RecordingsVO getListAllRecordings(String accessToken, String hostId, String from, String to) throws URISyntaxException, UnsupportedEncodingException;

}
