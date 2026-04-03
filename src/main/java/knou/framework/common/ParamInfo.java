package knou.framework.common;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import knou.framework.util.JsonUtil;
import knou.framework.util.SecureUtil;

/**
 * 파라메터 정보
 */
public class ParamInfo {
	private static Log log = LogFactory.getLog(ParamInfo.class);

	/**
	 * 암호화 파라메터에서 값 읽어오기
	 * @param request
	 * @param name
	 * @return
	 */
	public static String getParamValue(HttpServletRequest request, String name) {
		String value = "";

		try {
			String encParams = (String) request.getAttribute("encParams");

			if (encParams != null && !"".equals(encParams)) {
				Map<String, Object> paramMap = JsonUtil.jsonToMap(SecureUtil.decodeStr(encParams));
				if (paramMap.containsKey(name)) {
					value = (String)paramMap.get(name);
				}
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		
		log.info(">>>>>>>>>ParamInfo.value=" + value);

		return value;
	}
}
