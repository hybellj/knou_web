package knou.lms.login.config;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/*import com.bandisnc.sso.client.SsoClientApiManager;
import com.bandisnc.sso.constant.SsoPropConsts;*/

/**
 * BANDI SSO 클라이언트(SsoClientApiManager) 초기화.
 *
 * 서버 기동 시 1회 init() 하면, 이후 어디서든
 * SsoClientApiManager.getInstance() 로 동일 인스턴스를 사용할 수 있다.
 *
 * 연동정보 출처: _반디에스앤씨__한국방송통신대학교_연동시스템정보_newlms.xlsx
 *               (연동시스템명 = newlms)
 *
 * ⚠ 운영 배포 전 확인할 것:
 *   - SERVER_URL 을 운영(PROD) 도메인으로 전환
 *   - client_id/secret 류는 가능하면 application.properties / 환경변수로 분리
 */
@Component
public class SsoClientConfig {

    private static final Logger log = LoggerFactory.getLogger(SsoClientConfig.class);

    // 개발(DEV): http://auth.knou.ac.kr:8081
    // 운영(PROD): https://auth.knou.ac.kr   ← 운영 전환 시 교체
    private static final String SSO_SERVER_URL = "https://auth.knou.ac.kr";

    // [필수] 반디에스앤씨 제공 newlms 클라이언트 정보
    private static final String CLIENT_ID         = "0oWLGbgmcD6lG7HmyJrW9m6g3eWMJCnljpt1ga5ZJXGVhxv7pnjIvalX4H6-XR3IU-HoaIgrGfq1h0QjnIUR5Q";
    private static final String CLIENT_SECRET     = "644751cdb1470aa5186d23a3e23a3b077adf9dfccfa91fdee64c9ce233482ee2f639";
    private static final String CLIENT_ENC_SECRET = "a896f6d6ef4097d6acc00398ef0ad0e10fa2eb718397dc98b15603312bcdc6bd1618bc1fca33596cdbf0e9543fd7fb87f010229be81add9cd674e796586f160054fdd8b5431fc90a8c75cb3e53481677d843d6457afe2146e432d7c2acf2";
    private static final String CLIENT_SN_BDSKISV = "c0e0b6c61c8e3d84571549e8e56b8182";

    @PostConstruct
    public void init() {
        /*SsoClientApiManager clientApiManager = SsoClientApiManager.getInstance();

        if (!clientApiManager.isInit()) {
            Map<String, String> propMap = new HashMap<>();
            propMap.put(SsoPropConsts.SERVER_URL, SSO_SERVER_URL);
            propMap.put(SsoPropConsts.CLIENT_ID, CLIENT_ID);
            propMap.put(SsoPropConsts.CLIENT_SECRET, CLIENT_SECRET);
            propMap.put(SsoPropConsts.CLIENT_ENC_SECRET, CLIENT_ENC_SECRET);
            propMap.put(SsoPropConsts.CLIENT_SN_BDSKISV, CLIENT_SN_BDSKISV);
            propMap.put(SsoPropConsts.CONN_TIME_OUT, "15");

            // ⚠ MagicJCrypto 가 JDK 9+ 모듈 시스템에서 sun.security.util 접근 불가로 막힘
            //   (java.lang.IllegalAccessError: MJCSecureRandom ... sun.security.util.Debug)
            //   → BOUNCY_CASTLE 암호화 모듈로 전환 (bcprov-jdk15on-1.69.jar 필요, 이미 적용됨)
            propMap.put(SsoPropConsts.CRYPTO_SERVICE, "BOUNCY_CASTLE");

            // 운영 환경에서 SSL 인증서 이슈가 있을 경우 주석 해제
            // propMap.put(SsoPropConsts.IS_DISABLE_SSL_VERIFICATION, "true");

            clientApiManager.init(propMap);
            log.info("[SSO] SsoClientApiManager 초기화 완료 - serverUrl={}", SSO_SERVER_URL);
        }*/
    }
}
