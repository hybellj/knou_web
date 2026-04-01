package knou.framework.taglib;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import knou.framework.common.ParamInfo;
import knou.framework.util.MaskUtil;

/**
 * 공통 함수 태그
 */
public class CommFunctionTag {
	private CommFunctionTag() {
		throw new IllegalStateException("CommFunctionTag class");
	}


	/**
	 * 암호화 파라메터값 가져오기
	 * @param name
	 * @return String
	 */
	public static String getParamValue(String name) {
		ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
	    HttpServletRequest request = sra.getRequest();

	    return ParamInfo.getParamValue(request, name);
	}

	/**
	 * 사용자 이름 마스킹
	 * @param userNm
	 * @return String
	 */
	public static String maskUserNm(String userNm) {
		return MaskUtil.maskUserNm(userNm);
	}

	/** 전화번호 마스킹
	 * @param phoneNo
	 * @return String
	 */
	public static String maskPhoneNo(String phoneNo) {
		return MaskUtil.maskPhoneNo(phoneNo);
	}

	/** 이메일 마스킹
	 * @param email
	 * @return String
	 */
	public static String maskEmail(String email) {
		return MaskUtil.maskEmail(email);
	}

	/** 주소 마스킹
	 * @param address
	 * @return String
	 */
	public static String maskAddress(String address) {
		return MaskUtil.maskAddress(address);
	}

	/** 주민번호 마스킹
	 * @param juminNo
	 * @return String
	 */
	public static String maskJuminNo(String juminNo) {
		return MaskUtil.maskJuminNo(juminNo);
	}

	/** IP Address 마스킹
	 * @param ipAddress
	 * @return String
	 */
	public static String maskIpAddress(String ipAddress) {
		return MaskUtil.maskIpAddress(ipAddress);
	}
}
