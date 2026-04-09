package knou.lms.dashboard.web.controller;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.Stack;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jackson.map.ObjectMapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.CommonUtil;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.IdGenerator;
import knou.framework.util.LocaleUtil;
import knou.framework.util.MapToVoUtil;
import knou.framework.util.SecureUtil;
import knou.framework.util.SessionUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.bbs.service.BbsAtclService;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.common.dto.BaseParam;
import knou.lms.common.service.OrgOrgInfoService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.OrgOrgInfoVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.dto.DashboardParam;
import knou.lms.dashboard.service.AcadSchService;
import knou.lms.dashboard.service.DashboardFacadeService;
import knou.lms.dashboard.service.DashboardService;
import knou.lms.dashboard.service.SchService;
import knou.lms.dashboard.vo.AcadSchVO;
import knou.lms.dashboard.vo.DashboardAdminVO;
import knou.lms.dashboard.vo.DashboardVO;
import knou.lms.dashboard.vo.MainCreCrsVO;
import knou.lms.dashboard.vo.SchVO;
import knou.lms.dashboard.web.view.DashboardViewModel;
import knou.lms.erp.service.ErpService;
import knou.lms.erp.util.ErpUtil;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.logintry.vo.LogUserLoginTryLogVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.log.userconn.vo.LogUserConnStateVO;
import knou.lms.login.service.LoginService;
import knou.lms.menu.vo.MenuVO;
import knou.lms.msg.service.MsgAlimService;
import knou.lms.msg.vo.MsgAlimVO;
import knou.lms.org.service.OrgCodeService;
import knou.lms.resh.vo.ReshVO;
import knou.lms.sch.service.PopupNoticeService;
import knou.lms.sch.vo.PopupNoticeVO;
import knou.lms.std.service.StdService;
import knou.lms.sys.service.SysJobSchService;
import knou.lms.sys.vo.SysJobSchVO;
import knou.lms.user.CurrentUser;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrDeptCdVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Controller
@RequestMapping(value = "/dashboard")
public class DashboardController extends ControllerBase {

    private static final Logger log = LoggerFactory.getLogger(DashboardController.class);
    @Resource(name = "bbsAtclService")
    private BbsAtclService bbsAtclService;

    @Resource(name = "msgAlimService")
    private MsgAlimService msgAlimService;

    @Resource(name = "dashboardService")
    private DashboardService dashboardService;

    @Resource(name = "crecrsService")
    private CrecrsService crecrsService;

    @Resource(name = "acadSchService")
    private AcadSchService acadSchService;

    @Resource(name = "schService")
    private SchService schService;

    @Resource(name = "orgOrgInfoService")
    private OrgOrgInfoService orgOrgInfoService;

    @Resource(name = "logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name = "termService")
    private TermService termService;

    @Resource(name = "sysJobSchService")
    private SysJobSchService sysJobSchService;
    
    @Resource(name = "usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;

    @Resource(name = "logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    @Resource(name = "usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;

    @Resource(name = "orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name = "stdService")
    private StdService stdService;

    @Resource(name = "popupNoticeService")
    private PopupNoticeService popupNoticeService;

    @Resource(name = "erpService")
    private ErpService erpService;

    @Resource(name = "dashboardFacadeService")
    private DashboardFacadeService dashboardFacadeService;
    
    @Resource(name = "loginService")
    private LoginService loginService;

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/main.do")
    public String main(HttpServletRequest request, HttpServletResponse response, ModelMap model, RedirectAttributes redirect) throws Exception {
    	
        String userType = SessionInfo.getAuthrtCd(request);
        String userId = SessionInfo.getUserId(request);
        String userAcntId = SessionInfo.getUserRprsId(request);
        String type = StringUtil.nvl(request.getParameter("type"));
        String chgOrgId = StringUtil.nvl(request.getParameter("orgId"));
        String chgUserId = StringUtil.nvl(request.getParameter("userId"));

        // 언어설정
        String language = StringUtil.nvl(request.getParameter("language"));
        if (!"".equals(language) && !"".equals(StringUtil.nvl(userId))) {
            LocaleUtil.setLocale(request, language);
            //SessionInfo.setSysLocalkey(request, language);

            //개인환경설정 저장
            UsrUserInfoVO userInfo = new UsrUserInfoVO();
            userInfo.setUserRprsId(userAcntId);
            userInfo.setUserId(userId);
            UsrUserInfoVO infoVO = usrUserInfoService.userSelect(userInfo); // ASIS viewUser
            String conf = StringUtil.nvl(infoVO.getUserConf());

            if (StringUtil.isNull(conf)) {
                conf = "{}";
            }

            JSONParser parser = new JSONParser();
            JSONObject jsonObject = (JSONObject) parser.parse(conf);
            jsonObject.put("lang", language);
            infoVO.setUserConf(jsonObject.toJSONString());

            usrUserInfoService.userStngModify(infoVO); // ASIS updateUserConf
        }

        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String returnUri = "";
        boolean reloginChk = true;


        if (menuType.contains("ADM")) {
            // 관리자
            returnUri = "/adminDashboard.do";
        } else if (menuType.contains("PROF")) {
            //교수
            returnUri = "/profDashboard.do";
        } else {
            String loginGbn = SessionInfo.getLoginGbn(request);
            String chk = CommConst.LOGINGBN_CHECK_YN;

            // 테스트용 예외처리(임시)_....
            if ("2023201349".equals(userId)) {
                reloginChk = false;
            }

            // SSO 일반로그인인 경우 학생은 다시 로그인하도록 전달
            if (!SessionInfo.isVirtualLogin(request)
                    && reloginChk && "Y".equals(chk) && "0".equals(loginGbn)) {
                Locale locale = LocaleUtil.getLocale(request);
                request.getSession().invalidate();
                request.getSession().setAttribute("relogin", "true");
                LocaleUtil.setLocale(request, locale.toString());
                return "redirect:/";
            } else {
                //학생
                returnUri = "/stuDashboard.do";
            }
        }

        // 기관 사용자 변경인 경우
        if ("change".equals(type) && !"".equals(StringUtil.nvl(userId))) {
            List<UsrUserInfoVO> userRltnList = SessionInfo.getUserRltnList(request);

            if (userRltnList != null && userRltnList.size() > 0) {
                for (UsrUserInfoVO user : userRltnList) {
                    if (chgUserId.equals(user.getUserId())) {
                        SessionInfo.setUserId(request, chgUserId);
                        SessionInfo.setUserNm(request, user.getUserNm());
                        SessionInfo.setOrgId(request, user.getOrgId());
                        SessionInfo.setAuthrtGrpcd(request, user.getAuthrtGrpcd());
                        SessionInfo.setAuthrtCd(request, user.getWwwAuthrtCd());
                        break;
                    }
                }
            }
        }

        return "redirect:/dashboard" + returnUri;
    }

    @GetMapping("/adminDashboardMain.do")
    public String main(HttpServletRequest request, HttpServletResponse response, DashboardAdminVO vo, ModelMap model) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if (!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        // 지원모드 정보 초기화
        SessionInfo.setAdminCrsInfo(request, null);

        // 현재 홈정보 저장
        SessionInfo.setCurUserHome(request, "/dashboard/adminDashboard.do");

        // 과목세션정보 초기화
        SessionInfo.removeCourseInfo(request);

        // 사용자 접속 장치 설정
        SessionInfo.setDeviceType(request);

        // 사용자 세션정보
        UsrUserInfoVO userInfo = new UsrUserInfoVO();
        String userId = SessionInfo.getUserId(request);
        userInfo.setUserId(userId);
        vo.setUserId(userId);

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);

        // 마지막 로그인정보 조회
        String lastLogin = SessionInfo.getLastLogin(request);
        
        if ("".equals(lastLogin)) {
        	
            LogUserLoginTryLogVO loginTryLogVO = new LogUserLoginTryLogVO();
            
            loginTryLogVO.setUserId(userId);

            EgovMap loginUser = loginService.userLatestLoginHstrySelect(userId);

            if (loginUser != null) {
                SessionInfo.setLastLogin(request, 
                		DateTimeUtil.getDateType(8, loginUser.get("lgnDttm") + ".") + " (" + loginUser.get("lgnIp")+")");
            }
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        // 학기목록 조회
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        ProcessResultVO<TermVO> termResult = dashboardService.listAdminTerm(termVO);

        TermVO curTermVO = null;
        String curTermCd = "";
        List<TermVO> termList = new ArrayList<>();

        if (termResult.getReturnList() != null && termResult.getReturnList().size() > 0) {
            termList = termResult.getReturnList();

            for (TermVO termVO2 : termList) {
                if ("Y".equals(termVO2.getNowSmstryn())) {
                    curTermCd = termVO2.getTermCd();
                    curTermVO = termVO2;
                }
            }

            if (vo.getTermCd() == null || "".equals(vo.getTermCd())) {
                if ("".equals(curTermCd)) {
                    vo.setTermCd(termList.get(0).getTermCd());
                    curTermVO = termList.get(0);
                } else {
                    vo.setTermCd(curTermCd);
                }
            }

            if ("".equals(curTermCd)) {
                SessionInfo.setCurTerm(request, vo.getTermCd());
            }
        }
        SessionInfo.setCurTerm(request, curTermCd);
        model.addAttribute("termList", termList);

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(orgId);
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));

        // 학기정보 세팅
        model.addAttribute("termVO", curTermVO);
        model.addAttribute("haksaTermList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        // 수업팀 여부
        model.addAttribute("classTeamYn", "20079".equals(SessionInfo.getUserDeptId(request)) ? "Y" : "N");
        // 사용자정보 팝업 URL
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        // 관리자메뉴
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "common/admin/admin_common";
    }

    /**
     * ***************************************************
     * 운영자 대시보드
     *
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception ****************************************************
     */
    @RequestMapping(value = "/adminDashboard.do")
    public String adminDashboard(HttpServletRequest request, HttpServletResponse response, DashboardAdminVO vo, ModelMap model) throws Exception {
        String menuTycd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if (!menuTycd.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        // 지원모드 정보 초기화
        SessionInfo.setAdminCrsInfo(request, null);

        // 현재 홈정보 저장
        SessionInfo.setCurUserHome(request, "/dashboard/adminDashboard.do");

        // 과목세션정보 초기화
        SessionInfo.removeCourseInfo(request);

        // 사용자 접속 장치 설정
        SessionInfo.setDeviceType(request);

        // 사용자 세션정보
        UsrUserInfoVO userInfo = new UsrUserInfoVO();
        String userRprsId = SessionInfo.getUserRprsId(request);
        userInfo.setUserRprsId(userRprsId);
        vo.setUserRprsId(userRprsId);

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);

        // 마지막 로그인정보 조회
        String lastLogin = SessionInfo.getLastLogin(request);
        if ("".equals(lastLogin)) {
            LogUserLoginTryLogVO loginTryLogVO = new LogUserLoginTryLogVO();
            loginTryLogVO.setUserRprsId(userRprsId);
            
            EgovMap loginUser = loginService.userLatestLoginHstrySelect(userRprsId);

            if (loginUser != null) {
                SessionInfo.setLastLogin(request, 
                		DateTimeUtil.getDateType(8, loginUser.get("loginTryDttm") + ".") + " (" + loginUser.get("connIp")+")");
            }
        }

        // 전체공지
        ProcessResultVO<BbsAtclVO> resultNoticeListVO = new ProcessResultVO<>();

        // 전체설문
        ProcessResultVO<ReshVO> resultReschListVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        try {
            // 전체공지사항
            BbsAtclVO allNoticeVO = new BbsAtclVO();

            if (SessionInfo.isKnou(request)) {
                model.addAttribute("sysNoticeId", CommConst.BBS_ID_SYSTEM_NOTICE);
                allNoticeVO.setBbsId(CommConst.BBS_ID_SYSTEM_NOTICE); // 전체공지ID : BBS_210512T1934377924186
            } else {
                model.addAttribute("sysNoticeId", orgId + "_NOTICE");
                allNoticeVO.setBbsId(orgId + "_NOTICE");
            }

            allNoticeVO.setListScale(5);
            model.addAttribute("sysNoticeList", bbsAtclService.listRecentNotice(allNoticeVO));

            // 전체설문
            ReshVO allReschVO = new ReshVO();
            allReschVO.setListScale(5);
            resultReschListVO = dashboardService.listSysReschRecent(allReschVO);
            resultReschListVO.setResult(1);
            model.addAttribute("sysReschList", resultReschListVO.getReturnList());

            // 학기목록 조회
            TermVO termVO = new TermVO();
            termVO.setOrgId(orgId);
            ProcessResultVO<TermVO> termResult = dashboardService.listAdminTerm(termVO);

            TermVO curTermVO = null;
            String curTermCd = "";
            List<TermVO> termList = new ArrayList<>();

            if (termResult.getReturnList() != null && termResult.getReturnList().size() > 0) {
                termList = termResult.getReturnList();

                for (TermVO termVO2 : termList) {
                    if ("Y".equals(termVO2.getNowSmstryn())) {
                        curTermCd = termVO2.getTermCd();
                        curTermVO = termVO2;
                    }
                }

                if (vo.getTermCd() == null || "".equals(vo.getTermCd())) {
                    if ("".equals(curTermCd)) {
                        vo.setTermCd(termList.get(0).getTermCd());
                        curTermVO = termList.get(0);
                    } else {
                        vo.setTermCd(curTermCd);
                    }
                }

                if ("".equals(curTermCd)) {
                    SessionInfo.setCurTerm(request, vo.getTermCd());
                }
            }
            SessionInfo.setCurTerm(request, curTermCd);
            model.addAttribute("termList", termList);

            // 부서정보
            UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
            usrDeptCdVO.setOrgId(orgId);
            model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));

            // 학기정보 세팅
            model.addAttribute("termVO", curTermVO);
            model.addAttribute("haksaTermList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
            model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));
        } catch (MediopiaDefineException e) {
            resultNoticeListVO.setResult(-1);
            resultNoticeListVO.setMessage(e.getMessage());
        } catch (Exception e) {
            resultNoticeListVO.setResult(-1);
            resultNoticeListVO.setMessage("에러가 발생했습니다!");
        }

        // 수업팀 여부
        model.addAttribute("classTeamYn", "20079".equals(SessionInfo.getUserDeptId(request)) ? "Y" : "N");
        // 사용자정보 팝업 URL
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        // 관리자메뉴
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authrtCd", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtGrpcd(request));

        return "dashboard/admin_dashboard";
    }

