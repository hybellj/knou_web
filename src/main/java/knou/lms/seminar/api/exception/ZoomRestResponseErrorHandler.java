package knou.lms.seminar.api.exception;

import java.io.IOException;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.ResponseErrorHandler;

public class ZoomRestResponseErrorHandler implements ResponseErrorHandler {

	private static final Logger LOGGER = LoggerFactory.getLogger("tc");

	@Override
	public boolean hasError(ClientHttpResponse clientHttpResponse) throws IOException {
		return !clientHttpResponse.getStatusCode().is2xxSuccessful();
	}

	@Override
	public void handleError(ClientHttpResponse clientHttpResponse) throws IOException {
		LOGGER.error("Response HttpStatusCode={} {}", clientHttpResponse.getStatusCode(),
				IOUtils.toString(clientHttpResponse.getBody()),
				clientHttpResponse.getHeaders().getContentType().getCharset());

		byte[] responseBodyAsByteArray = IOUtils.toByteArray(clientHttpResponse.getBody());

		if (ZoomRestResponseErrorSupporter.isInvalidAccessToken(responseBodyAsByteArray)) {
			// OAuth토큰을 삭제하고 재발급 받도록 Exception을 발생시킨다.
			// OAuth와 JWT 모두, 같은 "Invalid access token." 메시지로 응답받기 때문에
			// JWT 토큰 사용하는 곳에서는 토큰을 삭제하면 안된다.
			throw new HttpClientTokenErrorException(clientHttpResponse.getStatusCode(),
					clientHttpResponse.getStatusText(), responseBodyAsByteArray,
					clientHttpResponse.getHeaders().getContentType().getCharset());
		}

		throw new HttpClientErrorException(clientHttpResponse.getStatusCode(), clientHttpResponse.getStatusText(),
				responseBodyAsByteArray, clientHttpResponse.getHeaders().getContentType().getCharset());
	}

}
