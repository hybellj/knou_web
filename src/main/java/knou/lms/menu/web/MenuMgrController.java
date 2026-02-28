package knou.lms.menu.web;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.HttpRequestUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.LocaleUtil;
import knou.framework.util.SecurityUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.service.OrgCfgService;
import knou.lms.common.service.OrgMenuService;
import knou.lms.common.service.OrgOrgInfoService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.OrgAuthGrpMenuVO;
import knou.lms.common.vo.OrgAuthGrpVO;
import knou.lms.common.vo.OrgCfgVO;
import knou.lms.common.vo.OrgMenuVO;
import knou.lms.common.vo.OrgOrgInfoVO;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.connip.service.OrgConnIpService;
import knou.lms.connip.vo.OrgConnIpVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.service.DashboardService;
import knou.lms.file.vo.CrsSizeMgrVO;
import knou.lms.lesson.dao.LessonOperateDAO;
import knou.lms.lesson.service.LessonOperateService;
import knou.lms.lesson.vo.LessonOperateVO;
import knou.lms.log.adminconnlog.service.LogAdminConnLogService;
import knou.lms.log.adminconnlog.vo.LogAdminConnLogVO;
import knou.lms.menu.dao.ReviewDAO;
import knou.lms.menu.service.ReviewService;
import knou.lms.menu.service.SysMenuService;
import knou.lms.menu.vo.MenuVO;
import knou.lms.menu.vo.ReviewVO;
import knou.lms.menu.vo.SysAuthGrpVO;
import knou.lms.org.service.OrgCodeMemService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeLangVO;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.system.config.vo.SysCfgVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

@Controller
@RequestMapping(value = "/menu/menuMgr")
public class MenuMgrController extends ControllerBase {
    
    private static final Logger LOGGER = LoggerFactory.getLogger(MenuMgrController.class);
    
    @Autowired @Qualifier("messageSource")
    private MessageSource messageSource;

    @Autowired @Qualifier("orgMenuService")
    private OrgMenuService orgMenuService;
    
    @Autowired @Qualifier("sysMenuService")
    private SysMenuService sysMenuService;
    
    @Autowired @Qualifier("orgCodeService")
    private OrgCodeService orgCodeService;
    
    @Autowired @Qualifier("orgCodeMemService")
    private OrgCodeMemService orgCodeMemService;
    
    @Autowired @Qualifier("orgOrgInfoService")
    private OrgOrgInfoService orgOrgInfoService;

