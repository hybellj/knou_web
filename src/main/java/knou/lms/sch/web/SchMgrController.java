package knou.lms.sch.web;

import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.service.OrgOrgInfoService;
import knou.lms.common.vo.OrgOrgInfoVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.service.AcadSchService;
import knou.lms.dashboard.vo.AcadSchVO;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.sch.service.PopupNoticeService;
import knou.lms.sch.service.SchCalendarService;
import knou.lms.sch.vo.PopupNoticeVO;
import knou.lms.sch.vo.SchCalendarVO;

@Controller
@RequestMapping(value = "/sch/schMgr")
public class SchMgrController extends ControllerBase {
    
    private static final Logger LOGGER = LoggerFactory.getLogger(SchMgrController.class);

	@Resource(name = "schCalendarService")
	private SchCalendarService schCalendarService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    @Resource(name="termService")
    private TermService termService;
    
    @Resource(name = "orgOrgInfoService")
    private OrgOrgInfoService orgOrgInfoService;
    
    @Resource(name = "acadSchService")
    private AcadSchService acadSchService;
    
    @Resource(name = "popupNoticeService")
    private PopupNoticeService popupNoticeService;
    
    @Resource(name = "orgCodeService")
    private OrgCodeService orgCodeService;
	
	// 수업일정관리 캘린더
	@RequestMapping(value="/Form/schCalendar.do")
	public String schCalendar(SchCalendarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        ProcessResultVO<SchCalendarVO> resultVO = new ProcessResultVO<>();
        vo.setUserId(userId);
        if(!"".equals(menuType)) {
            String[] userTypes = "|".equals(menuType.substring(0,1)) ? menuType.substring(1).split("\\|") : menuType.split("\\|");
            vo.setUserTypes(userTypes);
       }
        resultVO = schCalendarService.listCalendar(vo);
        
        model.addAttribute("calendarList", resultVO.getReturnList());
        model.addAttribute("curYear", DateTimeUtil.getCurrentDateText().substring(0, 4));
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "sch/mgr/sch_calendar";
	}

