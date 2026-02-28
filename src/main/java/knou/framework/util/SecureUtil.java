package knou.framework.util;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.AlgorithmParameterSpec;
import java.security.spec.RSAPublicKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.UUID;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspContext;
import javax.servlet.jsp.PageContext;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * 암호화 유틸리티
 */
public class SecureUtil {
	private static final Log log = LogFactory.getLog(SecureUtil.class);
	private final static int KEY_SIZE = 1024;
	private final static String RSA_KEY = "RSA_KEY";
	private final static String ENC_CHK_VALUE = "ENCODE_CHK_VALUE";
	private final static String CHAR_SET = "UTF-8";
	private final static String DEFAULT_KEY = "abcdefghijklmnopqrstuvwxyz123456";

	// 통합메시지 인증 토큰용 공개키
    private final static String RSA_PUBLIC_KEY = "30820122300d06092a864886f70d01010105000382010f003082010a02820101008645e3710c2b2594aabedc69266c19457b6ed8d91ab5241319cc75dcc44eaa941428f7bba0f0dfd11df0cdae8b2646bfdea48102791933d192ef45f115857d250ffc4728a7a8fd0f96b8948fbbf3b0fb679615574c8d761bce9a21ac0ae71424f853ec7948ed2993e63f80d94b1aea7b7f38f610e54ebcd68757e92db784eb67114e14ea86cda996b169f094968461e0e44e562994092250e26de30458945fb6d39f285e78e9fcac67fc5d35177df513aa8f8ce344a20cc79083d67c9558e16e5f86296a46608ee7d2f2d4146579348737567908dc351de531b9ca1d88334f1b6c1b8257485575fec48cfae5adee2dc4b7f7db6ae959e20d92aa08f3d1b669270203010001";

	/**
	 * 공개키 가져오기
	 * @param jspContext
	 * @return publicKey
	 */
	public static String getUserKey(JspContext jspContext) {
		HttpServletRequest request = (HttpServletRequest)((PageContext)jspContext).getRequest();
		return getUserKey(request);
	}

	/**
	 * 공개키 가져오기
	 * @param request
	 * @return publicKey
	 */
	public static String getUserKey(HttpServletRequest request) {
		KeyPair keyPair = (KeyPair)SessionUtil.getSessionValue(request, RSA_KEY);

		if (keyPair == null) {
			keyPair = createKeyPair();
			SessionUtil.setSessionValue(request, RSA_KEY, keyPair);
		}

		return getPublicKey(keyPair);
	}

	/**
	 * 공개키(Exponent) 가져오기
	 * @param request
	 * @return exponentKey
	 */
	public static String getUserKeyEx(HttpServletRequest request) {
		KeyPair keyPair = (KeyPair)SessionUtil.getSessionValue(request, RSA_KEY);

		if (keyPair == null) {
			keyPair = createKeyPair();
			SessionUtil.setSessionValue(request, RSA_KEY, keyPair);
		}

		return getPublicKeyExponent(keyPair);
	}

	/**
	 * Get KeyPair
	 * @param request
	 * @return
	 */
	private static KeyPair getKeyPair(HttpServletRequest request) {
		KeyPair keyPair = (KeyPair)SessionUtil.getSessionValue(request, RSA_KEY);

		if (keyPair == null) {
			keyPair = createKeyPair();
			SessionUtil.setSessionValue(request, RSA_KEY, keyPair);
		}

		return keyPair;
	}

