package knou.lms.seminar.api.reports.service;

import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;

import knou.lms.seminar.api.reports.vo.ParticipantsVO;

public interface ReportsService {
    
    /*****************************************************
     * TODO 미팅 참여자 리스트 조회
     * @param accessToken   API 호출 토큰키
     * @param meetingId     ZOOM에 등록된 미팅 ID 또는 미팅 UUID
     * @return ParticipantsVO
     * @throws URISyntaxException, UnsupportedEncodingException
     ******************************************************/
    public ParticipantsVO getMeetingParticipantReports(String accessToken, String meetingId) throws URISyntaxException, UnsupportedEncodingException;

}
