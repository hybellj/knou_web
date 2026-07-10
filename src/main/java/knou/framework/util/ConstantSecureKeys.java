package knou.framework.util;

/**
 * 암호화에 필요한 모든 키 값들은 이곳에 정의하여 관리할것.
 * MUST : 사이트 배포시 해당 키 값은 반드시 변경할것.
 * @author apple
 *
 */
public class ConstantSecureKeys {
	public static final String kJwtTokenProviderSecret = "tjdn123!";

	public static final String kTokenSecureKey	= "k2DEjm36";

	/**
	 * AES network 통신 암호화 키
	 */
	public static final String passphrase = "ZpC2hORuAHM7wOa9";

	/**
	 * [2023.02.27] AppToApp 시나리오 : 호출 앱에서 사용할 암호화키.
	 */
	public static final String passphraseForSite = "ZpC2hORuAHM7wOa9";
}
