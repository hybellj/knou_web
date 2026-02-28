package knou.lms.seminar.api.users.service.impl;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import knou.lms.seminar.api.common.ZoomApiUrl;
import knou.lms.seminar.api.common.ZoomRestTemplateSupporter;
import knou.lms.seminar.api.meetings.vo.AuthenticationOptionVO;
import knou.lms.seminar.api.users.UsersUrl;
import knou.lms.seminar.api.users.service.UsersService;
import knou.lms.seminar.api.users.vo.ReqUserVO;
import knou.lms.seminar.api.users.vo.UserSettingsVO;
import knou.lms.seminar.api.users.vo.UsersInfoVO;
import knou.lms.seminar.api.users.vo.UsersVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Service("usersService")
public class UsersServiceImpl implements UsersService {

    @Autowired
    private ZoomRestTemplateSupporter restTemplate;

    /*****************************************************
     * <p>
     * TODO ZOOM 이메일 등록 여부 확인
     * </p>
     * ZOOM 이메일 등록 여부 확인
     * 
     * @param accessToken   API 호출 토큰키
     * @param email         ZOOM에 등록한 이메일(tcEmail)
     * @return boolean
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public boolean checkAUserEmail(String accessToken, String email) throws URISyntaxException {
        ZoomApiUrl apiUrl = UsersUrl.CHECK_A_USER_EMAIL;

        URI url = new URI(apiUrl.getUrl());
        UriComponents uriComponents = UriComponentsBuilder.fromUri(url)
                .queryParam("email", email)
                .build();
        @SuppressWarnings("rawtypes")
        ResponseEntity<HashMap> response = restTemplate.exchange(accessToken, apiUrl,
                uriComponents.toUri(), HashMap.class);

        return (boolean) response.getBody().get("existed_email");
    }

    /*****************************************************
     * <p>
     * TODO 미팅 옵션 리스트 조회
     * </p>
     * 미팅 옵션 리스트 조회
     * 
     * @param accessToken   API 호출 토큰키
     * @param userId        ZOOM에서 생성된 사용자 ID(tcId) 또는 이메일(tcEmail)
     * @return List<AuthenticationOptionVO>
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public List<AuthenticationOptionVO> getUserSettings(String accessToken, String userId) throws URISyntaxException {
        ZoomApiUrl apiUrl = UsersUrl.GET_USERS_SETTINGS;

        URI url = new URI(String.format(apiUrl.getUrl(), userId));
        UriComponents uriComponents = UriComponentsBuilder.fromUri(url)
                .queryParam("option", "meeting_authentication")
                .build();
        ResponseEntity<UserSettingsVO> response = restTemplate.exchange(accessToken, apiUrl,
                uriComponents.toUri(), UserSettingsVO.class);

        return response.getBody().getAuthenticationOptions();
    }

    /*****************************************************
     * <p>
     * TODO 미팅 옵션 조회
     * </p>
     * 미팅 옵션 중 "지정한 도메인으로 Zoom에 로그인"옵션의 정보를 반환한다.<br>
     * "지정한 도메인으로 Zoom에 로그인"옵션이 없다면 "Zoom에 로그인"옵션의 정보를 반환한다.<br>
     * 
     * @param accessToken   API 호출 토큰키
     * @param userId        ZOOM에서 생성된 사용자 ID(tcId) 또는 이메일(tcEmail)
     * @return AuthenticationOptionVO
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public AuthenticationOptionVO getUserSetting(String accessToken, String userId) throws URISyntaxException {
        List<AuthenticationOptionVO> authenticationOptions = this.getUserSettings(accessToken, userId);

        return authenticationOptions.stream().filter(s -> "enforce_login_with_domains".equals(s.getType())
                    && "Zoom에 로그인".equals(s.getName()))
                .findFirst()
                .orElse(authenticationOptions.stream().filter(s -> "enforce_login".equals(s.getType())).findFirst().get());
    }
    
    /*****************************************************
     * <p>
     * TODO 사용자 리스트 조회
     * </p>
     * 사용자 리스트 조회
     * 
     * @param accessToken   API 호출 토큰키
     * @return UsersVO
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public UsersVO listUsers(String accessToken) throws URISyntaxException {
        ZoomApiUrl apiUrl = UsersUrl.LIST_USERS;

        URI url = new URI(apiUrl.getUrl());
        ResponseEntity<UsersVO> response = restTemplate.exchangePageList(accessToken, apiUrl,
                url, UsersVO.class);

        return response.getBody();
    }
    
    /*****************************************************
     * <p>
     * TODO 사용자 생성
     * </p>
     * 사용자 생성
     * 
     * @param accessToken   API 호출 토큰키
     * @param reqUserVO     사용자 정보 VO
     * @return UsersInfoVO
     * @throws URISyntaxException, Exception
     ******************************************************/
    @Override
    public UsersInfoVO createUsers(String accessToken, ReqUserVO reqUserVO) throws URISyntaxException,Exception {
        ZoomApiUrl apiUrl = UsersUrl.CREATE_USERS;

        URI url = new URI(apiUrl.getUrl());
        ResponseEntity<UsersInfoVO> response = restTemplate.exchange(accessToken, apiUrl, url, reqUserVO,
                UsersInfoVO.class);

        return response.getBody();
    }
    
