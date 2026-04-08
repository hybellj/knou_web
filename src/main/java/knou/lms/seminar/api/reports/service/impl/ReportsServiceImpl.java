package knou.lms.seminar.api.reports.service.impl;

import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import knou.lms.seminar.api.common.ZoomApiUrl;
import knou.lms.seminar.api.common.ZoomRestTemplateSupporter2;
import knou.lms.seminar.api.reports.ReportsUrl;
import knou.lms.seminar.api.reports.service.ReportsService;
import knou.lms.seminar.api.reports.vo.ParticipantsVO;

@Service("reportsService")
public class ReportsServiceImpl implements ReportsService {

    @Autowired
    private ZoomRestTemplateSupporter2 restTemplate;

    /*****************************************************
     * <p>
     * TODO 미팅 참여자 리스트 조회
     * </p>
     * 미팅 참여자 리스트 조회
     * 
     * @param accessToken   API 호출 토큰키
     * @param meetingId     ZOOM에 등록된 미팅 ID 또는 미팅 UUID
     * @return ParticipantsVO
     * @throws URISyntaxException, UnsupportedEncodingException
     ******************************************************/
    @Override
    public ParticipantsVO getMeetingParticipantReports(String accessToken, String meetingId) throws URISyntaxException, UnsupportedEncodingException {
        ZoomApiUrl apiUrl = ReportsUrl.GET_MEETING_PARTICIPANT_REPORTS;
        
        // ZOOM API에서 사용하는 String형태의 meetingId는 url에 사용하는 특수문자("/")가 포함 될 수 있으므로 이중 인코딩해야 한다.
        URI url = new URI(String.format(apiUrl.getUrl(), URLEncoder.encode(URLEncoder.encode(meetingId, "UTF-8"), "UTF-8")));
        UriComponents uriComponents = UriComponentsBuilder.fromUri(url)
                .build();
        ResponseEntity<ParticipantsVO> response = restTemplate.exchangePageList(accessToken, apiUrl,
                uriComponents.toUri(), ParticipantsVO.class);
        
        return response.getBody();
    }

}