    @Autowired @Qualifier("usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;
    
    @Autowired @Qualifier("orgCfgService")
    private OrgCfgService orgCfgService;
    
    @Autowired @Qualifier("orgConnIpService")
    private OrgConnIpService orgConnIpService;
    
    @Autowired @Qualifier("logAdminConnLogService")
    private LogAdminConnLogService logAdminConnLogService;
    
    @Autowired @Qualifier("reviewService")
    private ReviewService reviewService;
    
    @Autowired @Qualifier("termService")
    private TermService termService;
    
    @Autowired @Qualifier("lessonOperateService")
    private LessonOperateService lessonOperateService;
    
    @Autowired @Qualifier("dashboardService")
    private DashboardService dashboardService;  
    
    @Autowired @Qualifier("reviewDAO")
    private ReviewDAO reviewDAO;
    
    @Autowired @Qualifier("lessonOperateDAO")
    private LessonOperateDAO lessonOperateDAO;
    
    @Autowired @Qualifier("cmmnCdService")
    private CmmnCdService cmmnCdService;
    
    /***************************************************** 
     * @Method Name : code
     * @Method 설명 : 코드 관리 > 폼
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "mgr/main/code_form.jsp"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/code.do")
    public String code(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        //        if(!menuType.contains("ADM") || !checkAdmin()) {
    	if(!menuType.contains("ADM") && !checkAdmin()) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        vo.setIsRoot(true);	// 최상위 공통 코드 
        
        ProcessResultListVO<CmmnCdVO> processResultListVO = cmmnCdService.listCmmnCd(vo);
        List<CmmnCdVO> cmmnCdUpCdList = processResultListVO.getReturnList();
        model.addAttribute("cmmnCdUpCdList", cmmnCdUpCdList);
        
        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        return "mgr/main/code_form";
    }
    
    /***************************************************** 
     * @Method Name : codeCtgrList
     * @Method 설명 : 코드 관리 > 코드카테고리 리스트
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "mgr/main/code_ctgr_list.jsp"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/cmmnCdUpCdList.do")
    public String cmmnCdUpCdList(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        vo.setIsRoot(vo.getSearchValue() == null || vo.getSearchValue().trim().isEmpty());

        int pageIndex = 0;     // 현재 페이지
        int listScale    = 0;     // 한 페이지당 보여줄 건 수

        String strPageIndex = "";
        String strListScale = "";

        try {
            // 게시글 정보 설정 
            strPageIndex = request.getParameter("pageIndex");
            strListScale = request.getParameter("listScale");
            
            // 빈값체크 
            if(ValidationUtils.isEmpty(strPageIndex)) {
                pageIndex = 1;
            } else {
                pageIndex = Integer.parseInt(strPageIndex);
            }

            if(ValidationUtils.isEmpty(strListScale)) {
                listScale = 10;
            } else {
                listScale = Integer.parseInt(strListScale);
            }

            ProcessResultListVO<CmmnCdVO> processResultListVO = cmmnCdService.listCmmnCdPageing(vo, pageIndex, listScale);
            PagingInfo pageInfo = processResultListVO.getPageInfo();
            
            List<CmmnCdVO> cmmnCdUpCdList = processResultListVO.getReturnList();
            
            model.addAttribute("cmmnCdUpCdList", cmmnCdUpCdList);
            model.addAttribute("pageInfo", pageInfo);
            
        } catch(Exception e) {
        }
        return "mgr/main/code_ctgr_list";
    }
    
    /***************************************************** 
     * @Method Name : addCodeCtgr
     * @Method 설명 : 코드 관리 > 코드카테고리 저장
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/addUpCd.do")
    public String addUpCd(CmmnCdVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        
        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<CmmnCdVO> result = new ProcessResultVO<CmmnCdVO>();
        
        try {
            // 중복체크
        	CmmnCdVO dupCheckVo = new CmmnCdVO();
            dupCheckVo.setOrgId(orgId);
            dupCheckVo.setCd(vo.getCd());
            
            int count = cmmnCdService.countUpCd(dupCheckVo);
            
            if(count != 0) {
                result.setResult(-1);
                result.setMessage(messageSource.getMessage("main.code.message.dup.ctgr.code", null, locale)); // 코드 카테고리가 중복되었습니다.
                
                return JsonUtil.responseJson(response, result);
            }
            
            String userId = SessionInfo.getUserId(request);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            
            cmmnCdService.addUpCd(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.insert", null, locale));           // 정상적으로 수정되었습니다.
        } catch(Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("system.fail.data.process.msg", null, locale));    // 데이터 처리 중 오류가 발생하였습니다.
        }
        return JsonUtil.responseJson(response, result);
    }
    
    /***************************************************** 
     * @Method Name : editCodeCtgrForm
     * @Method 설명 : 코드 관리 > 코드카테고리 정보 조회
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editUpCdForm.do")
    public String editDeptForm(CmmnCdVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale = LocaleUtil.getLocale(request);
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        String userId = SessionInfo.getUserId(request);
        vo.setMdfrId(userId);
        
        ProcessResultVO<CmmnCdVO> result = new ProcessResultVO<CmmnCdVO>();
        
        try {
            vo = cmmnCdService.viewUpCd(vo);
            vo.setResult(1);
        } catch(Exception e) {
            vo.setResult(-1);
            result.setMessage(messageSource.getMessage("system.fail.data.process.msg", null, locale));    // 데이터 처리 중 오류가 발생하였습니다.
        }
        return JsonUtil.responseJson(response, vo);
    }
    
    /***************************************************** 
     * @Method Name : editCodeCtgr
     * @Method 설명 : 코드 관리 > 코드카테고리 수정
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/editUpCd.do")
    public String editUpCd(CmmnCdVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale = LocaleUtil.getLocale(request);
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        
        ProcessResultVO<CmmnCdVO> result = new ProcessResultVO<CmmnCdVO>();
        
        try {
        	cmmnCdService.editUpCd(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.update", null, locale));           // 정상적으로 수정되었습니다.
        } catch(Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("system.fail.data.process.msg", null, locale));    // 데이터 처리 중 오류가 발생하였습니다.
        }
        
        return JsonUtil.responseJson(response, result);
    }
    
    /***************************************************** 
     * @Method Name : removeUpCd
     * @Method 설명 : 코드관리 > 코드카테고리 삭제
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/removeUpCd.do")
    public String removeUpCd(CmmnCdVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale = LocaleUtil.getLocale(request);
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        
        ProcessResultVO<CmmnCdVO> result = new ProcessResultVO<CmmnCdVO>();
        
        try {
        	cmmnCdService.removeUpCd(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.delete", null, locale));           // 정상적으로 삭제되었습니다.
        } catch(Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("system.fail.data.process.msg", null, locale));    // 데이터 처리 중 오류가 발생하였습니다.
        }
        return JsonUtil.responseJson(response, result);
    }
    
    /***************************************************** 
     * @Method Name : codeList
     * @Method 설명 : 코드관리 > 코드 리스트
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "mgr/main/code_list.jsp"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/cmmnCdList.do")
    public String codeList(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String orgId  = SessionInfo.getOrgId(request);
        String langCd = SessionInfo.getLocaleKey(request);

        int pageIndex = 0;            // 현재 페이지
        int listScale    = 0;            // 한 페이지당 보여줄 건 수
        
        String strPageIndex = "";
        String strListScale = "";
        
        try {
            // 게시글 정보 설정 
            strPageIndex = request.getParameter("pageIndex");
            strListScale = request.getParameter("listScale");
            
            //빈값체크 
            if(ValidationUtils.isEmpty(strPageIndex)) {
                pageIndex = 1;
            } else {
                pageIndex = Integer.parseInt(strPageIndex);
            }

            if(ValidationUtils.isEmpty(strListScale)) {
                listScale = 10;
            } else {
                listScale = Integer.parseInt(strListScale);
            }
            
            vo.setOrgId(orgId);
            vo.setUseyn("");    // 사용여부에 관계없이 모두 조회 (VO에 Y로 박혀있음)
            vo.setLangCd(langCd);
            //vo.setIsRoot(false);
            
            ProcessResultListVO<CmmnCdVO> processResultListVO = cmmnCdService.listCmmnCdPageing(vo, pageIndex, listScale);
            PagingInfo pageInfo = processResultListVO.getPageInfo();

            List<CmmnCdVO> cmmnCdList = processResultListVO.getReturnList();
            
            model.addAttribute("cmmnCdList", cmmnCdList);
            model.addAttribute("pageInfo", pageInfo);

        } catch(Exception e) {
        }        
        return "mgr/main/code_list";
    }
    
    /***************************************************** 
     * @Method Name : addCode
     * @Method 설명 : 코드 관리 > 코드 저장
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/addCode.do")
    public String addCode(CmmnCdVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale = LocaleUtil.getLocale(request);
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        
        String langCd = SessionInfo.getLocaleKey(request);
        
        ProcessResultVO<OrgCodeVO> result = new ProcessResultVO<OrgCodeVO>();
        
        try {
            // 중복체크
			/*
			 * OrgCodeVO dupCheckVo = new OrgCodeVO(); dupCheckVo.setOrgId(orgId);
			 * dupCheckVo.setCodeCtgrCd(vo.getCodeCtgrCd());
			 * dupCheckVo.setCodeCd(vo.getCodeCd()); dupCheckVo.setLangCd(langCd);
			 */
        	
            
            int count = cmmnCdService.countCode(vo);
            
            if(count != 0) {
                result.setResult(-1);
                result.setMessage(messageSource.getMessage("main.code.message.dup.code", null, locale));  // 코드가 중복되었습니다.
                
                return JsonUtil.responseJson(response, result);
            }
            
            String userId = SessionInfo.getUserId(request);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            
            cmmnCdService.addCode(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.insert", null, locale));           // 정상적으로 수정되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("system.fail.data.process.msg", null, locale));    // 데이터 처리 중 오류가 발생하였습니다.
        }
        
        return JsonUtil.responseJson(response, result);
    }
    