	/**
	 * 암호화키 생성
	 * @return
	 */
	public static KeyPair createKeyPair() {
		KeyPair keyPair = null;
		try {
			KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
			generator.initialize(KEY_SIZE);
			keyPair = generator.genKeyPair();
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return keyPair;
	}

	/**
	 * Get 공개키
	 * @param keyPair
	 * @return
	 */
	public static String getPublicKey(KeyPair keyPair) {
		String key = null;
		try {
			KeyFactory keyFactory = KeyFactory.getInstance("RSA");
			RSAPublicKeySpec publicSpec = (RSAPublicKeySpec)keyFactory.getKeySpec(keyPair.getPublic(), RSAPublicKeySpec.class);
			key = publicSpec.getModulus().toString(16);
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return key;
	}

	/**
	 * Get PublicExponent
	 * @param keyPair
	 * @return
	 */
	public static String getPublicKeyExponent(KeyPair keyPair) {
		String keyExp = null;
		try {
			KeyFactory keyFactory = KeyFactory.getInstance("RSA");
			RSAPublicKeySpec publicSpec = (RSAPublicKeySpec)keyFactory.getKeySpec(keyPair.getPublic(), RSAPublicKeySpec.class);
			keyExp = publicSpec.getPublicExponent().toString(16);
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return keyExp;
	}


	/**
	 * 암호화된 문자열 복호화(RSA)
	 * @param privateKey
	 * @param securedValue
	 * @return decryptedValue
	 * @throws Exception
	 */
	public static String decodeRsa(PrivateKey privateKey, String securedValue) {
		String decryptedValue = "";

		try {
			if (securedValue != null && !securedValue.equals("")) {
				Cipher cipher = Cipher.getInstance("RSA");
				cipher.init(Cipher.DECRYPT_MODE, privateKey);

				byte[] encryptedBytes = hexToByteArray(securedValue);
				byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
				decryptedValue = new String(decryptedBytes, CHAR_SET);
			}
		} catch (Exception e) {
			decryptedValue = "";
		}

		return decryptedValue;
	}

	/**
	 * 암호화된 문자열 복호화(RSA)
	 * @param privateKey
	 * @param securedValue
	 * @return decryptedValue
	 * @throws Exception
	 */
	public static String decodeRsa(HttpServletRequest request, String value){
		KeyPair keyPair = getKeyPair(request);
		String decryptedValue = decodeRsa(keyPair.getPrivate(), value);

		return decryptedValue;
	}

	/**
	 * 암호화된 문자열 복호화(RSA)
	 * @param privateKey
	 * @param securedValue
	 * @return decryptedValue
	 * @throws Exception
	 */
	public static String decodeRsa(JspContext jspContext, String value) {
		HttpServletRequest request = (HttpServletRequest)((PageContext)jspContext).getRequest();
		return decodeRsa(request, value);
	}

	/**
	 * 문자열 암호화(RSA)
	 * @param publicKey
	 * @param value
	 * @return encryptedValue
	 * @throws Exception
	 */
	public static String encodeRsa(PublicKey publicKey, String value) throws Exception {
		Cipher cipher = Cipher.getInstance("RSA");
		cipher.init(Cipher.ENCRYPT_MODE, publicKey);

		String encryptedValue = "";
		if (value != null && !value.equals("")) {
			byte[] valueBytes = cipher.doFinal(value.getBytes(CHAR_SET));
			encryptedValue = byteArrayToHex(valueBytes);
		}

	    return encryptedValue;
	}

	/**
	 * 문자열 암호화(RSA)
	 * @param publicKey
	 * @param value
	 * @return encryptedValue
	 * @throws Exception
	 */
	public static String enccodeRsa(HttpServletRequest request, String value) throws Exception {
		KeyPair keyPair = getKeyPair(request);
		String encryptedValue = encodeRsa(keyPair.getPublic(), value);

		return encryptedValue;
	}

	/**
	 * 문자열 암호화(RSA)
	 * @param publicKey
	 * @param value
	 * @return encryptedValue
	 * @throws Exception
	 */
	public static String encodeRsa(JspContext jspContext, String value) throws Exception {
		HttpServletRequest request = (HttpServletRequest)((PageContext)jspContext).getRequest();
		return enccodeRsa(request, value);
	}


	/**
	 * 16진 문자열을 byte 배열로 변환
	 */
	private static byte[] hexToByteArray(String hex) {
		if (hex == null || hex.length() % 2 != 0) {
			return new byte[]{};
		}

		byte[] bytes = new byte[hex.length() / 2];
		for (int i = 0; i < hex.length(); i += 2) {
			byte value = (byte)Integer.parseInt(hex.substring(i, i + 2), 16);
			bytes[(int) Math.floor(i / 2)] = value;
		}
		return bytes;
	}

	/**
	 * byte 배열을 16진 문자열로 변환
	 */
	private static String byteArrayToHex(byte[] bytes){
	    StringBuilder sb = new StringBuilder();
	    for (byte b : bytes) {
	        sb.append(String.format("%02x", b&0xff));
	    }
	    return sb.toString();
	}

	/**
	 * 문자열 암호화(Base64)
	 * @param request
	 * @param value
	 * @return value
	 */
	public static String encodeStr(String value) {
		if (value != null) {
			try {
				value = encodeUrl(value);
				value = (new Base64()).encodeToString(value.getBytes(CHAR_SET));
			} catch (Exception e) {
				value = "";
				log.error(e.getMessage());
			}
		}

		return value;
	}

	/**
	 * 문자열 암호화(Base64, 암호화 체크값으로 검증)
	 * @param request
	 * @param value
	 * @return value
	 */
	public static String encodeSecureStr(HttpServletRequest request, String value) {
		if (value != null) {
			value = getEncChkValue(request) + encodeStr(value);
		}

		return value;
	}

	/**
	 * 문자열 복호화(Base64)
	 * @param request
	 * @param value
	 * @return value
	 */
	public static String decodeStr(String value) {
		if (value != null) {
			try {
				value = new String(java.util.Base64.getDecoder().decode(value), StandardCharsets.UTF_8);
				value = decodeUrl(value);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}

		return value;
	}

	/**
	 * 문자열 복호화(Base64, 암호화 체크값으로 검증)
	 * @param request
	 * @param value
	 * @return value
	 */
	public static String decodeSecureStr(HttpServletRequest request, String value) {
		if (value != null) {
			String userEnc = getEncChkValue(request);
			if (value.indexOf(userEnc) == 0) {
				value = value.substring(userEnc.length());
				value = decodeStr(value);
			}
			else {
				value = null;
			}
		}

		return value;
	}

	/**
	 * 암호화 체크 값
	 * @param request
	 * @return userEnc
	 */
	private static String getEncChkValue(HttpServletRequest request) {
		String chkValue = (String)SessionUtil.getSessionValue(request, ENC_CHK_VALUE);
		if (chkValue == null) {
			chkValue = UUID.randomUUID().toString().substring(0,4);
			SessionUtil.setSessionValue(request, ENC_CHK_VALUE, chkValue);
		}

		return chkValue;
	}

	/**
	 * Encode URL
	 * @param value
	 * @return encoded value
	 */
	public static String encodeUrl(String value) {
		if (value != null) {
			try {
				value = URLEncoder.encode(value, CHAR_SET);
			} catch (UnsupportedEncodingException e) {
				value = null;
			}
		}

		return value;
	}

	/**
	 * Decode URL
	 * @param value
	 * @return decoded value
	 */
	public static String decodeUrl(String value) {
		if (value != null) {
			try {
				value = URLDecoder.decode(value, CHAR_SET);
			} catch (UnsupportedEncodingException e) {
				value = null;
			}
		}
		return value;
	}

	/**
	 * 비밀번호 암호화 (SHA-256)
	 * @param value
	 * @return encValue
	 */
	public static String encodePassword(String value) {
		String encValue = "";

		try {
			MessageDigest sh = MessageDigest.getInstance("SHA-256");
			sh.update(value.getBytes());
			byte byteData[] = sh.digest();
			StringBuffer sb = new StringBuffer();

			for(int i = 0 ; i < byteData.length ; i++){
				sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
			}
			encValue = sb.toString();
		}
		catch(Exception e){
			log.error(e.getMessage());
		}

		return encValue;
	}


	// 통합메시지 인증 토큰
	public static String getMsgToken(String userId) {
	    String encValue = "";

	    try {
	        Calendar cal = Calendar.getInstance();
	        cal.setTime(new Date());
	        cal.add(Calendar.HOUR, 1);
	        String date = (new SimpleDateFormat("yyyyMMddHHmmss")).format(cal.getTime());
	        String value = userId + "," + date;

	        byte[] pubBytes = new byte[RSA_PUBLIC_KEY.length() / 2];
	        for (int i = 0; i < RSA_PUBLIC_KEY.length(); i += 2) {
	            pubBytes[(int) Math.floor(i / 2)] = (byte)Integer.parseInt(RSA_PUBLIC_KEY.substring(i, i + 2), 16);
	        }

	        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(pubBytes);
	        PublicKey pubKey = (KeyFactory.getInstance("RSA")).generatePublic(keySpec);
	        Cipher cipher = Cipher.getInstance("RSA");
	        cipher.init(Cipher.ENCRYPT_MODE, pubKey);

	        StringBuilder sb = new StringBuilder();
	        for (byte b : cipher.doFinal(value.getBytes("utf-8"))) {
	            sb.append(String.format("%02x", b&0xff));
	        }

	        encValue = sb.toString();;

	    } catch (Exception e) {
	        log.error(e.getMessage());
	    }

	    return encValue;
	}


	// RSA 암호화
	public static String getRSAEncript(String value) {
	    String encValue = "";

	    try {
	        byte[] pubBytes = new byte[RSA_PUBLIC_KEY.length() / 2];
	        for (int i = 0; i < RSA_PUBLIC_KEY.length(); i += 2) {
	            pubBytes[(int) Math.floor(i / 2)] = (byte)Integer.parseInt(RSA_PUBLIC_KEY.substring(i, i + 2), 16);
	        }

	        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(pubBytes);
	        PublicKey pubKey = (KeyFactory.getInstance("RSA")).generatePublic(keySpec);
	        Cipher cipher = Cipher.getInstance("RSA");
	        cipher.init(Cipher.ENCRYPT_MODE, pubKey);

	        StringBuilder sb = new StringBuilder();
	        for (byte b : cipher.doFinal(value.getBytes("utf-8"))) {
	            sb.append(String.format("%02x", b&0xff));
	        }

	        encValue = sb.toString();;

	    } catch (Exception e) {
	        log.error(e.getMessage());
	    }

	    return encValue;
	}


	// AES-128 CBC 암호화
	public static String encodeAesCbc(String str, String iv, String skey) {
	    try {
	        if (skey == null || "".equals(skey)) {
	            skey = DEFAULT_KEY;
	        }

	        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
	        SecretKeySpec secretKey = new SecretKeySpec(skey.getBytes("UTF-8"), "AES");
	        IvParameterSpec ivSpec = null;

	        if (iv != null && !"".equals(iv)) {
	            ivSpec = new IvParameterSpec(iv.getBytes());
	        }
	        else {
	            byte[] ivBytes = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
	            ivSpec = new IvParameterSpec(ivBytes);
	        }

	        cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivSpec);
	        byte[] encrpytionByte = cipher.doFinal(str.getBytes("UTF-8"));

	        str = new String(Base64.encodeBase64(encrpytionByte));

        } catch (Exception e) {
        }

        return str;
    }

	// AES-128 CBC 복호화
	public static String decodeAesCbc(String str, String iv, String skey) {
	    try {
    	    if (skey == null || "".equals(skey)) {
    	        skey = DEFAULT_KEY;
    	    }

    	    byte[] textBytes = Base64.decodeBase64(str);
    	    SecretKeySpec newKey = new SecretKeySpec(skey.getBytes("UTF-8"), "AES");
    	    AlgorithmParameterSpec ivSpec = null;

    	    if (iv != null && !"".equals(iv)) {
                ivSpec = new IvParameterSpec(iv.getBytes());
            }
            else {
                byte[] ivBytes = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
                ivSpec = new IvParameterSpec(ivBytes);
            }

    	    Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
    	    cipher.init(Cipher.DECRYPT_MODE, newKey, ivSpec);

    	    str = new String(cipher.doFinal(textBytes), "UTF-8");

	    } catch (Exception e) {
        }

	    return str;
	}

	// 다운로드경로 암호화
	public static String encodeDownPath(String path) {
	    path = encodeAesCbc(path, null, null);
	    path = path.replace("+", "[p]");
	    return path;
	}

	// 다운로드경로 복호화
	public static String decodeDownPath(String path) {
	    path = path.replace("[p]", "+");
        return decodeAesCbc(path, null, null);
    }
}
