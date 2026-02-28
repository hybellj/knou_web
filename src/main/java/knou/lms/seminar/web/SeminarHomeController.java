package knou.lms.seminar.web;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.lesson.service.LessonCntsService;
import knou.lms.lesson.service.LessonScheduleService;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.seminar.api.cloudrecording.vo.RecordingVO;
import knou.lms.seminar.api.users.vo.UsersInfoVO;
import knou.lms.seminar.service.SeminarAtndService;
import knou.lms.seminar.service.SeminarHstyService;
import knou.lms.seminar.service.SeminarLogService;
import knou.lms.seminar.service.SeminarService;
import knou.lms.seminar.service.SeminarTokenService;
import knou.lms.seminar.service.ZoomApiService;
import knou.lms.seminar.vo.SeminarAtndVO;
import knou.lms.seminar.vo.SeminarLogVO;
import knou.lms.seminar.vo.SeminarVO;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;

@Controller
@RequestMapping(value="/seminar/seminarHome")
public class SeminarHomeController extends ControllerBase {
    
    @Resource(name="seminarService")
    private SeminarService seminarService;
    
    @Resource(name="seminarAtndService")
    private SeminarAtndService seminarAtndService;
    
    @Resource(name="seminarHstyService")
    private SeminarHstyService seminarHstySerivce;
    
    @Resource(name="seminarLogService")
    private SeminarLogService seminarLogService;
    
    @Resource(name="crecrsService")
    private CrecrsService crecrsService;
    
    @Resource(name="lessonScheduleService")
    private LessonScheduleService lessonScheduleService;
    
    @Resource(name="termService")
    private TermService termService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    @Resource(name="stdService")
    private StdService stdService;
    
    @Resource(name="zoomApiService")
    private ZoomApiService zoomApiService;
    
    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;
    
    @Resource(name="seminarTokenService")
    private SeminarTokenService seminarTokenService;
    
    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;
    
    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;
    
    @Resource(name="lessonCntsService")
    private LessonCntsService lessonCntsService;
    
    @Resource(name="sysFileService")
    private SysFileService sysFileService;
    
