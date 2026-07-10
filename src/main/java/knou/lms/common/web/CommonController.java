package knou.lms.common.web;

import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.support.RequestContextUtils;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.MainOrgInfo;
import knou.framework.common.MenuInfo;
import knou.framework.common.PageInfo;
import knou.framework.common.ParamInfo;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.SessionBrokenException;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.service.CommonService;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.menu.vo.MenuVO;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.user.CurrentUser;
import knou.lms.user.service.UserService;
import knou.lms.user.vo.UserVO;

/**
 * 공통 Controller
 *
 * @author shil
 */
@Controller
public class CommonController extends ControllerBase {

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="stdService")
    private StdService stdService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    @Resource(name = "sysFileService")
    private SysFileService sysFileService;

    @Resource(name="commonService")
    private CommonService commonService;

    @Resource(name="userService")
    private UserService userService;

    /**
     * 페이지 이동
     * @param request
     * @param response
     * @param menu
     * @param modelMap
     * @return page
     * @throws Exception
     */
    @RequestMapping(value="/common/movePage.do")
    public String movePage(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {

        String movePage = CommConst.PAGE_HOME;
        String menu = ""; //mainVO.getMenu();

        SessionInfo.setCurUpMenuId(request, "");
        SessionInfo.setCurMenuId(request, "");

        return "redirect:"+movePage;
    }

    /**
     * 언어 변경
     * @param language
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value="/common/changeLanguage.do")
    public String changeLanguage(HttpServletRequest request, HttpServletResponse response,
            String language,  ModelMap modelMap) {
        Locale locale = new Locale(language);

        LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
        localeResolver.setLocale(request, response, StringUtils.parseLocaleString(language));

        return "redirect:"+CommConst.PAGE_HOME;
    }

    /**
     * 세션 설정 후 과목 이동 (임시)
     * @param vo
     * @param request
     * @param response
     * @param modelMap
     * @return page
     * @throws Exception
     */
    @RequestMapping(value="/common/moveCrs.do")
    public String moveCrs(DefaultVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
        Locale locale   = LocaleUtil.getLocale(request);

        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);

        String goUrl = vo.getGoUrl();
        String subParam = vo.getSubParam();

        if(ValidationUtils.isEmpty(userId)) {
            // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            throw new SessionBrokenException(getMessage("common.system.no_auth"));
        }

        if(ValidationUtils.isEmpty(goUrl) || ValidationUtils.isEmpty(subParam)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        String[] subParamArr = subParam.split("@");
        Map<String, String> subParamMap = new HashMap<>();

        for(String subParam2 : subParamArr) {
            String[] paramArr = subParam2.split("=");

            if(paramArr != null && paramArr.length == 2) {
                subParamMap.put(paramArr[0], paramArr[1]);
            }
        }

        String crsCreCd = subParamMap.get("crsCreCd");

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 과목정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setOrgId(orgId);
        creCrsVO = crecrsService.select(creCrsVO);

        if(creCrsVO == null) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 세션 SET
        if(StringUtil.nvl(menuType).contains("USR")) {
            // 수강중인 학생정보 조회
            StdVO stdVO = new StdVO();
            stdVO.setOrgId(orgId);
            stdVO.setCrsCreCd(crsCreCd);
            stdVO.setUserId(userId);
            stdVO = stdService.selectStd(stdVO);

            crecrsService.setCreCrsStuSession(request, creCrsVO, stdVO);
        } else {
            crecrsService.setCreCrsProfSession(request, creCrsVO);
        }

        request.setAttribute("goUrl", goUrl);
        request.setAttribute("subParamMap", subParamMap);

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);

        if(menuType.contains("USR")) {
            // 강의실 활동 로그 등록 (common.log.classroomEnter: 강의실 입장)
            logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_LECTURE_HOME, messageSource.getMessage("common.log.classroomEnter", null, locale));
        }

        return "common/temp/moveCrs";
    }

    /**
     * 세션 확인
     * @param vo
     * @param request
     * @return userId
     * @throws Exception
     */
    @RequestMapping(value="/common/checkSession.do")
    @ResponseBody
    public String sessionCheck(HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        if("".equals(userId)) {
            return "N";
        } else {
            return "Y";
        }
    }

    /**
     * 전체공지정보 이동
     * @param vo
     * @param request
     * @param response
     * @param modelMap
     * @return page
     * @throws Exception
     */
    @RequestMapping(value="/common/moveNotice.do")
    public String moveNotice(DefaultVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);

        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);

        String goUrl = vo.getGoUrl();
        String subParam = vo.getSubParam();
        String langCd = SessionInfo.getLocaleKey(request);

        if(ValidationUtils.isEmpty(userId)) {
            // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            throw new SessionBrokenException(getMessage("common.system.no_auth"));
        }

        if(ValidationUtils.isEmpty(goUrl) || ValidationUtils.isEmpty(subParam)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        String[] subParamArr = subParam.split("@");
        Map<String, String> subParamMap = new HashMap<>();

        for(String subParam2 : subParamArr) {
            String[] paramArr = subParam2.split("=");

            if(paramArr != null && paramArr.length == 2) {
                subParamMap.put(paramArr[0], paramArr[1]);
            }
        }

        String bbsId = subParamMap.get("bbsId");
        String atclId = subParamMap.get("atclId");
        /*
        String crsCreCd = subParamMap.get("crsCreCd");

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        */
/*
        // 전체공지정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setBbsId(bbsId);
        creCrsVO.setAtclId(atclId);
        creCrsVO.setLangCd(langCd);
        creCrsVO.setOrgId(orgId);
        creCrsVO = crecrsService.selectNotice(creCrsVO);


        if(creCrsVO == null) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
         */

        String plnParam;
        plnParam = "{\"bbsId\":\""+bbsId+"\",\"atclId\":\""+atclId+"\"}";

        String lsnPlanUrl;
        // lsnPlanUrl = CommConst.PRODUCT_DOMAIN+"/bbs/bbsHome/Form/atclView.do&#63;bbsId=',"+bbsId+", '&amp;atclId=',"+atclId;

        // /sso/CreateRequest.jsp?RelayState=https://"+serverName+"/api/learningStatusForm.do
        // lsnPlanUrl = CommConst.LSNPLAN_POP_URL_STD + new String((Base64.getEncoder()).encode(plnParam.getBytes()));

        // 세션 SET
        SessionInfo.setCurCorHome(request, "/bbs/bbsHome/Form/atclView.do");
        lsnPlanUrl = CommConst.LSNPLAN_POP_URL_STD + new String((Base64.getEncoder()).encode(plnParam.getBytes()));

        SessionInfo.setLessonPlanUrl(request, lsnPlanUrl);
        SessionInfo.setCurUpMenuId(request, "");
        SessionInfo.setCurMenuId(request, "");

        request.setAttribute("goUrl", goUrl);
        request.setAttribute("subParamMap", subParamMap);

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_COR_HOME);

        if(menuType.contains("USR")) {
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_LECTURE_HOME, messageSource.getMessage("common.log.classroomEnter", null, locale));
        }
        return "common/temp/moveCrs";
    }

    /**
     * 기관 index
     * @param vo
     * @param request
     * @param response
     * @param modelMap
     * @return
     */
    @RequestMapping(value="/index.do")
    public String moveOrgLogin(DefaultVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {
        if (!SessionInfo.isLogin(request)) {
            String org = request.getParameter("org");
            String orgDomain = SessionInfo.getOrgDomain(request);

            if (org != null && !org.equals(orgDomain)) {
                try {
                    List<OrgInfoVO> orgList = MainOrgInfo.getMainOrgList((HttpServletRequest)request);
                    for (OrgInfoVO orgInfoVO : orgList) {
                        if (orgInfoVO.getDmnnm().equals(org)) {
                            SessionInfo.setOrgDomain(request, orgInfoVO.getDmnnm());
                        }
                    }
                } catch (Exception e) {
                }
            }

            request.getSession().setAttribute("noSSO", "Y");

            return "login/login";
        }
        else {
            return "redirect:/";
        }
    }

    /**
     * 관리자 서브메뉴 가져오기 Ajax
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/common/adminSubmenuAjax.do")
    @ResponseBody
    public ProcessResultVO<MenuVO> adminSubmenuAjax(HttpServletRequest request, MenuVO menuVO) {
    	ProcessResultVO<MenuVO> resultVO = new ProcessResultVO<>();

    	try {
        	menuVO.setMenuGbncd(CommConst.AUTHRT_GRPCD_ADM);
        	List<MenuVO> subMenuList = MenuInfo.getSubMenuInfo(request, menuVO);

        	resultVO.setReturnList(subMenuList);
        	resultVO.setResult(1);
		} catch (Exception e) {
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());
		}

    	return resultVO;
    }

    /**
     * 기관별 학기기수목록조회
     * @param	PageInfo
     * @return	ResultDTO
     */
    @RequestMapping(value={"/common/admYrSmstrSelect.do", "/common/yrSmstrSelect.do"})
    @ResponseBody
    public ResultDTO<EgovMap> admYrSmstrSelect(PageInfo pageInfo, @CurrentUser UserContext userCtx) {
        // 관리자가 아닌 경우만 처리하도록 수정.(시스템 관리자는 모든 기관을 선택할 수 있어야 함)
        if (!CommConst.AUTHRT_CD_ADM.equals(userCtx.getAuthrtCd())) {
            pageInfo.setOrgId(userCtx.getLoginUser().getOrgId());
        }
        return new ResultDTO<EgovMap>().setReturnList(commonService.yrSmstrSelect(pageInfo)).setResultSuccess();
    }

    /**
     * 언어 변경
     * @param vo
     * @param request
     * @param response
     * @param modelMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/common/changeLang.do")
    public String changeLang(DefaultVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
    	String sbjctId = StringUtil.nvl(request.getParameter("sbjctId"));
    	String language = StringUtil.nvl(request.getParameter("language"));
    	UserContext userContext = SessionInfo.getUserContext(request);
    	String userId = "";

    	if (userContext != null) {
    		userId = StringUtil.nvl(userContext.getUserId());
    	}

        if (!"".equals(language) && !"".equals(userId)) {
        	userContext.setLangCd(language);
            LocaleUtil.setLocale(request, language);

            UserVO userVO = new UserVO();
            userVO.setUserId(userId);
	        userVO = userService.userSelect(userId);

            if (userVO != null) {
	            String conf = StringUtil.nvl(userVO.getUserEnvStngCts());

	            if (StringUtil.isNull(conf)) {
	                conf = "{}";
	            }

	            JSONParser parser = new JSONParser();
	            JSONObject jsonObject = (JSONObject) parser.parse(conf);
	            jsonObject.put("langCd", language);
	            userVO.setUserEnvStngCts(jsonObject.toJSONString());

	            //개인환경설정 저장
	            userService.userStngModify(userVO);
	        }
        }

        String url = "/";
        if (!"".equals(sbjctId)) {
        	url = "/subject/subject.do?sbjctId="+sbjctId;
        }

    	return "redirect:"+url;
    }
}