    /***************************************************** 
     * @Method Name : editCodeForm
     * @Method 설명 : 코드 관리 > 코드 정보 조회
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/editCodeForm.do")
    public String editCodeForm(CmmnCdVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale = LocaleUtil.getLocale(request);
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        
        ProcessResultVO<CmmnCdVO> result = new ProcessResultVO<CmmnCdVO>();
        
        try {
//            vo = orgCodeService.viewCode(orgId, vo.getCodeCtgrCd(), vo.getCodeCd(), langCd);
            vo = cmmnCdService.viewCode(vo);
            vo.setResult(1);
        } catch(Exception e) {
            vo.setResult(-1);
            result.setMessage(messageSource.getMessage("system.fail.data.process.msg", null, locale));    // 데이터 처리 중 오류가 발생하였습니다.
        }
        
        return JsonUtil.responseJson(response, vo);
    }

    
    /***************************************************** 
     * @Method Name : selectCodeLangForm
     * @Method 설명 : 코드 관리 > 코드 정보 조회 (언어 정보 포함) 예시용 코드
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/selectCodeLangForm.do")
    public String selectCodeLangForm(OrgCodeLangVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<OrgCodeLangVO> result = new ProcessResultVO<OrgCodeLangVO>();
        
        try {
            vo = orgCodeService.viewCode(SessionInfo.getOrgId(request), vo.getUpCd(), vo.getCd(), SessionInfo.getLocaleKey(request));
            vo.setResult(1);
        } catch(Exception e) {
            vo.setResult(-1);
            result.setMessage(messageSource.getMessage("system.fail.data.process.msg", null, locale));    // 데이터 처리 중 오류가 발생하였습니다.
        }
        
        return JsonUtil.responseJson(response, vo);
    }
    
    /***************************************************** 
     * @Method Name : editCode
     * @Method 설명 : 코드 관리 > 코드수정
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editCode.do")
    public String editCode(CmmnCdVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale = LocaleUtil.getLocale(request);
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        String userId = SessionInfo.getUserId(request);
        vo.setMdfrId(userId);
        
        ProcessResultVO<CmmnCdVO> result = new ProcessResultVO<CmmnCdVO>();
        
        try {
        	cmmnCdService.editCode(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.update", null, locale));           // 정상적으로 수정되었습니다.
        } catch(Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("system.fail.data.process.msg", null, locale));    // 데이터 처리 중 오류가 발생하였습니다.
        }
        
        return JsonUtil.responseJson(response, result);
    }
    
    /***************************************************** 
     * @Method Name : removeCode
     * @Method 설명 : 코드 관리 > 코드삭제
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/removeCode.do")
    public String removeCode(CmmnCdVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale = LocaleUtil.getLocale(request);
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        
        ProcessResultVO<CmmnCdVO> result = new ProcessResultVO<CmmnCdVO>();
        
        try {
        	cmmnCdService.removeCode(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.delete", null, locale));           // 정상적으로 삭제되었습니다.
        } catch(Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("system.fail.data.process.msg", null, locale));    // 데이터 처리 중 오류가 발생하였습니다.
        }
        
        return JsonUtil.responseJson(response, result);
    }

    /***************************************************** 
     * @Method Name : manageConnIp
     * @Method 설명 : 관리자 페이지 접속 ip 관리
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "/mgr/conn_ip_manage.jsp"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/manageConnIp.do")
    public String manageConnIp(MenuVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String orgId = SessionInfo.getOrgId(request);
  
        OrgCfgVO orgCfgVo = new OrgCfgVO();
        orgCfgVo.setOrgId(orgId);
        orgCfgVo.setCfgCtgrCd("CONN_IP");
        orgCfgVo.setCfgCd("MANAGE");
        orgCfgVo = orgCfgService.viewCfg(orgCfgVo);
        
        request.setAttribute("cfgVO", orgCfgVo);
        request.setAttribute("connIp", HttpRequestUtil.getIpAddr(request));

        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        return "mgr/conn_ip_manage";
    }
    
    /***************************************************** 
     * @Method Name : listConnIp
     * @Method 설명 : 관리자 페이지 접속 ip 목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "/mgr/conn_ip_list.jsp"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listConnIp.do")
    public String listConnIp(OrgConnIpVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultListVO<OrgConnIpVO> resultListVO = new ProcessResultListVO<>();

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);
                
        resultListVO = orgConnIpService.listPageing(vo, vo.getPageIndex(), vo.getListScale());
        
        request.setAttribute("connIpList", resultListVO.getReturnList());
        request.setAttribute("pageInfo", resultListVO.getPageInfo());
        request.setAttribute("connIp", HttpRequestUtil.getIpAddr(request));
        
        return "mgr/conn_ip_list";
    }
    
    /***************************************************** 
     * @Method Name : listConnLog
     * @Method 설명 : 관리자 페이지 접속 로그 목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "/mgr/conn_log_list.jsp"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listConnLog.do")
    public String listConnLog(LogAdminConnLogVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultListVO<LogAdminConnLogVO> resultListVO = new ProcessResultListVO<>();
        resultListVO = logAdminConnLogService.listLoginLog(vo, vo.getPageIndex(), vo.getListScale(), vo.getPageScale());
        
        request.setAttribute("connLogList", resultListVO.getReturnList());
        request.setAttribute("pageInfo", resultListVO.getPageInfo());

        return "mgr/conn_log_list";
    }
    
    /***************************************************** 
     * @Method Name : saveConnSetting
     * @Method 설명 : 관리자 페이지 접속 제한 설정
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return JsonUtil.responseJson(response, resultVO)
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/saveConnSetting.do")
    public String saveConnSetting(OrgCfgVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<SysCfgVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);

        vo.setOrgId(orgId);
        vo.setCfgCtgrCd("CONN_IP");
        vo.setCfgCd("MANAGE");
        vo.setMdfrId(SessionInfo.getUserId(request));
        
        try {
            //  sysCfgService.editCfg(vo);
            orgCfgService.editCfg(vo);
            resultVO.setResult(1);
            SecurityUtil.setCfgCacheChanged();
            resultVO.setMessage(messageSource.getMessage("success.common.config", null, locale));  // 설정이 정상적으로 적용되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.config.again.try", null, locale));   // 설정 적용에 실패하였습니다. 다시 시도해주시기 바랍니다.
        }
        
        return JsonUtil.responseJson(response, resultVO);
    }
    
    /***************************************************** 
     * @Method Name : addConnIp
     * @Method 설명 : 관리자 페이지 접속 ip 등록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return JsonUtil.responseJson(response, resultVO)
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/addConnIp.do")
    public String addConnIp(OrgConnIpVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<SysCfgVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        
        try {
            orgConnIpService.add(vo);
            resultVO.setResult(1);
            resultVO.setMessage(messageSource.getMessage("success.common.config", null, locale));   // 설정이 정상적으로 적용되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.config.again.try", null, locale));   // 설정 적용에 실패하였습니다. 다시 시도해주시기 바랍니다.
        }
        
        return JsonUtil.responseJson(response, resultVO);
    }
    
    /***************************************************** 
     * @Method Name : removeConnIp
     * @Method 설명 : 관리자 페이지 접속 ip 삭제
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return JsonUtil.responseJson(response, resultVO)
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/removeConnIp.do")
    public String removeConnIp(OrgConnIpVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<SysCfgVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        
        try {
            orgConnIpService.remove(vo);
            resultVO.setResult(1);
            resultVO.setMessage(messageSource.getMessage("success.common.config", null, locale));  // 정상적으로 삭제되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.config.again.try", null, locale));  // 정상적으로 삭제되지 못했습니다. 다시 시도해주시기 바랍니다.
        }
        
        return JsonUtil.responseJson(response, resultVO);
    }

    /***************************************************** 
     * @Method Name : sysMenuMain
     * @Method 설명 : 시스템 관리 > 메뉴관리
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "mgr/main/system_menu_main.jsp"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/sysMenuMain.do")
    public String sysMenuMain(OrgMenuVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        vo.setAuthrtGrpcd(StringUtil.nvl(vo.getAuthrtGrpcd(),"HOME")); //-- 홈페이지
        vo.setParMenuCd(""); //-- 최상위 메뉴

        request.setAttribute("vo", vo);

        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항

        return "mgr/main/system_menu_main";
    }

    /***************************************************** 
     * @Method Name : sysMenuList
     * @Method 설명 : 시스템 관리 > 메뉴 목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "mgr/main/system_menu_list.jsp"
     * @throws Exception
     ******************************************************/

