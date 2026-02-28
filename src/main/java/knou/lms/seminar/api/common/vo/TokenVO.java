package knou.lms.seminar.api.common.vo;

import org.apache.ibatis.type.Alias;

import com.fasterxml.jackson.annotation.JsonProperty;

import knou.lms.common.vo.DefaultVO;

@Alias("tokenVO")
public class TokenVO extends DefaultVO {

    private static final long serialVersionUID = 1L;
    
    @JsonProperty("access_token")
    private String accessToken;

    @JsonProperty("expires_in")
    private String expiresIn;

    @JsonProperty("refresh_token")
    private String refreshToken;

    @JsonProperty("refresh_token_expires_in")
    private String refreshTokenExpiresIn;
    
    private String tcEmail;
    private int expiresMin;
    private int reExpiresMin;

    public String getAccessToken() {
        return accessToken;
    }
    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getExpiresIn() {
        return expiresIn;
    }

    public void setExpiresIn(String expiresIn) {
        this.expiresIn = expiresIn;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public String getRefreshTokenExpiresIn() {
        return refreshTokenExpiresIn;
    }

    public void setRefreshTokenExpiresIn(String refreshTokenExpiresIn) {
        this.refreshTokenExpiresIn = refreshTokenExpiresIn;
    }   
    
    public String getTcEmail() {
        return tcEmail;
    }
    public void setTcEmail(String tcEmail) {
        this.tcEmail = tcEmail;
    }

    public int getExpiresMin() {
        return expiresMin;
    }

    public void setExpiresMin(int expiresMin) {
        this.expiresMin = expiresMin;
    }

    public int getReExpiresMin() {
        return reExpiresMin;
    }

    public void setReExpiresMin(int reExpiresMin) {
        this.reExpiresMin = reExpiresMin;
    }
    
    @Override
    public String toString() {
        return "TokenVO [accessToken=" + accessToken + ", expiresIn=" + expiresIn + ", refreshToken=" + refreshToken
                + ", refreshTokenExpiresIn=" + refreshTokenExpiresIn + ", tcEmail=" + tcEmail + ", expiresMin="
                + expiresMin + ", reExpiresMin=" + reExpiresMin + "]";
    }

}
