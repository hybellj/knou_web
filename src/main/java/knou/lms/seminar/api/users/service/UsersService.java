package knou.lms.seminar.api.users.service;

import java.net.URISyntaxException;
import java.util.List;

import knou.lms.seminar.api.meetings.vo.AuthenticationOptionVO;
import knou.lms.seminar.api.users.vo.ReqUserVO;
import knou.lms.seminar.api.users.vo.UsersInfoVO;
import knou.lms.seminar.api.users.vo.UsersVO;

public interface UsersService {
    
    /*****************************************************
     * TODO ZOOM 이메일 등록 여부 확인
     * @param accessToken   API 호출 토큰키
     * @param email         ZOOM에 등록한 이메일(tcEmail)
     * @return boolean
     * @throws URISyntaxException
     ******************************************************/
    public boolean checkAUserEmail(String accessToken, String email) throws URISyntaxException;

    /*****************************************************
     * TODO 미팅 옵션 리스트 조회
     * @param accessToken   API 호출 토큰키
     * @param userId        ZOOM에서 생성된 사용자 ID(tcId) 또는 이메일(tcEmail)
     * @return List<AuthenticationOptionVO>
     * @throws URISyntaxException
     ******************************************************/
    public List<AuthenticationOptionVO> getUserSettings(String accessToken, String userId) throws URISyntaxException;

    /*****************************************************
     * TODO 미팅 옵션 조회<br>
     *      미팅 옵션 중 "지정한 도메인으로 Zoom에 로그인"옵션의 정보를 반환한다.<br>
     *      "지정한 도메인으로 Zoom에 로그인"옵션이 없다면 "Zoom에 로그인"옵션의 정보를 반환한다.<br>
     * @param accessToken   API 호출 토큰키
     * @param userId        ZOOM에서 생성된 사용자 ID(tcId) 또는 이메일(tcEmail)
     * @return AuthenticationOptionVO
     * @throws URISyntaxException
     ******************************************************/
    public AuthenticationOptionVO getUserSetting(String accessToken, String userId) throws URISyntaxException;
    
    /*****************************************************
     * TODO 사용자 리스트 조회
     * @param accessToken   API 호출 토큰키
     * @return UsersVO
     * @throws URISyntaxException
     ******************************************************/
    public UsersVO listUsers(String accessToken) throws URISyntaxException;
    
    /*****************************************************
     * TODO 사용자 생성
     * @param accessToken   API 호출 토큰키
     * @param reqUserVO     사용자 정보 VO
     * @return UsersInfoVO
     * @throws URISyntaxException, Exception
     ******************************************************/
    public UsersInfoVO createUsers(String accessToken,ReqUserVO reqUserVO) throws URISyntaxException, Exception;
     
    /*****************************************************
     * TODO 사용자 삭제
     * @param accessToken   API 호출 토큰키
     * @param userId        ZOOM에서 생성된 사용자 ID(tcId) 또는 이메일(tcEmail)
     * @return int
     * @throws URISyntaxException
     ******************************************************/
    public int deleteAUser(String accessToken,String userId) throws URISyntaxException;
    
    /*****************************************************
     * TODO 사용자 조회
     * @param accessToken   API 호출 토큰키
     * @param userId        ZOOM에서 생성된 사용자 ID(tcId) 또는 이메일(tcEmail)
     * @return UsersInfoVO
     * @throws URISyntaxException, Exception
     ******************************************************/
    public UsersInfoVO getAUser(String accessToken,String userId) throws URISyntaxException, Exception;
    
    /*****************************************************
     * TODO 사용자 갱신
     * @param accessToken   API 호출 토큰키
     * @param userInfoVO    갱신할 사용자 정보 VO
     * @return int
     * @throws URISyntaxException
     ******************************************************/
    public int updateAUser(String accessToken,UsersInfoVO userInfoVO) throws URISyntaxException;

    /*****************************************************
     * TODO 사용자 비밀번호 갱신
     * @param accessToken   API 호출 토큰키
     * @param userId        ZOOM에서 생성된 사용자 ID(tcId) 또는 이메일(tcEmail)
     * @param userInfoVO    갱신할 사용자 정보 VO
     * @return int
     * @throws URISyntaxException
     ******************************************************/
    public int updateAUsersPassword(String accessToken,String userId,UsersInfoVO userInfoVO) throws URISyntaxException;
    
}