    @RequestMapping(value="/sysAuthorityMenuList.do")
    public String sysAuthorityMenuList(OrgMenuVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        vo.setAuthrtGrpcd(StringUtil.nvl(vo.getAuthrtGrpcd(),"HOME")); //-- 홈페이지
        vo.setParMenuCd(""); //-- 최상위 메뉴
        
        //--메뉴 리스트 조회
        ProcessResultListVO<OrgMenuVO> resultList = orgMenuService.listTreeMenu(vo);
        
        request.setAttribute("menuList", resultList.getReturnList());
        request.setAttribute("authGrpCd", vo.getAuthrtCd());
        request.setAttribute("vo", vo);

        return "mgr/main/system_menu_list";
    }
    /***************************************************** 
     * @Method Name : sysMenuAuthGrpList
     * @Method 설명 : 시스템 관리 > 메뉴 권한 그룹 목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "mgr/main/system_auth_grp_list.jsp"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/sysMenuAuthGrpList.do")
    public String sysMenuAuthGrpList(OrgMenuVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        vo.setAuthrtGrpcd(StringUtil.nvl(vo.getAuthrtGrpcd(),"HOME")); //-- 홈페이지
        vo.setParMenuCd(""); //-- 최상위 메뉴
        
        OrgAuthGrpVO oagvo = new OrgAuthGrpVO();
        oagvo.setOrgId(orgId);
        oagvo.setAuthrtGrpcd(StringUtil.nvl(vo.getAuthrtGrpcd(),"HOME")); //-- 홈페이지
        
        String[] langList = StringUtil.split(CommConst.LANG_SUPPORT,"/");
        request.setAttribute("langList", langList);
        
        //-- 메뉴 타입 조회
        List<OrgCodeVO> menuTypeList = orgCodeMemService.getOrgCodeList("MENU_TYPE",orgId);
        request.setAttribute("menuTypeList", menuTypeList);

        //--홈페이지 권한 목록 가져오기
        List<OrgAuthGrpVO> authGrpList = orgMenuService.listAuthGrp(oagvo).getReturnList();
        request.setAttribute("authGrpList", authGrpList);

        request.setAttribute("vo", vo);

        return "mgr/main/system_auth_grp_list";
    }
    
    /***************************************************** 
     * @Method Name : sysMenuAuthGrpPop
     * @Method 설명 : 시스템 관리 > 메뉴 권한 그룹 팝업
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "mgr/main/system_auth_grp_pop.jsp"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/sysMenuAuthGrpPop.do")
    public String sysMenuAuthGrpPop(OrgMenuVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        
        OrgAuthGrpVO oagvo = new OrgAuthGrpVO();
        oagvo.setOrgId(orgId);

        // 권한 목록 가져오기
        List<OrgAuthGrpVO> authGrpList = orgMenuService.listAuthGrp(oagvo).getReturnList();
        
        request.setAttribute("authGrpList", authGrpList);
        request.setAttribute("vo", vo);
                
        return "mgr/popup/system_auth_grp_pop";
    }

    /***************************************************** 
     * @Method Name : orgMenuSortList
     * @Method 설명 : 기관 메뉴의 순서를 업데이트 한다. 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/orgMenuSortList.do")
    public String orgMenuSortList(OrgMenuVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        vo.setAuthrtGrpcd(StringUtil.nvl(vo.getAuthrtGrpcd(),"HOME")); //-- 홈페이지
        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<OrgMenuVO> result = new ProcessResultVO<OrgMenuVO>();
        try {
            orgMenuService.sortMenu(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.menu.sort.update", null, locale));
            //result.setMessage("메뉴 순서를 변경하였습니다.");
        } catch (Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("fail.common.menu.sort.update", null, locale));
            //result.setMessage("메뉴 순서를 변경하지 못하였습니다.");
        }
        return JsonUtil.responseJson(response, result);
    }

    /***************************************************** 
     * @Method Name : sysMenuWrite
     * @Method 설명 : 시스템 관리 > 메뉴 상세 등록 폼
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "mgr/main/system_menu_write.jsp"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/sysMenuWrite.do")
    public String addFormSubMenu(OrgMenuVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        //--추가 및 수정폼 구분코드 (위치가 중요)
        request.setAttribute("gubun", "A");
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        
        String locale = SessionInfo.getLocaleKey(request);
        vo.setAuthrtGrpcd(StringUtil.nvl(vo.getAuthrtGrpcd(),"HOME")); //-- 홈페이지

        String[] langList = StringUtil.split(CommConst.LANG_SUPPORT,"/");
        request.setAttribute("langList", langList);

        //-- 메뉴 아이콘 목록 조회
        List<OrgCodeVO> iconList = orgCodeMemService.getOrgCodeList("MENU_ICON_CD", orgId);
        request.setAttribute("iconList", iconList);

        //-- 해당 메뉴의 정보를 검색해 온다.
        if(!"".equals(StringUtil.nvl(vo.getMenuCd()))) {
            OrgMenuVO orgMenuVO = new OrgMenuVO();
            orgMenuVO.setOrgId(vo.getOrgId());
            orgMenuVO.setAuthrtGrpcd(vo.getAuthrtGrpcd());
            orgMenuVO.setMenuCd(vo.getMenuCd());
            orgMenuVO.setAuthrtCd(vo.getAuthrtCd());
            vo = orgMenuService.viewMenu(orgMenuVO);
            request.setAttribute("gubun", "E");
        }
        
        //-- 상위 메뉴의 정보를 검색해 온다.
        if(!"".equals(StringUtil.nvl(vo.getParMenuCd()))) {
            OrgMenuVO parMenuVO = new OrgMenuVO();
            parMenuVO.setOrgId(vo.getOrgId());
            parMenuVO.setAuthrtGrpcd(vo.getAuthrtGrpcd());
            parMenuVO.setMenuCd(vo.getParMenuCd());
            parMenuVO.setAuthrtCd(vo.getAuthrtCd());
            parMenuVO = orgMenuService.viewMenu(parMenuVO);
            
            String parMenuName = parMenuVO.getMenuNm();

            vo.setParMenuCd(parMenuVO.getMenuCd());
            vo.setParMenuLvl(parMenuVO.getMenuLvl());
            vo.setParMenuNm(parMenuName);
        } else {
            vo.setParMenuNm("ROOT");
        }
        
        request.setAttribute("vo", vo);

        return "mgr/main/system_menu_write";
    }

    /***************************************************** 
     * @Method Name : addMenu
     * @Method 설명 : 메뉴 권한 관리 메뉴를 등록 한다.
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/addMenu.do")
    public String addMenu(OrgMenuVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String userId = StringUtil.nvl(vo.getRgtrId(),SessionInfo.getUserId(request));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        
        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<SysAuthGrpVO> result = new ProcessResultVO<SysAuthGrpVO>();
        try {
            orgMenuService.addMenu(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.menu.insert", null, locale));
            //result.setMessage("메뉴를 등록하였습니다.");
        } catch (Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("fail.common.menu.insert", null, locale));
            //result.setMessage("메뉴를 등록하지 못하였습니다.");
        }
        return JsonUtil.responseJson(response, result);
    }

    /***************************************************** 
     * @Method Name : editMenu
     * @Method 설명 : 메뉴 권한 관리 메뉴를 수정 한다. 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/editMenu.do")
    public String editMenu(OrgMenuVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {

        String userId = StringUtil.nvl(vo.getRgtrId(),SessionInfo.getUserId(request));
        vo.setMdfrId(userId);

        Locale locale = LocaleUtil.getLocale(request);
        

        if(vo.getMenuUrl().contains("pageSn=")) {
            String[] menuUrl = vo.getMenuUrl().split("pageSn=");
            //vo.setMenuUrl(menuUrl[0]+"pageSn="+CryptoUtil.decryptAes256(menuUrl[1]));
        }
        
        ProcessResultVO<SysAuthGrpVO> result = new ProcessResultVO<SysAuthGrpVO>();
        try {
            orgMenuService.editMenu(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.menu.update", null, locale));
            //result.setMessage("메뉴를 수정하였습니다.");
        } catch (Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("fail.common.menu.update", null, locale));
            //result.setMessage("메뉴를 수정하지 못하였습니다.");
        }
        return JsonUtil.responseJson(response, result);
    }
    
    /***************************************************** 
     * @Method Name : removeMenu
     * @Method 설명 : 메뉴 권한 관리 메뉴를 삭제 한다. 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/removeMenu.do")
    public String removeMenu(OrgMenuVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {

        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<SysAuthGrpVO> result = new ProcessResultVO<SysAuthGrpVO>();
        try {
            orgMenuService.removeMenu(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.menu.delete", null, locale));
            //result.setMessage("메뉴를 삭제하였습니다.");
        } catch (Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("fail.common.menu.delete", null, locale));
            //result.setMessage("메뉴를 삭제하지 못하였습니다.");
        }
        return JsonUtil.responseJson(response, result);
    }

    /***************************************************** 
     * @Method Name : editOrgMenuUseYn
     * @Method 설명 : 메뉴 권한 관리 권한을 수정 한다. 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/editOrgMenuUseYn.do")
    public String editOrgMenuUseYn(OrgMenuVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {

        String userId = StringUtil.nvl(vo.getMdfrId(),SessionInfo.getUserId(request));
        Locale locale = LocaleUtil.getLocale(request);
        
        OrgMenuVO orgMenuVo = new OrgMenuVO();
        orgMenuVo.setOrgId(vo.getOrgId());
        orgMenuVo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
        orgMenuVo.setMenuCd(vo.getMenuCd());
        orgMenuVo.setAuthrtCd(vo.getAuthrtCd());
        orgMenuVo = orgMenuService.viewMenu(orgMenuVo);
        
        orgMenuVo.setMdfrId(userId);
        orgMenuVo.setUseYn(StringUtil.nvl(vo.getUseYn(),"Y"));
        ProcessResultVO<OrgMenuVO> result = new ProcessResultVO<OrgMenuVO>();
        try {
            orgMenuService.editMenu(orgMenuVo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.menu.update", null, locale));
            // result.setMessage("메뉴를 수정하였습니다.");
        } catch (Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("fail.common.menu.update", null, locale));
            // result.setMessage("메뉴를 수정하지 못하였습니다.");
        }
        return JsonUtil.responseJson(response, result);
    }
    
    /***************************************************** 
     * @Method Name : saveAuthMenu
     * @Method 설명 : 메뉴 권한 관리 메뉴를 삭제 한다.
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/saveAuthMenu.do")
    public String saveAuthMenu(OrgAuthGrpMenuVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {

        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<SysAuthGrpVO> result = new ProcessResultVO<SysAuthGrpVO>();
        try {
            orgMenuService.addAuthGrpMenu(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.menu.auth.grp.insert", null, locale));
            // result.setMessage("권한그룹 메뉴를 등록하였습니다.");
        } catch (Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("fail.common.menu.auth.grp.insert", null, locale));
            // result.setMessage("권한그룹 메뉴를 등록하지 못하였습니다.");
        }
        return JsonUtil.responseJson(response, result);
    }

    /***************************************************** 
     * @Method Name : addAuthGrp
     * @Method 설명 : 메뉴 권한 관리 권한을 등록 한다.
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/addAuthGrp.do")
    public String addAuthGrp(OrgAuthGrpVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        String userId = StringUtil.nvl(vo.getRgtrId(),SessionInfo.getUserId(request));
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        Locale locale = LocaleUtil.getLocale(request);
        
        String[] langList = StringUtil.split(CommConst.LANG_SUPPORT,"/");
        List<OrgAuthGrpVO> authGrpLangList = new ArrayList<OrgAuthGrpVO>();

        for(int i=0; i<langList.length; i++) {
        	OrgAuthGrpVO oagVO = new OrgAuthGrpVO();
            if("".equals(vo.getAuthrtGrpcd()) || null == vo.getAuthrtGrpcd()) {
                oagVO.setAuthrtGrpcd("HOME");
            }

            oagVO.setAuthrtCd(vo.getAuthrtCd());
            oagVO.setLangCd(langList[i]);
            oagVO.setAuthrtGrpnm(vo.getAuthrtGrpnm());
            oagVO.setAuthrtGrpExpln(vo.getAuthrtGrpnm());
            oagVO.setOrgId(orgId);
            authGrpLangList.add(oagVO);
        }
        vo.setAuthGrpLangList(authGrpLangList);

        ProcessResultVO<OrgAuthGrpVO> result = new ProcessResultVO<OrgAuthGrpVO>();
        try {
            orgMenuService.addAuthGrp(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.auth.insert", null, locale));
            // result.setMessage("권한을 등록하였습니다.");
        } catch(Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("fail.common.auth.insert", null, locale));
            // result.setMessage("권한을 등록하지 못하였습니다.");
        }
        return JsonUtil.responseJson(response, result);
    }

    /***************************************************** 
     * @Method Name : editAuthGrp
     * @Method 설명 : 메뉴 권한 관리 권한을 수정 한다. 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editAuthGrp.do")
    public String editAuthGrp(OrgAuthGrpVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String userId = StringUtil.nvl(vo.getMdfrId(), SessionInfo.getUserId(request));
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        vo.setMdfrId(userId);
        
        Locale locale = LocaleUtil.getLocale(request);
        
        String[] langList = StringUtil.split(CommConst.LANG_SUPPORT,"/");
        List<OrgAuthGrpVO> authGrpLangList = new ArrayList<OrgAuthGrpVO>();
        
        for(int i=0; i < langList.length; i++) {
        	OrgAuthGrpVO oagVO = new OrgAuthGrpVO();
            oagVO.setAuthrtGrpcd(vo.getAuthrtGrpcd());
            oagVO.setAuthrtCd(vo.getAuthrtCd());
            oagVO.setLangCd(langList[i]);
            oagVO.setAuthrtGrpnm(vo.getAuthrtGrpnm());
            oagVO.setOrgId(orgId);
            authGrpLangList.add(oagVO);
        }
        vo.setAuthGrpLangList(authGrpLangList);
        
        ProcessResultVO<OrgAuthGrpVO> result = new ProcessResultVO<OrgAuthGrpVO>();
        try {
            orgMenuService.editAuthGrp(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.auth.update", null, locale));
            // result.setMessage("권한을 수정하였습니다.");
            
        } catch(Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("fail.common.auth.update", null, locale));
            // result.setMessage("권한을 수정하지 못하였습니다.");
        }
        return JsonUtil.responseJson(response, result);
    }
    
    /***************************************************** 
     * @Method Name : editAuthGrpUseYn
     * @Method 설명 : 메뉴 권한 관리 권한을 수정 한다. 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/editAuthGrpUseYn.do")
    public String editAuthGrpUseYn(OrgAuthGrpVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String orgId = SessionInfo.getOrgId(request);
        Locale locale = LocaleUtil.getLocale(request);
        
        String userId = StringUtil.nvl(vo.getMdfrId(),SessionInfo.getUserId(request));
        OrgAuthGrpVO orgAuthGrpVo = new OrgAuthGrpVO();
        orgAuthGrpVo.setOrgId(orgId);
        orgAuthGrpVo.setAuthrtCd(vo.getAuthrtCd());
        orgAuthGrpVo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
        orgAuthGrpVo = orgMenuService.viewAuthGrp(orgAuthGrpVo);
        
        orgAuthGrpVo.setMdfrId(userId);
        orgAuthGrpVo.setUseyn(StringUtil.nvl(vo.getUseyn(),"Y"));
        ProcessResultVO<OrgAuthGrpVO> result = new ProcessResultVO<OrgAuthGrpVO>();
        
        try {
            orgMenuService.editAuthGrp(orgAuthGrpVo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.auth.update", null, locale));
            // result.setMessage("권한을 수정하였습니다.");
            
        } catch(Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("fail.common.auth.update", null, locale));
            // result.setMessage("권한을 수정하지 못하였습니다.");
        }
        return JsonUtil.responseJson(response, result);
    }
    
    /***************************************************** 
     * @Method Name : removeAuthGrp
     * @Method 설명 : 메뉴 권한 관리 권한을 삭제 한다. 
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @param response
     * @return json
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/removeAuthGrp.do")
    public String removeAuthGrp(OrgAuthGrpVO vo, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        Locale locale = LocaleUtil.getLocale(request);
        
        ProcessResultVO<OrgAuthGrpVO> result = new ProcessResultVO<OrgAuthGrpVO>();
        try {
            orgMenuService.removeAuthGrp(vo);
            result.setResult(1);
            result.setMessage(messageSource.getMessage("success.common.auth.delete", null, locale));
            // result.setMessage("권한을 삭제하였습니다.");
            
        } catch(Exception e) {
            result.setResult(-1);
            result.setMessage(messageSource.getMessage("fail.common.auth.delete", null, locale));
            // result.setMessage("권한을 삭제하지 못하였습니다.");
        }
        return JsonUtil.responseJson(response, result);
    }

    /***************************************************** 
     * 복습기간 목록 폼 
     * @param vo
     * @param model
     * @param request
     * @return "mgr/review/review_list_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/reviewListForm.do")
    public String getReviewListForm(CrsSizeMgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
        
        // 학기목록
        List<OrgCodeVO> termList = orgCodeService.list("HAKSA_TERM");
        model.addAttribute("termList", termList);

        TermVO termVO  = new TermVO();
        termVO.setOrgId(orgId);
        List<TermVO> resultList = termService.list(termVO);
        request.setAttribute("creTermList", resultList);
        
        // 현재년도
        LocalDate localDate = LocalDate.now();
        int year = localDate.getYear();
        model.addAttribute("year", year);

        // 기관(학교)목록
        OrgOrgInfoVO orgOrgInfoVO = new OrgOrgInfoVO();
        orgOrgInfoVO.setUseYn("Y");
        List<OrgOrgInfoVO> orgInfoList = orgOrgInfoService.list(orgOrgInfoVO);

        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        model.addAttribute("deptCdList", usrDeptCdService.list(usrDeptCdVO));
        
        model.addAttribute("orgInfoList", orgInfoList);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        return "mgr/review/review_list_form";
    }

    /***************************************************** 
     * 복습기간 목록 조회 
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<ContentsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/reviewList.do")
    public String reviewList(ReviewVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        String crsTypeCds = vo.getCrsTypeCds();
        if(!"".equals(StringUtil.nvl(crsTypeCds))) {
            vo.setCrsTypeCdList(crsTypeCds.split(","));
        }
        
        // 복습기간 목록 전체 보여주기!
        /* 카운트 쿼리의 전체 카운트를 목록으로 출력할경우 딜레이가 심함!
        int reviewCount = reviewDAO.countReviewInfo(vo);
        vo.setListScale(reviewCount);
         */
        int reviewCount = 0;
        reviewCount = reviewDAO.countReviewInfo(vo);
        