    /**
     * 교수대시보드조회
     */
    @RequestMapping(value = "/profDashboard.do")
    public String profDashboard(DashboardVO dashboardVO, @CurrentUser UserContext userCtx,
    		HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	// 현재 홈정보 저장
        SessionInfo.setCurUserHome(request, "/dashboard/profDashboard.do");

        // 	과목세션정보 초기화
        // 	SessionInfo.removeCourseInfo(request);  > 왜 초기화 했을까?

        //	사용자접속장치정보저장
        // 	SessionInfo.setDeviceType(request);

        // 	사용자접속경로저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);

        // 마지막 로그인정보 조회 > 왜 조회해서 다시 설정하는가?
        if ( ValidationUtils.isEmpty( userCtx.getLoginUser() ) ) {
        	
        	EgovMap loginUser = loginService.userLatestLoginHstrySelect(userCtx.getUserId());

            if (loginUser != null) {
                SessionInfo.setLastLogin(request, 
                		DateTimeUtil.getDateType(8, loginUser.get("loginTryDttm") + ".") + " (" + loginUser.get("connIp")+")");
            }
        }

        // 교수학기목록조회 // TODO: refactoring profSmstrList
        TermVO termVO = new TermVO(userCtx);
        ProcessResultVO<TermVO> termResult = dashboardService.profSmstrList(termVO);  // TODO: 완료 교수학기목록조회 profSmstrList

        String termCd = "";
        String curTermCd = "";

            List<TermVO> termList = new ArrayList<>();
            if (termResult.getReturnList() != null && termResult.getReturnList().size() > 0) {
                termList = termResult.getReturnList();

                for (TermVO termVO2 : termList) { // 루프는 왜 돌리나?
                    if ("Y".equals(termVO2.getNowSmstryn())) { /// 현재학기면 학기코드를 termCD, curTermCd에 배정
                        termCd = termVO2.getTermCd();
                        curTermCd = termVO2.getTermCd();
                    }
                }

                if (dashboardVO.getTermCd() == null || "".equals(dashboardVO.getTermCd())) {
                    if ("".equals(termCd)) {
                        dashboardVO.setTermCd(termList.get(0).getTermCd()); // null이면 리스트의 학기코드를 대시보드에 배정
                    } else {
                        dashboardVO.setTermCd(termCd); // 있으면
                    }
                }

                if ("".equals(termCd)) {
                    termCd = dashboardVO.getTermCd();
                }
            }
            SessionInfo.setCurTerm(request, termCd);
            model.addAttribute("termList", termList);

            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

            // 학기 현재 주차 조회
            TermVO termLessonVO = new TermVO();
            termLessonVO.setOrgId(userCtx.getOrgId());
            termLessonVO.setTermCd(dashboardVO.getTermCd());

            EgovMap dashboardCurrentWeek = dashboardService.dashboardCurrentWeek(termLessonVO);
            model.addAttribute("dashboardCurrentWeek", dashboardCurrentWeek);
            //termLessonVO = termService.selectCurTermLesson(termLessonVO);
            //model.addAttribute("termLessonVO", termLessonVO);

            // 학기과목 목록 (전체, 대학, 대학원 별)
            dashboardVO.setUserId(userCtx.getUserId());
            dashboardVO.setSearchFrom("UNI");

            ProcessResultVO<DashboardVO> resultVO2 = dashboardService.profCourseInfo(dashboardVO);
            dashboardVO.setSearchFrom(null);
            DashboardVO crsDashboardVO = (DashboardVO) resultVO2.getReturnVO();

            List<MainCreCrsVO> corsList = crsDashboardVO.getCreCrsList();
            model.addAttribute("corsList", corsList);

            Set<String> uniCdSet = new HashSet<>(); // 대학, 대학원 구분 코드
            Set<String> univGbnSet = new HashSet<>(); // 대학, 대학원 구분 코드
            List<String> crsListAll = new ArrayList<>();

            for (MainCreCrsVO creVO : corsList) {
                crsListAll.add(creVO.getCrsCreCd());

                uniCdSet.add(creVO.getUniCd());

                if (!"".equals(StringUtil.nvl(creVO.getUnivGbn()))) {
                    univGbnSet.add(creVO.getUnivGbn());
                }
            }

            // 	TODO: 전체공지사항조회 공통으로
            // 	전체공지사항
            BbsAtclVO allNoticeVO = new BbsAtclVO();

            if (!SessionInfo.isKnou(request) && !"".equals(StringUtil.nvl(SessionInfo.getOrgId(request)))) {
                allNoticeVO.setBbsId(SessionInfo.getOrgId(request) + "_NOTICE");
                model.addAttribute("sysNoticeId", SessionInfo.getOrgId(request) + "_NOTICE");
            } else {
                allNoticeVO.setBbsId(CommConst.BBS_ID_SYSTEM_NOTICE); // 전체공지ID : BBS_210512T1934377924186
                model.addAttribute("sysNoticeId", CommConst.BBS_ID_SYSTEM_NOTICE);
            }

            allNoticeVO.setListScale(5);
            allNoticeVO.setVwerId(userCtx.getUserRprsId()); // 본인이 읽은 게시글 체크
            TermVO tvo = new TermVO();
            if ("".equals(StringUtil.nvl(dashboardVO.getTermCd()))) {
                tvo.setOrgId(SessionInfo.getOrgId(request));
                tvo = termService.selectCurrentTerm(tvo);
            } else {
                tvo.setTermCd(dashboardVO.getTermCd());
                tvo = termService.select(tvo);
            }
            allNoticeVO.setHaksaYear(tvo.getHaksaYear());
            allNoticeVO.setHaksaTerm(tvo.getHaksaTerm());

            boolean isNonProfAdmin = userCtx.getAuthrtCd().contains("ADM")
                    && !(userCtx.getAuthrtCd().contains("PFS") || userCtx.getAuthrtCd().contains("TUT"));

            if (!isNonProfAdmin) {
                List<String> univGbnList = new ArrayList<>();
                univGbnList.add("ALL");

                if (univGbnSet.size() > 0) {
                    univGbnList.addAll(new ArrayList<>(univGbnSet));
                }

                allNoticeVO.setUnivGbnList(univGbnList.toArray(new String[univGbnList.size()]));
            }


            // 시스템공지사항?
            List<EgovMap> sysNoticeList = bbsAtclService.listRecentNotice(allNoticeVO);
            model.addAttribute("sysNoticeList", sysNoticeList);

            // 강의 공지사항
            BbsAtclVO cosNoticeVO = new BbsAtclVO();
            cosNoticeVO.setOrgId(userCtx.getOrgId());
            cosNoticeVO.setBbsId("NOTICE");
            cosNoticeVO.setListScale(5);
            cosNoticeVO.setDeclsList(crsListAll);
            cosNoticeVO.setVwerId(userCtx.getUserRprsId()); // 본인이 읽은 게시글 체크

            List<EgovMap> cosNoticeList = null;

            // 전체공지리스트(전체공지+강의공지)
            List<EgovMap> allNoticeList = Stream.concat(
                            (sysNoticeList != null ? sysNoticeList.stream() : Stream.empty()),
                            (cosNoticeList != null ? cosNoticeList.stream() : Stream.empty())
                    )
                    .sorted((m1, m2) -> {
                        String d1 = String.valueOf(m1.get("regDttm"));
                        String d2 = String.valueOf(m2.get("regDttm"));
                        // 내림차순
                        return d2.compareTo(d1);
                    })
                    .limit(5)
                    .collect(Collectors.toList());
            model.addAttribute("allNoticeList", allNoticeList);

            // 기관이 방송대인 경우만
            if (userCtx.getOrgId().equals(CommConst.KNOU_ORG_ID)) {
                // 모니터링 과목
                dashboardVO.setSearchKey("tchType");
                ProcessResultVO<DashboardVO> resultVO3 = dashboardService.profCourseInfo(dashboardVO);
                dashboardVO.setSearchKey(null);
                DashboardVO monCrsDashboardVO = (DashboardVO) resultVO3.getReturnVO();

                List<MainCreCrsVO> monCorsList = monCrsDashboardVO.getCreCrsList();
                model.addAttribute("monCorsList", monCorsList);

                // 	법정과목
                //	TODO: 용어변경 법정과목 - STTY_SBJCT, LEGAL은 합법적인의 의미
                dashboardVO.setSearchFrom("LEGAL");
                dashboardVO.setSearchType(CommConst.EXAM_STARE_SEARCH_YN);
                ProcessResultVO<DashboardVO> resultVO4 = dashboardService.stdCourseInfo(dashboardVO);
                dashboardVO.setSearchType(null);
                dashboardVO.setSearchFrom(null);
                DashboardVO legalCrsDashboardVO = (DashboardVO) resultVO4.getReturnVO();

                List<MainCreCrsVO> legalCorsList = legalCrsDashboardVO.getCreCrsList();
                String legalPopUseYn = "N";

                // 법정교육 미완료자 체크
                if (!"".equals(curTermCd) && termCd.equals(curTermCd)) {
                    if (legalCorsList != null && legalCorsList.size() > 0) {
                        for (MainCreCrsVO legalCorsVO : legalCorsList) {
                            Integer prgrRatio = legalCorsVO.getPrgrRatio();

                            if (prgrRatio == null || prgrRatio != 100) {
                                legalPopUseYn = "Y";
                                break;
                            }
                        }
                    }
                }

                model.addAttribute("legalPopUseYn", legalPopUseYn);
                model.addAttribute("legalCorsList", legalCorsList);
            }

            int stdCnt = 0;
            List<String> coList = new ArrayList<>();
            for (MainCreCrsVO coVO : corsList) {
                coList.add(coVO.getCrsCreCd());
                stdCnt += coVO.getStdCnt();
            }

            // 과목 접속자 목록 조회
            LogUserConnStateVO stateVO = new LogUserConnStateVO();
            stateVO.setConnGbn("learner");
            stateVO.setCorsList(coList);
            stateVO.setSearchTm(CommConst.CONN_USER_CHECK_TIME); // 검색시간(분)

            if (coList != null && coList.size() > 0) {
                int userConnCnt = logUserConnService.countLogUserConnState(stateVO);
                stateVO.setListScale(30);
                List<LogUserConnStateVO> userConnList = logUserConnService.listTopLogUserConnState(stateVO);

                CreCrsVO creCrsVO = new CreCrsVO();
                creCrsVO.setOrgId(userCtx.getOrgId());
                creCrsVO.setSqlForeach(coList.toArray(new String[coList.size()]));
                int userIdCnt = crecrsService.countStdUserId(creCrsVO);

                model.addAttribute("userConnCnt", userConnCnt);
                model.addAttribute("userConnList", userConnList);
                model.addAttribute("stdCnt", userIdCnt);
                model.addAttribute("coList", coList);
            } else {
                model.addAttribute("userConnList", null);
                model.addAttribute("stdCnt", 0);
            }

            // 업무일정 조회
            String examAbsentPeroidYn = "N";
            String scoreObjtPeriodYn = "N";
            String dsblReqPeriodYn = "N";

            SysJobSchVO sysJobSchVO;
            SysJobSchVO sysJobSchSearchVO = new SysJobSchVO();
            sysJobSchSearchVO.setOrgId(userCtx.getOrgId());
            sysJobSchSearchVO.setUseYn("Y");
            sysJobSchSearchVO.setTermCd(dashboardVO.getTermCd());

            // 1.결시원 승인기간
            sysJobSchSearchVO.setCalendarCtgr("00190901");
            sysJobSchVO = sysJobSchService.select(sysJobSchSearchVO);

            if (sysJobSchVO != null) {
                examAbsentPeroidYn = sysJobSchVO.getSysjobSchdlPeriodYn();
            }

            // 2.성적이의 신청 정정기간(학부)
            if (uniCdSet.contains("C")) {
                sysJobSchSearchVO.setCalendarCtgr("00210203");
                sysJobSchVO = sysJobSchService.select(sysJobSchSearchVO);

                if (sysJobSchVO != null) {
                    String jobSchPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();

                    if ("Y".equals(StringUtil.nvl(jobSchPeriodYn))) {
                        scoreObjtPeriodYn = "Y";
                    }
                }
            }

            // 2.성적이의 신청 정정기간(대학원)
            if (uniCdSet.contains("G") && !"Y".equals(scoreObjtPeriodYn)) {
                sysJobSchSearchVO.setCalendarCtgr("00210205");
                sysJobSchVO = sysJobSchService.select(sysJobSchSearchVO);

                if (sysJobSchVO != null) {
                    String jobSchPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();

                    if ("Y".equals(StringUtil.nvl(jobSchPeriodYn))) {
                        scoreObjtPeriodYn = "Y";
                    }
                }
            }

            // 3.장애인 시험지원 승인기간
            sysJobSchSearchVO.setCalendarCtgr("00190806");
            sysJobSchVO = sysJobSchService.select(sysJobSchSearchVO);

            if (sysJobSchVO != null) {
                dsblReqPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();
            }

            model.addAttribute("examAbsentPeroidYn", examAbsentPeroidYn);
            model.addAttribute("scoreObjtPeriodYn", scoreObjtPeriodYn);
            model.addAttribute("dsblReqPeriodYn", dsblReqPeriodYn);

            // 수업운영점수 정보
            UsrUserInfoVO userInfoVO = new UsrUserInfoVO();
            userInfoVO.setTermCd(termCd);
            userInfoVO.setUserId(userCtx.getUserRprsId());
            userInfoVO.setSqlForeach(coList.toArray(new String[coList.size()]));
            EgovMap lessonManageMap = dashboardService.selectLessonManageInfo(request, userInfoVO);
            model.addAttribute("lessonManageMap", lessonManageMap);

            // 미처리 일정 조회
            // DashboardVO uncheckScheduleVO = new DashboardVO();
            // uncheckScheduleVO.setOrgId(orgId);
            // uncheckScheduleVO.setUserId(userId);
            // uncheckScheduleVO.setTermCd(dashboardVO.getTermCd());
            // uncheckScheduleVO.setUniCd(dashboardVO.getUniCd());
            // List<EgovMap> listUncheckSchedule = dashboardService.listUncheckSchedule(uncheckScheduleVO);
            // model.addAttribute("listUncheckSchedule", listUncheckSchedule);

            // 대시보드 팝업 조회
            PopupNoticeVO popupNoticeVO = new PopupNoticeVO();
            popupNoticeVO = popupNoticeService.selectAcitvePop(request, popupNoticeVO);
            model.addAttribute("popupNoticeVO", popupNoticeVO);

        // 과목 목록 표시 타입
        String listType = request.getParameter("listType");
        if (!"card".equals(listType)) {
            listType = "list";
        }

        model.addAttribute("listType", listType);
        /*
        request.setAttribute("modChgYn", "N");
        Stack<Map<String, Object>> modChgSrcUserStack = SessionInfo.getModChgSrcUserStack( request);
        if (modChgSrcUserStack != null && !modChgSrcUserStack.isEmpty() && modChgSrcUserStack.size() > 0 ) {
            request.setAttribute("modChgYn", "Y");
        }
        */

        if ( userCtx.getAuthrtGrpcd() != null && userCtx.getAuthrtGrpcd().startsWith("|")) {
        	userCtx.setAuthrtGrpcd(userCtx.getAuthrtGrpcd().substring(1));
        }

        String orgId = userCtx.getOrgId(); // ORG_ID, 파라메터로 처리 검토...

        LocalDate today = LocalDate.now();
        model.addAttribute("today", 	today.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
        model.addAttribute("isKnou", 	SessionInfo.isKnou(request));
        model.addAttribute("orgId", 	orgId);
        model.addAttribute("authrtGrpcd", 	userCtx.getAuthrtGrpcd());
        model.addAttribute("userId", 	SessionInfo.getUserId(request));

        // 암호화파라메터에 설정
        addEncParam("orgId", orgId);

        return "dashboard/main_prof_card";
    }

    /**
     * ***************************************************
     * 학생 대시보드
     * TODO: TOBE 개발완료시 삭제예정
     */
    //////////////////////////////////////////////////////////////////////////////// 서비스하지 않는 Request입니다. 단 ASIS 소스 분석을 위해서 남겨둡니다.
    //////////////////////////////////////////////////////////////////////////////// 대시보드개발이 완료되면 삭제, TOBE에서는 사용하지 않습니다. written by jinkoon 260313
    @RequestMapping(value = "/stuDashboard_bak.do")
    public String stuDashboardBak(HttpServletRequest request, HttpServletResponse response, DashboardVO dashboardVO, ModelMap model) throws Exception {
        boolean reloginChk = true;
        String loginGbn = SessionInfo.getLoginGbn(request);
        String chk = CommConst.LOGINGBN_CHECK_YN;



        // 	사용자 세션정보 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        //	********************************************************/
        //	대표아이디를 userId에 설정하면 안됩니다.
        //
        //	설정한 이유가 있으며 알려주세요. by jinkoon 20260130
        //	********************************************************/
        UsrUserInfoVO userInfo = new UsrUserInfoVO();
        //String userId = SessionInfo.getUserRprsId(request);
        //String userId = SessionInfo.getUserId(request);
        userInfo.setUserId(SessionInfo.getUserId(request));


        // SSO 일반로그인인 경우 학생은 다시 로그인하도록 전달
        if (!SessionInfo.isVirtualLogin(request)
                && reloginChk && "Y".equals(chk) && "0".equals(loginGbn)) {
            Locale locale = LocaleUtil.getLocale(request);
            request.getSession().invalidate();
            request.getSession().setAttribute("relogin", "true");
            LocaleUtil.setLocale(request, locale.toString());
            return "redirect:/";
        }

        // 현재 홈정보 저장
        SessionInfo.setCurUserHome(request, "/dashboard/stuDashboard.do");
        // 과목세션정보 초기화
        SessionInfo.removeCourseInfo(request);
        //사용자 접속 장치 설정
        SessionInfo.setDeviceType(request);

        String orgId = SessionInfo.getOrgId(request);

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_HOME);
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, null, CommConst.ACTN_HSTY_COURSE_HOME, "강의실홈 입장");

