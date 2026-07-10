package knou.framework.util;

/*import common.config.ConstantSecureKeys;
import common.encrypt.AESCryptor;*/
import knou.framework.util.ConstantSecureKeys;
import knou.framework.util.AESCryptor;

/**
 * http 통신에서 사용되는 파라미터 암호화를 적용하여 값을 인코딩/디코딩한다.
 * 추후 암호화 변경시 이 곳에서만 변경하면 됨.
 * @author truwind
 *
 */
public class HttpParamMrg {

	/**
	 * base64Url + AES/CBC/5Padding decode를 푼 값을 반환.
	 * @param param
	 * @return
	 */
	public static String getDecodedValue(String paramValue) {
		if(paramValue == null || paramValue.isEmpty()) return "";

		String decodedValue = AESCryptor.decryptStringWithAES128(paramValue);
		return decodedValue;
	}

	/**
	 * 값을 AES/CBC/5Padding 암호화 + base64Url encode한 값을 반환한다.
	 * @param paramValue
	 * @return
	 */
	public static String getEncodedValue(String paramValue) {
		if(paramValue == null || paramValue.isEmpty()) return "";

		String encodedValue = AESCryptor.encryptStringWithAES128(paramValue);
		return encodedValue;
	}

	/**
	 * base64Url + AES/CBC/5Padding decode를 푼 값을 반환.
	 * @param param
	 * @return
	 */
	public static String decodedValueForSite(String paramValue) {
		if(paramValue == null || paramValue.isEmpty()) return "";

		return AESCryptor.decryptAES128(ConstantSecureKeys.passphraseForSite, paramValue);
	}

	/**
	 * 값을 AES/CBC/5Padding 암호화 + base64Url encode한 값을 반환한다.
	 * @param paramValue
	 * @return
	 */
	public static String encodedValueForSite(String paramValue) {
		if(paramValue == null || paramValue.isEmpty()) return "";

		return AESCryptor.encryptAES128(ConstantSecureKeys.passphraseForSite, paramValue);
	}
}
