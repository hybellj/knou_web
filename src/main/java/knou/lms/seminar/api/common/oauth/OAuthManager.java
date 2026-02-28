package knou.lms.seminar.api.common.oauth;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.annotation.Resource;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import knou.framework.common.CommConst;
import knou.lms.seminar.api.common.vo.TokenVO;

public class OAuthManager {
    
    private static final Logger LOGGER = LoggerFactory.getLogger("tc");

    @Resource(name = "zoomRestTemplate")
    private RestTemplate restTemplate;

    /***************************************************** 
     * TODO ZOOM 사용자 인증용 URL 리턴
     * @param clientId, redirectUri
     * @return url
     * @throws Exception
     ******************************************************/
    public String getAuthorizeUrl(String clientId, String redirectUri) throws UnsupportedEncodingException {
        String authorizationUrl = CommConst.ZOOM_OAUTH_REST_AUTHORIZATION_URL;
        String scope = CommConst.ZOOM_OAUTH_REST_SCOPE;
        String state = CommConst.ZOOM_OAUTH_REST_STATE;

        UriComponentsBuilder builder = UriComponentsBuilder.fromUriString(authorizationUrl)
                .queryParam("response_type", "code").queryParam("client_id", clientId)
                .queryParam("redirect_uri", URLEncoder.encode(redirectUri, "UTF-8"));
        
        if (scope != null) {
            builder.queryParam("scope", URLEncoder.encode(scope, "UTF-8"));
        }
        
        if (state != null) {
            builder.queryParam("state", URLEncoder.encode(state, "UTF-8"));
        }
        
        String url = builder.build().toUriString();
        LOGGER.debug("OAuth Authorization request. URL=" + url);
        return url;
    }
    
    /***************************************************** 
     * TODO ZOOM 사용자 토큰 조회 API 호출 ( 사용자 인증용 )
     * @param clientId, clientSecret, code, redirectUri
     * @return TokenVO
     * @throws Exception
     ******************************************************/
    public TokenVO getAccessToken(String clientId, String clientSecret, String code, String redirectUri) {
        LOGGER.debug("OAuth Access token request. authorization_code=" + code);
        
        MultiValueMap<String, String> multiValueMap = new LinkedMultiValueMap<>();
        multiValueMap.add("grant_type", "authorization_code");
        multiValueMap.add("code", code);
        multiValueMap.add("redirect_uri", redirectUri);
        ResponseEntity<TokenVO> response = this.getAccessToken(multiValueMap, clientId, clientSecret);
        
        LOGGER.debug("OAuth Access token response. " + response.toString());
        
        return response.getBody();
    }

    /***************************************************** 
     * TODO ZOOM 사용자 토큰 조회 API 호출 ( 새로고침용 )
     * @param clientId, clientSecret, refreshToken
     * @return TokenVO
     * @throws Exception
     ******************************************************/
    public TokenVO refreshAccessToken(String clientId, String clientSecret, String refreshToken) {
        LOGGER.debug("OAuth Refresh access token request. refresh_token=" + refreshToken);
        
        MultiValueMap<String, String> multiValueMap = new LinkedMultiValueMap<>();
        multiValueMap.add("grant_type", "refresh_token");
        multiValueMap.add("refresh_token", refreshToken);
        ResponseEntity<TokenVO> response = this.getAccessToken(multiValueMap, clientId, clientSecret);
        
        LOGGER.debug("OAuth Refresh access token response. " + response.toString());
        
        return response.getBody();
    }

    /***************************************************** 
     * TODO ZOOM 사용자 토큰 조회 API 호출
     * @param clientId, clientSecret
     * @return HttpHeaders
     * @throws Exception
     ******************************************************/
    private ResponseEntity<TokenVO> getAccessToken(MultiValueMap<String, String> multiValueMap, String clientId, String clientSecret) {
        if (!CommConst.ZOOM_OAUTH_REST_TOKEN_HEADER_AUTHORIZATION_ENABLE) {
            multiValueMap.add("client_id", clientId);
            multiValueMap.add("client_secret", clientSecret);
        }

        HttpEntity<MultiValueMap<String, String>> param = new HttpEntity<>(multiValueMap, this.getHttpHeaders(clientId, clientSecret));
        ResponseEntity<TokenVO> resultVO = restTemplate
                .postForEntity(CommConst.ZOOM_OAUTH_REST_TOKEN_URL, param, TokenVO.class);
        
        // OAuth 사이트에 따라 없는 경우가 있으므로 프로퍼티에 설정한 값을 사용한다.
        TokenVO token = resultVO.getBody();
        if (token.getRefreshTokenExpiresIn() == null) {
            token.setRefreshTokenExpiresIn(CommConst.ZOOM_OAUTH_REST_REFRESH_TOKEN_EXPIRES_IN);
        }
        
        return resultVO;
    }

    /***************************************************** 
     * TODO ZOOM 사용자 토큰 조회용 header 설정
     * @param clientId, clientSecret
     * @return HttpHeaders
     * @throws Exception
     ******************************************************/
    private HttpHeaders getHttpHeaders(String clientId, String clientSecret) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        
        if (CommConst.ZOOM_OAUTH_REST_TOKEN_HEADER_AUTHORIZATION_ENABLE) {
            StringBuilder builder = new StringBuilder();
            builder.append(clientId);
            builder.append(":");
            builder.append(clientSecret);
            headers.add(HttpHeaders.AUTHORIZATION, "Basic " + Base64.encodeBase64String(builder.toString().getBytes()));
        }
        
        return headers;
    }

}