        // 마지막 로그인정보 조회 >>>>> 조회 해서 무엇을 하는가?
        String lastLogin = SessionInfo.getLastLogin(request); 
        if ("".equals(lastLogin)) {
            LogUserLoginTryLogVO loginTryLogVO = new LogUserLoginTryLogVO();
            loginTryLogVO.setUserId(userInfo.getUserId());
            
            EgovMap loginUser = loginService.userLatestLoginHstrySelect(userInfo.getUserId());

            if (loginUser != null) {
                SessionInfo.setLastLogin(request, 
                		DateTimeUtil.getDateType(8, loginUser.get("loginTryDttm") + ".") + " (" + loginUser.get("connIp")+")");
            }
        }

        ProcessResultVO<BbsAtclVO> resultNoticeListVO = new ProcessResultVO<>();

        try {
            // 학기목록 조회
            TermVO termVO = new TermVO();
            termVO.setUserId(userInfo.getUserId());
            ProcessResultVO<TermVO> termResult = dashboardService.listStdTerm(termVO);
            String termCd = "";
            String curTermCd = "";
            TermVO curTermVO = null;

            List<TermVO> termList = new ArrayList<>();
            if (termResult.getReturnList() != null && termResult.getReturnList().size() > 0) {
                termList = termResult.getReturnList();

                for (TermVO termVO2 : termList) {
                    if ("Y".equals(termVO2.getNowSmstryn())) {
                        termCd = termVO2.getTermCd();
                        curTermVO = termVO2;
                        curTermCd = termVO2.getTermCd();
                    }
                }

                if (dashboardVO.getTermCd() == null || "".equals(dashboardVO.getTermCd())) {
                    if ("".equals(termCd)) {
                        dashboardVO.setTermCd(termList.get(0).getTermCd());
                        curTermVO = termList.get(0);
                    } else {
                        dashboardVO.setTermCd(termCd);
                    }
                }

                if ("".equals(termCd)) {
                    termCd = dashboardVO.getTermCd();
                }
            }

            if (curTermVO != null) {
                dashboardVO.setHaksaYear(curTermVO.getHaksaYear());
                dashboardVO.setHaksaTerm(curTermVO.getHaksaTerm());

                if (SessionInfo.isKnou(request)) {
                    // 강의평가 URL 세팅
                    SessionInfo.setLectEvalUrl(request, ErpUtil.getStuLectEvalUrl(curTermVO.getHaksaYear(), curTermVO.getHaksaTerm(), SessionInfo.getUserId(request)));
                }
            }

            SessionInfo.setCurTerm(request, termCd);
            model.addAttribute("termList", termList);

            // 학기 현재 주차 조회
            TermVO termLessonVO = new TermVO();
            termLessonVO.setOrgId(orgId);
            termLessonVO.setTermCd(dashboardVO.getTermCd());
            EgovMap dashboardCurrentWeek = dashboardService.dashboardCurrentWeek(termLessonVO);
            model.addAttribute("dashboardCurrentWeek", dashboardCurrentWeek);
            // termLessonVO = termService.selectCurTermLesson(termLessonVO);
            // model.addAttribute("termLessonVO", termLessonVO);

            // 강의평가 팝업 사용 여부
            String lectureEvalPopUseYn = "Y";

            // 학기과목 목록
            dashboardVO.setUserId(userInfo.getUserId());
            dashboardVO.setSearchFrom("UNI");
            dashboardVO.setSearchType(CommConst.EXAM_STARE_SEARCH_YN);
            ProcessResultVO<DashboardVO> resultVO2 = dashboardService.stdCourseInfo(dashboardVO);
            dashboardVO.setSearchType(null);
            dashboardVO.setSearchFrom(null);
            DashboardVO crsDashboardVO = (DashboardVO) resultVO2.getReturnVO();

            List<MainCreCrsVO> corsList = crsDashboardVO.getCreCrsList();
            for (MainCreCrsVO creCrsVO : corsList) {
                // TODO 임시설정, 페루학생 [외국인을위한기초한국어1] 수강생인 경우 예외처리
                if ("CHY142".equals(creCrsVO.getCrsCd())) {
                    lectureEvalPopUseYn = "N";
                }

                if (curTermVO != null) {
                    String sSmt = curTermVO.getHaksaTerm().length() < 2 ? curTermVO.getHaksaTerm() + "0" : curTermVO.getHaksaTerm();
                    String sCuriCls = creCrsVO.getDeclsNo().length() < 2 ? "0" + creCrsVO.getDeclsNo() : creCrsVO.getDeclsNo();
                    String plnParam = "{\"sYear\":\"" + curTermVO.getHaksaYear() + "\",\"sSmt\":\"" + sSmt + "\",\"sCuriNum\":\"" + creCrsVO.getCrsCd() + "\",\"sCuriCls\":\"" + sCuriCls + "\"}";
                    String lsnPlanUrl = CommConst.LSNPLAN_POP_URL_STD + new String((Base64.getEncoder()).encode(plnParam.getBytes()));
                    creCrsVO.setLsnPlanUrl(lsnPlanUrl);
                }

                // 언어가 한국어가 아니면 교수명,조교명 영문으로 표시
                if (!"ko".equalsIgnoreCase(SessionInfo.getLocaleKey(request))) {
                    creCrsVO.setProfNm(creCrsVO.getProfNmEng());
                    creCrsVO.setAssistNmEng(creCrsVO.getAssistNmEng());
                }

            }
            model.addAttribute("corsList", corsList);

            // 학점교류 과목
            model.addAttribute("hpIntchList", crsDashboardVO.getHpIntchList());

            Set<String> uniCdSet = new HashSet<>(); // 대학, 대학원 구분 코드
            Set<String> univGbnSet = new HashSet<>(); // 대학, 대학원 구분 코드
            List<String> crsListAll = new ArrayList<>();

            if (corsList != null) {
                for (MainCreCrsVO creVO : corsList) {
                    crsListAll.add(creVO.getCrsCreCd());

                    uniCdSet.add(creVO.getUniCd());

                    if (!"".equals(StringUtil.nvl(creVO.getUnivGbn()))) {
                        univGbnSet.add(creVO.getUnivGbn());
                    }
                }
            }

            // 전체공지사항
            BbsAtclVO allNoticeVO = new BbsAtclVO();

            if (!SessionInfo.isKnou(request) && !"".equals(StringUtil.nvl(SessionInfo.getOrgId(request)))) {
                allNoticeVO.setBbsId(SessionInfo.getOrgId(request) + "_NOTICE");
                model.addAttribute("sysNoticeId", SessionInfo.getOrgId(request) + "_NOTICE");
            } else {
                allNoticeVO.setBbsId(CommConst.BBS_ID_SYSTEM_NOTICE); // 전체공지ID : BBS_210512T1934377924186
                model.addAttribute("sysNoticeId", CommConst.BBS_ID_SYSTEM_NOTICE);
            }

            allNoticeVO.setListScale(5);
            allNoticeVO.setVwerId(userInfo.getUserId()); // 본인이 읽은 게시글 체크
            TermVO tvo = new TermVO();
            if ("".equals(StringUtil.nvl(dashboardVO.getTermCd()))) {
                tvo.setOrgId(SessionInfo.getOrgId(request));
                tvo = termService.selectCurrentTerm(tvo);
            } else {
                tvo.setTermCd(dashboardVO.getTermCd());
                tvo = termService.select(tvo);
            }
            allNoticeVO.setHaksaYear(tvo.getHaksaYear());
            allNoticeVO.setHaksaTerm(tvo.getHaksaTerm());
            UsrUserInfoVO uvo = new UsrUserInfoVO();
            uvo.setUserId(userInfo.getUserId());
            uvo = usrUserInfoService.userSelect(uvo);

            List<String> univGbnList = new ArrayList<>();
            univGbnList.add("ALL");

            if (univGbnSet.size() > 0) {
                univGbnList.addAll(new ArrayList<>(univGbnSet));
            }

            allNoticeVO.setUnivGbnList(univGbnList.toArray(new String[univGbnList.size()]));

            model.addAttribute("sysNoticeList", bbsAtclService.listRecentNotice(allNoticeVO));
            // 강의 공지사항
            BbsAtclVO cosNoticeVO = new BbsAtclVO();
            cosNoticeVO.setOrgId(userInfo.getOrgId());
            cosNoticeVO.setBbsId("NOTICE");
            cosNoticeVO.setUserId(userInfo.getUserId());
            cosNoticeVO.setListScale(5);
            cosNoticeVO.setDeclsList(crsListAll);
            cosNoticeVO.setVwerId(userInfo.getUserId()); // 본인이 읽은 게시글 체크
            cosNoticeVO.setLearnerViewModeYn("Y");

            if (crsListAll != null && crsListAll.size() > 0) {
                List<EgovMap> cosNoticeList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
                model.addAttribute("cosNoticeList", cosNoticeList);

                // 강의 QNA
                cosNoticeVO.setBbsId("QNA");
                List<EgovMap> cosQnaList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
                model.addAttribute("cosQnaList", cosQnaList);

                // QNA 미답변수 조회
                EgovMap qnaNoAnsInfo = bbsAtclService.selectNoAnswerAtclStatus(cosNoticeVO);
                model.addAttribute("qnaNoAnsInfo", qnaNoAnsInfo);

                // 1:1 상담
                cosNoticeVO.setBbsId("SECRET");
                List<EgovMap> cosSecretList = bbsAtclService.listRecentBbsAtcl(cosNoticeVO);
                model.addAttribute("cosSecretList", cosSecretList);

                // 1:1상담 미답변수 조회
                EgovMap secretNoAnsInfo = bbsAtclService.selectNoAnswerAtclStatus(cosNoticeVO);
                model.addAttribute("secretNoAnsInfo", secretNoAnsInfo);

                // 대시보드 현황 (학생)
                DefaultVO dashboardStatVO = new DefaultVO();
                dashboardStatVO.setUserId(userInfo.getUserId());
                dashboardStatVO.setSqlForeach(crsListAll.toArray(new String[crsListAll.size()]));
                EgovMap dashboardStat = dashboardService.dashboardStatStu(dashboardStatVO);
                model.addAttribute("dashboardStat", dashboardStat);
            }

            // 학생 미완료 강의 조회
            DefaultVO defaultVO = new DefaultVO();
            defaultVO.setOrgId(orgId);
            defaultVO.setUserId(userInfo.getUserId());
            defaultVO.setTermCd(dashboardVO.getTermCd());
            List<EgovMap> listStdUncompletedLesson = dashboardService.listStdUncompletedLesson(defaultVO);
            model.addAttribute("listStdUncompletedLesson", listStdUncompletedLesson);

            // 모니터링 과목 목록
            model.addAttribute("monCorsList", null);

            // 한사대만 법정과목 목록
            if (SessionInfo.isKnou(request)) {
                // 법정 과목 목록
                dashboardVO.setSearchFrom("LEGAL");
                dashboardVO.setUserId(userInfo.getUserId());
                dashboardVO.setSearchType(CommConst.EXAM_STARE_SEARCH_YN);
                ProcessResultVO<DashboardVO> resultVO3 = dashboardService.stdCourseInfo(dashboardVO);
                dashboardVO.setSearchType(null);
                dashboardVO.setSearchFrom(null);
                DashboardVO legalCrsDashboardVO = (DashboardVO) resultVO3.getReturnVO();

                List<MainCreCrsVO> legalCorsList = legalCrsDashboardVO.getCreCrsList();
                String legalPopUseYn = "N";

                // 법정교육 미완료자 체크
                if (!"".equals(curTermCd) && termCd.equals(curTermCd)) {
                    if (legalCorsList != null && legalCorsList.size() > 0) {
                        for (MainCreCrsVO legalCorsVO : legalCorsList) {
                            Integer prgrRatio = legalCorsVO.getPrgrRatio();

                            if (prgrRatio == null || prgrRatio != 100) {
                                legalPopUseYn = "Y";
                                break;
                            }
                        }
                    }
                }

                model.addAttribute("legalPopUseYn", legalPopUseYn);
                model.addAttribute("legalCorsList", legalCorsList);
            } else {
                model.addAttribute("legalCorsList", null);
            }

            int stdCnt = 0;
            List<String> coList = new ArrayList<>();
            for (MainCreCrsVO coVO : corsList) {
                coList.add(coVO.getCrsCreCd());
                stdCnt += coVO.getStdCnt();
            }

            // 과목 접속자 목록 조회
            LogUserConnStateVO stateVO = new LogUserConnStateVO();
            stateVO.setConnGbn("learner");
            stateVO.setCorsList(coList);
            stateVO.setSearchTm(CommConst.CONN_USER_CHECK_TIME); // 검색시간(분)

            if (coList != null && coList.size() > 0) {
                int userConnCnt = logUserConnService.countLogUserConnState(stateVO);
                stateVO.setListScale(30);
                List<LogUserConnStateVO> userConnList = logUserConnService.listTopLogUserConnState(stateVO);

                CreCrsVO creCrsVO = new CreCrsVO();
                creCrsVO.setOrgId(orgId);
                creCrsVO.setSqlForeach(coList.toArray(new String[coList.size()]));
                int userIdCnt = crecrsService.countStdUserId(creCrsVO);

                model.addAttribute("userConnCnt", userConnCnt);
                model.addAttribute("userConnList", userConnList);
                model.addAttribute("stdCnt", userIdCnt);
                model.addAttribute("coList", coList);
                model.addAttribute("coListStr", String.join(",", coList));
            } else {
                model.addAttribute("userConnList", null);
                model.addAttribute("stdCnt", 0);
            }
            model.addAttribute("dashboardVO", dashboardVO);

            // 업무일정 조회
            String examAbsentPeroidYn = "N";
            String scoreObjtPeriodYn = "N";
            String dsblReqPeriodYn = "N";

            SysJobSchVO sysJobSchVO;
            SysJobSchVO sysJobSchSearchVO = new SysJobSchVO();
            sysJobSchSearchVO.setOrgId(orgId);
            sysJobSchSearchVO.setUseYn("Y");
            sysJobSchSearchVO.setTermCd(dashboardVO.getTermCd());

            // 1.결시원 신청기간 (중간)
            sysJobSchSearchVO.setCalendarCtgr("00190904");
            sysJobSchVO = sysJobSchService.select(sysJobSchSearchVO);

            if (sysJobSchVO != null) {
                examAbsentPeroidYn = sysJobSchVO.getSysjobSchdlPeriodYn();
            }

            // 1.결시원 신청기간 (기말)
            if ("N".equals(examAbsentPeroidYn)) {
                sysJobSchSearchVO.setCalendarCtgr("00190905");
                sysJobSchVO = sysJobSchService.select(sysJobSchSearchVO);

                if (sysJobSchVO != null) {
                    examAbsentPeroidYn = sysJobSchVO.getSysjobSchdlPeriodYn();
                }
            }

            // 2.성적이의 신청기간(학부)
            if (uniCdSet.contains("C")) {
                sysJobSchSearchVO.setCalendarCtgr("00210202");
                sysJobSchVO = sysJobSchService.select(sysJobSchSearchVO);

                if (sysJobSchVO != null) {
                    String jobSchPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();

                    if ("Y".equals(StringUtil.nvl(jobSchPeriodYn))) {
                        scoreObjtPeriodYn = "Y";
                    }
                }
            }

            // 2.성적이의 신청기간(대학원)
            if (uniCdSet.contains("G") && !"Y".equals(scoreObjtPeriodYn)) {
                sysJobSchSearchVO.setCalendarCtgr("00210204");
                sysJobSchVO = sysJobSchService.select(sysJobSchSearchVO);

                if (sysJobSchVO != null) {
                    String jobSchPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();

                    if ("Y".equals(StringUtil.nvl(jobSchPeriodYn))) {
                        scoreObjtPeriodYn = "Y";
                    }
                }
            }

            // 3.장애인 시험지원 신청기간
            sysJobSchSearchVO.setCalendarCtgr("00190805");
            sysJobSchVO = sysJobSchService.select(sysJobSchSearchVO);

            if (sysJobSchVO != null) {
                dsblReqPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();
            }

            // 3.장애인 시험지원요청 확인기간
            if (!"Y".equals(StringUtil.nvl(dsblReqPeriodYn))) {
                sysJobSchSearchVO.setCalendarCtgr("00190809");
                sysJobSchVO = sysJobSchService.select(sysJobSchSearchVO);

                if (sysJobSchVO != null) {
                    dsblReqPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();
                }
            }

            // 장애 여부
            UsrUserInfoVO uuivo = new UsrUserInfoVO();
            uuivo.setUserId(userInfo.getUserId());
            uuivo = usrUserInfoService.userSelect(uuivo);

            // 대시보드 팝업 조회
            PopupNoticeVO popupNoticeVO = new PopupNoticeVO();
            popupNoticeVO = popupNoticeService.selectAcitvePop(request, popupNoticeVO);

            if (popupNoticeVO != null) {
                String popTypeCd = popupNoticeVO.getPopupNtcId();

                // 강의평가 팝업 관련 설정
                if ("EVAL".equals(popTypeCd)) {
                    if (SessionInfo.isKnou(request) && "Y".equals(lectureEvalPopUseYn)) {
                        model.addAttribute("lectEvalViewYn", "Y");
                        model.addAttribute("lectEvalUrl", SessionInfo.getLectEvalUrl(request));
                        model.addAttribute("popupNoticeVO", popupNoticeVO);
                    }
                } else {
                    model.addAttribute("popupNoticeVO", popupNoticeVO);
                }
            }

            model.addAttribute("examAbsentPeroidYn", examAbsentPeroidYn);
            model.addAttribute("scoreObjtPeriodYn", scoreObjtPeriodYn);
            model.addAttribute("dsblReqPeriodYn", dsblReqPeriodYn);
            model.addAttribute("disablilityYn", StringUtil.nvl(uuivo.getDisablilityYn(), "N"));
            model.addAttribute("uniCd", StringUtil.nvl(uvo.getUniCd()));

        } catch (MediopiaDefineException e) {
            resultNoticeListVO.setResult(-1);
            resultNoticeListVO.setMessage(e.getMessage());
        } catch (Exception e) {
            resultNoticeListVO.setResult(-1);
            resultNoticeListVO.setMessage("에러가 발생했습니다!");
        }

