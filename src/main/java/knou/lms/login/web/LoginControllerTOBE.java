package knou.lms.login.web;

import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import com.naru.provider.ServiceProvider;

import knou.framework.common.CommConst;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
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
	 * @param vo
	 * @param commandMap
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/loginProcTOBE.do")
    public String loginProcTOBE(LoginParam param, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    
		log.info("loginProcTOBE.do 시작");
		
		String	initUrl = "redirect:/";
		String	loginUrl = "/indexTOBE";

        //	SQLInjection방어(간단필터)
        //if ( isHackInput( param.getGoMcd()) || isHackInput(param.getGoUrl())) { // 로그인 후 페이지 이동으로 추정
        //    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        //    return null;
        //}
		// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>. 인터셉터에 추가해서 로그인 후 이동한다.
		//if (userCtx == null) {
		//    SessionInfo.setPreviousUrl(request, request.getRequestURI());
		//    response.sendRedirect("/login.do");
		//    return false;
		//}
		// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>. 로그인 성공 후 처리
		//String prevUrl = (String) SessionInfo.getPreviousUrl(request);
		//if (prevUrl != null) {
		//    SessionInfo.getPreviousUrl(request);
		//    return "redirect:" + prevUrl;
		//}
		//return "redirect:/dashboard/dashboard.do";

		try { 
			
	        boolean	existUserId = true; // TODO: userService.existUserId(param);
	        //	userService.existUserId(param);
	        
	        boolean isCorrectPswd = true; // TODO: userService.isCorrectPswd(param);
	        //	userService.loing(param);
	        
	        boolean isValidUser = true; // TODO: userService.isVaildUser(param);
	        // 	userService.isValidUser(param);
               	
        	//	아이디존재확인
            if (! existUserId ) 
                return loginUrl;
            
            //	비밀번호일치확인
            if (! isCorrectPswd ) 
                return loginUrl;

            //	유효사용자확인
            if (!isValidUser)
                return loginUrl;            
            
            UserVO loginUser = userService.userSelect(param.getUserId());
            
            UserContext userCtx = new UserContext();
            userCtx.setLoginUser(loginUser);
            userCtx.setSelectedUser(loginUser);

    		List<UserVO> 	registeredUsersList = userService.registeredUsersSelect(userCtx.getSelectedUser().getUserRprsId());
    		
    		//1. 대표아이디로 	교수아이디들 조회
    		List<String>	profIds =  userService.userIdsSelect(userCtx.getSelectedUser().getUserRprsId());
            
    		//2. 대표아이디로 	수강생아이디들 조회
    		List<String>	stdntIds =  userService.userIdsSelect(userCtx.getSelectedUser().getUserRprsId());
            
            //1.1. 대표아이디 없을 경우 로그인한 아이디로 조회
    		if ( profIds.isEmpty() )
    			profIds.add(userCtx.getSelectedUser().getUserId());
    		
    		if ( stdntIds.isEmpty() )
    			stdntIds.add(userCtx.getSelectedUser().getUserId());
            
            //2. 과목테이블에서[교수] 기관아이디조회, 수강테이블에서[학생] 기관아이디조회 - orgid, orgnm, sbjctId, sbjctnm, userTycd - 교수
    		List<EgovMap> userOrgIdsFromSubject = userService.subjectByUserOrgIdSelect(profIds, stdntIds); // 과목테이블에서[교수] 기관아이디조회, 수강테이블에서[학생] 기관아이디조회
            userCtx.setUserOrgIdsFromSubject(userOrgIdsFromSubject);
    		
    		
    		// TODO: Authenticate SessionInfo 변수들과 호환을 위해 start
    		SessionInfo.setUserId(request, userCtx.getSelectedUser().getUserId());
    		SessionInfo.setAuthrtCd(request, userCtx.getSelectedUser().getUserTycd());
    		SessionInfo.setAuthrtGrpcd(request, userCtx.getSelectedUser().getUserTycd());
    		// TODO: Authenticate SessionInfo 변수들과 호환을 위해 end
    		
    		// TODO: 초기 UserContext와 호환을 위해 start
    		// TODO: 초기 UserContext와 호환을 위해 end
    		
    		Map<String, UserVO> registeredUsers = new HashMap<>();
    		/* 프로그램의 가독성을 위해 람다식을 사용하지 않습니다 */
    		if ( null != registeredUsersList ) {    			
				for (UserVO regiUser : registeredUsersList) {
					if ( null != regiUser ) {
						registeredUsers.put(regiUser.getUserId(), regiUser);
					}
				}				
    		}    		
    		userCtx.setRegisteredUsers(registeredUsers);    		
    		
    		// 3 orgCtx		생성 -- 로그인한 사용자의 대표아이디로 소속기관 전부와 해당 기관에서의 권한을 로딩 - 필요한가?
    		// 4 menuCtx 	생성 -- 사용자가 소유한 모든 아이디의 메뉴들을 로딩 - 필요한가?
    		// 5 subjectCtx 생성 -- 사용자가 소유한 과목의 정보를 로딩 - 필요한가?
    		
            // 6 권한별 화면으로 분기 PROF, STDNT, ADM
    		initUrl = resolveDashboard(userCtx.getSelectedUser().getUserTycd()); 
    		
    		// UserContext를 세션에 저장
    		SessionInfo.setUserContext(request, userCtx);

        } catch (Exception e) {
        	handleLoginFail(param.getUserId());
            //return "redirect:/indexTOBE";
        } finally {
            //TODO: userService.loginModify(param.getUserId());
        }
        
        return "redirect:/dashboard" + initUrl;
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

        //	권한 정규화
        //String role = normalizeRole(user.getAuthrtGrpcd());

        //SessionInfo.setAuthrtGrpcd(request, role);
        //SessionInfo.setAuthrtCd(request, user.getAuthrtCd());

        //	userCtx 생성
		/*
		 * UserContext userCtx = new UserContext( user.getOrgId(), user.getUserId(),
		 * user.getAuthrtCd(), user.getRprsId(), role, SessionInfo.getLastLogin(request)
		 * );
		 */

        //srequest.getSession().setAttribute("userCtx", userCtx);
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

        UsrUserInfoVO info = usrUserInfoService.viewUser(user);

        String conf = StringUtil.nvl(info.getUserConf(), "{}");

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject) parser.parse(conf);
        json.put("lang", language);

        info.setUserConf(json.toJSONString());
        usrUserInfoService.updateUserConf(info);
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
	
	/**
     * sso 임시 로그인
     * 
     * @param request
     * @param response
     * @param modelMap
     * @throws Exception
     */
    @RequestMapping(value = "/sso/ssoLoginResTOBE.do")
    public String ssoLoginRes(HttpServletRequest request, HttpServletResponse response, TmpLoginVO tmpLoginVO,  ModelMap model) throws Exception {
        // 시스템 점검중 안내페이지 표시여부
        if ("Y".equals(CommConst.WORK_PAGE_YN)) {
            response.sendRedirect("/");
        }
        
        HttpSession ss = request.getSession();
        
        Enumeration<?> em = ss.getAttributeNames();
        while (em.hasMoreElements()) {
            String skey = (String) em.nextElement();
            //System.out.println(">>>"+skey+" -- "+ss.getAttribute(skey));
            //System.out.println(ss.getAttribute(skey));
        }
        
        String ssoUserId = (String) ss.getAttribute("SSO_ID");
        String str = (String) ss.getAttribute(ServiceProvider.SESSION_TOKEN);
        
        String[] lines = str.split("\r?\n|\r");
        
        int loginGnbIdx = -1;
        for(int i=0; i < lines.length; i++) {
            if(lines[i].indexOf("LOGINGBN") > -1) {
                loginGnbIdx = i;
            }
        }
        
        String loginGnb = lines[loginGnbIdx].substring(lines[loginGnbIdx].indexOf("=")+1);
        
        System.out.println(DateTimeUtil.getCurrentDateText() + " : SSO LOGIN ---> "+ssoUserId+", "+loginGnb);
        
        
        UsrLoginVO vo = new UsrLoginVO();
        
        vo.setOrgId("ORG0000001");
        vo.setOrgNm("KNOU");
        vo.setUserId(ssoUserId);
        vo.setUserIdEncpswd("SSO");
        
        UsrUserInfoVO uuivo = new UsrUserInfoVO();
        String userId = "";
        String orgId = vo.getOrgId();
        String pswdChgReqYn = "N";
        String mainMcd = "MC00000000"; //메인
        String goMcd = StringUtil.nvl(vo.getGoMcd(), mainMcd);
        String goUrl = vo.getGoUrl();
        Boolean isTmpLogin = false;
        List<UsrUserInfoVO> userRltnList = null;
        
        /** 브라우저 , 호스트 변조 접근 방지 시작 2015.12.15 */
        boolean chkUserAgentHack = false;
        if(StringUtil.nvl(goMcd).indexOf("' AND ") !=-1) chkUserAgentHack = true;
        if(StringUtil.nvl(goMcd).indexOf("' OR ") !=-1) chkUserAgentHack = true;
        if(StringUtil.nvl(goMcd).indexOf("\" AND ") !=-1) chkUserAgentHack = true;
        if(StringUtil.nvl(goMcd).indexOf("\" OR ") !=-1) chkUserAgentHack = true;
        if(StringUtil.nvl(goMcd).indexOf(" AND ") !=-1) chkUserAgentHack = true;
        if(StringUtil.nvl(goMcd).indexOf(" OR ") !=-1) chkUserAgentHack = true;
        if(StringUtil.nvl(goUrl).indexOf("' AND ") !=-1) chkUserAgentHack = true;
        if(StringUtil.nvl(goUrl).indexOf("' OR ") !=-1) chkUserAgentHack = true;
        if(StringUtil.nvl(goUrl).indexOf("\" AND ") !=-1) chkUserAgentHack = true;
        if(StringUtil.nvl(goUrl).indexOf("\" OR ") !=-1) chkUserAgentHack = true;
        if(StringUtil.nvl(goUrl).indexOf(" AND ") !=-1) chkUserAgentHack = true;
        if(StringUtil.nvl(goUrl).indexOf(" OR ") !=-1) chkUserAgentHack = true;
        if (chkUserAgentHack) {
            // log.error(message);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "ERROR");
            return null;
        }
        
        OrgCfgVO orgCfgVo = new OrgCfgVO();
        orgCfgVo.setOrgId(orgId);
        orgCfgVo.setCfgCtgrCd("LOGIN");
        orgCfgVo.setCfgCd("EXCEPTION");
        
        String exceptionMcd = orgCfgService.getValue(orgCfgVo);
        
        orgCfgVo.setCfgCtgrCd("LOGIN");
        orgCfgVo.setCfgCd("GAPTIME");
        
        int faileSec = Integer.parseInt(orgCfgService.getValue(orgCfgVo))/60;
        
        if(exceptionMcd.contains(goMcd)) {
            goMcd = mainMcd; //-- 예외 처리 메뉴 번호인 경우 홈페이지로 연결
        }
        
        uuivo.setUserId(vo.getUserId());
        uuivo.setUserIdEncpswd(vo.getUserIdEncpswd());
        
        LogUserLoginTryLogVO lultlvo = new LogUserLoginTryLogVO();
        lultlvo.setUserId(uuivo.getUserId());
        lultlvo.setBrowserInfo(request.getHeader("User-Agent"));
        lultlvo.setConnIp(CommonUtil.getIpAddress(request));
        lultlvo.setLoginSuccYn("Y");
        try {
            String orgId2 = StringUtil.nvl(uuivo.getOrgId(),"");
            if(orgId2.equals("")){
                uuivo.setOrgId(orgId);
            }
            
            uuivo = usrUserInfoService.viewForLogin(uuivo);
            
            // 퇴사자 체크
            String status = uuivo.getStatus();
            
            if("N".equals(StringUtil.nvl(status)) && !StringUtil.nvl(uuivo.getAuthrtGrpcd()).contains("USR")) {
                lultlvo.setLoginSuccYn("N");
                model.addAttribute("msg_code", "RETIRE");
                return "common/error_login";
            }
            
            // 미납자 체크
            if("UNPAID".equals(StringUtil.nvl(uuivo.getLoginAcptDivCd()))) {
                lultlvo.setLoginSuccYn("N");
                model.addAttribute("msg_code", "UNPAID");
                return "common/error_login";
            }
            
            String conf = StringUtil.nvl(uuivo.getUserConf());
            if (!"".equals(conf)) {
                JSONParser parser = new JSONParser();
                JSONObject jsonObject = (JSONObject) parser.parse(conf);
                String lang = StringUtil.nvl((String)jsonObject.get("lang"));
                if (!"".equals(lang)) {
                    LocaleUtil.setLocale(request, lang);
                    SessionInfo.setSysLocalkey(request, lang);
                }
            }
            
            // 마지막 로그인정보 조회
            if ("".equals(SessionInfo.getLastLogin(request))) {
                LogUserLoginTryLogVO loginTryLogVO = new LogUserLoginTryLogVO();
                loginTryLogVO.setUserId(uuivo.getUserId());
                System.out.println("66666666666666666666666666666666666666666");
                loginTryLogVO = logUserLoginTryLogService.selectLastLogin(loginTryLogVO);
                
                if (loginTryLogVO != null) {
                    SessionInfo.setLastLogin(request, loginTryLogVO.getLoginTryDttmStr());
                }
            }
            
            // 외부기관 사용자 연결정보 조회
            userRltnList = usrUserInfoService.selectUserOrgRltnByKnouUser(uuivo);
            
        } catch(Exception e) {
            uuivo = new UsrUserInfoVO();
            uuivo.setUserId(userId);
            lultlvo.setLoginSuccYn("N");
            System.out.println(DateTimeUtil.getCurrentDateText() + " : SSO LOGIN fail ---> "+ssoUserId);
            System.out.println(e.toString());
        } finally {
            logUserLoginTryLogService.add(lultlvo);
        }
        
        // 로그인 처리
        // 세션 정보를 셋팅해 준다.
        usrLoginService.editLastLogin(uuivo);
        SessionInfo.setUserId(request,uuivo.getUserId());
        SessionInfo.setUserRprsId(request,uuivo.getUserRprsId());
        SessionInfo.setUserNm(request,uuivo.getUserNm());
        SessionInfo.setUserPhoto(request, uuivo.getPhotoFileId());
        
        // 세션ID 저장(중복로그인 체크용)
        uuivo.setSessionId(request.getSession().getId());
        usrLoginService.insertSessionId(uuivo);
        
        //STUDENT:학생 / PROFESSOR:교수 / ADMIN:관리자   
        SessionInfo.setAuthrtGrpcd(request,uuivo.getAuthrtGrpcd());
        SessionInfo.setAuthrtCd(request,uuivo.getWwwAuthrtCd());
        // ADMIN 권한이있으면 Y / 없으면 N
        SessionInfo.setAdmYn(request,uuivo.getAdminAuthYn());
        SessionInfo.setLoginIp(request,CommonUtil.getIpAddress(request));
        SessionInfo.setOrgId(request,uuivo.getOrgId());
        SessionInfo.setOrgNm(request,vo.getOrgNm());
        SessionInfo.setDisablilityYn(request,uuivo.getDisablilityYn());
        SessionInfo.setDisablilityExamYn(request,uuivo.getDisablilityExamYn());
        SessionInfo.setUserDeptId(request,uuivo.getDeptCd());
        SessionInfo.setUniCd(request, uuivo.getUniCd());
        SessionInfo.setUserTypeDetail(request, uuivo.getUserTypeDetail());
        SessionInfo.setUserTycd(request, uuivo.getAuthrtGrpcd());
        
        if (userRltnList != null && userRltnList.size() > 1) {
        	SessionInfo.setUserRltnList(request, userRltnList);
        }
        
        /*로그인 구분 값은 아래와 같습니다.
        0 : 일반 로그인 (ID/PW)
        1 : 공동인증서 로그인(PKI인증)
        2 : 생체인증-지문(FIDO인증)
        3 : 카카오인증
        4 : 유예처리
        5 : 간편번호 인증
        */
        SessionInfo.setLoginGbn(request,loginGnb);
        
        // 파일함 접근 권한이 있는지 검사
        OrgCfgVO orgCfgVO = new OrgCfgVO();
        orgCfgVO.setOrgId(orgId);
        orgCfgVO.setCfgCtgrCd("FILE_BOX");
        orgCfgVO.setCfgCd("USER_AUTH");
        String fleBoxAuthGrp = orgCfgService.getValue(orgCfgVO);
        String[] arrFleBoxAuthGrp = fleBoxAuthGrp.split("\\,");
        String userTypes = SessionInfo.getAuthrtCd(request);
        String[] arrUserType = userTypes.split("\\|");
        String fileBoxUseAuthYn = "N";
        for(String userType : arrUserType) {
            if (Arrays.stream(arrFleBoxAuthGrp).anyMatch(userType::equals)) {
                fileBoxUseAuthYn = "Y";
                break;
            }
        }
        
        SessionInfo.setFileBoxUseAuthYn(request, fileBoxUseAuthYn);
        
        // 임시 비밀번호 로그인일 경우 프로필 관리 페이지 이동
        if(isTmpLogin) {
            //return "redirect:"+ new URLBuilder("user", "/userHome/Form/editProfileForm", request).toString();
        }
        
        request.getSession().setAttribute("SSO_STATUS", "login");
        
        String url = "/dashboard/main.do";
        String moveUrl = (String)SessionUtil.getSessionValue(request, "MOVE_URL_NOLOGIN");
    	if (moveUrl != null && !"".equals(moveUrl)) {
    		url = moveUrl;
    	}
    	SessionUtil.removeSessionValue(request, "MOVE_URL_NOLOGIN");
        
        return "redirect:"+url;
    }
    
    public String getBrowserType(HttpServletRequest request)
    {
        String browser = "";
        String userAgent = request.getHeader("User-Agent").toLowerCase();
        if (userAgent.indexOf("trident") >= 0 || userAgent.indexOf("msie") >= 0) {
            browser = "IE";
        }
        else if (userAgent.indexOf("edge") >= 0) {
            browser = "EG";
        }
        else if (userAgent.indexOf("opr") >= 0 || userAgent.indexOf("opera") >= 0) {
            browser = "OP";
        }
        else if (userAgent.indexOf("chrome") >= 0) {
            browser = "CR";
        }
        else if (userAgent.indexOf("safari") >= 0) {
            browser = "SF";
        }
        else if (userAgent.indexOf("firefox") >= 0) {
            browser = "FF";
        }
        else {
            browser = "NN";
        }
        return browser;
    }
    
}
