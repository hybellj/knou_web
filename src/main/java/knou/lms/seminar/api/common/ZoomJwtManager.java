package knou.lms.seminar.api.common;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import knou.framework.common.CommConst;
import knou.lms.seminar.api.common.oauth.JwtClientManager;
import io.jsonwebtoken.Header;
import io.jsonwebtoken.JwsHeader;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@Component
public class ZoomJwtManager implements JwtClientManager {

    private static final Logger LOGGER = LoggerFactory.getLogger("tc");

    /** 토큰 만료 시간 : 토큰 생성 후 60초 */
    private int expirationTime = 1 * 60;

    private final SignatureAlgorithm ALGORITHM = SignatureAlgorithm.HS256;

    @Override
    public String getAccessToken(String orgId) throws Exception {
        return generateToken(orgId, null);
    }

    @Override
    public String getAccessToken(String orgId, String tcEmail) throws Exception {
        return generateToken(orgId, tcEmail);
    }

    private String generateToken(String orgId, String tcEmail) throws Exception {

        Date expiration = new Date(System.currentTimeMillis() + (expirationTime * 1000));
        printLog(orgId, tcEmail, expiration);

        String token = Jwts.builder()
                .setHeaderParam(Header.TYPE, Header.JWT_TYPE)
                .setHeaderParam(JwsHeader.ALGORITHM, ALGORITHM.getJcaName())
                .setIssuer(CommConst.ZOOM_JWT_API_KEY)
                .setExpiration(expiration)
                .signWith(ALGORITHM, CommConst.ZOOM_JWT_API_SECRET_KEY.getBytes())
                .compact();

        return token;
    }

    private void printLog(String orgId, String tcEmail, Date expiration) {
        if (LOGGER.isDebugEnabled()) {
            StringBuilder builder = new StringBuilder("ZOOM JWT Access token generate. ");
            builder.append("orgId=");
            builder.append(orgId);
            if (tcEmail != null) {
                builder.append(", tcEmail=");
                builder.append(tcEmail);
            }
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            builder.append(", expiration=");
            builder.append(format.format(expiration));
            LOGGER.debug(builder.toString());
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setExpirationTime(int expirationTime) {
        this.expirationTime = expirationTime;
    }
    
}
