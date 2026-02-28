package knou.lms.seminar.service;

import java.util.List;

import knou.lms.seminar.api.cloudrecording.vo.RecordingFileVO;
import knou.lms.seminar.api.cloudrecording.vo.RecordingVO;
import knou.lms.seminar.api.meetings.vo.MeetingVO;
import knou.lms.seminar.api.meetings.vo.MeetingsVO;
import knou.lms.seminar.api.reports.vo.ParticipantsVO;
import knou.lms.seminar.api.users.vo.UsersInfoVO;
import knou.lms.seminar.api.users.vo.UsersVO;
import knou.lms.seminar.vo.SeminarVO;
import knou.lms.user.vo.UsrUserInfoVO;

public interface ZoomApiService {

    /*****************************************************
     * TODO 사용자 정보 호출 API
     * @param String
     * @return UsersInfoVO
     * @throws Exception
     ******************************************************/
    public UsersInfoVO selectUser(String tcEmail) throws Exception;
    
    /*****************************************************
     * TODO 사용자 목록 호출 API
     * @param UsrUserInfoVO
     * @return UsersVO
     * @throws Exception
     ******************************************************/
    public UsersVO listUsers(UsrUserInfoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 사용자 등록 호출 API
     * @param UsrUserInfoVO
     * @return UsrUserInfoVO
     * @throws Exception
     ******************************************************/
    public UsrUserInfoVO insertUser(UsrUserInfoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 사용자 수정 호출 API
     * @param UsrUserInfoVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateUser(UsrUserInfoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 사용자 삭제 호출 API
     * @param UsrUserInfoVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteUser(UsrUserInfoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 미팅 정보 호출 API
     * @param String
     * @return MeetingVO
     * @throws Exception
     ******************************************************/
    public MeetingVO selectMeeting(String zoomId) throws Exception;
    
    /*****************************************************
     * TODO 미팅 목록 호출 API
     * @param String
     * @return MeetingsVO
     * @throws Exception
     ******************************************************/
    public MeetingsVO listMeetings(String tcEmail) throws Exception;
    
    /*****************************************************
     * TODO 미팅 등록 호출 API
     * @param SeminarVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    public SeminarVO insertMeeting(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 미팅 수정 호출 API
     * @param SeminarVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    public SeminarVO updateMeeting(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 미팅 삭제 호출 API
     * @param SeminarVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    public SeminarVO deleteMeeting(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 미팅 사전 참여자 등록 호출 API
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void addMeetingRegistrant(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 미팅 참여자 목록 호출 API
     * @param SeminarVO
     * @return ParticipantsVO
     * @throws Exception
     ******************************************************/
    public ParticipantsVO getMeetingParticipantReports(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 일정 기간 미팅 녹화 목록 호출 API
     * @param UsrUserInfoVO
     * @return List<RecordingVO>
     * @throws Exception
     ******************************************************/
    public List<RecordingVO> listRecordingsOfAnAccount(UsrUserInfoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 특정 미팅 녹화 목록 호출 API
     * @param SeminarVO
     * @return RecordingSettingsVO
     * @throws Exception
     ******************************************************/
    public List<RecordingFileVO> listMeetingRecordingFiles(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * 전체 미팅 녹화 영상 목록 조회
     * @param SeminarVO
     * @return List<RecordingVO>
     * @throws Exception
     ******************************************************/
    public List<RecordingVO> listAllRecording(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 사용자 테이블 ZOOM 정보 수정
     * @param UsrUserInfoVO
     * @return UsrUserInfoVO
     * @throws Exception
     ******************************************************/
    public UsrUserInfoVO updateUserTcInfo(UsrUserInfoVO vo) throws Exception;
    
}
