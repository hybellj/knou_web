package knou.lms.exam.web;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.*;
import knou.framework.vo.FileVO;
import knou.lms.asmt.service.AsmtProService;
import knou.lms.asmt.vo.AsmtVO;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.erp.service.ErpService;
import knou.lms.erp.vo.ErpEnrollmentVO;
import knou.lms.exam.facade.QuizFacadeService;
import knou.lms.exam.service.*;
import knou.lms.exam.vo.*;
import knou.lms.exam.web.view.QuizMainView;
import knou.lms.file.vo.AtflVO;
import knou.lms.forum.service.ForumJoinUserService;
import knou.lms.forum.service.ForumService;
import knou.lms.forum.vo.ForumVO;
import knou.lms.lesson.service.LessonScheduleService;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.lesson.vo.LogLessonActnHstyVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.sys.service.SysJobSchService;
import knou.lms.sys.vo.SysJobSchVO;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrUserInfoVO;
import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
@RequestMapping(value="/exam")
public class ExamHomeController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(ExamHomeController.class);

    @Resource(name="examService")
    private ExamService examService;

    @Resource(name="quizFacadeService")
    private QuizFacadeService quizFacadeService;

    @Resource(name="tkexamRsltService")
    private TkexamRsltService tkexamRsltService;

    @Resource(name="tkexamService")
    private TkexamService tkexamService;

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="examStareService")
    private ExamStareService examStareService;

    @Resource(name="examQstnService")
    private ExamQstnService examQstnService;

    @Resource(name="termService")
    private TermService termService;

    @Resource(name="examAbsentService")
    private ExamAbsentService examAbsentService;

    @Resource(name="examDsblReqService")
    private ExamDsblReqService examDsblReqService;

    @Resource(name="stdService")
    private StdService stdService;

    @Resource(name="examOathService")
    private ExamOathService examOathService;

    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name="forumService")
    private ForumService forumService;

    @Resource(name="forumJoinUserService")
    private ForumJoinUserService forumJoinUserService;

    @Resource(name="asmtProService")
    private AsmtProService asmntService;

    @Resource(name="usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;

    @Resource(name="sysJobSchService")
    private SysJobSchService sysJobSchService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name="erpService")
    private ErpService erpService;

    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    @Resource(name="lessonScheduleService")
    private LessonScheduleService lessonScheduleService;

    /*****************************************************
     * 신규 작성 Controller 영역
     *****************************************************/
    /*****************************************************
     * 시험 목록 페이지 (교수)
     * @param vo
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamListView.do")
    public String profExamListView(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String sbjctId = vo.getSbjctId() == null ? "SBJCT_OFRNG_ID2" : vo.getSbjctId();

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }

        model.addAttribute("vo", vo);

        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        // 임시로 prof 경로 추가
        return "exam/prof/exam_list_view";
    }

    /*****************************************************
     * 시험 [등록|수정] 페이지 (교수)
     * @param ExamVO
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamWriteView.do")
    public String profExamWriteView(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String examBscId = StringUtil.nvl(vo.getExamBscId());
        String tkexamMthdCd = StringUtil.nvl(vo.getTkexamMthdCd());
        String byteamSubrexamUseyn = StringUtil.nvl(vo.getByteamSubrexamUseyn());
        String sbjctId = vo.getSbjctId() == null ? "SBJCT_OFRNG_ID2" : vo.getSbjctId();
        String isModify = null;

        ExamVO examVO = null;
        List<ExamVO> examDtlInfoVO = null;
        if (examBscId.isEmpty()) {
            // 시험 기본 ID가 공백일 경우 [등록]
            isModify = "N";
        } else {
            // 시험 기본 ID가 있을 경우 [수정]
            isModify = "Y";
            examVO = examService.selectProfExamDtl(vo); // 시험 상세 조회 (화면 표시 기본정보)
            if ("Y".equals(examVO.getByteamSubrexamUseyn())) {
                // 팀 시험일 경우
                examDtlInfoVO = examService.selectProfExamTeamDtl(vo);

                // examDtlInfoVO의 모든 항목이 examVO와 동일한 examCts, examTtl을 가질 경우 = 부 주제 미사용(N)
                // 하나라도 다를 경우 = 부 주제 사용(Y)
                if (examDtlInfoVO != null && !examDtlInfoVO.isEmpty()) {
                    String baseExamCts = StringUtil.nvl(examVO.getExamCts());
                    String baseExamTtl = StringUtil.nvl(examVO.getExamTtl());
                    boolean allSame = examDtlInfoVO.stream().allMatch(dtl ->
                            baseExamCts.equals(StringUtil.nvl(dtl.getExamCts())) &&
                                    baseExamTtl.equals(StringUtil.nvl(dtl.getExamTtl()))
                    );
                    examVO.setLrnGrpSubsbjctUseyn(allSame ? "N" : "Y");
                }
            }
        }
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("examVO", examVO);
        model.addAttribute("examDtlInfoVO", examDtlInfoVO);
        model.addAttribute("isModify", isModify); // 등록|수정 여부
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("examType", StringUtil.nvl(vo.getExamType()));

        // 임시로 prof 경로 추가
        return "exam/prof/exam_write";
    }

    /*****************************************************
     * 시험 관리 페이지 (시험정보 및 평가 탭)
     * @param ExamVO
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamInfoEvlView.do")
    public String profExamInfoEvlView(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String tabType = StringUtil.nvl(vo.getTabType());
        String examBscId = StringUtil.nvl(vo.getExamBscId());
        String tkexamMthdCd = StringUtil.nvl(vo.getTkexamMthdCd());
        String byteamSubrexamUseyn = StringUtil.nvl(vo.getByteamSubrexamUseyn());

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        ExamVO examVO = examService.selectProfExamDtl(vo);
        List<ExamVO> examDtlInfoVO = null;
        if ("Y".equals(examVO.getByteamSubrexamUseyn())) {
            examDtlInfoVO = examService.selectProfExamTeamDtl(vo);

            // examDtlInfoVO의 모든 항목이 examVO와 동일한 examCts, examTtl을 가질 경우 = 부 주제 미사용(N)
            // 하나라도 다를 경우 = 부 주제 사용(Y)
            if (examDtlInfoVO != null && !examDtlInfoVO.isEmpty()) {
                String baseExamCts = StringUtil.nvl(examVO.getExamCts());
                String baseExamTtl = StringUtil.nvl(examVO.getExamTtl());
                boolean allSame = examDtlInfoVO.stream().allMatch(dtl ->
                    baseExamCts.equals(StringUtil.nvl(dtl.getExamCts())) &&
                    baseExamTtl.equals(StringUtil.nvl(dtl.getExamTtl()))
                );
                examVO.setLrnGrpSubsbjctUseyn(allSame ? "N" : "Y");
            }
        }
        model.addAttribute("vo", vo);
        model.addAttribute("examVO", examVO);
        model.addAttribute("examDtlInfoVO", examDtlInfoVO);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("sbjctId", StringUtil.nvl(vo.getSbjctId()));
        model.addAttribute("examType", StringUtil.nvl(vo.getExamType()));
        examVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, examBscId));
        // 임시로 prof 경로 추가
        return "exam/prof/exam_info_evl";
    }

    /*****************************************************
     * 시험 관리 페이지 (시험 대체 탭)
     * @param ExamVO
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamSbstView.do")
    public String profExamSbstView(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String tabType = StringUtil.nvl(vo.getTabType());
        String examBscId = StringUtil.nvl(vo.getExamBscId());
        String tkexamMthdCd = StringUtil.nvl(vo.getTkexamMthdCd());
        String byteamSubrexamUseyn = StringUtil.nvl(vo.getByteamSubrexamUseyn());

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        ExamVO examVO = examService.selectProfExamDtl(vo);
        List<ExamVO> examDtlInfoVO = null;
        if ("Y".equals(examVO.getByteamSubrexamUseyn())) {
            examDtlInfoVO = examService.selectProfExamTeamDtl(vo);

            // examDtlInfoVO의 모든 항목이 examVO와 동일한 examCts, examTtl을 가질 경우 = 부 주제 미사용(N)
            // 하나라도 다를 경우 = 부 주제 사용(Y)
            if (examDtlInfoVO != null && !examDtlInfoVO.isEmpty()) {
                String baseExamCts = StringUtil.nvl(examVO.getExamCts());
                String baseExamTtl = StringUtil.nvl(examVO.getExamTtl());
                boolean allSame = examDtlInfoVO.stream().allMatch(dtl ->
                        baseExamCts.equals(StringUtil.nvl(dtl.getExamCts())) &&
                                baseExamTtl.equals(StringUtil.nvl(dtl.getExamTtl()))
                );
                examVO.setLrnGrpSubsbjctUseyn(allSame ? "N" : "Y");
            }
        }
        model.addAttribute("vo", vo);
        model.addAttribute("examVO", examVO);
        model.addAttribute("examDtlInfoVO", examDtlInfoVO);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("sbjctId", StringUtil.nvl(vo.getSbjctId()));
        model.addAttribute("examType", StringUtil.nvl(vo.getExamType()));
        examVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, examBscId));
        // 임시로 prof 경로 추가
        return "exam/prof/exam_info_sbst";
    }

    /*****************************************************
     * 시험 관리 페이지 (시험 대체 등록|수정)
     * @param ExamVO
     * @param model
     * @param request
     * @return viewa
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamSbstWrite.do")
    public String profExamSbstWriteView(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String examBscId = StringUtil.nvl(vo.getExamBscId());
        String gbn = StringUtil.nvl(vo.getGbn());
        String tkexamMthdCd = StringUtil.nvl(vo.getTkexamMthdCd());
        String byteamSubrexamUseyn = StringUtil.nvl(vo.getByteamSubrexamUseyn());

        ExamVO sbstVO = null;
        List<ExamVO> examDtlInfoVO = null;
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        ExamVO examVO = examService.selectProfExamDtl(vo);

        if ("ASMT".equals(gbn)) {
            sbstVO = examService.selectProfSbstAsmt(vo);
        } else if ("QUIZ".equals(gbn)) {
            sbstVO = examService.selectProfSbstQuiz(vo);
        }

        if ("Y".equals(examVO.getByteamSubrexamUseyn())) {
            examDtlInfoVO = examService.selectProfExamTeamDtl(vo);

            // examDtlInfoVO의 모든 항목이 examVO와 동일한 examCts, examTtl을 가질 경우 = 부 주제 미사용(N)
            // 하나라도 다를 경우 = 부 주제 사용(Y)
            if (examDtlInfoVO != null && !examDtlInfoVO.isEmpty()) {
                String baseExamCts = StringUtil.nvl(examVO.getExamCts());
                String baseExamTtl = StringUtil.nvl(examVO.getExamTtl());
                boolean allSame = examDtlInfoVO.stream().allMatch(dtl ->
                        baseExamCts.equals(StringUtil.nvl(dtl.getExamCts())) &&
                                baseExamTtl.equals(StringUtil.nvl(dtl.getExamTtl()))
                );
                examVO.setLrnGrpSubsbjctUseyn(allSame ? "N" : "Y");
            }
        }
        model.addAttribute("vo", vo);
        model.addAttribute("examVO", examVO);
        model.addAttribute("sbstVO", sbstVO);
        model.addAttribute("gbn", gbn);
        model.addAttribute("examDtlInfoVO", examDtlInfoVO);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("sbjctId", StringUtil.nvl(vo.getSbjctId()));
        model.addAttribute("examType", StringUtil.nvl(vo.getExamType()));
        examVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, examBscId));
        // 임시로 prof 경로 추가
        return "exam/prof/exam_info_sbst_write";
    }

    /*****************************************************
     * 시험 관리 페이지 (결시 내용 및 현황 탭)
     * @param ExamVO
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamAbsnceView.do")
    public String profExamAbsnceView(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String tabType = StringUtil.nvl(vo.getTabType());
        String examBscId = StringUtil.nvl(vo.getExamBscId());
        String tkexamMthdCd = StringUtil.nvl(vo.getTkexamMthdCd());
        String byteamSubrexamUseyn = StringUtil.nvl(vo.getByteamSubrexamUseyn());

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        ExamVO examVO = examService.selectProfExamDtl(vo);
        List<ExamVO> examDtlInfoVO = null;
        if ("Y".equals(examVO.getByteamSubrexamUseyn())) {
            examDtlInfoVO = examService.selectProfExamTeamDtl(vo);

            // examDtlInfoVO의 모든 항목이 examVO와 동일한 examCts, examTtl을 가질 경우 = 부 주제 미사용(N)
            // 하나라도 다를 경우 = 부 주제 사용(Y)
            if (examDtlInfoVO != null && !examDtlInfoVO.isEmpty()) {
                String baseExamCts = StringUtil.nvl(examVO.getExamCts());
                String baseExamTtl = StringUtil.nvl(examVO.getExamTtl());
                boolean allSame = examDtlInfoVO.stream().allMatch(dtl ->
                        baseExamCts.equals(StringUtil.nvl(dtl.getExamCts())) &&
                                baseExamTtl.equals(StringUtil.nvl(dtl.getExamTtl()))
                );
                examVO.setLrnGrpSubsbjctUseyn(allSame ? "N" : "Y");
            }
        }
        model.addAttribute("vo", vo);
        model.addAttribute("examVO", examVO);
        model.addAttribute("examDtlInfoVO", examDtlInfoVO);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("sbjctId", StringUtil.nvl(vo.getSbjctId()));
        model.addAttribute("examType", StringUtil.nvl(vo.getExamType()));
        examVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, examBscId));
        // 임시로 prof 경로 추가
        return "exam/prof/exam_info_absnce";
    }

    /*****************************************************
     * 시험 관리 페이지 (장애인/고령자 지원 현황 탭)
     * @param ExamVO
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamDsblView.do")
    public String profExamDsblView(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String tabType = StringUtil.nvl(vo.getTabType());
        String examBscId = StringUtil.nvl(vo.getExamBscId());
        String tkexamMthdCd = StringUtil.nvl(vo.getTkexamMthdCd());
        String byteamSubrexamUseyn = StringUtil.nvl(vo.getByteamSubrexamUseyn());

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        ExamVO examVO = examService.selectProfExamDtl(vo);
        List<ExamVO> examDtlInfoVO = null;
        if ("Y".equals(examVO.getByteamSubrexamUseyn())) {
            examDtlInfoVO = examService.selectProfExamTeamDtl(vo);

            // examDtlInfoVO의 모든 항목이 examVO와 동일한 examCts, examTtl을 가질 경우 = 부 주제 미사용(N)
            // 하나라도 다를 경우 = 부 주제 사용(Y)
            if (examDtlInfoVO != null && !examDtlInfoVO.isEmpty()) {
                String baseExamCts = StringUtil.nvl(examVO.getExamCts());
                String baseExamTtl = StringUtil.nvl(examVO.getExamTtl());
                boolean allSame = examDtlInfoVO.stream().allMatch(dtl ->
                        baseExamCts.equals(StringUtil.nvl(dtl.getExamCts())) &&
                                baseExamTtl.equals(StringUtil.nvl(dtl.getExamTtl()))
                );
                examVO.setLrnGrpSubsbjctUseyn(allSame ? "N" : "Y");
            }
        }
        model.addAttribute("vo", vo);
        model.addAttribute("examVO", examVO);
        model.addAttribute("examDtlInfoVO", examDtlInfoVO);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("sbjctId", StringUtil.nvl(vo.getSbjctId()));
        model.addAttribute("examType", StringUtil.nvl(vo.getExamType()));
        examVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, examBscId));
        // 임시로 prof 경로 추가
        return "exam/prof/exam_info_dsbl";
    }

    /*****************************************************
     * 시험 관리 페이지 (퀴즈관리 탭)
     * @param ExamVO
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamQuizMngView.do")
    public String profExamQuizMngView(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String tabType = StringUtil.nvl(vo.getTabType());
        String examBscId = StringUtil.nvl(vo.getExamBscId());
        String tkexamMthdCd = StringUtil.nvl(vo.getTkexamMthdCd());
        String byteamSubrexamUseyn = StringUtil.nvl(vo.getByteamSubrexamUseyn());

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        ExamVO examVO = examService.selectProfExamDtl(vo);
        List<ExamVO> examDtlInfoVO = null;
        if ("Y".equals(examVO.getByteamSubrexamUseyn())) {
            examDtlInfoVO = examService.selectProfExamTeamDtl(vo);

            // examDtlInfoVO의 모든 항목이 examVO와 동일한 examCts, examTtl을 가질 경우 = 부 주제 미사용(N)
            // 하나라도 다를 경우 = 부 주제 사용(Y)
            if (examDtlInfoVO != null && !examDtlInfoVO.isEmpty()) {
                String baseExamCts = StringUtil.nvl(examVO.getExamCts());
                String baseExamTtl = StringUtil.nvl(examVO.getExamTtl());
                boolean allSame = examDtlInfoVO.stream().allMatch(dtl ->
                        baseExamCts.equals(StringUtil.nvl(dtl.getExamCts())) &&
                                baseExamTtl.equals(StringUtil.nvl(dtl.getExamTtl()))
                );
                examVO.setLrnGrpSubsbjctUseyn(allSame ? "N" : "Y");
            }
        }
        model.addAttribute("vo", vo);
        model.addAttribute("examVO", examVO);
        model.addAttribute("examDtlInfoVO", examDtlInfoVO);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("sbjctId", StringUtil.nvl(vo.getSbjctId()));
        model.addAttribute("examType", StringUtil.nvl(vo.getExamType()));
        examVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, examBscId));
        // 임시로 prof 경로 추가
        return "exam/prof/exam_info_quiz_mng";
    }

    /*****************************************************
     * 시험 관리 페이지 (퀴즈관리 탭)
     * @param ExamVO
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamQuizMngWrite.do")
    public String profExamQuizMngWrite(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String examBscId = StringUtil.nvl(vo.getExamBscId());
        String gbn = StringUtil.nvl(vo.getGbn());
        String tkexamMthdCd = StringUtil.nvl(vo.getTkexamMthdCd());
        String byteamSubrexamUseyn = StringUtil.nvl(vo.getByteamSubrexamUseyn());

        List<ExamVO> examDtlInfoVO = null;
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        ExamVO examVO = examService.selectProfExamDtl(vo);
        ExamVO quizVO = examService.selectProfQuizMng(vo);

        if ("Y".equals(examVO.getByteamSubrexamUseyn())) {
            examDtlInfoVO = examService.selectProfExamTeamDtl(vo);

            // examDtlInfoVO의 모든 항목이 examVO와 동일한 examCts, examTtl을 가질 경우 = 부 주제 미사용(N)
            // 하나라도 다를 경우 = 부 주제 사용(Y)
            if (examDtlInfoVO != null && !examDtlInfoVO.isEmpty()) {
                String baseExamCts = StringUtil.nvl(examVO.getExamCts());
                String baseExamTtl = StringUtil.nvl(examVO.getExamTtl());
                boolean allSame = examDtlInfoVO.stream().allMatch(dtl ->
                        baseExamCts.equals(StringUtil.nvl(dtl.getExamCts())) &&
                                baseExamTtl.equals(StringUtil.nvl(dtl.getExamTtl()))
                );
                examVO.setLrnGrpSubsbjctUseyn(allSame ? "N" : "Y");
            }
        }
        model.addAttribute("vo", vo);
        model.addAttribute("examVO", examVO);
        model.addAttribute("quizVO", quizVO);
        model.addAttribute("gbn", gbn);
        model.addAttribute("examDtlInfoVO", examDtlInfoVO);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("sbjctId", StringUtil.nvl(vo.getSbjctId()));
        model.addAttribute("examType", StringUtil.nvl(vo.getExamType()));
        examVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, examBscId));
        // 임시로 prof 경로 추가
        return "exam/prof/exam_info_quiz_write";
    }

    /*****************************************************
     * 사용자 시험 응시현황 (파이)차트데이터 조회(팝업)
     * @param ExamVO
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamUserTkexamStatusPieChartPopup.do")
    public String selectUserTkexamStatusForPieChart(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        model.addAttribute("chartMap", examService.selectUserTkexamStatusForPieChart(vo.getExamBscId(), vo.getSbjctId()));

        return "exam/prof/popup/exam_user_tkexam_status_piechart_pop";
    }

    /*****************************************************
     * 사용자 시험 응시현황 (가로선)차트데이터 조회(팝업)
     * @param ExamVO
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamUserTkexamStatusHrChartPopup.do")
    public String selectUserTkexamStatusForHrChart(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        model.addAttribute("chartMap", examService.selectUserTkexamStatusForPieChart(vo.getExamBscId(), vo.getSbjctId()));
        model.addAttribute("chartList", examService.selectUserTkexamStatusForHrChart(vo.getExamBscId(), vo.getSbjctId()));

        return "exam/prof/popup/exam_user_tkexam_status_hrchart_pop";
    }

    /*****************************************************
     * 교수 메모 조회(팝업)
     * @param Map<String, Object>
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamMemoPopup.do")
    public String profQuizMemoPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {
        QuizMainView quizMainView = quizFacadeService.loadProfQuizMemoPopup(params);

        model.addAttribute("vo", quizMainView.getExamBscVO());
        model.addAttribute("quizExamnee", quizMainView.getQuizExamnee());
        model.addAttribute("profMemo", quizMainView.getProfMemo());

        return "exam/prof/popup/prof_exam_memo_pop";
    }

    /*****************************************************
     * 교수 시험 응시이력(팝업)
     * @param TkexamVO
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamTkexamHstryPopup.do")
    public String profExamTkexamHstryPopup(TkexamVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        QuizMainView quizMainView = quizFacadeService.loadProfQuizTkexamHstryPopup(vo);
        model.addAttribute("quizExamnee", quizMainView.getQuizExamnee());
        model.addAttribute("tkexamHstryList", quizMainView.getTkexamHstryList());

        return "exam/prof/popup/prof_exam_tkexam_hstry_pop";
    }

    /*****************************************************
     * 교수 시험 엑셀 성적등록(팝업)
     * @param ExamBscVO
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamExcelScrRegistPopup.do")
    public String profQuizExcelScrRegistPopup(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        request.setAttribute("vo", vo);

        vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM));

        model.addAttribute("vo", vo);
        model.addAttribute("userId", userId);

        return "exam/prof/popup/prof_exam_excel_scr_regist_pop";
    }

    /*****************************************************
     * 결시자 결시신청 결과 조회(팝업)
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsnceUserRsltPopup.do")
    public String selectAbsnceRslt(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String examBscId = vo.getExamBscId();
        String userId = vo.getUserId();

        vo.setExamBscId(examBscId);
        vo.setUserId(userId);
        ExamVO examVO = examService.selectAbsnceRslt(vo);
        model.addAttribute("absnceRslt", examVO);
        return "exam/prof/popup/prof_exam_absnce_rslt_pop";
    }

    /*****************************************************
     * 결시자 결시신청 이력 목록 페이징(팝업)
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsnceUserHstrPagingPopup.do")
    public String listAbsnceUserHstrPaging(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String examBscId = vo.getExamBscId();
        String userId = vo.getUserId();

        resultVO = examService.listAbsnceUserHstrPaging(vo);
        model.addAttribute("absnceHstr", resultVO);
        return "exam/prof/popup/prof_exam_absnce_hstr_pop";
    }

    /*****************************************************
     * 장애인/고령자 시험 지원 상세 조회(팝업)
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examDsblUserDtlPopup.do")
    public String selectDsblDtl(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String sbjctId = vo.getSbjctId();
        String userId = vo.getUserId();

        vo.setSbjctId(sbjctId);
        vo.setUserId(userId);
        ExamVO examVO = examService.selectDsblDtl(vo);
        model.addAttribute("dsblDtl", examVO);
        return "exam/prof/popup/prof_exam_dsbl_dtl_pop";
    }

    /*****************************************************
     * 응시현황 차트데이터 조회(팝업) (시험 메인 페이지)
     * @param ExamVO
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/tkexamStatListPopup.do")
    public String selectTkexamStat(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String midBscId = null;
        String lstBscId = null;
        String sbjctId = vo.getSbjctId();

        List<EgovMap> examMidLst = examService.listExamMidLst(sbjctId);
        for (EgovMap exam : examMidLst) {
            String examGbncd = StringUtil.nvl((String) exam.get("examGbncd"));
            if (examGbncd.contains("MID")) {
                midBscId = StringUtil.nvl((String) exam.get("examBscId"));
            } else if (examGbncd.contains("LST")) {
                lstBscId = StringUtil.nvl((String) exam.get("examBscId"));
            }
        }

        // 중간고사 (가로선) 차트 데이터 조회
        model.addAttribute("midChartMap", examService.selectUserTkexamStatusForPieChart(midBscId, sbjctId));
        model.addAttribute("midChartList", examService.selectUserTkexamStatusForHrChart(midBscId, sbjctId));

        // 기말고사 (가로선) 차트 데이터 조회
        model.addAttribute("lstChartMap", examService.selectUserTkexamStatusForPieChart(lstBscId, sbjctId));
        model.addAttribute("lstChartList", examService.selectUserTkexamStatusForHrChart(lstBscId, sbjctId));

        model.addAttribute("vo", vo);
        return "exam/prof/popup/exam_user_tkexam_status_list_pop";
    }

    /*****************************************************
     * 시험 등록
     * @param ExamBscVO
     * @param RequestParam
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/examRegist.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<ExamBscVO> examRegist(ExamBscVO vo, @RequestParam(value = "dtlInfos", defaultValue = "[]") String dtlInfoStr, ModelMap model, HttpServletRequest request) throws Exception{
        ProcessResultVO<ExamBscVO> resultVO = new ProcessResultVO<ExamBscVO>();
        ObjectMapper mapper = new ObjectMapper();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }

//            vo.setSbjctId("SBJCT_OFRNG_ID2");       // 과목 ID (임시 하드코딩 추후 vo 에서 가져오도록 설정)
            vo.setLctrWknoSchdlId(null);            // 강의주차 일정 아이디  (임시)
            vo.setExamGrpId(null);                  // 시험 그룹 ID (임시)
            vo.setQstnDsplyGbncd("WHOL");           // 문항 화면표시 구분코드 (임시)
            vo.setAvgMrkOyn(null);                  // 평균성적 공개여부 (임시)
            vo.setMrkOpenSdttm(null);               // 성적공개 시작일시 (임시)
            vo.setImdtAnswShtInqyn(null);           // 즉시답안 조회여부 (임시)
            vo.setMaxTkexamCnt(99);                 // 최대응시 횟수 (임시)
            vo.setQstnRndmyn("N");                  // 문항 무작위 여부 (임시)
            vo.setQstnVwitmRndmyn("N");             // 문항보기 항목 무작위 여부 (임시)
            vo.setQstnCnddtUseyn("N");              // 문항후보 사용여부 (임시)
            vo.setMrkRfltrt(0);                     // 성적 반영비율 (임시)
            vo.setLrnGrpSubasmtStngyn("N");         // 학습그룹 부과제 설정여부 (임시)
            vo.setExamTycd("EXAM");                 // 시험 유형코드 (시험만 등록되므로 하드코딩)

            vo.setExamtmAllocGbncd("REMAINDER");    // 시험시간 배정 구분코드
            vo.setExamtmExpsrTycd("LEFT");          // 시험시간 노출 유형코드
            vo.setRgtrId(userId);                   // (세션) 등록자 ID
            vo.getExamDtlVO().setRgtrId(userId);    // (세션) 등록자 ID
            vo.getExamDtlVO().setDtlInfos(mapper.readValue(dtlInfoStr, new TypeReference<List<Map<String, Object>>>() {
            }));

            resultVO.setReturnVO(examService.examRegist(vo));
            resultVO.setResultSuccess();
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 대체 시험 등록
     * @param ExamBscVO
     * @param RequestParam
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/examSbstRegist.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<ExamVO> examSbstRegist(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception{
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setRgtrId(userId);
        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }

            resultVO.setReturnVO(examService.examSbstRegist(vo));
            resultVO.setResultSuccess();
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 교수 시험성적 엑셀 업로드&등록
     * @param ExamBscVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamScrExcelUpload.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<ExamBscVO> profExamScrExcelUpload(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamBscVO> resultVO = new ProcessResultVO<ExamBscVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);

        try {
            List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());

            FileVO fileVO = new FileVO();
            fileVO.setUploadFiles(vo.getUploadFiles());
            fileVO.setCopyFiles(vo.getCopyFiles());
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setRgtrId(vo.getRgtrId());

            //엑셀 읽기위한 정보값 세팅
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("startRaw", 5);
            map.put("excelGrid", vo.getExcelGrid());
            map.put("fileVO", fileVO);
            map.put("searchKey", "excelUpload");

            //엑셀 리더
            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<?> list = excelUtilPoi.simpleReadGrid(map);

            //읽어온 값으로 update
            //examStareService.updateExampleExcelStareScore(vo, list);
            resultVO.setResult(1);
            //resultVO.setMessage(getMessage("exam.alert.save.score"));/* 점수 저장이 완료되었습니다. */

        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    /*****************************************************
     * 교수 시험목록 페이징
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamPaging.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> listProfExamPaging(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String examTtl = vo.getExamTtl();
        String sbjctId = vo.getSbjctId() == null ? "SBJCT_OFRNG_ID2" : vo.getSbjctId();

        vo.setOrgId(orgId);
        vo.setExamTtl(examTtl);
        vo.setSbjctId(sbjctId);
        try {
            resultVO = examService.listProfExamPaging(vo);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 교수 시험 상세 조회
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamDtl.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> selectProfExamDtl(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        try {
            // 필수 파라미터 체크
            String examBscId = vo.getExamBscId();

            if (examBscId == null || examBscId.isEmpty()) {
                resultVO.setResultFailed();
                resultVO.setMessage("시험 ID가 필요합니다.");
                return resultVO;
            }

            ExamVO examVO = examService.selectProfExamDtl(vo);

            if(examVO == null) {
                resultVO.setResultFailed();
                resultVO.setMessage("해당 시험 정보를 찾을 수 없습니다.");
            } else {
                resultVO.setReturnVO(examVO);
                resultVO.setResultSuccess();
                resultVO.setMessage("성공 메시지");
            }
        } catch(Exception e) {
            LOGGER.error("시험 상세 조회 실패", e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 평가대상자 목록 페이징
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/tkexamUserPaging.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> listTkexamUserPaging(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String examBscId = vo.getExamBscId();
        String byteamSubrexamUseyn = vo.getByteamSubrexamUseyn();
        String sbjctId = vo.getSbjctId() == null ? "SBJCT_OFRNG_ID2" : vo.getSbjctId();

        vo.setExamBscId(examBscId);
        vo.setSbjctId(sbjctId);
        try {
            // 시험 평가대상자
            resultVO = examService.listTkexamUserPaging(vo);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 평가대상자 인원 조회
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/tkexamUserCount.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> listTkexamUserCount(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String examBscId = vo.getExamBscId();
        String byteamSubrexamUseyn = vo.getByteamSubrexamUseyn();
        String sbjctId = vo.getSbjctId() == null ? "SBJCT_OFRNG_ID2" : vo.getSbjctId();

        vo.setExamBscId(examBscId);
        vo.setSbjctId(sbjctId);
        try {
            resultVO = examService.listTkexamUserPaging(vo);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 학습그룹 부주제 목록 조회
     * @param ExamDtlVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examLrnGrpSubAsmtListAjax.do")
    @ResponseBody
    public ProcessResultVO<ExamDtlVO> examLrnGrpSubAsmtListAjax(ExamDtlVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamDtlVO> resultVO = new ProcessResultVO<ExamDtlVO>();

        try {
            resultVO.setReturnList(examService.quizLrnGrpSubAsmtList(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /*****************************************************
     * 교수 시험대체 목록 페이징
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examSbstPaging.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> listProfSbstPaging(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String examBscId = vo.getExamBscId();

        vo.setExamBscId(examBscId);
        try {
            resultVO = examService.listProfSbstPaging(vo);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 교수 시험대체 대상자 목록 페이징
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examSbstUserPaging.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> listProfSbstUserPaging(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String examBscId = vo.getExamBscId();

        vo.setExamBscId(examBscId);
        try {
            resultVO = examService.listProfSbstUserPaging(vo);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 교수 시험 결시자 목록 페이징
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsnceUserPaging.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> listProfAbsnceUserPaging(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String examBscId = vo.getExamBscId();

        vo.setExamBscId(examBscId);
        try {
            resultVO = examService.listProfAbsnceUserPaging(vo);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 장애인/고령자 시험 지원 목록 페이징
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/dsblUserPaging.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> listDsblUserPaging(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String sbjctId = vo.getSbjctId();

        vo.setSbjctId(sbjctId);
        try {
            resultVO = examService.listDsblUserPaging(vo);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 교수 시험대체 목록 페이징
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examQuizPaging.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> listExamQuizPaging(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String examBscId = vo.getExamBscId();

        vo.setExamBscId(examBscId);
        try {
            resultVO = examService.listExamQuizPaging(vo);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 수강생 시험 응시현황 목록 페이징
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/tkexamStatPaging.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> listUserTkexamStatPaging(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String sbjctId = vo.getSbjctId();

        vo.setSbjctId(sbjctId);
        try {
            resultVO = examService.listUserTkexamStatPaging(vo);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 성적 공개여부 수정
     * @param ExamVO
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editMrkOyn.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<ExamVO> updateMrkOyn(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception{
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String mrkOyn = vo.getMrkOyn();
        String examBscId = vo.getExamBscId();

        vo.setMrkOyn(mrkOyn);
        vo.setExamBscId(examBscId);
        try {
            examService.updateMrkOyn(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 성적 반영비율 수정
     * @param List<ExamBscVO>
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editMrkRfltrt.do")
    @ResponseBody
    public ProcessResultVO<ExamBscVO> examMrkRfltrtModifyAjax(@RequestBody List<ExamBscVO> list, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamBscVO> resultVO = new ProcessResultVO<ExamBscVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            for(ExamBscVO vo : list) {
                vo.setMdfrId(userId);
            }
            examService.examMrkRfltrtListModify(list);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        }  catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 수정
     * @param ExamVO
     * @param dtlInfoStr
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/examModify.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<ExamVO> updateExamDtlInfo(ExamVO vo, @RequestParam(value = "dtlInfos", defaultValue = "[]") String dtlInfoStr, ModelMap model, HttpServletRequest request) throws Exception{
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();
        ObjectMapper mapper = new ObjectMapper();
        String examBscId = vo.getExamBscId();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }

            vo.setExamBscId(examBscId);
            vo.setRgtrId(userId);                   // 등록자 ID
            vo.setMdfrId(userId);                   // 수정자 ID
            vo.getExamDtlVO().setRgtrId(userId);    // 등록자 ID
            vo.getExamDtlVO().setMdfrId(userId);    // 등록자 ID
            vo.getExamDtlVO().setDtlInfos(mapper.readValue(dtlInfoStr, new TypeReference<List<Map<String, Object>>>() {
            }));

            examService.updateExamDtlInfo(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        }  catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /*****************************************************
     * 교수 시험 평가점수 일괄 수정
     * @param List<Map<String, Object>>
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamEvlScrBulkModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> profExamEvlScrBulkModifyAjax(@RequestBody List<Map<String, Object>> list, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            for(Map<String, Object> map : list) {
                map.put("rgtrId", userId);
            }
            tkexamRsltService.profQuizEvlScrBulkModify(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("점수 수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /*****************************************************
     * 대체 시험 수정
     * @param ExamVO
     * @param dtlInfoStr
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/examSbstModify.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<ExamVO> updateSbstAsmt(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception{
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setMdfrId(userId);                   // 수정자 ID
        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }

            examService.updateExamSbst(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        }  catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 삭제
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/examDelete.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<ExamVO> deleteExamBsc(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception{
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String mrkOyn = vo.getMrkOyn();
        String examBscId = vo.getExamBscId();
        String byteamSubrexamUseyn = vo.getByteamSubrexamUseyn();

        vo.setMrkOyn(mrkOyn);
        vo.setExamBscId(examBscId);
        vo.setByteamSubrexamUseyn(byteamSubrexamUseyn);
        try {
            examService.deleteExamBsc(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 대체 시험 삭제
     * @param ExamVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/examSbstDelete.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<ExamVO> examSbstDelete(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception{
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setMdfrId(userId);                   // 수정자 ID
        try {
            examService.deleteExamSbst(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 대상자 엑셀 다운로드
     * @param ExamVO
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamTkexamStatusExcelDown.do")
    public String profExamTkexamStatusExcelDown(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        HashMap<String, Object> map = new HashMap<>();
        String title = "시험대상자목록";

        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("examBscId", vo.getExamBscId());
        params.put("tkexamCmptnyn", request.getParameter("tkexamCmptnyn"));
        params.put("evlyn", request.getParameter("evlyn"));
        params.put("searchValue", vo.getSearchValue());
        map.put("list", examService.tkexamUserList(params));
        map.put("ext", ".xlsx(big)");

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String currentDate = sdf.format(new Date());


        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + currentDate);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 시험 결시자 엑셀 다운로드
     * @param ExamVO
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profAbsnceStatusExcelDown.do")
    public String profAbsnceStatusExcelDown(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        HashMap<String, Object> map = new HashMap<>();
        String title = "결시대상자목록";

        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("examBscId", vo.getExamBscId());
        params.put("aplyStscd", request.getParameter("aplyStscd"));
        params.put("searchValue", vo.getSearchValue());
        map.put("list", examService.listProfAbsnceUser(params));
        map.put("ext", ".xlsx(big)");

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String currentDate = sdf.format(new Date());


        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + currentDate);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 시험 점수 업로드 샘플 엑셀 다운로드
     * @param ExamBscVO
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamScrRegistSampleExcelDown.do")
    public String profExamScrRegistSampleExcelDown(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String title = getMessage("exam.label.std.list"); // 학습자목록

        Map<String, Object> searchMap = new HashMap<String, Object>();
        searchMap.put("examBscId", vo.getExamBscId());
        List<EgovMap> tkexamList = tkexamService.quizTkexamList(searchMap);

        // POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        // 엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);  // 시험학습자목록
        map.put("sheetName", title);   // 학습자목록
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", tkexamList);

        HashMap<String, Object> params = new HashMap<>();
        params.put("outFileName", title);  // 학습자목록
        params.put("sheetName", title);    // 학습자목록
        params.put("list", tkexamList);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        params.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(params);

        return "excelView";
    }

    /*****************************************************
     * 장애인/고령자 시험지원 엑셀 다운로드
     * @param ExamVO
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profExamDsblStatusExcelDown.do")
    public String profExamDsblStatusExcelDown(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        HashMap<String, Object> map = new HashMap<>();
        String title = "지원대상자목록";

        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("sbjctId", vo.getSbjctId());
        params.put("aplyStscd", request.getParameter("aplyStscd"));
        params.put("searchValue", vo.getSearchValue());
        map.put("list", examService.dsblUserList(params));
        map.put("ext", ".xlsx(big)");

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String currentDate = sdf.format(new Date());


        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + currentDate);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 기존에 있던 Controller 영역
     *****************************************************/

    /*****************************************************
     * 중간/기말 대체 과제 목록 (교수)
     * @param ExamVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examListByInsRef.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> examListByInsRef(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setUserId(userId);
            List<EgovMap> examList = examService.listExamByInsRef(vo);
            resultVO.setReturnList(examList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 중간/기말 수시, 외국어 시험 목록 (교수)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examListByEtc.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> examListByEtc(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        try {
            List<ExamVO> examList = examService.listExamByEtc(vo);
            resultVO.setReturnList(examList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 장애인 시험지원 엑셀 다운로드 (교수)
     * @param ExamDsblReqVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examDsblReqExcelDown.do")
    public String examDsblReqExcelDown(ExamDsblReqVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String orgId = SessionInfo.getOrgId(request);

        vo.setOrgId(orgId);
        vo.setPagingYn("N");

        String title = getMessage("exam.label.dsbl.req.list"); // 장애인시험지원목록

        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);       // 장애인시험지원목록
        map.put("sheetName", title);   // 장애인시험지원목록
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", examDsblReqService.list(vo).getReturnList());

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title);    // 장애인시험지원목록

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 결시원 엑셀 다운로드 (교수)
     * @param ExamAbsentVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsentExcelDown.do")
    public String examAbsentExcelDown(ExamAbsentVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String title = getMessage("exam.label.exam.absent.list"); // 결시원목록

        Locale locale = LocaleUtil.getLocale(request);
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);        // 결시원목록
        map.put("sheetName", title);    // 결시원목록
        map.put("excelGrid", vo.getExcelGrid());

        vo.setPagingYn("N");
        map.put("list", examAbsentService.listPaging(vo).getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title); // 결시원목록

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 결시원 목록 가져오기 ajax (공통)
     * @param ExamAbsentVO
     * @return ProcessResultVO<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsentList.do")
    @ResponseBody
    public ProcessResultVO<ExamAbsentVO> examAbsentList(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamAbsentVO> resultVO = new ProcessResultVO<ExamAbsentVO>();

        try {
            List<ExamAbsentVO> absentList = examAbsentService.list(vo);
            resultVO.setReturnList(absentList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 결시원 목록 가져오기 ajax (공통) 페이징
     * @param ExamAbsentVO
     * @return ProcessResultVO<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsentListPaging.do")
    @ResponseBody
    public ProcessResultVO<ExamAbsentVO> examAbsentListPaging(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamAbsentVO> resultVO = new ProcessResultVO<ExamAbsentVO>();

        try {
            resultVO = examAbsentService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 서약서 제출 목록 팝업 (교수)
     * @param ExamVO
     * @return "exam/popup/exam_oath_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examOathPop.do")
    public String examOathPop(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        ExamVO examVO = examService.select(vo);
        request.setAttribute("vo", examVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);

        TermVO termVO = new TermVO();
        termVO.setTermCd(creCrsVO.getTermCd());
        termVO = termService.select(termVO);
        request.setAttribute("termVO", termVO);
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        return "exam/popup/exam_oath_pop";
    }

    /*****************************************************
     * 시험 서약서 목록 가져오기 ajax (교수)
     * @param ExamOathVO
     * @return ProcessResultVO<ExamOathVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/oathListPaging.do")
    @ResponseBody
    public ProcessResultVO<ExamOathVO> oathListPaging(ExamOathVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamOathVO> resultVO = new ProcessResultVO<ExamOathVO>();

        try {
            resultVO = examOathService.listOathByCreCrsPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /***************************************************** 
     * 시험 서약서 엑셀 다운로드
     * @param ExamOathVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/oathExcelDown.do")
    public String oathExcelDown(ExamOathVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        vo.setPagingYn("N");

        String title = getMessage("exam.label.oath.submit.list"); // 서약서 제출 목록

        Locale locale = LocaleUtil.getLocale(request);
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);     // 서약서 제출 목록
        map.put("sheetName", title); // 서약서 제출 목록
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", examOathService.listOathByCreCrsPaging(vo).getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title);  // 서약서 제출 목록

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 시험 서약서 양식 팝업 (공통)
     * @param ExamOathVO
     * @return "exam/popup/exam_oath_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examOathViewPop.do")
    public String examOathViewPop(ExamOathVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        request.setAttribute("vo", vo);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);

        TermVO termVO = new TermVO();
        termVO.setTermCd(creCrsVO.getTermCd());
        termVO = termService.select(termVO);
        request.setAttribute("termVO", termVO);

        if(!"".equals(StringUtil.nvl(vo.getStdId()))) {
            StdVO stdVO = new StdVO();
            stdVO.setStdId(vo.getStdId());
            stdVO = stdService.select(stdVO);
            request.setAttribute("stdVO", stdVO);
        }
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        return "exam/popup/exam_oath_view_pop";
    }

    /*****************************************************
     * 시험 서약서 제출 정보 ajax (학생)
     * @param ExamOathVO
     * @return ProcessResultVO<ExamOathVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewOath.do")
    @ResponseBody
    public ProcessResultVO<ExamOathVO> viewOath(ExamOathVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ExamOathVO> resultVO = new ProcessResultVO<ExamOathVO>();

        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsVO = crecrsService.selectCreCrs(creCrsVO);

            ErpEnrollmentVO enrollmentVO = new ErpEnrollmentVO();
            enrollmentVO.setYear(creCrsVO.getCreYear());
            enrollmentVO.setSemester(creCrsVO.getCreTerm());
            enrollmentVO.setCourseCode(creCrsVO.getCrsCd());
            enrollmentVO.setSection(creCrsVO.getDeclsNo());
            enrollmentVO.setStudentId(SessionInfo.getUserId(request));

            enrollmentVO = erpService.selectCourseEnrollment(enrollmentVO);
            resultVO.setReturnVO(enrollmentVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 서약서 제출 ajax (학생)
     * @param ExamOathVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/submitOath.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> submitOath(ExamOathVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        Locale locale = LocaleUtil.getLocale(request);
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            vo.setOrgId(orgId);
            vo.setRgtrId(vo.getUserId());
            vo.setMdfrId(vo.getUserId());
            examOathService.insert(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.oath.submit"));/* 서약서 제출 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 중간/기말 참여현황 페이지 (교수)
     * @param ExamVO
     * @return "exam/exam_stare_join_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/examStareJoinList.do")
    public String examStareJoinListForm(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("vo", vo);
        request.setAttribute("creCrsVO", creCrsVO);
        request.setAttribute("waitVO", examService.selectExamWait(vo));
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        request.setAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "exam/exam_stare_join_list";
    }

    /*****************************************************
     * 중간/기말 참여현황 엑셀 다운로드 (교수)
     * @param ExamVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examStareExcelDown.do")
    public String examStareExcelDown(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        Locale locale = LocaleUtil.getLocale(request);
        String title = "";
        if("ADMISSION".equals(StringUtil.nvl(vo.getExamType()))) {
            title = getMessage("exam.label.admission.std.list");/* 수시평가학습자목록 */
        } else {
            title = getMessage("exam.label.mid.end.exam.std.list");/* 중간기말학습자목록 */
        }
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", examStareService.listExamStareStatus(vo));

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 중간/기말 성적 가로바차트 ajax (교수)
     * @param ForumStareVO
     * @return ProcessResultVO<ExamStareVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewExamScoreHorizontalBarChart.do")
    @ResponseBody
    public ProcessResultVO<ExamStareVO> viewExamScoreHorizontalBarChart(ExamStareVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamStareVO> resultVO = new ProcessResultVO<ExamStareVO>();

        try {
            List<ExamStareVO> statusList = examStareService.listStuExamScoreStatus(vo);
            resultVO.setReturnList(statusList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 중간/기말 성적 세로바차트 ajax (교수)
     * @param ForumStareVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewExamScoreBarChart.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> viewExamScoreBarChart(ExamStareVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            EgovMap statusMap = examStareService.selectExamScoreStatus(vo);
            resultVO.setReturnVO(statusMap);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }

        return resultVO;
    }

    /*****************************************************
     * 중간/기말 참여현황 목록 ajax (교수)
     * @param ExamVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examStareJoinList.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> examStareJoinList(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            List<EgovMap> joinStatus = examStareService.listExamStareStatus(vo);
            resultVO.setReturnList(joinStatus);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 등록 (교수)
     * @param ExamVO
     * @return "redirect:/exam/Form/examList.do"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeExam.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> writeExam(ExamVO vo, AsmtVO asmtVO, ForumVO forumVO, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setOrgId(orgId);
            vo.setExamCtgrCd("EXAM");
            vo.setUseYn("Y");
            vo.setRegYn("Y");
            resultVO.setReturnVO(examService.insertExam(vo));
            examService.examInsRefManage(vo, asmtVO, forumVO, request);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.insert.ins.ref"));/* 대체평가 등록 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 수정 페이지 (교수)
     * @param ExamVO
     * @return "exam/exam_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/examEdit.do")
    public String examEditForm(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        ExamVO examVO = examService.select(vo);
        model.addAttribute("vo", examVO);

        if("".equals(StringUtil.nvl(vo.getExamCd()))) {
            throw new BadRequestUrlException(getMessage("exam.error.not.exist.exam"));/* 시험 정보가 존재하지 않습니다. */
        }

        if(!"".equals(StringUtil.nvl(examVO.getInsRefCd()))) {
            // 퀴즈
            String insRefType = StringUtil.nvl(examVO.getInsRefCd()).split("_")[0];
            if("EXAM".equals(insRefType)) {
                ExamVO quizVO = new ExamVO();
                quizVO.setExamCd(examVO.getInsRefCd());
                quizVO = examService.select(quizVO);
                model.addAttribute("quizVO", quizVO);
                // 과제
            } else if("ASMNT".equals(insRefType)) {
                AsmtVO asmtVO = new AsmtVO();
                asmtVO.setAsmtId(examVO.getInsRefCd());
                asmtVO.setUserId(userId);
                asmtVO.setCrsCreCd(examVO.getCrsCreCd());
                asmtVO = (AsmtVO) asmntService.selectObject(asmtVO).getReturnVO();
                model.addAttribute("asmntVO", asmtVO);
                // 토론
            } else if("FORUM".equals(insRefType)) {
                ForumVO forumVO = new ForumVO();
                forumVO.setForumCd(examVO.getInsRefCd());
                forumVO = forumService.selectForum(forumVO);
                model.addAttribute("forumVO", forumVO);
            }
        }

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.select(creCrsVO);

        // 성적처리 일정
        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setOrgId(SessionInfo.getOrgId(request));
        sysJobSchVO.setHaksaYear(creCrsVO.getCreYear());
        sysJobSchVO.setHaksaTerm(creCrsVO.getCreTerm());
        sysJobSchVO.setCalendarCtgr("00210206");
        sysJobSchVO = sysJobSchService.select(sysJobSchVO);

        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        model.addAttribute("examType", StringUtil.nvl(vo.getExamType()));
        model.addAttribute("sysJobSchVO", sysJobSchVO);

        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        return "exam/exam_write";
    }

    /*****************************************************
     * 시험 수정 (교수)
     * @param ExamVO
     * @return "redirect:/exam/Form/examList.do"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editExam.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> editExam(ExamVO vo, AsmtVO asmtVO, ForumVO forumVO, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);

        try {
            examService.examInsRefManage(vo, asmtVO, forumVO, request);
            resultVO.setReturnVO(examService.updateExam(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.insert.ins.ref"));/* 대체평가 등록 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 응시 유형별 카운트
     * @param ExamVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectStareTypeCount.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> selectStareTypeCount(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            int cnt = examService.selectStareTypeCount(vo);
            resultVO.setResult(cnt);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 성적공개 수정 ajax (교수)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editExamScoreOpen.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> editExamScoreOpen(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        try {
            vo.setMdfrId(userId);
            examService.updateExamScoreOpen(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.update"));/* 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 삭제 ajax (교수)
     * @param ExamVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/delExam.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delExam(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        vo.setMdfrId(userId);

        try {
            ExamVO examVO = examService.select(vo);
            String examTypeCd = StringUtil.nvl(examVO.getExamTypeCd());
            String insRefCd = StringUtil.nvl(examVO.getInsRefCd()).split("_")[0];
            if(!"A".equals(StringUtil.nvl(vo.getExamStareTypeCd()))) {
                // (시험,대체) 퀴즈 삭제
                if("QUIZ".equals(examTypeCd) || ("EXAM".equals(examTypeCd) && "EXAM".equals(insRefCd))) {
                    ExamVO quizVO = new ExamVO();
                    quizVO.setExamCd(examVO.getInsRefCd());
                    quizVO.setMdfrId(vo.getMdfrId());
                    quizVO.setSearchKey("QUIZ");
                    examService.updateExamDelYn(quizVO);
                    // (시험,대체) 과제 삭제
                } else if("ASMNT".equals(examTypeCd) || ("EXAM".equals(examTypeCd) && "ASMNT".equals(insRefCd))) {
                    AsmtVO asmtVO = new AsmtVO();
                    asmtVO.setSearchMenu("delete");
                    asmtVO.setAsmtId(examVO.getInsRefCd());
                    asmtVO.setMdfrId(vo.getMdfrId());
                    asmntService.examAsmntManage(asmtVO, request);
                    // (시험,대체) 토론 삭제
                } else if("FORUM".equals(examTypeCd) || ("EXAM".equals(examTypeCd) && "FORUM".equals(insRefCd))) {
                    ForumVO forumVO = new ForumVO();
                    forumVO.setSearchMenu("delete");
                    forumVO.setForumCd(examVO.getInsRefCd());
                    forumVO.setMdfrId(vo.getMdfrId());
                    forumService.examForumManage(forumVO, request);
                }
            }

            if("insRef".equals(StringUtil.nvl(vo.getSearchKey()))) {
                vo.setExamTypeCd("EXAM".equals(examTypeCd) ? examTypeCd : "ETC");
                vo.setSearchFrom("EDIT");
                examService.updateExam(vo);
            } else {
                examService.updateExamDelYn(vo);
            }
            examVO.setGoUrl("EXAM");
            examService.setScoreRatio(examVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.delete"));/* 삭제 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 이전 시험 가져오기 팝업 (교수)
     * @param ExamVO
     * @return "exam/exam_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examCopyListPop.do")
    public String examCopyListPop(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        String orgId = SessionInfo.getOrgId(request);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setUserId(userId);
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        List<TermVO> termList = termService.list(termVO);
        request.setAttribute("vo", vo);
        request.setAttribute("termList", termList);

        return "exam/popup/exam_copy_list_pop";
    }

    /*****************************************************
     * 이전 시험 리스트 가져오기 ajax (학생)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examCopyList.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> examCopyList(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        try {
            vo.setOrgId(orgId);
            resultVO = examService.listMyCreCrsExam(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 이전 시험 가져오기 ajax (교수)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examCopy.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> examCopy(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamVO> returnVO = new ProcessResultVO<ExamVO>();

        try {
            ExamVO examVO = new ExamVO();
            examVO = examService.select(vo);
            returnVO.setReturnVO(examVO);
            returnVO.setResult(1);
        } catch(Exception e) {
            returnVO.setResult(-1);
            returnVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        return returnVO;
    }

    /*****************************************************
     * 시험 과제 등록 팝업 (교수)
     * @param AsmntVO
     * @return "exam/popup/exam_write_asmnt_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examWriteAsmntPop.do")
    public String examWriteAsmntPop(AsmtVO vo, ExamVO dateVO, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        vo.setUserId(userId);
        AsmtVO asmtVO = (AsmtVO) asmntService.selectObject(vo).getReturnVO();
        request.setAttribute("asmntVo", asmtVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("examTypeCd", vo.getSearchKey());
        request.setAttribute("creCrsVO", creCrsVO);

        ExamVO evo = new ExamVO();
        if(!"".equals(StringUtil.nvl(vo.getSearchFrom()))) {
            evo.setExamCd(StringUtil.nvl(vo.getSearchFrom()));
            evo = examService.select(evo);
        }
        request.setAttribute("evo", evo);
        request.setAttribute("dateVO", dateVO);

        return "exam/popup/exam_write_asmnt_pop";
    }

    /*****************************************************
     * 시험 과제 등록 ajax (교수)
     * @param AsmntVO
     * @return ProcessResultVO<AsmtVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/addAsmnt.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> addAsmnt(AsmtVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<AsmtVO> returnVO = new ProcessResultVO<AsmtVO>();
        vo.setUserId(userId);
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setSearchMenu("insert");

        try {
            returnVO = asmntService.examAsmntManage(vo, request);
            returnVO.setResult(1);
        } catch(Exception e) {
            returnVO.setResult(-1);
            returnVO.setMessage(getMessage("exam.error.insert"));/* 저장 중 에러가 발생하였습니다. */
        }
        return returnVO;
    }

    /*****************************************************
     * 시험 과제 수정 ajax (교수)
     * @param AsmntVO
     * @return ProcessResultVO<AsmtVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editAsmnt.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> editAsmnt(AsmtVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<AsmtVO> returnVO = new ProcessResultVO<AsmtVO>();
        vo.setUserId(userId);
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setSearchMenu("update");

        try {
            returnVO = asmntService.examAsmntManage(vo, request);
            returnVO.setResult(1);
        } catch(Exception e) {
            returnVO.setResult(-1);
            returnVO.setMessage(getMessage("exam.error.update"));/* 수정 중 에러가 발생하였습니다. */
        }
        return returnVO;
    }

    /*****************************************************
     * 시험 토론 등록 팝업 (교수)
     * @param ForumVO
     * @return "exam/popup/exam_write_forum_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examWriteForumPop.do")
    public String examWriteForumPop(ForumVO vo, ExamVO dateVO, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        ForumVO forumVO = forumService.selectForum(vo);
        request.setAttribute("forumVo", forumVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("examTypeCd", vo.getSearchKey());
        request.setAttribute("creCrsVO", creCrsVO);

        ExamVO evo = new ExamVO();
        if(!"".equals(StringUtil.nvl(vo.getSearchFrom()))) {
            evo.setExamCd(StringUtil.nvl(vo.getSearchFrom()));
            evo = examService.select(evo);
        }
        request.setAttribute("evo", evo);
        request.setAttribute("dateVO", dateVO);

        return "exam/popup/exam_write_forum_pop";
    }

    /*****************************************************
     * 시험 토론 등록 ajax (교수)
     * @param ForumVO
     * @return ProcessResultVO<ForumVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/addForum.do")
    @ResponseBody
    public ProcessResultVO<ForumVO> addForum(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ForumVO> returnVO = new ProcessResultVO<ForumVO>();
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setSearchMenu("insert");

        try {
            returnVO = forumService.examForumManage(vo, request);
            returnVO.setResult(1);
        } catch(Exception e) {
            returnVO.setResult(-1);
            returnVO.setMessage(getMessage("exam.error.insert"));/* 저장 중 에러가 발생하였습니다. */
        }
        return returnVO;
    }

    /*****************************************************
     * 시험 토론 수정 ajax (교수)
     * @param ForumVO
     * @return ProcessResultVO<ForumVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editForum.do")
    @ResponseBody
    public ProcessResultVO<ForumVO> editForum(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ForumVO> returnVO = new ProcessResultVO<ForumVO>();
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setSearchMenu("update");

        try {
            returnVO = forumService.examForumManage(vo, request);
            returnVO.setResult(1);
        } catch(Exception e) {
            returnVO.setResult(-1);
            returnVO.setMessage(getMessage("exam.error.update"));/* 수정 중 에러가 발생하였습니다. */
        }
        return returnVO;
    }

    /*****************************************************
     * 시험 퀴즈 등록 팝업 (교수)
     * @param ExamVO
     * @return "exam/popup/exam_write_quiz_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examWriteQuizPop.do")
    public String examWriteQuizPop(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String examStareTypeCd = StringUtil.nvl(vo.getExamStareTypeCd());
        vo.setExamStareTypeCd("");
        ExamVO examVO = new ExamVO();
        if(!"".equals(StringUtil.nvl(vo.getExamCd()))) {
            examVO = examService.select(vo);
        }
        request.setAttribute("examVo", examVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("examTypeCd", vo.getSearchKey());
        request.setAttribute("creCrsVO", creCrsVO);

        ExamVO evo = new ExamVO();
        if(!"".equals(StringUtil.nvl(vo.getSearchFrom()))) {
            evo.setExamCd(StringUtil.nvl(vo.getSearchFrom()));
            evo = examService.select(evo);
        }
        vo.setExamStareTypeCd(examStareTypeCd);
        request.setAttribute("evo", evo);
        request.setAttribute("dateVO", vo);

        return "exam/popup/exam_write_quiz_pop";
    }

    /*****************************************************
     * 시험 정보 페이지 (교수)
     * @param ExamVO
     * @return "exam/exam_info_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examInfoManage.do")
    public String examInfoManage(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        ExamVO examVO = examService.select(vo);
        request.setAttribute("vo", examVO);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        request.setAttribute("examType", StringUtil.nvl(vo.getExamType()));
        request.setAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "exam/exam_info_manage";
    }

    /*****************************************************
     * 실시간 시험 성적 통계 팝업 (교수)
     * @param ExamVO
     * @return "exam/popup/exam_score_status_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examScoreStatusPop.do")
    public String examScoreStatusPop(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        ExamVO examVO = examService.select(vo);
        request.setAttribute("vo", examVO);

        return "exam/popup/exam_score_status_pop";
    }

    /*****************************************************
     * 시험 목록 페이지 (학생)
     * @param ExamVO
     * @return "exam/stu_exam_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/stuExamList.do")
    public String stuExamListForm(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String crsCreCd = vo.getCrsCreCd();

        StdVO stdVO = new StdVO();
        stdVO.setUserId(userId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO = stdService.selectStd(stdVO);
        vo.setCrsCreCd(crsCreCd);
        vo.setStdId(stdVO.getStdId());
        vo.setUserId(userId);
        model.addAttribute("vo", vo);

        if("DSBL".equals(vo.getExamType())) {
            String disablilityYn = StringUtil.nvl(SessionInfo.getDisablilityYn(request), "N");

            if(!"Y".equals(disablilityYn)) {
                // 사용권한이 없거나 로그아웃되었습니다. 다시 로그인하세요.
                throw new AccessDeniedException(getMessage("common.system.no_auth"));
            }
        }

        if("DSBL".equals(vo.getExamType()) || "ABSENT".equals(vo.getExamType())) {
            // 강의실 활동 로그 등록
            String typeStr = "DSBL".equals(vo.getExamType()) ? "장애인시험지원" : "결시원";
            logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_EXAM, typeStr + " 신청목록");

            if("ABSENT".equals(vo.getExamType())) {
                // 현재학기 정보조회
                TermVO termVO = new TermVO();
                termVO.setOrgId(orgId);
                termVO = termService.selectCurrentTerm(termVO);

                // 과목정보 조회
                CreCrsVO creCrsVO = new CreCrsVO();
                creCrsVO.setCrsCreCd(crsCreCd);
                creCrsVO = crecrsService.select(creCrsVO);

                boolean isCurrentTermCreCrs = false;
                // 현재 학기 과목인지 체크
                if(termVO != null && creCrsVO != null && termVO.getTermCd().equals(StringUtil.nvl(creCrsVO.getTermCd()))) {
                    isCurrentTermCreCrs = true;
                }

                if(isCurrentTermCreCrs) {
                    SysJobSchVO sysJobSchVO = new SysJobSchVO();
                    sysJobSchVO.setOrgId(orgId);
                    sysJobSchVO.setUseYn("Y");
                    //sysJobSchVO.setTermCd(termCd);
                    // 00190902: 결시원신청-중간고사(일정공지용), 00190903: 결시원신청-기말고사(일정공지용)
                    sysJobSchVO.setSqlForeach(new String[]{"00190902", "00190903"});
                    List<SysJobSchVO> jobSchList = sysJobSchService.list(sysJobSchVO);
                    Map<String, SysJobSchVO> jobSchMap = new HashMap<>();
                    for(SysJobSchVO sysJobSchVO2 : jobSchList) {
                        jobSchMap.put(sysJobSchVO2.getCalendarCtgr(), sysJobSchVO2);
                    }

                    model.addAttribute("midSysJobSchVO", jobSchMap.get("00190902")); // 결시원신청-중간고사(일정공지용)
                    model.addAttribute("lastSysJobSchVO", jobSchMap.get("00190903")); // 결시원신청-기말고사(일정공지용)
                }
            }
        }

        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(StringUtil.nvl(vo.getCrsCreCd()));
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);

        TermVO termVO = new TermVO();
        termVO.setCrsCreCd(crsCreCd);
        termVO = termService.selectTermByCrsCreCd(termVO);
        model.addAttribute("termVO", termVO);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");

        //String oathMidParam = "{\"yy\":\""+creCrsVO.getCreYear()+"\",\"tmGbn\":\""+creCrsVO.getCreTerm()+"\",\"examGbn\":\"01\"}";
        //String oathEndParam = "{\"yy\":\""+creCrsVO.getCreYear()+"\",\"tmGbn\":\""+creCrsVO.getCreTerm()+"\",\"examGbn\":\"02\"}";
        //oathMidParam = (new Base64()).encodeToString(oathMidParam.getBytes());
        //oathEndParam = (new Base64()).encodeToString(oathEndParam.getBytes());

        //String examOathMidUrl = CommConst.EXT_URL_EXAMOATH + oathMidParam;
        //String examOathEndUrl = CommConst.EXT_URL_EXAMOATH + oathEndParam;
        String examOathMidUrl = CommConst.EXT_URL_EXAMOATH;
        String examOathEndUrl = CommConst.EXT_URL_EXAMOATH;
        model.addAttribute("examOathMidUrl", examOathMidUrl);
        model.addAttribute("examOathEndUrl", examOathEndUrl);

        return "exam/stu_exam_list";
    }

    /*****************************************************
     * 서약서 apiheader 가져오기
     * @param ExamVO
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/oathHeader.do")
    @ResponseBody
    public String oathHeader(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        String langApiHeader = SecureUtil.encodeAesCbc(DateTimeUtil.getCurrentString() + userId, null, CommConst.ERP_API_KEY);
        return langApiHeader;
    }

    /*****************************************************
     * 시험 목록  가져오기 ajax (학생)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stuExamList.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> stuExamList(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        try {
            resultVO = examService.list(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 정보 페이지 (학습자)
     * @param ExamVO
     * @return "exam/stu_exam_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stuExamView.do")
    public String stuQuizView(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd());
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        StdVO stdVO = new StdVO();
        stdVO.setUserId(userId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO = stdService.selectStd(stdVO);
        vo.setStdId(stdVO.getStdId());
        ExamVO examVO = examService.select(vo);
        examVO.setCrsCreCd(crsCreCd);
        // 강의실 활동 로그 등록
        String examStareTypeCd = StringUtil.nvl(examVO.getExamStareTypeCd());
        String examStr = "M".equals(examStareTypeCd) ? "중간고사 대체평가" : "L".equals(examStareTypeCd) ? "기말고사 대체평가" : "수시평가";
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_EXAM, examStr + " 정보확인");

        TermVO termVO = new TermVO();
        termVO.setCrsCreCd(crsCreCd);
        termVO = termService.selectTermByCrsCreCd(termVO);
        request.setAttribute("termVO", termVO);

        request.setAttribute("vo", examVO);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", crsCreCd);
        request.setAttribute("examType", StringUtil.nvl(vo.getExamType()));
        LocalDateTime today = LocalDateTime.now();
        request.setAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        LocalDateTime startDate = LocalDateTime.parse(examVO.getExamStartDttm(), DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        startDate = startDate.plusMinutes(examVO.getExamStareTm());
        request.setAttribute("endDttm", startDate.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        return "exam/stu_exam_view";
    }

    /*****************************************************
     * 장애인 시험지원 신청 목록 페이지 (교수)
     * @param vo
     * @param model
     * @param request
     * @return "exam/exam_dsbl_req_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examDsblReqList.do")
    public String examDsblReqListForm(ExamDsblReqVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd());
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); // 페이지 접근 권한이 없습니다.
        }

        vo.setCrsCreCd(crsCreCd);
        model.addAttribute("vo", vo);

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setOrgId(orgId);
        sysJobSchVO.setCalendarCtgr("00190806"); // 시험지원요청(교수)
        sysJobSchVO.setTermCd(termVO.getTermCd());
        sysJobSchVO = sysJobSchService.select(sysJobSchVO);
        model.addAttribute("sysJobSchVO", sysJobSchVO);

        model.addAttribute("menuType", menuType.contains("ADM") ? "ADM" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        model.addAttribute("userId", userId);

        return "exam/exam_dsbl_req_list";
    }

    /*****************************************************
     * 모든 장애 학생 목록 가져오기 ajax (교수)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<ExamDsblReqVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/allExamDsblReqList.do")
    @ResponseBody
    public ProcessResultVO<ExamDsblReqVO> allExamDsblReqList(ExamDsblReqVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamDsblReqVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);
            vo.setPagingYn("N");
            resultVO = examDsblReqService.list(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 장애인 시험지원 신청 목록 팝업 (교수)
     * @param ExamDsblReqVO
     * @return "exam/popup/exam_dsbl_req_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewExamDsblReqPop.do")
    public String viewExamDsblReqPop(ExamDsblReqVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        if(!"".equals(StringUtil.nvl(vo.getDsblReqCd()))) {
            ExamDsblReqVO dsblReqVO = examDsblReqService.select(vo);
            request.setAttribute("vo", dsblReqVO);
        }

        StdVO stdVO = new StdVO();
        stdVO.setStdId(vo.getStdId());
        stdVO = stdService.select(stdVO);
        request.setAttribute("stdVO", stdVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        UsrUserInfoVO uuivo = new UsrUserInfoVO();
        uuivo.setUserId(StringUtil.nvl(stdVO.getUserId()));
        uuivo = usrUserInfoService.viewForLogin(uuivo);
        request.setAttribute("uuivo", uuivo);

        return "exam/popup/exam_dsbl_req_view_pop";
    }

    /*****************************************************
     * 장애인 시험지원 학습자 신청 로그 팝업
     * @param ExamDsblReqVO
     * @return "exam/popup/exam_dsbl_req_hsty_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examDsblReqHstyPop.do")
    public String examDsblReqHstyPop(LogLessonActnHstyVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        request.setAttribute("hstyList", logLessonActnHstyService.listLessonActnHsty(vo));

        return "exam/popup/exam_dsbl_req_hsty_pop";
    }

    /*****************************************************
     * 장애인 지원 신청 승인/반려 ajax (교수)
     * @param ExamDsblReqVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/insertExamDsblReq.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> insertExamDsblReq(ExamDsblReqVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            examDsblReqService.insertExamDsblReq(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.update"));/* 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 장애인 시험지원 신청 목록 페이지 (학생)
     * @param vo
     * @param model
     * @param request
     * @return "exam/stu_exam_dsbl_req_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/stuExamDsblReqList.do")
    public String stuExamDsblReqListForm(ExamDsblReqVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd());

        vo.setCrsCreCd(crsCreCd);
        vo.setUserId(userId);
        model.addAttribute("vo", vo);

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        UsrUserInfoVO uuivo = new UsrUserInfoVO();
        uuivo.setUserId(userId);
        uuivo = usrUserInfoService.viewUser(uuivo);
        model.addAttribute("uuivo", uuivo);

        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setOrgId(orgId);
        sysJobSchVO.setCalendarCtgr("00190805"); // 시험지원요청
        sysJobSchVO.setTermCd(termVO.getTermCd());
        sysJobSchVO = sysJobSchService.select(sysJobSchVO);
        model.addAttribute("sysJobSchVO", sysJobSchVO);
        SysJobSchVO sjsVO = new SysJobSchVO();
        sjsVO.setOrgId(orgId);
        sjsVO.setCalendarCtgr("00190809"); // 시험지원요청(확인기간)
        sjsVO.setTermCd(termVO.getTermCd());
        sjsVO = sysJobSchService.select(sjsVO);
        model.addAttribute("sysJobSchVO2", sjsVO);

        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME, "장애인 시험지원 확인");

        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));

        return "exam/stu_exam_dsbl_req_list";
    }

    /*****************************************************
     * 장애인 시험지원 신청 목록 가져오기 ajax (학생)
     * @param ExamDsblReqVO
     * @return ProcessResultVO<ExamDsblReqVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stuExamDsblReqList.do")
    @ResponseBody
    public ProcessResultVO<ExamDsblReqVO> stuExamDsblReqList(ExamDsblReqVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamDsblReqVO> resultVO = new ProcessResultVO<ExamDsblReqVO>();

        try {
            resultVO = examDsblReqService.listMyCreCrsExamDsblReq(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 장애인 시험지원 신청 ajax (학생)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stuExamDsblReqApplicate.do")
    @ResponseBody
    public ProcessResultVO<UsrUserInfoVO> stuExamDsblReqApplicate(ExamDsblReqVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            UsrUserInfoVO uuivo = new UsrUserInfoVO();
            uuivo.setUserId(userId);
            uuivo = usrUserInfoService.viewForLogin(uuivo);
            if(!"Y".equals(StringUtil.nvl(uuivo.getDisablilityYn()))) {
                resultVO.setResult(-1);
                resultVO.setMessage(getMessage("exam.alert.applicate.dsbl.req.not.target")); // 장애학생 시험지원 신청대상이 아닙니다.
                return resultVO;
            }
            if("Y".equals(StringUtil.nvl(uuivo.getDisablilityExamYn()))) {
                resultVO.setResult(-1);
                resultVO.setMessage(getMessage("exam.alert.already.applicate.dsbl.req")); // 이미 장애학생 시험지원 신청하셨습니다.
                return resultVO;
            }
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, "DSBLREQ", CommConst.ACTN_HSTY_EXAM, "장애인시험지원 신청");

            uuivo.setSearchKey("NONCANCEL");
            examDsblReqService.updateDisability(uuivo);

            resultVO.setResult(1);
        } catch(EgovBizException | MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage()); // 신청 중 에러가 발생하였습니다.
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.apply")); // 신청 중 에러가 발생하였습니다.
        }

        return resultVO;
    }

    /*****************************************************
     * 장애인 시험지원 취소
     * @param vo
     * @param map
     * @param request
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stuExamDsblReqCancel.do")
    @ResponseBody
    public ProcessResultVO<UsrUserInfoVO> stuExamDsblReqCancel(UsrUserInfoVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, "DSBLREQ", CommConst.ACTN_HSTY_EXAM, "장애인시험지원 취소");

            vo.setMdfrId(userId);
            vo.setSearchKey("CANCEL");
            examDsblReqService.updateDisability(vo);
            resultVO.setResult(1);
        } catch(EgovBizException | MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage()); // 신청 중 에러가 발생하였습니다.
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.apply")); // 신청 중 에러가 발생하였습니다.
        }

        return resultVO;
    }

    /*****************************************************
     * 결시원 신청 목록 페이지 (교수)
     * @param ExamAbsentVO
     * @return "exam/exam_absent_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/examAbsentList.do")
    public String examAbsentListForm(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd());
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        if("".equals(menuType)) {
            menuType = "PROF";
        }

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        vo.setCrsCreCd(crsCreCd);
        request.setAttribute("vo", vo);

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        request.setAttribute("termVO", termVO);
        request.setAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setOrgId(orgId);
        sysJobSchVO.setCalendarCtgr("00190901");
        sysJobSchVO.setTermCd(termVO.getTermCd());
        sysJobSchVO = sysJobSchService.select(sysJobSchVO);
        request.setAttribute("sysJobSchVO", sysJobSchVO);
        request.setAttribute("menuType", menuType.contains("ADM") ? "ADM" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        request.setAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        request.setAttribute("userId", userId);

        return "exam/exam_absent_list";
    }

    /*****************************************************
     * 시험 결시원 신청 정보 팝업 (교수)
     * @param ExamAbsentVO
     * @return "exam/popup/exam_absent_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsentViewPop.do")
    public String examAbsentViewPop(ExamAbsentVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        if("".equals(menuType)) {
            menuType = "PROF";
        }

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        if(!"".equals(StringUtil.nvl(vo.getExamAbsentCd()))) {

            ExamAbsentVO absentVO = examAbsentService.select(vo);
            request.setAttribute("vo", absentVO);
        }

        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);
        request.setAttribute("termVO", termVO);

        StdVO stdVO = new StdVO();
        stdVO.setStdId(vo.getStdId());
        stdVO = stdService.select(stdVO);
        request.setAttribute("stdVO", stdVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        request.setAttribute("userId", userId);

        ExamAbsentVO absentVO2 = new ExamAbsentVO();
        absentVO2.setCrsCreCd(vo.getCrsCreCd());
        absentVO2.setUserId(stdVO.getUserId());
        EgovMap examAbsentApplicateYnMap = examAbsentService.selectExamAbsentApplicateYn(absentVO2);
        request.setAttribute("examAbsentApplicateYnMap", examAbsentApplicateYnMap);

        model.addAttribute("isKnou", SessionInfo.isKnou(request));
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "exam/popup/exam_absent_view_pop";
    }

    /*****************************************************
     * 시험 결시원 신청이력 팝업 (교수)
     * @param ExamAbsentVO
     * @return "exam/popup/exam_absent_list_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsentListPop.do")
    public String examAbsentListPop(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        /*
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage()); 페이지 접근 권한이 없습니다.
        }
        */

        List<ExamAbsentVO> absentList = examAbsentService.list(vo);
        request.setAttribute("list", absentList);
        request.setAttribute("cnt", absentList.size());

        StdVO stdVO = new StdVO();
        stdVO.setStdId(vo.getStdId());
        stdVO = stdService.select(stdVO);
        request.setAttribute("stdVO", stdVO);

        return "exam/popup/exam_absent_list_pop";
    }

    /*****************************************************
     * 결시원 신청 목록 페이지 (학생)
     * @param ExamAbsentVO
     * @return "exam/stu_exam_absent_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/stuExamAbsentList.do")
    public String stuExamAbsentListForm(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd());

        vo.setCrsCreCd(crsCreCd);
        vo.setUserId(userId);
        request.setAttribute("vo", vo);
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);

        String termCd = null;

        if(termVO != null) {
            termCd = termVO.getTermCd();
        }

        request.setAttribute("termVO", termVO);
        request.setAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        LocalDateTime today = LocalDateTime.now();
        request.setAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setOrgId(orgId);
        sysJobSchVO.setUseYn("Y");
        sysJobSchVO.setTermCd(termCd);
        // 00190902: 결시원신청-중간고사(일정공지용), 00190903: 결시원신청-기말고사(일정공지용)
        sysJobSchVO.setSqlForeach(new String[]{"00190902", "00190903"});
        List<SysJobSchVO> jobSchList = sysJobSchService.list(sysJobSchVO);
        Map<String, SysJobSchVO> jobSchMap = new HashMap<>();
        for(SysJobSchVO sysJobSchVO2 : jobSchList) {
            jobSchMap.put(sysJobSchVO2.getCalendarCtgr(), sysJobSchVO2);
        }

        request.setAttribute("midSysJobSchVO", jobSchMap.get("00190902")); // 결시원신청-중간고사(일정공지용)
        request.setAttribute("lastSysJobSchVO", jobSchMap.get("00190903")); // 결시원신청-기말고사(일정공지용)

        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));

        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME, "결시원 확인");

        return "exam/stu_exam_absent_list";
    }

    /*****************************************************
     * 결시원 목록 가져오기 ajax (학생)
     * @param ExamAbsentVO
     * @return ProcessResultVO<ExamAbsentVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stuExamAbsentList.do")
    @ResponseBody
    public ProcessResultVO<ExamAbsentVO> stuExamAbsentList(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamAbsentVO> resultVO = new ProcessResultVO<ExamAbsentVO>();

        try {
            resultVO = examAbsentService.listMyCreCrsExamAbsent(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list"));/* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 결시원 신청 팝업 (학생)
     * @param ExamAbsentVO
     * @return "exam/stu_exam_absent_applicate_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stuExamAbsentApplicatePop.do")
    public String stuExamAbsentApplicatePop(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);
        String orgId = SessionInfo.getOrgId(request);

        ExamVO examVO = new ExamVO();
        examVO.setExamCd(vo.getExamCd());
        examVO = examService.select(examVO);
        examVO.setSearchMenu(StringUtil.nvl(vo.getSearchMenu()));
        request.setAttribute("vo", examVO);

        StdVO stdVO = new StdVO();
        stdVO.setStdId(vo.getStdId());
        stdVO = stdService.select(stdVO);
        request.setAttribute("stdVO", stdVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        LocalDate date = LocalDate.now();
        request.setAttribute("date", date);

        // 결시원 일정공지
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO = termService.selectCurrentTerm(termVO);

        String termCd = null;

        if(termVO != null) {
            termCd = termVO.getTermCd();
        }

        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setOrgId(orgId);
        sysJobSchVO.setUseYn("Y");
        sysJobSchVO.setTermCd(termCd);
        // 00190902: 결시원신청-중간고사(일정공지용), 00190903: 결시원신청-기말고사(일정공지용)
        sysJobSchVO.setSqlForeach(new String[]{"00190902", "00190903"});
        List<SysJobSchVO> jobSchList = sysJobSchService.list(sysJobSchVO);
        Map<String, SysJobSchVO> jobSchMap = new HashMap<>();
        for(SysJobSchVO sysJobSchVO2 : jobSchList) {
            jobSchMap.put(sysJobSchVO2.getCalendarCtgr(), sysJobSchVO2);
        }

        if("M".equals(examVO.getExamStareTypeCd())) {
            request.setAttribute("midSysJobSchVO", jobSchMap.get("00190902")); // 결시원신청-중간고사(일정공지용)
        } else if("L".equals(examVO.getExamStareTypeCd())) {
            request.setAttribute("lastSysJobSchVO", jobSchMap.get("00190903")); // 결시원신청-기말고사(일정공지용)
        }

        return "exam/popup/stu_exam_absent_applicate_pop";
    }

    /*****************************************************
     * 결시원 신청 ajax (학생)
     * @param ExamAbsentVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examAbsentApplicate.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> examAbsentApplicate(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            ExamVO examVO = new ExamVO();
            examVO.setExamCd(vo.getExamCd());
            examVO = examService.select(examVO);
            // 강의실 활동 로그 등록
            String examStr = "M".equals(StringUtil.nvl(examVO.getExamStareTypeCd())) ? "중간고사" : "기말고사";
            logLessonActnHstyService.saveLessonActnHsty(request, examVO.getCrsCreCd(), CommConst.ACTN_HSTY_EXAM, examStr + " 결시원 신청");

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
            resultVO.setMessage(getMessage("exam.error.apply"));/* 신청 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 결시 내역 팝업 (학생)
     * @param ExamAbsentVO
     * @return "exam/stu_exam_absent_applicate_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stuExamAbsentApprViewPop.do")
    public String stuExamAbsentApprViewPop(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        String userId = SessionInfo.getUserId(request);

        ExamAbsentVO absentVO = examAbsentService.select(vo);
        request.setAttribute("vo", absentVO);

        ExamAbsentVO absentVO2 = new ExamAbsentVO();
        absentVO2.setCrsCreCd(absentVO.getCrsCreCd());
        absentVO2.setUserId(userId);
        EgovMap examAbsentApplicateYnMap = examAbsentService.selectExamAbsentApplicateYn(absentVO2);
        request.setAttribute("examAbsentApplicateYnMap", examAbsentApplicateYnMap);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(absentVO.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, creCrsVO.getCrsCreCd(), CommConst.ACTN_HSTY_EXAM, "결시원 신청내역 및 승인여부 확인");

        return "exam/popup/stu_exam_absent_appr_view_pop";
    }

    /*****************************************************
     * 결시원 수정 ajax (교수)
     * @param ExamAbsentVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateExamAbsent.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateExamAbsent(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String userId = SessionInfo.getUserId(request);

        try {
            vo.setMdfrId(userId);
            examAbsentService.updateAbsent(request, vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.update"));/* 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 결시원 정리
     * @param ExamAbsentVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateAllCompanion.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateAllCompanion(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String userId = SessionInfo.getUserId(request);

        try {
            vo.setMdfrId(userId);
            examAbsentService.updateAllCompanion(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.batch.companion"));/* 일괄 반려 처리 중 에러가 발생하였습니다. */
        }

        return resultVO;
    }

    /*****************************************************
     * 결시원 정리 ajax (교수)
     * @param ExamAbsentVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateAllCompanionProf.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateAllCompanionProf(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String userId = SessionInfo.getUserId(request);

        try {
            vo.setMdfrId(userId);
            vo.setUserId(userId);
            examAbsentService.updateAllCompanionProf(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.batch.companion"));/* 일괄 반려 처리 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 응시 파라미터
     * @param ExamAbsentVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examStareEncrypto.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> examStareEncrypto(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setUserId(userId);
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        try {
            /*
             * SiteCd
             * 학부 중간/기말     : 0001
             * 학부 수시평가       : 0003
             * 대학원 중간/기말  : 0004
             * 대학원 외국어시험 : 0007
             * 학부 선수과목 수강생(대학원) : 0001
             *
             * Cert 인증여부
             * Y(PKI인증, FIDO인증)
             * K(카카오인증)
             * D(유예처리)
             * null(안심등교)
             */
            LocalDateTime today = LocalDateTime.now();
            String time = today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
            String timeLimit = CryptoUtil.encryptAes256(time, "EXAM");
            userId = CryptoUtil.encryptAes256(userId, "EXAM");
            String siteCd = StringUtil.nvl(vo.getSiteCd());

            // 임시
            String cert = "Y";

            String returnStr = "";
            String goUrl = "";

            EgovMap egovMap = examService.selectExamEncryptoInfo(vo);
            ExamVO examVO = examService.select(vo);
            // 중간/기말
            if("0001".equals(siteCd) || "0004".equals(siteCd)) {
                returnStr = egovMap.get("userId") + "|HYYCU|" + siteCd + "|1|" + egovMap.get("creYear") + "|" + egovMap.get("creTerm") + "|" + egovMap.get("examGbn") + "||||||||||||";
                returnStr = CryptoUtil.encryptAes256(returnStr, "EXAM");
                goUrl = CommConst.EXT_URL_ETS + "?UserId=" + userId + "&Cert=" + cert + "&TargetSvc=ETS&TimeLimit=" + timeLimit + "&SiteCd=" + siteCd + "&returnStr=" + returnStr + "&gubun=ROAD";
                // 강의실 활동 로그 등록
                String examStr = "01".equals(egovMap.get("examGbn")) ? "중간고사" : "기말고사";
                logLessonActnHstyService.saveLessonActnHsty(request, examVO.getCrsCreCd(), CommConst.ACTN_HSTY_EXAM, examStr + " 시험응시");
                // 수시평가
            } else if("0003".equals(siteCd)) {
                returnStr = egovMap.get("userId") + "|HYYCU|" + siteCd + "|1|" + egovMap.get("creYear") + "|" + egovMap.get("creTerm") + "|01|"
                        + egovMap.get("crsCd") + "|" + egovMap.get("tchId") + "|" + egovMap.get("ltWeek") + "|Y|" + egovMap.get("declsNo") + "|" + egovMap.get("userNm") + "|" + egovMap.get("deptId")
                        + "|" + egovMap.get("deptNm") + "|Y|" + egovMap.get("userGrade") + "|" + egovMap.get("email") + "|" + egovMap.get("mobileNo");
                returnStr = CryptoUtil.encryptAes256(returnStr, "EXAM");
                goUrl = CommConst.EXT_URL_ETS + "?UserId=" + userId + "&Cert=" + cert + "&TargetSvc=ETS&TimeLimit=" + timeLimit + "&SiteCd=" + siteCd + "&returnStr=" + returnStr;
                // 강의실 활동 로그 등록
                logLessonActnHstyService.saveLessonActnHsty(request, examVO.getCrsCreCd(), CommConst.ACTN_HSTY_EXAM, "[" + egovMap.get("examTitle") + "] 수시평가 응시하기");
                // 외국어시험
            } else if("0007".equals(siteCd)) {
                goUrl = CommConst.EXT_URL_ETS + "?UserId=" + userId + "&Cert=" + cert + "&TargetSvc=ETS&TimeLimit=" + timeLimit + "&SiteCd=" + siteCd;
                // 맛보기
            } else {
                returnStr = egovMap.get("userId") + "|HYYCU|0001|3|||||||Y|01|" + egovMap.get("userNm") + "|" + egovMap.get("deptId") + "|" + egovMap.get("deptNm") + "|N|" + egovMap.get("userGrade") + "|" + egovMap.get("email") + "|" + egovMap.get("mobileNo");
                returnStr = CryptoUtil.encryptAes256(returnStr, "EXAM");
                goUrl = CommConst.EXT_URL_ETS_PREVIEW + "?returnStr=" + returnStr + "&gubun=ROAD";
            }
            vo.setGoUrl(goUrl);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 기타, 대체 과제 정보 조회
     * @param ExamVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectExamInsInfo.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> updateExamAbsent(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            EgovMap eMap = examService.selectExamInsInfo(vo);
            resultVO.setReturnVO(eMap);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 기타, 대체 과제 정보 조회
     * @param ExamVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listExamInsUser.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listExamInsUser(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            List<EgovMap> egovList = examService.listExamInsUser(vo);
            resultVO.setReturnList(egovList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }

        return resultVO;
    }

    /*****************************************************
     * 시험 대체평가 대상자 설정 팝업
     * @param ExamVO
     * @return "exam/popup/exam_ins_target_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examInsTargetPop.do")
    public String examInsTargetPop(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        ExamVO examVO = examService.select(vo);
        request.setAttribute("vo", examVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        LocalDateTime today = LocalDateTime.now();
        request.setAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        return "exam/popup/exam_ins_target_pop";
    }

    /*****************************************************
     * 대체평가 대상자 목록
     * @param ExamStareVO
     * @return ProcessResultVO<ExamStareVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listInsTraget.do")
    @ResponseBody
    public ProcessResultVO<ExamStareVO> listInsTraget(ExamStareVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamStareVO> resultVO = new ProcessResultVO<ExamStareVO>();

        try {
            List<ExamStareVO> stareList = examStareService.listExamNoStare(vo);
            resultVO.setReturnList(stareList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }

        return resultVO;
    }

    /*****************************************************
     * 대체평가 대상자 설정
     * @param ExamStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/insTargetSet.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> insTargetSet(ExamStareVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setReExamYn("Y");
            String[] stdNoList = vo.getStdIds().split(",");
            for(String stdNo : stdNoList) {
                vo.setStdId(stdNo);
                vo.setStareSn(stdNo + vo.getExamCd());
                examStareService.updateExamStare(vo);
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.setting"));/* 설정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 대체평가 대상자 취소 ( 다수 )
     * @param ExamStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/insTargetCancelByStdNos.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> insTargetCancelByStdNos(ExamStareVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setReExamYn("N");
            String[] stdNoList = vo.getStdIds().split(",");
            for(String stdNo : stdNoList) {
                vo.setStdId(stdNo);
                examStareService.updateExamStare(vo);
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.setting"));/* 설정 중 에러가 발생하였습니다. */
        }

        return resultVO;
    }

    /*****************************************************
     * 대체평가 대상자 설정 취소
     * @param ExamStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/insTargetCancel.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> insTargetCancel(ExamStareVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            vo.setMdfrId(userId);
            examStareService.resetReExamStareByStd(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.setting")); /* 설정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 학생 전체 결시원 대상 시험 리스트 조회
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listAllStuAbsentExam.do")
    @ResponseBody
    public ProcessResultVO<ExamAbsentVO> listAllStuAbsentExam(ExamAbsentVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ExamAbsentVO> resultVO = new ProcessResultVO<>();

        try {
            vo.setOrgId(orgId);
            vo.setUserId(userId);
            List<ExamAbsentVO> list = examAbsentService.listAllStuAbsentExam(vo);

            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험 대체평가 연결 팝업
     * @param ExamVO
     * @return "exam/popup/exam_ins_ref_link_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examInsRefLinkPop.do")
    public String examInsRefLinkPop(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_EXAM);

        ExamVO examVO = examService.select(vo);
        request.setAttribute("vo", examVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        return "exam/popup/exam_ins_ref_link_pop";
    }

    /*****************************************************
     * 중간/기말 대체평가 연결 가능 목록
     * @param ExamVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listSetInsRef.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listSetInsRef(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            resultVO = examService.listSetInsRef(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 중간/기말 대체평가 연결
     * @param ExamVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/setInsRef.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> setInsRef(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setMdfrId(userId);
            examService.setInsRef(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); /* 에러가 발생했습니다! */
        }
        return resultVO;
    }

    /*****************************************************
     * 중간/기말 대체평가 연결해제
     * @param ExamVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/setInsRefCancel.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> setInsRefCancel(ExamVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setMdfrId(userId);
            examService.setInsRefCancel(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); /* 에러가 발생했습니다! */
        }
        return resultVO;
    }

    /*****************************************************
     * 특정 학습자 시험 응시 여부
     * @param ExamStareVO
     * @return ProcessResultVO<ExamStareVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/examStareByStdNo.do")
    @ResponseBody
    public ProcessResultVO<ExamStareVO> examStareByStdNo(ExamStareVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamStareVO> resultVO = new ProcessResultVO<ExamStareVO>();

        try {
            ExamStareVO stareVO = examStareService.examStareByStdNo(vo);
            resultVO.setReturnVO(stareVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

}
