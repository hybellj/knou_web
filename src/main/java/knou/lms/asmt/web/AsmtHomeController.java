package knou.lms.asmt.web;

import com.fasterxml.jackson.annotation.JsonIgnore;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.IdPrefixType;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.*;
import knou.framework.vo.FileVO;
import knou.lms.asmt.service.AsmtProService;
import knou.lms.asmt.service.AsmtStuService;
import knou.lms.asmt.vo.AsmtVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.erp.service.ErpService;
import knou.lms.erp.vo.ErpMessageMsgVO;
import knou.lms.lesson.service.LessonScheduleService;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.mut.service.MutEvalService;
import knou.lms.mut.vo.MutEvalVO;
import knou.lms.org.service.OrgCodeService;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.sys.service.SysJobSchService;
import knou.lms.sys.vo.SysJobSchVO;
import knou.lms.team.service.TeamMemberService;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrUserInfoVO;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
// @RequestMapping(value={"/asmt/asmtHome","/asmt/asmtLect","/asmt/asmtPop"})
@RequestMapping(value="/asmt")
public class AsmtHomeController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(AsmtHomeController.class);

    /**
     * 과제 정보 service
     */
    @Resource(name="asmtProService")
    private AsmtProService asmtProService;

    @Resource(name="asmtStuService")
    private AsmtStuService asmtStuService;

    @Resource(name="mutEvalService")
    private MutEvalService mutEvalService;

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name="stdService")
    private StdService stdService;

    @Resource(name="erpService")
    private ErpService erpService;

    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name="termService")
    private TermService termService;

    @Resource(name="lessonScheduleService")
    private LessonScheduleService lessonScheduleService;

    @Resource(name="usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name="sysJobSchService")
    private SysJobSchService sysJobSchService;

    @Resource(name="teamMemberService")
    private TeamMemberService teamMemberService;

    // 과제목록 화면
    @RequestMapping(value="/profAsmtListView.do")
    public String profAsmtListView(HttpServletRequest request, ModelMap model, AsmtVO vo) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String sbjctId = vo.getSbjctId();

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        if(ValidationUtils.isEmpty(sbjctId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }


        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("sbjctId", sbjctId);

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setRgtrId(SessionInfo.getUserId(request));

        //asmtProService.chkNewStd(vo);

        vo.setSbjctId(sbjctId);
        model.addAttribute("vo", vo);

        return "asmt/asmt_list";
    }

    // 과제 조회
    @RequestMapping(value="/profAsmtSelect.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> profAsmtSelect(HttpServletRequest request, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();
        String crsCreCd = vo.getCrsCreCd();

        try {
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            vo.setOrgId(SessionInfo.getOrgId(request));
            vo.setUserId(SessionInfo.getUserId(request));

            AsmtVO asmtVO = asmtProService.select(vo);

            if(asmtVO != null) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("ASMT");
                fileVO.setFileBindDataSn(asmtVO.getAsmtId());
                asmtVO.setFileList(sysFileService.list(fileVO).getReturnList());
            }

            resultVO.setReturnVO(asmtVO);
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

    // 과제 목록 조회
    @RequestMapping(value="/profAsmtList.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> profAsmtList(HttpServletRequest request, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();
        String sbjctId = vo.getSbjctId();

        try {
            if(ValidationUtils.isEmpty(sbjctId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            vo.setOrgId(SessionInfo.getOrgId(request));
            vo.setUserId(SessionInfo.getUserId(request));

            if("Y".equals(StringUtil.nvl(vo.getPagingYn()))) {
                resultVO = asmtProService.listPaging(vo);
            } else {
                resultVO.setReturnList(asmtProService.list(vo));
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

    // 과제 복사
    @RequestMapping(value="/profAsmtCopy.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> copyAsmnt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        return asmtProService.selectAsmnt(vo);
    }

    // 이전 과제 목록 조회
    @RequestMapping(value="/profPrevAsmtList.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> getProPrevAsmntList(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(vo.getUserId());

        return asmtProService.selectPrevAsmntList(vo);
    }

    // 과제 성적공개여부 수정
    @RequestMapping(value="/profAsmtMrkOpenYnModify.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> edtScoreOpen(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        return asmtProService.updateScoreOpen(vo);
    }

    // 과제 성적반영비율 수정
    @RequestMapping(value="/profMrkRfltRtModify.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> profMrkRfltRtModify(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        return asmtProService.updateScoreRatio(vo);
    }

    // 분반 목록 조회
    @RequestMapping(value="/profDvclasList.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> getDeclsList(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();

        try {
            List<AsmtVO> resultList = asmtProService.selectDeclsList(vo);

            resultVO.setReturnList(resultList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }

    // 과제 등록 화면
    @RequestMapping(value="/profAsmtRegistView.do")
    public String asmntView(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        String sbjctId = vo.getSbjctId();

        if(ValidationUtils.isEmpty(sbjctId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 과목개설 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setSbjctId(sbjctId);
//        creCrsVO = crecrsService.select(creCrsVO);
        creCrsVO.setHaksaYear("2026");
        creCrsVO.setHaksaTerm("1");

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        model.addAttribute("vo", vo);
        model.addAttribute("creCrsVO", creCrsVO);

        if(!"".equals(StringUtil.nvl(vo.getAsmtId()))) {
            AsmtVO asmtVO = (AsmtVO) asmtProService.selectObject(vo).getReturnVO();

            model.addAttribute("asmtVO", asmtVO);
            model.addAttribute("uploadPath", getAsmntUploadPath(request, asmtVO.getAsmtId()));
        } else {
            // 새과제코드 새로 생성
            vo.setNewAsmtId(IdGenUtil.genNewId(IdPrefixType.ASMT));
            model.addAttribute("uploadPath", getAsmntUploadPath(request, vo.getNewAsmtId()));
        }

        /* 주차 선택 목록 */
        /*LessonScheduleVO lsvo = new LessonScheduleVO();
        lsvo.setCrsCreCd(vo.getSbjctId());
        List<LessonScheduleVO> lessonScheduleList = lessonScheduleService.list(lsvo);

        model.addAttribute("lessonScheduleList", lessonScheduleList);
*/
        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        // 성적처리 일정
        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setOrgId(SessionInfo.getOrgId(request));
        sysJobSchVO.setHaksaYear(creCrsVO.getCreYear());
        sysJobSchVO.setHaksaTerm(creCrsVO.getCreTerm());
        sysJobSchVO.setCalendarCtgr("00210206");
//        sysJobSchVO = sysJobSchService.select(sysJobSchVO);

        // 테스트과목 예외
        if(creCrsVO.getSbjctId().contains("TEST")) {
            if(sysJobSchVO != null) {
                sysJobSchVO.setSysjobSchdlEymd("21001231595959");
            }
        }

        model.addAttribute("sysJobSchVO", sysJobSchVO);

        return "asmt/asmt_write";
    }

    // 과제 등록
    @RequestMapping(value="/profAsmtRegist.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> proRegAsmnt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();

        try {
            vo.setOrgId(SessionInfo.getOrgId(request));
//            vo.setUserId(SessionInfo.getUserId(request));
            vo.setRgtrId(SessionInfo.getUserId(request));

            // 업로드된 파일 목록
            List<FileVO> fileList = FileUtil.getUploadFileList(vo.getUploadFiles());
            vo.setFileList(fileList);

            asmtProService.insertAsmnt(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    // 과제 수정
    @RequestMapping(value="/profAsmtModify.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> edtAsmnt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        try {
            // 업로드된 파일 목록
            List<FileVO> fileList = FileUtil.getUploadFileList(vo.getUploadFiles());
            vo.setFileList(fileList);
            asmtProService.updateAsmnt(vo);

            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    // 과제 삭제
    @RequestMapping(value="/profAsmtDelete.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> delAsmnt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        ProcessResultVO<AsmtVO> result = asmtProService.deleteAsmnt(vo);
        asmtProService.setScoreRatio(vo);

        return result;
    }

    // (팝업)이전과제목록 화면
    @RequestMapping(value="/profAsmtCopyPopView.do")
    public String asmntCopyListPop(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();

        // 강의실 정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.select(creCrsVO);

        TermVO termVO = new TermVO();
        termVO.setCrsCreCd(crsCreCd);

        model.addAttribute("vo", vo);
        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("creYearList", termService.listCreYearByProfCourse(termVO));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        return "asmt/popup/asmt_copy_list_pop";
    }

    // 과목 조회
    @RequestMapping(value="/profSbjctList.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> getCrsCreList(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        return asmtProService.selectCrsCreList(vo);
    }

    // 과제 정보 화면
    @RequestMapping(value="/profAsmtSelectView.do")
    public String asmntInfoManage(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setSelectType("OBJECT");

        request.setAttribute("vo", asmtProService.selectAsmnt(vo).getReturnVO());

        return "asmt/asmt_info_manage";
    }

    // 과제 평가 화면
    @RequestMapping(value="/profAsmtEvlView.do")
    public String asmntScoreManage(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("sbjctId", vo.getSbjctId());
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setSelectType("OBJECT");

        AsmtVO aVo = new AsmtVO();
        aVo = (AsmtVO) asmtProService.selectAsmnt(vo).getReturnVO();
        model.addAttribute("vo", aVo);

        // 참여자 조회
        model.addAttribute("jVo", asmtStuService.selectJoinIndi(vo).getReturnVO());

        if("Y".equals(aVo.getTeamAsmtStngyn())) {
            vo.setLrnGrpId(aVo.getLrnGrpId());
            model.addAttribute("teamList", asmtProService.selectTeamList(vo).getReturnList());
        }

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO.setOrgId(vo.getOrgId());
        creCrsVO.setSbjctId(vo.getSbjctId());
        creCrsVO = crecrsService.select(creCrsVO);

        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("uploadPath", getAsmntUploadPath(request, vo.getAsmtId()));
        model.addAttribute("konanCopyScoreUrl", CommConst.KONAN_COPY_SCORE_URL);
        model.addAttribute("serverMode", CommConst.SERVER_MODE);

        return "asmt/asmt_score_manage";
    }

    // 상호평가 결과 화면
    @RequestMapping(value="/profAsmtMutEvlRsltView.do")
    public String mutEvalResult(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setSelectType("OBJECT");

        AsmtVO aVo = new AsmtVO();
        aVo = (AsmtVO) asmtProService.selectAsmnt(vo).getReturnVO();
        model.addAttribute("vo", aVo);

        return "asmt/asmt_mut_eval_result";
    }

    /*****************************************************
     * 상호평가 내역 보기 팝업
     * @param
     * @return "asmt/popup/asmt_mut_eval_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profAsmtMutEvlPopSelectView.do")
    public String mutEvalViewPop(AsmtVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        model.addAttribute("vo", vo);

        return "asmt/popup/asmt_mut_eval_view_pop";
    }

    /*****************************************************
     * 상호평가 내역 보기 팝업
     * @param
     * @return "asmt/popup/stu_asmnt_mut_eval_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stdntAsmtMutEvlPopSelectView.do")
    public String stuMutEvalViewPop(AsmtVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        model.addAttribute("vo", vo);

        return "asmt/popup/stu_asmnt_mut_eval_view_pop";
    }

    // 상호평가 목록
    @RequestMapping(value="/profAsmtMutEvlList.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> listMutEval(AsmtVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);
            List<AsmtVO> list = asmtProService.listMutEval(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 루브릭 수정
    @RequestMapping(value="/profAsmtMutEvlModify.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> updateMutEval(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {

        return asmtProService.updateMutEval(vo);
    }

    // 과제 대상자 조회
    @RequestMapping(value="/profAsmtTrgtrSelect.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> getTargetIndi(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));

        return asmtProService.selectTargetIndi(vo);
    }

    // 제재출 정보 수정
    @RequestMapping(value="/profAsmtResbModify.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> edtResendInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            vo.setOrgId(SessionInfo.getOrgId(request));
            vo.setUserId(SessionInfo.getUserId(request));

            asmtProService.updateResend(vo);
            resultVO.setResult(1);
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    // (개인)참여자 조회
    @RequestMapping(value="/profAsmtSbmsnPtcpntSelect.do")
    @ResponseBody
    @JsonIgnore
    public ProcessResultVO<AsmtVO> getJoinIndi(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));

        ProcessResultVO<AsmtVO> result = asmtProService.selectJoinIndi(vo);

        return result;
    }

    // (개인)성적 수정
    @RequestMapping(value="/profAsmtMrkModify.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> edtScoreIndi(HttpServletRequest request, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();
        try {
            vo.setOrgId(SessionInfo.getOrgId(request));
            vo.setUserId(SessionInfo.getUserId(request));
            asmtProService.updateScoreIndi(vo);

            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    // (개인)성적 수정 일괄
    @RequestMapping(value="/profAsmtMrkBulkModify.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> edtScoreIndiBatch(HttpServletRequest request, ModelMap model, @RequestBody List<AsmtVO> list) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();

        try {
            asmtProService.updateScoreIndiBatch(request, list);

            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    // (팝업)메모 팝업
    @RequestMapping(value="/profAsmtMemoPopView.do")
    public String memoPop(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setSelectType("OBJECT");

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        request.setAttribute("cVo", crecrsService.selectCreCrs(creCrsVO));
        request.setAttribute("vo", asmtProService.selectAsmnt(vo).getReturnVO());
        request.setAttribute("gVo", asmtProService.selectJoinIndi(vo).getReturnVO());

        return "asmt/popup/asmt_prof_memo_pop";
    }

    // (개인)메모 수정
    @RequestMapping(value="/profAsmtMemoModify.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> edtMemoIndi(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        return asmtProService.updateMemoIndi(vo);
    }

    // (팝업)댓글 팝업
    @RequestMapping(value="/profAsmtCmntPopView.do")
    public String cmntPop(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setSelectType("OBJECT");

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        request.setAttribute("cVo", crecrsService.selectCreCrs(creCrsVO));
        request.setAttribute("gVo", asmtProService.selectJoinIndi(vo).getReturnVO());
        request.setAttribute("vo", vo);
        request.setAttribute("userId", SessionInfo.getUserId(request));
        request.setAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");

        return "asmt/popup/asmt_cmnt_pop";
    }

    // 댓글 목록 조회
    @RequestMapping(value="/profAsmtCmntList.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> listCmnt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {

        return asmtProService.listCmnt(vo);
    }

    // 댓글 등록
    @RequestMapping(value="/profAsmtCmntRegist.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> proInsertCmnt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setUserId(SessionInfo.getUserId(request));

        return asmtProService.insertCmnt(vo);
    }

    // 댓글 수정
    @RequestMapping(value="/profAsmtCmntModify.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> proUpdateCmnt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setUserId(SessionInfo.getUserId(request));

        return asmtProService.updateCmnt(vo);
    }

    // (개인)우수과제 선정
    @RequestMapping(value="/profAsmtExlnChcModify.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> edtBestIndi(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        return asmtProService.updateBestIndi(vo);
    }

    // (팀)참여자 조회
    @RequestMapping(value="/profAsmtTeamPtcpntSelect.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> getJoinTeam(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));

        return asmtProService.selectJoinTeam(vo);
    }

    // (팝업)피드백 화면
    @RequestMapping(value="/profAsmtFdbkPopView.do")
    public String fdbkListPop(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ASMT);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");

        vo.setOrgId(SessionInfo.getOrgId(request));

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        request.setAttribute("cVo", crecrsService.selectCreCrs(creCrsVO));

        vo.setSelectType("OBJECT");
        request.setAttribute("gVo", asmtProService.selectJoinIndi(vo).getReturnVO());
        request.setAttribute("aVo", vo);
        model.addAttribute("uploadPath", getAsmntUploadPath(request, vo.getAsmtId()));

        return "asmt/popup/asmt_fdbk_list_pop";
    }

    // (팝업)피드백 화면
    @RequestMapping(value="/profAsmtFdbkPopListView.do")
    public String fdbkListView(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ASMT);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");

        vo.setOrgId(SessionInfo.getOrgId(request));

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        request.setAttribute("cVo", crecrsService.selectCreCrs(creCrsVO));

        vo.setSelectType("OBJECT");
        request.setAttribute("gVo", asmtProService.selectJoinIndi(vo).getReturnVO());

        model.addAttribute("uploadPath", getAsmntUploadPath(request, vo.getAsmtId()));

        return "asmt/popup/asmt_fdbk_list_view";
    }

    // 피드백 조회
    @RequestMapping(value="/profAsmtFdbkSelect.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> getFdbk(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        return asmtProService.selectFdbk(vo);
    }

    // 피드백 저장
    @RequestMapping(value="/profAsmtFdbkRegist.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> regFdbk(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        // 쪽지발송을 위한 목록
        String[] stdNoArr = vo.getUserId().split(",");

        // 피드백 저장
        ProcessResultVO<AsmtVO> resultVO = asmtProService.insertFdbk(vo);

        try {
            AsmtVO asmtVO = new AsmtVO();
            asmtVO.setAsmtId(vo.getAsmtId());
            asmtVO.setSelectType("OBJECT");
            asmtVO = (AsmtVO) asmtProService.selectAsmnt(asmtVO).getReturnVO();

            String pushNoticeYn = asmtVO.getPushAlimyn();

            if("Y".equals(pushNoticeYn)) {
                // 쪽지발송 처리
                sendFeedbackMessage(request, vo, stdNoArr);

                // PUSH발송 처리
                sendFeedbackPush(request, vo, stdNoArr);
            }
        } catch(Exception e) {
        }
        return resultVO;
    }

    // 피드백 수정
    @RequestMapping(value="/profAsmtFdbkModify.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> edtFdbk(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        // 피드백 저장
        ProcessResultVO<AsmtVO> resultVO = asmtProService.updateFdbk(vo);

        return resultVO;
    }

    // 피드백 삭제
    @RequestMapping(value="/profAsmtFdbkDelete.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> delFdbk(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        return asmtProService.deleteFdbk(vo);
    }

    // (팝업)이전과제 목록 팝업
    @RequestMapping(value="/profPrevAsmtListPopView.do")
    public String prevAsmntPop(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ASMT);

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        request.setAttribute("cVo", crecrsService.selectCreCrs(creCrsVO));
        request.setAttribute("vo", vo);

        vo.setSelectType("OBJECT");
        request.setAttribute("gVo", asmtProService.selectJoinIndi(vo).getReturnVO());

        return "asmt/popup/asmt_prev_list_pop";
    }

    // 이전과제 제출파일 조회
    @RequestMapping(value="/profPrevAsmtSbmsnFileSelect.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> getPrevAsmntFiles(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        return asmtProService.selectPrevAsmntFiles(vo);
    }

    // Ez-Grader 화면
    @RequestMapping(value="/profEzGraderView.do")
    public String ezgView(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setSelectType("OBJECT");

        AsmtVO aVo = (AsmtVO) asmtProService.selectAsmnt(vo).getReturnVO();
        MutEvalVO mVo = new MutEvalVO();
        mVo.setSelectType("OBJECT");
//        mVo.setAsmtEvlId(aVo.getAsmtEvlId());

        // 참여자 조회
        request.setAttribute("jVo", asmtStuService.selectJoinIndi(vo).getReturnVO());

        // 우수과제 조회
        request.setAttribute("bList", asmtStuService.selectBest(vo).getReturnList());

        // 서버시간 가져오기!
        LocalDateTime today = LocalDateTime.now();
        request.setAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        request.setAttribute("stdNo", vo.getUserId());
        request.setAttribute("vo", aVo);
        request.setAttribute("eval", mutEvalService.selectMut(mVo).getReturnVO());

        model.addAttribute("uploadPath", getAsmntUploadPath(request, vo.getAsmtId()));
        model.addAttribute("konanCopyScoreUrl", CommConst.KONAN_COPY_SCORE_URL);

        if("CE_230827T194710c550004".equals(crsCreCd)) {
            model.addAttribute("docViewerUseYn", "Y");
        } else {
            model.addAttribute("docViewerUseYn", CommConst.SYNAP_DOC_VIEWER_USE_YN);
        }
        model.addAttribute("docConvertExts", String.join(",", CommConst.DOC_CONVERT_EXTS));

        return "ezg/ezg_main_form";
    }

    // (팝업)제출이력 목록 팝업
    @RequestMapping(value="/profAsmtSbmsnHstryPopListView.do")
    public String submitHystPop(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ASMT);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        request.setAttribute("cVo", crecrsService.selectCreCrs(creCrsVO));
        request.setAttribute("vo", vo);

        vo.setSelectType("OBJECT");
        request.setAttribute("gVo", asmtProService.selectJoinIndi(vo).getReturnVO());

        return "asmt/popup/asmt_hyst_list_pop";
    }

    // 제출이력 조회
    @RequestMapping(value="/profAsmtSbmsnHstrySelect.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> getSubmitHystList(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        return asmtProService.selectSubmitHystList(vo);
    }

    // (팝업)엑셀 성적 등록
    @RequestMapping(value="/profAsmtMrkExcelUploadPopView.do")
    public String excelPop(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ASMT);

        request.setAttribute("vo", vo);

        model.addAttribute("uploadPath", getAsmntUploadPath(request, vo.getAsmtId()));

        return "asmt/popup/asmt_score_excel_upload";
    }

    // (팝업)제출내용 팝업
    @RequestMapping(value="/profAsmtSbmsnCtsPopSelectView.do")
    public String asmntsbmsnCtsPop(HttpServletRequest request, ModelMap model, AsmtVO vo) throws Exception {
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        model.addAttribute("cVo", crecrsService.selectCreCrs(creCrsVO));
        model.addAttribute("vo", vo);
        model.addAttribute("asmntJoinVO", asmtProService.selectAsmntJoinUser(vo));

        return "asmt/popup/asmt_send_cts_pop";
    }

    // 엑셀 업로드(엑셀 성적등록)
    @RequestMapping(value="/profAsmtMrkBulkExcelRegist.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> regExcelUpload(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ASMT);

        vo.setUserId(SessionInfo.getUserId(request));
        return asmtProService.uploadExcel(vo);
    }

    // 엑셀 다운로드(엑셀 성적 등록 샘플)
    @RequestMapping(value="/profAsmtMrkBulkSelectSampleExcelDwln.do")
    public String getSampleDownload(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ASMT);

        vo.setSelectType("LIST");

        ProcessResultVO<AsmtVO> resultList = null;

        if("TEAM".equals(vo.getAsmtGbncd())) {
            resultList = asmtProService.selectJoinTeam(vo);
        } else {
            resultList = asmtProService.selectJoinIndi(vo);
        }
        request.setAttribute("vo", resultList.getReturnList());

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적등록_학습자목록");
        map.put("sheetName", "성적등록_학습자목록");
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", resultList.getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", "과제_성적등록_학습자목록_" + new SimpleDateFormat("yyyyMMdd").format(new Date()));

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    // 엑셀 다운로드(성적평가 리스트)
    @RequestMapping(value="/profAsmtMrkEvlListExcelDwld.do")
    public String getExcelDownload(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ASMT);

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setSelectType("LIST");

        ProcessResultVO<AsmtVO> resultList = asmtProService.selectJoinIndi(vo);
        request.setAttribute("vo", resultList.getReturnList());

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적평가리스트");
        map.put("sheetName", "성적평가리스트");
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", resultList.getReturnList());

        CreCrsVO crecrsVO = new CreCrsVO();
        crecrsVO.setCrsCreCd(vo.getCrsCreCd());
        crecrsVO = crecrsService.selectCreCrs(crecrsVO);

        ProcessResultVO<AsmtVO> resultVO = asmtProService.selectObject(vo);
        AsmtVO avo = (AsmtVO) resultVO.getReturnVO();

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", crecrsVO.getCrsCreNm() + "(" + crecrsVO.getDeclsNo() + "반)" + "_" + avo.getAsmtTtl() + "_" + new SimpleDateFormat("yyyyMMdd").format(new Date()));

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    // 선택 대상자 과제 파일다운로드
    @RequestMapping(value="/profAsmtFileDwld.do")
    public void getAsmntFileDown(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        String fileNamePattern = "[:\\\\/%*?:|\"<>]";

        // 1. 과제정보 조회
        vo.setSelectType("OBJECT");
        ProcessResultVO<AsmtVO> processResultVO = asmtProService.selectAsmnt(vo);
        AsmtVO asmtVO = (AsmtVO) processResultVO.getReturnVO();
        String asmntTitle = asmtVO.getAsmtTtl().replaceAll(fileNamePattern, "");
        String zipFileName = asmntTitle + ".zip";

        // 2. 과제 업로드 파일정보 조회
        List<FileVO> asmntSendList = asmtProService.getAsmntZipFileDown(vo);

        response.setHeader("Content-Type", "application/octet-stream");
        response.setHeader("Content-Transfer-Coding", "binary");
        response.setHeader("Pragma", "no-cache;");
        response.setHeader("Expires", "-1;");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + java.net.URLEncoder.encode(zipFileName, "UTF-8").replaceAll("\\+", "%20") + "\";charset=\"UTF-8\"");

        ServletOutputStream binaryOut = response.getOutputStream();

        ZipArchiveOutputStream zos = new ZipArchiveOutputStream(binaryOut);
        zos.setEncoding(Charset.defaultCharset().name());
        FileInputStream fis = null;

        try {
            int length;
            ZipArchiveEntry ze;
            byte[] buf = new byte[8 * 1024];
            String fileNm;

            for(FileVO fileVO : asmntSendList) {
                String path = CommConst.WEBDATA_PATH + fileVO.getFilePath() + "/" + fileVO.getFileSaveNm();
                path = path.replace("/\\/g", "/");

                File file = new File(path);

                if(!file.isDirectory() && file.exists() && file.length() > 0) {
                    fileNm = fileVO.getFileNm();

                    ze = new ZipArchiveEntry(fileNm);
                    zos.putArchiveEntry(ze);
                    fis = new FileInputStream(file);
                    while((length = fis.read(buf, 0, buf.length)) >= 0) {
                        zos.write(buf, 0, length);
                    }
                    fis.close();
                    zos.closeArchiveEntry();
                }
            }

            zos.flush();
            zos.close();
            binaryOut.flush();
            binaryOut.close();
        } catch(Exception e) {
        } finally {
            if(fis != null) try {
                fis.close();
            } catch(Exception e2) {
            }
            if(zos != null) try {
                zos.flush();
                zos.close();
            } catch(Exception e2) {
            }
            if(binaryOut != null) try {
                binaryOut.flush();
                binaryOut.close();
            } catch(Exception e2) {
            }
        }
    }

    // (팝업)재제출 관리
    @RequestMapping(value="/profAsmtSbmsnMngPopView.do")
    public String resendPop(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setSelectType("OBJECT");
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

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

        model.addAttribute("vo", asmtProService.selectAsmnt(vo).getReturnVO());
        model.addAttribute("gVo", asmtProService.selectJoinIndi(vo).getReturnVO());
        model.addAttribute("sysJobSchVO", sysJobSchVO);
        model.addAttribute("serverMode", CommConst.SERVER_MODE);

        return "asmt/popup/asmt_resend_manage_pop";
    }

    // 미제출 처리
    @RequestMapping(value="/profAsmtNsbMng.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> editNoSubmit(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);

        try {
            vo.setOrgId(orgId);
            vo.setMdfrId(userId);

            asmtProService.editNoSubmit(vo);

            resultVO.setResult(1);
        } catch(EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    // 과제목록 화면
    @RequestMapping(value="/stu/listView.do")
    public String stuListView(HttpServletRequest request, ModelMap model, AsmtVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        if(crsCreCd == null) {
            crsCreCd = SessionInfo.getCrsCreCd(request);
//            vo.setCrsCd(crsCreCd);
        }

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, vo.getCrsCreCd(), CommConst.ACTN_HSTY_ASSIGNMENT, "과제 목록");

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        asmtProService.chkNewStd(vo);

        model.addAttribute("vo", vo);

        return "asmt/stu_asmnt_list";
    }

    // 과제 조회
    @RequestMapping(value="/stu/getAsmnt.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> stuSelectAsmnt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        return asmtStuService.selectAsmnt(vo);
    }

    // 과제 정보 화면
    @RequestMapping(value="/stu/asmtInfoManage.do")
    public String stuAsmntInfoManage(HttpServletRequest request, ModelMap model, AsmtVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setSelectType("OBJECT");

        // 과제 정보조회
        AsmtVO asmtVO = (AsmtVO) asmtStuService.selectAsmnt(vo).getReturnVO();

        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, vo.getCrsCreCd(), CommConst.ACTN_HSTY_ASSIGNMENT, "[" + asmtVO.getAsmtTtl() + "] 과제정보 확인");

        model.addAttribute("vo", asmtVO);

        if("HY-LIGHT".equals(asmtVO.getAsmtGbncd())) {
            return "asmt/stu_asmnt_info_manage_hylight";
        }

        // 참여자 조회
        model.addAttribute("jVo", asmtStuService.selectJoinIndi(vo).getReturnVO());

        // 우수과제 조회
        model.addAttribute("bList", asmtStuService.selectBest(vo).getReturnList());

        // 서버시간 가져오기!
        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        model.addAttribute("uploadPath", getAsmntUploadPath(request, vo.getAsmtId()));

        return "asmt/stu_asmnt_info_manage";
    }

    // 과제 평가 화면
    @RequestMapping(value="/stu/asmtScoreManage.do")
    public String stuAsmntScoreManage(HttpServletRequest request, ModelMap model, AsmtVO vo) throws Exception {
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(userId);
        vo.setSelectType("OBJECT");

        AsmtVO asmtVO = (AsmtVO) asmtStuService.selectAsmnt(vo).getReturnVO();

        logLessonActnHstyService.saveLessonActnHsty(request, vo.getCrsCreCd(), CommConst.ACTN_HSTY_ASSIGNMENT, "[" + asmtVO.getAsmtTtl() + "] 과제 상호평가");

        model.addAttribute("vo", asmtVO);
        model.addAttribute("userId", userId);
        model.addAttribute("uploadPath", getAsmntUploadPath(request, vo.getAsmtId()));
        // 참여자 조회
        model.addAttribute("jVo", asmtStuService.selectJoinIndi(vo).getReturnVO());

        return "asmt/stu_asmnt_score_manage";
    }

    // 과제 제출
    @RequestMapping(value="/stu/regAsmnt.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> stuRegAsmnt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();

        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();
        String crsCreCd = vo.getCrsCreCd();

        try {
            vo.setUserId(StringUtil.nvl(vo.getUserId(), SessionInfo.getUserId(request)));

            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 업로드된 파일 목록
            List<FileVO> fileList = FileUtil.getUploadFileList(vo.getUploadFiles());
            vo.setFileList(fileList);

            asmtStuService.insertAsmnt(vo);

            if("Y".equals(CommConst.SYNAP_DOC_VIEWER_USE_YN) || "CE_230827T194710c550004".equals(crsCreCd)) {
                try {
                    if(ValidationUtils.isNotEmpty(vo.getAsmtSbmsnId())) {
                        FileVO fileVO = new FileVO();
                        fileVO.setRepoCd("ASMNT");
                        fileVO.setFileBindDataSn(vo.getAsmtSbmsnId());
                        List<FileVO> list = sysFileService.list(fileVO).getReturnList();
                        sysFileService.convertToHtmlViewerFileList(list);
                    }
                } catch(Exception e) {
                    LOGGER.debug("convertToHtmlViewerFile Error: ", e);
                }
            }

            try {
                // 강의실 활동 로그 등록
                vo.setSelectType("OBJECT");
                AsmtVO avo = (AsmtVO) asmtStuService.selectAsmnt(vo).getReturnVO();
                logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_ASSIGNMENT, "[" + avo.getAsmtTtl() + "] 과제 제출");
            } catch(Exception e) {
            }

            resultVO.setResult(1);
        } catch(MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());

            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!

            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }
        return resultVO;
    }

    // 교수자가 제출 완료 처리
    @RequestMapping(value="/profAsmtSbmsnCmptnProc.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> changeAsmntSubmit(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();

        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();
        String crsCreCd = vo.getCrsCreCd();
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        try {
            if(ValidationUtils.isEmpty(crsCreCd)
                    || ValidationUtils.isEmpty(vo.getUserId())
                    || ValidationUtils.isEmpty(vo.getAsmtId())
                    || ValidationUtils.isEmpty(vo.getAsmtSbmsnId())) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            if(!menuType.contains("PROF")) {
                // 페이지 접근 권한이 없습니다.
                throw new AccessDeniedException(getCommonNoAuthMessage());
            }

            // 업로드된 파일 목록
            List<FileVO> fileList = FileUtil.getUploadFileList(vo.getUploadFiles());
            vo.setFileList(fileList);

            asmtProService.serInsertAsmnt(vo);

            try {
                // 강의실 활동 로그 등록
                vo.setSelectType("OBJECT");
                AsmtVO avo = (AsmtVO) asmtStuService.selectAsmnt(vo).getReturnVO();
                logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_ASSIGNMENT, "[" + avo.getAsmtTtl() + "] 과제 제출");
            } catch(Exception e) {

            }

            resultVO.setResult(1);
        } catch(MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());

            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!

            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }

        return resultVO;
    }

    // 교수자가 제출 완료 처리 (일괄)
    @RequestMapping(value="/profAsmtSbmsnBulkCmptnProc.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> changeAsmntSubmitBatch(AsmtVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();

        String crsCreCd = vo.getCrsCreCd();
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String indvAsmtList = vo.getIndvAsmtList();

        try {
            if(ValidationUtils.isEmpty(crsCreCd)
                    || ValidationUtils.isEmpty(vo.getAsmtId())
                    || ValidationUtils.isEmpty(indvAsmtList)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            if(!menuType.contains("PROF")) {
                // 페이지 접근 권한이 없습니다.
                throw new AccessDeniedException(getCommonNoAuthMessage());
            }

            asmtProService.serInsertAsmntBatch(request, vo);

            resultVO.setResult(1);
        } catch(MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    // 교수자가 미제출 과제 대리등록(학습자)
    @RequestMapping(value="/profAsmtNsbOnslfRegist.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> serRegAsmnt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();

        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();
        String crsCreCd = vo.getCrsCreCd();
        String userId = StringUtil.nvl(vo.getUserId(), SessionInfo.getUserId(request));

        try {
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            vo.setUserId(userId);

            // 업로드된 파일 목록
            List<FileVO> fileList = FileUtil.getUploadFileList(vo.getUploadFiles());
            vo.setFileList(fileList);

            asmtProService.serInsertAsmnt(vo);

            if("Y".equals(CommConst.SYNAP_DOC_VIEWER_USE_YN) || "CE_230827T194710c550004".equals(crsCreCd)) {
                try {
                    String asmntCd = vo.getAsmtId();

                    if(ValidationUtils.isNotEmpty(asmntCd) && ValidationUtils.isNotEmpty(userId)) {
                        AsmtVO asmtVO = new AsmtVO();
                        asmtVO.setAsmtId(asmntCd);
                        asmtVO.setCrsCreCd(crsCreCd);
                        asmtVO.setUserId(userId);
                        asmtVO.setSelectType("OBJECT");
                        asmtVO = (AsmtVO) asmtStuService.selectJoinIndi(asmtVO).getReturnVO();

                        if(asmtVO != null) {
                            @SuppressWarnings("unchecked")
                            List<FileVO> list = (List<FileVO>) asmtVO.getFileList();
                            sysFileService.convertToHtmlViewerFileList(list);
                        }
                    }
                } catch(Exception e) {
                    LOGGER.debug("convertToHtmlViewerFile Error: ", e);
                }
            }

            try {
                // 강의실 활동 로그 등록
                vo.setSelectType("OBJECT");
                AsmtVO avo = (AsmtVO) asmtStuService.selectAsmnt(vo).getReturnVO();
                logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_ASSIGNMENT, "[" + avo.getAsmtTtl() + "] 과제 제출");
            } catch(Exception e) {
            }

            resultVO.setResult(1);
        } catch(MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());

            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!

            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }
        return resultVO;
    }

    // (개인)참여자 조회
    @RequestMapping(value="/stu/getJoinIndi.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> getStuJoinIndi(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        return asmtStuService.selectJoinIndi(vo);
    }

    // (팝업)상호평가 화면
    @RequestMapping(value="/stu/evalViewPop.do")
    public String getStuEvalViewPop(HttpServletRequest request, ModelMap model, AsmtVO vo) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ASMT);

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setSelectType("OBJECT");

        model.addAttribute("vo", asmtStuService.selectJoinIndi(vo).getReturnVO());
        model.addAttribute("gVo", asmtStuService.selectEval(vo).getReturnVO());
        model.addAttribute("aVo", asmtStuService.selectAsmnt(vo).getReturnVO());
        model.addAttribute("deviceType", SessionInfo.getDeviceType(request));

        if("CE_230827T194710c550004".equals(vo.getCrsCreCd())) {
            model.addAttribute("docViewerUseYn", "Y");
        } else {
            model.addAttribute("docViewerUseYn", CommConst.SYNAP_DOC_VIEWER_USE_YN);
        }
        model.addAttribute("docConvertExts", CommConst.DOC_CONVERT_EXTS);
        model.addAttribute("docConvertExts", String.join(",", CommConst.DOC_CONVERT_EXTS));

        return "asmt/popup/stu_asmnt_eval_pop";
    }

    // 상호평가 저장
    @RequestMapping(value="/stu/regEval.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> regStuEval(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ASMT);

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        return asmtStuService.insertEval(vo);
    }

    // (팝업)우수과제 화면
    @RequestMapping(value="/stu/bestViewPop.do")
    public String getStuBestViewPop(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ASMT);

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setSelectType("OBJECT");

        request.setAttribute("vo", asmtStuService.selectJoinIndi(vo).getReturnVO());

        return "asmt/popup/stu_asmnt_best_pop";
    }

    // 피드백 쪽지 발송
    private void sendFeedbackMessage(HttpServletRequest request, AsmtVO vo, String[] stdNoArr) throws Exception {
        // 쪽지발송 처리
        if("Y".equals(CommConst.FEEDBACK_MESSAGE_SEND_YN)) {
            String orgId = SessionInfo.getOrgId(request);

            // 과목정보
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsVO = crecrsService.selectCreCrs(creCrsVO);

            // 과제정보
            vo.setSelectType("OBJECT");
            AsmtVO asmtVO = (AsmtVO) asmtProService.selectAsmnt(vo).getReturnVO();

            // 학생정보
            StdVO stdVO = new StdVO();
            stdVO.setCrsCreCd(vo.getCrsCreCd());
            stdVO.setStdIdArr(stdNoArr);
            List<StdVO> stdList = stdService.listUserByStdNo(stdVO);

            // 발송대상자 조회
            List<String> userIdList = new ArrayList<>();

            for(StdVO stdVO2 : stdList) {
                userIdList.add(stdVO2.getUserId());
            }

            UsrUserInfoVO userResvInfoVO = new UsrUserInfoVO();
            userResvInfoVO.setOrgId(orgId);
            userResvInfoVO.setSqlForeach(userIdList.toArray(new String[userIdList.size()]));
            List<UsrUserInfoVO> listUserRecvInfo = usrUserInfoService.listUserRecvInfo(userResvInfoVO);

            if(listUserRecvInfo.size() > 0) {
                String msgCtnt = "<b>[" + creCrsVO.getCrsCreNm() + "] 과목, [" + asmtVO.getAsmtTtl() + "] 교수님 피드백입니다.</b><br>";
                msgCtnt += vo.getFdbkCts();

                ErpMessageMsgVO erpMessageMsgVO = new ErpMessageMsgVO();
                erpMessageMsgVO.setUsrUserInfoList(listUserRecvInfo);
                erpMessageMsgVO.setCtnt(msgCtnt);
                erpMessageMsgVO.setCrsCreCd(vo.getCrsCreCd());

                // 쪽지발송 저장
                erpService.insertSysMessageMsg(request, erpMessageMsgVO, "과제 피드백 쪽지 발송");
            }
        }
    }

    // 피드백 PUSH 발송
    private void sendFeedbackPush(HttpServletRequest request, AsmtVO vo, String[] stdNoArr) throws Exception {
        /*
        // 쪽지발송 처리
        if(!"Y".equals(CommConst.FEEDBACK_MESSAGE_SEND_YN)) {
            StdVO stdVO = new StdVO();
            stdVO.setCrsCreCd(vo.getCrsCreCd());
            stdVO.setStdIdArr(stdNoArr);

            List<StdVO> stdList = stdService.listUserByStdNo(stdVO);
            if(stdList != null && stdList.size() > 0) {
                List<String> userIdList = new ArrayList<>();
                
                for(StdVO stdVO2 : stdList) {
                    userIdList.add(stdVO2.getUserId());
                }
                
                // 발송대상자 조회
                UsrUserInfoVO userResvInfoVO = new UsrUserInfoVO();
                userResvInfoVO.setOrgId(SessionInfo.getOrgId(request));
                userResvInfoVO.setSqlForeach(userIdList.toArray(new String[userIdList.size()]));
                List<UsrUserInfoVO> listUserRecvInfo = usrUserInfoService.listUserRecvInfo(userResvInfoVO);
                
                if(listUserRecvInfo.size() > 0) {
                    // 과목정보
                    CreCrsVO creCrsVO = new CreCrsVO();
                    creCrsVO.setCrsCreCd(vo.getCrsCreCd());
                    creCrsVO = crecrsService.selectCreCrs(creCrsVO);
                    
                    String crsCreNm = StringUtil.nvl(creCrsVO.getCrsCreNm());
                    
                    if(!"".equals(crsCreNm)) {
                        crsCreNm = crsCreNm + " (" + StringUtil.nvl(creCrsVO.getDeclsNo()) + ")반";
                    }
                    
                    // [{0}], 교수님의 [피드백]이 등록되었습니다.
                    String[] subjectArgu = {crsCreNm};
                    String subject = getMessage("asmt.push.template.feedback.regist", subjectArgu);
                    String ctnt = StringUtil.removeTag(vo.getFdbkCts());
                    
                    ErpMessagePushVO erpMessagePushVO = new ErpMessagePushVO();
                    erpMessagePushVO.setUsrUserInfoList(listUserRecvInfo);
                    erpMessagePushVO.setSubject(subject);
                    erpMessagePushVO.setCtnt(ctnt);
                    erpMessagePushVO.setCrsCreCd(creCrsVO.getCrsCreCd());
                    erpService.insertSysMessagePush(request, erpMessagePushVO, "과제 피드백 등록 PUSH 발송");
                }
            }
        }
        */
    }

    // 과제 루브릭 저장
    @RequestMapping(value="/profAsmtRubricRegist.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> insertMutEvalRslt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();
        vo.setRgtrId(SessionInfo.getUserId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));

        asmtProService.insertMutEvalRslt(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    // 과제 루브릭 평가 연결 목록 조회
    @RequestMapping(value="/profAsmtRubricEvlRinkList.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> listMutEvalRslt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {

        return asmtProService.listMutEvalRslt(vo);
    }

    // 과제 대상자 루브릭 점수 채점 취소
    @RequestMapping(value="/profAsmtRubricEvlCnclRegist.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> cancelMutEvalRslt(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();
        vo.setUserId(SessionInfo.getUserId(request));

        asmtProService.cancelMutEvalRslt(vo);
        resultVO.setResult(1);

        return resultVO;
    }


    // (팝업)운영자과제제출 화면
    @RequestMapping(value="/profEzGraderSbmsnPopView.do")
    public String ezgSubmitPop(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setEzgUserId(vo.getUserId());
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setSelectType("OBJECT");

        // 과제 정보조회
        AsmtVO aVo = (AsmtVO) asmtProService.selectAsmnt(vo).getReturnVO();
        MutEvalVO mVo = new MutEvalVO();
        mVo.setSelectType("OBJECT");
//        mVo.setAsmtEvlId(aVo.getAsmtEvlId());

        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, vo.getCrsCreCd(), CommConst.ACTN_HSTY_ASSIGNMENT, "[" + aVo.getAsmtTtl() + "] 과제정보 확인");

        // 참여자 조회
        request.setAttribute("jVo", asmtStuService.selectJoinIndi(vo).getReturnVO());

        // 우수과제 조회
        request.setAttribute("bList", asmtStuService.selectBest(vo).getReturnList());

        // 서버시간 가져오기!
        LocalDateTime today = LocalDateTime.now();
        request.setAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        request.setAttribute("stdNo", vo.getUserId());
        request.setAttribute("vo", aVo);
        request.setAttribute("eval", mutEvalService.selectMut(mVo).getReturnVO());

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        request.setAttribute("cVo", crecrsService.selectCreCrs(creCrsVO));
        request.setAttribute("vo", vo);

        vo.setSelectType("OBJECT");
        request.setAttribute("gVo", asmtProService.selectJoinIndi(vo).getReturnVO());

        model.addAttribute("uploadPath", getAsmntUploadPath(request, vo.getAsmtId()));

        return "ezg/ezg_submit_pop";
    }

    // 과제 업로드 경로
    private String getAsmntUploadPath(HttpServletRequest request, String asmntCd) {
        String yearTerm = StringUtil.nvl(SessionInfo.getCurCrsYearTerm(request));
        if("".equals(yearTerm)) {
            Calendar cal = Calendar.getInstance();
            yearTerm = (new SimpleDateFormat("yyyy")).format(cal.getTime());

            int mon = cal.get(Calendar.MONTH) + 1;
            if(mon >= 2 && mon <= 8) {
                yearTerm += "10";
            } else {
                yearTerm += "20";
            }
        }

        String uploadPath = "/" + yearTerm + "/asmt/" + asmntCd;
        return uploadPath;
    }

    // 유사율 비교 팝업
    @RequestMapping(value="/profMosartPopView.do")
    public String mosaComparePop(AsmtVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        vo.setSelectType("OBJECT");
        AsmtVO aVo = (AsmtVO) asmtProService.selectAsmnt(vo).getReturnVO();

        model.addAttribute("vo", vo);
        model.addAttribute("aVo", aVo);
        return "asmt/popup/mosa_compare_pop";
    }

    // 과제 학생 선택 팝업
    @RequestMapping(value="/profAsmntStdntChcPopView.do")
    public String asmntStuSelectPop(AsmtVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        vo.setSelectType("OBJECT");
        AsmtVO aVo = (AsmtVO) asmtProService.selectAsmnt(vo).getReturnVO();

        model.addAttribute("vo", vo);
        model.addAttribute("aVo", aVo);
        return "asmt/popup/asmt_stu_select_pop";
    }

}
