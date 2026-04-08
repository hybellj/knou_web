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
	public JsonNode fetchToken(String pltfrmCntnId, String pltfrmCntnClientId, String pltfrmCntnClientPswd) throws Exception {
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

        ResponseEntity<JsonNode> response = restTemplate.exchange(request, JsonNode.class);

        if (response.getStatusCode() != HttpStatus.OK) {
            throw new RuntimeException("토큰 발급 실패 [" + response.getStatusCode() + "]");
        }

        return response.getBody();
	}

	// Onwer 정보 조회
    public JsonNode getOnwerInfo(String authrtTkn) throws Exception {
    	URI uri = URI.create(UsersUrl.GET_OWNER_INFO.getUrl());

        ResponseEntity<JsonNode> response = zoomRestTemplateSupporter.exchange(
        		authrtTkn, UsersUrl.GET_OWNER_INFO, uri, JsonNode.class);

        if (response.getStatusCode() != HttpStatus.OK) {
            throw new RuntimeException("Owner 정보 조회 실패 [" + response.getStatusCode() + "]");
        }

        return response.getBody();
    }

}