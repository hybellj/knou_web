package knou.framework.util;

import java.nio.ByteBuffer;
import java.security.AlgorithmParameters;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.lang3.CharEncoding;

import knou.framework.util.ConstantSecureKeys;

public class AESCryptor {

    // === Base64url 유틸 (EncodeUtil 대체) ===
    private static String base64UrlEncodeString(byte[] data) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(data);
    }

    private static byte[] base64UrlDecodeString(String value) {
        // 패딩이 붙어 와도 처리되도록 보정
        String v = value;
        int rem = v.length() % 4;
        if (rem == 2) v += "==";
        else if (rem == 3) v += "=";
        return Base64.getUrlDecoder().decode(v);
    }
    // =====================================

    public static String encryptStringWithAES128(String plaintext)  {
    	return AESCryptor.encryptAES128(ConstantSecureKeys.passphrase, plaintext);
    }

    public static String encryptIntWithAES128(int plainInt)  {
    	String plaintext = Integer.toString(plainInt);
    	return AESCryptor.encryptAES128(ConstantSecureKeys.passphrase, plaintext);
    }

    public static String encryptAES128(String key, String plaintext)  {
        try {
            byte[] keyData = key.getBytes(CharEncoding.UTF_8);

            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(keyData, "AES"), new IvParameterSpec(keyData));

            byte[] encryptd = cipher.doFinal(plaintext.getBytes(CharEncoding.UTF_8));

            return base64UrlEncodeString(encryptd);
        } catch ( Exception e) {
            return null;
        }
    }

    public static String decryptStringWithAES128(String encryptedText)  {
    	return AESCryptor.decryptAES128(ConstantSecureKeys.passphrase, encryptedText);
    }

    public static String decryptIntWithAES128(int encryptedInt)  {
    	String encryptedText = Integer.toString(encryptedInt);
    	return AESCryptor.decryptAES128(ConstantSecureKeys.passphrase, encryptedText);
    }

    public static String decryptAES128(String key, String encryptedText)  {
        try {
            byte[] keyData = key.getBytes(CharEncoding.UTF_8);

            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(keyData, "AES"), new IvParameterSpec(keyData));

            byte[] base64Decoded = base64UrlDecodeString(encryptedText);
            byte[] decrypted = cipher.doFinal(base64Decoded);

            return new String(decrypted, CharEncoding.UTF_8);

        } catch (Exception e) {
            return null;
        }
    }

    public static void test() {
        String plainText = "{\"idx\":\"1234\",\"userid\":\"rmc00001\",\"otp\":\"12345\",\"time\":\"2019-09-18 15:53:00\"}";
        String enc = AESCryptor.encryptAES128(ConstantSecureKeys.passphrase, plainText);
        System.out.println( "AES Helper e : " + enc);
        String result2 = AESCryptor.decryptAES128(ConstantSecureKeys.passphrase, enc);
        System.out.println("AES Helper d: " + result2);

        String result = AESCryptor.decryptAES128(ConstantSecureKeys.passphrase, "a8FvcyD0m04AZbMKO8JxdydlCuqvq68gvJoDWHLOI5oYNoFLtYp8ncoSueh9wRqdi8cYPcaXUtg-LUhkN1q080dsXfjV7OPHOMWhAvr6Y6s");
        System.out.println("AES Helper d2: " + result);
    }


    /////////AES256///////
    public static String encryptStringWithAES256(String plaintext)  {
    	return AESCryptor.encryptAES256(ConstantSecureKeys.passphrase, plaintext);
    }

    public static String encryptIntWithAES256(int plainInt)  {
    	String plaintext = Integer.toString(plainInt);
    	return AESCryptor.encryptAES256(ConstantSecureKeys.passphrase, plaintext);
    }

    public static String decryptStringWithAES256(String encryptedText)  {
    	return AESCryptor.decryptAES256(ConstantSecureKeys.passphrase, encryptedText);
    }

    public static String decryptIntWithAES256(int encryptedInt)  {
    	String encryptedText = Integer.toString(encryptedInt);
    	return AESCryptor.decryptAES256(ConstantSecureKeys.passphrase, encryptedText);
    }

    public static String encryptAES256(String key, String msg) {
    	try {
    		SecureRandom random = new SecureRandom();
            byte bytes[] = new byte[20];
            random.nextBytes(bytes);
            byte[] saltBytes = bytes;

            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
            PBEKeySpec spec = new PBEKeySpec(key.toCharArray(), saltBytes, 70000, 256);

            SecretKey secretKey = factory.generateSecret(spec);
            SecretKeySpec secret = new SecretKeySpec(secretKey.getEncoded(), "AES");

            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, secret);
            AlgorithmParameters params = cipher.getParameters();

            byte[] ivBytes = params.getParameterSpec(IvParameterSpec.class).getIV();
            byte[] encryptedTextBytes = cipher.doFinal(msg.getBytes("UTF-8"));

            byte[] buffer = new byte[saltBytes.length + ivBytes.length + encryptedTextBytes.length];
            System.arraycopy(saltBytes, 0, buffer, 0, saltBytes.length);
            System.arraycopy(ivBytes, 0, buffer, saltBytes.length, ivBytes.length);
            System.arraycopy(encryptedTextBytes, 0, buffer, saltBytes.length + ivBytes.length, encryptedTextBytes.length);

            return Base64.getEncoder().encodeToString(buffer);
    	}
    	catch (Exception e) {
    		return null;
		}
    }

    public static String decryptAES256(String key, String msg) {
    	try {
    		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            ByteBuffer buffer = ByteBuffer.wrap(Base64.getDecoder().decode(msg));

            byte[] saltBytes = new byte[20];
            buffer.get(saltBytes, 0, saltBytes.length);
            byte[] ivBytes = new byte[cipher.getBlockSize()];
            buffer.get(ivBytes, 0, ivBytes.length);
            byte[] encryoptedTextBytes = new byte[buffer.capacity() - saltBytes.length - ivBytes.length];
            buffer.get(encryoptedTextBytes);

            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
            PBEKeySpec spec = new PBEKeySpec(key.toCharArray(), saltBytes, 70000, 256);

            SecretKey secretKey = factory.generateSecret(spec);
            SecretKeySpec secret = new SecretKeySpec(secretKey.getEncoded(), "AES");

            cipher.init(Cipher.DECRYPT_MODE, secret, new IvParameterSpec(ivBytes));

            byte[] decryptedTextBytes = cipher.doFinal(encryoptedTextBytes);
            return new String(decryptedTextBytes);
    	}
    	catch (Exception e) {
    		return null;
		}
    }

	 // mSABER 파라미터 암호화 — AESCryptor.encryptAES128 과 동일(CBC, IV=key) + base64url
	 // jar(cryptoSM)의 AES_BASE64 와 검증된 동일 로직. jar 불필요.
 // mSABER 전용: 패딩 유지 base64url (cryptoSM.jar 와 100% 동일)
    public static String encryptForMsaber(String plaintext) {
        try {
            byte[] keyData = ConstantSecureKeys.passphrase.getBytes(CharEncoding.UTF_8);
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE,
                    new SecretKeySpec(keyData, "AES"),
                    new IvParameterSpec(keyData));   // IV = key (jar 와 동일)
            byte[] encrypted = cipher.doFinal(plaintext.getBytes(CharEncoding.UTF_8));
            // 패딩 유지(withoutPadding 안 씀) → == 가 살아있음
            return Base64.getUrlEncoder().withoutPadding().encodeToString(encrypted);
        } catch (Exception e) {
            return null;
        }
    }

    public static String decryptForMsaber(String encryptedText) {
        try {
            byte[] keyData = ConstantSecureKeys.passphrase.getBytes(CharEncoding.UTF_8);
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE,
                    new SecretKeySpec(keyData, "AES"),
                    new IvParameterSpec(keyData));
            byte[] decoded = Base64.getUrlDecoder().decode(encryptedText);
            return new String(cipher.doFinal(decoded), CharEncoding.UTF_8);
        } catch (Exception e) {
            return null;
        }
    }
}