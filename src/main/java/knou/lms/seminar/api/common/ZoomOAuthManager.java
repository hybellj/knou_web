package knou.lms.seminar.api.common;

import java.io.UnsupportedEncodingException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import knou.framework.common.CommConst;
import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.lms.seminar.api.common.oauth.OAuthManager;
import knou.lms.seminar.api.common.vo.TokenVO;
import knou.lms.seminar.dao.SeminarTokenDAO;
import knou.lms.seminar.vo.SeminarTokenVO;
import knou.lms.user.dao.UsrUserInfoDAO;
import knou.lms.user.vo.UsrUserInfoVO;

@Component
public class ZoomOAuthManager extends OAuthManager {
    
    private static final Logger LOGGER = LoggerFactory.getLogger("tc");
    
    @Resource(name="usrUserInfoDAO")
    private UsrUserInfoDAO usrUserInfoDAO;
    
    @Resource(name="seminarTokenDAO")
    private SeminarTokenDAO seminarTokenDAO;

    private String clientId;
    private String clientSecret;
    
    /***************************************************** 
     * TODO ZOOM APP TYPE별 client 설정
     * @param appType
     * @return void
     * @throws Exception
     ******************************************************/
    public void chooseAppType(int appType) {
        if (appType == ZoomOAuthAppType.USER_MANAGED_APP) {
            LOGGER.debug("ZOOM OAuth APP type=User-managed app");
            this.clientId = CommConst.ZOOM_OAUTH_USER_MANAGE_CLIENT_ID;
            this.clientSecret = CommConst.ZOOM_OAUTH_USER_MANAGE_CLIENT_SECRET;
        } else {
            LOGGER.debug("ZOOM OAuth APP type=Account-level app");
            this.clientId = CommConst.ZOOM_OAUTH_ACCOUNT_MANAGE_CLIENT_ID;
            this.clientSecret = CommConst.ZOOM_OAUTH_ACCOUNT_MANAGE_CLIENT_SECRET;
        }
    }

    /***************************************************** 
     * TODO ZOOM redirectUrl 리턴
     * @param appType, request
     * @return redirectUrl
     * @throws Exception
     ******************************************************/
    public String getRedirectUri(int appType, HttpServletRequest request) {
        String result = "";
        String secure = request.isSecure() ? "https://" : "http://";
        result = secure + request.getServerName() + "/zoom/v2/authorize";
        if (appType == ZoomOAuthAppType.USER_MANAGED_APP) {
            result = result + "/member.do";
        } else {
            result = result + "/admin.do";
        }
        return result;
    }
    
    /***************************************************** 
     * TODO ZOOM 사용자 인증용 URL 리턴
     * @param redirectUrl
     * @return url
     * @throws Exception
     ******************************************************/
    public String getAuthorizeUrl(String redirectUri) throws UnsupportedEncodingException {
        // API APP TYPE 체크
        this.checkAppType();
        return super.getAuthorizeUrl(this.clientId, redirectUri);
    }
    
    /***************************************************** 
     * TODO ZOOM 사용자 인증용 URL 리턴
     * @param appType, request
     * @return url
     * @throws Exception
     ******************************************************/
    public String getAuthorizeUrl(int appType, HttpServletRequest request) throws UnsupportedEncodingException {
        // redirectUrl 조회
        String redirectUri = getRedirectUri(appType, request);
        return this.getAuthorizeUrl(redirectUri);
    }

    /***************************************************** 
     * TODO ZOOM 인증된 사용자 토큰 값 조회
     * @param code, redirectUri
     * @return TokenVO
     * @throws Exception
     ******************************************************/
    public TokenVO getAccessToken(String code, String redirectUri) {
        // API APP TYPE 체크
        this.checkAppType();
        return super.getAccessToken(this.clientId, this.clientSecret, code, redirectUri);
    }
    
    /***************************************************** 
     * TODO DB에 저장된 AccessToken 조회
     * @param request
     * @return TokenVO
     * @throws Exception
     ******************************************************/
    public TokenVO getAccessTokenFromVc(HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        UsrUserInfoVO uuivo = new UsrUserInfoVO();
        uuivo.setUserId(userId);
        uuivo = usrUserInfoDAO.selectForCompare(uuivo);
        return this.getAccessTokenFromVc(StringUtil.nvl(uuivo.getTcEmail()));
    }