        // 과목 목록 표시 타입
        String listType = request.getParameter("listType");
        if (!"card".equals(listType)) {
            listType = "list";
        }

        model.addAttribute("listType", listType);
        /*
        request.setAttribute("modChgYn", "N");
        Stack<Map<String, Object>> modChgSrcUserStack = SessionInfo.getModChgSrcUserStack( request);
        if(modChgSrcUserStack != null && !modChgSrcUserStack.isEmpty() && modChgSrcUserStack.size() > 0 ) {
            request.setAttribute("modChgYn", "Y");
        }
        */

        // 언어연동 API 처리
        if (!SessionInfo.isKnou(request) || "Y".equals(StringUtil.nvl((String) SessionUtil.getSessionValue(request, "CHECK_LANG")))) {
            model.addAttribute("langApiCheck", "N");
        } else {
            model.addAttribute("langApiCheck", "Y");
        }
        String langApiHeader = SecureUtil.encodeAesCbc(DateTimeUtil.getCurrentString() + userInfo.getUserId(), null, CommConst.ERP_API_KEY);
        String langApiUrl = CommConst.ERP_API_URL + userInfo.getUserId() + "/language";
        model.addAttribute("langApiUrl", langApiUrl);
        model.addAttribute("langApiHeader", langApiHeader);
        SessionUtil.setSessionValue(request, "CHECK_LANG", "Y");

