package knou.lms.seminar.api.common.oauth;

import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Objects;

import javax.crypto.KeyGenerator;
import javax.crypto.spec.SecretKeySpec;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.impl.Base64Codec;
import io.jsonwebtoken.impl.crypto.DefaultJwtSignatureValidator;

@Component
public class JwtServerManager {
    
    private static final Logger LOGGER = LoggerFactory.getLogger("api");

    private static final SignatureAlgorithm ALGORITHM = SignatureAlgorithm.HS256;

    public boolean isValidToken(String token, String secret, String apiKey) throws ExpiredJwtException {
        final String tokenWithoutBearer;
        if (token != null && token.startsWith("Bearer ")) {
            // Bearer 제거
            tokenWithoutBearer = token.substring(7);
        } else {
            return false;
        }

        if (!isValidSignature(tokenWithoutBearer, secret)) {
            return false;
        }

        try {
            Jws<Claims> claims = Jwts.parser()
                    .setSigningKey(new SecretKeySpec(secret.getBytes(), ALGORITHM.getJcaName()))
                    .parseClaimsJws(tokenWithoutBearer);

            printLog(claims, apiKey);

            if (!Objects.equals(apiKey, claims.getBody().getIssuer())) {
                return false;
            }
        } catch (ExpiredJwtException e) {
            LOGGER.error(e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
            return false;
        }

        return true;
    }

    private void printLog(Jws<Claims> claims, String apiKey) {
        if (LOGGER.isDebugEnabled()) {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String algorithm = claims.getHeader().getAlgorithm();
            String issuer = claims.getBody().getIssuer();
            String expiration = format.format(claims.getBody().getExpiration());
            LOGGER.debug("API Key is {}. Token parse. algorithm={}, issuer={}, expiration={}.", apiKey, algorithm, issuer,
                    expiration);
        }
    }

    private boolean isValidSignature(String token, String secret) {
        String[] chunks = token.split("\\.");
        String tokenWithoutSignature = chunks[0] + "." + chunks[1];
        String signature = chunks[2];
        SecretKeySpec secretKeySpec = new SecretKeySpec(secret.getBytes(), ALGORITHM.getJcaName());
        DefaultJwtSignatureValidator validator = new DefaultJwtSignatureValidator(ALGORITHM, secretKeySpec);
        return validator.isValid(tokenWithoutSignature, signature);
    }

    public static String generatorApiKey() throws NoSuchAlgorithmException {
        return Base64Codec.BASE64.encode(generatorKey(128));
    }

    public static String generatorApiSecret() throws NoSuchAlgorithmException {
        return Base64Codec.BASE64.encode(generatorKey(192));
    }

    private static byte[] generatorKey(int i) throws NoSuchAlgorithmException {
        KeyGenerator keyGenerator = KeyGenerator.getInstance(ALGORITHM.getJcaName());
        keyGenerator.init(i);
        return keyGenerator.generateKey().getEncoded();
    }
    
    /**
     * 운영중 유지보수의 편의성을 위한 LMS Client에 제공할 키 생성 메소드
     */
    public static void main(String[] args) throws Exception {
        String apiKey = JwtServerManager.generatorApiKey();
        System.out.println("ApiKey:");
        System.out.println(apiKey);
        String apiSecret = JwtServerManager.generatorApiSecret();
        System.out.println("ApiSecret:");
        System.out.println(apiSecret);
    }

}
