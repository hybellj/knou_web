package knou.lms.smnr.pltfrm.zoom.api.common;

import java.net.URI;
import java.util.Base64;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.databind.JsonNode;

import knou.lms.smnr.pltfrm.zoom.api.users.UsersUrl;

@Component
public class ZoomTokenClient {
	private static final String TOKEN_URL		= ZoomApiUrl.ZOOM_TOKEN_URL;

	@Autowired
    private ZoomRestTemplateSupporter zoomRestTemplateSupporter;

	@Autowired
    @Qualifier("zoomRestTemplate")
    private RestTemplate restTemplate;

	// ZOOM 토큰 발급
	public JsonNode fetchToken(String pltfrmCntnId, String pltfrmCntnClientId, String pltfrmCntnClientPswd) {
		String credentials = pltfrmCntnClientId + ":" + pltfrmCntnClientPswd;
	    String encoded = Base64.getEncoder().encodeToString(credentials.getBytes());

	    URI uri = UriComponentsBuilder
	        .fromHttpUrl(TOKEN_URL)
	        .queryParam("grant_type", "account_credentials")
	        .queryParam("account_id", pltfrmCntnId)
	        .build()
	        .toUri();

	    RequestEntity<Void> request = RequestEntity
	        .post(uri)
	        .header(HttpHeaders.AUTHORIZATION, "Basic " + encoded)
	        .contentType(MediaType.APPLICATION_FORM_URLENCODED)
	        .build();

	    ResponseEntity<JsonNode> response;
	    try {
	        response = restTemplate.exchange(request, JsonNode.class);
	    } catch (HttpClientErrorException e) {
	        // 4xx 에러 처리 (401, 400 등)
	        handleZoomAuthError(e);
	        throw e; // handleZoomAuthError에서 던지지 않을 경우 대비
	    }

	    if (!response.getStatusCode().is2xxSuccessful()) {
	        throw new RuntimeException("토큰 발급 실패 [" + response.getStatusCode() + "]");
	    }

	    JsonNode body = response.getBody();

	    // 응답 바디에 에러 필드가 있는 경우 체크
	    if (body != null && body.has("error")) {
	        handleZoomBodyError(body);
	    }

	    return body;
	}

	private void handleZoomAuthError(HttpClientErrorException e) {
	    HttpStatus status = (HttpStatus) e.getStatusCode();
	    String responseBody = e.getResponseBodyAsString();

	    if (status == HttpStatus.UNAUTHORIZED) {        // 401
	        throw new RuntimeException("Zoom 인증 실패: Client ID 또는 Client Secret이 올바르지 않습니다.");

	    } else if (status == HttpStatus.BAD_REQUEST) {  // 400
	        if (responseBody.contains("invalid_client")) {
	            throw new RuntimeException("Zoom 인증 실패: Client ID가 올바르지 않습니다.");
	        } else if (responseBody.contains("invalid_request")) {
	            throw new RuntimeException("Zoom 인증 실패: Account ID가 올바르지 않거나 요청 형식이 잘못되었습니다.");
	        }
	        throw new RuntimeException("Zoom 토큰 요청 오류 [400]: " + responseBody);

	    } else {
	        throw new RuntimeException("Zoom 토큰 발급 실패 [" + status + "]: " + responseBody);
	    }
	}

	private void handleZoomBodyError(JsonNode body) {
	    String error = body.path("error").asText();
	    String errorDescription = body.path("error_description").asText();

	    switch (error) {
	        case "invalid_client":
	            throw new RuntimeException("Zoom 키 불일치: Client ID 또는 Secret이 잘못되었습니다. " +
	                "[" + errorDescription + "]");
	        case "invalid_grant":
	            throw new RuntimeException("Zoom 키 불일치: Account ID가 잘못되었습니다. " +
	                "[" + errorDescription + "]");
	        case "access_denied":
	            throw new RuntimeException("Zoom 접근 거부: 해당 앱의 권한이 없습니다. " +
	                "[" + errorDescription + "]");
	        default:
	            throw new RuntimeException("Zoom 토큰 에러: " + error + " - " + errorDescription);
	    }
	}

	// Onwer 정보 조회
    public JsonNode getOnwerInfo(String authrtTkn) {
    	URI uri = URI.create(UsersUrl.GET_OWNER_INFO.getUrl());

        ResponseEntity<JsonNode> response = zoomRestTemplateSupporter.exchange(
        		authrtTkn, UsersUrl.GET_OWNER_INFO, uri, JsonNode.class);

        if (response.getStatusCode() != HttpStatus.OK) {
            throw new RuntimeException("Owner 정보 조회 실패 [" + response.getStatusCode() + "]");
        }

        return response.getBody();
    }

}