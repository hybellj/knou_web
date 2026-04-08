package knou.lms.exam.web;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.CrsExcelUtilPoi;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.service.OrgOrgInfoService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.exam.service.ExamAbsentService;
import knou.lms.exam.service.ExamDsblReqService;
import knou.lms.exam.service.ExamQbankCtgrService;
import knou.lms.exam.service.ExamQbankQstnService;
import knou.lms.exam.service.ExamService;
import knou.lms.exam.service.ExamStareService;
import knou.lms.exam.vo.ExamAbsentVO;
import knou.lms.exam.vo.ExamDsblReqVO;
import knou.lms.exam.vo.ExamIndustryConVO;
import knou.lms.exam.vo.ExamQbankCtgrVO;
import knou.lms.exam.vo.ExamQbankQstnVO;
import knou.lms.exam.vo.ExamStareVO;
import knou.lms.exam.vo.ExamVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgAbsentRatioService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgAbsentRatioVO;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.sys.service.SysCodeService;
import knou.lms.sys.service.SysJobSchService;
import knou.lms.sys.vo.SysJobSchVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrDeptCdVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Controller
@RequestMapping(value="/exam/examMgr")
public class ExamMgrController extends ControllerBase {
    
    @Resource(name="examService")
    private ExamService examService;
    