    /*****************************************************
     * <p>
     * TODO 사용자 삭제
     * </p>
     * 사용자 삭제
     * 
     * @param accessToken   API 호출 토큰키
     * @param userId        ZOOM에서 생성된 사용자 ID(tcId) 또는 이메일(tcEmail)
     * @return int
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public int deleteAUser(String accessToken, String userId) throws URISyntaxException {
        ZoomApiUrl apiUrl = UsersUrl.DELETE_A_USER;

        URI url = new URI(String.format(apiUrl.getUrl(), userId));
        UriComponents uriComponents = UriComponentsBuilder.fromUri(url).queryParam("action","delete").build();
        ResponseEntity<Object> response = restTemplate.exchange(accessToken, apiUrl,
                uriComponents.toUri(), Object.class);

        return response.getStatusCodeValue();
    }
    
    /*****************************************************
     * <p>
     * TODO 사용자 조회
     * </p>
     * 사용자 조회
     * 
     * @param accessToken   API 호출 토큰키
     * @param userId        ZOOM에서 생성된 사용자 ID(tcId) 또는 이메일(tcEmail)
     * @return UsersInfoVO
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public UsersInfoVO getAUser(String accessToken, String userId) throws URISyntaxException {
        ZoomApiUrl apiUrl = UsersUrl.GET_A_USER;

        URI url = new URI(String.format(apiUrl.getUrl(), userId));
        ResponseEntity<UsersInfoVO> response = restTemplate.exchange(accessToken, apiUrl, url,
                UsersInfoVO.class);
        return response.getBody();
    }
    
    /*****************************************************
     * <p>
     * TODO 사용자 갱신
     * </p>
     * 사용자 갱신
     * 
     * @param accessToken   API 호출 토큰키
     * @param userInfoVO    갱신할 사용자 정보 VO
     * @return int
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public int updateAUser(String accessToken, UsersInfoVO userInfoVO) throws URISyntaxException {
        ZoomApiUrl apiUrl = UsersUrl.UPDATE_A_USER;

        URI url = new URI(String.format(apiUrl.getUrl(), userInfoVO.getId()));
        ResponseEntity<UsersInfoVO> response = restTemplate.exchange(accessToken, apiUrl, url,
                userInfoVO, UsersInfoVO.class);

        return response.getStatusCodeValue();
    }

    /*****************************************************
     * <p>
     * TODO 사용자 비밀번호 갱신
     * </p>
     * 사용자 비밀번호 갱신
     * 
     * @param accessToken   API 호출 토큰키
     * @param userId        ZOOM에서 생성된 사용자 ID(tcId) 또는 이메일(tcEmail)
     * @param userInfoVO    갱신할 사용자 정보 VO
     * @return int
     * @throws URISyntaxException
     ******************************************************/
    @Override
    public int updateAUsersPassword(String accessToken, String userId,UsersInfoVO userInfoVO) throws URISyntaxException {
        ZoomApiUrl apiUrl = UsersUrl.UPDATE_A_USERS_PASSWORD;

        URI url = new URI(String.format(apiUrl.getUrl(), userId));
        ResponseEntity<UsrUserInfoVO> response = restTemplate.exchange(accessToken, apiUrl, url,
                userInfoVO, UsrUserInfoVO.class);

        return response.getStatusCodeValue();
    }

}
