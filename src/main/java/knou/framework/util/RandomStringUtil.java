package knou.framework.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * MD5 알고리즘을 이용한 랜덤문자열을 생성.
 */
public class RandomStringUtil {
	protected static final Log log = LogFactory.getLog(RandomStringUtil.class);
	
	private RandomStringUtil() {
		throw new IllegalStateException("RandomStringUtil class");
	}
	
	public static String getRandomMD5() {
	    String result = null;

	    try {
	        MessageDigest digest = MessageDigest.getInstance("SHA-256");
	        byte[] hash = digest.digest(String.valueOf(
	                new SecureRandom().nextInt(1000000)).getBytes(StandardCharsets.UTF_8));
	        result = bytesToHex(hash);
	        if (result.length() > 32) {
	        	result = result.substring(0,32);
	        }
	    } catch (NoSuchAlgorithmException e) {
	    	log.error(e.getMessage());
	    }

	    return result;
	}

	private static String bytesToHex(byte[] bytes) {
	    StringBuilder hexString = new StringBuilder(2 * bytes.length);
	    for (byte b : bytes) {
	        String hex = Integer.toHexString(0xff & b);
	        if (hex.length() == 1) {
	            hexString.append('0');
	        }
	        hexString.append(hex);
	    }
	    return hexString.toString();
	}

}
