package knou.framework.util;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.GeneralSecurityException;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.util.Base64;
import java.util.Random;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import knou.framework.common.CommConst;
//import sun.misc.BASE64Decoder;


@SuppressWarnings("restriction")
public class CryptoUtil {

    public final static String _ERROR = "_ERROR";

    private final static String CHARSET_DEFAULT = "8859_1";
    private final static String CHARSET_SERVER = "utf-8";
    private final static String DELIMETER_NORMAL = "!#!";
    // private final static String  DELIMETER_DATA = "!@!";

    /**
     * 2중 암호화된 파라매터 문자열을 복호화 해서 String[]로 반환한다.
     */
    private static byte[] decode(String encodeString) {
        //BASE64Decoder B64Decoder = new BASE64Decoder();
        byte[] bytDecodedData;

        try {
            //bytDecodedData = B64Decoder.decodeBuffer(encodeString);
        	bytDecodedData = Base64.getDecoder().decode(encodeString);
        	
            return bytDecodedData;
        } catch(Exception ex) {
            return null;
        }
    }

    // Triple-DES Decryption Method
    private static String triDES_DecryptString(byte[] key, byte[] encMessage) {
        byte[] bytDecryptedData;
        SecretKey sKey;
        Cipher DecryptCipher;

        try {
            // 키를 설정한다.
            sKey = new SecretKeySpec(key, "DESede");

            // Cipher를 생성하고 초기화 한다.
            DecryptCipher = Cipher.getInstance("DESede/CBC/NoPadding");
            DecryptCipher.init(Cipher.DECRYPT_MODE, sKey, new IvParameterSpec(key, 0, 8));

            bytDecryptedData = DecryptCipher.doFinal(encMessage);
            return new String(bytDecryptedData, CHARSET_SERVER);
        } catch(Exception ex) {
            return "";
        }
    }

    /**
     * 클라이언트 정보를 복호화해서 배열로 반환.
     * @param str
     * @return
     */
    public static String[] descrypt(String str) {
        String strDescInfo = "";
        String[] aryValues = null;
        String ckData = "";

        try {
            if(StringUtil.isNull(str)) return aryValues;    //

            strDescInfo = new String(decode(str), CHARSET_DEFAULT);
            aryValues = strDescInfo.split(DELIMETER_NORMAL);

            ckData = aryValues[0]; // 복호화 키.
            strDescInfo = aryValues[1]; // 복호화 대상.

            if(aryValues.length < 2) {
                aryValues = new String[]{ _ERROR, "복호화키, 값 분리에 실패했습니다."};
                return aryValues;
            }

            strDescInfo = triDES_DecryptString(ckData.getBytes(CHARSET_DEFAULT), strDescInfo.getBytes(CHARSET_DEFAULT));
            aryValues = strDescInfo.split(DELIMETER_NORMAL);

            for(int cnt=0; cnt < aryValues.length; cnt++) {
                aryValues[cnt] = URLDecoder.decode(aryValues[cnt].trim(), CHARSET_SERVER);
            }

            return aryValues;

        } catch(Exception ex) {
            aryValues = new String[] { _ERROR, "파라매터 복호화 과정에서 오류가 발생하였습니다." + ex.getMessage()};
            return aryValues;
        }
    }

    /**
     * 랜덤 문자열을 생성해서 반환한다. 0~9, A~Z 범위내에서 length만큼 생성한다.
     * @param length
     * @return
     */
    static public String makeRandomString(int length) {
        StringBuffer buffer = new StringBuffer();
        Random random = new Random();

        String chars[] = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9".split(",");

        for(int i=0; i<length; i++) {
            buffer.append(chars[random.nextInt(chars.length)]);
        }
        return buffer.toString();
    }

