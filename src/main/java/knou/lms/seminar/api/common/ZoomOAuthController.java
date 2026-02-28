package knou.lms.seminar.api.common;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.dao.CrecrsDAO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.seminar.api.common.vo.TokenVO;
import knou.lms.seminar.api.users.service.UsersService;
import knou.lms.seminar.api.users.vo.UsersInfoVO;
import knou.lms.seminar.dao.SeminarTokenDAO;
import knou.lms.seminar.service.ZoomApiService;
import knou.lms.seminar.vo.SeminarTokenVO;
import knou.lms.user.dao.UsrUserInfoDAO;
import knou.lms.user.vo.UsrUserInfoVO;

@Controller
@RequestMapping(value = "/zoom/v2")
public class ZoomOAuthController extends ControllerBase {
    
    private static final Logger LOGGER = LoggerFactory.getLogger("tc");
    
    @Resource(name="seminarTokenDAO")
    private SeminarTokenDAO seminarTokenDAO;
    
    @Resource(name="usrUserInfoDAO")
    private UsrUserInfoDAO usrUserInfoDAO;
    
    @Resource(name="crecrsDAO")
    private CrecrsDAO crecrsDAO;
    
    /** 메시지 처리 */
    @Resource(name = "messageSource")
    private MessageSource messageSource;

    @Autowired
    private ZoomOAuthAppType oAuthAppType;
    
    @Autowired
    private UsersService usersService;
    
    @Autowired
    private ZoomApiService zoomApiService;
    
    /***************************************************** 
     * TODO ZOOM 사용자 역할(소유자, 관리자) 인증 후 호출 값
     * @param code, request 
     * @return authorize
     * @throws Exception
     ******************************************************/
    @GetMapping(value = "/authorize/admin.do")
    public String authorizeAdmin(@RequestParam("code") String code, HttpServletRequest request) throws Exception {
        printLog(request);
        return authorize(code, request, ZoomOAuthAppType.ACCOUNT_LEVEL_APP);
    }

    /***************************************************** 
     * TODO ZOOM 사용자 역할(사용자) 인증 후 호출 값
     * @param code, request 
     * @return authorize
     * @throws Exception
     ******************************************************/
    @GetMapping(value = "/authorize/member.do")
    public String authorizeMemember(@RequestParam("code") String code, HttpServletRequest request) throws Exception {
        printLog(request);
        return authorize(code, request, ZoomOAuthAppType.USER_MANAGED_APP);
    }