        LocalDate today = LocalDate.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMM")) + "01");
        model.addAttribute("isKnou", SessionInfo.isKnou(request));

        String url = "dashboard/stu_dashboard";

        return url;
    }

    /*****************************************************
     * 일정관리 목록 캘린더 페이지
     * @param SchVO
     * @return "dashboard/sch_calendar"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/schCalendar.do")
    public String schCalendar(SchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        ProcessResultVO<SchVO> resultVO = new ProcessResultVO<SchVO>();
        vo.setUserId(userId);
        if (!"".equals(menuType)) {
            String[] userTypes = "|".equals(menuType.substring(0, 1)) ? menuType.substring(1).split("\\|") : menuType.split("\\|");
            vo.setUserTypes(userTypes);
        }
        resultVO = schService.listCalendar(vo);

        request.setAttribute("calendarList", resultVO.getReturnList());
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("userId", userId);

        return "dashboard/sch_calendar";
    }

    /*****************************************************
     * 일정 조회 (리스트형)
     * @param SchVO
     * @return ProcessResultVO<SchVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/schCalendarList.do")
    @ResponseBody
    public ProcessResultVO<SchVO> schCalendarList(SchVO vo, ModelMap map, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        // String[] userTypes = menuType.split("\\|");
        String classUserType = menuType.contains("USR") ? "USR" : "PROF";
        String searchMenu = menuType.contains("USR") ? "USR" : "PROF";

        ProcessResultVO<SchVO> resultVO = new ProcessResultVO<SchVO>();
        try {

            String creCrsListString = request.getParameter("coList");
            creCrsListString = creCrsListString.replace("[", "").replace("]", "");
            String[] creCrsListArray = creCrsListString.split(",");
            vo.setSqlForeach(creCrsListArray);

            /*
            String creCrsListString = request.getParameter("coList");
            creCrsListString = creCrsListString.replace("[", "").replace("]", "");
            String[] creCrsListArray = creCrsListString.split(",");
            List<String> creCrsList = Arrays.asList(creCrsListArray);
            vo.setCreCrsList(creCrsList);
            */

            // vo.setUserTypes(userTypes);
            vo.setClassUserTypeGubun(classUserType);
            vo.setSearchMenu(searchMenu);
            vo.setUserId(StringUtil.nvl(userId, ""));
            vo.setOrgId(orgId);
            vo.setPagingYn("N"); // 페이지 처리 안함
            resultVO = schService.listSchedule(vo);

            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    @RequestMapping(value = "/stuSchCalendarList.do")
    @ResponseBody
    public ProcessResultVO<SchVO> stuSchCalendarList(SchVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        ProcessResultVO<SchVO> resultVO = new ProcessResultVO<>();

        try {
            String creCrsListString = StringUtil.nvl(request.getParameter("coList"));
            String[] creCrsListArray = creCrsListString.split(",");

            if (creCrsListArray.length > 0) {
                vo.setSqlForeach(creCrsListArray);
                vo.setUserId(StringUtil.nvl(userId, ""));
                vo.setOrgId(orgId);
                vo.setPagingYn("N"); // 페이지 처리 안함
                /* resultVO = schService.stuListSchedule(vo); */ // 임시로 막아둠
            }
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }

        return resultVO;
    }

    @RequestMapping(value = "/profSchCalendarList.do")
    @ResponseBody
    public ProcessResultVO<SchVO> profSchCalendarList(SchVO vo, ModelMap map, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        // String[] userTypes = menuType.split("\\|");
        String classUserType = menuType.contains("USR") ? "USR" : "PROF";
        String searchMenu = menuType.contains("USR") ? "USR" : "PROF";

        ProcessResultVO<SchVO> resultVO = new ProcessResultVO<SchVO>();
        try {

            String creCrsListString = request.getParameter("coList");
            creCrsListString = creCrsListString.replace("[", "").replace("]", "");
            String[] creCrsListArray = creCrsListString.split(",");
            vo.setSqlForeach(creCrsListArray);

            /*
            String creCrsListString = request.getParameter("coList");
            creCrsListString = creCrsListString.replace("[", "").replace("]", "");
            String[] creCrsListArray = creCrsListString.split(",");
            List<String> creCrsList = Arrays.asList(creCrsListArray);
            vo.setCreCrsList(creCrsList);
            */

            // vo.setUserTypes(userTypes);
            vo.setClassUserTypeGubun(classUserType);
            vo.setSearchMenu(searchMenu);
            vo.setUserId(StringUtil.nvl(userId, ""));
            vo.setOrgId(orgId);
            vo.setPagingYn("N"); // 페이지 처리 안함
            resultVO = schService.profListSchedule(vo);

            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    @RequestMapping(value = "/acadSchList.do")
    @ResponseBody
    public ProcessResultVO<SchVO> acadSchList(SchVO vo, ModelMap map, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        ProcessResultVO<SchVO> resultVO = new ProcessResultVO<SchVO>();
        try {
            vo.setUserId(StringUtil.nvl(userId, ""));
            vo.setOrgId(orgId);
            resultVO = schService.listAcadSch(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    /*****************************************************
     * 특정 사용자 과목 목록 조회
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listUserCreCrs.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listUserCreCrs(CreCrsVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();

        try {
            vo.setUserId(StringUtil.nvl(userId, ""));
            resultVO = crecrsService.listUserCreCrsPaging(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }

        return resultVO;
    }

    /*****************************************************
     * 일정 등록 팝업
     * @param SchVO
     * @return "dashboard/popup/sch_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/writeSchPop.do")
    public String writeSchPop(SchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);

        OrgOrgInfoVO orgOrgInfoVO = new OrgOrgInfoVO();

        AcadSchVO acadSchVO = new AcadSchVO();
        acadSchVO.setSchStartDt(StringUtil.nvl(vo.getStart()));
        acadSchVO.setSchEndDt(StringUtil.nvl(vo.getEnd()));

        request.setAttribute("vo", acadSchVO);
        request.setAttribute("termVO", termVO);
        request.setAttribute("orgInfoList", orgOrgInfoService.list(orgOrgInfoVO));
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("userId", userId);

        return "dashboard/popup/sch_write";
    }

    /*****************************************************
     * 일정 수정 팝업
     * @param AcadSchVO
     * @return "dashboard/popup/sch_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editSchPop.do")
    public String editSchPop(AcadSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);

        OrgOrgInfoVO orgOrgInfoVO = new OrgOrgInfoVO();

        vo = acadSchService.select(vo);

        request.setAttribute("vo", vo);
        request.setAttribute("termVO", termVO);
        request.setAttribute("orgInfoList", orgOrgInfoService.list(orgOrgInfoVO));
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("userId", userId);

        return "dashboard/popup/sch_write";
    }

    /*****************************************************
     * 일정 등록
     * @param AcadSchVO
     * @return ProcessResultVO<AcadSchVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/writeSch.do")
    @ResponseBody
    public ProcessResultVO<AcadSchVO> writeSch(AcadSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<AcadSchVO> resultVO = new ProcessResultVO<AcadSchVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            String acadSchSn = IdGenerator.getNewId("ACAD");
            vo.setAcadSchSn(acadSchSn);
            acadSchService.insert(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }

        return resultVO;
    }

    /*****************************************************
     * 일정 수정
     * @param AcadSchVO
     * @return ProcessResultVO<AcadSchVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editSch.do")
    @ResponseBody
    public ProcessResultVO<AcadSchVO> editSch(AcadSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<AcadSchVO> resultVO = new ProcessResultVO<AcadSchVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        try {
            vo.setOrgId(orgId);
            vo.setMdfrId(userId);
            acadSchService.update(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    /*****************************************************
     * 일정 삭제
     * @param AcadSchVO
     * @return ProcessResultVO<AcadSchVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/delSch.do")
    @ResponseBody
    public ProcessResultVO<AcadSchVO> delSch(AcadSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<AcadSchVO> resultVO = new ProcessResultVO<AcadSchVO>();
        try {
            acadSchService.delete(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    /*****************************************************
     * 관리자 메인 > 과목별 학습현황
     * @param vo
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listLessonStatusByCrs.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listLessonStatusByCrs(DashboardVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);
            List<EgovMap> list = dashboardService.listLessonStatusByCrs(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 관리자 메인 > 과목별 학습현황 엑셀
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/downExcelLessonStatusByCrs.do")
    public String downExcelLessonStatusByCrs(DashboardVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);

        vo.setOrgId(orgId);

        // 조회조건
        String haksaTermNm = request.getParameter("haksaTermNm");
        String uniNm = StringUtil.nvl(request.getParameter("uniNm"));
        String deptNm = StringUtil.nvl(request.getParameter("deptNm"));

        // 조회조건
        String[] searchValues = {
                getMessage("common.year") + " : " + vo.getHaksaYear() // 학년도
                , getMessage("common.term") + " : " + haksaTermNm // 학기
                , getMessage("common.type") + " : " + uniNm // 구분
                , getMessage("common.dept_name") + " : " + deptNm // 학과
                , getMessage("common.search.condition") + " : " + vo.getSearchValue() // 검색조건
        };
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        List<EgovMap> list = dashboardService.listLessonStatusByCrsExcel(request, vo);
        List<DashboardVO> listExc = new ArrayList<>();

        for (EgovMap egovMap : list) {
            DashboardVO listInfo = new DashboardVO();
            for (Field field : DashboardVO.class.getDeclaredFields()) {
                String fieldName = field.getName();
                Object value = egovMap.get(fieldName);

                MapToVoUtil.setFieldValueWithConversion(listInfo, field, value);

            }
            listExc.add(listInfo);
        }

        String title = getMessage("dashboard.label.lesson.status.crs"); // 과목별 학습현황

        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", listExc);

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 관리자 메인 > 학생별 학습현황
     * @param vo
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listLessonStatusByStd.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listLessonStatusByStd(DashboardVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);
            List<EgovMap> list = dashboardService.listLessonStatusByStd(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 관리자 메인 > 학생별 학습현황 엑셀
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/downExcelLessonStatusByStd.do")
    public String downExcelLessonStatusByStd(DashboardVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);

        vo.setOrgId(orgId);

        // 조회조건
        String haksaTermNm = request.getParameter("haksaTermNm");
        String uniNm = StringUtil.nvl(request.getParameter("uniNm"));
        String deptNm = StringUtil.nvl(request.getParameter("deptNm"));
        String crsCreNm = StringUtil.nvl(request.getParameter("crsCreNm"));

        // 조회조건
        String[] searchValues = {
                getMessage("common.year") + " : " + vo.getHaksaYear() // 학년도
                , getMessage("common.term") + " : " + haksaTermNm // 학기
                , getMessage("common.type") + " : " + uniNm // 구분
                , getMessage("common.dept_name") + " : " + deptNm // 학과
                , getMessage("review.label.crscrenm") + " : " + crsCreNm // 과목명
                , getMessage("common.search.condition") + " : " + vo.getSearchValue() // 검색조건
        };
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        List<EgovMap> list = dashboardService.listLessonStatusByStd(vo);
        List<DashboardVO> listExc = new ArrayList<>();

        for (EgovMap egovMap : list) {
            DashboardVO listInfo = new DashboardVO();
            for (Field field : DashboardVO.class.getDeclaredFields()) {
                field.setAccessible(true);
                String fieldName = field.getName();
                Object value = egovMap.get(fieldName);

                if (value != null) {
                    field.set(listInfo, value);
                }
            }
            listExc.add(listInfo);
        }

        String title = getMessage("dashboard.label.lesson.status.std"); // 학생별 학습현황

        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", listExc);

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 관리자 메인 > 학생별 학습현황 팝업
     * @param vo
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lessonStatusPop.do")
    public String lessonStatusPop(DashboardVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);

        // 1. 사용자 조회
        UsrUserInfoVO userInfoVO = new UsrUserInfoVO();
        userInfoVO.setUserId(vo.getUserId());
        userInfoVO = usrUserInfoService.userSelect(userInfoVO);

        // 2. 학생별 학습현황 목록 조회
        vo.setOrgId(orgId);
        vo.setSearchKey("lessonStatusPop");
        List<EgovMap> listLessonStatusByStd = dashboardService.listLessonStatusByStd(vo);

        model.addAttribute("userInfoVO", userInfoVO);
        model.addAttribute("listLessonStatusByStd", listLessonStatusByStd);
        model.addAttribute("vo", vo);

        return "/dashboard/popup/lesson_status_pop";
    }

    /*****************************************************
     * 관리자 메인 > 사용자 검색
     * @param vo
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listAdminDashUser.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listAdminDashUser(DashboardVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);
            if (!SessionInfo.isKnou(request)) {
                vo.setOrgKnouRltn("Y");
            }

            resultVO = dashboardService.listAdminDashUser(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 학생 홈 > 강의평가 팝업
     * @param vo
     * @return "/dashboard/popup/lect_eval_pop";
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/lectEvalPop.do")
    public String lectEvalPop(DashboardVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);

        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);

        SysJobSchVO sysJobSchSearchVO = new SysJobSchVO();
        sysJobSchSearchVO.setOrgId(orgId);
        sysJobSchSearchVO.setUseYn("Y");
        sysJobSchSearchVO.setTermCd(termVO.getTermCd());
        // 00190501: 중간강의평가일정, 00190505: 기말강의평가일정
        sysJobSchSearchVO.setSqlForeach(new String[]{"00190501", "00190505"});
        List<SysJobSchVO> jobSchList = sysJobSchService.list(sysJobSchSearchVO);
        Map<String, SysJobSchVO> jobSchMap = new HashMap<>();
        for (SysJobSchVO sysJobSchVO2 : jobSchList) {
            jobSchMap.put(sysJobSchVO2.getCalendarCtgr(), sysJobSchVO2);
        }

        SysJobSchVO sysJobSchVO;

        String midLectEvalPeriodYn = "N";   // 중간 강의평가 일정
        String midLectEvalStartDttm = "";   // 중간 강의평가 시작일
        String midLectEvalEndDttm = "";     // 중간 강의평가 종료일

        String finalLectEvalPeriodYn = "N";   // 기말 강의평가 일정
        String finalLectEvalStartDttm = "";   // 기말 강의평가 시작일
        String finalLectEvalEndDttm = "";     // 기말  강의평가 종료일

        // 중간강의평가일정
        sysJobSchVO = jobSchMap.get("00190505");

        if (sysJobSchVO != null) {
            midLectEvalPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();
            midLectEvalStartDttm = sysJobSchVO.getSysjobSchdlSymd();
            midLectEvalEndDttm = sysJobSchVO.getSysjobSchdlEymd();
        }

        // 기말강의평가일정
        sysJobSchVO = jobSchMap.get("00190501");

        if (sysJobSchVO != null) {
            finalLectEvalPeriodYn = sysJobSchVO.getSysjobSchdlPeriodYn();
            finalLectEvalStartDttm = sysJobSchVO.getSysjobSchdlSymd();
            finalLectEvalEndDttm = sysJobSchVO.getSysjobSchdlEymd();
        }

        model.addAttribute("vo", vo);
        model.addAttribute("midLectEvalPeriodYn", midLectEvalPeriodYn);
        model.addAttribute("midLectEvalStartDttm", midLectEvalStartDttm);
        model.addAttribute("midLectEvalEndDttm", midLectEvalEndDttm);
        model.addAttribute("finalLectEvalPeriodYn", finalLectEvalPeriodYn);
        model.addAttribute("finalLectEvalStartDttm", finalLectEvalStartDttm);
        model.addAttribute("finalLectEvalEndDttm", finalLectEvalEndDttm);
        model.addAttribute("lectEvalPopUrl", ErpUtil.getStuLectEvalUrl(termVO.getHaksaYear(), termVO.getHaksaTerm(), userId));

        return "/dashboard/popup/lect_eval_pop";
    }

    /**
     * 가상지원모드 세션 종료
     *
     * @param map
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/closeVirtualSession.do")
    @ResponseBody
    public String closeVirtualSession(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws Exception {
        resetVirtualSession(request);

        return "1";
    }


    /**
     * 가상지원모드 (App 에서 호출할 경우)
     *
     * @param map
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/closeVirtualSessionApp.do")
    public String closeVirtualSessionByApp(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws Exception {
        resetVirtualSession(request);

        String url = StringUtil.nvl(request.getParameter("url"));
        if ("".equals(url)) {
            url = "/dashboard/adminDashboard.do";
        }

        return "redirect:" + url;
    }


    // 가상로그인 세션 초기화
    private void resetVirtualSession(HttpServletRequest request) throws Exception {
        Map<String, Object> srcUserMap = SessionInfo.getAdminCrsInfo(request);

        if (srcUserMap != null) {
            if (srcUserMap.get("userId") != null) {
                SessionInfo.setUserId(request, (String) srcUserMap.get("userId"));
            }
            if (srcUserMap.get("userNm") != null) {
                SessionInfo.setUserNm(request, (String) srcUserMap.get("userNm"));
            }
            if (srcUserMap.get("curUpMenuId") != null) {
                SessionInfo.setCurUpMenuId(request, (String) srcUserMap.get("curUpMenuId"));
            }
            if (srcUserMap.get("curMenuId") != null) {
                SessionInfo.setCurMenuId(request, (String) srcUserMap.get("curMenuId"));
            }

            SessionInfo.setAdminCrsInfo(request, null);
        }

        Stack<Map<String, Object>> stack = SessionInfo.getVirtualLoginStack(request);
        Map<String, Object> beforeUserMap = null;

        if (stack != null && !stack.empty() && stack.size() > 0) {
            beforeUserMap = stack.pop();
        } else {
            beforeUserMap = SessionInfo.getVirtualLoginInfo(request);
        }

        if (beforeUserMap != null) {
            if (stack != null && !stack.empty() && stack.size() > 0) {
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
            SessionInfo.setUserNm(request, uuivo.getUserNm());

            //STUDENT:학생 / PROFESSOR:교수 / ADMIN:관리자
            SessionInfo.setAuthrtGrpcd(request, uuivo.getAuthrtGrpcd());
            SessionInfo.setAuthrtCd(request, uuivo.getWwwAuthrtCd());
            // ADMIN 권한이있으면 Y / 없으면 N
            SessionInfo.setAdmYn(request, uuivo.getAdminAuthYn());

            SessionInfo.setLoginIp(request, CommonUtil.getIpAddress(request));
            SessionInfo.setOrgId(request, uuivo.getOrgId());
            //SessionInfo.setOrgNm(request,vo.getOrgNm());
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
                SessionInfo.setLastLogin(request, loginTryLogVO.getLoginTryDttmStr());
            }

            //수강생정보 삭제
            SessionInfo.setStdNo(request, "");
            SessionInfo.setSysLocalkey(request, "ko");
            LocaleUtil.setLocale(request, "ko");
            SessionInfo.removeCourseInfo(request);
        }
    }


    // (팝업)위젯 설정 팝업
    @RequestMapping(value = "/widgetSettingPop.do")
    public String widgetSettingPop(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String userId = SessionInfo.getUserId(request);

        DashboardVO dashBoardVO = new DashboardVO();
        dashBoardVO.setUserId(userId);

        model.addAttribute("vo", dashBoardVO);
        return "dashboard/popup/widget_setting_pop";
    }

    // (팝업)위젯 설정 팝업
    @RequestMapping(value = "/widgetSettingPop2.do")
    public String widgetSettingPop2(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String userId = SessionInfo.getUserId(request);

        DashboardVO dashBoardVO = new DashboardVO();
        dashBoardVO.setUserId(userId);

        model.addAttribute("vo", dashBoardVO);
        return "dashboard/popup/widget_setting_pop2";
    }

    // (팝업)위젯 설정 팝업 리스트
    @RequestMapping(value = "/widgetSettingPopList.do")
    @ResponseBody
    public ProcessResultVO<DashboardVO> widgetSettingPopList(DashboardVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DashboardVO> resultVO = new ProcessResultVO<>();

        try {
            vo.setUserId(StringUtil.nvl(userId, ""));
            resultVO = dashboardService.listWidgetSettingPop(vo);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return resultVO;
    }

    @RequestMapping(value = "/widgetStngSelect.do")
    @ResponseBody
    public Map<String, Object> widgetStngSelect(DashboardVO vo) throws Exception {
        Map<String, Object> result = new HashMap<>();

        EgovMap widgetInfo = dashboardService.widgetStngSelect(vo);

        if (widgetInfo != null) {
            String jsonCts = (String) widgetInfo.get("widgetStngCts");

            if (jsonCts != null && !jsonCts.isEmpty()) {
                ObjectMapper mapper = new ObjectMapper();

                try {
                    result.put("result", 1);
                    result.put("dataList", jsonCts); // JS에서 사용할 위젯 배열 데이터
                    result.put("masterInfo", widgetInfo); // 나머지 기본 정보들

                    /*
                    // 과목 접속자 수 조회
                    EgovMap lgnUsrCnt = dashboardService.lgnUsrCntSelect(vo);
                    result.put("lgnUsrCnt", lgnUsrCnt);

                    // 학생 수 조회
                    EgovMap totStdntCnt = dashboardService.totStdntCntSelect(vo);
                    result.put("totStdntCnt", totStdntCnt);

                    // 과목 리스트 조희
					List<EgovMap> sbjctList = dashboardService.sbjctList(vo);
                    result.put("sbjctList", sbjctList);
                    */

                } catch (Exception e) {
                    e.printStackTrace();
                    result.put("result", 0);
                    result.put("message", "JSON 파싱 중 오류가 발생했습니다.");
                }
            } else {
                result.put("result", 0);
                result.put("message", "설정된 위젯 상세 정보가 없습니다.");
            }
        } else {
            result.put("result", 0);
            result.put("message", "위젯 설정 데이터가 존재하지 않습니다.");
        }

        return result;
    }

    @RequestMapping(value="/widgetStngChange.do")
    @ResponseBody
    public ProcessResultVO<DashboardVO> widgetStngChange(DashboardVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<DashboardVO> resultVO = new ProcessResultVO<DashboardVO>();

        try {
            dashboardService.widgetStngChange(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    @RequestMapping("/widgetStngColrSelect.do")
    @ResponseBody
    public Map<String, Object> widgetStngColr(DashboardVO vo) throws Exception {
        EgovMap widgetStngColrSelect = dashboardService.widgetStngColrSelect(vo);
        Map<String, Object> result = new HashMap<>();
        if (widgetStngColrSelect != null) {
            result.put("result", 1);
            result.put("data", widgetStngColrSelect);
        } else {
            result.put("result", 0);
            result.put("message", "위젯 설정이 없습니다.");
        }
        return result;  // JSON으로 내려감
    }

    @RequestMapping("/widgetStngPopView.do")
    @ResponseBody
    public Map<String, Object> widgetStngPopView(DashboardVO vo, @CurrentUser UserContext userCtx,
    		HttpServletRequest request) throws Exception {
    	String userId = userCtx.getUserId();

    	Map<String, Object> result = new HashMap<>();

        // 1. 세션 체크: 로그인이 안 되어 있으면 즉시 반환
        if (!SessionInfo.isLogin(request)) {
            result.put("sessChkYn", "N");
            return result;
        }

        // 2. 기본 세션 정보 설정
        result.put("sessChkYn", "Y");

        // 3. 데이터 조회
        vo.setUserId(userId);
        EgovMap data = dashboardService.widgetStngPopView(vo);

        // 4. 조회 결과에 따른 응답 처리
        if (data != null) {
            result.put("result", 1);
            result.put("data", data);
        } else {
            result.put("result", 0);
            result.put("message", "위젯 설정이 없습니다.");
        }

        return result;
    }

    @RequestMapping("/widgetStngColrPopView.do")
    @ResponseBody
    public Map<String, Object> widgetStngColrPopView(DashboardVO vo, @CurrentUser UserContext userCtx,
    		HttpServletRequest request) throws Exception {
    	String userId = userCtx.getUserId();

        Map<String, Object> result = new HashMap<>();

        // 1. 세션 체크 (Fail-Fast)
        if (!SessionInfo.isLogin(request)) {
            result.put("sessChkYn", "N");
            return result;
        }

        result.put("sessChkYn", "Y");

        // 2. 데이터 조회 및 응답 구성
        vo.setUserId(userId);
        EgovMap data = dashboardService.widgetStngColrPopView(vo);

        if (data != null) {
            result.put("result", 1);
            result.put("data", data);
        } else {
            result.put("result", 0);
            result.put("message", "위젯 설정이 없습니다.");
        }

        return result;
    }

    /*****************************************************
     * 위젯 삭제
     * @param DashboardVO
     * @return ProcessResultVO<DashboardVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/widgetStngReset.do")
    @ResponseBody
    public ProcessResultVO<DashboardVO> widgetStngDelete(DashboardVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<DashboardVO> resultVO = new ProcessResultVO<DashboardVO>();

        try {
        	dashboardService.widgetStngReset(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    /**
     * ***************************************************
     * 대시보드2
     * @param userCtx
     * @param model
     * @return
     * @throws Exception *********************************
     */
    @RequestMapping(value = "/dashboard.do")
    public String dashboard(@CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception { 
    	
    	BaseParam param = new DashboardParam(userCtx.getSelectedUser(), 3);
    	
    	DashboardViewModel dashVM = dashboardFacadeService.getDashboardResponse(userCtx.getSelectedUser(), param);
    	
    	model.addAttribute("dashVM", dashVM);
    	
    	return dashVM.getViewName();
    }

    /**
     * 메인 탭페이지
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mainTabpage.do")
    public String mainTabpage(MenuVO vo, HttpServletRequest request, ModelMap model) throws Exception {
    	String menuUrl = StringUtil.nvl(vo.getMenuUrl());
    	String menunm = StringUtil.nvl(vo.getMenunm());
    	String upMenuId = StringUtil.nvl(vo.getUpMenuId());
    	String menuId = StringUtil.nvl(vo.getMenuId());

    	model.addAttribute("authrtGrpcd", SessionInfo.getAuthrtGrpcd(request));
    	model.addAttribute("menuUrl", menuUrl);
    	model.addAttribute("menunm", menunm);
    	model.addAttribute("upMenuId", upMenuId);
    	model.addAttribute("menuId", menuId);

    	addEncParam("upMenuId", upMenuId);
    	addEncParam("menuId", menuId);

    	return "dashboard/main_tabpage";
    }


    /**
     * 교수 Today 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profWidgetToday.do")
    public String profWidgetToday(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	// TODO 처리 로직 추가
    	int lgnUsrCnt = 1;
    	int totStdntCnt = 10;
    	String todayDate = DateTimeUtil.getCurrentString("yyyy.MM.dd");

    	model.addAttribute("lgnUsrCnt", lgnUsrCnt);
    	model.addAttribute("totStdntCnt", totStdntCnt);
    	model.addAttribute("todayDate", todayDate);

    	return "dashboard/widget/prof_widget_today";
    }

    /**
     * 교수 이달의 학사일정 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profWidgetSchedule.do")
    public String profWidgetSchedule(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	// TODO 처리 로직 추가

    	return "dashboard/widget/prof_widget_schedule";
    }

    /**
    * 교수 강의Q&A 위젯
    * @param request
    * @param model
    * @return
    * @throws Exception
    */
   @RequestMapping(value = "/profWidgetQna.do")
   public String profWidgetQna(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

	   // TODO 처리 로직 추가

	   return "dashboard/widget/prof_widget_qna";
   }

    /**
     * 교수 공지사항 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profWidgetNotice.do")
    public String profWidgetNotice(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	// TODO 처리 로직 추가

    	return "dashboard/widget/prof_widget_notice";
    }

    /**
     * 교수 1:1상담 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profWidgetCounsel.do")
    public String profWidgetCounsel(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	// TODO 처리 로직 추가

    	return "dashboard/widget/prof_widget_counsel";
    }

    /*****************************************************
     * 교수 알림(메시지) 위젯
     * @param vo
     * @param request
     * @param model
     * @return "dashboard/widget/prof_widget_msg"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profWidgetMsg.do")
    public String profWidgetMsg(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));

    	MsgAlimVO msgAlimVO = new MsgAlimVO();
    	msgAlimVO.setUserId(userId);
    	msgAlimVO.setListCnt(5);
    	msgAlimVO.setMblSndngTycd("PUSH");

    	List<MsgAlimVO> pushList = msgAlimService.selectMblSndngList(msgAlimVO);

    	model.addAttribute("pushList", pushList);

    	return "dashboard/widget/prof_widget_msg";
    }

    /**
     * 교수 강의과목 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profWidgetSubject.do")
    public String profWidgetSubject(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {
    	// TODO 처리 로직 추가
    	return "dashboard/widget/prof_widget_subject";
    }



    /**
     * ***************************************************
     * 학생 대시보드
     * TODO: TOBE 새로 작업하는 학생용 대시보드 작업
     * 작업 완료후 새 버전에 맞게 명칭, 메쏘드 등 변경
     */
    @RequestMapping(value = "/stuDashboard.do")
    public String stuDashboard(DashboardVO dashboardVO, @CurrentUser UserContext userCtx,  
    		HttpServletRequest request, HttpServletResponse response,  ModelMap model) throws Exception {
    	
    	model.addAttribute("orgId", 		userCtx.getOrgId());
        model.addAttribute("authrtGrpcd", 	userCtx.getAuthrtGrpcd());
        model.addAttribute("userId", 		SessionInfo.getUserId(request));

        return "dashboard/stu_dashboard";
    }

    /**
     * 학생 Today 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/stuWidgetToday.do")
    public String stuWidgetToday(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	// TODO 처리 로직 추가
    	String todayDate = DateTimeUtil.getCurrentString("yyyy.MM.dd");

    	model.addAttribute("todayDate", todayDate);

    	return "dashboard/widget/stu_widget_today";
    }

    /**
     * 학생 이달의 학사일정 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/stuWidgetSchedule.do")
    public String stuWidgetSchedule(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	// TODO 처리 로직 추가

    	return "dashboard/widget/stu_widget_schedule";
    }

    /**
    * 학생 강의Q&A 위젯
    * @param request
    * @param model
    * @return
    * @throws Exception
    */
   @RequestMapping(value = "/stuWidgetQna.do")
   public String stuWidgetQna(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

	   // TODO 처리 로직 추가

	   return "dashboard/widget/stu_widget_qna";
   }

    /**
     * 학생 공지사항 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/stuWidgetNotice.do")
    public String stuWidgetNotice(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	// TODO 처리 로직 추가

    	return "dashboard/widget/stu_widget_notice";
    }

    /**
     * 학생 1:1상담 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/stuWidgetCounsel.do")
    public String stuWidgetCounsel(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	// TODO 처리 로직 추가

    	return "dashboard/widget/stu_widget_counsel";
    }

    /**
     * 학생 알림(메시지) 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/stuWidgetMsg.do")
    public String stuWidgetMsg(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	// TODO 처리 로직 추가

    	return "dashboard/widget/stu_widget_msg";
    }

    /**
     * 학생 수강과목 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/stuWidgetSubject.do")
    public String stuWidgetSubject(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	// TODO 처리 로직 추가

    	return "dashboard/widget/stu_widget_subject";
    }

    /**
     * 학생 강의자료실 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/stuWidgetPds.do")
    public String stuWidgetPds(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	// TODO 처리 로직 추가

    	return "dashboard/widget/stu_widget_pds";
    }

    /**
     * 학생 강의 이어보기 위젯
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/stuWidgetContstdy.do")
    public String stuWidgetContstdy(DashboardVO vo, HttpServletRequest request, ModelMap model) throws Exception {

    	// TODO 처리 로직 추가

    	return "dashboard/widget/stu_widget_contstdy";
    }
}