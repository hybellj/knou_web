package knou.lms.seminar.api.common.oauth;

/**
 * 아래와 같은 작업을 할때 JWT를 사용한다.</br>
 * 
 * <ul>
 * <li>OAuth 토큰을 발급 받기전에 API를 호출할 때</li>
 * <li>배치작업에서 사용자를 모른 상태로 API를 호출할 때</li>
 * <li>Member 계정으로 Account-level의 API를 호출할 때</li>
 * <li>Webhook으로 요청을 받은후 API를 호출할 때</li>
 * <li>시스템에서 OAuth 인증을 사용하지 않을 때 API를 호출할 때</li>
 * </ul>
 * 
 * 기본 토큰 만료시간은 60초이다. 만료시간이 짧은 경우에는 설정후에 토큰을 생성한다.</br>
 */
public interface JwtClientManager {

    public String getAccessToken(String orgId) throws Exception;
    
    public String getAccessToken(String orgId, String tcEmail) throws Exception;
    
    /**
     * 토큰 만료 시간을 설정한다.</br>
     * 많은 데이터를 연계할 때는 소요되는 시간만큼 만료 시간을 설정한다.
     * 
     * @param expirationTime 초단위
     */
    public void setExpirationTime(int expirationTime);
    
}
