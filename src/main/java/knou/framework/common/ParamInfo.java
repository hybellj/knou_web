package knou.framework.common;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

/**
 * 파라메 정보
 */
public class ParamInfo {

	/**
	 * 암호화 파라메터에서 값 읽어오기
	 * @param request
	 * @param name
	 * @return
	 */
	public static String getParamValue(HttpServletRequest request, String name) {
		String value = "";

		@SuppressWarnings("unchecked")
		Map<String, String> eparamMap = (Map<String, String>) request.getAttribute("eparamMap");
		if (eparamMap != null && eparamMap.containsKey(name)) {
			value = eparamMap.get(name);
		}

		return value;
	}
}
