package knou.lms.user.param;

import java.io.Serializable;

/**
 * 접속자 메타 정보 파라미터 객체
 */
public class UserMetaParam implements Serializable {

    private static final long serialVersionUID = 1L;

    private String ip;           // 접속 IP
    private String userAgent;    // 브라우저 헤더 정보
    private String sessionId;    // 세션 ID
    private String browser;      // 브라우저 종류 (Chrome, Edge 등)
    private String os;           // 운영체제 (Windows10, Android 등)
    private String deviceType;   // 기기 구분 (PC, mobile)

    // 기본 생성자
    public UserMetaParam() {}

    // Getter & Setter
    public String getIp() { return ip; }
    public void setIp(String ip) { this.ip = ip; }

    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public String getBrowser() { return browser; }
    public void setBrowser(String browser) { this.browser = browser; }

    public String getOs() { return os; }
    public void setOs(String os) { this.os = os; }

    public String getDeviceType() { return deviceType; }
    public void setDeviceType(String deviceType) { this.deviceType = deviceType; }

    // 디버깅을 위한 toString 오버라이드
    @Override
    public String toString() {
        return "UserMetaParam [ip=" + ip + ", browser=" + browser + ", os=" + os + 
               ", deviceType=" + deviceType + ", sessionId=" + sessionId + "]";
    }
}