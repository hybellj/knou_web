package knou.lms.login.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.databind.JsonNode;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.IdPrefixType;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.AESCryptor;
import knou.framework.util.CommonUtil;
import knou.framework.util.ConstantSecureKeys;
import knou.framework.util.IdGenUtil;
import knou.framework.util.LocaleUtil;
import knou.framework.util.SessionUtil;
import knou.framework.util.URLBuilder;
import knou.lms.log.logintry.vo.LogUserLoginTryLogVO;
import knou.lms.login.param.LoginParam;
import knou.lms.login.service.LoginService;
import knou.lms.login.vo.UserLgnHstryVO;
import knou.lms.org.service.OrgService;
import knou.lms.user.vo.UserVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Controller
public class LoginController extends ControllerBase {
	private static Logger log = Logger.getLogger(LoginController.class);

	@Autowired
	@Qualifier("loginService")
	private LoginService loginService;

	@Autowired
	@Qualifier("orgService")
	private OrgService orgService;

	// mSABER 공통 정보 (문서: siteCode=KNOU, subsystem=2(포털))
    private static final String MSABER_BASE = "https://mauth.knou.ac.kr";
    private static final String SITE_CODE   = "KNOU";
    private static final String SUBSYSTEM   = "2";
    private static final String MSABER_KEY = ConstantSecureKeys.passphrase; // 벤더 제공 운영 키

    private final RestTemplate rest = new RestTemplate();

	@RequestMapping(value = "/logout.do")
	public String logout( ModelMap model, HttpServletRequest request) throws Exception {
		SessionUtil.removeAll(request);
		return "redirect:" + new URLBuilder("", "login.do", request).toString();
	}

	@RequestMapping(value = "/login.do")
	public String login(ModelMap model, HttpServletRequest request) {
		log.info("LoginController > login.do - 시작");
		UserContext userCtx = (UserContext) request.getSession().getAttribute("USER_CONTEXT");
		if ( null != userCtx ) {
			if ( userCtx.isAdmin() )
				return "redirect:/dashboard/adminDashboardV2.do?menuId=ADMORG0000001";
			if ( userCtx.isProfessor() )
				return "redirect:/dashboard/profDashboard.do";
			if ( userCtx.isStudent() )
				return "redirect:/dashboard/stuDashboard.do";
		}
		return "index";
	}

	@RequestMapping(value="/loginProc.do")
    public String loginProc(LoginParam param, HttpServletRequest request, HttpServletResponse response) throws Exception {

		log.info("LoginController > loginProc.do 시작");

		UserLgnHstryVO  userLgnHstryVO = new UserLgnHstryVO();

	    try {
	    	EgovMap lastLoginMap = loginService.userLatestLoginHstrySelect(param.getUserId());

	    	userLgnHstryVO = UserLgnHstryVO.create(IdGenUtil.genNewId(IdPrefixType.LOHST), param, request);
	    	userLgnHstryVO.setTraceId((String) request.getAttribute("TRACE_ID"));

	        UserContext userCtx = loginService.processLogin(param, userLgnHstryVO);
	        LocaleUtil.setLocale(request, userCtx);

	        UserVO selectedUser = userCtx.getLoginUser();

	        SessionInfo.setOrgId(request,       selectedUser.getOrgId());
	        SessionInfo.setUserId(request,      selectedUser.getUserId());
	        SessionInfo.setUserRprsId(request,  selectedUser.getUserRprsId());
	        SessionInfo.setAuthrtCd(request,    selectedUser.getAuthrtCd());
	        SessionInfo.setAuthrtGrpcd(request, selectedUser.getAuthrtGrpcd());

	        log.info(selectedUser.toString());

        	if (lastLoginMap != null) {
        		userCtx.setLastLoginIp((String)lastLoginMap.get("lgnIp"));
        		userCtx.setLastLoginDttm((String)lastLoginMap.get("lgnDttm"));
        	}

	        SessionInfo.setUserContext(request, userCtx);

	        String initUrl = resolveDashboard(selectedUser.getUserTycd());

	        HttpSession session = request.getSession();
	        String previousPage = (String) session.getAttribute("previousPage");

	        if ( null != previousPage && ! previousPage.isEmpty() ) {
	            session.removeAttribute("previousPage");
	            log.info("goto previous Page=" + previousPage);
	            return "redirect:" + previousPage;
	        } else {
	        	log.info("initUrl=" + initUrl);
	        	return "redirect:/dashboard" + initUrl;
	        }

	    } catch (Exception ex) {
	    	ex.printStackTrace();
	    	userLgnHstryVO.setLgnScsyn("N");
    	    userLgnHstryVO.setLgnFailMsg(CommonUtil.getRootMessage(ex));
    	    loginService.userLatestLoginHstryInsert(userLgnHstryVO);
    	    handleLoginFail(param.getUserId());
    	    return "index";
	    }
    }

	private boolean isHackInput(String uri) {
        if (uri == null) return false;
        return uri.toUpperCase().contains(" OR ") || uri.toUpperCase().contains(" AND ")
        		|| uri.contains("'") || uri.contains("\"");
    }

    private boolean isValidUser(UserVO user) {
    	return true;
    }

    private void handleLoginFail(String userId) {
        System.out.println("LOGIN FAIL : " + userId);
    }

    private LogUserLoginTryLogVO createLoginLog(HttpServletRequest request, UsrUserInfoVO user) {
        LogUserLoginTryLogVO log = new LogUserLoginTryLogVO();
        log.setUserRprsId(user.getUserRprsId());
        log.setBrowserInfo(request.getHeader("User-Agent"));
        log.setConnIp(CommonUtil.getIpAddress(request));
        return log;
    }