    @Resource(name="usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;
    
    @Resource(name="examAbsentService")
    private ExamAbsentService examAbsentService;
    
    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;
    
    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;
    
    @Resource(name="orgOrgInfoService")
    private OrgOrgInfoService orgOrgInfoService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    @Resource(name="termService")
    private TermService termService;
    
    @Resource(name="sysCodeService")
    private SysCodeService sysCodeService;
    
    @Resource(name="orgAbsentRatioService")
    private OrgAbsentRatioService orgAbsentRatioService;
    
    @Resource(name="crecrsService")
    private CrecrsService crecrsService;
    
    @Resource(name="sysJobSchService")
    private SysJobSchService sysJobSchService;
    
    @Resource(name="examDsblReqService")
    private ExamDsblReqService examDsblReqService;
    
    @Resource(name="stdService")
    private StdService stdService;
    
    @Resource(name="examQbankCtgrService")
    private ExamQbankCtgrService examQbankCtgrService;
    
    @Resource(name="examQbankQstnService")
    private ExamQbankQstnService examQbankQstnService;
    
    @Resource(name="examStareService")
    private ExamStareService examStareService;
    
    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;
    
    /*****************************************************
     * 결시원 등록 페이지
     * @param ExamAbsentVO
     * @return "exam/mgr/exam_absent_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/examAbsentAddList.do")
    public String examAbsentAddListForm(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        request.setAttribute("termVO", termVO);
        request.setAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        request.setAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));
        
        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        request.setAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));

        request.setAttribute("menuType", "ADM");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("userId", userId);
        request.setAttribute("type", "add");
        request.setAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "exam/mgr/exam_absent_list";
    }
    
    /*****************************************************
     * 결시원 승인 페이지
     * @param ExamAbsentVO
     * @return "exam/mgr/exam_absent_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/examAbsentApproveList.do")
    public String examAbsentApproveListForm(ExamAbsentVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        String userNm    = StringUtil.nvl(SessionInfo.getUserNm(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        request.setAttribute("termVO", termVO);
        request.setAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        request.setAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        request.setAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));
        
        request.setAttribute("menuType", "ADM");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("userId", userId);
        request.setAttribute("userNm", userNm);
        request.setAttribute("type", "approve");
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        
        return "exam/mgr/exam_absent_list";
    }
    
    /*****************************************************
     * 결시원 목록 조회
     * @param ExamAbsentVO
     * @return ProcessResultVO<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsentList.do")
    @ResponseBody
    public ProcessResultVO<ExamAbsentVO> examAbsentList(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        ProcessResultVO<ExamAbsentVO> resultVO = new ProcessResultVO<ExamAbsentVO>();

        try {
            vo.setOrgId(orgId);
            resultVO = examAbsentService.listAdminExamAbsent(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }

        return resultVO;
    }
    
    /*****************************************************
     * 결시원 정보 조회
     * @param ExamAbsentVO
     * @return ProcessResultVO<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewExamAbsent.do")
    @ResponseBody
    public ProcessResultVO<ExamAbsentVO> viewExamAbsent(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        ProcessResultVO<ExamAbsentVO> resultVO = new ProcessResultVO<ExamAbsentVO>();

        try {
            vo.setOrgId(orgId);
            vo = examAbsentService.select(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 결시원 승인/반려
     * @param ExamAbsentVO
     * @return ProcessResultVO<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateExamAbsent.do")
    @ResponseBody
    public ProcessResultVO<ExamAbsentVO> updateExamAbsent(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        
        ProcessResultVO<ExamAbsentVO> resultVO = new ProcessResultVO<ExamAbsentVO>();
        String userId = SessionInfo.getUserId(request);
        
        try {
            vo.setMdfrId(userId);
            
            for(String examAbsentCd : vo.getExamAbsentCd().split(",")) {
                vo.setExamAbsentCd(examAbsentCd);
                examAbsentService.updateAbsent(request, vo);
            }
            
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.update"));/* 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 결시원 엑셀 다운로드
     * @param ExamAbsentVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsentExcelDown.do")
    public String examAbsentExcelDown(ExamAbsentVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);
        
        String title = getMessage("exam.label.exam.absent.list"); // 결시원목록
        
        vo.setSearchMenu("excelDown");
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);        // 결시원목록
        map.put("sheetName", title);    // 결시원목록
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", examAbsentService.listAdminExamAbsent(vo).getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title); // 결시원목록

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }
    
    /*****************************************************
     * 결시원 신청이력 팝업
     * @param ExamAbsentVO
     * @return "exam/mgr/popup/exam_absent_apply_hsty_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsentApplyHstyPop.do")
    public String examAbsentApplyHstyPop(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        UsrUserInfoVO uuivo = new UsrUserInfoVO();
        uuivo.setUserId(vo.getUserId());
        uuivo = usrUserInfoService.userSelect(uuivo);
        request.setAttribute("uuivo", uuivo);
        
        return "exam/mgr/popup/exam_absent_apply_hsty_pop";
    }
    
    /*****************************************************
     * 결시원 추가 팝업
     * @param ExamAbsentVO
     * @return "exam/mgr/popup/exam_absent_apply_hsty_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/addExamAbsentPop.do")
    public String addExamAbsentPop(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        request.setAttribute("vo", vo);
        
        return "exam/mgr/popup/exam_absent_add_pop";
    }
    
    /*****************************************************
     * 결시원 미신청 목록 조회
     * @param ExamAbsentVO
     * @return ProcessResultVO<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsentNotApplicateList.do")
    @ResponseBody
    public ProcessResultVO<ExamAbsentVO> examAbsentNotApplicateList(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<ExamAbsentVO> resultVO = new ProcessResultVO<ExamAbsentVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setSearchFrom(userId);
            resultVO = examAbsentService.listCreCrsNotAbsent(vo);
            UsrUserInfoVO uuivo = new UsrUserInfoVO();
            uuivo.setUserId(vo.getUserId());
            uuivo = usrUserInfoService.userSelect(uuivo);
            resultVO.setReturnVO(uuivo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 시험과목 정보 조회
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectCreCrsByExam.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> selectCreCrsByExam(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        try {
            ExamVO examVO = examService.selectCreCrsByExam(vo);
            resultVO.setReturnVO(examVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 결시원 추가
     * @param ExamAbsentVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsentApplicate.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> examAbsentApplicate(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setOrgId(orgId);
            resultVO = examAbsentService.examAbsentApplicate(request, vo);
            resultVO.setResult(1);
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.add"));/* 추가 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 결시기준 등록 페이지
     * @param OrgAbsentRatioVO
     * @return "exam/mgr/exam_absent_ratio_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/examAbsentRatioList.do")
    public String examAbsentRatioListForm(OrgAbsentRatioVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        request.setAttribute("examGbnList", sysCodeService.listCode("ABSENT_SCORE_EXAM_CD").getReturnList());
        request.setAttribute("scoreGbnList", sysCodeService.listCode("ABSENT_SCORE_GBN_CD").getReturnList());
        request.setAttribute("menuType", "ADM");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("userId", userId);

        return "exam/mgr/exam_absent_ratio_list";
    }
    
    /*****************************************************
     * 결시원 성적비율 리스트
     * @param OrgAbsentRatioVO
     * @return ProcessResultVO<OrgAbsentRatioVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsentRatioList.do")
    @ResponseBody
    public ProcessResultVO<OrgAbsentRatioVO> examAbsentRatioList(OrgAbsentRatioVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<OrgAbsentRatioVO> resultVO = new ProcessResultVO<OrgAbsentRatioVO>();
        
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setOrgId(orgId);
            resultVO = orgAbsentRatioService.list(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 결시원 성적비율 정보
     * @param OrgAbsentRatioVO
     * @return ProcessResultVO<OrgAbsentRatioVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewExamAbsentRatio.do")
    @ResponseBody
    public ProcessResultVO<OrgAbsentRatioVO> viewExamAbsentRatio(OrgAbsentRatioVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<OrgAbsentRatioVO> resultVO = new ProcessResultVO<OrgAbsentRatioVO>();
        
        try {
            OrgAbsentRatioVO orgAbsentRatioVO = orgAbsentRatioService.select(vo);
            resultVO.setReturnVO(orgAbsentRatioVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 결시원 성적비율 등록
     * @param OrgAbsentRatioVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/addExamAbsentRatio.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addExamAbsentRatio(OrgAbsentRatioVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            orgAbsentRatioService.insert(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.insert"));/* 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 결시원 성적비율 삭제
     * @param OrgAbsentRatioVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/delExamAbsentRatio.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delExamAbsentRatio(OrgAbsentRatioVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        try {
            orgAbsentRatioService.delete(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.delete"));/* 삭제 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 결시원 성적비율 엑셀 다운로드
     * @param OrgAbsentRatioVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examStareExcelDown.do")
    public String examStareExcelDown(OrgAbsentRatioVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);
        
        String title = getMessage("exam.label.absent.score.ratio"); // 결시원목록
        
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);/* 결시원 성적비율 */
        map.put("sheetName", title);/* 결시원 성적비율 */
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", orgAbsentRatioService.list(vo).getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title);/* 결시원 성적비율내역 */

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }
    
