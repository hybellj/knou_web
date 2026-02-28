package knou.lms.seminar.api.cloudrecording.service.impl;

import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import knou.lms.seminar.api.cloudrecording.CloudRecordingUrl;
import knou.lms.seminar.api.cloudrecording.service.CloudRecordingService;
import knou.lms.seminar.api.cloudrecording.vo.RecordingSettingsVO;
import knou.lms.seminar.api.cloudrecording.vo.RecordingVO;
import knou.lms.seminar.api.cloudrecording.vo.RecordingsVO;
import knou.lms.seminar.api.common.ZoomApiUrl;
import knou.lms.seminar.api.common.ZoomRestTemplateSupporter;

@Service("cloudRecordingService")
public class CloudRecordingServiceImpl implements CloudRecordingService {

    @Autowired
    private ZoomRestTemplateSupporter restTemplate;

    /*****************************************************
     * <p>
     * TODO 녹화 영상 설정 조회
     * </p>
     * 녹화 영상 설정 조회
     * 
     * @param accessToken   API 호출 토큰키
     * @param meetingId     미팅 ID
     * @return RecordingSettingsVO
     * @throws URISyntaxException, UnsupportedEncodingException
     ******************************************************/
    @Override
    public RecordingSettingsVO getMeetingRecordingSettings(String accessToken, String meetingId)
            throws URISyntaxException, UnsupportedEncodingException {
        ZoomApiUrl apiUrl = CloudRecordingUrl.GET_MEETING_RECORDING_SETTINGS;

        // ZOOM API에서 사용하는 String형태의 meetingId는 url에 사용하는 특수문자("/")가 포함 될 수 있으므로 이중 인코딩해야 한다.
        URI url = new URI(String.format(apiUrl.getUrl(), URLEncoder.encode(URLEncoder.encode(meetingId, "UTF-8"), "UTF-8")));
        ResponseEntity<RecordingSettingsVO> response = restTemplate.exchange(accessToken, apiUrl,
                url, RecordingSettingsVO.class);

        return response.getBody();
    }

    /*****************************************************
     * <p>
     * TODO 계정의 모든 녹화 영상 조회
     * </p>
     * 계정의 모든 녹화 영상 조회
     * 
     * @param accessToken   API 호출 토큰키
     * @param accountId     계정 ID
     * @param from          시작일자
     * @param to            종료일자
     * @return List<RecordingVO>
     * @throws URISyntaxException, UnsupportedEncodingException
     ******************************************************/
    @Override
    public List<RecordingVO> listRecordingsOfAnAccount(String accessToken, String accountId, String from, String to)
            throws URISyntaxException, UnsupportedEncodingException {
        ZoomApiUrl apiUrl = CloudRecordingUrl.LIST_RECORDINGS_OF_AN_ACCOUNT;

        URI url = new URI(String.format(apiUrl.getUrl(), accountId));
        UriComponents uriComponents = UriComponentsBuilder.fromUri(url)
                .queryParam("from", from)
                .queryParam("to", to)
                .build();
        ResponseEntity<RecordingsVO> response = restTemplate.exchangePageList(accessToken,
                apiUrl, uriComponents.toUri(), RecordingsVO.class);
        return response.getBody().getObjects();
    }

    /*****************************************************
     * <p>
     * TODO 특정 미팅 녹화 영상 목록 조회
     * </p>
     * 특정 미팅 녹화 영상 목록 조회
     * 
     * @param accessToken   API 호출 토큰키
     * @param meetingId     미팅 ID
     * @return RecordingVO
     * @throws URISyntaxException, UnsupportedEncodingException
     ******************************************************/
    @Override
    public RecordingVO getMeetingRecordings(String accessToken, String meetingId)
            throws URISyntaxException, UnsupportedEncodingException {
        ZoomApiUrl apiUrl = CloudRecordingUrl.GET_MEETING_RECORDINGS;
        
        URI url = new URI(String.format(apiUrl.getUrl(), meetingId));
        ResponseEntity<RecordingVO> response = restTemplate.exchange(accessToken, apiUrl, url, RecordingVO.class);
        
        return response.getBody();
    }

    /*****************************************************
     * <p>
     * 전체 미팅 녹화 영상 목록 조회
     * </p>
     * 전체 미팅 녹화 영상 목록 조회
     * 
     * @param accessToken   API 호출 토큰키
     * @param meetingId     미팅 ID
     * @param from          시작일자
     * @param to            종료일자
     * @return RecordingsVO
     * @throws URISyntaxException, UnsupportedEncodingException
     ******************************************************/
    @Override
    public RecordingsVO getListAllRecordings(String accessToken, String hostId, String from, String to)
            throws URISyntaxException, UnsupportedEncodingException {
        ZoomApiUrl apiUrl = CloudRecordingUrl.GET_LIST_ALL_RECORDINGS;
        URI url = new URI(String.format(apiUrl.getUrl(), hostId));
        UriComponents uriComponents = UriComponentsBuilder.fromUri(url)
                .queryParam("from", from)
                .queryParam("to", to)
                .build();
        
        ResponseEntity<RecordingsVO> response = restTemplate.exchangePageList(accessToken,
                apiUrl, uriComponents.toUri(), RecordingsVO.class);
        
        return response.getBody();
    }

}