    private void setSession(HttpServletRequest request, UserVO user) throws Exception {
        SessionInfo.setUserId(request, user.getUserId());
        SessionInfo.setUserNm(request, user.getUsernm());
        SessionInfo.setOrgId(request, user.getOrgId());
    }

    private String normalizeRole(String role) {
        if (role == null) return CommConst.AUTHRT_GRPCD_STDNT;
        if (role.contains(CommConst.AUTHRT_GRPCD_ADM)) return CommConst.AUTHRT_GRPCD_ADM;
        if (role.contains(CommConst.AUTHRT_GRPCD_PROF)) return CommConst.AUTHRT_GRPCD_PROF;
        return CommConst.AUTHRT_GRPCD_STDNT;
    }

    private String resolveDashboard(String role) {
        switch (role) {
            case CommConst.AUTHRT_GRPCD_ADM:   return "/adminDashboardV2.do";
            case CommConst.AUTHRT_GRPCD_PROF:  return "/profDashboard.do";
            case CommConst.AUTHRT_GRPCD_STDNT: return "/stuDashboard.do";
            default: return "/index";
        }
    }

    /**
     * 세션토큰(challenge) 발급 래퍼
     * 브라우저 → 이 메서드 → mSABER /module/v2/option
     */
    @PostMapping("/api/2fa/option.do")
    public ResponseEntity<?> issueChallenge(@RequestBody OptionRequest req,
            @RequestHeader(value="X-Forwarded-For", required=false) String fwd) {
        try {
            String userId = req.getUserId();
            String atVal = (req.getAuthType()!=null && !req.getAuthType().isEmpty()) ? req.getAuthType() : "2";

            System.out.println("[2FA] userId='" + userId + "' atVal='" + atVal + "'");

            if (userId == null || userId.isEmpty()) {
                Map<String,Object> err = new HashMap<>();
                err.put("ok", false);
                err.put("message", "userId 없음 - 로그인 아이디를 입력하세요");
                return ResponseEntity.badRequest().body(err);
            }

            // mSABER 파라미터 암호화 (CBC+IV=key+base64url, cryptoSM.jar 와 동일 로직)
            String ud = AESCryptor.encryptForMsaber(userId);
            String sd = AESCryptor.encryptForMsaber(SITE_CODE);
            String at = AESCryptor.encryptForMsaber(atVal);

            System.out.println("[2FA] ud=" + ud + " sd=" + sd + " at=" + at);

            if (ud == null || sd == null || at == null) {
                Map<String,Object> err = new HashMap<>();
                err.put("ok", false);
                err.put("message", "암호화 결과 null (ud=" + ud + ", sd=" + sd + ", at=" + at + ")");
                return ResponseEntity.badRequest().body(err);
            }

            UriComponentsBuilder bld = UriComponentsBuilder
                    .fromHttpUrl(MSABER_BASE + "/module/v2/option")
                    .queryParam("ud", ud)
                    .queryParam("sd", sd)
                    .queryParam("at", at);
            if (fwd != null && !fwd.isEmpty()) {
                bld.queryParam("ci", AESCryptor.encryptForMsaber(fwd));
            }
            // build(true) → build().encode() 로 변경: == 가 %3D%3D 로 안전하게 인코딩됨
            java.net.URI uri = bld.build().encode().toUri();
            System.out.println("[2FA] URL=" + uri);

            // --- mSABER 응답을 String 으로 먼저 받아 실제 본문 확인 ---
            JsonNode bodyNode;
            try {
                ResponseEntity<String> raw = rest.postForEntity(uri, null, String.class);
                System.out.println("[2FA] mSABER status=" + raw.getStatusCode());
                System.out.println("[2FA] mSABER body=" + raw.getBody());

                com.fasterxml.jackson.databind.ObjectMapper om = new com.fasterxml.jackson.databind.ObjectMapper();
                bodyNode = om.readTree(raw.getBody());
            } catch (org.springframework.web.client.HttpStatusCodeException he) {
                System.out.println("[2FA] mSABER ERROR status=" + he.getStatusCode());
                System.out.println("[2FA] mSABER ERROR body=" + he.getResponseBodyAsString());
                Map<String,Object> err = new HashMap<>();
                err.put("ok", false);
                err.put("message", "mSABER " + he.getStatusCode() + " 응답");
                return ResponseEntity.badRequest().body(err);
            }

            int result = (bodyNode != null) ? bodyNode.path("result").asInt(0) : 0;
            if (result != 1) {
                Map<String,Object> err = new HashMap<>();
                err.put("ok", false);
                err.put("message", (bodyNode!=null)? bodyNode.path("description").asText("세션 토큰 생성 실패") : "응답 없음");
                return ResponseEntity.badRequest().body(err);
            }
            Map<String,Object> ok = new HashMap<>();
            ok.put("ok", true);
            ok.put("challenge", bodyNode.path("challenge").asText());
            return ResponseEntity.ok(ok);

        } catch (Exception e) {
            e.printStackTrace();
            Map<String,Object> err = new HashMap<>();
            err.put("ok", false);
            err.put("message", e.getClass().getSimpleName()+" - "+e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }

    public static class OptionRequest {
        private String userId;   // ud
        private String otp;      // o  (옵션)
        private String authType; // at (옵션, 기본 2=생체)
        public String getUserId() { return userId; }
        public void setUserId(String userId) { this.userId = userId; }
        public String getOtp() { return otp; }
        public void setOtp(String otp) { this.otp = otp; }
        public String getAuthType() { return authType; }
        public void setAuthType(String authType) { this.authType = authType; }
    }
}