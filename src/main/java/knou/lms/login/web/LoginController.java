package knou.lms.login.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.LoginFailedException;
import knou.framework.util.CommonUtil;
import knou.framework.util.SessionUtil;
import knou.framework.util.URLBuilder;
import knou.lms.log.logintry.vo.LogUserLoginTryLogVO;
import knou.lms.login.param.LoginParam;
import knou.lms.login.service.LoginService;
import knou.lms.org.service.OrgService;
import knou.lms.org.vo.OrgVO;
import knou.lms.user.param.UserMetaParam;
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

	/**
	 * @Method Name : main
	 * @Method 설명 : 홈페이지 메인 폼
	 * @param
	 * @param commandMap
	 * @param model
	 * @return "/logout.jsp"
	 * @throws Exception
	 */
	@RequestMapping(value = "/logout.do")
	public String logout( ModelMap model, HttpServletRequest request) throws Exception {

		SessionUtil.removeAll(request);
		return "redirect:" + new URLBuilder("", "login.do", request).toString();
	}

	/**
	 * @Method Name : main
	 * @param model
	 * @return "/login.jsp"
	 * @throws Exception
	 */
	@RequestMapping(value = "/login.do")
	public String login(ModelMap model, HttpServletRequest request) throws Exception {

		List<OrgVO> orgList = orgService.orgListSelect();
		model.addAttribute("orgList", orgList);
		return "login/login";
	}

	/**
	 * 로그인 처리
	 * @param LoginParam
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/loginProc.do")
    public String loginProcTOBE(LoginParam param, HttpServletRequest request, HttpServletResponse response) throws Exception {

		log.info("loginProc.do 시작");

	    try {
	    	
	    	// 0. LoginMetaVO 생성
	    	UserMetaParam userMetaParam = CommonUtil.createUserMetaParam(request);
	    	
	        // 1. login 처리
	        UserContext userCtx = loginService.processLogin(param, userMetaParam);

	        // 2. 세션 변수 설정 --> 삭제예정
	        UserVO selectedUser = userCtx.getSelectedUser();
	        SessionInfo.setOrgId(request,       selectedUser.getOrgId());
	        SessionInfo.setUserId(request,      selectedUser.getUserId());
	        SessionInfo.setUserRprsId(request,  selectedUser.getUserRprsId());
	        SessionInfo.setAuthrtCd(request,    selectedUser.getUserTycd());
	        SessionInfo.setAuthrtGrpcd(request, selectedUser.getUserTycd());

	        // 3. USER_CONTEXT 세션저장
	        SessionInfo.setUserContext(request, userCtx); // USER_CONTEXT

	        // 4. 화면 분기
	        String initUrl = resolveDashboard(selectedUser.getUserTycd());
	        log.info("initUrl=" + initUrl);

	        return "redirect:/dashboard" + initUrl;

	    } catch (LoginFailedException e) {
	        // 로그인 실패 시 (비번 틀림 등)
	        handleLoginFail(param.getUserId());
	        return "/index";
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "/index";
	    }
    }

	private boolean isHackInput(String uri) {
        if (uri == null)
        	return false;
        return uri.toUpperCase().contains(" OR ") || uri.toUpperCase().contains(" AND ")
        		|| uri.contains("'") || uri.contains("\"");
    }

    private boolean isValidUser(UserVO user) {
        //TODO: if ("N".equals(user.getStatus())) return false;
        //TODO: if ("UNPAID".equals(user.getLoginAcptDivCd())) return false;
        //TODO: return !StringUtil.isNull(user.getAuthrtCd());
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
        //TODO: usrLoginService.editLastLogin(user);
        SessionInfo.setUserId(request, user.getUserId());
        SessionInfo.setUserNm(request, user.getUsernm());
        SessionInfo.setOrgId(request, user.getOrgId());

        //	권한 정규화?
        //String role = normalizeRole(user.getAuthrtGrpcd());
        //SessionInfo.setAuthrtGrpcd(request, role);
        //SessionInfo.setAuthrtCd(request, user.getAuthrtCd());
    }

    private String normalizeRole(String role) {
        if (role == null) return "STDNT";
        if (role.contains("ADM")) return "ADM";
        if (role.contains("PROF")) return "PROF";
        return "STDNT";
    }

    private String resolveDashboard(String role) {
        switch (role) {
            case "ADM":   return "/adminDashboard.do";
            case "PROF":  return "/profDashboard.do";
            case "STDNT": return "/stuDashboard.do";
            default: return "/index";
        }
    }
}