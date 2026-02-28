package knou.lms.sys.web;

import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.service.OrgOrgInfoService;
import knou.lms.common.vo.OrgOrgInfoVO;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.sys.service.SysCodeService;
import knou.lms.sys.service.SysJobSchExcService;
import knou.lms.sys.service.SysJobSchService;
import knou.lms.sys.vo.SysJobSchExcVO;
import knou.lms.sys.vo.SysJobSchVO;

@Controller
@RequestMapping(value="/jobSchMgr")
public class SysJobSchMgrController extends ControllerBase {

    @Resource(name="sysJobSchService")
    private SysJobSchService sysJobSchService;
    
    @Resource(name="sysJobSchExcService")
    private SysJobSchExcService sysJobSchExcService;
    
    @Resource(name="sysCodeService")
    private SysCodeService sysCodeService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;
    
    @Resource(name="orgOrgInfoService")
    private OrgOrgInfoService orgOrgInfoService;
    
    @Resource(name="termService")
    private TermService termService;
    
    /*****************************************************
     * TODO 업무일정관리 페이지
     * @param SysJobSchVO
     * @return "sys/sch/job_sch_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/jobSchMng.do")
    public String jobSchListForm(SysJobSchVO vo, Model model, HttpServletRequest request) throws Exception {
        Locale locale    = LocaleUtil.getLocale(request);
        String authrtCd  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        if(!authrtCd.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        OrgOrgInfoVO orgOrgInfoVO = new OrgOrgInfoVO();
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("SMSTR_TYCD"));
        model.addAttribute("vo", vo);
        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("orgInfoList", orgOrgInfoService.list(orgOrgInfoVO));

        return "sys/sch/job_sch_list";
    }
    
    /***************************************************** 
     * TODO 업무일정 조회 페이징
     * @param SysJobSchVO 
     * @return ProcessResultVO<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/jobSchListPaging.do")
    @ResponseBody
    public ProcessResultVO<SysJobSchVO> jobSchListPaging(SysJobSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysJobSchVO> resultVO = new ProcessResultVO<SysJobSchVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        vo.setOrgId(orgId);
        try {
            resultVO = sysJobSchService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
    
    /*****************************************************
     * TODO 업무일정 상세정보 팝업
     * @param SysJobSchVO
     * @return "sys/sch/popup/view_job_sch_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewJobSchPop.do")
    public String viewJobSchPop(SysJobSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        vo = sysJobSchService.select(vo);

        request.setAttribute("vo", vo);
        return "sys/sch/popup/view_job_sch_pop";
    }
    
    /***************************************************** 
     * TODO 업무구분 코드 목록 가져오기
     * @param OrgCodeVO 
     * @return ProcessResultVO<OrgCodeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/jobSchCalendarCtgrList.do")
    @ResponseBody
    public ProcessResultVO<OrgCodeVO> jobSchCalendarCtgrList(OrgCodeVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<OrgCodeVO> resultVO = new ProcessResultVO<OrgCodeVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            resultVO.setReturnList(orgCodeService.selectOrgCodeList(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
    
    /*****************************************************
     * TODO 업무일정 등록 페이지
     * @param SysJobSchVO
     * @return "sys/sch/job_sch_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/writeJobSch.do")
    public String writeJobSchForm(SysJobSchVO vo, Model model, HttpServletRequest request) throws Exception {
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        
        
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("SMSTR_TYCD"));
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("orgInfoList", orgOrgInfoService.list(new OrgOrgInfoVO()));
        
        return "sys/sch/job_sch_write";
    }
    
    /***************************************************** 
     * TODO 업무일정 등록
     * @param SysJobSchVO 
     * @return ProcessResultVO<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeJobSch.do")
    @ResponseBody
    public ProcessResultVO<SysJobSchVO> writeJobSch(SysJobSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysJobSchVO> resultVO = new ProcessResultVO<SysJobSchVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setOrgId(orgId);
            
            sysJobSchService.insert(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
    
    /*****************************************************
     * TODO 업무일정 수정 페이지
     * @param SysJobSchVO
     * @return "sys/sch/job_sch_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/editJobSch.do")
    public String editJobSchForm(SysJobSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        String sValue = vo.getSearchValue();
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        vo.setOrgId(orgId);
        vo = sysJobSchService.select(vo);
        
        vo.setSearchValue(sValue);
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        request.setAttribute("termVO", termVO);
        request.setAttribute("vo", vo);
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("SMSTR_CD"));
//        request.setAttribute("orgId", orgId);
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        request.setAttribute("orgInfoList", orgOrgInfoService.list(new OrgOrgInfoVO()));
        
        return "sys/sch/job_sch_write";
    }
    
    /***************************************************** 
     * TODO 업무일정 수정
     * @param SysJobSchVO 
     * @return ProcessResultVO<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editJobSch.do")
    @ResponseBody
    public ProcessResultVO<SysJobSchVO> editJobSch(SysJobSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysJobSchVO> resultVO = new ProcessResultVO<SysJobSchVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setMdfrId(userId);
            sysJobSchService.update(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 업무일정 삭제
     * @param SysJobSchVO 
     * @return ProcessResultVO<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/delJobSch.do")
    @ResponseBody
    public ProcessResultVO<SysJobSchVO> delJobSch(SysJobSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysJobSchVO> resultVO = new ProcessResultVO<SysJobSchVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            sysJobSchService.delete(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
    
    // 업무구분  목록
    @RequestMapping(value="/jobSchCalendarCtgrNmList.do")
    public String  jobSchCalendarCtgrNmList(String orgId, ModelMap map, HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ProcessResultListVO<SysCodeVO> ctgrNmList = sysCodeService.jobSchCalendarCtgrNmList(orgId);
        ProcessResultListVO<OrgCodeVO> scheduleList = orgCodeService.listCode(orgId, "TASK_SCHDL_TYCD");
//        		sysJobSchService.jobSchCalendarCtgrNmList(orgId);
        
        return JsonUtil.responseJson(response, scheduleList);
    }
    
    /***************************************************** 
     * TODO 업무일정 예외 삭제
     * @param SysJobSchExcVO 
     * @return ProcessResultVO<SysJobSchExcVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deleteSysJobSchExc.do")
    @ResponseBody
    public ProcessResultVO<SysJobSchExcVO> deleteSysJobSchExc(SysJobSchExcVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysJobSchExcVO> resultVO = new ProcessResultVO<SysJobSchExcVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setUserId(userId);
            if(!"".equals(StringUtil.nvl(vo.getExcpIdStr()))) {
                String[] excList = vo.getExcpIdStr().split(",");
                for(String exc : excList) {
                    vo.setSysjobSchdlExcpId(exc.split("\\|")[0]);
                    vo.setCrsCreCd(exc.split("\\|")[1]);
                    sysJobSchExcService.delete(vo);
                }
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO ERP 업무일정 연동
     * @param SysJobSchVO 
     * @return ProcessResultVO<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/getErpSch.do")
    @ResponseBody
    public ProcessResultVO<SysJobSchVO> getErpSch(SysJobSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysJobSchVO> resultVO = new ProcessResultVO<SysJobSchVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        vo.setOrgId(orgId);
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        
        try {
            sysJobSchService.getEepLink(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("sch.alert.erp.sch.link.n", null, locale));/* ERP 업무일정 연동 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
}