    /***************************************************** 
     * TODO DB에 저장된 AccessToken 조회
     * @param tcEmail ( ZOOM에 등록된 이메일 )
     * @return TokenVO
     * @throws Exception
     ******************************************************/
    public TokenVO getAccessTokenFromVc(String tcEmail) throws Exception {
        // API APP TYPE 설정여부 체크
        this.checkAppType();
        // DB에 저장된 AccessToken 정보 조회
        SeminarTokenVO seminarTokenVO = new SeminarTokenVO();
        seminarTokenVO.setTcEmail(tcEmail);
        seminarTokenVO = seminarTokenDAO.selectAccessToken(seminarTokenVO);
        TokenVO tokenVO = new TokenVO();
        if (seminarTokenVO != null) {
            // 조회한 토큰 유효기간 체크
            tokenVO.setAccessToken(seminarTokenVO.getAccesToken());
            tokenVO.setExpiresIn(seminarTokenVO.getExpireIn());
            tokenVO.setRefreshToken(seminarTokenVO.getRefreshToken());
            tokenVO.setRefreshTokenExpiresIn(seminarTokenVO.getRefreshExpireIn());
            tokenVO.setTcEmail(seminarTokenVO.getTcEmail());
            tokenVO.setExpiresMin(seminarTokenVO.getExpireMin());
            tokenVO.setReExpiresMin(seminarTokenVO.getReExpireMin());
            tokenVO.setRgtrId(seminarTokenVO.getRgtrId());
            tokenVO = this.genToken(tokenVO);
        } else {
            LOGGER.debug("ZOOM OAuth Access token not found from database. userId={}", tcEmail);
        }
        return tokenVO;
    }

    private void checkAppType() {
        if (this.clientId == null) {
            throw new NullPointerException("ClientId, clientSecret is null. Call methode this class's chooseAppType.");
        }
    }

    /***************************************************** 
     * TODO 토큰 만료시 갱신 후 리턴
     * @param TokenVO
     * @return TokenVO
     * @throws Exception
     ******************************************************/
    private TokenVO genToken(TokenVO tokenVO) throws Exception {
        // 토큰 만료시 새로운 토큰으로 갱신
        if (isExpired(tokenVO)) {
            this.printLog(tokenVO);
            // 토큰 갱신 API 호출
            TokenVO vo = super.refreshAccessToken(this.clientId, this.clientSecret, tokenVO.getRefreshToken());

            vo.setTcEmail(tokenVO.getTcEmail());
            // 토큰 새로고침용 만료기간이 없으면 자체 값 설정
            if (vo.getRefreshTokenExpiresIn() == null) {
                vo.setRefreshTokenExpiresIn(CommConst.ZOOM_OAUTH_REST_REFRESH_TOKEN_EXPIRES_IN);
            }
            // DB에 저장되있는 OAuth 토큰 정보 조회
            SeminarTokenVO seminarTokenVO = new SeminarTokenVO();
            seminarTokenVO.setTcEmail(vo.getTcEmail());
            seminarTokenVO = seminarTokenDAO.selectAccessToken(seminarTokenVO);
            // 정보 없으면 토큰 정보 저장
            if(seminarTokenVO == null) {
                SeminarTokenVO tvo = new SeminarTokenVO();
                tvo.setTcEmail(vo.getTcEmail());
                tvo.setAccesToken(vo.getAccessToken());
                tvo.setExpireIn(vo.getExpiresIn());
                tvo.setRefreshToken(vo.getRefreshToken());
                tvo.setRefreshExpireIn(vo.getRefreshTokenExpiresIn());
                tvo.setRgtrId(tokenVO.getRgtrId());
                seminarTokenDAO.insertAccessToken(tvo);
            // 정보 있으면 토큰 정보 수정
            } else {
                seminarTokenVO.setAccesToken(vo.getAccessToken());
                seminarTokenVO.setExpireIn(vo.getExpiresIn());
                seminarTokenVO.setRefreshToken(vo.getRefreshToken());
                seminarTokenVO.setRefreshExpireIn(vo.getRefreshTokenExpiresIn());
                seminarTokenDAO.updateAccessToken(seminarTokenVO);
            }
            return vo;
        } else {
            LOGGER.debug("ZOOM OAuth Access token from VC database. userId={}", tokenVO.getTcEmail());
            return tokenVO;
        }
    }
    
    /***************************************************** 
     * TODO 토큰 만료기간 체크
     * @param TokenVO
     * @return Boolean
     * @throws Exception
     ******************************************************/
    private boolean isExpired(TokenVO tokenVO) {
        return tokenVO.getExpiresMin() < 0;
    }

    private void printLog(TokenVO tokenVO) {
        if (LOGGER.isDebugEnabled()) {
            StringBuilder logStr = new StringBuilder();
            logStr.append("ZOOM OAuth Refresh access token request info. ");
            logStr.append("tcEmail=" + tokenVO.getTcEmail() + ", ");
            logStr.append("refreshToken=" + tokenVO.getRefreshToken().substring(0, 60) + "...");
            LOGGER.debug(logStr.toString());
        }
    }

}
