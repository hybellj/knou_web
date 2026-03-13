package knou.lms.exam.web;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.AjaxProcessException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.crs.service.CrsService;
import knou.lms.crs.crs.vo.CrsVO;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.exam.facade.QuizFacadeService;
import knou.lms.exam.service.*;
import knou.lms.exam.vo.*;
import knou.lms.exam.web.view.QuizMainView;
import knou.lms.lesson.service.LessonScheduleService;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.user.service.UsrUserInfoService;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
@RequestMapping(value="/quiz")
public class QuizHomeController extends ControllerBase {

    @Resource(name="quizFacadeService")
    private QuizFacadeService quizFacadeService;


    @Resource(name="examService")
    private ExamService examService;

    @Resource(name="examStareService")
    private ExamStareService examStareService;

    @Resource(name="examStareHstyService")
    private ExamStareHstyService examStareHstyService;

    @Resource(name="examStarePaperService")
    private ExamStarePaperService examStarePaperService;

    @Resource(name="examQstnService")
    private ExamQstnService examQstnService;

    @Resource(name="examQbankCtgrService")
    private ExamQbankCtgrService examQbankCtgrService;

    @Resource(name="examQbankQstnService")
    private ExamQbankQstnService examQbankQstnService;

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="crsService")
    private CrsService crsService;

    @Resource(name="termService")
    private TermService termService;

    @Resource(name="stdService")
    private StdService stdService;

    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name="lessonScheduleService")
    private LessonScheduleService lessonScheduleService;

    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    @Resource(name="cmmnCdService")
    private CmmnCdService cmmnCdService;

    @Resource(name="qstnService")
    private QstnService qstnService;

    @Resource(name="qstnVwitmService")
    private QstnVwitmService qstnVwitmService;

    @Resource(name="tkexamService")
    private TkexamService tkexamService;

    @Resource(name="tkexamRsltService")
    private TkexamRsltService tkexamRsltService;

    @Resource(name="exampprService")
    private ExampprService exampprService;

    @Resource(name="tkexamAnswShtService")
    private TkexamAnswShtService tkexamAnswShtService;

    /**
     * 교수퀴즈목록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_quiz_list_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizListView.do")
    public String profQuizListView(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("sbjctId", "SBJCT_OFRNG_ID1");    // 과목아이디
        model.addAttribute("menuTycd", "PROF");

        return "quiz/prof_quiz_list_view";
    }

    /**
     * 교수퀴즈목록조회
     *
     * @param sbjctId     과목아이디
     * @param searchValue 검색어 ( 퀴즈명 )
     * @return 교수 퀴즈목록
     * @throws Exception
     */
    @RequestMapping(value="/profQuizListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profQuizListAjax(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            resultVO = examService.profQuizListPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈성적공개여부수정
     *
     * @param examBscId  시험기본아이디
     * @param mrkOyn     성적공개여부
     * @param exampprOyn 시험지공개여부
     * @throws Exception
     */
    @RequestMapping(value="/quizMrkOynModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<ExamBscVO> quizMrkOynModifyAjax(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ExamBscVO> resultVO = new ProcessResultVO<ExamBscVO>();

        try {
            vo.setMdfrId(userId);
            examService.examBscModify(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈성적반영비율수정
     *
     * @param examDtlId 성적상세아이디
     * @param mrkRfltrt 성적반영비율
     * @throws Exception
     */
    @RequestMapping(value="/quizMrkRfltrtModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<ExamBscVO> quizMrkRfltrtModifyAjax(@RequestBody List<ExamBscVO> list, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ExamBscVO> resultVO = new ProcessResultVO<ExamBscVO>();

        try {
            for(ExamBscVO vo : list) {
                vo.setMdfrId(userId);
            }
            examService.quizMrkRfltrtListModify(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수퀴즈등록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_quiz_regist_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizRegistView.do")
    public String profQuizRegistView(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        QuizMainView quizMainView = quizFacadeService.loadProfQuizRegistView(vo);
        model.addAttribute("dvclasList", quizMainView.getSbjctDcvlasList());

        model.addAttribute("menuTycd", "PROF");
        model.addAttribute("sbjctId", vo.getSbjctId());    // 과목아이디

        return "quiz/prof_quiz_regist_view";
    }

    /**
     * 퀴즈등록
     *
     * @param ExamBscVO 퀴즈 정보
     * @return ProcessResultVO<ExamBscVO>
     * @throws Exception
     */
    @RequestMapping(value="/quizRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<ExamBscVO> quizRegistAjax(ExamBscVO vo, @RequestParam(value="dtlInfos", defaultValue="[]") String dtlInfosStr, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
//        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        ProcessResultVO<ExamBscVO> resultVO = new ProcessResultVO<ExamBscVO>();
        ObjectMapper mapper = new ObjectMapper();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setExamtmAllocGbncd("REMAINDER");
            vo.setExamtmExpsrTycd("LEFT");
            vo.getExamDtlVO().setRgtrId(userId);
            vo.getExamDtlVO().setDtlInfos(mapper.readValue(dtlInfosStr, new TypeReference<List<Map<String, Object>>>() {
            }));

            resultVO.setReturnVO(examService.quizRegist(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("저장 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수퀴즈수정화면
     *
     * @param sbjctId 과목개설아이디
     * @return prof_quiz_regist_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizModifyView.do")
    public String profQuizModifyView(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        QuizMainView quizMainView = quizFacadeService.loadProfQuizModifyView(vo);

        ExamBscVO bscVO = quizMainView.getExamBscVO();
        bscVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_EXAM, bscVO.getExamBscId()));	// 첨부파일저장소 설정
        model.addAttribute("vo", bscVO);
        model.addAttribute("dvclasList", quizMainView.getQuizGrpSbjctList());
        model.addAttribute("sbjctId", StringUtil.nvl(vo.getSbjctId()));
        model.addAttribute("menuTycd", "PROF");

        return "quiz/prof_quiz_regist_view";
    }

    /**
     * 퀴즈수정
     *
     * @param ExamBscVO 퀴즈 정보
     * @return ProcessResultVO<ExamBscVO>
     * @throws Exception
     */
    @RequestMapping(value="/quizModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<ExamBscVO> quizModifyAjax(ExamBscVO vo, @RequestParam(value="dtlInfos", defaultValue="[]") String dtlInfosStr, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
//        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        ProcessResultVO<ExamBscVO> resultVO = new ProcessResultVO<ExamBscVO>();
        ObjectMapper mapper = new ObjectMapper();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.getExamDtlVO().setRgtrId(userId);
            vo.getExamDtlVO().setMdfrId(userId);
            vo.getExamDtlVO().setDtlInfos(mapper.readValue(dtlInfosStr, new TypeReference<List<Map<String, Object>>>() {
            }));

            resultVO.setReturnVO(examService.quizModify(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈삭제
     *
     * @param sbjctId   과목아이디
     * @param examBscId 시험기본아이디
     * @param delyn 	삭제여부
     * @return ProcessResultVO<ExamBscVO>
     * @throws Exception
     */
    @RequestMapping(value="/quizDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> quizDeleteAjax(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
//        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String sbjctId = vo.getSbjctId();
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        try {
            if(ValidationUtils.isEmpty(sbjctId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }

            vo.setMdfrId(userId);
            examService.quizDelete(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("삭제 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /**
     * 교수이전퀴즈복사팝업
     *
     * @param sbjctId 과목아이디
     * @return prof_bfr_quiz_copy_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profBfrQuizCopyPopup.do")
    public String profBfrQuizCopyPopup(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	QuizMainView quizMainView = quizFacadeService.loadProfBfrQuizCopyPopup(vo);
    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        model.addAttribute("quizSearchSmstrList", quizMainView.getQuizSearchSmstrList());
        vo.setUserId(userId);
        model.addAttribute("vo", vo);

        return "quiz/popup/prof_bfr_quiz_copy_pop";
    }

    /**
     * 교수권한과목퀴즈목록조회
     *
     * @param userId        교수아이디
     * @param smstrChrtId 	학사년도/학기
     * @param sbjctId       과목아이디
     * @param searchValue   검색내용(퀴즈명)
     * @param listScale     페이지크기
     * @return 퀴즈목록 페이징
     * @throws Exception
     */
    @RequestMapping(value="/profAuthrtSbjctQuizListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAuthrtSbjctQuizListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            resultVO = examService.profAuthrtSbjctQuizList(params);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈정보조회
     *
     * @param examBscId 시험기본아이디
     * @return 퀴즈 정보
     * @throws Exception
     */
    @RequestMapping(value="/quizSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<ExamBscVO> quizSelectAjax(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamBscVO> resultVO = new ProcessResultVO<ExamBscVO>();

        try {
            resultVO.setReturnVO(examService.quizSelect(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("정보 조회 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /**
     * 교수퀴즈문항관리화면
     *
     * @param examBscId 시험기본아이디
     * @param sbjctId   과목아이디
     * @return prof_quiz_qstn_mng_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizQstnMngView.do")
    public String profQuizQstnMngView(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        UserContext userCtx = new UserContext(SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getUserTycd(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));
        request.getSession().setAttribute("USER_CONTEXT", userCtx);

        QuizMainView quizMainView = quizFacadeService.loadProfQuizQstnMngView(vo, userCtx);

        model.addAttribute("userCtx", userCtx);
        model.addAttribute("vo", quizMainView.getExamBscVO());
        model.addAttribute("quizTeamList", quizMainView.getQuizTeamList());
        model.addAttribute("isQstnsCmptn", quizMainView.getIsQstnsCmptn());
        model.addAttribute("qstnRspnsTycdList", quizMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", quizMainView.getCmmnCdList().get("qstnDfctlvTycd"));
        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        model.addAttribute("menuTycd", "PROF");

        return "quiz/prof_quiz_qstn_mng_view";
    }

    /**
     * 퀴즈학습그룹부과제목록조회
     *
     * @param lrnGrpId  학습그룹아이디
     * @param examBscId 시험기본아이디
     * @return 퀴즈 부과제 목록
     * @throws Exception
     */
    @RequestMapping(value="/quizLrnGrpSubAsmtListAjax.do")
    @ResponseBody
    public ProcessResultVO<ExamDtlVO> quizLrnGrpSubAsmtListAjax(ExamDtlVO vo, ModelMap model, HttpServletRequest request) throws Exception {
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

    /**
     * 퀴즈문항목록조회
     *
     * @param examDtlId 시험상세아이디
     * @return 퀴즈 문항 목록
     * @throws Exception
     */
    @RequestMapping(value="/quizQstnListAjax.do")
    @ResponseBody
    public ProcessResultVO<QstnVO> quizQstnListAjax(QstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<QstnVO> resultVO = new ProcessResultVO<QstnVO>();

        try {
            List<QstnVO> qstnList = qstnService.qstnList(vo);
            if(qstnList != null && !qstnList.isEmpty() && qstnList.size() > 0) {
                int qstnCnt = qstnService.qstnCntSelect(vo);
                if(qstnCnt >= 0) {
                    qstnList.get(0).setQstnCnt(qstnCnt);
                }
                resultVO.setReturnList(qstnList);
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈문항보기항목목록조회
     *
     * @param qstnId 문항아이디
     * @return 퀴즈 문항보기항목 목록
     * @throws Exception
     */
    @RequestMapping(value="/quizQstnVwitmListAjax.do")
    @ResponseBody
    public ProcessResultVO<QstnVwitmVO> quizQstnVwitmListAjax(QstnVwitmVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<QstnVwitmVO> resultVO = new ProcessResultVO<QstnVwitmVO>();

        try {
            List<QstnVwitmVO> qstnVwitmList = qstnVwitmService.qstnVwitmList(vo);
            resultVO.setReturnList(qstnVwitmList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈문항등록
     *
     * @param QstnVO 문항 정보
     * @return ProcessResultVO<QstnVO>
     * @throws Exception
     */
    @RequestMapping(value="/quizQstnRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> quizQstnRegistAjax(QstnVO vo, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        ObjectMapper mapper = new ObjectMapper();

        try {
            if(ValidationUtils.isEmpty(userId) || ValidationUtils.isEmpty(vo.getExamBscId())) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }

            ExamBscVO bscVO = new ExamBscVO();
            bscVO.setExamBscId(vo.getExamBscId());
            bscVO = examService.quizSelect(bscVO);

            int tkexamStrtUserCnt = bscVO.getTkexamStrtUserCnt();
            if(tkexamStrtUserCnt > 0) {
                throw new AjaxProcessException("퀴즈 응시자가 있어 수정할 수 없습니다.");
            }

            vo.setRgtrId(userId);
            vo.setQstns(mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {
            }));
            qstnService.quizQstnRegist(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("문항 등록 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈문항수정
     *
     * @param QstnVO 문항 정보
     * @return ProcessResultVO<QstnVO>
     * @throws Exception
     */
    @RequestMapping(value="/quizQstnModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> quizQstnModifyAjax(QstnVO vo, @RequestParam(value="qstns", defaultValue="[]") String qstnsStr, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        ObjectMapper mapper = new ObjectMapper();

        try {
            if(ValidationUtils.isEmpty(userId) || ValidationUtils.isEmpty(vo.getExamBscId())) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }

            ExamBscVO bscVO = new ExamBscVO();
            bscVO.setExamBscId(vo.getExamBscId());
            bscVO = examService.quizSelect(bscVO);

            int tkexamStrtUserCnt = bscVO.getTkexamStrtUserCnt();
            if(tkexamStrtUserCnt > 0) {
                throw new AjaxProcessException("퀴즈 응시자가 있어 수정할 수 없습니다.");
            }

            vo.setMdfrId(userId);
            vo.setRgtrId(userId);
            vo.setQstns(mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {
            }));
            qstnService.quizQstnModify(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("문항 수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈문항순번수정
     *
     * @param examDtlId 시험상세아이디
     * @param qstnSeqno 변경할 문항순번
     * @param searchKey 문항순번
     * @throws Exception
     */
    @RequestMapping(value="/qstnSeqnoModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<QstnVO> qstnSeqnoModifyAjax(QstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<QstnVO> resultVO = new ProcessResultVO<QstnVO>();

        try {
            vo.setMdfrId(userId);
            qstnService.qstnSeqnoModify(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈문항후보순번수정
     *
     * @param examDtlId      시험상세아이디
     * @param qstnId         문항아이디
     * @param qstnSeqno      문항순번
     * @param qstnCnddtSeqno 변경할 문항후보순번
     * @throws Exception
     */
    @RequestMapping(value="/qstnCnddtSeqnoModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<QstnVO> qstnCnddtSeqnoModifyAjax(QstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<QstnVO> resultVO = new ProcessResultVO<QstnVO>();

        try {
            vo.setMdfrId(userId);
            qstnService.qstnCnddtSeqnoModify(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 문항정보조회
     *
     * @param examDtlId 시험상세아이디
     * @param qstnId    문항아이디
     * @return 퀴즈 문항 정보
     * @throws Exception
     */
    @RequestMapping(value="/qstnSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<QstnVO> qstnSelectAjax(QstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<QstnVO> resultVO = new ProcessResultVO<QstnVO>();

        try {
            resultVO.setReturnVO(qstnService.qstnSelect(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("정보 조회 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /**
     * 퀴즈문항삭제
     *
     * @param QstnVO 문항 정보
     * @return ProcessResultVO<QstnVO>
     * @throws Exception
     */
    @RequestMapping(value="/quizQstnDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> quizQstnDeleteAjax(QstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }

            vo.setMdfrId(userId);
            qstnService.quizQstnDelete(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("문항 수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈문항점수수정
     *
     * @param examBscId 시험기본아이디
     * @param examDtlId 시험상세아이디
     * @return ProcessResultVO<QstnVO>
     * @throws Exception
     */
    @RequestMapping(value="/quizQstnScrModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> quizQstnScrModifyAjax(QstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }

            ExamBscVO bscVO = new ExamBscVO();
            bscVO.setExamBscId(vo.getExamBscId());
            bscVO = examService.quizSelect(bscVO);

            int tkexamStrtUserCnt = bscVO.getTkexamStrtUserCnt();
            if(tkexamStrtUserCnt > 0) {
                throw new AjaxProcessException("퀴즈 응시자가 있어 수정할 수 없습니다.");
            }

            vo.setMdfrId(userId);
            qstnService.quizQstnScrModify(vo);
            resultVO.setResult(1);
        } catch(EgovBizException | MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("점수 수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈문항점수일괄수정
     *
     * @param examBscId 시험기본아이디
     * @param examDtlId 시험상세아이디
     * @return ProcessResultVO<QstnVO>
     * @throws Exception
     */
    @RequestMapping(value="/quizQstnScrBulkModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> quizQstnScrBulkModifyAjax(QstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }

            ExamBscVO bscVO = new ExamBscVO();
            bscVO.setExamBscId(vo.getExamBscId());
            bscVO = examService.quizSelect(bscVO);

            int tkexamStrtUserCnt = bscVO.getTkexamStrtUserCnt();
            if(tkexamStrtUserCnt > 0) {
                throw new AjaxProcessException("퀴즈 응시자가 있어 수정할 수 없습니다.");
            }

            vo.setMdfrId(userId);
            qstnService.quizQstnScrBulkModify(vo);
            resultVO.setResult(1);
        } catch(EgovBizException | MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("점수 수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 출제완료퀴즈문항점수일괄수정
     *
     * @param examDtlId 시험상세아이디
     * @param qstnSeqno 문항순번
     * @param qstnScr 	문항점수
     * @return ProcessResultVO<QstnVO>
     * @throws Exception
     */
    @RequestMapping(value="/cmptnYQuizQstnScrBulkModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> cmptnYQuizQstnScrBulkModifyAjax(@RequestBody List<Map<String, Object>> list, ModelMap model, HttpServletRequest request) throws Exception {
    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));
    	ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

    	try {
    		for(Map<String, Object> map : list) {
            	map.put("mdfrId", userId);
            }
    		qstnService.cmptnYQuizQstnScrBulkModify(list);
    		resultVO.setResult(1);
    	} catch(EgovBizException | MediopiaDefineException e) {
    		resultVO.setResult(-1);
    		resultVO.setMessage(e.getMessage());
    	} catch(Exception e) {
    		resultVO.setResult(-1);
    		resultVO.setMessage("점수 수정 중 에러가 발생하였습니다.");
    	}
    	return resultVO;
    }

    /**
     * 교수퀴즈문항가져오기
     *
     * @param copyQstnId	복사문항아이디
     * @param examDtlId 	시험상세아이디
     * @throws Exception
     */
    @RequestMapping(value="/profQuizQstnCopyAjax.do")
    @ResponseBody
    public ProcessResultVO<QstnVO> profQuizQstnCopyAjax(@RequestBody List<Map<String, Object>> list, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<QstnVO> resultVO = new ProcessResultVO<QstnVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
        	for(Map<String, Object> map : list) {
            	map.put("rgtrId", userId);
            }
        	qstnService.quizQstnCopy(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("가져오기 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈문제출제완료수정
     *
     * @param examBscId   시험기본아이디
     * @param examDtlId   시험상세아이디
     * @param examGbncd   시험구분코드
     * @param searchGubun 수정상태 ( save, edit )
     * @param searchGubun searchKey ( bsc, dtl )
     * @return ProcessResultVO<QstnVO>
     * @throws Exception
     */
    @RequestMapping(value="/quizQstnsCmptnModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<ExamBscVO> quizQstnsCmptnModifyAjax(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = SessionInfo.getUserId(request);
        ProcessResultVO<ExamBscVO> resultVO = new ProcessResultVO<ExamBscVO>();

        try {
            vo.setMdfrId(userId);
            examService.quizQstnsCmptnModify(vo);
            resultVO.setResult(1);
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("문항 출제 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 시험응시시작사용자수조회
     *
     * @param examBscId 시험기본아이디
     * @param examDtlId 시험상세아이디
     * @return 퀴즈 정보
     * @throws Exception
     */
    @RequestMapping(value="/tkexamStrtUserCntSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> tkexamStrtUserCntSelectAjax(ExamDtlVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            resultVO.setResult(examService.tkexamStrtUserCntSelect(vo));
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("정보 조회 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /**
     * 교수퀴즈문제복사팝업
     *
     * @param sbjctId	과목아이디
     * @param examBscId 시험기본아이디
     * @return prof_quiz_qstn_copy_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizQstnCopyPopup.do")
    public String profQuizQstnCopyPopup(ExamDtlVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	QuizMainView quizMainView = quizFacadeService.loadProfQuizQstnCopyPopup(vo);
    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        model.addAttribute("quizSearchSmstrList", quizMainView.getQuizSearchSmstrList());
        vo.setUserId(userId);
        model.addAttribute("vo", vo);

        return "quiz/popup/prof_quiz_qstn_copy_pop";
    }

    /**
     * 문제가져오기과목목록조회
     *
     * @param smstrChrtId 	학기기수아이디
     * @param sbjctId 		과목이이디
     * @return 과목목록
     * @throws Exception
     */
    @RequestMapping(value="/copyQstnSbjctListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> copyQstnSbjctListAjax(SbjctVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            resultVO.setReturnList(examService.qstnCopySbjctList(vo.getSmstrChrtId(), vo.getSbjctId()));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /**
     * 문제가져오기퀴즈목록조회
     *
     * @param sbjctId 		과목이이디
     * @return 퀴즈목록
     * @throws Exception
     */
    @RequestMapping(value="/copyQstnQuizListAjax.do")
    @ResponseBody
    public ProcessResultVO<ExamDtlVO> copyQstnQuizListAjax(ExamDtlVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	ProcessResultVO<ExamDtlVO> resultVO = new ProcessResultVO<ExamDtlVO>();

    	try {
    		resultVO.setReturnList(examService.qstnCopyQuizList(vo.getSbjctId()));
    		resultVO.setResult(1);
    	} catch(Exception e) {
    		resultVO.setResult(-1);
    		resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
    	}

    	return resultVO;
    }

    /**
     * 교수문항복사퀴즈문항목록조회
     *
     * @param examDtlId 시험상세아이디
     * @return 퀴즈문항목록
     * @throws Exception
     */
    @RequestMapping(value="/profQstnCopyQuizQstnListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profQstnCopyQuizQstnList(QstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            List<EgovMap> qbnkQstnList = qstnService.profQstnCopyQuizQstnList(vo);
            resultVO.setReturnList(qbnkQstnList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수퀴즈문제출제완료수정팝업
     *
     * @param examBscId   시험기본아이디
     * @param examDtlId   시험상세아이디
     * @param examGbncd   시험구분코드
     * @param searchGubun 수정상태 ( save, edit )
     * @param searchKey   기본, 상세구분 ( bsc, dtl )
     * @return prof_quiz_qstns_cmptn_modify_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizQstnsCmptnModifyPopup.do")
    public String profQuizQstnsCmptnModifyPopup(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        request.setAttribute("vo", vo);

        return "quiz/popup/prof_quiz_qstns_cmptn_modify_pop";
    }

    /**
     * 교수퀴즈시험지미리보기팝업
     *
     * @param sbjctId   과목아이디
     * @param examBscId 시험기본아이디
     * @return prof_quiz_examppr_preview_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizExampprPreviewPopup.do")
    public String profQuizExampprPreviewPopup(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        QuizMainView quizMainView = quizFacadeService.loadProfQuizExampprPreviewPopup(vo);

        model.addAttribute("vo", quizMainView.getExamBscVO());
        model.addAttribute("qstnList", quizMainView.getQstnList());
        model.addAttribute("qstnVwitmList", quizMainView.getQstnVwitmList());
        if("QUIZ_TEAM".equals(quizMainView.getExamBscVO().getExamGbncd())) {
            model.addAttribute("quizTeamList", quizMainView.getQuizTeamList());
        }

        return "quiz/popup/prof_quiz_examppr_preview_pop";
    }

    /**
     * 교수퀴즈재응시관리화면
     *
     * @param examBscId 시험기본아이디
     * @param sbjctId   과목아이디
     * @return prof_quiz_retkexam_mng_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizRetkexamMngView.do")
    public String profQuizRetkexamMngView(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        QuizMainView quizMainView = quizFacadeService.loadProfQuizRetkexamMngView(vo);

        model.addAttribute("vo", quizMainView.getExamBscVO());
        model.addAttribute("quizTeamList", quizMainView.getQuizTeamList());
        model.addAttribute("menuTycd", "PROF");
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "quiz/prof_quiz_retkexam_mng_view";
    }

    /**
     * 교수퀴즈응시목록조회
     *
     * @param examBscId     시험기본아이디
     * @param tkexamCmptnyn 응시여부
     * @param evlyn         평가여부
     * @param searchValue   검색어(학과, 학번, 이름)
     * @return 퀴즈응시목록
     * @throws Exception
     */
    @RequestMapping(value="/profQuizTkexamListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profQuizTkexamListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            List<EgovMap> tkexamList = tkexamService.quizTkexamList(params);
            resultVO.setReturnList(tkexamList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수퀴즈응시이력팝업
     *
     * @param examDtlId 시험상세아이디
     * @param userId    사용자아이디
     * @return prof_quiz_tkexam_hstry_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizTkexamHstryPopup.do")
    public String profQuizTkexamHstryPopup(TkexamVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        QuizMainView quizMainView = quizFacadeService.loadProfQuizTkexamHstryPopup(vo);
        model.addAttribute("quizExamnee", quizMainView.getQuizExamnee());
        model.addAttribute("tkexamHstryList", quizMainView.getTkexamHstryList());

        return "quiz/popup/prof_quiz_tkexam_hstry_pop";
    }

    /**
     * 교수퀴즈시험지평가팝업
     *
     * @param examDtlId 시험상세아이디
     * @param userId    사용자아이디
     * @return prof_quiz_examppr_evl_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizExampprEvlPopup.do")
    public String profQuizExampprEvlPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        QuizMainView quizMainView = quizFacadeService.loadProfQuizExampprEvlPopup(params);
        model.addAttribute("params", params);
        model.addAttribute("vo", quizMainView.getExamBscVO());
        model.addAttribute("quizExamnee", quizMainView.getQuizExamnee());
        model.addAttribute("quizTkexamList", quizMainView.getQuizTkexamList());
        model.addAttribute("tkexamExampprAnswShtList", quizMainView.getTkexamExampprAnswShtList());

        return "quiz/popup/prof_quiz_examppr_evl_pop";
    }

    /**
     * 퀴즈재응시설정
     *
     * @param examBscId       시험기본아이디
     * @param examDtlId       시험상세아이디
     * @param userId          사용자아이디
     * @param reexamyn        재시험여부
     * @param reexamPsblSdttm 재시험가능시작일시
     * @param reexamPsblEdttm 재시험가능종료일시
     * @param reexamMrkRfltrt 재시험성적반영비율
     * @throws Exception
     */
    @RequestMapping(value="/quizRetkexamSettingAjax.do")
    @ResponseBody
    public ProcessResultVO<ExamDtlVO> quizRetkexamSettingAjax(@RequestBody List<ExamDtlVO> list, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ExamDtlVO> resultVO = new ProcessResultVO<ExamDtlVO>();

        try {
            for(ExamDtlVO vo : list) {
                vo.setRgtrId(userId);
                vo.setMdfrId(userId);
            }
            tkexamService.quizRetkexamSetting(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수퀴즈평가관리화면
     *
     * @param examBscId 	시험기본아이디
     * @param sbjctId 		과목아이디
     * @return prof_quiz_evl_mng_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizEvlMngView.do")
    public String profQuizEvlMngView(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
		QuizMainView quizMainView = quizFacadeService.loadProfQuizEvlMngView(vo);

		model.addAttribute("vo", quizMainView.getExamBscVO());
		model.addAttribute("menuTycd", "PROF");
		model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "quiz/prof_quiz_evl_mng_view";
    }

    /**
	* 교수퀴즈메모팝업
	*
	* @param sbjctId 	과목아이디
	* @return prof_quiz_memo_pop.jsp
	* @throws Exception
	*/
    @RequestMapping(value="/profQuizMemoPopup.do")
    public String profQuizMemoPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {
    	QuizMainView quizMainView = quizFacadeService.loadProfQuizMemoPopup(params);

        model.addAttribute("vo", quizMainView.getExamBscVO());
        model.addAttribute("quizExamnee", quizMainView.getQuizExamnee());
        model.addAttribute("profMemo", quizMainView.getProfMemo());

		return "quiz/popup/prof_quiz_memo_pop";
    }

    /**
	* 퀴즈교수메모수정
	*
	* @param examDtlId 	시험상세아이디
	* @param tkexamId 	시험응시아이디
	* @param userId 	사용자아이디
	* @param profMemo 	교수메모
	* @throws Exception
	*/
    @RequestMapping(value="/quizProfMemoModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<TkexamRsltVO> quizProfMemoModifyAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<TkexamRsltVO> resultVO = new ProcessResultVO<TkexamRsltVO>();

        try {
        	params.put("rgtrId", userId);
            tkexamRsltService.profMemoModify(params);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("메모 저장 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
	* 교수퀴즈시험지초기화
	*
	* @param tkexamId 	시험응시아이디
	* @param examBscId 	시험기본아이디
	* @param examDtlId 	시험상세아이디
	* @param userId 	사용자아이디
	* @throws Exception
	*/
    @RequestMapping(value="/profQuizExampprInitAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> profQuizExampprInitAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
        	params.put("rgtrId", userId);
            tkexamService.quizExampprInit(params);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("초기화 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
	* 교수퀴즈평가점수일괄수정
	*
	* @param examDtlId 	시험상세아이디
	* @param tkexamId 	시험응시아이디
	* @param userId 	사용자아이디
	* @param scr 		점수
	* @param scoreType  점수유형
	* @throws Exception
	*/
    @RequestMapping(value="/profQuizEvlScrBulkModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> profQuizEvlScrBulkModifyAjax(@RequestBody List<Map<String, Object>> list, ModelMap model, HttpServletRequest request) throws Exception {

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

    /**
     * 교수퀴즈응시현황팝업
     *
     * @param examBscId 시험기본아이디
     * @param sbjctId 	과목아이디
     * @return prof_quiz_tkexam_status_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizTkexamStatusPopup.do")
    public String profQuizTkexamStatusPopup(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        model.addAttribute("chartMap", tkexamService.userTkexamStatusSelect(vo.getExamBscId(), vo.getSbjctId()));

        return "quiz/popup/prof_quiz_tkexam_status_pop";
    }

    /**
     * 교수퀴즈응시현황엑셀다운로드
     *
     * @param examBscId 		시험기본아이디
     * @param tkexamCmptnyn 	응시여부
     * @param evlyn 			평가여부
     * @param searchValue 		검색어 ( 학과, 학번, 성명 )
     * @param excelGrid 		엑셀그리드
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value="/profQuizTkexamStatusExcelDown.do")
    public String profQuizTkexamStatusExcelDown(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", "시험학습자목록");
        map.put("sheetName", "학습자목록");
        map.put("excelGrid", vo.getExcelGrid());

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("examBscId", vo.getExamBscId());
        params.put("tkexamCmptnyn", request.getParameter("tkexamCmptnyn"));
        params.put("evlyn", request.getParameter("evlyn"));
        params.put("searchValue", vo.getSearchValue());
        map.put("list", tkexamService.quizTkexamList(params));

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", "학습자목록");

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /**
     * 교수퀴즈시험지일괄엑셀다운로드
     *
     * @param examBscId 	시험기본아이디
     * @param sbjctId 		과목아이디
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value="/profQuizExampprBulkExcelDown.do")
    public String profQuizExampprBulkExcelDown(ExamBscVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String paperTitle = "학습자별 시험지 목록";

        List<EgovMap> trgtrList = examService.exampprBulkExcelDownQuizTrgtrList(vo);
        List<EgovMap> qstnList = exampprService.exampprBulkExcelDownQuizQstnList(vo);

        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", paperTitle);      // 학습자별 시험지 목록
        map.put("sheetName", paperTitle);  // 학습자별 시험지 목록
        map.put("list", trgtrList);
        map.put("qstnList", qstnList);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", paperTitle);   // 학습자별 시험지 목록
        modelMap.put("workbook", examStarePaperStdListExcel2(map, request));
        modelMap.put("list", trgtrList);
        modelMap.put("qstnList", qstnList);
        modelMap.put("sheetName", "examStarePaperStdList");
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    public SXSSFWorkbook examStarePaperStdListExcel2(HashMap<String, Object> map, HttpServletRequest request) {

        String title = StringUtil.nvl(map.get("title"));
        String sheetName = StringUtil.nvl(map.get("sheetName"), "sheet1");
        List<EgovMap> resultList = (List<EgovMap>) map.get("list");
        List<EgovMap> qstnList = (List<EgovMap>) map.get("qstnList");

        String checkNo = "";
        int checkQstnNo = 0;
        List<EgovMap> questionNos = new ArrayList<>();
        for(int i = 0; i < qstnList.size(); i++) {
        	EgovMap egovMap = qstnList.get(i);

            int qstnSeqno = Integer.parseInt(StringUtil.nvl(egovMap.get("qstnSeqno"), "0"));
            int qstnCnddtSeqno = Integer.parseInt(StringUtil.nvl(egovMap.get("qstnCnddtSeqno"), "0"));

            if(!checkNo.equals(qstnSeqno + "-" + qstnCnddtSeqno)) {
                questionNos.add(egovMap);
                checkNo = qstnSeqno + "-" + qstnCnddtSeqno;
                checkQstnNo++;
            }
        }

        int fixColSize = 5; //고정 컬럼 길이
        int addColSize = qstnList == null ? 0 : checkQstnNo; //가변 컬럼 길이
        int colSize = fixColSize + addColSize;

        String ext = StringUtil.nvl(map.get("ext"));
        if(StringUtil.isNull(ext)) {
            ext = ".xlsx";
        }

        SXSSFWorkbook workbook = null;
        SXSSFSheet worksheet = null;
        SXSSFRow row = null;

        workbook = new SXSSFWorkbook();
        // 새로운 sheet를 생성한다.
        worksheet = workbook.createSheet(sheetName);

        //폰트 설정
        Font fontTitle = workbook.createFont();
        fontTitle.setFontHeight((short) (16 * 25)); //사이즈
        fontTitle.setBold(true);

        //폰트 설정
        Font font1 = workbook.createFont();
        font1.setFontName("나눔고딕"); //글씨체
        font1.setFontHeight((short) (16 * 10)); //사이즈
        font1.setBold(true);

        //폰트 설정(정답)
        Font fontBlue = workbook.createFont();
        fontBlue.setFontName("나눔고딕"); //글씨체
        fontBlue.setFontHeight((short) (16 * 10)); //사이즈
        fontBlue.setBold(true);
        fontBlue.setColor(IndexedColors.BLUE.getIndex());

        //폰트 설정(미평가)
        Font fontGrey = workbook.createFont();
        fontGrey.setFontName("나눔고딕"); //글씨체
        fontGrey.setFontHeight((short) (16 * 10)); //사이즈
        fontGrey.setBold(true);
        fontGrey.setColor(IndexedColors.GREY_50_PERCENT.getIndex());

        //폰트 설정(틀림)
        Font fontRed = workbook.createFont();
        fontRed.setFontName("나눔고딕"); //글씨체
        fontRed.setFontHeight((short) (16 * 10)); //사이즈
        fontRed.setBold(true);
        fontRed.setColor(IndexedColors.RED.getIndex()); //Font.COLOR_RED

        // 셀 스타일 및 폰트 설정
        CellStyle styleTitle = workbook.createCellStyle();
        //정렬
        styleTitle.setAlignment(HorizontalAlignment.CENTER);
        styleTitle.setVerticalAlignment(VerticalAlignment.CENTER);
        styleTitle.setBorderRight(BorderStyle.NONE);
        styleTitle.setBorderLeft(BorderStyle.NONE);
        styleTitle.setBorderTop(BorderStyle.NONE);
        styleTitle.setBorderBottom(BorderStyle.NONE);
        styleTitle.setFont(fontTitle);

        // 셀 스타일 및 폰트 설정
        CellStyle styleCulums = workbook.createCellStyle();
        //정렬
        styleCulums.setAlignment(HorizontalAlignment.CENTER); //왼쪽 정렬
        styleCulums.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleCulums.setBorderRight(BorderStyle.NONE);
        styleCulums.setBorderLeft(BorderStyle.NONE);
        styleCulums.setBorderTop(BorderStyle.NONE);
        styleCulums.setBorderBottom(BorderStyle.NONE);
        styleCulums.setFont(font1);

        // 셀 스타일 및 폰트 설정
        CellStyle styleContent = workbook.createCellStyle();
        //정렬
        styleContent.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
        styleContent.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleContent.setBorderRight(BorderStyle.NONE);
        styleContent.setBorderLeft(BorderStyle.NONE);
        styleContent.setBorderTop(BorderStyle.NONE);
        styleContent.setBorderBottom(BorderStyle.NONE);
        styleContent.setFont(font1);


        // 셀 스타일 및 폰트 설정(정답)
        CellStyle styleComplete = workbook.createCellStyle();
        //정렬
        styleComplete.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
        styleComplete.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleComplete.setFont(fontBlue);

        // 셀 스타일 및 폰트 설정(미평가)
        CellStyle styleStudy = workbook.createCellStyle();
        //정렬
        styleStudy.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
        styleStudy.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleStudy.setFont(fontGrey);

        // 셀 스타일 및 폰트 설정(틀림)
        CellStyle styleNoStudy = workbook.createCellStyle();
        //정렬
        styleNoStudy.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
        styleNoStudy.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleNoStudy.setFont(fontRed);

        // 칼럼 길이 설정
        int columnWidth = 3000;
        worksheet.setColumnWidth(0, 1500);
        worksheet.setColumnWidth(1, 3000);
        worksheet.setColumnWidth(2, 3000);
        worksheet.setColumnWidth(3, 3000);
        worksheet.setColumnWidth(4, 3000);

        for(int j = fixColSize; j < colSize; j++) { // 가변컬럼
            worksheet.setColumnWidth(j, columnWidth);
        }

        int rowNum = -1;

        // TITLE
        row = worksheet.createRow(++rowNum);
        for(int j = 0; j < colSize; j++) {
            row.createCell(j).setCellValue(title);
            row.getCell(j).setCellStyle(styleTitle);
        }
        // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
        if(colSize > 1) {
            worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, colSize - 1));
        }

        // 빈행
        row = worksheet.createRow(++rowNum);
        for(int j = 0; j < colSize; j++) {
            row.createCell(j).setCellValue("");
        }

        // 헤더 설정
        row = worksheet.createRow(++rowNum);
        row.createCell(0).setCellValue("NO.");
        row.getCell(0).setCellStyle(styleCulums);
        row.createCell(1).setCellValue("학과");
        row.getCell(1).setCellStyle(styleCulums); // 학과
        row.createCell(2).setCellValue("아이디");
        row.getCell(2).setCellStyle(styleCulums); // 아이디
        row.createCell(3).setCellValue("이름");
        row.getCell(3).setCellStyle(styleCulums); // 이름
        row.createCell(4).setCellValue("상태");
        row.getCell(4).setCellStyle(styleCulums); // 상태

        for(int j = fixColSize; j < colSize; j++) { // 가변컬럼
            EgovMap egovMap = questionNos.get(j - fixColSize);
            String qstnCts = StringUtil.nvl(egovMap.get("qstnCts")).replaceAll("<[^>]*>", " ");
            row.createCell(j).setCellValue(qstnCts);
            row.getCell(j).setCellStyle(styleCulums);
        }

        //헤더별 병합
        row = worksheet.createRow(++rowNum);
        for(int j = 0; j < fixColSize; j++) {
            row.createCell(j).setCellValue("");
            row.getCell(j).setCellStyle(styleTitle);
        }
        for(int j = fixColSize; j < colSize; j++) { // 가변컬럼
            EgovMap egovMap = questionNos.get(j - fixColSize);
            row.createCell(j).setCellValue(StringUtil.nvl(egovMap.get("qstnSeqno")) + "-" + StringUtil.nvl(egovMap.get("qstnCnddtSeqno")) + "번");
            row.getCell(j).setCellStyle(styleCulums);
        }

        //헤더별 병합
        row = worksheet.createRow(++rowNum);
        for(int j = 0; j < fixColSize; j++) {
            row.createCell(j).setCellValue("");
            row.getCell(j).setCellStyle(styleTitle);
            // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
            if(colSize > 1) {
                worksheet.addMergedRegion(new CellRangeAddress(rowNum - 2, rowNum, j, j));
            }
        }
        for(int j = fixColSize; j < colSize; j++) { // 가변컬럼
            EgovMap egovMap = questionNos.get(j - fixColSize);
            row.createCell(j).setCellValue(StringUtil.nvl(egovMap.get("qstnRspnsTynm")));
            row.getCell(j).setCellStyle(styleCulums);
        }

        // list
        for(int i = 0; i < resultList.size(); i++) {
            EgovMap vo = resultList.get(i);
            row = worksheet.createRow(++rowNum);
            int lineNo = resultList.size() - i;
            String userId = StringUtil.nvl(vo.get("userId"));
            String stareStatusCd = StringUtil.nvl(vo.get("tkexamCmptnyn"));
            String reExamYn = StringUtil.nvl(vo.get("retkexamYn"));
            String status = "";
            if("Y".equals(reExamYn)) {
                status = "재응시";
            }
            else if("N".equals(stareStatusCd)) {
                status = "미응시";
            }
            else if("C".equals(stareStatusCd)) {
                status = "응시완료";
            }

            row.createCell(0).setCellValue(StringUtil.nvl(lineNo));
            row.getCell(0).setCellStyle(styleContent);
            row.createCell(1).setCellValue(StringUtil.nvl(vo.get("deptnm")));
            row.getCell(1).setCellStyle(styleContent);
            row.createCell(2).setCellValue(StringUtil.nvl(vo.get("userId")));
            row.getCell(2).setCellStyle(styleContent);
            row.createCell(3).setCellValue(StringUtil.nvl(vo.get("usernm")));
            row.getCell(3).setCellStyle(styleContent);
            row.createCell(4).setCellValue(status);
            row.getCell(4).setCellStyle(styleContent);
            for(int j = fixColSize; j < colSize; j++) { // 가변컬럼
                EgovMap questionEgovMap = questionNos.get(j - fixColSize);
                String questionQstnNo = StringUtil.nvl(questionEgovMap.get("qstnSeqno"));
                String questionSubNo = StringUtil.nvl(questionEgovMap.get("qstnCnddtSeqno"));
                String questionNo = questionQstnNo + "-" + questionSubNo;
                String cellNullCheck = "";
                for(int l = 0; l < qstnList.size(); l++) {
                    EgovMap qstnEgovMap = qstnList.get(l);
                    String qstnUserId = StringUtil.nvl(qstnEgovMap.get("userId"));
                    String qstnQstnNo = StringUtil.nvl(qstnEgovMap.get("qstnSeqno"));
                    String qstnSubNo = StringUtil.nvl(qstnEgovMap.get("qstnCnddtSeqno"));
                    String qstnNo = qstnQstnNo + "-" + qstnSubNo;
                    if(userId.equals(qstnUserId) && questionNo.equals(qstnNo)) {
                        String answShtCts = StringUtil.nvl(qstnEgovMap.get("answShtCts"));
                        String qstnRspnsTycd = StringUtil.nvl(qstnEgovMap.get("qstnRspnsTycd"));
                        int scr = (int) Math.round(Math.floor(Double.parseDouble(StringUtil.nvl(qstnEgovMap.get("scr"), "0"))));

                        row.createCell(j).setCellValue(answShtCts);
                        //정답유무 처리
                        if("LONG_TEXT".equals(qstnRspnsTycd) && scr <= 0) {
                            row.getCell(j).setCellStyle(styleStudy);
                        } else if(scr > 0 && !"".equals(answShtCts)) {
                            row.getCell(j).setCellStyle(styleComplete);
                        } else if(scr == 0) {
                            row.getCell(j).setCellStyle(styleNoStudy);
                        } else {
                            row.getCell(j).setCellStyle(styleNoStudy);
                        }
                        cellNullCheck = "N";
                        break;
                    } else if(userId.equals(qstnUserId)) {
                        cellNullCheck = "Y";
                    }
                }
                if("Y".equals(cellNullCheck)) {
                    row.createCell(j).setCellValue(" ");
                    row.getCell(j).setCellStyle(styleStudy);
                }
            }
        }

        return workbook;
    }

    /**
     * 교수퀴즈시험지일괄인쇄팝업
     *
     * @param examBscId 	시험기본아이디
     * @param sbjctId   	과목아이디
     * @return prof_quiz_examppr_bulk_print_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profQuizExampprBulkPrintPopup.do")
    public String profQuizExampprBulkPrintPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {
    	QuizMainView quizMainView = quizFacadeService.loadProfQuizExampprBulkPrintPopup(params);
    	model.addAttribute("examBscVO", quizMainView.getExamBscVO());
        model.addAttribute("quizTkexamList", quizMainView.getQuizTkexamList());

        return "quiz/popup/prof_quiz_examppr_bulk_print_pop";
    }

    /**
     * 교수시험응시시험지답안목록조회
     *
     * @param tkexamId  시험응시아이디
     * @param userId 	사용자아이디
     * @return 시험응시시험지답안목록
     * @throws Exception
     */
    @RequestMapping(value="/profTkexamExampprAnswShtListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profTkexamExampprAnswShtListAjax(TkexamVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
        	resultVO.setReturnList(exampprService.tkexamExampprAnswShtList(vo.getTkexamId(), vo.getUserId()));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
	* 퀴즈시험지점수수정
	*
	* @param exampprId 			시험지아이디
	* @param qstnId 			문항아이디
	* @param tkexamAnswShtId 	시험응시답안아이디
	* @param userId 			사용자아이디
	* @throws Exception
	*/
    @RequestMapping(value="/quizExampprScrModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<TkexamAnswShtVO> quizExampprScrModifyAjax(@RequestBody List<Map<String, Object>> list, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<TkexamAnswShtVO> resultVO = new ProcessResultVO<TkexamAnswShtVO>();

        try {
        	for(Map<String, Object> map : list) {
            	map.put("rgtrId", userId);
            }
            tkexamAnswShtService.tkexamAnswShtScrModify(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("점수 저장 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 퀴즈문항분포바차트
     *
     * @param examDtlId  	시험상세아이디
     * @param qstnId 		문항아이디
     * @return 퀴즈문항분포
     * @throws Exception
     */
    @RequestMapping(value="/quizQstnDistributionBarChartAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> quizQstnDistributionBarChartAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
        	resultVO = qstnService.quizQstnDistributionBarChart(params);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }

    /**
     * 퀴즈문항정답현황파이차트
     *
     * @param examDtlId  	시험상세아이디
     * @param qstnId 		문항아이디
     * @return 퀴즈문항현황
     * @throws Exception
     */
    @RequestMapping(value="/quizQstnCransStatusPieChartAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> quizQstnCransStatusPieChartAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
        	resultVO = qstnService.quizQstnCransStatusPieChart(params);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }











    /*****************************************************
     * 퀴즈 목록 페이지 (교수)
     * @param ExamVO
     * @return "quiz/quiz_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/quizList.do")
    public String quizListForm(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        if(ValidationUtils.isEmpty(vo.getCrsCreCd())) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd = vo.getCrsCreCd();

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        vo.setCrsCreCd(crsCreCd);
        request.setAttribute("vo", vo);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));

        return "quiz/quiz_list";
    }

    /*****************************************************
     * 퀴즈 문제 정보 가져오기 ajax (교수)
     * @param ExamQstnVO
     * @return ProcessResultVO<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectQuizQstn.do")
    @ResponseBody
    public ProcessResultVO<ExamQstnVO> selectQuizQstn(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamQstnVO> resultVO = new ProcessResultVO<ExamQstnVO>();

        try {
            ExamQstnVO qstnVO = new ExamQstnVO();
            qstnVO = examQstnService.select(vo);
            resultVO.setReturnVO(qstnVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험문제 배정된 학습자 리스트 가져오기 ajax (교수)
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectQuizQstnStdList.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> selectQuizQstnStdList(ExamStarePaperVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            resultVO = examStarePaperService.listStdPageing(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문항 관리 페이지 (교수)
     * @param ExamVO
     * @return "quiz/quiz_qstn_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizQstnManage.do")
    public String quizQstnManage(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        ExamVO evo = examService.select(vo);
        if(!"".equals(StringUtil.nvl(evo.getInsRefCd()))) {
            vo.setExamCd(evo.getInsRefCd());
        }

        ExamVO examVO = examService.select(vo);
        request.setAttribute("vo", examVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        ExamQstnVO qstnVO = new ExamQstnVO();
        qstnVO.setExamCd(vo.getExamCd());

        int qstnCnt = examQstnService.qstnCount(qstnVO);
        request.setAttribute("qstnCnt", qstnCnt);

        List<ExamQstnVO> qstnList = examQstnService.list(qstnVO);
        request.setAttribute("qstnList", qstnList);
        request.setAttribute("qstnTypeList", orgCodeService.selectOrgCodeList("QSTN_TYPE_CD"));
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        LocalDateTime today = LocalDateTime.now();
        request.setAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        if("Y".equals(StringUtil.nvl(examVO.getExamSubmitYn()))) {
            List<ExamQstnVO> paperList = examQstnService.list(qstnVO);
            request.setAttribute("paperList", paperList);
        }

        return "quiz/quiz_qstn_manage";
    }

    /*****************************************************
     * 퀴즈 문항 수정 옵션 팝업
     * @param ExamVO
     * @return "quiz/popup/quiz_qstn_edit_option"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizQstnEditOptionPop.do")
    public String quizQstnEditOptionPop(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        request.setAttribute("vo", vo);

        return "quiz/popup/quiz_qstn_edit_option";
    }

    /*****************************************************
     * 퀴즈 문항 엑셀 업로드 팝업 (교수)
     * @param ExamVO
     * @return "quiz/popup/quiz_qstn_excel_upload"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizQstnExcelUploadPop.do")
    public String quizQstnExcelUploadPop(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        request.setAttribute("vo", vo);

        return "quiz/popup/quiz_qstn_excel_upload";
    }

    /*****************************************************
     * 퀴즈 문항 샘플 엑셀 다운로드 (교수)
     * @param ExamQstnVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizExcelUploadSampleDownload.do")
    public String quizExcelUploadSampleDownload(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setMdfrId(userId);
        vo.setRgtrId(userId);

        String title = getMessage("exam.label.exam.qstn"); // 시험문제

        HashMap<String, Object> map = new HashMap<String, Object>();
        List<EgovMap> resultList = new ArrayList<>();

        //예제 파일 데이터 정보값
        map = examQstnService.exampleExcelQstnList(vo);
        if(map != null) {
            resultList = (List<EgovMap>) map.get("list");
        }

        request.setAttribute("list", map.get("list"));
        request.setAttribute("vo", vo);

        // 엑셀화를 위한 정보값 세팅
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title);    // 시험문제
        modelMap.put("sheetName", title);      // 시험문제
        modelMap.put("list", resultList);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleBigGrid(map));

        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 퀴즈 문항 엑셀 업로드 (교수)
     * @param ExamVO
     * @return ProcessResultVO<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/uploadQuizQstnExcel.do")
    @ResponseBody
    public ProcessResultVO<ExamQstnVO> uploadQuizQstnExcel(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        ProcessResultVO<ExamQstnVO> resultVO = new ProcessResultVO<ExamQstnVO>();

        try {
            //등록된 파일 가져오기
            FileVO fileVO = new FileVO();
            fileVO.setUploadFiles(vo.getUploadFiles());
            fileVO.setCopyFiles(vo.getCopyFiles());
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setRgtrId(vo.getRgtrId());
            //등록된 파일 저장 후 가져오기
            fileVO = sysFileService.addFile(fileVO);

            //엑셀 읽기위한 정보값 세팅
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("startRaw", 13);
            map.put("excelGrid", vo.getExcelGrid());
            map.put("fileVO", fileVO);
            map.put("searchKey", "excelUpload");

            //엑셀 리더
            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<?> list = excelUtilPoi.simpleReadGrid(map);

            //읽어온 값으로 insert
            resultVO = examQstnService.insertExcelQstnList(vo, list);
            resultVO.setMessage(getMessage("exam.alert.excel.upload"));/* 엑셀 업로드가 완료되었습니다. */
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.excel.upload"));/* 엑셀 업로드 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문항 제출 수정 팝업
     * @param ExamVO
     * @return "quiz/popup/edit_exam_submit_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editExamSubmitYnPop.do")
    public String editExamSubmitYnPop(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        request.setAttribute("vo", vo);

        return "quiz/popup/edit_exam_submit_pop";
    }

    /*****************************************************
     * 퀴즈 문항 제출 완료 처리 ajax (교수)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editExamSubmitYn.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> editExamSubmitYn(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String connIp = StringUtil.nvl(SessionInfo.getLoginIp(request));
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setLoginIp(connIp);
            resultVO = examService.updateExamSubmitYn(vo, request);
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.submit"));/* 문항 출제 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문항 등록 ajax (교수)
     * @param ExamQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeQuizQstn.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> writeQuizQstn(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String crsCreCd = vo.getCrsCreCd();
        String examCd = vo.getExamCd();

        try {
            if(ValidationUtils.isEmpty(userId) || ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(examCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            ExamVO examVO = new ExamVO();
            examVO.setExamCd(examCd);
            examVO.setCrsCreCd(crsCreCd);
            examVO = examService.select(examVO);

            int examStartUserCnt = examVO.getExamStartUserCnt();
            if(examStartUserCnt > 0) {
                // 퀴즈 응시자가 있어 수정할 수 없습니다.
                throw new AjaxProcessException(getMessage("exam.alert.quiz.answer.user.y.not.edit"));
            }

            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            examQstnService.insertExamQstn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.insert"));/* 문항 등록 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문항 수정 ajax (교수)
     * @param ExamQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editQuizQstn.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editQuizQstn(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            vo.setMdfrId(userId);
            examQstnService.updateExamQstn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.update"));/* 문항 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문항 수정 옵션포함 ajax (교수)
     * @param ExamQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editQuizQstnOption.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editQuizQstnOption(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            vo.setMdfrId(userId);
            examQstnService.updateExamQstnOption(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.update"));/* 문항 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문항 삭제 ajax (교수)
     * @param ExamQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/delQuizQstn.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delQuizQstn(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            vo.setMdfrId(userId);
            examQstnService.updateExamQstnDelYn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.delete"));/* 문항 삭제 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 점수 수정 ajax (교수)
     * @param ExamQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateQuizQstnScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateQuizQstnScore(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            vo.setMdfrId(userId);
            examQstnService.updateExamQstnScore(vo);
            resultVO.setResult(1);
        } catch(EgovBizException | MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.score.update"));/* 점수 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 배점 일괄수정
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateQuizQstnScoreBatch.do")
    @ResponseBody
    public ProcessResultVO<ExamQstnVO> updateQuizQstnScoreBatch(@RequestBody List<ExamQstnVO> list, HttpServletRequest request, ModelMap model) throws Exception {
        ProcessResultVO<ExamQstnVO> resultVO = new ProcessResultVO<>();

        try {
            examQstnService.updateExamQstnScoreBatch(request, list);
            resultVO.setResult(1);
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문항 점수 1점 부여
     * @param ExamQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateQuizQstnScore1.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateQuizQstnScore1(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            vo.setMdfrId(userId);
            examQstnService.updateExamQstnScore1(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.score.update"));/* 점수 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 목록  가져오기 ajax (교수)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizList.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> quizList(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        try {
            vo.setUserId(userId);
            resultVO = examService.list(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 목록  가져오기 페이징 ajax (교수)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizListPaging.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> quizListPaging(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        try {
            resultVO = examService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문항 목록 가져오기 ajax (교수)
     * @param ExamQstnVO
     * @return ProcessResultVO<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listQuizQstn.do")
    @ResponseBody
    public ProcessResultVO<ExamQstnVO> listQuizQstn(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamQstnVO> resultVO = new ProcessResultVO<ExamQstnVO>();

        try {
            List<ExamQstnVO> qstnList = examQstnService.list(vo);
            if(qstnList != null && !qstnList.isEmpty() && qstnList.size() > 0) {
                int qstnCnt = examQstnService.qstnCount(vo);
                if(qstnCnt >= 0) {
                    qstnList.get(0).setQstnCnt(qstnCnt);
                }
                resultVO.setReturnList(qstnList);
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제 순서 변경 ajax (교수)
     * @param ExamQstnVO
     * @return ProcessResultVO<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editQuizQstnNo.do")
    @ResponseBody
    public ProcessResultVO<ExamQstnVO> editQuizQstnNo(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        ProcessResultVO<ExamQstnVO> resultVO = new ProcessResultVO<ExamQstnVO>();

        try {
            examQstnService.editQstnNo(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.sort"));/* 문제 번호 변경 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제 후보 순서 변경 ajax (교수)
     * @param ExamQstnVO
     * @return ProcessResultVO<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editQuizSubNo.do")
    @ResponseBody
    public ProcessResultVO<ExamQstnVO> editQuizSubNo(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        ProcessResultVO<ExamQstnVO> resultVO = new ProcessResultVO<ExamQstnVO>();

        try {
            examQstnService.editSubNo(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.sub.qstn.sort"));/* 후보 문항 순서 변경 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 재응시 관리 페이지 (교수)
     * @param ExamVO
     * @return "quiz/quiz_retake_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizRetakeManage.do")
    public String quizRetakeManage(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        ExamVO examVO = examService.select(vo);
        request.setAttribute("vo", examVO);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        request.setAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "quiz/quiz_retake_manage";
    }

    /*****************************************************
     * 퀴즈 재응시 설정 ajax (교수)
     * @param ForumStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editReQuizStare.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editReQuizStare(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            resultVO = examStareService.setReExamStare(vo, request);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.reexam"));/* 재응시 설정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 평가 관리 페이지 (교수)
     * @param ExamVO
     * @return "quiz/quiz_score_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizScoreManage.do")
    public String quizScoreManage(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd = vo.getCrsCreCd();

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.select(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);

        ExamVO examVO = examService.select(vo);
        model.addAttribute("vo", examVO);

        ExamStareVO stareVO = new ExamStareVO();
        stareVO.setExamCd(vo.getExamCd());
        stareVO.setCrsCreCd(crsCreCd);
        EgovMap scoreStatus = examStareService.selectExamScoreStatus(stareVO);
        model.addAttribute("scoreStatus", scoreStatus);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        model.addAttribute("konanCopyScoreUrl", CommConst.KONAN_COPY_SCORE_URL);

        return "quiz/quiz_score_manage";
    }

    /*****************************************************
     * 퀴즈 성적 차트 ajax (교수)
     * @param ExamStareVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewQuizScoreChart.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> viewQuizScoreChart(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            if(ValidationUtils.isEmpty(vo.getCrsCreCd())) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

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
     * 퀴즈 성적 차트 팝업
     * @param ExamStareVO
     * @return "quiz/popup/quiz_score_chart_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizScoreChartPop.do")
    public String quizScoreChartPop(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        if(ValidationUtils.isEmpty(vo.getCrsCreCd())) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        request.setAttribute("chartMap", examStareService.selectExamScoreStatus(vo));

        return "quiz/popup/quiz_score_chart_pop";
    }

    /*****************************************************
     * 퀴즈 엑셀 성적 등록 팝업 (교수)
     * @param ExamVO
     * @return "quiz/popup/quiz_score_excel_upload"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizScoreExcelUploadPop.do")
    public String quizScoreExcelUploadPop(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        request.setAttribute("vo", vo);

        return "quiz/popup/quiz_score_excel_upload";
    }

    /*****************************************************
     * 퀴즈 성적 등록 샘플 엑셀 다운로드 (교수)
     * @param ForumStareVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizScoreSampleDownload.do")
    public String quizScoreSampleDownload(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setMdfrId(userId);
        vo.setRgtrId(userId);
        vo.setPagingYn("N");

        String examTitle = getMessage("exam.label.exam.std.list"); // 시험학습자목록
        String stdTitle = getMessage("exam.label.std.list"); // 학습자목록

        ProcessResultVO<ExamStareVO> resultList = examStareService.listExamStareStd(vo);

        String[] searchValues = {};

        // POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        // 엑셀 정보값 세팅
        HashMap<String, Object> map1 = new HashMap<>();
        map1.put("title", examTitle);  // 시험학습자목록
        map1.put("sheetName", stdTitle);   // 학습자목록
        map1.put("searchValues", searchValues);
        map1.put("excelGrid", vo.getExcelGrid());
        map1.put("list", resultList.getReturnList());

        HashMap<String, Object> modelMap1 = new HashMap<>();
        modelMap1.put("outFileName", stdTitle);  // 학습자목록
        modelMap1.put("sheetName", stdTitle);    // 학습자목록
        modelMap1.put("list", resultList.getReturnList());

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap1.put("workbook", excelUtilPoi.simpleBigGrid(map1));
        model.addAllAttributes(modelMap1);

        return "excelView";
    }

    /*****************************************************
     * 퀴즈 성적 엑셀 업로드 ajax (교수)
     * @param ForumStareVO
     * @return ProcessResultVO<ExamStareVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/uploadQuizScoreExcel.do")
    @ResponseBody
    public ProcessResultVO<ExamStareVO> uploadQuizScoreExcel(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        ProcessResultVO<ExamStareVO> resultVO = new ProcessResultVO<ExamStareVO>();

        try {
            //등록된 파일 가져오기
            FileVO fileVO = new FileVO();
            fileVO.setUploadFiles(vo.getUploadFiles());
            fileVO.setCopyFiles(vo.getCopyFiles());
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setRgtrId(vo.getRgtrId());
            //등록된 파일 저장 후 가져오기
            fileVO = sysFileService.addFile(fileVO);

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
            examStareService.updateExampleExcelStareScore(vo, list);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("exam.alert.save.score"));/* 점수 저장이 완료되었습니다. */

        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 교수 메모 팝업 (교수)
     * @param ForumStareVO
     * @return "quiz/popup/quiz_prof_memo"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizProfMemoPop.do")
    public String quizProfMemoPop(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        ExamStareVO stareVO = examStareService.selectExamStareStd(vo);
        request.setAttribute("stareVO", stareVO);

        ExamVO examVO = new ExamVO();
        examVO.setExamCd(vo.getExamCd());
        examVO = examService.select(examVO);
        request.setAttribute("examVO", examVO);

        return "quiz/popup/quiz_prof_memo";
    }

    /*****************************************************
     * 퀴즈 응시 메모 수정 ajax (교수)
     * @param ForumStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editExamStareMemo.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editExamStareMemo(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            vo.setMdfrId(userId);
            examStareService.updateExamStareMemo(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.memo.insert"));/* 메모 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 응시 현황 엑셀 다운로드 (교수)
     * @param ExamVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizStatusExcelDown.do")
    public String quizStatusExcelDown(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String examTitle = getMessage("exam.label.exam.std.list"); // 시험학습자목록
        String stdTitle = getMessage("exam.label.std.list"); // 학습자목록

        HashMap<String, Object> map = new HashMap<>();
        map.put("title", examTitle);   // 시험학습자목록
        map.put("sheetName", stdTitle);    // 학습자목록
        map.put("excelGrid", vo.getExcelGrid());

        vo.setPagingYn("N");
        map.put("list", examStareService.listExamStareStd(vo).getReturnList());

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", stdTitle);   // 학습자목록

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 일괄 시험지 엑셀 다운로드 (교수)
     * @param ExamVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/allQuizPaperExcelDown.do")
    public String allQuizPaperExcelDown(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String paperTitle = getMessage("exam.label.std.paper.list"); // 학습자별 시험지 목록

        vo.setPagingYn("N");
        List<EgovMap> resultList = examStareService.listExamStareStdEgov(vo);
        ExamStarePaperVO paperVO = new ExamStarePaperVO();
        paperVO.setExamCd(vo.getExamCd());
        paperVO.setSortKey("excel");
        List<EgovMap> examQstnList = examStarePaperService.listStdStarePaper(paperVO);

        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", paperTitle);      // 학습자별 시험지 목록
        map.put("sheetName", paperTitle);  // 학습자별 시험지 목록
        map.put("list", resultList);
        map.put("examQstnList", examQstnList);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", paperTitle);   // 학습자별 시험지 목록
        modelMap.put("workbook", examStarePaperStdListExcel(map, request));
        modelMap.put("list", resultList);
        modelMap.put("examQstnList", examQstnList);
        modelMap.put("sheetName", "examStarePaperStdList");
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    public SXSSFWorkbook examStarePaperStdListExcel(HashMap<String, Object> map, HttpServletRequest request) {

        String title = StringUtil.nvl(map.get("title"));
        String sheetName = StringUtil.nvl(map.get("sheetName"), "sheet1");
        List<EgovMap> resultList = (List<EgovMap>) map.get("list");
        List<EgovMap> examQstnList = (List<EgovMap>) map.get("examQstnList");

        String checkNo = "";
        int k = 0;
        int checkQstnNo = 0;
        List<EgovMap> questionNos = new ArrayList<>();
        for(int i = 0; i < examQstnList.size(); i++) {
            EgovMap nextEgovMap = examQstnList.get(i);
            if(i - 1 < 0) {
                k = 0;
            } else {
                k = i - 1;
            }
            EgovMap egovMap = examQstnList.get(k);

            int qstnNo = Integer.parseInt(StringUtil.nvl(egovMap.get("qstnNo"), "0"));
            int subNo = Integer.parseInt(StringUtil.nvl(egovMap.get("subNo"), "0"));
            int nextQstnNo = Integer.parseInt(StringUtil.nvl(nextEgovMap.get("qstnNo"), "0"));
            int nextSubNo = Integer.parseInt(StringUtil.nvl(nextEgovMap.get("subNo"), "0"));

            if(qstnNo != 0 && subNo != 0 && !checkNo.equals(qstnNo + "-" + subNo)) {
                questionNos.add(egovMap);
                checkNo = nextQstnNo + "-" + nextSubNo;
                checkQstnNo++;
            }
        }

        int fixColSize = 5; //고정 컬럼 길이
        int addColSize = examQstnList == null ? 0 : checkQstnNo; //가변 컬럼 길이
        int colSize = fixColSize + addColSize;

        String ext = StringUtil.nvl(map.get("ext"));
        if(StringUtil.isNull(ext)) {
            ext = ".xlsx";
        }

        ServletOutputStream sos = null;
        SXSSFWorkbook workbook = null;
        SXSSFSheet worksheet = null;
        SXSSFRow row = null;
        SXSSFCell cell = null;

        workbook = new SXSSFWorkbook();
        // 새로운 sheet를 생성한다.
        worksheet = workbook.createSheet(sheetName);

        //폰트 설정
        Font fontTitle = workbook.createFont();
        fontTitle.setFontHeight((short) (16 * 25)); //사이즈
        fontTitle.setBold(true);

        //폰트 설정
        Font font1 = workbook.createFont();
        font1.setFontName("나눔고딕"); //글씨체
        font1.setFontHeight((short) (16 * 10)); //사이즈
        font1.setBold(true);

        //폰트 설정(정답)
        Font fontBlue = workbook.createFont();
        fontBlue.setFontName("나눔고딕"); //글씨체
        fontBlue.setFontHeight((short) (16 * 10)); //사이즈
        fontBlue.setBold(true);
        fontBlue.setColor(IndexedColors.BLUE.getIndex());

        //폰트 설정(미평가)
        Font fontGrey = workbook.createFont();
        fontGrey.setFontName("나눔고딕"); //글씨체
        fontGrey.setFontHeight((short) (16 * 10)); //사이즈
        fontGrey.setBold(true);
        fontGrey.setColor(IndexedColors.GREY_50_PERCENT.getIndex());

        //폰트 설정(틀림)
        Font fontRed = workbook.createFont();
        fontRed.setFontName("나눔고딕"); //글씨체
        fontRed.setFontHeight((short) (16 * 10)); //사이즈
        fontRed.setBold(true);
        fontRed.setColor(IndexedColors.RED.getIndex()); //Font.COLOR_RED

        // 셀 스타일 및 폰트 설정
        CellStyle styleTitle = workbook.createCellStyle();
        //정렬
        styleTitle.setAlignment(HorizontalAlignment.CENTER);
        styleTitle.setVerticalAlignment(VerticalAlignment.CENTER);
        styleTitle.setBorderRight(BorderStyle.NONE);
        styleTitle.setBorderLeft(BorderStyle.NONE);
        styleTitle.setBorderTop(BorderStyle.NONE);
        styleTitle.setBorderBottom(BorderStyle.NONE);
        styleTitle.setFont(fontTitle);

        // 셀 스타일 및 폰트 설정
        CellStyle styleCulums = workbook.createCellStyle();
        //정렬
        styleCulums.setAlignment(HorizontalAlignment.CENTER); //왼쪽 정렬
        styleCulums.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleCulums.setBorderRight(BorderStyle.NONE);
        styleCulums.setBorderLeft(BorderStyle.NONE);
        styleCulums.setBorderTop(BorderStyle.NONE);
        styleCulums.setBorderBottom(BorderStyle.NONE);
        styleCulums.setFont(font1);

        // 셀 스타일 및 폰트 설정
        CellStyle styleContent = workbook.createCellStyle();
        //정렬
        styleContent.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
        styleContent.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleContent.setBorderRight(BorderStyle.NONE);
        styleContent.setBorderLeft(BorderStyle.NONE);
        styleContent.setBorderTop(BorderStyle.NONE);
        styleContent.setBorderBottom(BorderStyle.NONE);
        styleContent.setFont(font1);


        // 셀 스타일 및 폰트 설정(정답)
        CellStyle styleComplete = workbook.createCellStyle();
        //정렬
        styleComplete.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
        styleComplete.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleComplete.setFont(fontBlue);

        // 셀 스타일 및 폰트 설정(미평가)
        CellStyle styleStudy = workbook.createCellStyle();
        //정렬
        styleStudy.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
        styleStudy.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleStudy.setFont(fontGrey);

        // 셀 스타일 및 폰트 설정(틀림)
        CellStyle styleNoStudy = workbook.createCellStyle();
        //정렬
        styleNoStudy.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
        styleNoStudy.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleNoStudy.setFont(fontRed);

        // 칼럼 길이 설정
        int columnWidth = 3000;
        worksheet.setColumnWidth(0, 1500);
        worksheet.setColumnWidth(1, 3000);
        worksheet.setColumnWidth(2, 3000);
        worksheet.setColumnWidth(3, 3000);
        worksheet.setColumnWidth(4, 3000);

        for(int j = fixColSize; j < colSize; j++) { // 가변컬럼
            worksheet.setColumnWidth(j, columnWidth);
        }

        int rowNum = -1;

        // TITLE
        row = worksheet.createRow(++rowNum);
        for(int j = 0; j < colSize; j++) {
            row.createCell(j).setCellValue(title);
            row.getCell(j).setCellStyle(styleTitle);
        }
        // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
        if(colSize > 1) {
            worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, colSize - 1));
        }

        // 빈행
        row = worksheet.createRow(++rowNum);
        for(int j = 0; j < colSize; j++) {
            row.createCell(j).setCellValue("");
        }

        // 헤더 설정
        row = worksheet.createRow(++rowNum);
        row.createCell(0).setCellValue("NO.");
        row.getCell(0).setCellStyle(styleCulums);
        row.createCell(1).setCellValue(getMessage("exam.label.dept"));
        row.getCell(1).setCellStyle(styleCulums); // 학과
        row.createCell(2).setCellValue(getMessage("exam.label.user.id"));
        row.getCell(2).setCellStyle(styleCulums); // 아이디
        row.createCell(3).setCellValue(getMessage("exam.label.user.nm"));
        row.getCell(3).setCellStyle(styleCulums); // 이름
        row.createCell(4).setCellValue(getMessage("exam.label.situation"));
        row.getCell(4).setCellStyle(styleCulums); // 상태

        for(int j = fixColSize; j < colSize; j++) { // 가변컬럼
            EgovMap egovMap = questionNos.get(j - fixColSize);
            String qstnCts = StringUtil.nvl(egovMap.get("qstnCts")).replaceAll("<[^>]*>", " ");
            row.createCell(j).setCellValue(qstnCts);
            row.getCell(j).setCellStyle(styleCulums);
        }

        //헤더별 병합
        row = worksheet.createRow(++rowNum);
        for(int j = 0; j < fixColSize; j++) {
            row.createCell(j).setCellValue("");
            row.getCell(j).setCellStyle(styleTitle);
        }
        for(int j = fixColSize; j < colSize; j++) { // 가변컬럼
            EgovMap egovMap = questionNos.get(j - fixColSize);
            row.createCell(j).setCellValue(StringUtil.nvl(egovMap.get("qstnNo")) + "-" + StringUtil.nvl(egovMap.get("subNo")) + getMessage("exam.label.no")); // 번
            row.getCell(j).setCellStyle(styleCulums);
        }

        //헤더별 병합
        row = worksheet.createRow(++rowNum);
        for(int j = 0; j < fixColSize; j++) {
            row.createCell(j).setCellValue("");
            row.getCell(j).setCellStyle(styleTitle);
            // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
            if(colSize > 1) {
                worksheet.addMergedRegion(new CellRangeAddress(rowNum - 2, rowNum, j, j));
            }
        }
        for(int j = fixColSize; j < colSize; j++) { // 가변컬럼
            EgovMap egovMap = questionNos.get(j - fixColSize);
            row.createCell(j).setCellValue(StringUtil.nvl(egovMap.get("qstnTypeNm")));
            row.getCell(j).setCellStyle(styleCulums);
        }

        // list
        for(int i = 0; i < resultList.size(); i++) {
            EgovMap vo = resultList.get(i);
            row = worksheet.createRow(++rowNum);
            int lineNo = resultList.size() - i;
            String stdNo = StringUtil.nvl(vo.get("stdNo"));
            String stareStatusCd = StringUtil.nvl(vo.get("stareStatusCd"));
            String reExamYn = StringUtil.nvl(vo.get("reExamYn"));
            String status = "";
            if("Y".equals(reExamYn)) {
                status = getMessage("exam.label.reexam");
            }    // 재응시
            else if("N".equals(stareStatusCd)) {
                status = getMessage("exam.label.no.stare");
            }    // 미응시
            else if("T".equals(stareStatusCd)) {
                status = getMessage("exam.label.qstn.temp.save");
            }  // 임시저장
            else if("C".equals(stareStatusCd)) {
                status = getMessage("exam.label.complete.stare");
            }  // 응시완료

            row.createCell(0).setCellValue(StringUtil.nvl(lineNo));
            row.getCell(0).setCellStyle(styleContent);
            row.createCell(1).setCellValue(StringUtil.nvl(vo.get("deptNm")));
            row.getCell(1).setCellStyle(styleContent);
            row.createCell(2).setCellValue(StringUtil.nvl(vo.get("userId")));
            row.getCell(2).setCellStyle(styleContent);
            row.createCell(3).setCellValue(StringUtil.nvl(vo.get("userNm")));
            row.getCell(3).setCellStyle(styleContent);
            row.createCell(4).setCellValue(status);
            row.getCell(4).setCellStyle(styleContent);
            for(int j = fixColSize; j < colSize; j++) { // 가변컬럼
                EgovMap questionEgovMap = questionNos.get(j - fixColSize);
                String questionQstnNo = StringUtil.nvl(questionEgovMap.get("qstnNo"));
                String questionSubNo = StringUtil.nvl(questionEgovMap.get("subNo"));
                String questionNo = questionQstnNo + "-" + questionSubNo;
                String cellNullCheck = "";
                for(int l = 0; l < examQstnList.size(); l++) {
                    EgovMap qstnEgovMap = examQstnList.get(l);
                    String qstnStdNo = StringUtil.nvl(qstnEgovMap.get("stdNo"));
                    String qstnQstnNo = StringUtil.nvl(qstnEgovMap.get("qstnNo"));
                    String qstnSubNo = StringUtil.nvl(qstnEgovMap.get("subNo"));
                    String qstnNo = qstnQstnNo + "-" + qstnSubNo;
                    if(stdNo.equals(qstnStdNo) && questionNo.equals(qstnNo)) {
                        String stareAnsr = StringUtil.nvl(qstnEgovMap.get("stareAnsr"));
                        String qstnTypeCd = StringUtil.nvl(qstnEgovMap.get("qstnTypeCd"));
                        int getScore = (int) Math.round(Math.floor(Double.parseDouble(StringUtil.nvl(qstnEgovMap.get("getScore"), "0"))));

                        row.createCell(j).setCellValue(stareAnsr);
                        //정답유무 처리
                        if("DESCRIBE".equals(qstnTypeCd) && getScore <= 0) {
                            row.getCell(j).setCellStyle(styleStudy);
                        } else if(getScore > 0 && !"".equals(stareAnsr)) {
                            row.getCell(j).setCellStyle(styleComplete);
                        } else if(getScore == 0) {
                            row.getCell(j).setCellStyle(styleNoStudy);
                        } else {
                            row.getCell(j).setCellStyle(styleNoStudy);
                        }
                        cellNullCheck = "N";
                        break;
                    } else if(stdNo.equals(qstnStdNo)) {
                        cellNullCheck = "Y";
                    }
                }
                if("Y".equals(cellNullCheck)) {
                    row.createCell(j).setCellValue(" ");
                    row.getCell(j).setCellStyle(styleStudy);
                }
            }
        }

        return workbook;
    }

    /*****************************************************
     * 퀴즈 시험지 일괄 인쇄 팝업 (교수)
     * @param ForumStareVO
     * @return "quiz/quiz_stare_paper_print"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizStarePaperListPrintPop.do")
    public String quizStarePaperListPrintPop(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        vo.setPagingYn("N");
        ProcessResultVO<EgovMap> resultList = examStareService.listExamStareStdPageing(vo);
        request.setAttribute("resultList", resultList.getReturnList());
        request.setAttribute("resultListSize", resultList.getReturnList().size());
        request.setAttribute("vo", vo);

        return "quiz/popup/quiz_stare_paper_print";
    }

    /*****************************************************
     * 학습자 시험지 리스트 가져오기 ajax (교수)
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizStarePaperList.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> quizStarePaperList(ExamStarePaperVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            if("".equals(StringUtil.nvl(vo.getExamQstnSns()[0]))) {
                vo.setExamQstnSns(null);
            }
            List<EgovMap> stdPaperList = examStarePaperService.listStdStarePaper(vo);
            resultVO.setReturnList(stdPaperList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 학습자 시험지 최종점수 변경 ajax (교수)
     * @param ForumStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateExamStareScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateExamStareScore(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            vo.setMdfrId(userId);
            resultVO = examStareService.updateExamStareScore(vo);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.score.update"));/* 점수 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 초기화 설정 ajax (교수)
     * @param ForumStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editInitQuizStare.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editInitQuizStare(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String connIp = StringUtil.nvl(SessionInfo.getLoginIp(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setLoginIp(connIp);
            resultVO = examStareService.initExamStare(vo);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.init"));/* 초기화 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 참여 사용자 리스트 가져오기 ajax (교수)
     * @param ForumStareVO
     * @return ProcessResultVO<ExamStareVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizStareUserList.do")
    @ResponseBody
    public ProcessResultVO<ExamStareVO> quizStareUserList(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamStareVO> resultVO = new ProcessResultVO<ExamStareVO>();

        try {
            resultVO = examStareService.listExamStareStd(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 시험지 미리보기 팝업 (교수)
     * @param ExamVO
     * @return "quiz/popup/quiz_qstn_preview_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizQstnPreviewPop.do")
    public String quizQstnPreviewPop(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        ExamVO examVO = examService.select(vo);

        ExamQstnVO qvo = new ExamQstnVO();
        qvo.setExamCd(examVO.getExamCd());
        List<ExamQstnVO> paperList = examQstnService.list(qvo);

        request.setAttribute("paperList", paperList);
        request.setAttribute("vo", examVO);

        return "quiz/popup/quiz_qstn_preview_pop";
    }

    /*****************************************************
     * 퀴즈 목록 페이지 (학습자)
     * @param ExamVO
     * @return "quiz/stu_quiz_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/stuQuizList.do")
    public String stuQuizListForm(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd(), SessionInfo.getCurCrsCreCd(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String auditYn = StringUtil.nvl(SessionInfo.getAuditYn(request));

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_QUIZ, "퀴즈 목록");

        vo.setCrsCreCd(crsCreCd);
        StdVO stdVO = new StdVO();
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(userId);
        stdVO = stdService.selectStd(stdVO);
        model.addAttribute("stdVO", stdVO);
        model.addAttribute("vo", vo);
        model.addAttribute("auditYn", auditYn);

        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", crsCreCd);

        return "quiz/stu_quiz_list";
    }

    /*****************************************************
     * 퀴즈 목록 가져오기 ajax (학습자)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stuQuizList.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> stuQuizList(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        try {
            vo.setUserId(userId);
            resultVO = examService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 정보 페이지 (학습자)
     * @param ExamVO
     * @return "quiz/stu_quiz_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stuQuizView.do")
    public String stuQuizView(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd());
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        StdVO stdVO = new StdVO();
        stdVO.setUserId(userId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO = stdService.selectStd(stdVO);
        vo.setStdId(stdVO.getStdId());
        vo.setUserId(userId);
        ExamVO examVO = examService.select(vo);
        examVO.setCrsCreCd(crsCreCd);

        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_QUIZ, "[" + examVO.getExamTitle() + "] 퀴즈정보 확인");

        request.setAttribute("vo", examVO);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", crsCreCd);

        return "quiz/stu_quiz_view";
    }

    /*****************************************************
     * 퀴즈 등록 페이지 (교수)
     * @param ExamVO
     * @return "quiz/quiz_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/writeQuiz.do")
    public String writeQuizForm(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String lessonScheduleId = vo.getLessonScheduleId();

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);


        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(vo.getCrsCreCd());
        List<LessonScheduleVO> lessonScheduleList = lessonScheduleService.list(lessonScheduleVO);

        model.addAttribute("lessonScheduleId", lessonScheduleId);
        model.addAttribute("lessonScheduleList", lessonScheduleList);

        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));

        return "quiz/quiz_write";
    }

    /*****************************************************
     * 퀴즈 등록 (교수)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeQuiz.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> writeQuiz(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setOrgId(orgId);
            vo.setExamCtgrCd("QUIZ");
            if("".equals(StringUtil.nvl(vo.getExamTypeCd()))) {
                vo.setExamTypeCd("QUIZ");
            }
            vo.setExamStareTypeCd(StringUtil.nvl(vo.getExamStareTypeCd(), "A"));
            vo.setExamTmTypeCd("REMAINDER");
            vo.setViewTmTypeCd("LEFT");
            vo.setUseYn("Y");
            vo.setRegYn("Y");
            resultVO.setReturnVO(examService.insertExam(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.insert"));/* 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 수정 페이지 (교수)
     * @param ExamVO
     * @return "quiz/quiz_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/editQuiz.do")
    public String editQuizForm(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        ExamVO examVO = examService.select(vo);
        model.addAttribute("vo", examVO);

        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("EXAM_CD");
        fileVO.setFileBindDataSn(vo.getExamCd());
        ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);
        for(FileVO fvo : fileList.getReturnList()) {
            fvo.setFileId(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")));
        }
        model.addAttribute("fileList", fileList.getReturnList());

        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(vo.getCrsCreCd());
        List<LessonScheduleVO> lessonScheduleList = lessonScheduleService.list(lessonScheduleVO);
        model.addAttribute("lessonScheduleList", lessonScheduleList);

        List<EgovMap> examCreCrsList = examService.listExamCreCrsDecls(vo);
        model.addAttribute("creCrsList", examCreCrsList);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));

        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        return "quiz/quiz_write";
    }

    /*****************************************************
     * 퀴즈 수정 (교수)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editQuiz.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> editQuiz(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setOrgId(orgId);
            vo.setSearchFrom("EDIT");
            resultVO.setReturnVO(examService.updateExam(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.update"));/* 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 수정 ajax (교수)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editQuizAjax.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> editQuizAjax(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        try {
            vo.setSearchFrom("EDIT");
            vo.setMdfrId(userId);
            String[] examCds = StringUtil.nvl(vo.getExamCds()).split("\\|");
            String[] scoreRatios = StringUtil.nvl(vo.getScoreRatios()).split("\\|");
            if(examCds.length > 0 && !"".equals(examCds[0])) {
                for(int i = 0; i < examCds.length; i++) {
                    vo.setExamCd(examCds[i]);
                    vo.setScoreRatio(Integer.valueOf(scoreRatios[i]));
                    examService.updateExam(vo);
                }
            } else {
                examService.updateExam(vo);
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.update"));/* 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 삭제 (교수)
     * @param ExamVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/delQuiz.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delQuiz(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String crsCreCd = vo.getCrsCreCd();
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        try {
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            vo.setMdfrId(userId);
            vo.setSearchKey("QUIZ");
            examService.updateExamDelYn(vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.delete"));/* 삭제 중 에러가 발생하였습니다. */
        }

        return resultVO;
    }

    /*****************************************************
     * 이전 퀴즈 가져오기 팝업 (교수)
     * @param ExamVO
     * @return "quiz/popup/quiz_copy_list_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizCopyListPop.do")
    public String quizCopyListPop(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));

        vo.setUserId(userId);
        request.setAttribute("vo", vo);
        TermVO termVO = new TermVO();
        termVO.setSearchKey(authGrpCd.contains("TUT") ? "ASSISTANT" : "PROF");
        if(menuType.contains("ADM") && !menuType.contains("PROF")) termVO.setSearchKey(null);
        termVO.setUserId(SessionInfo.getUserId(request));
        request.setAttribute("creYearList", termService.listCreYearByProf(termVO));
        request.setAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        return "quiz/popup/quiz_copy_list_pop";
    }

    /*****************************************************
     * 이전 퀴즈 리스트 가져오기 ajax (교수)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizCopyList.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> quizCopyList(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        try {
            vo.setOrgId(orgId);
            resultVO = examService.listMyCreCrsExam(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 이전 퀴즈 가져오기 ajax (교수)
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizCopy.do")
    @ResponseBody
    public ProcessResultVO<ExamVO> quizCopy(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


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
     * 문항 가져오기 팝업 (교수)
     * @param ExamVO
     * @return "quiz/popup/quiz_qstn_copy_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizQstnCopyPop.do")
    public String quizQstnCopyPop(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String crsCreCd = vo.getCrsCreCd();

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        vo.setUserId(userId);
        model.addAttribute("vo", vo);
        model.addAttribute("crsCreCd", crsCreCd);

        CreCrsVO cvo = new CreCrsVO();
        cvo.setCrsCreCd(crsCreCd);
        cvo = crecrsService.selectCreCrs(cvo);
        model.addAttribute("creCrsVO", cvo);

        ExamQstnVO qstnVO = new ExamQstnVO();
        qstnVO.setExamCd(vo.getExamCd());
        List<ExamQstnVO> qstnList = examQstnService.seqQstnList(qstnVO);
        model.addAttribute("qstnList", qstnList);
        model.addAttribute("qstnCnt", examQstnService.qstnCount(qstnVO));

        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        List<TermVO> termList = termService.list(termVO);
        model.addAttribute("termList", termList);

        return "quiz/popup/quiz_qstn_copy_pop";
    }

    /*****************************************************
     * 퀴즈 문항 가져오기 ajax (교수)
     * @param ExamQstnVO
     * @return ProcessResultVO<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/insertCopyQstn.do")
    @ResponseBody
    public ProcessResultVO<ExamQstnVO> insertCopyQstn(ExamQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ExamQstnVO> resultVO = new ProcessResultVO<ExamQstnVO>();

        try {
            vo.setRgtrId(userId);
            examQstnService.insertCopyQstn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.copy"));/* 가져오기 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 시험지 및 평가 팝업 (교수)
     * @param ExamVO
     * @return "quiz/popup/quiz_qstn_eval_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizQstnEvalPop.do")
    public String quizQstnEvalPop(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        try {
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsVO = crecrsService.selectCreCrs(creCrsVO);
            request.setAttribute("creCrsVO", creCrsVO);

            String searchValue = vo.getSearchValue();
            vo.setSearchValue("");
            ExamVO examVO = examService.select(vo);
            examVO.setSearchKey(vo.getSearchKey());
            examVO.setSearchValue(searchValue);
            request.setAttribute("vo", examVO);

            ExamStareVO stareVO = new ExamStareVO();
            stareVO.setExamCd(vo.getExamCd());
            stareVO.setStdId(vo.getStdId());
            stareVO = examStareService.selectExamStareStd(stareVO);

            ExamStarePaperVO starePaperCheckVO = new ExamStarePaperVO();
            starePaperCheckVO.setExamCd(vo.getExamCd());
            starePaperCheckVO.setStdNo(vo.getStdId());
            starePaperCheckVO.setSearchType("EVAL");
            List<EgovMap> stdPaperCheckList = examStarePaperService.listStdStarePaper(starePaperCheckVO);

            if(stareVO == null || stdPaperCheckList.size() == 0) {
                StdVO stdVO = new StdVO();
                stdVO.setStdId(vo.getStdId());
                stdVO = stdService.select(stdVO);

                if(stdVO != null) {
                    StdVO stdVO2 = new StdVO();
                    stdVO2.setCrsCreCd(stdVO.getCrsCreCd());
                    stdVO2.setUserId(stdVO.getUserId());
                    stdVO2.setStdId(stdVO.getStdId());
                    List<StdVO> stdList = new ArrayList<>();
                    stdList.add(stdVO2);
                    examVO.setSearchKey("ONE");
                    examService.insertRandomPaper(examVO, stdList);
                }

                stareVO = examStareService.selectExamStareStd(stareVO);
            }

            request.setAttribute("stareVO", stareVO);

            stareVO.setSearchKey(vo.getSearchKey());
            stareVO.setSearchValue(searchValue);
            stareVO.setPagingYn("N");
            request.setAttribute("stdList", examStareService.listExamStareStd(stareVO).getReturnList());

            ExamStarePaperVO starePaperVO = new ExamStarePaperVO();
            starePaperVO.setExamCd(vo.getExamCd());
            starePaperVO.setStdNo(vo.getStdId());
            starePaperVO.setSearchType("EVAL");
            List<EgovMap> stdPaperList = examStarePaperService.listStdStarePaper(starePaperVO);
            request.setAttribute("paperList", stdPaperList);

            request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");

            String quizCompleteYn = "N";

            // 시험 시작여부 체크
            if(menuType.contains("PROF") && examVO.getStartDttm() != null) {
                quizCompleteYn = "Y";
            }
            // 시험 완료여부 체크
            else if(menuType.contains("USR") && examVO.getEndDttm() != null) {
                quizCompleteYn = "Y";
            } else {
                String reExamYn = StringUtil.nvl(examVO.getReExamYn(), "N");
                String stuReExamYn = StringUtil.nvl(examVO.getStuReExamYn(), "N");

                if("Y".equals(reExamYn) && "Y".equals(stuReExamYn) && "완료".equals(StringUtil.nvl(examVO.getReExamStatus()))) {
                    quizCompleteYn = "Y";
                } else if("완료".equals(StringUtil.nvl(examVO.getExamStatus()))) {
                    quizCompleteYn = "Y";
                }
            }

            request.setAttribute("quizCompleteYn", quizCompleteYn);

        } catch(Exception e) {
            System.out.println(e.getMessage());
        }

        return "quiz/popup/quiz_qstn_eval_pop";
    }

    /*****************************************************
     * 퀴즈 시험문항 학습자 단일 점수 수정 ajax (교수)
     * @param ExamStarePaperVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateQstnPaperScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateQstnPaperScore(ExamStarePaperVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            vo.setMdfrId(userId);
            examStarePaperService.updateQstnPaperScore(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.score.update"));/* 점수 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 시험문항별 학습자 다수 점수 수정 ajax (교수)
     * @param ExamStarePaperVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateQstnPaperStdScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateQstnPaperStdScore(ExamStarePaperVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            vo.setMdfrId(userId);
            examStarePaperService.updateQstnPaperStdScore(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.score.update"));/* 점수 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 시험 문항별 전체 정답 처리 ajax (교수)
     * @param ExamStarePaperVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateQstnAllRightScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateQstnAllRightScore(ExamStarePaperVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            vo.setMdfrId(userId);
            examService.updateQstnAllRightScore(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.score.update"));/* 점수 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 시험지 수정 ajax (교수)
     * @param ExamStarePaperVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateQstnPaper.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateQstnPaper(ExamStarePaperVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            vo.setMdfrId(userId);
            examStarePaperService.updateStarePaper(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.qstn.score.update"));/* 점수 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 시험문항 보기문항분포 현황 바차트 ajax (교수)
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewQuizQstnBarChart.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> viewQuizQstnBarChart(ExamStarePaperVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            resultVO = examService.examQstnBarChart(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제 정답 통계 파이차트 ajax (교수)
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewQuizQstnPieChart.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> viewQuizQstnPieChart(ExamStarePaperVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            resultVO = examService.examQstnPieChart(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }

    /*****************************************************
     * 응시 기록 보기 팝업 (교수)
     * @param ForumStareVO
     * @return "quiz/popup/quiz_record_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizRecordViewPop.do")
    public String quizRecordViewPop(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        ExamVO examVO = new ExamVO();
        examVO.setExamCd(vo.getExamCd());
        examVO.setStdId(vo.getStdId());
        examVO = examService.select(examVO);
        request.setAttribute("vo", examVO);

        ExamStareVO stareVO = examStareService.selectExamStareStd(vo);
        request.setAttribute("stareVO", stareVO);

        ExamStareHstyVO stareHstyVO = new ExamStareHstyVO();
        stareHstyVO.setExamCd(vo.getExamCd());
        stareHstyVO.setStdNo(vo.getStdId());
        List<ExamStareHstyVO> recordList = examStareHstyService.listExamStareHsty(stareHstyVO);
        request.setAttribute("recordList", recordList);

        ExamStarePaperVO pvo = new ExamStarePaperVO();
        pvo.setExamCd(vo.getExamCd());
        pvo.setStdNo(vo.getStdId());
        request.setAttribute("paperList", examStarePaperService.listStdStarePaper(pvo));

        return "quiz/popup/quiz_record_view_pop";
    }

    /*****************************************************
     * 응시 시험지 답안 이력
     * @param ExamStarePaperHstyVO
     * @return ProcessResultVO<ExamStarePaperHstyVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listPaperHstyLog.do")
    @ResponseBody
    public ProcessResultVO<ExamStarePaperHstyVO> listPaperHstyLog(ExamStarePaperHstyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ExamStarePaperHstyVO> resultVO = new ProcessResultVO<ExamStarePaperHstyVO>();

        try {
            resultVO = examStarePaperService.listPaperHstyLog(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 응시 주의사항 팝업 (학습자)
     * @param ExamVO
     * @return "quiz/popup/quiz_paper_pop_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizJoinAlarmPop.do")
    public String quizJoinAlarmPop(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);
        ExamVO examVO = examService.select(vo);
        examVO.setGoUrl(StringUtil.nvl(vo.getGoUrl()));
        request.setAttribute("vo", examVO);

        return "quiz/popup/quiz_paper_pop_form";
    }

    /*****************************************************
     * 퀴즈 시험지 팝업 (학습자)
     * @param ExamVO
     * @return "quiz/popup/quiz_paper_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizJoinPop.do")
    public String quizJoinPop(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        ExamVO examVO = examService.select(vo);
        examVO.setStdId(vo.getStdId());
        request.setAttribute("vo", examVO);

        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, creCrsVO.getCrsCreCd(), CommConst.ACTN_HSTY_QUIZ, "[" + examVO.getExamTitle() + "] 퀴즈 응시 시작");
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            ExamStareVO stareVO = new ExamStareVO();
            stareVO.setExamCd(vo.getExamCd());
            stareVO.setStdId(vo.getStdId());
            stareVO = examStareService.selectExamStareStd(stareVO);
            if(stareVO == null) {
                stareVO = new ExamStareVO();
                stareVO.setExamCd(vo.getExamCd());
                stareVO.setStdId(vo.getStdId());
            }
            stareVO.setCrsCreCd(vo.getCrsCreCd());
            stareVO.setRgtrId(StringUtil.nvl(stareVO.getUserId()));
            stareVO.setMdfrId(StringUtil.nvl(stareVO.getUserId()));
            resultVO = examStarePaperService.startStdExamStare(stareVO, request);
            request.setAttribute("stareVO", stareVO);
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        request.setAttribute("processResultVO", resultVO);
        request.setAttribute("resultVO", resultVO.getReturnVO());

        return "quiz/popup/quiz_paper_pop";
    }

    /*****************************************************
     * 퀴즈 제출 ajax (학습자)
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizCompleteStare.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> quizCompleteStare(ExamStarePaperVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd(), SessionInfo.getCurCrsCreCd(request));
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            // 사용자 접속상태 저장
            logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);
            ExamVO evo = new ExamVO();
            evo.setExamCd(vo.getExamCd());
            evo = examService.select(evo);
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_QUIZ, "[" + evo.getExamTitle() + "] 퀴즈 응시 종료");

            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            resultVO = examStarePaperService.complateExamStare(vo, request);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.submit.saving"));/* 시험 제출 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 임시 저장 ajax (학습자)
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizSaveTempStare.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> quizSaveTempStare(ExamStarePaperVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd(), SessionInfo.getCurCrsCreCd(request));

        ExamVO evo = new ExamVO();
        evo.setExamCd(vo.getExamCd());
        evo = examService.select(evo);

        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_QUIZ, "[" + evo.getExamTitle() + "] 퀴즈 임시저장");

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            resultVO = examStarePaperService.saveTemporaryExamStare(vo, request);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.submit.tempsave"));/* 시험 임시 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 제출 답안 팝업 (학습자)
     * @param ExamVO
     * @return "quiz/popup/quiz_qstn_eval_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizSubmitAnswerPop.do")
    public String quizSubmitAnswerPop(ExamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        ExamVO examVO = examService.select(vo);
        request.setAttribute("vo", examVO);

        ExamStareVO stareVO = new ExamStareVO();
        stareVO.setExamCd(vo.getExamCd());
        stareVO.setStdId(vo.getStdId());
        stareVO = examStareService.selectExamStareStd(stareVO);
        request.setAttribute("stareVO", stareVO);

        ExamStarePaperVO starePaperVO = new ExamStarePaperVO();
        starePaperVO.setExamCd(vo.getExamCd());
        starePaperVO.setStdNo(vo.getStdId());
        starePaperVO.setSearchType("EVAL");
        List<EgovMap> stdPaperList = examStarePaperService.listStdStarePaper(starePaperVO);
        request.setAttribute("paperList", stdPaperList);

        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");

        String quizCompleteYn = "N";

        // 시험 완료여부 체크
        if(menuType.contains("USR") && examVO.getEndDttm() != null) {
            quizCompleteYn = "Y";
        } else {
            String reExamYn = StringUtil.nvl(examVO.getReExamYn(), "N");
            String stuReExamYn = StringUtil.nvl(examVO.getStuReExamYn(), "N");

            if("Y".equals(reExamYn) && "Y".equals(stuReExamYn) && "완료".equals(StringUtil.nvl(examVO.getReExamStatus()))) {
                quizCompleteYn = "Y";
            } else if("완료".equals(StringUtil.nvl(examVO.getExamStatus()))) {
                quizCompleteYn = "Y";
            }
        }

        request.setAttribute("quizCompleteYn", quizCompleteYn);

        return "quiz/popup/quiz_qstn_eval_pop";
    }

    /*****************************************************
     * 퀴즈 문제은행 목록 페이지 (교수)
     * @param ExamQbankQstnVO
     * @return "quiz/qbank_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/qbankList.do")
    public String qbnakListForm(ExamQbankQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd = vo.getCrsCreCd();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        //if(ValidationUtils.isEmpty(crsCreCd)) {
        //    // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        //    throw new BadRequestUrlException(getMessage("common.system.error"));
        //}
        //
        //if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
        //    throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        //}

        //CreCrsVO cvo = new CreCrsVO();
        //cvo.setCrsCreCd(crsCreCd);
        //cvo = crecrsService.selectCreCrs(cvo);
        //if("".equals(StringUtil.nvl(vo.getCrsNo()))) {
        //    vo.setCrsNo(cvo.getCrsCd());
        //}
        //request.setAttribute("creCrsVO", cvo);

        vo.setCrsCreCd(crsCreCd);
        vo.setUserId(userId);
        request.setAttribute("vo", vo);
        ExamQbankCtgrVO ctgrVO = new ExamQbankCtgrVO();
        ctgrVO.setCrsNo(vo.getCrsNo());

        //CreCrsVO creCrsVO = new CreCrsVO();
        //creCrsVO.setUserId(StringUtil.nvl(cvo.getTchNo()));
        //creCrsVO.setCreYear(cvo.getCreYear());
        //creCrsVO.setCreTerm(cvo.getCreTerm());
        //List<CrsVO> crsList = crsService.selectCrsByUserId(creCrsVO);
        //request.setAttribute("crsList", crsList);

        //ctgrVO.setSearchType("UPPER");
        //List<ExamQbankCtgrVO> qbankCtgrList = examQbankCtgrService.list(ctgrVO);
        //request.setAttribute("ctgrList", qbankCtgrList);

        //List<ExamQbankCtgrVO> userList = examQbankCtgrService.listQbankCtgrUser(ctgrVO);
        //request.setAttribute("userList", userList);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(crsCreCd));
        request.setAttribute("userId", userId);

        return "quiz/qbank_list";
    }

    /*****************************************************
     * 퀴즈 문제은행 목록 가져오기 페이징 ajax (교수)
     * @param ExamQbankQstnVO
     * @return ProcessResultVO<ExamQbankQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/qbankList.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankQstnVO> qbankList(ExamQbankQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamQbankQstnVO> resultVO = new ProcessResultVO<ExamQbankQstnVO>();

        try {
            resultVO = examQbankQstnService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 문제은행 엑셀 다운로드 (교수)
     * @param ExamQbankQstnVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/qbankExcelDown.do")
    public String qbankExcelDown(ExamQbankQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String title = getMessage("exam.label.qbank.list"); // 문제은행목록

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);      // 문제은행목록
        map.put("sheetName", title);  // 문제은행목록
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", examQbankQstnService.list(vo));

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title);   // 문제은행목록

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 퀴즈 문제은행 목록 가져오기  ajax (교수)
     * @param ExamQbankQstnVO
     * @return ProcessResultVO<ExamQbankQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/qbankQstnList.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankQstnVO> qbankQstnList(ExamQbankQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamQbankQstnVO> resultVO = new ProcessResultVO<ExamQbankQstnVO>();

        try {
            List<ExamQbankQstnVO> qstnList = examQbankQstnService.list(vo);
            resultVO.setReturnList(qstnList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제은행 등록 페이지 (교수)
     * @param ExamQbankCtgrVO
     * @return "quiz/qbank_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/writeQbank.do")
    public String writeQbankForm(ExamQbankCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userNm = StringUtil.nvl(SessionInfo.getUserNm(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        ExamQbankQstnVO qstnVO = new ExamQbankQstnVO();
        qstnVO.setCrsNo(vo.getCrsNo());
        CrsVO crsVO = new CrsVO();
        crsVO.setCrsCd(vo.getCrsNo());
        crsVO = crsService.selectCrs(crsVO);
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectTchCreCrs(creCrsVO);

        request.setAttribute("creCrsVO", creCrsVO);
        request.setAttribute("vo", qstnVO);
        request.setAttribute("crsVO", crsVO);

        vo.setSearchType("UPPER");
        List<ExamQbankCtgrVO> qbankCtgrList = examQbankCtgrService.list(vo);
        request.setAttribute("ctgrList", qbankCtgrList);
        request.setAttribute("qstnTypeList", orgCodeService.selectOrgCodeList("QSTN_TYPE_CD"));
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        ExamQbankQstnVO qvo = new ExamQbankQstnVO();
        qvo.setExamQbankCtgrCd("-");
        qvo.setCrsNo(vo.getCrsNo());
        request.setAttribute("qstnVO", examQbankQstnService.selectQbankQstnNos(qvo));

        return "quiz/qbank_write";
    }

    /*****************************************************
     * 퀴즈 문제은행 수정 페이지 (교수)
     * @param ExamQbankQstnVO
     * @return "quiz/qbank_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/editQbank.do")
    public String editQbankForm(ExamQbankQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userNm = StringUtil.nvl(SessionInfo.getUserNm(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));

        if(ValidationUtils.isEmpty(vo.getCrsCreCd())) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        ExamQbankQstnVO qstnSnVO = new ExamQbankQstnVO();
        qstnSnVO.setExamQbankQstnSn(vo.getExamQbankQstnSn());
        qstnSnVO = examQbankQstnService.select(qstnSnVO);
        ExamQbankQstnVO qstnVO = examQbankQstnService.select(vo);
        ExamQbankCtgrVO ctgrVO = new ExamQbankCtgrVO();
        ctgrVO.setCrsNo(vo.getCrsNo());
        ctgrVO.setCrsCreCd(vo.getCrsCreCd());
        CrsVO crsVO = new CrsVO();
        crsVO.setCrsCd(vo.getCrsNo());
        crsVO = crsService.selectCrs(crsVO);
        ctgrVO.setUserId(userId);
        ctgrVO.setUserNm(userNm);

        List<ExamQbankCtgrVO> qbankCtgrList = examQbankCtgrService.list(ctgrVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectTchCreCrs(creCrsVO);

        if(qstnVO == null && qstnSnVO != null) {
            request.setAttribute("vo", qstnSnVO);
        } else {
            request.setAttribute("vo", qstnVO);
        }
        request.setAttribute("creCrsVO", creCrsVO);
        request.setAttribute("crsVO", crsVO);
        request.setAttribute("ctgrList", qbankCtgrList);
        request.setAttribute("qstnTypeList", orgCodeService.selectOrgCodeList("QSTN_TYPE_CD"));
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));

        return "quiz/qbank_write";
    }

    /*****************************************************
     * 문제은행 등록 ajax (교수)
     * @param ExamQbankQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeQbank.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> writeQbank(ExamQbankQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        try {
            vo.setRgtrId(vo.getRgtrId());
            vo.setMdfrId(vo.getRgtrId());
            examQbankQstnService.insertQbankQstn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.insert")); // 저장 중 에러가 발생하였습니다.
        }

        return resultVO;
    }

    /*****************************************************
     * 문제은행 수정 ajax (교수)
     * @param ExamQbankQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editQbank.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editQbank(ExamQbankQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        try {
            vo.setMdfrId(vo.getRgtrId());
            examQbankQstnService.updateQbankQstn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.update")); // 수정 중 에러가 발생하였습니다.
        }

        examQbankQstnService.updateQbankQstn(vo);

        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제은행 삭제 ajax (교수)
     * @param ExamQbankQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/delQbank.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delQbank(ExamQbankQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            examQbankQstnService.updateQbankQstnDelYn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.delete"));/* 삭제 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제은행 하위 분류코드 가져오기 ajax (교수)
     * @param ExamQbankCtgrVO
     * @return ProcessResultVO<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listExamQbankCtgrCd.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankCtgrVO> listExamQbankCtgrCd(ExamQbankCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamQbankCtgrVO> resultVO = new ProcessResultVO<ExamQbankCtgrVO>();

        try {
            List<ExamQbankCtgrVO> qbankList = examQbankCtgrService.list(vo);
            resultVO.setReturnList(qbankList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 문제은행 분류코드 정보
     * @param ExamQbankCtgrVO
     * @return ProcessResultVO<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewExamQbankCtgrCd.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankCtgrVO> viewExamQbankCtgrCd(ExamQbankCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamQbankCtgrVO> resultVO = new ProcessResultVO<ExamQbankCtgrVO>();

        try {
            vo = examQbankCtgrService.select(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제은행 특정 분류코드 문제 순서 조회 ajax (교수)
     * @param ExamQbankQstnVO
     * @return ProcessResultVO<ExamQbankQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectQbankQstnNos.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankQstnVO> selectQbankQstnNos(ExamQbankQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<ExamQbankQstnVO> resultVO = new ProcessResultVO<ExamQbankQstnVO>();

        try {
            ExamQbankQstnVO qstnVO = examQbankQstnService.selectQbankQstnNos(vo);
            resultVO.setReturnVO(qstnVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }

        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제은행 문제보기 팝업 (교수)
     * @param ExamQbankVO
     * @return "quiz/popup/qbank_qstn_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/qbankQstnViewPop.do")
    public String qbankQstnViewPop(ExamQbankQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        ExamQbankQstnVO qstnVO = examQbankQstnService.select(vo);
        if(qstnVO != null) {
            if("MATCH".equals(StringUtil.nvl(qstnVO.getQstnTypeCd()))) {
                String rgtAnsr = StringUtil.nvl(qstnVO.getRgtAnsr1());
                String[] ansrList = rgtAnsr.split("\\|");
                List<String> arrAnsr = Arrays.asList(ansrList);
                Collections.shuffle(arrAnsr);
                rgtAnsr = String.join(",", arrAnsr);
                qstnVO.setRgtAnsr1(rgtAnsr);
            }
        }
        request.setAttribute("vo", qstnVO);

        return "quiz/popup/qbank_qstn_view_pop";
    }

    /*****************************************************
     * 퀴즈 문제은행 분류코드 등록 팝업 (교수)
     * @param ExamQbankCtgrVO
     * @return "quiz/popup/qbank_write_class_code_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeQbankCtgrPop.do")
    public String writeClassCodePop(ExamQbankCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        CrsVO crsVO = new CrsVO();
        crsVO.setCrsCd(vo.getCrsNo());
        crsVO = crsService.selectCrs(crsVO);
        CreCrsVO cvo = new CreCrsVO();
        cvo.setCrsCreCd(vo.getCrsCreCd());
        cvo = crecrsService.selectTchCreCrs(cvo);
        request.setAttribute("vo", cvo);
        request.setAttribute("crsVO", crsVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setUserId(cvo.getUserId());
        creCrsVO.setCreYear(cvo.getCreYear());
        creCrsVO.setCreTerm(cvo.getCreTerm());
        List<CrsVO> crsList = crsService.selectCrsByUserId(creCrsVO);
        request.setAttribute("crsList", crsList);

        vo.setSearchType("UPPER");
        List<ExamQbankCtgrVO> qbankCtgrList = examQbankCtgrService.list(vo);
        request.setAttribute("ctgrList", qbankCtgrList);

        List<ExamQbankCtgrVO> userList = examQbankCtgrService.listQbankCtgrUser(vo);
        request.setAttribute("userList", userList);

        return "quiz/popup/qbank_ctgr_write_pop";
    }

    /*****************************************************
     * 퀴즈 문제은행 분류코드 엑셀 다운로드 (교수)
     * @param ExamQbankCtgrVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/qbankCtgrExcelDown.do")
    public String qbankCtgrExcelDown(ExamQbankCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);

        String title = getMessage("exam.label.qbank.ctgr.list"); // 문제은행분류목록

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);     // 문제은행분류목록
        map.put("sheetName", title); // 문제은행분류목록
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", examQbankCtgrService.list(vo));

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title);  // 문제은행분류목록

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 퀴즈 문제은행 분류 코드 등록 ajax (교수)
     * @param ExamQbankCtgrVO
     * @return ProcessResultVO<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeQbankCtgr.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankCtgrVO> writeQbankCtgr(ExamQbankCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        ProcessResultVO<ExamQbankCtgrVO> resultVO = new ProcessResultVO<ExamQbankCtgrVO>();

        try {
            vo.setRgtrId(vo.getUserId());
            vo.setMdfrId(vo.getUserId());
            vo.setOrgId(orgId);
            examQbankCtgrService.insertQbankCtgr(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.insert"));/* 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제은행 분류 코드 수정
     * @param ExamQbankCtgrVO
     * @return ProcessResultVO<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editQbankCtgr.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankCtgrVO> editQbankCtgr(ExamQbankCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        ProcessResultVO<ExamQbankCtgrVO> resultVO = new ProcessResultVO<ExamQbankCtgrVO>();

        try {
            vo.setMdfrId(vo.getUserId());
            examQbankCtgrService.updateQbankCtgr(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.update"));/* 수정 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제은행 분류 코드 삭제
     * @param ExamQbankCtgrVO
     * @return ProcessResultVO<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/delQbankCtgr.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankCtgrVO> delQbankCtgr(ExamQbankCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        ProcessResultVO<ExamQbankCtgrVO> resultVO = new ProcessResultVO<ExamQbankCtgrVO>();

        try {
            examQbankCtgrService.deleteQbankCtgr(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.delete"));/* 삭제 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제은행 문제 정보 조회
     * @param ExamQbankQstnVO
     * @return ProcessResultVO<ExamQbankQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewQbankQstn.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankQstnVO> viewQbankQstn(ExamQbankQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        ProcessResultVO<ExamQbankQstnVO> resultVO = new ProcessResultVO<ExamQbankQstnVO>();

        try {
            vo = examQbankQstnService.select(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제은행 분류 목록 가져오기 ajax (교수)
     * @param ExamQbankCtgrVO
     * @return ProcessResultVO<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/qbankCtgrList.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankCtgrVO> qbankCtgrList(ExamQbankCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        ProcessResultVO<ExamQbankCtgrVO> resultVO = new ProcessResultVO<ExamQbankCtgrVO>();

        try {
            resultVO = examQbankCtgrService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 문제은행 분류코드 순서 가져오기 ajax (교수)
     * @param ExamQbankCtgrVO
     * @return ProcessResultVO<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectQbankCtgrOdr.do")
    @ResponseBody
    public ProcessResultVO<ExamQbankCtgrVO> selectQbankCtgrOdr(ExamQbankCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_QUIZ);


        ProcessResultVO<ExamQbankCtgrVO> resultVO = new ProcessResultVO<ExamQbankCtgrVO>();

        try {
            int examCtgrOdr = examQbankCtgrService.selectQbankCtgrOdr(vo);
            vo.setExamCtgrOdr(examCtgrOdr);
            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /*****************************************************
     * 퀴즈 참여가능여부 조회
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/checkStdExamStare.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> selectExamStdStareInfo(ExamStareVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            vo.setUserId(userId);
            examStareService.checkStdExamStare(vo);
            resultVO.setResult(1);
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.info"));/* 정보 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

}
