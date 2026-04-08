package knou.lms.smnr.pltfrm.zoom.api.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import knou.lms.smnr.pltfrm.zoom.api.common.vo.ZoomPagenationVO;

import java.net.URI;

@Component
public class ZoomRestTemplateSupporter {

    private static final int PAGE_SIZE_MAX = 300;

    @Autowired
    @Qualifier("zoomRestTemplate")
    private RestTemplate restTemplate;

    // Body 있는 요청 (POST, PATCH)
    public <T> ResponseEntity<T> exchange(String authrtTkn, ZoomApiUrl apiUrlEnum,
            URI url, Object requestBody, Class<T> responseType) {

        RequestEntity<Object> request = RequestEntity
            .method(apiUrlEnum.getMethod(), url)
            .contentType(MediaType.APPLICATION_JSON)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + authrtTkn)
            .body(requestBody);

        return restTemplate.exchange(request, responseType);
    }

    // Body 없는 요청 (GET, DELETE)
    public <T> ResponseEntity<T> exchange(String authrtTkn, ZoomApiUrl apiUrlEnum,
            URI url, Class<T> responseType) {

        RequestEntity<Object> request = RequestEntity
            .method(apiUrlEnum.getMethod(), url)
            .accept(MediaType.APPLICATION_JSON)
            .contentType(MediaType.APPLICATION_JSON)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + authrtTkn)
            .body(null);

        return restTemplate.exchange(request, responseType);
    }

    // 목록 조회 (페이징 자동 처리)
    public <T> ResponseEntity<T> exchangePageList(String authrtTkn, ZoomApiUrl apiUrlEnum,
            URI url, Class<T> responseType) {

        return exchangeList(authrtTkn, apiUrlEnum.getMethod(), url, responseType, null);
    }

    @SuppressWarnings("unchecked")
    private <T> ResponseEntity<T> exchangeList(String authrtTkn, HttpMethod method,
            URI url, Class<T> responseType, String nextPageToken) {

        UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromUri(url)
            .queryParam("page_size", PAGE_SIZE_MAX);

        if (nextPageToken != null && !nextPageToken.isEmpty()) {
            uriBuilder.queryParam("next_page_token", nextPageToken);
        }

        UriComponents uriComponents = uriBuilder.build();

        RequestEntity<Object> request = RequestEntity
            .method(method, uriComponents.toUri())
            .accept(MediaType.APPLICATION_JSON)
            .contentType(MediaType.APPLICATION_JSON)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + authrtTkn)
            .body(null);

        ResponseEntity<T> response = restTemplate.exchange(request, responseType);
        ZoomPagenationVO pagenation = (ZoomPagenationVO) response.getBody();

        // 다음 페이지 있으면 재귀 호출
        if (response.getStatusCode() == HttpStatus.OK
                && pagenation.getNextPageToken() != null
                && !pagenation.getNextPageToken().isEmpty()) {

            ResponseEntity<T> nextResponse = exchangeList(
                authrtTkn, method, url, responseType, pagenation.getNextPageToken());

            ZoomPagenationVO nextPagenation = (ZoomPagenationVO) nextResponse.getBody();
            nextPagenation.getObjects().addAll(pagenation.getObjects());
            response = nextResponse;
        }

        return response;
    }
}