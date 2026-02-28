package knou.lms.seminar.api.exception;

import java.nio.charset.Charset;

import org.springframework.http.HttpStatus;
import org.springframework.web.client.HttpClientErrorException;

/**
 * 
 * OAuth와 JWT 잘못된 토큰을 사용할 경우 사용하는 Exception<br>
 * OAuth와 JWT 모두, ZOOM으로 부터 같은 "Invalid access token." 메시지로 응답받는다.<br>
 * <br>
 * *주의사항<br>
 * OAuth토큰만 사용하는 곳에서는 catch하고 tb_tc_token_info에서 잘못된 토큰을 삭제한다.<br>
 * JWT 토큰을 사용하는 곳에서는 catch하면 tb_tc_token_info에서 토큰을 삭제하면 안된다.
 * 
 */
public class HttpClientTokenErrorException extends HttpClientErrorException {

	private static final long serialVersionUID = 6301239469910963431L;

	public HttpClientTokenErrorException(HttpStatus statusCode, String statusText, byte[] responseBody,
			Charset responseCharset) {
		super(statusCode, statusText, responseBody, responseCharset);
	}

}