    /*****************************************************
     * 장애학생시험지원(교수) 페이지
     * @param vo
     * @param model
     * @param request
     * @return "exam/mgr/exam_dsbl_req_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/examDsblReqProfList.do")
    public String examDsblReqProfListForm(ExamDsblReqVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userNm = StringUtil.nvl(SessionInfo.getUserNm(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));
        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setOrgId(orgId);
        sysJobSchVO.setTermCd(termVO.getTermCd());
        sysJobSchVO.setCalendarCtgr("00190806"); // 시험지원요청(교수)
        sysJobSchVO = sysJobSchService.select(sysJobSchVO);
        model.addAttribute("sysJobSchVO", sysJobSchVO);
        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        
        model.addAttribute("menuType", "ADM");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("userId", userId);
        model.addAttribute("userNm", userNm);
        model.addAttribute("type", "PROF");
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        
        return "exam/mgr/exam_dsbl_req_list";
    }
    
    /*****************************************************
     * 장애학생시험지원 페이지
     * @param vo
     * @param model
     * @param request
     * @return "exam/mgr/exam_dsbl_req_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/examDsblReqList.do")
    public String examDsblReqListForm(ExamDsblReqVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userNm = StringUtil.nvl(SessionInfo.getUserNm(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));
        
        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        model.addAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));
        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setOrgId(orgId);
        sysJobSchVO.setCalendarCtgr("00190806"); // 시험지원요청(교수)
        sysJobSchVO.setTermCd(termVO.getTermCd());
        sysJobSchVO = sysJobSchService.select(sysJobSchVO);
        model.addAttribute("sysJobSchVO", sysJobSchVO);
        
        model.addAttribute("menuType", "ADM");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("userId", userId);
        model.addAttribute("userNm", userNm);
        model.addAttribute("type", "ALL");
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        
        return "exam/mgr/exam_dsbl_req_list";
    }
    
    /*****************************************************
     * 장애인시험지원 리스트
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<ExamDsblReqVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examDsblReqList.do")
    @ResponseBody
    public ProcessResultVO<ExamDsblReqVO> examDsblReqList(ExamDsblReqVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamDsblReqVO> resultVO = new ProcessResultVO<>();
        
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            // 사용자 접속상태 저장
            logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
            
            vo.setOrgId(orgId);
            
            List<ExamDsblReqVO> list = examDsblReqService.listExamDsblReqByAdmin(vo);
            
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 장애인시험지원 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examDsblReqExcelDown.do")
    public String examDsblReqExcelDown(ExamDsblReqVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        String orgId = SessionInfo.getOrgId(request);
        
        vo.setOrgId(orgId);
        
        String title = getMessage("exam.label.dsbl.req.list"); // 장애인시험지원목록
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);       // 장애인시험지원목록
        map.put("sheetName", title);       // 장애인시험지원목록
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", examDsblReqService.listExamDsblReqByAdmin(vo));

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title);       // 장애인시험지원목록

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }
    
    /*****************************************************
     * 장애인 시험지원 신청 목록 팝업
     * @param vo
     * @param model
     * @param request
     * @return "exam/mgr/popup/exam_dsbl_req_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewExamDsblReqPop.do")
    public String viewExamDsblReqPop(ExamDsblReqVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        if(!"".equals(StringUtil.nvl(vo.getDsblReqCd()))) {
            ExamDsblReqVO examDsblReqVO = examDsblReqService.select(vo);
            model.addAttribute("examDsblReqVO", examDsblReqVO);
        }

        StdVO stdVO = new StdVO();
        stdVO.setStdId(vo.getStdId());
        stdVO = stdService.select(stdVO);
        model.addAttribute("stdVO", stdVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("type", StringUtil.nvl(vo.getSearchMenu()));
        
        UsrUserInfoVO uuivo = new UsrUserInfoVO();
        uuivo.setUserId(StringUtil.nvl(stdVO.getUserId()));
        uuivo = usrUserInfoService.viewForLogin(uuivo);
        model.addAttribute("uuivo", uuivo);

        return "exam/mgr/popup/exam_dsbl_req_view_pop";
    }
    
    /***************************************************** 
     * 문제은행 목록 페이지
     * @param ExamQbankQstnVO 
     * @return "exam/mgr/qbank_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/qbankList.do")
    public String qbnakListForm(ExamQbankQstnVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        request.setAttribute("termVO", termVO);
        request.setAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        request.setAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));
        
        // 부서정보
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));
        request.setAttribute("deptList", usrDeptCdService.list(usrDeptCdVO));
        request.setAttribute("qstnTypeList", orgCodeService.selectOrgCodeList("QSTN_TYPE_CD"));
        request.setAttribute("vo", vo);
        request.setAttribute("menuType", "ADM");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        
        return "exam/mgr/qbank_list";
    }
    
    /*****************************************************
     * 문제은행 문제 등록
     * @param ExamQbankQstnVO
     * @return ProcessResultVO<ExamQbankQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeQbank.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankQstnVO> writeQbank(ExamQbankQstnVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        ProcessResultVO<ExamQbankQstnVO> resultVO = new ProcessResultVO<ExamQbankQstnVO>();
        
        try {
            vo.setMdfrId(vo.getRgtrId());
            examQbankQstnService.insertQbankQstn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.insert"));/* 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 문제은행 문제 수정
     * @param ExamQbankQstnVO
     * @return ProcessResultVO<ExamQbankQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editQbank.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankQstnVO> editQbank(ExamQbankQstnVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        ProcessResultVO<ExamQbankQstnVO> resultVO = new ProcessResultVO<ExamQbankQstnVO>();
        
        try {
            vo.setMdfrId(vo.getRgtrId());
            examQbankQstnService.updateQbankQstn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.update"));/* 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 문제은행 분류코드 등록 페이지
     * @param ExamQbankCtgrVO 
     * @return "exam/mgr/qbank_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/writeQbankCtgr.do")
    public String writeQbankCtgrForm(ExamQbankCtgrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        ExamQbankCtgrVO ctgrVO = new ExamQbankCtgrVO();
        ctgrVO.setCrsNo(vo.getCrsNo());
        ctgrVO.setSearchType("UPPER");
        List<ExamQbankCtgrVO> qbankCtgrList = examQbankCtgrService.list(ctgrVO);
        request.setAttribute("ctgrList", qbankCtgrList);
        List<ExamQbankCtgrVO> userList = examQbankCtgrService.listQbankCtgrUser(vo);
        request.setAttribute("userList", userList);
        request.setAttribute("vo", vo);
        request.setAttribute("menuType", "ADM");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        
        return "exam/mgr/qbank_ctgr_write";
    }

    
    /***************************************************** 
     * 미응시자 재시험 설정
     * @param ExamVO 
     * @return "exam/mgr/re_exam_config_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/reExamConfigList.do")
    public String reExamConfigListForm(ExamQbankCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        request.setAttribute("termVO", termVO);
        request.setAttribute("haksaTermList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        request.setAttribute("vo", vo);
        request.setAttribute("menuType", "ADM");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        
        return "exam/mgr/re_exam_config_list";
    }
    
    /***************************************************** 
     * 재시험 등록관리 팝업
     * @param ExamVO 
     * @return "exam/mgr/popup/re_exam_config_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="reExamConfigPop.do")
    public String reExamConfigPop(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        // 현재학기
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        
        // 현재 학기 년도
        String haksaYear = termVO.getHaksaYear();
        
        // 현재 학기
        String haksaTerm = termVO.getHaksaTerm();
        
        // 학기 코드 목록
        String haksaTermNm = "";
        List<OrgCodeVO> haksaTermCdList = orgCodeService.selectOrgCodeList("HAKSA_TERM");

        for(OrgCodeVO orgCodeVO : haksaTermCdList) {
            String codeCd = orgCodeVO.getCd();
            
            if(haksaTerm.equals(codeCd)) {
                // 현재 학기명
                haksaTermNm = orgCodeVO.getCdnm();
                break;
            }
        }
        
        request.setAttribute("haksaYear", haksaYear);
        request.setAttribute("haksaTerm", haksaTerm);
        request.setAttribute("haksaTermNm", haksaTermNm);
        
        request.setAttribute("vo", vo);
        
        return "exam/mgr/popup/re_exam_config_pop";
    }
    
    /*****************************************************
     * 실시간 시험 미응시 리스트 조회
     * @param ExamStareVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reExamStdList.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> reExamStdList(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = SessionInfo.getOrgId(request);
        
        String haksaYear = vo.getHaksaYear();
        String haksaTerm = vo.getHaksaTerm();
        String crsCreCd = vo.getCrsCreCd();
        String examStareTypeCd = vo.getExamStareTypeCd();
        
        try {
            if(!menuType.contains("ADM")) {
                throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
            }

            vo.setOrgId(orgId);
            
            ExamVO examVO = new ExamVO();
            examVO.setCrsCreCd(crsCreCd);
            examVO.setExamCtgrCd("EXAM");
            examVO.setExamStareTypeCd(examStareTypeCd);
            examVO = examService.select(examVO);
            
            if(examVO == null) {
                throw new AccessDeniedException(getMessage("exam.error.not.exist.exam"));// 시험 정보가 존재하지 않습니다.
            }
            
            // 학사년도, 학기별 학기코드 조회
            TermVO termVO = new TermVO();
            termVO.setHaksaYear(haksaYear);
            termVO.setHaksaTerm(haksaTerm);
            termVO = termService.selectTermByHaksa(termVO);
            
            List<EgovMap> list = null;
            
            if(termVO != null) {
                String termCd = termVO.getTermCd();
                vo.setTermCd(termCd);
                
                list = examStareService.listReExamStd(vo);
            }
            
            resultVO.setReturnVO(examVO);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 실시간 시험 미응시 페이징 리스트 조회
     * @param ExamStareVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reExamStdListPaging.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> reExamStdListPaging(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = SessionInfo.getOrgId(request);
        
        String haksaYear = vo.getHaksaYear();
        String haksaTerm = vo.getHaksaTerm();
        
        try {
            if(!menuType.contains("ADM")) {
                throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
            }
            
            vo.setOrgId(orgId);
            
            // 학사년도, 학기별 학기코드 조회
            TermVO termVO = new TermVO();
            termVO.setHaksaYear(haksaYear);
            termVO.setHaksaTerm(haksaTerm);
            termVO = termService.selectTermByHaksa(termVO);
            String termCd = null;
            if(termVO != null) {
                termCd = termVO.getTermCd();
                
                vo.setTermCd(termCd);
            }
            
            resultVO = examStareService.listPagingReExamStd(vo);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 실시간 시험 미응시 리스트 조회 엑셀 다운로드
     * @param ExamStareVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/downExcelReExamStdList.do")
    public String excelStudentList(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = SessionInfo.getOrgId(request);
       
        String haksaYear = vo.getHaksaYear();
        String haksaTerm = vo.getHaksaTerm();
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        vo.setOrgId(orgId);
        
        // 학사년도, 학기별 학기코드 조회
        TermVO termVO = new TermVO();
        termVO.setHaksaYear(haksaYear);
        termVO.setHaksaTerm(haksaTerm);
        termVO = termService.selectTermByHaksa(termVO);
        
        String termCd = null;
        if(termVO != null) {
            termCd = termVO.getTermCd();
            
            vo.setTermCd(termCd);
        }
        
        // 조회조건 
        String haksaTermNm = request.getParameter("haksaTermNm");
        String uniNm = request.getParameter("uniNm");
        String deptNm = request.getParameter("deptNm");
        String crsCreNm = request.getParameter("crsCreNm");
        String examStareTypeNm = request.getParameter("examStareTypeNm");
        String apprStatNm = request.getParameter("apprStatNm");
        String userNm = vo.getUserNm();
        String tchNm = vo.getTchNm();
        
        if(ValidationUtils.isNotEmpty(vo.getUserId())) {
            userNm = StringUtil.nvl(userNm) + "(" + vo.getUserId() + ")";
        }
        
        if(ValidationUtils.isNotEmpty(vo.getTchNo())) {
            tchNm = StringUtil.nvl(tchNm) + "(" + vo.getTchNo() + ")";
        }
        
        String[] searchValues = {
              getMessage("common.year") + " : " + haksaYear // 학년도
            , getMessage("common.term") + " : " + haksaTermNm // 학기
            , getMessage("exam.label.org.type") + " : " + uniNm // 대학구분
            , getMessage("exam.label.dept") + " : " + deptNm // 학과
            , getMessage("common.subject") + " : " + crsCreNm // 과목
            , getMessage("common.label.exam") + " : " + examStareTypeNm // 시험
            , getMessage("exam.label.exam.absent.submit.status") + " : " + apprStatNm // 결시원 제출상태
            , getMessage("exam.label.user.nm") + "(" + getMessage("exam.label.user.no") + ") : " + userNm // 이름(학번)
            , getMessage("exam.label.tch.nm") + "(" + getMessage("exam.label.tch.no") + ") : " + tchNm // 교수명(사번)
        };
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        List<EgovMap> list = examStareService.listReExamStd(vo);
        
        String title = getMessage("exam.label.re.exam.user.status"); // 시험 미응시자 현황
        
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
        map.put("ext", ".xlsx(big)");
     
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
     * 실시간 시험 재시험 등록현황
     * @param ExamStareVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reExamConfigStatusList.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> reExamConfigStatusList(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = SessionInfo.getOrgId(request);
        
        String haksaYear = vo.getHaksaYear();
        String haksaTerm = vo.getHaksaTerm();
        
        try {
            if(!menuType.contains("ADM")) {
                throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
            }
            
            vo.setOrgId(orgId);
            
            // 학사년도, 학기별 학기코드 조회
            TermVO termVO = new TermVO();
            termVO.setHaksaYear(haksaYear);
            termVO.setHaksaTerm(haksaTerm);
            termVO = termService.selectTermByHaksa(termVO);
            String termCd = null;
            if(termVO != null) {
                termCd = termVO.getTermCd();
                vo.setTermCd(termCd);
            }
            
            List<EgovMap> list = examStareService.listReExamConfigStatus(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /***************************************************** 
     * 재시험 등록관리 상세 팝업
     * @param ExamVO 
     * @return "exam/mgr/popup/re_exam_config_detail_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="reExamConfigDetailPop.do")
    public String re_exam_config_pop(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        String crsCreCd = vo.getCrsCreCd();
        String examCd   = vo.getExamCd();
        String haksaYear = vo.getHaksaYear();
        String haksaTerm = vo.getHaksaTerm();
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        // 학기 코드 목록
        String haksaTermNm = "";
        List<OrgCodeVO> haksaTermCdList = orgCodeService.selectOrgCodeList("HAKSA_TERM");

        for(OrgCodeVO orgCodeVO : haksaTermCdList) {
            String codeCd = orgCodeVO.getCd();
            
            if(haksaTerm.equals(codeCd)) {
                // 현재 학기명
                haksaTermNm = orgCodeVO.getCdnm();
                break;
            }
        }
        
        // 시험정보 조회
        ExamVO examVO = new ExamVO();
        examVO.setExamCd(examCd);
        examVO = examService.select(examVO);
        
        // 과목 정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setUniCd("");
        creCrsVO = crecrsService.select(creCrsVO);
        
        model.addAttribute("haksaYear", haksaYear);
        model.addAttribute("haksaTerm", haksaTerm);
        model.addAttribute("haksaTermNm", haksaTermNm);
        
        model.addAttribute("examVO", examVO);
        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("vo", vo);
        
        return "exam/mgr/popup/re_exam_config_detail_pop";
    }
    
    /***************************************************** 
     * 실시간시험 재시험 설정
     * @param ExamVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/setReExamStare.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> setMidEndReExamStare(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        
        try {
            resultVO = examStareService.setMidEndReExamStare(vo, request);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /*****************************************************
     * 수업 > 산업체위탁생학습진행현황 페이지
     * @Method Name : industryConLearningForm
     * @Method 설명 : 수업 > 산업체위탁생학습진행현황
     * @param ExamIndustryConVO
     * @return "exam/mgr/industry_con_learning_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/industryConLearningForm.do")
    public String industryConLearningForm(ExamIndustryConVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String curYear = DateTimeUtil.getYear();
        String curTerm = "";
        String curCrsCreCd = "";
        
        vo.setHaksaYear(curYear);
        
        ProcessResultVO<ExamIndustryConVO> resultVo = new ProcessResultVO<ExamIndustryConVO>();
                
        resultVo = examStareService.selectHaksaTerm(vo);
        
        request.setAttribute("haksaTermList", resultVo.getReturnList());

        if (resultVo.getReturnList().size() > 0) {
            for (int i = 0; i < resultVo.getReturnList().size(); i++) {
                ExamIndustryConVO inVo = resultVo.getReturnList().get(i);
                
                if ("Y".equals(inVo.getCurTermYn())) {
                    curTerm = inVo.getHaksaTermCd();
                    vo.setHaksaTerm(inVo.getHaksaTermCd());
                }
            }
        } 
        
        resultVo = examStareService.selectCreCrsNm(vo);
        request.setAttribute("creCrsList", resultVo.getReturnList());
    
        if (resultVo.getReturnList().size() > 0) {
            ExamIndustryConVO inVo = resultVo.getReturnList().get(0);
                
            curCrsCreCd = inVo.getCrsCreCd();
            vo.setCrsCreCd(curCrsCreCd);
        }         
        
        request.setAttribute("curYear", curYear);
        request.setAttribute("curTerm", curTerm);
        request.setAttribute("orgId", orgId);
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        request.setAttribute("haksaYearList", examStareService.selectHaksaYear(vo));
        request.setAttribute("lessonSchedule", examStareService.selectLessonSchedule(vo));

        return "exam/mgr/industry_con_learning_form";
    }      
    
    /***************************************************** 
     * 학사 학기 목록 조회
     * @param ExamIndustryConVO 
     * @return ProcessResultVO<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/searchHaksaTerm.do")
    @ResponseBody
    public ProcessResultVO<ExamIndustryConVO> searchHaksaTerm(ExamIndustryConVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamIndustryConVO> resultVO = new ProcessResultVO<ExamIndustryConVO>();
        
        try {
            resultVO = examStareService.selectHaksaTerm(vo);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 과목 목록
     * @param ExamIndustryConVO 
     * @return ProcessResultVO<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/searchCreCrsNm.do")
    @ResponseBody
    public ProcessResultVO<ExamIndustryConVO> searchCreCrsNm(ExamIndustryConVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamIndustryConVO> resultVO = new ProcessResultVO<ExamIndustryConVO>();

        try {
            resultVO = examStareService.selectCreCrsNm(vo);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }
    
    /**
     * 산업체위탁생학습진행현황 조회
     * @Method Name : industryConLearningList
     * @Method 설명 : 수업 > 산업체위탁생학습진행현황 조회
     * @param  
     * @param commandMap
     * @param model
     * @return  "/exam/mgr/industry_con_learning_list.jsp"
     * @throws Exception
     */
    @RequestMapping(value = "/industryConLearningList.do")
    public String industryConLearningList(ExamIndustryConVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        List<ExamIndustryConVO> resultList = examStareService.selectIndustryConLearningList(vo);
        
        request.setAttribute("lessonSchedule", examStareService.selectLessonSchedule(vo));
        request.setAttribute("industryList", resultList);

        return "exam/mgr/industry_con_learning_list";
    }    
    
    /**
     * @Method Name : industryConLearningExcel
     * @Method 설명 : 산업체위탁생학습진행현황 (엑셀 다운로드)
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return  "excelView"
     * @throws Exception
     */
    @RequestMapping(value="/industryConLearningExcel.do")
    public String industryConLearningExcel(ExamIndustryConVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) throws Exception {

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMddHHmmss");
        
        //산업체위탁생학습진행현황  조회
        List<ExamIndustryConVO> resultList = examStareService.selectIndustryConLearningList(vo);

        String[] searchValues = {"조회조건 : "+StringUtil.nvl(vo.getSearchValue())};
      
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "산업체위탁생학습진행현황");
        map.put("sheetName", "산업체위탁생학습진행현황");
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", resultList);
     
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        String name = StringUtil.nvl(vo.getHaksaYear())+"_산업체위탁생학습진행현황_"+date.format(today);

        modelMap.put("outFileName", name);
      
        CrsExcelUtilPoi excelUtilPoi = new CrsExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }    
    
}
