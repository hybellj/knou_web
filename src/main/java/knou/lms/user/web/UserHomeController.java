package knou.lms.user.web;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.ServiceProcessException;
import knou.framework.util.*;
import knou.framework.vo.FileVO;
import knou.lms.common.service.OrgCfgService;
import knou.lms.common.service.OrgMenuService;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.OrgMenuVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.connip.service.OrgConnIpService;
import knou.lms.log.adminconnlog.service.LogAdminConnLogService;
import knou.lms.log.adminconnlog.vo.LogAdminConnLogVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.logintry.service.LogUserLoginTryLogService;
import knou.lms.log.logintry.vo.LogUserLoginTryLogVO;
import knou.lms.log.privateinfo.service.PrivateInfoInqService;
import knou.lms.log.privateinfo.vo.PrivateInfoInqVO;
import knou.lms.login.service.LoginService;
import knou.lms.menu.service.SysMenuMemService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.user.facade.UserPrfilFacadeService;
import knou.lms.user.service.*;
import knou.lms.user.vo.*;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.dao.DataRetrievalFailureException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;
import java.util.*;

@Controller
@RequestMapping(value="/user/userHome")
public class UserHomeController extends ControllerBase {

    @Resource(name="usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;

    @Resource(name="usrLoginService")
    private UsrLoginService usrLoginService;

    @Resource(name="orgCfgService")
    private OrgCfgService orgCfgService;

    @Resource(name="logUserLoginTryLogService")
    private LogUserLoginTryLogService logUserLoginTryLogService;

    @Resource(name="logAdminConnLogService")
    private LogAdminConnLogService logAdminConnLogService;

    @Resource(name="sysMenuMemService")
    private SysMenuMemService sysMenuMemService;

    @Resource(name="privateInfoInqService")
    private PrivateInfoInqService privateInfoInqService;

    @Resource(name="orgMenuService")
    private OrgMenuService orgMenuService;

    @Resource(name="usrUserFindPswdService")
    private UsrUserFindPswdService usrUserFindPswdService;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name="usrEmailAuthService")
    private UsrEmailAuthService usrEmailAuthService;

    @Resource(name="orgConnIpService")
    private OrgConnIpService orgConnIpService;

    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    @Resource(name="stdService")
    private StdService stdService;

    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;

    @Resource(name="userPrfilFacadeService")
    private UserPrfilFacadeService userPrfilFacadeService;

    @Resource(name="userPrfilService")
    private UserPrfilService userPrfilService;
    
    @Resource(name="loginService")
	private LoginService loginService;