    /***************************************************** 
     * TODO 세미나 목록 페이지
     * @param SeminarVO
     * @return "seminar/seminar_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/seminarList.do")
    public String seminarListForm(SeminarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd  = vo.getCrsCreCd();
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("userId", userId);
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", crsCreCd);
        
        return "seminar/seminar_list";
    }
    
    /***************************************************** 
     * TODO 세미나 정보
     * @param SeminarVO 
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewSeminar.do")
    @ResponseBody
    public ProcessResultVO<SeminarVO> viewSeminar(SeminarVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarVO> resultVO = new ProcessResultVO<SeminarVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setUserId(userId);
            SeminarVO seminarVO = seminarService.select(vo);
            resultVO.setReturnVO(seminarVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("seminar.error.info", null, locale));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 세미나 목록 페이징
     * @param SeminarVO 
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/seminarList.do")
    @ResponseBody
    public ProcessResultVO<SeminarVO> seminarList(SeminarVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarVO> resultVO = new ProcessResultVO<SeminarVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            List<SeminarVO> seminarList = seminarService.list(vo);
            resultVO.setReturnList(seminarList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("seminar.error.list", null, locale));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 세미나 목록 페이징
     * @param SeminarVO 
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/seminarListPaging.do")
    @ResponseBody
    public ProcessResultVO<SeminarVO> seminarListPaging(SeminarVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarVO> resultVO = new ProcessResultVO<SeminarVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            resultVO = seminarService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("seminar.error.list", null, locale));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 세미나 등록 페이지
     * @param SeminarVO
     * @return "seminar/seminar_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/seminarWrite.do")
    public String seminarWriteForm(SeminarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd  = vo.getCrsCreCd();
        
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.select(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);
        
        creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        List<CreCrsVO> declsList = crecrsService.listCreCrsDeclsNoByTch(creCrsVO);
        request.setAttribute("declsList", declsList);
        creCrsVO = crecrsService.selectTchCreCrs(creCrsVO);
        try {
            // 담당 교수 ZOOM 계정 보유 여부 체크
            UsersInfoVO uuivo = zoomApiService.selectUser(creCrsVO.getUserId()+"@hycu.ac.kr");
            request.setAttribute("authYn", uuivo != null ? "Y" : "N");
        } catch(Exception e) {
            request.setAttribute("authYn", "N");
        }
        request.setAttribute("vo", vo);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", crsCreCd);
        request.setAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        
        return "seminar/seminar_write";
    }
    
    /***************************************************** 
     * TODO 세미나 등록
     * @param SeminarVO 
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeSeminar.do")
    @ResponseBody
    public ProcessResultVO<SeminarVO> writeSeminar(SeminarVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarVO> resultVO = new ProcessResultVO<SeminarVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        try {
            if(!"free".equals(StringUtil.nvl(vo.getSeminarCtgrCd()))) {
                int seminarCnt = seminarService.countBySchedule(vo);
                if(seminarCnt > 0) {
                    resultVO.setResult(-1);
                    resultVO.setMessage("세미나가 등록되어 있습니다.");
                    return resultVO;
                }
                if(!"".equals(StringUtil.nvl(vo.getLessonScheduleId()))) {
                    LessonScheduleVO lsVO = new LessonScheduleVO();
                    lsVO.setLessonScheduleId(vo.getLessonScheduleId());
                    lsVO.setCrsCreCd(vo.getCrsCreCd());
                    lsVO = lessonScheduleService.select(lsVO);
                    String wekClsfGbn = StringUtil.nvl(lsVO.getWekClsfGbn());
                    if(!"02".equals(wekClsfGbn) && !"03".equals(wekClsfGbn)) {
                        resultVO.setResult(-1);
                        resultVO.setMessage("세미나 등록 불가능합니다. 다른 주차를 선택해주세요.");
                        return resultVO;
                    }
                }
            }
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            seminarService.insertSeminar(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("seminar.error.insert", null, locale));/* 저장 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO ZOOM 개설 API 호출
     * @param SeminarVO 
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeZoom.do")
    @ResponseBody
    public ProcessResultVO<SeminarVO> writeZoom(SeminarVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<SeminarVO> resultVO = new ProcessResultVO<SeminarVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setUserId(userId);
            vo.setOrgId(orgId);
            // 줌 회의 등록
            SeminarVO seminarVO = zoomApiService.insertMeeting(vo);
            resultVO.setReturnVO(seminarVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("seminar.error.insert", null, locale));/* 저장 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 세미나 수정 페이지
     * @param SeminarVO
     * @return "seminar/seminar_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/seminarEdit.do")
    public String seminarEditForm(SeminarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd  = vo.getCrsCreCd();
        
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        List<CreCrsVO> declsList = crecrsService.listCreCrsDeclsNoByTch(creCrsVO);
        request.setAttribute("declsList", declsList);
        creCrsVO = crecrsService.selectTchCreCrs(creCrsVO);
        try {
            // 담당 교수 ZOOM 계정 보유 여부 체크
            UsersInfoVO uuivo = zoomApiService.selectUser(creCrsVO.getUserId()+"@hycu.ac.kr");
            request.setAttribute("authYn", uuivo != null ? "Y" : "N");
        } catch(Exception e) {
            request.setAttribute("authYn", "N");
        }
        
        CreCrsVO cvo = new CreCrsVO();
        cvo.setCrsCreCd(crsCreCd);
        cvo = crecrsService.select(cvo);
        request.setAttribute("creCrsVO", cvo);
        
        SeminarVO seminarVO = seminarService.select(vo);
        request.setAttribute("vo", seminarVO);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", crsCreCd);
        request.setAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        
        return "seminar/seminar_write";
    }
    
    /***************************************************** 
     * TODO 세미나 수정
     * @param SeminarVO 
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editSeminar.do")
    @ResponseBody
    public ProcessResultVO<SeminarVO> editSeminar(SeminarVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarVO> resultVO = new ProcessResultVO<SeminarVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        try {
            if(!"free".equals(StringUtil.nvl(vo.getSeminarCtgrCd()))) {
                int seminarCnt = seminarService.countBySchedule(vo);
                if(seminarCnt > 0) {
                    resultVO.setResult(-1);
                    resultVO.setMessage("세미나가 등록되어 있습니다.");
                    return resultVO;
                }
            }
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            seminarService.updateSeminar(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("seminar.error.update", null, locale));/* 수정 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 주차 세미나 개설 여부 조회
     * @param SeminarVO 
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/seminarCntBySchedule.do")
    @ResponseBody
    public ProcessResultVO<SeminarVO> seminarCntBySchedule(SeminarVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarVO> resultVO = new ProcessResultVO<SeminarVO>();
        Locale locale   = LocaleUtil.getLocale(request);
        String crsCreCd = vo.getCrsCreCd();
        
        try {
            vo.setCrsCreCd(crsCreCd);
            int seminarCnt = seminarService.countBySchedule(vo);
            if(seminarCnt > 0) {
                LessonScheduleVO lsvo = new LessonScheduleVO();
                lsvo.setLessonScheduleId(vo.getLessonScheduleId());
                lsvo.setCrsCreCd(crsCreCd);
                lsvo = lessonScheduleService.select(lsvo);
                resultVO.setResult(-1);
                resultVO.setMessage(StringUtil.nvl(lsvo.getLessonScheduleOrder())+"주차에 이미 세미나가 개설되어 있습니다.");
                return resultVO;
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 세미나 삭제
     * @param SeminarVO 
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/delSeminar.do")
    @ResponseBody
    public ProcessResultVO<SeminarVO> delSeminar(SeminarVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarVO> resultVO = new ProcessResultVO<SeminarVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        try {
            vo.setUserId(userId);
            vo.setOrgId(orgId);
            seminarService.deleteSeminar(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("seminar.error.delete", null, locale));/* 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 이전 세미나 가져오기 팝업
     * @param SeminarVO
     * @return "seminar/popup/seminar_copy_list_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/seminarCopyListPop.do")
    public String seminarCopyListPop(SeminarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        request.setAttribute("vo", vo);
        TermVO termVO = new TermVO();
        termVO.setUserId(SessionInfo.getUserId(request));
        termVO.setSearchKey(authGrpCd.contains("TUT") ? "ASSISTANT" : "PROF");
        if(menuType.contains("ADM") && !menuType.contains("PROF")) termVO.setSearchKey(null);
        request.setAttribute("creYearList", termService.listCreYearByProf(termVO));
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        
        return "seminar/popup/seminar_copy_list_pop";
    }
    
    /***************************************************** 
     * 세미나 출결관리 페이지
     * @param SeminarVO
     * @return "seminar/seminar_attend_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/seminarAttendManage.do")
    public String seminarAttemdManage(SeminarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd  = vo.getCrsCreCd();
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.select(creCrsVO);
        
        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("vo", seminarService.select(vo));
        model.addAttribute("userId", userId);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", crsCreCd);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        
        return "seminar/seminar_attend_manage";
    }
    
    /***************************************************** 
     * TODO 세미나 수강생 목록
     * @param SeminarAtndVO 
     * @return ProcessResultVO<SeminarAtndVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/seminarStdList.do")
    @ResponseBody
    public ProcessResultVO<SeminarAtndVO> seminarStdList(SeminarAtndVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarAtndVO> resultVO = new ProcessResultVO<SeminarAtndVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        try {
            vo.setOrgId(orgId);
            List<SeminarAtndVO> stdList = seminarAtndService.listStd(vo);
            resultVO.setReturnList(stdList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("seminar.error.list", null, locale));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 세미나 수강생 정보
     * @param SeminarAtndVO 
     * @return ProcessResultVO<SeminarAtndVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/seminarStdView.do")
    @ResponseBody
    public ProcessResultVO<SeminarAtndVO> seminarStdView(SeminarAtndVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarAtndVO> resultVO = new ProcessResultVO<SeminarAtndVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            vo = seminarAtndService.selectStd(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("seminar.error.info", null, locale));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 세미나 수강생 출결 변경 로그 목록
     * @param SeminarLogVO 
     * @return ProcessResultVO<SeminarLogVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/seminarStdAttendLog.do")
    @ResponseBody
    public ProcessResultVO<SeminarLogVO> seminarStdAttendLog(SeminarLogVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarLogVO> resultVO = new ProcessResultVO<SeminarLogVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            List<SeminarLogVO> logList = seminarLogService.list(vo);
            resultVO.setReturnList(logList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("seminar.error.list", null, locale));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 세미나 출결 상세 팝업
     * @param SeminarVO
     * @return "seminar/popup/seminar_copy_list_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/seminarAttendStatPop.do")
    public String seminarAttendStatPop(SeminarAtndVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        Locale locale   = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        
        SeminarVO seminarVO = new SeminarVO();
        seminarVO.setSeminarId(vo.getSeminarId());
        seminarVO = seminarService.select(seminarVO);
        
        SeminarAtndVO atndVO = seminarAtndService.selectStd(vo);
        List<FileVO> fileList = null;
        if(ValidationUtils.isNotEmpty(atndVO.getSeminarAtndId())) {
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("SEMINAR");
            fileVO.setFileBindDataSn(atndVO.getSeminarAtndId());
            ProcessResultVO<FileVO> resultVO = (ProcessResultVO<FileVO>) sysFileService.list(fileVO);
            fileList = resultVO.getReturnList();
        }
        
        model.addAttribute("vo", vo);
        model.addAttribute("seminarVO", seminarVO);
        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("atndVO", atndVO);
        model.addAttribute("fileList", fileList);
        
        return "seminar/popup/seminar_attend_stat_pop";
    }
    
    /***************************************************** 
     * TODO 세미나 수강생 출결 정보 변경
     * @param SeminarAtndVO 
     * @return ProcessResultVO<SeminarAtndVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/seminarAtndEdit.do")
    @ResponseBody
    public ProcessResultVO<SeminarAtndVO> seminarAtndEdit(SeminarAtndVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarAtndVO> resultVO = new ProcessResultVO<SeminarAtndVO>();
        Locale locale    = LocaleUtil.getLocale(request);
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            seminarAtndService.update(vo);
            resultVO.setResult(1);
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("seminar.error.change.attend.status", null, locale));/* 출결상태 변경 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 세미나 수강생 메모 변경
     * @param SeminarAtndVO 
     * @return ProcessResultVO<SeminarAtndVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/seminarAtndMemoEdit.do")
    @ResponseBody
    public ProcessResultVO<SeminarAtndVO> seminarAtndMemoEdit(SeminarAtndVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<SeminarAtndVO> resultVO = new ProcessResultVO<SeminarAtndVO>();
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();
        
        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            seminarAtndService.updateMemoOne(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
            
            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO ZOOM 출결 정보 API 호출
     * @param SeminarVO 
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/zoomAttendSet.do")
    @ResponseBody
    public ProcessResultVO<SeminarVO> zoomAttendSet(SeminarVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarVO> resultVO = new ProcessResultVO<SeminarVO>();
        Locale locale   = LocaleUtil.getLocale(request);
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String crsCreCd = vo.getCrsCreCd();
        
        try {
            vo.setUserId(userId);
            vo.setMdfrId(userId);
            vo.setCrsCreCd(crsCreCd);
            seminarService.seminarAttendSet(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("seminar.error.process.zoom.attend", null, locale));/* Zoom 출결 처리 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 학생 세미나 목록 페이지
     * @param SeminarVO
     * @return "seminar/stu_seminar_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/stuSeminarList.do")
    public String stuSeminarListForm(SeminarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd  = vo.getCrsCreCd();
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        String auditYn    = StringUtil.nvl(SessionInfo.getAuditYn(request));
        
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_SEMINAR, "세미나 목록");
        
        StdVO stdVO = new StdVO();
        stdVO.setUserId(userId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO = stdService.selectStd(stdVO);
        model.addAttribute("stdVO", stdVO);
        model.addAttribute("auditYn", auditYn);
        
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", crsCreCd);
        
        return "seminar/stu_seminar_list";
    }
    
    /***************************************************** 
     * TODO 학생 세미나 정보 페이지
     * @param SeminarVO
     * @return "seminar/stu_seminar_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/stuSeminarView.do")
    public String stuSeminarView(SeminarVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd  = vo.getCrsCreCd();
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        SeminarVO seminarVO = new SeminarVO();
        seminarVO.setSeminarId(vo.getSeminarId());
        seminarVO.setStdNo(StringUtil.nvl(vo.getStdNo()));

        seminarVO = seminarService.select(seminarVO);

        // crsCreCd 가 null 일 경우 값 추가!
        if(crsCreCd == null || "".equals(crsCreCd)) {
            crsCreCd = seminarVO.getCrsCreCd();
        }

        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_SEMINAR, "["+seminarVO.getSeminarNm()+"] 세미나정보 확인");

        StdVO stdVO = new StdVO();
        stdVO.setUserId(userId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO = stdService.selectStd(stdVO);
        
        request.setAttribute("vo", seminarVO);
        request.setAttribute("stdVO", stdVO);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", crsCreCd);
        request.setAttribute("auditYn", SessionInfo.getAuditYn(request));
        
        return "seminar/stu_seminar_view";
    }
    
    /***************************************************** 
     * TODO 세미나 이메일 직접 등록 팝업
     * @param SeminarVO
     * @return "seminar/popup/stu_seminar_self_email_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/stuSeminarSelfEmailPop.do")
    public String stuSeminarSelfEmailPop(SeminarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String crsCreCd = vo.getCrsCreCd();
        
        StdVO stdVO = new StdVO();
        stdVO.setUserId(userId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO = stdService.selectStd(stdVO);
        
        SeminarVO seminarVO = new SeminarVO();
        seminarVO.setSeminarId(vo.getSeminarId());
        seminarVO = seminarService.select(seminarVO);
        
        request.setAttribute("vo", seminarVO);
        request.setAttribute("stdVO", stdVO);
        request.setAttribute("crsCreCd", crsCreCd);
        
        return "seminar/popup/stu_seminar_self_email_pop";
    }
    
    /***************************************************** 
     * TODO ZOOM 호스트 참여
     * @param SeminarVO 
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/zoomHostStart.do")
    @ResponseBody
    public ProcessResultVO<SeminarAtndVO> zoomHostStart(SeminarAtndVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarAtndVO> resultVO = new ProcessResultVO<SeminarAtndVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userAgent = request.getHeader("User-Agent").toUpperCase();
        String connIp    = StringUtil.nvl(SessionInfo.getLoginIp(request));
        
        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setDeviceTypeCd(userAgent.indexOf("MOBILE") > -1 ? "MOBILE" : "PC");
            vo.setRegIp(connIp);
            resultVO.setReturnVO(seminarService.getHostUrl(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO ZOOM 학습자 참여
     * @param SeminarVO 
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/zoomJoinStart.do")
    @ResponseBody
    public ProcessResultVO<SeminarAtndVO> zoomJoinStart(SeminarAtndVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        
        ProcessResultVO<SeminarAtndVO> resultVO = new ProcessResultVO<SeminarAtndVO>();
        Locale locale    = LocaleUtil.getLocale(request);
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String userAgent = request.getHeader("User-Agent").toUpperCase();
        String connIp    = StringUtil.nvl(SessionInfo.getLoginIp(request));
        
        // 강의실 활동 로그 등록
        SeminarVO seminarVO = new SeminarVO();
        seminarVO.setSeminarId(vo.getSeminarId());
        seminarVO = seminarService.select(seminarVO);
        logLessonActnHstyService.saveLessonActnHsty(request, seminarVO.getCrsCreCd(), CommConst.ACTN_HSTY_SEMINAR, "["+seminarVO.getSeminarNm()+"] 세미나 참여");
        
        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setAuthrtGrpcd(menuType);
            vo.setDeviceTypeCd(userAgent.indexOf("MOBILE") > -1 ? "MOBILE" : "PC");
            vo.setRegIp(connIp);
            resultVO.setReturnVO(seminarService.getJoinUrl(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 녹화 영상 팝업
     * @param SeminarVO
     * @return "seminar/popup/seminar_record_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/recordViewPop.do")
    public String recordViewPop(SeminarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String seminarId = vo.getSeminarId();
        
        vo.setUserId(userId);
        try {
            SeminarVO seminarVO = new SeminarVO();
            seminarVO.setSeminarId(seminarId);
            seminarVO = seminarService.select(seminarVO);
            
            SeminarVO apiParamVO = new SeminarVO();
            apiParamVO.setZoomId(seminarVO.getZoomId());
            apiParamVO.setSearchFrom(seminarVO.getSeminarStartDttm());
            apiParamVO.setSearchTo(seminarVO.getSeminarEndDttm());
            List<RecordingVO> allRecordingList = zoomApiService.listAllRecording(apiParamVO);
            
            request.setAttribute("allRecordingList", allRecordingList);
        } catch(Exception e) {
            System.out.println(e.getStackTrace());
        }
        
        return "seminar/popup/seminar_record_view_pop";
    }
    /*
    public String recordViewPop(SeminarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        vo.setUserId(userId);
        List<RecordingFileVO> resultList = new ArrayList<RecordingFileVO>();
        try {
            resultList = zoomApiService.listMeetingRecordingFiles(vo);
        } catch(Exception e) {
            System.out.println(e.getStackTrace());
        }
        request.setAttribute("fileList", resultList);
        
        return "seminar/popup/seminar_record_view_pop";
    }
    */
    
    /***************************************************** 
     * TODO 출결 목록 팝업
     * @param SeminarVO
     * @return "seminar/popup/seminar_attend_list_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/attendListPop.do")
    public String attendListPop(SeminarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_SEMINAR);
        String crsCreCd = vo.getCrsCreCd();
        
        vo.setCrsCreCd(crsCreCd);
        request.setAttribute("attendList", seminarService.seminarAttendList(vo));
        request.setAttribute("vo", vo);
        
        return "seminar/popup/seminar_attend_list_pop";
    }
    
    /***************************************************** 
     * TODO ZOOM 출결 목록 엑셀 다운로드
     * @param SeminarVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/attendExcelDown.do")
    public String attendExcelDown(SeminarVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", messageSource.getMessage("seminar.label.attend.status", null, locale));        // 출결현황
        map.put("sheetName", messageSource.getMessage("seminar.label.attend.status", null, locale));    // 출결현황
        map.put("excelGrid", vo.getExcelGrid());
        
        map.put("list", seminarService.seminarAttendList(vo));
        
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", messageSource.getMessage("seminar.label.attend.status", null, locale));   // 출결현황
        
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }

}
