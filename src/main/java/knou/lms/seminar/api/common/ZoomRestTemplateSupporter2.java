package knou.lms.seminar.api.common;

import java.net.URI;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import knou.framework.util.StringUtil;
import knou.lms.seminar.api.common.vo.PagenationVO;

@Component
public class ZoomRestTemplateSupporter2 {

private static final int PAGE_SIZE_MAX = 300;

    private static final Logger LOGGER = LoggerFactory.getLogger("tc");

    @Autowired
    @Qualifier("zoomRestTemplate")
    private RestTemplate restTemplate;

    public <T> ResponseEntity<T> exchange(String accessToken, ZoomApiUrl apiUrlEnum, URI url, Object requestBody,
            Class<T> responseType) {
        printLog(apiUrlEnum, url);
        RequestEntity<Object> request = RequestEntity.method(apiUrlEnum.getMethod(), url)
                .contentType(MediaType.APPLICATION_JSON)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken).body(requestBody);
        return restTemplate.exchange(request, responseType);
    }

    public <T> ResponseEntity<T> exchange(String accessToken, ZoomApiUrl apiUrlEnum, URI url, Class<T> responseType) {
        printLog(apiUrlEnum, url);
        RequestEntity<Object> request = RequestEntity.method(apiUrlEnum.getMethod(), url)
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken).body(null);
        return restTemplate.exchange(request, responseType);
    }

    public <T> ResponseEntity<T> exchangePageList(String accessToken, ZoomApiUrl apiUrlEnum, URI url, Class<T> responseType) {
        printLog(apiUrlEnum, url);
        return exchangeList(accessToken, apiUrlEnum.getMethod(), url, responseType, null);
    }

    @SuppressWarnings("unchecked")
    private <T> ResponseEntity<T> exchangeList(String accessToken, HttpMethod method, URI url, Class<T> responseType,
            String nextPageToken) {
        UriComponentsBuilder uribuilder = UriComponentsBuilder.fromUri(url).queryParam("page_size", PAGE_SIZE_MAX);
        if (StringUtil.isNotNull(nextPageToken)) {
            uribuilder.queryParam("next_page_token", nextPageToken);
        }
        UriComponents uriComponents = uribuilder.build();

        RequestEntity<Object> request = RequestEntity.method(method, uriComponents.toUri())
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken).body(null);

        ResponseEntity<T> response = restTemplate.exchange(request, responseType);
        PagenationVO pagenation = (PagenationVO) response.getBody();

        if (response.getStatusCode() == HttpStatus.OK && StringUtil.isNotNull(pagenation.getNextPageToken())) {
            ResponseEntity<T> nextResponse = this.exchangeList(accessToken, method, url, responseType,
                    pagenation.getNextPageToken());
            PagenationVO nextPagenation = (PagenationVO) nextResponse.getBody();
            nextPagenation.getObjects().addAll(pagenation.getObjects());
            // nextPageToken 값이 없는 마지막 Object에 담기위해 서로 바꾼다.
            response = nextResponse;
        }

        return response;
    }

    private void printLog(ZoomApiUrl apiUrlEnum, URI url) {
        LOGGER.info("Request API {}. HttpMethod={}, URL={}", apiUrlEnum, apiUrlEnum.getMethod(), url);
    }

}