    /*****************************************************
     * 사용자 모드 전환 로그인 ( 관리자, 교수자)
     * @param UsrLoginVO
     * @return "redirect:"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value={"/loginUserByAdmin.do", "/loginUserByCourseStd.do"})
    public String virtualLogin(UsrLoginVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String servletPath = request.getServletPath();
        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = vo.getUserId();
        String goUrl = vo.getGoUrl(); // 로그인 후 이동할 URL

        if(servletPath.contains("/loginUserByAdmin.do")) {
            if(!menuType.contains("ADM")) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new AccessDeniedException(getMessage("common.system.no_auth"));
            }
        } else {
            if(!menuType.contains("PROF")) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new AccessDeniedException(getMessage("common.system.no_auth"));
            }
        }

        UsrUserInfoVO uuivo = new UsrUserInfoVO();
        uuivo.setUserId(userId);

        try {
            uuivo = usrUserInfoService.viewForLogin(uuivo);

            if(!orgId.equals(uuivo.getOrgId())) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }

            if(StringUtil.isNull(uuivo.getWwwAuthrtCd())) {
                // 사용자 권한정보가 존재하지 않습니다.
                throw new AccessDeniedException(getMessage("user.message.login.failed.no.auth"));
            }

            // 퇴사자 체크
            String status = uuivo.getStatus();

            if("N".equals(StringUtil.nvl(status)) && !StringUtil.nvl(uuivo.getAuthrtGrpcd()).contains("USR")) {
                model.addAttribute("msg_code", "RETIRE");
                return "common/error_login";
            }
        } catch(DataRetrievalFailureException e) {
            throw e;
        }

        String srcUserId = StringUtil.nvl(SessionInfo.getUserId(request));
        String srcUserNm = StringUtil.nvl(SessionInfo.getUserNm(request));
        String srcDeptCd = StringUtil.nvl(SessionInfo.getUserDeptId(request));
        String srcOrgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        // 로그인 처리
        // 세션 정보를 셋팅해 준다.
        SessionInfo.setUserId(request, uuivo.getUserId());
        SessionInfo.setUserId(request, uuivo.getUserId());
        SessionInfo.setUserNm(request, uuivo.getUserNm());

        // STUDENT:학생 / PROFESSOR:교수 / ADMIN:관리자   
        SessionInfo.setAuthrtGrpcd(request, uuivo.getAuthrtGrpcd());
        SessionInfo.setAuthrtCd(request, uuivo.getWwwAuthrtCd());
        // ADMIN 권한이있으면 Y / 없으면 N
        SessionInfo.setAdmYn(request, uuivo.getAdminAuthYn());

        SessionInfo.setLoginIp(request, CommonUtil.getIpAddress(request));
        SessionInfo.setOrgId(request, uuivo.getOrgId());
        SessionInfo.setOrgNm(request, vo.getOrgNm());
        SessionInfo.setDisablilityYn(request, uuivo.getDisablilityYn());
        SessionInfo.setDisablilityExamYn(request, uuivo.getDisablilityExamYn());
        SessionInfo.setUserDeptId(request, uuivo.getDeptCd());
        SessionInfo.setUniCd(request, uuivo.getUniCd());
        SessionInfo.setUserTypeDetail(request, uuivo.getUserTypeDetail());
        SessionInfo.setUserTycd(request, uuivo.getAuthrtGrpcd());
        SessionInfo.setUserPhoto(request, uuivo.getPhotoFileId());

        // 마지막 로그인 정보 조회
        LogUserLoginTryLogVO loginTryLogVO = new LogUserLoginTryLogVO();
        loginTryLogVO.setUserId(uuivo.getUserId());
        
        EgovMap loginUser = loginService.userLatestLoginHstrySelect(uuivo.getUserId());
        
        if (loginUser != null) {
            SessionInfo.setLastLogin(request, 
            		DateTimeUtil.getDateType(8, loginUser.get("loginTryDttm") + ".") + " (" + loginUser.get("connIp")+")");
        }

        if(SessionInfo.getAuthrtGrpcd(request).contains("ADM")) {
            LogAdminConnLogVO laclVO = new LogAdminConnLogVO();
            laclVO.setConnLogSn(IdGenerator.getNewId("ACLOG"));
            laclVO.setUserId(uuivo.getUserId());
            laclVO.setUserId(uuivo.getUserId());
            laclVO.setUserNm(uuivo.getUserNm());
            laclVO.setLoginIp(CommonUtil.getIpAddress(request));
            logAdminConnLogService.addConnectLog(laclVO);
        }

        if(vo.getModChgFromMenuCd() != null && !"".equals(StringUtil.nvl(vo.getModChgFromMenuCd()))) {

            // 사용자 모드 전환 전 아이디를 스택에 저장
            Stack<Map<String, Object>> stack = SessionInfo.getVirtualLoginStack(request);

            Map<String, Object> srcUserMap = new HashMap<>();
            srcUserMap.put("userId", srcUserId);
            srcUserMap.put("userNm", srcUserNm);
            srcUserMap.put("userId", srcUserId);
            srcUserMap.put("deptCd", srcDeptCd);
            srcUserMap.put("menuCd", vo.getModChgFromMenuCd());
            srcUserMap.put("searchCond", vo.getModChgSearchCond());
            srcUserMap.put("modChgType", "ADM");
            SessionInfo.setVirtualLoginInfo(request, srcUserMap);

            if(stack == null) {
                stack = new Stack<>();
            }

            stack.push(srcUserMap);
            SessionInfo.setVirtualLoginStack(request, stack);

            // 개인정보 접근 로그 기록(사용자 전환 모드에 대한 로그)
            PrivateInfoInqVO pildto = new PrivateInfoInqVO();
            pildto.setOrgId(srcOrgId);
            pildto.setMenuCd(StringUtil.nvl(SessionInfo.getMenuCode(request)));
            pildto.setUserId(srcUserId);
            pildto.setUserNm(srcUserNm);
            pildto.setDivCd("MOD_CHG");
            pildto.setModChgUserId(uuivo.getUserId());
            pildto.setModChgUserNm(uuivo.getUserNm());

            String inqCts = uuivo.getUserId();
            OrgMenuVO paramOrgMenuVO = new OrgMenuVO();
            paramOrgMenuVO.setOrgId(orgId);
            paramOrgMenuVO.setMenuCd(vo.getModChgFromMenuCd());
            paramOrgMenuVO.setLangCd(locale.getLanguage());
            OrgMenuVO orgMenuVO = orgMenuService.getMenuSimpleInfo(paramOrgMenuVO);

            if(orgMenuVO != null) {
                inqCts = StringUtil.nvl(orgMenuVO.getMenuTypeNm()) + " > " + StringUtil.nvl(orgMenuVO.getMenuNm()) + "(" + uuivo.getUserId() + ")";
            }
            pildto.setInqCts(inqCts);

            privateInfoInqService.add(pildto);
        }

        // 파일함 접근 권한이 있는지 검사
        /*
        OrgCfgVO orgCfgVO = new OrgCfgVO();
        orgCfgVO.setOrgId(orgId);
        orgCfgVO.setCfgCtgrCd("FILE_BOX");
        orgCfgVO.setCfgCd("USER_AUTH");
        String fleBoxAuthGrp = orgCfgService.getValue(orgCfgVO);
        String[] arrFleBoxAuthGrp = fleBoxAuthGrp.split("\\,");
        String userTypes = SessionInfo.getUserType(request);
        String[] arrUserType = userTypes.split("\\|");
        String fileBoxUseAuthYn = "N";
        for(String userType : arrUserType) {
            if (Arrays.stream(arrFleBoxAuthGrp).anyMatch(userType::equals)) {
                fileBoxUseAuthYn = "Y";
                break;
            }
        }
        SessionInfo.setFileBoxUseAuthYn(request, fileBoxUseAuthYn);
        */