    /***************************************************** 
     * TODO ZOOM 사용자 AccessToken 값 DB 저장
     * @param code, request, appType
     * @return "seminar/popup/zoom_authorize_pop"
     * @throws Exception
     ******************************************************/
    private String authorize(String code, HttpServletRequest request, int appType) throws Exception {
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String crsCreCd = StringUtil.nvl(request.getParameter("crsCreCd"), SessionInfo.getCurCrsCreCd(request));
        try {
            // OAuth App 설정
            ZoomOAuthManager oAuthManager = oAuthAppType.getOAuthManager(appType);
            // redirectUrl 파라미터 조회
            String redirectUri = oAuthManager.getRedirectUri(appType, request);
            // 인증한 사용자 OAuth 토큰 값 조회
            TokenVO tokenVO = oAuthManager.getAccessToken(code, redirectUri);
            
            // ZOOM 사용자 정보 조회
            UsersInfoVO uuivo = usersService.getAUser(tokenVO.getAccessToken(), "me");
            
            // 대표교수 정보 조회
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(crsCreCd);
            creCrsVO = crecrsDAO.selectTchCreCrs(creCrsVO);
            
            SeminarTokenVO seminarTokenVO = new SeminarTokenVO();
            seminarTokenVO.setTcEmail(uuivo.getEmail());
            // 인증한 사용자가 소유자 이면서 ACCOUNT LEVEL APP 호출 시 DB에 저장되는 email 값 변경
            if("Owner".equals(uuivo.getRoleName()) && appType == 0) {
                seminarTokenVO.setTcEmail("ADM");
            }
            if((creCrsVO != null && (creCrsVO.getUserId()+"@hycu.ac.kr").equalsIgnoreCase(uuivo.getEmail())) || ("Owner".equals(uuivo.getRoleName()) && appType == 0) || "cyber@hycu.ac.kr".equals(uuivo.getEmail()) || "hycuzoom@hycu.ac.kr".equals(uuivo.getEmail())) {
                // DB에 저장되있는 OAuth 토큰 정보 조회
                seminarTokenVO = seminarTokenDAO.selectAccessToken(seminarTokenVO);
                // 정보 없으면 토큰 정보 저장
                if(seminarTokenVO == null) {
                    SeminarTokenVO stVO = new SeminarTokenVO();
                    String tokenId = IdGenerator.getNewId("TOKEN");
                    stVO.setTcEmail(uuivo.getEmail());                              // ZOOM 메일
                    stVO.setTokenId(tokenId);                                       // DB 저장용 랜덤 고유번호
                    stVO.setAccesToken(tokenVO.getAccessToken());                   // OAuth AccessToken 값
                    stVO.setExpireIn(tokenVO.getExpiresIn());                       // AccessToken 유효기간
                    stVO.setRefreshToken(tokenVO.getRefreshToken());                // OAuth 새로고침용 토큰 값
                    stVO.setRefreshExpireIn(tokenVO.getRefreshTokenExpiresIn());    // 새로고침용 토큰 유효기간
                    stVO.setRgtrId(userId);
                    seminarTokenDAO.insertAccessToken(stVO);
                // 정보 있으면 토큰 정보 수정
                } else {
                    seminarTokenVO.setAccesToken(tokenVO.getAccessToken());                 // OAuth AccessToken 값
                    seminarTokenVO.setExpireIn(tokenVO.getExpiresIn());                     // AccessToekn 유효기간
                    seminarTokenVO.setRefreshToken(tokenVO.getRefreshToken());              // OAuth 새로고침용 토큰 값
                    seminarTokenVO.setRefreshExpireIn(tokenVO.getRefreshTokenExpiresIn());  // 새로고침용 토큰 유효기간
                    seminarTokenDAO.updateAccessToken(seminarTokenVO);
                }
                
                if(creCrsVO != null && (creCrsVO.getUserId()+"@hycu.ac.kr").equalsIgnoreCase(uuivo.getEmail())) {
                    // 사용자 정보 수정
                    UsrUserInfoVO uvo = new UsrUserInfoVO();
                    uvo.setUserId(creCrsVO.getUserId());
                    zoomApiService.updateUserTcInfo(uvo);
                }
                
                request.setAttribute("message", "인증되었습니다.");
                request.setAttribute("tokenChk", "Y");
            } else {
                request.setAttribute("message", "대표교수의 ZOOM 계정이 일치하지 않습니다.");
                request.setAttribute("tokenChk", "N");
            }
        } catch(Exception e) {
            request.setAttribute("message", "인증에 실패하였습니다.");
            request.setAttribute("tokenChk", "N");
        }
        
        return "seminar/popup/zoom_authorize_pop";
    }

    private void printLog(HttpServletRequest request) throws Exception {
        if (LOGGER.isDebugEnabled()) {
            String userId = StringUtil.nvl(SessionInfo.getUserId(request));
            UsrUserInfoVO uuivo = new UsrUserInfoVO();
            uuivo.setUserId(userId);
            uuivo = usrUserInfoDAO.selectForCompare(uuivo);
            LOGGER.debug("ZOOM Authorized for LMS. redirect_uri={}, userId={}", request.getRequestURI(), uuivo.getUserId());
        }
    }
    
    /***************************************************** 
     * TODO ZOOM 사용자 인증용 URL 조회
     * @param UsrUserInfoVO 
     * @return ProcessResultVO<String>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/authorize/getUrl.do")
    @ResponseBody
    public ProcessResultVO<String> getAuthorizeUrl(UsrUserInfoVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<String> resultVO = new ProcessResultVO<String>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            // DB 사용자 정보 조회
            UsrUserInfoVO uuivo = new UsrUserInfoVO();
            uuivo.setUserId(userId);
            uuivo = usrUserInfoDAO.selectForCompare(uuivo);
            // ZOOM에 등록된 사용자 역할로 호출할 OAuth 설정
            // DB에 등록된 TC_ROLE => 소유자(Owner), 관리자(Admin), 사용자(Member)
            String tcRole = uuivo.getTcRole();
            ZoomOAuthManager oAuthManager = oAuthAppType.getOAuthManager(oAuthAppType.getAppType(tcRole));
            // ZOOM 사용자 인증용 URL 조회
            String redirectUri = oAuthManager.getAuthorizeUrl(oAuthAppType.getAppType(tcRole), request);
            resultVO.setReturnVO(redirectUri);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생했습니다!");
        }
        
        return resultVO;
    }

}
