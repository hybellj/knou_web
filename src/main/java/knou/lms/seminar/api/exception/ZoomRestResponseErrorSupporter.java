package knou.lms.seminar.api.exception;

import java.io.IOException;
import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.client.HttpClientErrorException;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * ZOOM API호출해서 응답받는 에러코드를 VC에서 사용하는 ErrorType을 변환하거나,<br>
 * 특정 에러인지 판단한다.
 */
public class ZoomRestResponseErrorSupporter {
	
	private static final Logger LOGGER = LoggerFactory.getLogger("tc");

	// ZOOM API에 정의된 에러코드
	private static final int INVALID_ACCESS_TOKEN = 124;
	private static final int NOT_EXIST_USER = 1001;
	private static final int NOT_CREATED_BASIC_USER = 3412;

	public static boolean isInvalidAccessToken(byte[] responseBody) {
		int errorCode = getErrorCode(responseBody);
		return INVALID_ACCESS_TOKEN == errorCode;
	}
	
	/**
	 * ZOOM은 관리 계정당 Basic 사용자를 기본으로 9,999개까지 생성할 수 있다.
	 * 
	 * @param responseBody HttpClientErrorException.getResponseBodyAsByteArray()에서 받을 수 있는 에러
	 * @return Basic 사용자를 더 이상 생성할 수 없으면 true를 반환한다. 
	 */
	public static boolean isMaximumBasicUsers(byte[] responseBody) {
		int errorCode = getErrorCode(responseBody);
		return NOT_CREATED_BASIC_USER == errorCode;
	}

	/**
	 * HttpClientErrorException에서 ZOOM의 에러코드를 읽어 해당되는 ErrorType으로 반환한다.<br>
	 * <ul>
	 * <li>사용자가 없는 경우</li>
	 * </ul>
	 * 상위 조건 외는 API_RESPONSE_ERROR으로 반환한다.<br>
	 * <br>
	 * 변환하고자하는 ZOOM 에러 코드가 있을 때, 이 메소드를 수정해서 사용한다.
	 * 
	 * @param HttpClientErrorException 
	 * @return ErrorType
	 */
	public static ErrorType getErrorType(HttpClientErrorException exception) {
		int errorCode = getErrorCode(exception.getResponseBodyAsByteArray());
		switch (errorCode) {
		case NOT_EXIST_USER:
			return ErrorType.API_NOT_EXIST_USER;
		default:
			return ErrorType.API_RESPONSE_ERROR;
		}
	}

	private static int getErrorCode(byte[] responseBody) {
		HashMap<String, Object> bodyMap;
		try {
			bodyMap = new ObjectMapper()
					.readValue(responseBody, new TypeReference<HashMap<String, Object>>() {});
			if (bodyMap.containsKey("code")) {
				return (Integer) bodyMap.get("code");
			}
		} catch (IOException e) {
			LOGGER.error(e.getMessage(), e);
		}
		return -1;
	}

}