        if(ValidationUtils.isNotEmpty(goUrl)) {
            if(goUrl.indexOf("crsHomeProf.do") > -1 || goUrl.indexOf("crsHomeStd.do") > -1) {
                SessionInfo.setCurUserHome(request, "/dashboard/main.do");
            }
            return "redirect:" + goUrl;
        }
        return "redirect:/dashboard/main.do";
    }

    /***************************************************** 
     * 사용자 모드 전환 로그인 ( 교수 )
     * @param UsrLoginVO
     * @return "redirect:"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/loginUserByProfessor.do")
    public String loginUserByProfessor(UsrLoginVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String crsCreCd = vo.getCrsCreCd();
        String userId = CommConst.TMP_USER_ID; // 임시 사용자 (학생화면보기)
        if(!"".equals(orgId) && !CommConst.KNOU_ORG_ID.equals(orgId)) {
            userId = "tmp_" + orgId;
        }

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        if(!menuType.contains("PROF")) {
            // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            throw new AccessDeniedException(getMessage("common.system.no_auth"));
        }

        UsrUserInfoVO uuivo = new UsrUserInfoVO();
        uuivo.setUserId(userId);
        uuivo.setUserId(userId);
        uuivo.setOrgId(orgId);

        try {
            // 임시사용자 등록
            usrUserInfoService.setTmpUser(uuivo);

            uuivo = usrUserInfoService.viewForLogin(uuivo);

            if(!orgId.equals(uuivo.getOrgId())) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new AccessDeniedException(getMessage("common.system.error"));
            }

            if(StringUtil.isNull(uuivo.getWwwAuthrtCd())) {
                // 사용자 권한정보가 존재하지 않습니다.
                throw new AccessDeniedException(getMessage("user.message.login.failed.no.auth"));
            }

            // 임시 수강생 등록
            StdVO stdVO = new StdVO();
            stdVO.setOrgId(orgId);
            stdVO.setCrsCreCd(crsCreCd);
            stdVO.setUserId(userId);
            stdService.insertTmpStd(stdVO);

            // 퇴사자 체크
            String status = uuivo.getStatus();

            if("N".equals(StringUtil.nvl(status)) && !StringUtil.nvl(uuivo.getAuthrtGrpcd()).contains("USR")) {
                model.addAttribute("msg_code", "RETIRE");
                return "common/error_login";
            }
        } catch(DataRetrievalFailureException e) {
            throw e;
        }

        String srcUserId = StringUtil.nvl(SessionInfo.getUserId(request));
        String srcUserNm = StringUtil.nvl(SessionInfo.getUserNm(request));
        String srcDeptCd = StringUtil.nvl(SessionInfo.getUserDeptId(request));
        String srcOrgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        // 로그인 처리
        // 세션 정보를 셋팅해 준다.
        SessionInfo.setUserId(request, uuivo.getUserId());
        SessionInfo.setUserId(request, uuivo.getUserId());
        SessionInfo.setUserNm(request, uuivo.getUserNm());

        // STUDENT:학생 / PROFESSOR:교수 / ADMIN:관리자   
        SessionInfo.setAuthrtGrpcd(request, uuivo.getAuthrtGrpcd());
        SessionInfo.setAuthrtCd(request, uuivo.getWwwAuthrtCd());
        // ADMIN 권한이있으면 Y / 없으면 N
        SessionInfo.setAdmYn(request, uuivo.getAdminAuthYn());

        SessionInfo.setLoginIp(request, CommonUtil.getIpAddress(request));
        SessionInfo.setOrgId(request, uuivo.getOrgId());
        SessionInfo.setOrgNm(request, vo.getOrgNm());
        SessionInfo.setDisablilityYn(request, uuivo.getDisablilityYn());
        SessionInfo.setDisablilityExamYn(request, uuivo.getDisablilityExamYn());
        SessionInfo.setUserDeptId(request, uuivo.getDeptCd());
        SessionInfo.setUniCd(request, uuivo.getUniCd());
        SessionInfo.setUserTypeDetail(request, uuivo.getUserTypeDetail());
        SessionInfo.setUserTycd(request, uuivo.getAuthrtGrpcd());
        SessionInfo.setUserPhoto(request, uuivo.getPhotoFileId());

        // 마지막 로그인 정보 조회
        LogUserLoginTryLogVO loginTryLogVO = new LogUserLoginTryLogVO();
        loginTryLogVO.setUserId(uuivo.getUserId());
        
        EgovMap loginUser = loginService.userLatestLoginHstrySelect(uuivo.getUserId());
        
        if (loginUser != null) {
            SessionInfo.setLastLogin(request, 
            		DateTimeUtil.getDateType(8, loginUser.get("loginTryDttm") + ".") + " (" + loginUser.get("connIp")+")");
        }

        if(SessionInfo.getAuthrtGrpcd(request).contains("ADM")) {
            LogAdminConnLogVO laclVO = new LogAdminConnLogVO();
            laclVO.setConnLogSn(IdGenerator.getNewId("ACLOG"));
            laclVO.setUserId(uuivo.getUserId());
            laclVO.setUserId(uuivo.getUserId());
            laclVO.setUserNm(uuivo.getUserNm());
            laclVO.setLoginIp(CommonUtil.getIpAddress(request));
            logAdminConnLogService.addConnectLog(laclVO);
        }

        // if(vo.getModChgFromMenuCd() != null && !"".equals(StringUtil.nvl(vo.getModChgFromMenuCd()))) {
        // 사용자 모드 전환 전 아이디를 스택에 저장
        Stack<Map<String, Object>> stack = SessionInfo.getVirtualLoginStack(request);

        Map<String, Object> srcUserMap = new HashMap<>();
        srcUserMap.put("userId", srcUserId);
        srcUserMap.put("userNm", srcUserNm);
        srcUserMap.put("userId", srcUserId);
        srcUserMap.put("deptCd", srcDeptCd);
        srcUserMap.put("menuCd", vo.getModChgFromMenuCd());
        srcUserMap.put("searchCond", vo.getModChgSearchCond());
        srcUserMap.put("modChgType", "PROF");
        srcUserMap.put("crsCreCd", crsCreCd);
        SessionInfo.setVirtualLoginInfo(request, srcUserMap);

        if(stack == null) {
            stack = new Stack<>();
        }

        stack.push(srcUserMap);
        SessionInfo.setVirtualLoginStack(request, stack);

        // 개인정보 접근 로그 기록(사용자 전환 모드에 대한 로그)
        PrivateInfoInqVO pildto = new PrivateInfoInqVO();
        pildto.setOrgId(srcOrgId);
        pildto.setMenuCd(StringUtil.nvl(SessionInfo.getMenuCode(request)));
        pildto.setUserId(srcUserId);
        pildto.setUserNm(srcUserNm);
        pildto.setDivCd("MOD_CHG");
        pildto.setModChgUserId(uuivo.getUserId());
        pildto.setModChgUserNm(uuivo.getUserNm());

        String inqCts = uuivo.getUserId();
        OrgMenuVO paramOrgMenuVO = new OrgMenuVO();
        paramOrgMenuVO.setOrgId(orgId);
        paramOrgMenuVO.setMenuCd(vo.getModChgFromMenuCd());
        paramOrgMenuVO.setLangCd(locale.getLanguage());
        OrgMenuVO orgMenuVO = orgMenuService.getMenuSimpleInfo(paramOrgMenuVO);

        if(orgMenuVO != null) {
            inqCts = StringUtil.nvl(orgMenuVO.getMenuTypeNm()) + " > " + StringUtil.nvl(orgMenuVO.getMenuNm()) + "(" + uuivo.getUserId() + ")";
        }

        pildto.setInqCts(inqCts);
        privateInfoInqService.add(pildto);
        // }

        // 파일함 접근 권한이 있는지 검사
        /*
        OrgCfgVO orgCfgVO = new OrgCfgVO();
        orgCfgVO.setOrgId(orgId);
        orgCfgVO.setCfgCtgrCd("FILE_BOX");
        orgCfgVO.setCfgCd("USER_AUTH");
        String fleBoxAuthGrp = orgCfgService.getValue(orgCfgVO);
        String[] arrFleBoxAuthGrp = fleBoxAuthGrp.split("\\,");
        String userTypes = SessionInfo.getUserType(request);
        String[] arrUserType = userTypes.split("\\|");
        String fileBoxUseAuthYn = "N";

        for(String userType : arrUserType) {
            if (Arrays.stream(arrFleBoxAuthGrp).anyMatch(userType::equals)) {
                fileBoxUseAuthYn = "Y";
                break;
            }
        }
        SessionInfo.setFileBoxUseAuthYn(request, fileBoxUseAuthYn);
        */

        // 과목세션정보 초기화
        SessionInfo.removeCourseInfo(request);

        return "redirect:/crs/crsHome.do?crsCreCd=" + crsCreCd;
    }

    /***************************************************** 
     * 사용자 모드 전환 아웃(원래로 돌아가기)
     * @param UsrLoginVO
     * @return "redirect:"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/modChgOut.do")
    public String modChgOut(UsrLoginVO vo, ModelMap map, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 모드 전환인 상태에서 로그아웃을 하는지 검사.(원 사용자로 다시 로그인 시켜야 함)

        Stack<Map<String, Object>> stack = SessionInfo.getVirtualLoginStack(request);
        Map<String, Object> beforeUserMap = null;

        if(stack != null && !stack.empty() && stack.size() > 0) {
            beforeUserMap = stack.pop();
        } else {
            beforeUserMap = SessionInfo.getVirtualLoginInfo(request);
        }

        if(beforeUserMap != null) {
            if(stack != null && !stack.empty() && stack.size() > 0) {
                SessionInfo.setVirtualLoginInfo(request, stack.peek());
            } else {
                SessionInfo.setVirtualLoginInfo(request, null);
            }

            String orgId = SessionInfo.getOrgId(request);
            UsrUserInfoVO uuivo = new UsrUserInfoVO();
            uuivo.setUserId(beforeUserMap.get("userId").toString());
            uuivo.setOrgId(orgId);
            uuivo = usrUserInfoService.viewForLogin(uuivo);
            SessionInfo.setUserId(request, uuivo.getUserId());
            SessionInfo.setUserId(request, uuivo.getUserId());
            SessionInfo.setUserNm(request, uuivo.getUserNm());

            //STUDENT:학생 / PROFESSOR:교수 / ADMIN:관리자   
            SessionInfo.setAuthrtGrpcd(request, uuivo.getAuthrtGrpcd());
            SessionInfo.setAuthrtCd(request, uuivo.getWwwAuthrtCd());
            // ADMIN 권한이있으면 Y / 없으면 N
            SessionInfo.setAdmYn(request, uuivo.getAdminAuthYn());

            SessionInfo.setLoginIp(request, CommonUtil.getIpAddress(request));
            SessionInfo.setOrgId(request, uuivo.getOrgId());
            SessionInfo.setOrgNm(request, vo.getOrgNm());
            SessionInfo.setDisablilityYn(request, uuivo.getDisablilityYn());
            SessionInfo.setDisablilityExamYn(request, uuivo.getDisablilityExamYn());
            SessionInfo.setUserDeptId(request, uuivo.getDeptCd());
            SessionInfo.setUniCd(request, uuivo.getUniCd());
            SessionInfo.setUserTypeDetail(request, uuivo.getUserTypeDetail());
            SessionInfo.setUserTycd(request, uuivo.getAuthrtGrpcd());
            SessionInfo.setUserPhoto(request, uuivo.getPhotoFileId());

            // 마지막 로그인 정보 조회
            LogUserLoginTryLogVO loginTryLogVO = new LogUserLoginTryLogVO();
            loginTryLogVO.setUserId(uuivo.getUserId());
            /* loginTryLogVO = logUserLoginTryLogService.userLatestLoginHstrySelect(loginTryLogVO); */

            if(loginTryLogVO != null) {
                SessionInfo.setLastLogin(request, loginTryLogVO.getLoginTryDttmStr()); // 에러날라나?
            }

            //수강생정보 삭제
            SessionInfo.setStdNo(request, "");
            SessionInfo.setSysLocalkey(request, "ko");
            LocaleUtil.setLocale(request, "ko");

            // 파일함 접근 권한이 있는지 검사
            /*
            OrgCfgVO orgCfgVO = new OrgCfgVO();
            orgCfgVO.setOrgId(orgId);
            orgCfgVO.setCfgCtgrCd("FILE_BOX");
            orgCfgVO.setCfgCd("USER_AUTH");
            String fleBoxAuthGrp = orgCfgService.getValue(orgCfgVO);
            String[] arrFleBoxAuthGrp = fleBoxAuthGrp.split("\\,");
            String userTypes = SessionInfo.getUserType(request);
            String[] arrUserType = userTypes.split("\\|");
            String fileBoxUseAuthYn = "N";
            for(String beforeUserType : arrUserType) {
                if (Arrays.stream(arrFleBoxAuthGrp).anyMatch(beforeUserType::equals)) {
                    fileBoxUseAuthYn = "Y";
                    break;
                }
            }
            SessionInfo.setFileBoxUseAuthYn(request, fileBoxUseAuthYn);
            */

            String modChgType = StringUtil.nvl(beforeUserMap.get("modChgType"));
            String crsCreCd = StringUtil.nvl(beforeUserMap.get("crsCreCd"));
            String menuCd = StringUtil.nvl(beforeUserMap.get("menuCd"));

            if("PROF".equals(modChgType)) {
                if(ValidationUtils.isNotEmpty(crsCreCd)) {
                    // 과목세션정보 초기화
                    SessionInfo.removeCourseInfo(request);

                    return "redirect:/crs/crsHome.do?crsCreCd=" + crsCreCd;
                }

                return "redirect:/dashboard/main.do";
            }

            // TB_ORG_MENU_TMP -> TB_ORG_MENU 변경전까지 하드코딩
            if("ADM0000000001".equals(menuCd)) {
                //원래 페이지로 이동
                return "redirect:/dashboard/adminDashboard.do";
            }

            //원래 페이지로 이동
            return "redirect:/user/userMgr/Form/manageUser.do";
        } else {
            return "redirect:/dashboard/main.do";
        }
    }

    /***************************************************** 
     * 사용자 비밀번호 초기화
     * @param UsrUserInfoVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/resetPass.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> resetPass(UsrUserInfoVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String tmpPass;

        // 수신자 이메일, 유저번호 체크
        if("".equals(StringUtil.nvl(vo.getEmail(), "")) || "".equals(StringUtil.nvl(vo.getUserId(), ""))) {
            resultVO.setResult(-1);
            resultVO.setMessage("system.fail.data.process.msg");/* 데이터 처리 중 오류가 발생하였습니다. */
            return resultVO;
        }

        // 사용자 검색
        try {
            vo.setOrgId(orgId);
            vo = usrUserInfoService.searchUserId(vo);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("system.fail.data.process.msg");/* 데이터 처리 중 오류가 발생하였습니다. */
            return resultVO;
        }

        try {
            tmpPass = usrLoginService.getNewPass();

            //초기화된 비밀번호 등록
            UsrLoginVO ulVO = new UsrLoginVO();
            ulVO.setUserId(vo.getUserId());
            ulVO.setUserIdEncpswd(tmpPass);
            ulVO.setTmpPswd(tmpPass);
            ulVO.setMdfrId("searchPw");
            usrLoginService.editPass(ulVO);     // 유저 비밀번호 임시 비밀번호변경
            usrLoginService.editTmpPass(ulVO);  // 임시 비밀번호 변경

            // 이메일 템플릿 변수 적용결과 조회
            UsrUserFindPswdVO usrUserFindPswdVO = usrUserFindPswdService.getResetPassResultEmailTpl();

            if(usrUserFindPswdVO == null) {
                throw new ServiceProcessException();
            }

            // 이메일 템플릿 변수 설정
            Map<String, Object> argu = new HashMap<>();
            // 임시 비밀번호
            argu.put("Password", tmpPass);

            UsrUserInfoVO sndrInfoVO = new UsrUserInfoVO();
            sndrInfoVO.setUserId(userId);
            sndrInfoVO = usrUserInfoService.searchUserId(sndrInfoVO);

            // 이메일 전송용 파라미터 저장
            EgovMap egovMap = new EgovMap();
            egovMap.put("alarmType", "E");                                                              // 발송구분 (E: EMAIL)
            egovMap.put("userId", StringUtil.nvl(vo.getUserId()));                                      // 사용자번호
            egovMap.put("userNm", StringUtil.nvl(vo.getUserNm()));                                      // 사용자이름
            egovMap.put("rcvEmailAddr", StringUtil.nvl(vo.getEmail()));                                 // 수신자 이메일
            egovMap.put("sysCd", "SYSCD0001");                                                          // 시스템 코드
            egovMap.put("orgId", orgId);                                                                // 기관 코드
            egovMap.put("bussGbn", "UNI");                                                              // 업무구분
            egovMap.put("sendRcvGbn", "S");                                                             // 수신 발신 구분
            egovMap.put("subject", DecoratorUtil.replaceContens(usrUserFindPswdVO.getTitle(), argu));   // 제목
            egovMap.put("ctnt", DecoratorUtil.replaceContens(usrUserFindPswdVO.getCts(), argu));        // 내용
            egovMap.put("sndrPersNo", userId);                                                          // 발송자 개인번호
            egovMap.put("sndrDeptCd", StringUtil.nvl(sndrInfoVO.getDeptCd()));                          // 발송자 부서코드
            egovMap.put("sndrNm", StringUtil.nvl(sndrInfoVO.getUserNm()));                              // 발송자명
            egovMap.put("sndrEmailAddr", StringUtil.nvl(sndrInfoVO.getEmail()));                        // 발송자 이메일주소
            egovMap.put("logDesc", "비밀번호 초기화 이메일");                                                   // 로그설명

            resultVO.setReturnVO(egovMap);
            resultVO.setResult(1);
            resultVO.setMessage("user.message.useredit.temp.pswd.msg.send.complete");/* 입력하신 메일(연락처)로 임시 비밀번호를 발송 하였습니다. */
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("user.message.useredit.email.send.failed.msg");/* 이메일 전송과정에서 문제가 발생했습니다. */
        }

        return resultVO;
    }

    /*****************************************************
     * 내정보 팝업
     * @param UsrUserInfoVO
     * @return "user/popup/user_profile_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/userProfilePop.do")
    public String userProfilePop(UsrUserInfoVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        if(SessionInfo.getAuthrtGrpcd(request).contains("USR")) {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME, "내정보 확인");
        }

        vo.setUserId(SessionInfo.getUserId(request));

        vo = usrUserInfoService.userSelect(vo);

        request.setAttribute("phtFile", vo.getPhotoFileId());
        request.setAttribute("vo", vo);
        request.setAttribute("orgId", orgId);

        return "user/popup/user_profile_pop";
    }

    /*****************************************************
     * 내정보 수정 팝업
     * @param UsrUserInfoVO
     * @return "user/popup/user_profile_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/userProfileEditPop.do")
    public String userProfileEditPop(UsrUserInfoVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        vo.setUserId(SessionInfo.getUserId(request));
        vo = usrUserInfoService.userSelect(vo);
        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("USER_PROFILE");
        fileVO.setFileBindDataSn(vo.getUserId());
        ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);
        for(FileVO fvo : fileList.getReturnList()) {
            fvo.setFileId(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")));
        }
        request.setAttribute("fileList", fileList.getReturnList());
        UsrEmailAuthVO usrEmailAuthVO = new UsrEmailAuthVO();
        usrEmailAuthVO.setUserEmailAuthId("AUTH_210712T173020ee00002");
        usrEmailAuthVO = usrEmailAuthService.select(usrEmailAuthVO);
        request.setAttribute("usrEmailAuthVO", usrEmailAuthVO);
        request.setAttribute("phoneCodeList", orgCodeService.selectOrgCodeList("PHONE_CODE"));
        request.setAttribute("vo", vo);
        request.setAttribute("orgId", orgId);

        return "user/popup/user_profile_edit_pop";
    }

    /***************************************************** 
     * 사용자 수정
     * @param UsrUserInfoVO
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editUser.do")
    @ResponseBody
    public ProcessResultVO<UsrUserInfoVO> editUser(UsrUserInfoVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String connIp = StringUtil.nvl(CommonUtil.getIpAddress(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String phtFileDelYn = StringUtil.nvl(vo.getPhtFileDelYn());

        try {
            vo.setUserId(userId);
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            resultVO = usrUserInfoService.editUserInfo(vo, "UE", connIp);
            resultVO.setResult(1);

            if("Y".equals(phtFileDelYn)) {
                SessionInfo.setUserPhoto(request, null);
            }

            if(resultVO.getReturnVO() != null) {
                Method method = resultVO.getReturnVO().getClass().getMethod("getPhtFileByte");
                byte[] phtFileByte = (byte[]) method.invoke(resultVO.getReturnVO());
                
                /*
                BufferedImage im = null;
                try {
                    im = ImageIO.read( method.invoke(resultVO.getReturnVO()). );
                } catch(IOException e) {
                    //log.error("get error");
                }
                */

                //BufferedImage thumb = im;

                // 사진을 업데이트한 경우 세션에 사진정보 수정
                if(phtFileByte != null && phtFileByte.length > 0) {
                    String phtFile = "data:image/png;base64," + new String(Base64.getEncoder().encode(phtFileByte));
                    SessionInfo.setUserPhoto(request, phtFile);
                }
            }

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("fail.common.msg");/* 에러가 발생했습니다! */
        }

        return resultVO;
    }

    /***************************************************** 
     * 사용자 비밀번호 확인
     * @param UsrUserInfoVO
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/userPassLoginCheck.do")
    @ResponseBody
    public ProcessResultVO<UsrUserInfoVO> userPassLoginCheck(UsrUserInfoVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setOrgId(orgId);
            vo.setUserIdEncpswd(CryptoUtil.encryptSha(vo.getUserIdEncpswd()));
            vo = usrUserInfoService.viewForLoginCheck(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("fail.common.msg");/* 에러가 발생했습니다! */
        }
        return resultVO;
    }

    /***************************************************** 
     * 사용자 이메일 인증
     * @param UsrEmailAuthVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/sendEmailAuth.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> sendEmailAuth(UsrEmailAuthVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userEmailAuthId = request.getParameter("userEmailAuthId");
        String receiverEmail = request.getParameter("receiverEmail");

        // 수신자 이메일 체크
        if("".equals(StringUtil.nvl(receiverEmail, ""))) {
            resultVO.setResult(-1);
            resultVO.setMessage("system.fail.data.process.msg");/* 데이터 처리 중 오류가 발생하였습니다. */
            return resultVO;
        }

        try {
            vo.setUserEmailAuthId(userEmailAuthId);
            vo = usrEmailAuthService.select(vo);

            if(vo == null || !"Y".equals(StringUtil.nvl(vo.getUseYn()))) {
                throw new ServiceProcessException();
            }

            // 인증코드 생성
            String authCode = CryptoUtil.encryptAes256(receiverEmail, "").substring(0, 8);

            // 이메일 템플릿 변수 설정
            Map<String, Object> argu = new HashMap<>();
            argu.put("receiverEmail", receiverEmail);
            argu.put("authCode", authCode);

            UsrUserInfoVO sndrInfoVO = new UsrUserInfoVO();
            sndrInfoVO.setUserId(userId);
            sndrInfoVO = usrUserInfoService.searchUserId(sndrInfoVO);

            // 이메일 전송용 파라미터 저장
            EgovMap egovMap = new EgovMap();
            egovMap.put("alarmType", "E");                                          // 발송구분 (E: EMAIL)
            egovMap.put("userId", StringUtil.nvl(sndrInfoVO.getUserId()));          // 사용자번호
            egovMap.put("userNm", StringUtil.nvl(sndrInfoVO.getUserNm()));          // 사용자이름
            egovMap.put("rcvEmailAddr", StringUtil.nvl(sndrInfoVO.getEmail()));     // 수신자 이메일
            egovMap.put("sysCd", "SYSCD0001");                                      // 시스템 코드
            egovMap.put("orgId", orgId);                                            // 기관 코드
            egovMap.put("bussGbn", "UNI");                                          // 업무구분
            egovMap.put("sendRcvGbn", "S");                                         // 수신 발신 구분
            egovMap.put("subject", StringUtil.nvl(vo.getTitle()));                  // 제목
            egovMap.put("ctnt", DecoratorUtil.replaceContens(vo.getCts(), argu));   // 내용
            egovMap.put("sndrPersNo", StringUtil.nvl(vo.getRgtrId()));               // 발송자 개인번호
            egovMap.put("sndrDeptCd", "");                                          // 발송자 부서코드
            egovMap.put("sndrNm", StringUtil.nvl(vo.getSenderNm()));                // 발송자명
            egovMap.put("sndrEmailAddr", StringUtil.nvl(vo.getSenderEmail()));      // 발송자 이메일주소
            egovMap.put("logDesc", "메일 인증용");                                      // 로그설명

            resultVO.setReturnVO(egovMap);
            resultVO.setResult(1);
            resultVO.setMessage("user.message.useredit.msg.send.complete");/* 입력하신 메일(연락처)로 인증코드를 발송 하였습니다. */
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("user.message.useredit.email.send.failed.msg");/* 이메일 전송과정에서 문제가 발생했습니다. */
        }

        return resultVO;
    }

    /***************************************************** 
     * 이메일 인증코드 확인
     * @param UsrUserInfoVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/emailAuthCheck.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> emailAuthCheck(UsrUserInfoVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        String authCode = request.getParameter("authCode");

        if(checkEmailAuth(authCode, vo.getEmail())) {
            resultVO.setResult(1);
        } else {
            resultVO.setResult(-1);
        }

        return resultVO;
    }

    /***************************************************** 
     * 이메일 인증코드 확인
     * @param authCode, originEmail
     * @return boolean
     * @throws Exception
     ******************************************************/
    private boolean checkEmailAuth(String authCode, String originEmail) throws Exception {
        if("".equals(StringUtil.nvl(authCode, "")) || "".equals(StringUtil.nvl(originEmail, ""))) {
            return false;
        }

        if(authCode.length() != 8) {
            return false;
        }

        String originAuthCode = CryptoUtil.encryptAes256(originEmail, "").substring(0, 8);

        if(authCode.equals(originAuthCode)) {
            return true;
        } else {
            return false;
        }
    }

    /***************************************************** 
     * 사용자 환경 설정 변경
     * @param UsrUserInfoVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/setUserConf")
    @ResponseBody
    public ProcessResultVO<EgovMap> setUserConf(UsrUserInfoVO vo, ModelMap map, HttpServletRequest request) throws Exception {
    	
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        String confType = StringUtil.nvl(request.getParameter("confType"));
        String confVal = StringUtil.nvl(request.getParameter("confVal"));        
        

        if("theme".equals(confType)) {
            SessionInfo.setThemeMode(request, confVal);
        }

        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 로그아웃
     *
     * @param request
     * @param response
     * @param tmpLoginVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/logout.do")
    public String logout(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        if(SessionInfo.getAuthrtGrpcd(request).contains("USR")) {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME, "로그아웃");
        }

        SessionUtil.removeAll(request);
        request.getSession().invalidate();

        String url = "redirect:/";

        return url;
    }

    /***************************************************** 
     * 학과(부서) 목록 조회 (학기별 수강생의 부서)
     * @param UsrDeptCdVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listByStdHaksaTerm.do")
    @ResponseBody
    public ProcessResultVO<UsrDeptCdVO> listByStdHaksaTerm(UsrDeptCdVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<UsrDeptCdVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);

            List<UsrDeptCdVO> list = usrDeptCdService.listDeptByStdHaksaTerm(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 사용자 프로필 화면 조회
     * @param UserPrfilVO
     * @return "user/prfile/user_prfil_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/userPrfilView.do")
    public String userPrfilView(UserPrfilVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        UserContext userContext = new UserContext(SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getUserTycd(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));

        UserPrfilView userPrfilView = userPrfilFacadeService.loadUserPrfil(userContext);

        //model.addAttribute("phtFile", vo.getPhotoFileId());
        model.addAttribute("vo", userPrfilView.getUserPrfilVO());
        model.addAttribute("userAuthrtList", userPrfilView.getUserAuthrtList());
        //model.addAttribute("orgId", orgId);

        return "user/prfil/user_prfil_view";
    }

    /**
     * 사용자프로필알림변경 Ajax
     *
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/userPrfilAlimChangeAjax.do")
    @ResponseBody
    public ProcessResultVO<UserPrfilVO> userPrfilAlimChangeAjax(UserPrfilVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<UserPrfilVO> resultVO = new ProcessResultVO<>();

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = SessionInfo.getUserId(request);

        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);

            userPrfilService.userPrfilAlimChange(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /**
     * 사용자프로필수정화면 조회
     *
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/userPrfilModifyView.do")
    public String userPrfilModifyView(UserPrfilVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        UserContext userContext = new UserContext(SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getUserTycd(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));

        UserPrfilView userPrfilView = userPrfilFacadeService.loadUserPrfilModify(userContext);

        model.addAttribute("vo", userPrfilView.getUserPrfilVO());
        model.addAttribute("userAuthrtList", userPrfilView.getUserAuthrtList());
        model.addAttribute("nowSmstrLectOrgList", userPrfilView.getNowSmstrLectOrgList());

        return "user/prfil/user_prfil_modify_view";
    }

    @RequestMapping(value="/userPrfilPswdChkAjax.do")
    @ResponseBody
    public ProcessResultVO<UserPrfilVO> userPrfilPswdChkAjax(UserPrfilVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<UserPrfilVO> resultVO = new ProcessResultVO<>();

        String userId = SessionInfo.getUserId(request);

        try {
            vo.setUserId(userId);
            // 패스워드 암호화
            String enc = CryptoUtil.encryptSha(vo.getUserIdEncpswd());
            vo.setUserIdEncpswd(enc);

            UserPrfilVO returnVO = new UserPrfilVO();
            boolean pswdMtched = userPrfilService.isPswdMtch(vo);
            returnVO.setPswdMtchyn(pswdMtched ? "Y" : "N");

            resultVO.setReturnVO(returnVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /**
     * 사용자프로필 수정
     *
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/userPrfilModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<UserPrfilVO> userPrfilModifyAjax(UserPrfilVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<UserPrfilVO> resultVO = new ProcessResultVO<>();

        UserContext userContext = new UserContext(SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getUserTycd(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));

        try {

            userPrfilFacadeService.modifyUserPrfil(userContext, vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;

    }

    /**
     * 사용자 프로필 알림수신동의 유의사항 모달
     *
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/alimNoticePopview.do")
    public String alimNoticePopview(ModelMap model, HttpServletRequest request) throws Exception {
        return "user/prfil/alim_notice_popview";
    }
}
