package knou.lms.schedule.web;

import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.IdPrefixType;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.IdGenUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.dto.CalendarDTO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.common.service.OrgOrgInfoService;
import knou.lms.common.vo.BlankVO;
import knou.lms.common.vo.OrgOrgInfoVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.service.AcadSchService;
import knou.lms.dashboard.vo.AcadSchVO;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.schedule.service.CalendarService;
import knou.lms.schedule.service.PopupNoticeService;
import knou.lms.schedule.vo.CalendarVO;
import knou.lms.schedule.vo.ClassScheduleVO;
import knou.lms.schedule.vo.PopupNoticeVO;
import knou.lms.subject.service.SubjectService;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value = "/schedule")
public class MyScheduleController extends ControllerBase {
    
    private static final Logger log = LoggerFactory.getLogger(MyScheduleController.class);

	//@Resource(name = "calendarService")
	//private CalendarService calendarService;
	
	@Resource(name = "calendarService")
	private CalendarService calendarService;
    
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
    
    @Resource(name="subjectService")
    private SubjectService subjectService;
	
	// 수업일정목록조회화면
	@RequestMapping(value="/myScheduleListView.do")
	public String myScheduleListView(CalendarVO calVo, @CurrentUser UserContext userCtx
			, ModelMap model, HttpServletRequest request) throws Exception {	
		SubjectDTO sbjctDto = new SubjectDTO(calVo);
		model.addAttribute("vo", subjectService.subjectSelect(sbjctDto));
		model.addAttribute("userCtx", userCtx);
		log.info(calVo.toString());		
	    return "schedule/calendar";	 
	}

	// 수업일정목록조회
	@RequestMapping(value="/myScheduleList.do")
	@ResponseBody
	public ResultDTO<EgovMap> myScheduleList(BlankVO bvo, CalendarDTO calDto, @CurrentUser UserContext userCtx
			, ModelMap model, HttpServletRequest request) throws Exception {
		
		CalendarDTO cDto = setDefaultDate(calDto);
		//cDto.setSbjctId(bvo.getSbjctId()); // TODO: 다시 테스트 필요
		cDto.setUserId(userCtx.getLoginUser().getUserId());
		
		log.info(cDto.toString());        
		
        return new ResultDTO<EgovMap>().setReturnList(calendarService.myScheduleList(userCtx, cDto)).setResultSuccess();
	}
	
	// 수업일정수정
	@RequestMapping(value="/profClassScheduleModify.do")
	@ResponseBody
	public ResultDTO<Void> profClassScheduleModify(BlankVO bvo, @Valid ClassScheduleVO classScheduleVO, @CurrentUser UserContext userCtx
			, ModelMap model, HttpServletRequest request) throws Exception {
		
		log.info(classScheduleVO.toString());
		
		classScheduleVO.setMdfrId(userCtx.getLoginUser().getUserId());
		
		int successCnt = calendarService.profClassScheduleModify(classScheduleVO);  
		
		return new ResultDTO<Void>().setSuccessCount(successCnt);
	}
	
	// 수업일정삭제
	@RequestMapping(value="/profClassScheduleDelete.do")
	@ResponseBody
	public ResultDTO<Void> profClassScheduleDelete(BlankVO bvo, ClassScheduleVO classScheduleVO, @CurrentUser UserContext userCtx
			, ModelMap model, HttpServletRequest request) throws Exception {		
		int successCnt = calendarService.profClassScheduleDelete(classScheduleVO);    	
    	return new ResultDTO<Void>().setSuccessCount(successCnt);
	}
	
	// 수업일정등록
	@RequestMapping(value="/profClassScheduleRegist.do")
	@ResponseBody
	public ResultDTO<Void> profClassScheduleRegist(BlankVO bvo, @Valid ClassScheduleVO classScheduleVO, @CurrentUser UserContext userCtx
			, ModelMap model, HttpServletRequest request) throws Exception {
		
		classScheduleVO.setClasSchdlId(IdGenUtil.genNewId(IdPrefixType.SBCSC));
		
		classScheduleVO.setRgtrId(userCtx.getLoginUser().getUserId());
		
		log.info(classScheduleVO.toString());
		
		int successCnt = calendarService.profClassScheduleRegist(classScheduleVO);  
		
		return new ResultDTO<Void>().setSuccessCount(successCnt);
	}
		
	
	private CalendarDTO setDefaultDate(CalendarDTO calDto) {
		
		// 1. null이면 새 객체 생성, 아니면 기존 객체 사용
	    CalendarDTO result = (calDto != null) ? calDto : new CalendarDTO();

	    // 2. 기본 뷰 타입 설정
	    if (result.getViewTycd() == null) {
	        result.setViewTycd("VIEW_MONTH");
	    }

	    // 3. 날짜 계산 기준일 설정 (기존 값 있으면 파싱, 없으면 오늘)
	    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
	    LocalDateTime base = (result.getStartDttm() != null) 
	            ? LocalDateTime.parse(result.getStartDttm(), fmt) 
	            : LocalDateTime.now();

	    boolean isMonth = "VIEW_MONTH".equals(result.getViewTycd());

	    // 4. 시작일시 설정 (00:00:00)
	    if (result.getStartDttm() == null) {
	        LocalDateTime start = isMonth ? base.withDayOfMonth(1) 
	                : base.with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));
	        result.setStartDttm(start.withHour(0).withMinute(0).withSecond(0).format(fmt));
	    }

	    // 5. 종료일시 설정 (23:59:59)
	    if (result.getEndDttm() == null) {
	        LocalDateTime end = isMonth ? base.with(TemporalAdjusters.lastDayOfMonth()) 
	                : base.with(TemporalAdjusters.nextOrSame(DayOfWeek.SATURDAY));
	        result.setEndDttm(end.withHour(23).withMinute(59).withSecond(59).format(fmt));
	    }

	    return result;
	}

	// 일정 등록 팝업
	@RequestMapping(value="/writeSchPop.do")
	public String writeSchPop(CalendarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
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
        
        return "schedule/schedule_write";
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
	@RequestMapping(value = "/scheduleModifyPopView.do")
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
        
        return "schedule/schedule_modify";
    }
	
	// 일정 수정
	@RequestMapping(value = "/scheduleModify.do")
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
	@RequestMapping(value = "/scheduleDelete.do")
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
	
	// 일정목록조회페이징
    @RequestMapping(value = "/scheduleListPaging.do")
    @ResponseBody
    public ProcessResultVO<CalendarVO> schListPaging(CalendarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CalendarVO> resultVO = new ProcessResultVO<>();
        try {
            resultVO = calendarService.listPaging(vo);
            
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
            log.error("e: ", e);
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
    
    /***************************************************** 
     * 일정관리 > 팝업관리 미리보기
     * @param vo
     * @param model
     * @param request
     * @return "sch/popup/popup_notice_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/popupNoticeViewPop.do")
    public String popupNoticeViewPop(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String orgId = SessionInfo.getOrgId(request);
        String popNoticeSn = vo.getPopupNtcId();

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
            model.addAttribute("lectEvalPopUrl", vo.getLectEvalUrl());
        }
        
        model.addAttribute("popupNoticeVO", popupNoticeVO);
        model.addAttribute("vo", vo);
        
        return "sch/popup/popup_notice_view";
    }
    
    /***************************************************** 
     * 일정관리 > 활성 팝업 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectActivePop.do")
    @ResponseBody
    public ProcessResultVO<PopupNoticeVO> selectActivePop(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNoticeVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
           
            resultVO.setReturnVO(popupNoticeService.selectAcitvePop(request, vo));
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
