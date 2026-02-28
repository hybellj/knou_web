package knou.lms.seminar.vo;

import knou.lms.common.vo.DefaultVO;

public class SeminarTokenVO extends DefaultVO {

    private static final long serialVersionUID = -1699838556600334847L;
    /** tb_lms_seminar_token */
    private String  tokenId;            // 인증 토큰 고유 ID
    private String  tcEmail;            // 참가 이메일
    private String  accesToken;         // 액세스 토큰
    private String  expireIn;           // 토큰 만료일
    private String  refreshToken;       // 갱신 토큰
    private String  refreshExpireIn;    // 갱신 토큰 만료일
    private Integer expireMin;          // 토큰 만료 시간
    private Integer reExpireMin;        // 갱신 토큰 만료 시간
    
    public String getTokenId() {
        return tokenId;
    }
    public void setTokenId(String tokenId) {
        this.tokenId = tokenId;
    }
    public String getTcEmail() {
        return tcEmail;
    }
    public void setTcEmail(String tcEmail) {
        this.tcEmail = tcEmail;
    }
    public String getAccesToken() {
        return accesToken;
    }
    public void setAccesToken(String accesToken) {
        this.accesToken = accesToken;
    }
    public String getExpireIn() {
        return expireIn;
    }
    public void setExpireIn(String expireIn) {
        this.expireIn = expireIn;
    }
    public String getRefreshToken() {
        return refreshToken;
    }
    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }
    public String getRefreshExpireIn() {
        return refreshExpireIn;
    }
    public void setRefreshExpireIn(String refreshExpireIn) {
        this.refreshExpireIn = refreshExpireIn;
    }
    public Integer getExpireMin() {
        return expireMin;
    }
    public void setExpireMin(Integer expireMin) {
        this.expireMin = expireMin;
    }
    public Integer getReExpireMin() {
        return reExpireMin;
    }
    public void setReExpireMin(Integer reExpireMin) {
        this.reExpireMin = reExpireMin;
    }

}