	// 일정 조회
	@RequestMapping(value = "/schCalendarList.do")
	@ResponseBody
	public ProcessResultVO<SchCalendarVO> schCalendarList(SchCalendarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId    = StringUtil.nvl(SessionInfo.getOrgId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        String[] userTypes = menuType.split("\\|");
        
        String classUserType = menuType.contains("USR") ? "USR" : "PROF";
        String searchMenu = menuType.contains("USR") ? "USR" : "PROF";
		
        ProcessResultVO<SchCalendarVO> resultVO = new ProcessResultVO<>();
        try {
            vo.setUserTypes(userTypes);
            vo.setClassUserTypeGubun(classUserType);
            vo.setSearchMenu(searchMenu);
            vo.setUserId(StringUtil.nvl(userId, ""));
            vo.setOrgId(orgId);
            resultVO = schCalendarService.listSchedule(vo);
            
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
	}
	
	// 일정 등록 팝업
	@RequestMapping(value="/writeSchPop.do")
	public String writeSchPop(SchCalendarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId    = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        OrgOrgInfoVO orgOrgInfoVO = new OrgOrgInfoVO();
        
        AcadSchVO acadSchVO = new AcadSchVO();
        acadSchVO.setSchStartDt(StringUtil.nvl(vo.getStartFmt()));
        acadSchVO.setSchEndDt(StringUtil.nvl(vo.getEndFmt()));
        
        model.addAttribute("vo", acadSchVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("orgInfoList", orgOrgInfoService.list(orgOrgInfoVO));
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("userId", userId);
        model.addAttribute("orgId", orgId);
        
        return "sch/popup/sch_write";
	}
	
	// 일정 등록
	@RequestMapping(value = "/writeSch.do")
	@ResponseBody
	public ProcessResultVO<AcadSchVO> writeSch(AcadSchVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<AcadSchVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
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
	
	// 일정 수정 팝업
	@RequestMapping(value = "/editSchPop.do")
    public String editSchPop(AcadSchVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId    = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        OrgOrgInfoVO orgOrgInfoVO = new OrgOrgInfoVO();
        
        vo = acadSchService.select(vo);
        
        model.addAttribute("vo", vo);
        model.addAttribute("termVO", termVO);
        model.addAttribute("orgInfoList", orgOrgInfoService.list(orgOrgInfoVO));
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("userId", userId);
        
        return "sch/popup/sch_write";
    }
	
	// 일정 수정
	@RequestMapping(value = "/editSch.do")
    @ResponseBody
    public ProcessResultVO<AcadSchVO> editSch(AcadSchVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<AcadSchVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));
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

	// 일정 삭제
	@RequestMapping(value = "/delSch.do")
    @ResponseBody
    public ProcessResultVO<AcadSchVO> delSch(AcadSchVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<AcadSchVO> resultVO = new ProcessResultVO<>();
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
	
	// 일정 조회 페이징
    @RequestMapping(value = "/schListPaging.do")
    @ResponseBody
    public ProcessResultVO<SchCalendarVO> schListPaging(SchCalendarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SchCalendarVO> resultVO = new ProcessResultVO<>();
        try {
            resultVO = schCalendarService.listPaging(vo);
            
            resultVO.setResult(1);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    /***************************************************** 
     * 일정관리 > 팝업관리 목록 이동
     * @param vo
     * @param model
     * @param request
     * @return "sch/mgr/popup_notice_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/popupNoticeList.do")
    public String popupNoticeListForm(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String orgId = SessionInfo.getOrgId(request);
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }
        
        // 팝업대상
        List<OrgCodeVO> popTargetCdList = orgCodeService.selectOrgCodeList("POP_TRGTCD");
        
        model.addAttribute("popTargetCdList", popTargetCdList);
        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "sch/mgr/popup_notice_list";
    }
    
    /***************************************************** 
     * 일정관리 > 팝업관리 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listPopupNotice.do")
    @ResponseBody
    public ProcessResultVO<PopupNoticeVO> listPopupNotice(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNoticeVO> resultVO = new ProcessResultVO<>();
        
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
        	throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }
        
        try {
        	
        	String orgId = SessionInfo.getOrgId(request);
        	String pagingYn = StringUtil.nvl(vo.getPagingYn());
        	String popTargetCd = vo.getPopupNtcTrgtCd();

            vo.setOrgId(orgId);
            
            if(ValidationUtils.isNotEmpty(popTargetCd)) {
                vo.setPopupNtcTrgtCdList(popTargetCd.split(","));
            }
            
            if("Y".equals(pagingYn)) {
                resultVO = popupNoticeService.listPaging(vo);
            } else {
                List<PopupNoticeVO> list = popupNoticeService.list(vo);
                resultVO.setReturnList(list);
            }
            
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }
    
    /***************************************************** 
     * 일정관리 > 팝업관리 목록 이동
     * @param vo
     * @param model
     * @param request
     * @return "sch/popup/popup_notice_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/popupNoticeWritePop.do")
    public String popupNoticeWritePop(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        String orgId = SessionInfo.getOrgId(request);
        String popupNtcId = vo.getPopupNtcId();
        String popupNtcTycd = vo.getPopupNtcTycd();

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }
        
        if(ValidationUtils.isEmpty(popupNtcTycd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        
        vo.setOrgId(orgId);
        
        PopupNoticeVO popupNoticeVO = null;
        
        if(ValidationUtils.isNotEmpty(popupNtcId)) {
            popupNoticeVO = popupNoticeService.select(vo);
            
            if(popupNoticeVO == null) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
        }
        
        // 팝업대상
        List<OrgCodeVO> popTargetCdList = orgCodeService.selectOrgCodeList("POP_TARGET_CD");
        
        model.addAttribute("popupNoticeVO", popupNoticeVO);
        model.addAttribute("popTargetCdList", popTargetCdList);
        model.addAttribute("vo", vo);
        
        return "sch/popup/popup_notice_write";
    }
    
    /***************************************************** 
     * 일정관리 > 팝업관리 미리보기
     * @param vo
     * @param model
     * @param request
     * @return "sch/popup/popup_notice_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/popupNoticePreviewPop.do")
    public String popupNoticePreviewPop(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        String orgId = SessionInfo.getOrgId(request);
        String popNoticeSn = vo.getPopupNtcId();

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }
        
        if(ValidationUtils.isEmpty(popNoticeSn)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        
        vo.setOrgId(orgId);
        
        PopupNoticeVO popupNoticeVO = popupNoticeService.select(vo);
            
        if(popupNoticeVO == null) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        
        if("EVAL".equals(popupNoticeVO.getPopupNtcId())) {
            model.addAttribute("lectEvalPopUrl", CommConst.LECT_EVAL_POP_URL);
        }
        
        model.addAttribute("popupNoticeVO", popupNoticeVO);
        model.addAttribute("vo", vo);
        model.addAttribute("pageType", "PREVIEW");
        
        return "sch/popup/popup_notice_view";
    }
    
    /***************************************************** 
     * 일정관리 > 팝업관리 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectPopupNotice.do")
    @ResponseBody
    public ProcessResultVO<PopupNoticeVO> selectPopupNotice(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNoticeVO> resultVO = new ProcessResultVO<>();
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        String orgId = SessionInfo.getOrgId(request);
        String popNoticeSn = vo.getPopupNtcId();
        
        try {
            // 페이지 접근 권한 체크
            if(!("Y".equals(admYn))) {
                throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
            }
            
            if(ValidationUtils.isEmpty(popNoticeSn)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            
            vo.setOrgId(orgId);
           
            resultVO.setReturnVO(popupNoticeService.select(vo));
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 일정관리 > 팝업관리 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/insertPopupNotice.do")
    @ResponseBody
    public ProcessResultVO<PopupNoticeVO> insertPopupNotice(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNoticeVO> resultVO = new ProcessResultVO<>();
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        String orgId = SessionInfo.getOrgId(request);
        String userAcntId = SessionInfo.getUserRprsId(request);
        
        try {
            // 페이지 접근 권한 체크
            if(!("Y".equals(admYn))) {
                throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
            }
            
            vo.setOrgId(orgId);
            vo.setMdfrId(userAcntId);
            vo.setRgtrId(userAcntId);
           
            popupNoticeService.insert(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 일정관리 > 팝업관리 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updatePopupNotice.do")
    @ResponseBody
    public ProcessResultVO<PopupNoticeVO> updatePopupNotice(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNoticeVO> resultVO = new ProcessResultVO<>();
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            // 페이지 접근 권한 체크
            if(!("Y".equals(admYn))) {
                throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
            }
            
            vo.setOrgId(orgId);
            vo.setMdfrId(userId);
            
            popupNoticeService.update(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 일정관리 > 팝업관리 사용여부 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateUseYnPopupNotice.do")
    @ResponseBody
    public ProcessResultVO<PopupNoticeVO> updateUseYn(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNoticeVO> resultVO = new ProcessResultVO<>();
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        
        try {
            // 페이지 접근 권한 체크
            if(!("Y".equals(admYn))) {
                throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
            }
            
            vo.setOrgId(orgId);
            vo.setMdfrId(userId);
            
            popupNoticeService.updateUseYn(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 일정관리 > 팝업관리 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deletePopupNotice.do")
    @ResponseBody
    public ProcessResultVO<PopupNoticeVO> deletePopupNotice(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNoticeVO> resultVO = new ProcessResultVO<>();
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            // 페이지 접근 권한 체크
            if(!("Y".equals(admYn))) {
                throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
            }
            
            vo.setOrgId(orgId);
            
            popupNoticeService.delete(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
}
