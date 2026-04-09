package knou.lms.login.web;

import java.util.Arrays;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import knou.framework.common.CommConst;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.LoginFailedException;
import knou.framework.util.CommonUtil;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.LocaleUtil;
import knou.framework.util.SessionUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.service.OrgCfgService;
import knou.lms.common.vo.OrgCfgVO;
import knou.lms.connip.service.OrgConnIpService;
import knou.lms.log.adminconnlog.service.LogAdminConnLogService;
import knou.lms.log.logintry.service.LogUserLoginTryLogService;
import knou.lms.log.logintry.vo.LogUserLoginTryLogVO;
import knou.lms.login.param.LoginParam;
import knou.lms.login.service.LoginService;
import knou.lms.menu.service.SysMenuMemService;
import knou.lms.user.param.UserMetaParam;
import knou.lms.user.service.UserService;
import knou.lms.user.service.UsrLoginService;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.TmpLoginVO;
import knou.lms.user.vo.UserVO;
import knou.lms.user.vo.UsrLoginVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Controller
public class LoginControllerTOBE {

    private static Logger log = Logger.getLogger(LoginControllerTOBE.class);

    @Autowired
    private LoginService loginService;

    @Autowired @Qualifier("orgCfgService")
    private OrgCfgService orgCfgService;

    @Autowired @Qualifier("usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;

    @Autowired @Qualifier("usrLoginService")
    private UsrLoginService usrLoginService;

    @Autowired @Qualifier("logUserLoginTryLogService")
    private LogUserLoginTryLogService logUserLoginTryLogService;

    @Autowired @Qualifier("logAdminConnLogService")
    private LogAdminConnLogService logAdminConnLogService;

    @Autowired @Qualifier("sysMenuMemService")
    private SysMenuMemService sysMenuMemService;

    @Autowired @Qualifier("orgConnIpService")
    private OrgConnIpService orgConnIpService;

    @Autowired @Qualifier("userService")
    private UserService userService;

	/**
	 * 로그인 처리
	 * @param LoginParam
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	@RequestMapping(value="/loginProcTOBE.do")
    public String loginProcTOBE(LoginParam param, HttpServletRequest request, HttpServletResponse response) throws Exception {

		log.info("loginProcTOBE.do 시작");

	    try {
	    	
	    	// 0. LoginMetaVO 생성
	    	UserMetaParam userMetaParm = new UserMetaParam();
	    	
	        // 1. login 처리
	        UserContext userCtx = loginService.processLogin(param, userMetaParm);

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
	        return "/indexTOBE";
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "/indexTOBE";
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
            case "PROF":  return "/dashboard.do";
            case "STDNT": return "/dashboard.do";
            default: return "/index";
        }
    }

    private void updateUserLanguage(HttpServletRequest request, String userAcntId, String userId, String language) throws Exception {

        LocaleUtil.setLocale(request, language);

        UsrUserInfoVO user = new UsrUserInfoVO();
        user.setUserRprsId(userAcntId);
        user.setUserId(userId);

        UsrUserInfoVO info = usrUserInfoService.userSelect(user);

        String conf = StringUtil.nvl(info.getUserConf(), "{}");

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject) parser.parse(conf);
        json.put("lang", language);

        info.setUserConf(json.toJSONString());
        usrUserInfoService.userStngModify(info);
    }

    private void changeUserSession(HttpServletRequest request, String chgUserId) {
        List<UsrUserInfoVO> list = SessionInfo.getUserRltnList(request);
        if (list == null) return;
        for (UsrUserInfoVO user : list) {
            if (chgUserId.equals(user.getUserId())) {
                SessionInfo.setUserId(request, user.getUserId());
                SessionInfo.setUserNm(request, user.getUserNm());
                SessionInfo.setOrgId(request, user.getOrgId());
                SessionInfo.setAuthrtGrpcd(request, user.getAuthrtGrpcd());
                SessionInfo.setAuthrtCd(request, user.getWwwAuthrtCd());
                break;
            }
        }
    }

    private boolean isNeedRelogin(HttpServletRequest request, String userId) {
        String loginGbn = SessionInfo.getLoginGbn(request);
        String chk = CommConst.LOGINGBN_CHECK_YN;
        //if ("2023201349".equals(userId)) return false;
        return !SessionInfo.isVirtualLogin(request) && "Y".equals(chk) && "0".equals(loginGbn);
    }
}