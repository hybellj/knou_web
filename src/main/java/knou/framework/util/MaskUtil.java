package knou.framework.util;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * 개인정보 마스킹 유틸리티
 */
public class MaskUtil {
	private static Log log = LogFactory.getLog(MaskUtil.class);

	/**
	 * 사용자 이름 마스킹
	 * @param userNm
	 * @return
	 */
	public static String maskUserNm(String userNm) {
		try {
			if (userNm != null && !"".equals(userNm)) {
			    boolean isKorean = userNm.chars().anyMatch(c ->
			    		Character.UnicodeBlock.of(c) == Character.UnicodeBlock.HANGUL_SYLLABLES ||
			            Character.UnicodeBlock.of(c) == Character.UnicodeBlock.HANGUL_JAMO ||
			            Character.UnicodeBlock.of(c) == Character.UnicodeBlock.HANGUL_COMPATIBILITY_JAMO);

		        if (isKorean) { // 한글이름
		        	int length = userNm.length();
		        	if (length <= 2) {
		                userNm = userNm.charAt(0) + "*";
		            } else if (length == 3) {
		            	userNm = userNm.charAt(0) + "*" + userNm.charAt(2);
		            } else if (length == 4) {
		            	userNm = userNm.charAt(0) + "**" + userNm.charAt(3);
		            } else {
		                StringBuilder maskedName = new StringBuilder();
		                maskedName.append(userNm.substring(0, 2));
		                for (int i = 2; i < length - 1; i++) {
		                    maskedName.append('*');
		                }
		                maskedName.append(userNm.charAt(length - 1));
		                userNm = maskedName.toString();
		            }
		        }
		        else { // 영문이름
		            String[] parts = userNm.split(" ");
		            StringBuilder maskedName = new StringBuilder();
		            for (String part : parts) {
		                if (part.length() <= 2) {
		                    maskedName.append(part.charAt(0)).append("* ");
		                } else {
		                    maskedName.append(part.charAt(0)).append("*".repeat(part.length() - 2)).append(part.charAt(part.length() - 1)).append(" ");
		                }
		            }
		            userNm = maskedName.toString().trim();
		        }
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return userNm;
	}

	/**
	 * 사용자 전화번호 마스킹
	 * @param phoneNo
	 * @return
	 */
	public static String maskPhoneNo(String phoneNo) {
		try {
			if (phoneNo != null && !"".equals(phoneNo)) {
		        String digits = phoneNo.replaceAll("\\D", "");
		        String start = digits.substring(0, 3);
		        String end = digits.substring(digits.length() - 4);
		        String middle = "*".repeat(digits.length() - 7);

		        if (phoneNo.contains("-")) {
		            phoneNo = start + "-" + middle + "-" + end;
		        } else {
		        	phoneNo = start + middle + end;
		        }
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return phoneNo;
	}

	/**
	 * 이메일 마스킹
	 * @param email
	 * @return
	 */
	public static String maskEmail(String email) {
		try {
			if (email != null && !"".equals(email)) {
		        int atIndex = email.indexOf("@");
		        if (atIndex > 2) {
			        String prefix = email.substring(0, 2);
			        String suffix = email.substring(atIndex);
			        String maskedPart = "*".repeat(atIndex - 2);
			        email = prefix + maskedPart + suffix;
		        }
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return email;
    }

	/**
	 * 주소 마스킹
	 * @param address
	 * @return
	 */
	public static String maskAddress(String address) {
		try {
			if (address != null && !"".equals(address)) {
				address = address.replaceAll("\\d", "*");
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return address;
    }

	/**
	 * 주민번호 마스킹
	 * @param juminNo
	 * @return
	 */
    public static String maskJuminNo(String juminNo) {
		try {
	    	if (juminNo != null && !"".equals(juminNo)) {
	    		if (juminNo.contains("-")) {
	    			juminNo = juminNo.replaceAll("(?<=\\d{6}-)\\d{7}", "*******"); // 901231-1234567 (하이픈이 존재하는 경우)
				} else {
					juminNo = juminNo.replaceAll("\\d{7}$", "*******"); // 9012311234567 (하이픈이 존재하지 않는 경우)
				}
	    	}
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return juminNo;
    }

    /**
     * IP Address 마스킹
     * @param ipAddress
     * @return
     */
    public static String maskIpAddress(String ipAddress) {
		try {
	    	if (ipAddress != null && !"".equals(ipAddress)) {
		    	if (ipAddress.contains(".")) {
		            String[] parts = ipAddress.split("\\.");
		            if (parts.length == 4) {
		                parts[2] = "***";
		                ipAddress = String.join(".", parts);
		            }
		        } else if (ipAddress.contains(":")) {
		            String[] parts = ipAddress.split(":");
		            if (parts.length == 8) {
		                parts[parts.length - 2] = "***";
		                ipAddress = String.join(":", parts);
		            }
		        }
	    	}
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return ipAddress;
    }
}