        ProcessResultListVO<ReviewVO> returnList = reviewService.reviewListPaging(vo, vo.getPageIndex(), vo.getListScale(), vo.getPageScale());
        request.setAttribute("resultList", returnList.getReturnList());
        request.setAttribute("pageInfo", returnList.getPageInfo());
        request.setAttribute("reviewCount", reviewCount);
        request.setAttribute("vo", vo);
        
        return "mgr/review/review_list";
    }

    /*****************************************************
     * 복습기간설정
     * @param ReviewVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/updateReview.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateReview(ReviewVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        Locale locale = LocaleUtil.getLocale(request);
        
        String userId = SessionInfo.getUserId(request);
        vo.setMdfrId(userId);

        try {
            reviewService.updateReview(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale)); /*에러가 발생했습니다!*/
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 복습기간 목록 엑셀 다운로드
     * @param ExamStareVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelReviewList.do")
    public String downExcelReviewList(ReviewVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 조회조건 
        String[] searchValues = {getMessage("common.search.condition") + " : " + StringUtil.nvl(vo.getSearchValue())};
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        List<EgovMap> list = reviewService.reviewListExcel(vo);
        
        String title = getMessage("review.lecture.list"); // 복습기간목록
         
        // POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        // 엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
     
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);
      
        // 엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }

    /**
     * @Method Name : main
     * @Method 설명 : 수업운영도구 > 강의알리미
     * @param  
     * @param commandMap
     * @param model
     * @return  "lesson/lesson_operate_form.jsp"
     * @throws Exception
     */
    @RequestMapping(value = "/Form/lessonOperate.do")
    public String lessonOperate(LessonOperateVO vo ,ModelMap model, HttpServletRequest request) throws Exception {

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request)); 
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException("페이지 접근 권한이 없습니다.");
        }
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        TermVO termVO  = new TermVO();
        termVO.setOrgId(orgId);
        
        // 현재년도
        LocalDate localDate = LocalDate.now();
        int year = localDate.getYear();
        model.addAttribute("year", year);

        // 학기목록
        List<OrgCodeVO> termList = orgCodeService.list("HAKSA_TERM");
        model.addAttribute("termList", termList);

        // 현재년도 + 학기목록
        List<TermVO> creTermList = termService.list(termVO);
        model.addAttribute("creTermList", creTermList);

        // 기관(학교)목록 
        OrgOrgInfoVO orgOrgInfoVO = new OrgOrgInfoVO();
        orgOrgInfoVO.setUseYn("Y");
        List<OrgOrgInfoVO> orgInfoList = orgOrgInfoService.list(orgOrgInfoVO);
        model.addAttribute("orgInfoList", orgInfoList);
        
        // 부서목록
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        model.addAttribute("deptCdList", usrDeptCdService.list(usrDeptCdVO));

        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항

        return "lesson/lesson_operate_form";
    }
    
    /***************************************************** 
     * @Method Name : lessonOperateList
     * @Method 설명 : 수업운영목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "lesson/lesson_operate_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonOperateList.do")
    public String lessonOperateList(LessonOperateVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        String crsTypeCds = vo.getCrsTypeCds();
        if(!"".equals(StringUtil.nvl(crsTypeCds))) {
            vo.setCrsTypeCdList(crsTypeCds.split(","));
        }
        
        // 수업운영목록 전체 보여주기!
        int operateCount = lessonOperateDAO.count(vo);
        vo.setListScale(operateCount);

        ProcessResultListVO<LessonOperateVO> returnList = lessonOperateService.listPageing(vo, vo.getPageIndex(), vo.getListScale(), vo.getPageScale());
 
        request.setAttribute("resultList", returnList.getReturnList());
        request.setAttribute("pageInfo", returnList.getPageInfo());
        request.setAttribute("count", operateCount);
        request.setAttribute("vo", vo);
        
        return "lesson/lesson_operate_list";
    }
    
    /***************************************************** 
     * @Method Name : lessonAsmntUnratedList
     * @Method 설명 : 과제미제출과목목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "lesson/lesson_operate_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonAsmntNoSubmitList.do")
    public String lessonAsmntNoSubmitList(LessonOperateVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        //  과제미제출과목 목록 전체 보여주기!
        int asmntCount = lessonOperateDAO.countAsmntNoSubmit(vo);
        vo.setListScale(asmntCount);

        ProcessResultListVO<LessonOperateVO> returnList = lessonOperateService.listAsmntNoSubmitPageing(vo, vo.getPageIndex(), vo.getListScale(), vo.getPageScale());
 
        request.setAttribute("resultList", returnList.getReturnList());
        request.setAttribute("pageInfo", returnList.getPageInfo());
        request.setAttribute("count", asmntCount);
        request.setAttribute("vo", vo);
        
        return "lesson/lesson_asmnt_no_submit_list";
    }
    
    /***************************************************** 
     * @Method Name : lessonRecordUnratedList
     * @Method 설명 : 성적미평가과목목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "lesson/lesson_operate_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonScoreUnratedList.do")
    public String lessonScoreUnratedList(LessonOperateVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        // 성적미평가과목 목록 전체 보여주기!
        int scoreCount = lessonOperateDAO.countScoreUnrated(vo);
        vo.setListScale(scoreCount);

        ProcessResultListVO<LessonOperateVO> returnList = lessonOperateService.listScoreUnratedPageing(vo, vo.getPageIndex(), vo.getListScale(), vo.getPageScale());
 
        request.setAttribute("resultList", returnList.getReturnList());
        request.setAttribute("pageInfo", returnList.getPageInfo());
        request.setAttribute("count", scoreCount);
        request.setAttribute("vo", vo);
        
        return "lesson/lesson_score_unrated_list";
    }
    
    /***************************************************** 
     * @Method Name : lessonLoginChiefList
     * @Method 설명 : 로그인경과목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "lesson/lesson_operate_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonLoginChiefList.do")
    public String lessonLoginChiefList(LessonOperateVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        // 교수자, 조교 목록 보여주기!
        int loginCount = lessonOperateDAO.countLoginChief(vo);
        vo.setListScale(loginCount);

        ProcessResultListVO<LessonOperateVO> returnList = lessonOperateService.listLoginChiefPageing(vo, vo.getPageIndex(), vo.getListScale(), vo.getPageScale());
 
        request.setAttribute("resultList", returnList.getReturnList());
        request.setAttribute("pageInfo", returnList.getPageInfo());
        request.setAttribute("count", loginCount);
        request.setAttribute("vo", vo);

        return "lesson/lesson_login_chief_list";
    }
    
    /***************************************************** 
     * @Method Name : lessonLoginLecturelist
     * @Method 설명 : 로그인경과목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "lesson/lesson_operate_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonLoginLecturelist.do")
    public String lessonLoginLecturelist(LessonOperateVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        String userId = StringUtil.nvl(vo.getUserId(), SessionInfo.getUserId(request));
        vo.setUserId(userId);
        
        // 교수자, 조교 목록 보여주기!
        int loginCount = lessonOperateDAO.countLoginLecture(vo);
        vo.setListScale(loginCount);

        ProcessResultListVO<LessonOperateVO> returnList = lessonOperateService.listLoginLecturePageing(vo, vo.getPageIndex(), vo.getListScale(), vo.getPageScale());
 
        request.setAttribute("resultList", returnList.getReturnList());
        request.setAttribute("pageInfo", returnList.getPageInfo());
        request.setAttribute("count", loginCount);
        request.setAttribute("vo", vo);

        return "lesson/lesson_login_lecture_list";
    }
    
    /***************************************************** 
     * @Method Name : lessonLoginAsmntlist
     * @Method 설명 : 로그인경과목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "lesson/lesson_operate_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonLoginAsmntlist.do")
    public String lessonLoginAsmntlist(LessonOperateVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        String userId = StringUtil.nvl(vo.getUserId(), SessionInfo.getUserId(request));
        vo.setUserId(userId);
        
        // 교수자, 조교 목록 보여주기!
        int asmntCount = lessonOperateDAO.countLoginAsmnt(vo);
        vo.setListScale(asmntCount);

        ProcessResultListVO<LessonOperateVO> returnList = lessonOperateService.listLoginAsmntPageing(vo, vo.getPageIndex(), vo.getListScale(), vo.getPageScale());
 
        request.setAttribute("resultList", returnList.getReturnList());
        request.setAttribute("pageInfo", returnList.getPageInfo());
        request.setAttribute("count", asmntCount);
        request.setAttribute("vo", vo);

        return "lesson/lesson_login_asmnt_list";
    }

    /***************************************************** 
     * @Method Name : lessonLoginQuizlist
     * @Method 설명 : 로그인경과목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "lesson/lesson_operate_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonLoginQuizlist.do")
    public String lessonLoginQuizlist(LessonOperateVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        String userId = StringUtil.nvl(vo.getUserId(), SessionInfo.getUserId(request));
        vo.setUserId(userId);
        
        // 교수자, 조교 목록 보여주기!
        int quizCount = lessonOperateDAO.countLoginQuiz(vo);
        vo.setListScale(quizCount);

        ProcessResultListVO<LessonOperateVO> returnList = lessonOperateService.listLoginQuizPageing(vo, vo.getPageIndex(), vo.getListScale(), vo.getPageScale());
 
        request.setAttribute("resultList", returnList.getReturnList());
        request.setAttribute("pageInfo", returnList.getPageInfo());
        request.setAttribute("count", quizCount);
        request.setAttribute("vo", vo);

        return "lesson/lesson_login_quiz_list";
    }

    /***************************************************** 
     * @Method Name : lessonLoginForumlist
     * @Method 설명 : 로그인경과목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "lesson/lesson_operate_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonLoginForumlist.do")
    public String lessonLoginForumlist(LessonOperateVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        String userId = StringUtil.nvl(vo.getUserId(), SessionInfo.getUserId(request));
        vo.setUserId(userId);
        
        // 교수자, 조교 목록 보여주기!
        int forumCount = lessonOperateDAO.countLoginForum(vo);
        vo.setListScale(forumCount);

        ProcessResultListVO<LessonOperateVO> returnList = lessonOperateService.listLoginForumPageing(vo, vo.getPageIndex(), vo.getListScale(), vo.getPageScale());
 
        request.setAttribute("resultList", returnList.getReturnList());
        request.setAttribute("pageInfo", returnList.getPageInfo());
        request.setAttribute("count", forumCount);
        request.setAttribute("vo", vo);

        return "lesson/lesson_login_forum_list";
    }

    /***************************************************** 
     * @Method Name : lessonLoginResearchlist
     * @Method 설명 : 로그인경과목록
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "lesson/lesson_operate_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/lessonLoginResearchlist.do")
    public String lessonLoginResearchlist(LessonOperateVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        String userId = StringUtil.nvl(vo.getUserId(), SessionInfo.getUserId(request));
        vo.setUserId(userId);
        
        // 교수자, 조교 목록 보여주기!
        int researchCount = lessonOperateDAO.countLoginResearch(vo);
        vo.setListScale(researchCount);

        ProcessResultListVO<LessonOperateVO> returnList = lessonOperateService.listLoginResearchPageing(vo, vo.getPageIndex(), vo.getListScale(), vo.getPageScale());
 
        request.setAttribute("resultList", returnList.getReturnList());
        request.setAttribute("pageInfo", returnList.getPageInfo());
        request.setAttribute("count", researchCount);
        request.setAttribute("vo", vo);

        return "lesson/lesson_login_research_list";
    }
   
}
