package knou.framework.taglib;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import knou.framework.common.CommConst;
import knou.framework.common.ParamInfo;
import knou.framework.util.MaskUtil;

/**
 * 공통 함수 태그
 */
public class CommFunctionTag {
	private static Log log = LogFactory.getLog(CommFunctionTag.class);

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
		try {
			if ("Y".equals(CommConst.USERINFO_MASK_YN)) {
				userNm = MaskUtil.maskUserNm(userNm);
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return userNm;
	}

	/** 전화번호 마스킹
	 * @param phoneNo
	 * @return String
	 */
	public static String maskPhoneNo(String phoneNo) {
		try {
			if ("Y".equals(CommConst.USERINFO_MASK_YN)) {
				phoneNo = MaskUtil.maskPhoneNo(phoneNo);
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return phoneNo;
	}

	/** 이메일 마스킹
	 * @param email
	 * @return String
	 */
	public static String maskEmail(String email) {
		try {
			if ("Y".equals(CommConst.USERINFO_MASK_YN)) {
				email = MaskUtil.maskEmail(email);
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return email;
	}

	/** 주소 마스킹
	 * @param address
	 * @return String
	 */
	public static String maskAddress(String address) {
		try {
			if ("Y".equals(CommConst.USERINFO_MASK_YN)) {
				address = MaskUtil.maskAddress(address);
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return address;
	}

	/** 주민번호 마스킹
	 * @param juminNo
	 * @return String
	 */
	public static String maskJuminNo(String juminNo) {
		try {
			if ("Y".equals(CommConst.USERINFO_MASK_YN)) {
				juminNo = MaskUtil.maskJuminNo(juminNo);
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return juminNo;
	}

	/** IP Address 마스킹
	 * @param ipAddress
	 * @return String
	 */
	public static String maskIpAddress(String ipAddress) {
		try {
			if ("Y".equals(CommConst.USERINFO_MASK_YN)) {
				ipAddress = MaskUtil.maskIpAddress(ipAddress);
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return ipAddress;
	}
}