    /**
     * SHA256 Hashing
     * @param str
     * @return
     */
    public static String SHA256Encode(String str) {
        MessageDigest md;
        StringBuffer sb = new StringBuffer();

        try {
            md = MessageDigest.getInstance("SHA-256");
            md.update(str.getBytes());
            byte byteData[] = md.digest();
            for(int i=0; i<byteData.length; i++) {
                sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            }
        } catch(NoSuchAlgorithmException e) {
            // e.printStackTrace();
            sb.append("Error");
        }
        return sb.toString();
    }

    /**
     * 복호화
     * 
     * @param privateKey
     * @param securedValue
     * @return
     * @throws Exception
     */
    public static String decryptRsa(PrivateKey privateKey, String securedValue) throws Exception {

        Cipher cipher = Cipher.getInstance(CommConst.RSA_INSTANCE);
        byte[] encryptedBytes = hexToByteArray(securedValue);
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] decryptedBytes = cipher.doFinal(encryptedBytes);

        // 문자 인코딩 주의.
        String decryptedValue = new String(decryptedBytes, "utf-8");

        return decryptedValue;
    }

    /**
     * 16진 문자열을 byte 배열로 변환한다.
     * 
     * @param hex
     * @return
     */
    public static byte[] hexToByteArray(String hex) {
        if(hex == null || hex.length() % 2 != 0) { return new byte[] {}; }

        byte[] bytes = new byte[hex.length() / 2];
        for(int i=0; i<hex.length(); i += 2) {
            byte value = (byte) Integer.parseInt(hex.substring(i, i + 2), 16);
            bytes[(int) Math.floor(i / 2)] = value;
        }
        return bytes;
    }

    /**
     * rsa 공개키, 개인키 생성
     * 
     * @param request
     * @return 
     */
    public static void initRsa(HttpServletRequest request) {
        HttpSession session = request.getSession();

        KeyPairGenerator generator;
        try {
            generator = KeyPairGenerator.getInstance(CommConst.RSA_INSTANCE);
            generator.initialize(1024);

            KeyPair keyPair = generator.genKeyPair();
            KeyFactory keyFactory = KeyFactory.getInstance(CommConst.RSA_INSTANCE);
            PublicKey publicKey = keyPair.getPublic();
            PrivateKey privateKey = keyPair.getPrivate();

            session.setAttribute(CommConst.RSA_WEB_KEY, privateKey); // session에 RSA 개인키를 세션에 저장

            RSAPublicKeySpec publicSpec = (RSAPublicKeySpec) keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);
            String publicKeyModulus = publicSpec.getModulus().toString(16);
            String publicKeyExponent = publicSpec.getPublicExponent().toString(16);

            request.setAttribute("RSAModulus", publicKeyModulus); // rsa modulus 를 request 에 추가
            request.setAttribute("RSAExponent", publicKeyExponent); // rsa exponent 를 request 에 추가
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    public static String encryptAes256(String text, String type) throws NoSuchAlgorithmException, 
        GeneralSecurityException, UnsupportedEncodingException {

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        String AES_KEY = CommConst.AES_ENCRYPTION_KEY;
        if("EXAM".equals(type)) {
            AES_KEY = CommConst.EXAM_AES_ENCRYPTION_KEY;
        }
        
        if(text == null || text.length() == 0) {
            return text; 
        }

        if(AES_KEY.length() != 256 / 8) {
            throw new IllegalArgumentException("'secretKey' must be 256 bit");
        }
        
        String iv = AES_KEY.substring(0, 16); // 16byte
        
        if(iv.length() != 128 / 8) {
            throw new IllegalArgumentException("'iv' must be 128 bit");
        }
        
        SecretKeySpec keySpec = new SecretKeySpec(AES_KEY.getBytes("UTF-8"), "AES");
        IvParameterSpec ivParamSpec = new IvParameterSpec(iv.getBytes("UTF-8"));
        if("EXAM".equals(type)) {
            byte[] ivByte = new byte[16];
            for(byte b : ivByte) {
                b = (byte) 0x80;
            }
            ivParamSpec = new IvParameterSpec(ivByte);
        }
        cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivParamSpec);

        byte[] byteStr = cipher.doFinal(text.getBytes("UTF-8"));
        String encrypted =  Base64.getEncoder().encodeToString(byteStr);

        // Base64로 인코딩된 텍스트 중  url로 전달 시 구분자로 인식되는 문제가 있는 특수문자 변환처리  
        // 변환 처리 ('/' -> '_', '+' -> '-')
        // '*' IIS에서 Filter 처리되어 사용 불가 )
        if("EXAM".equals(type)) {
            encrypted = URLEncoder.encode(encrypted, "UTF-8");
        } else {
            encrypted = StringUtil.ReplaceAll(encrypted, "/" , "_");
            encrypted = StringUtil.ReplaceAll(encrypted, "+" , "-");
        }
        return encrypted;
    }
    
    public static String encryptAes256(String text) throws NoSuchAlgorithmException,
        GeneralSecurityException, UnsupportedEncodingException {

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        String AES_KEY = CommConst.AES_ENCRYPTION_KEY;
    
        if(text == null || text.length() == 0) {
            return text; 
        }

        if(AES_KEY.length() != 256 / 8) {
            throw new IllegalArgumentException("'secretKey' must be 256 bit");
        }
    
        String iv = AES_KEY.substring(0, 16); // 16byte
    
        if(iv.length() != 128 / 8) {
            throw new IllegalArgumentException("'iv' must be 128 bit");
        }
    
        SecretKeySpec keySpec = new SecretKeySpec(AES_KEY.getBytes("UTF-8"), "AES");
        IvParameterSpec ivParamSpec = new IvParameterSpec(iv.getBytes("UTF-8"));
        cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivParamSpec);

        byte[] byteStr = cipher.doFinal(text.getBytes("UTF-8"));
        String encrypted =  Base64.getEncoder().encodeToString(byteStr);
    
        // Base64로 인코딩된 텍스트 중  url로 전달 시 구분자로 인식되는 문제가 있는 특수문자 변환처리  
        // 변환 처리 ('/' -> '_', '+' -> '-')
        // '*' IIS에서 Filter 처리되어 사용 불가 )
        encrypted = StringUtil.ReplaceAll(encrypted, "/" , "_");
        encrypted = StringUtil.ReplaceAll(encrypted, "+" , "-");

        return encrypted;
    }

    public static String decryptAes256(String encFileSn)  throws NoSuchAlgorithmException,
        GeneralSecurityException, UnsupportedEncodingException {

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        String AES_KEY = CommConst.AES_ENCRYPTION_KEY;

        if(encFileSn == null || encFileSn.length() == 0) {
            return encFileSn; 
        }

        if(AES_KEY.length() != 256 / 8) {
            throw new IllegalArgumentException("'secretKey' must be 256 bit");
        }

        String iv = AES_KEY.substring(0, 16); // 16byte
        
        if(iv.length() != 128 / 8) {
            throw new IllegalArgumentException("'iv' must be 128 bit");
        }

        SecretKeySpec keySpec = new SecretKeySpec(AES_KEY.getBytes("UTF-8"), "AES");
        IvParameterSpec ivParamSpec = new IvParameterSpec(iv.getBytes("UTF-8"));
        cipher.init(Cipher.DECRYPT_MODE, keySpec, ivParamSpec);

        // Base64로 인코딩된 텍스트 중  url로 전달 시 구분자로 인식되는 문제가 있는 특수문자 변환처리  
        // 변환 처리 ('_' -> '/', '-' -> '+')
        // '*' IIS에서 Filter 처리되어 사용 불가 )     
        encFileSn = StringUtil.ReplaceAll(encFileSn, "_" , "/");
        encFileSn = StringUtil.ReplaceAll(encFileSn, "-" , "+");

        byte[] decodedBytes = Base64.getDecoder().decode(encFileSn);
        byte[] decrypted = cipher.doFinal(decodedBytes);
        return new String(decrypted, "UTF-8");
    }

    public static String encryptSha(String str) {
        return SHA256Encode(str);
    }
}
