package knou.lms.login.web;

import java.util.Arrays;
import java.util.Enumeration;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.naru.provider.ServiceProvider;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.CommonUtil;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.LocaleUtil;
import knou.framework.util.SessionUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.URLBuilder;
import knou.lms.common.service.OrgCfgService;
import knou.lms.common.vo.OrgCfgVO;
import knou.lms.connip.service.OrgConnIpService;
import knou.lms.log.adminconnlog.service.LogAdminConnLogService;
import knou.lms.log.logintry.service.LogUserLoginTryLogService;
import knou.lms.log.logintry.vo.LogUserLoginTryLogVO;
import knou.lms.login.service.LoginService;
import knou.lms.login.vo.LoginVO;
import knou.lms.menu.service.SysMenuMemService;
import knou.lms.user.service.UsrLoginService;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.TmpLoginVO;
import knou.lms.user.vo.UsrLoginVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Controller
public class LoginControllerTOBE extends ControllerBase {
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
    public String loginProc(UsrLoginVO vo, Map commandMap, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    
		String reloginUrl = "redirect:/";

        //	SQL Injection 방어 (간단 필터)
        if ( isHackInput(vo.getGoMcd()) || isHackInput(vo.getGoUrl())) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return null;
        }

        UsrUserInfoVO user = new UsrUserInfoVO();
        user.setUserId(vo.getUserId());
        user.setUserRprsId(vo.getUserRprsId());
        user.setUserIdEncpswd(vo.getUserIdEncpswd());

        LogUserLoginTryLogVO logVO = createLoginLog(request, user);

        try {
            user = usrUserInfoService.viewForLogin(user);

            //	비밀번호 체크 (현재는 통과 상태)
            if (!checkPassword(user, vo)) {
                return reloginUrl;
            }

            //	상태 체크
            if (!isValidUser(user)) {
                return reloginUrl;
            }

        } catch (Exception e) {
            handleLoginFail(vo, user);
            return reloginUrl;
        } finally {
            logUserLoginTryLogService.add(logVO);
        }

        //	세션 세팅
        setSession(request, user);

        return "redirect:/userIndex.do";
    }
	
	 @RequestMapping("/userIndex.do")
	 public String main(HttpServletRequest request) throws Exception {

        String userId = SessionInfo.getUserId(request);
        String userAcntId = SessionInfo.getUserRprsId(request);
        String authGrp = SessionInfo.getAuthrtGrpcd(request);

        String type = StringUtil.nvl(request.getParameter("type"));
        String chgUserId = StringUtil.nvl(request.getParameter("userId"));
        String language = StringUtil.nvl(request.getParameter("language"));

        // 1️ 언어 설정
        if (!StringUtil.isNull(language) && !StringUtil.isNull(userId)) {
            updateUserLanguage(request, userAcntId, userId, language);
        }

        // 2 사용자 전환
        if ("change".equals(type)) {
            changeUserSession(request, chgUserId);
        }

        // 3️ 리로그인 체크
        if (isNeedRelogin(request, userId)) {
            Locale locale = LocaleUtil.getLocale(request);
            request.getSession().invalidate();
            request.getSession().setAttribute("relogin", "true");
            LocaleUtil.setLocale(request, locale.toString());
            return "redirect:/";
        }

        // 4️ 권한별 분기
        String returnUri = resolveDashboard(authGrp);

        return "redirect:/dashboard" + returnUri;
    }
	
 	private boolean isHackInput(String str) {
        if (str == null) return false;
        return str.contains(" OR ") || str.contains(" AND ") || str.contains("'") || str.contains("\"");
    }

    private boolean checkPassword(UsrUserInfoVO user, UsrLoginVO vo) {
        return true; // TODO: 실제 비밀번호 체크 적용
    }

    private boolean isValidUser(UsrUserInfoVO user) {
        if ("N".equals(user.getStatus())) return false;
        if ("UNPAID".equals(user.getLoginAcptDivCd())) return false;
        return !StringUtil.isNull(user.getAuthrtCd());
    }

    private void handleLoginFail(UsrLoginVO vo, UsrUserInfoVO user) {
        System.out.println("LOGIN FAIL : " + vo.getUserId());
    }

    private LogUserLoginTryLogVO createLoginLog(HttpServletRequest request, UsrUserInfoVO user) {
        LogUserLoginTryLogVO log = new LogUserLoginTryLogVO();
        log.setUserRprsId(user.getUserRprsId());
        log.setBrowserInfo(request.getHeader("User-Agent"));
        log.setConnIp(CommonUtil.getIpAddress(request));
        return log;
    }

    private void setSession(HttpServletRequest request, UsrUserInfoVO user) throws Exception {
        usrLoginService.editLastLogin(user);
        SessionInfo.setUserId(request, user.getUserId());
        SessionInfo.setUserNm(request, user.getUserNm());
        SessionInfo.setOrgId(request, user.getOrgId());

        //	권한 정규화
        String role = normalizeRole(user.getAuthrtGrpcd());

        SessionInfo.setAuthrtGrpcd(request, role);
        SessionInfo.setAuthrtCd(request, user.getAuthrtCd());

        //	userCtx 생성
        UserContext userCtx = new UserContext(
                user.getOrgId(),
                user.getUserId(),
                role,
                user.getAuthrtCd(),
                role,
                user.getUserRprsId(),
                SessionInfo.getLastLogin(request)
        );

        request.getSession().setAttribute("userCtx", userCtx);
    }

    private String normalizeRole(String role) {
        if (role == null) return "STDNT";
        if (role.contains("ADM")) return "ADM";
        if (role.contains("PROF")) return "PROF";
        return "STDNT";
    }

    private String resolveDashboard(String role) {
        switch (role) {
            case "ADM": return "/adminDashboard.do";
            case "PROF": return "/profDashboard.do";
            default: return "/stuDashboard.do";
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
