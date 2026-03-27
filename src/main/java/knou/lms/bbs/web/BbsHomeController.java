package knou.lms.bbs.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.exception.SessionBrokenException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.FileUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidateUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.bbs.facade.BbsFacadeService;
import knou.lms.bbs.service.BbsAtclService;
import knou.lms.bbs.service.BbsCmntService;
import knou.lms.bbs.service.BbsInfoLangService;
import knou.lms.bbs.service.BbsInfoService;
import knou.lms.bbs.service.BbsViewService;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.bbs.vo.BbsCmntVO;
import knou.lms.bbs.vo.BbsInfoLangVO;
import knou.lms.bbs.vo.BbsInfoVO;
import knou.lms.bbs.vo.BbsVO;
import knou.lms.bbs.vo.BbsViewVO;
import knou.lms.bbs.web.util.BbsAuthUtil;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

@Controller
@RequestMapping(value = "/bbs/bbsHome")
public class BbsHomeController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(BbsHomeController.class);
    private static final String TEMPLATE_URL = "bbsHome";

    @Resource(name = "bbsInfoService")
    private BbsInfoService bbsInfoService;

    @Resource(name = "bbsAtclService")
    private BbsAtclService bbsAtclService;

    @Resource(name = "bbsCmntService")
    private BbsCmntService bbsCmntService;

    @Resource(name = "bbsInfoLangService")
    private BbsInfoLangService bbsInfoLangService;

    @Resource(name = "termService")
    private TermService termService;

    @Resource(name = "crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name = "bbsViewService")
    private BbsViewService bbsViewService;

    @Resource(name = "semesterService")
    private SemesterService semesterService;

    @Resource(name="orgInfoService")
	private OrgInfoService orgInfoService;

	@Resource(name="usrDeptCdService")
	private UsrDeptCdService usrDeptCdService;

	@Resource(name="sbjctService")
	private SbjctService sbjctService;

	@Resource(name="bbsFacadeService")
	private BbsFacadeService bbsFacadeService;

    /** 게시판 START **/

    /*****************************************************
     * 게시글 목록 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/atcl_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/atclList.do")
    public String atclListForm(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        boolean isAdmin = BbsAuthUtil.isAdmin(request);
        String orgId = SessionInfo.getOrgId(request);
        String bbsId = vo.getBbsId();
        String langCd = SessionInfo.getLocaleKey(request);
        String atclWriteAuth = "N"; // 글쓰기 권한

        if(ValidationUtils.isEmpty(bbsId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setLangCd(langCd);
        bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판

        if(!isAdmin) {
            bbsInfoVO.setUseYn("Y");
        }

        bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

        if(bbsInfoVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        if(BbsAuthUtil.isStudent(request)) {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME, StringUtil.nvl(bbsInfoVO.getBbsnm()) + " 목록");
        }

        // 글쓰기 권한 체크
        atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsInfoVO);

        ////////////////////////////
        addEparam("bbsId", bbsInfoVO.getBbsId());
        addEparam("bbsTycd", bbsInfoVO.getBbsTycd());

        SmstrChrtVO smstrChrtVO = new SmstrChrtVO();
        smstrChrtVO.setOrgId(SessionInfo.getOrgId(request));
        smstrChrtVO = semesterService.selectCurrentSemester(smstrChrtVO);

        model.addAttribute("curSmstrChrtVO", smstrChrtVO);

        // 조회기준연도에 개설된 학기기수 조회
        model.addAttribute("smstrChrtList", semesterService.listSmstrChrtByDgrsYr(smstrChrtVO));


        model.addAttribute("defaultYear", smstrChrtVO.getDgrsYr());
        model.addAttribute("defaultTerm", smstrChrtVO.getDgrsSmstrChrt());
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("vo", vo);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/atcl_list";
    }

    /*****************************************************
     * TODO 게시글 보기 이동     (구) -- 삭제 예정
     * @param vo
     * @param model
     * @param request
     * @return "bbs/atcl_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/atclView.do")
    public String atclView(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        boolean isAdmin = BbsAuthUtil.isAdmin(request);
        boolean isVirtualLogin = SessionInfo.isVirtualLogin(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserRprsId(request);
        String bbsId = vo.getBbsId();
        String atclId = request.getParameter("atclId");
        String langCd = SessionInfo.getLocaleKey(request);

        String atclEditAuth = "N";      // 글수정 권한
        String atclDeleteAuth  = "N";   // 글삭제 권한
        String answerWriteAuth = "N";   // 답글쓰기 권한
        String commentWriteAuth = "N";  // 댓글쓰기 권한

        if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setLangCd(langCd);
        bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판

        if(!isAdmin) {
            bbsInfoVO.setUseYn("Y");
        }

        bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

        if(bbsInfoVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        if(BbsAuthUtil.isStudent(request)) {
         // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME, bbsInfoVO.getBbsnm() + " 내용확인");
        }

        // 게시글 조회
        BbsAtclVO bbsAtclVO = new BbsAtclVO();
        bbsAtclVO.setOrgId(orgId);
        bbsAtclVO.setBbsId(bbsId);
        bbsAtclVO.setAtclId(atclId);
        bbsAtclVO.setVwerId(userId); // 조회자
        bbsAtclVO.setLangCd(langCd);

        if(!isAdmin) {
            bbsAtclVO.setLockYn("N");
            bbsAtclVO.setLearnerViewModeYn("Y");
        }
        if(CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
            bbsAtclVO.setHaksaYear(vo.getHaksaYear());
            bbsAtclVO.setHaksaTerm(vo.getHaksaTerm());
        }
        bbsAtclVO = bbsAtclService.viewBbsAtcl(bbsAtclVO);

        if(bbsAtclVO  == null) {
            // 게시글 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
        }

        // 조회 정보 등록
        if(!isVirtualLogin) {
            try {
                BbsViewVO bbsViewVO = new BbsViewVO();
                bbsViewVO.setOrgId(orgId);
                bbsViewVO.setAtclId(atclId);
                bbsViewVO.setUserId(userId);
                BbsViewVO bbsViewInfo = bbsViewService.selectBbsView(bbsViewVO);

                if(bbsViewInfo == null) {
                    bbsViewService.insertBbsView(bbsViewVO);
                } else {
                    bbsViewService.updateBbsView(bbsViewVO);
                }

                int cnt = bbsViewService.countBbsView(bbsViewVO);

                BbsAtclVO updateHitVO = new BbsAtclVO();
                updateHitVO.setAtclId(atclId);
                updateHitVO.setInqCnt(cnt);
                //bbsAtclService.updateBbsAtclHits(updateHitVO);

                // 답글이 있는경우 답글 viewer 세팅
                int answerAtclCnt = bbsAtclVO.getAnswerAtclCnt();

                if(answerAtclCnt > 0) {
                    BbsAtclVO bbsAtclVO2 = new BbsAtclVO();
                    bbsAtclVO2.setOrgId(orgId);
                    bbsAtclVO2.setBbsId(vo.getBbsId());
                    bbsAtclVO2.setUpAtclId(bbsAtclVO.getAtclId());

                    List<BbsAtclVO> listAnswerAtcl = bbsAtclService.listBbsAtclAnswer(bbsAtclVO2);

                    for(BbsAtclVO answerAtclVO : listAnswerAtcl) {
                        bbsViewVO = new BbsViewVO();
                        bbsViewVO.setAtclId(answerAtclVO.getAtclId());
                        bbsViewVO.setUserId(userId);

                        bbsViewInfo = bbsViewService.selectBbsView(bbsViewVO);

                        if(bbsViewInfo == null) {
                            bbsViewService.insertBbsView(bbsViewVO);
                        } else {
                            bbsViewService.updateBbsView(bbsViewVO);
                        }
                    }
                }
            } catch (Exception e) {
                LOGGER.debug("e: ", e);
            }
        }

        // 비공개글 접근 체크
        if(!isAdmin && !("N".equals(bbsAtclVO.getLockYn()) || userId.equals(bbsAtclVO.getRgtrId()))) {
            // 접근 권한이 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
        }

        // 글수정, 삭제, 답글, 댓글쓰기 권한체크
        atclEditAuth = BbsAuthUtil.getAtclEditAuth(request, bbsInfoVO, bbsAtclVO);
        //atclDeleteAuth = BbsAuthUtil.getAtclDeleteAuth(request, bbsVO, bbsAtclVO);
        answerWriteAuth = BbsAuthUtil.getAnswerAtclWriteAuth(request, bbsInfoVO);
        commentWriteAuth = BbsAuthUtil.getCommentWriteAuth(request, bbsInfoVO, bbsAtclVO);

        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("atclEditAuth", atclEditAuth);
        model.addAttribute("atclDeleteAuth", atclDeleteAuth);
        model.addAttribute("answerWriteAuth", answerWriteAuth);
        model.addAttribute("commentWriteAuth", commentWriteAuth);
        model.addAttribute("vo", vo);
        model.addAttribute("templateUrl", TEMPLATE_URL);
        model.addAttribute("userId", userId);

        return "bbs/atcl_view";
    }

    /*****************************************************
     * 게시글 쓰기 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/atcl_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/atclWrite.do")
    public String atclWrite(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = SessionInfo.getOrgId(request);
        String bbsId = vo.getBbsId();
        String atclWriteAuth = "Y"; // 글쓰기 권한

        String langCd = SessionInfo.getLocaleKey(request);
        vo.setLangCd(langCd);

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setLangCd(langCd);
        bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판

        if(!isAdmin) {
            bbsInfoVO.setUseYn("Y");
        }

        bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

        if(bbsInfoVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        // 글쓰기 권한 체크
        atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsInfoVO);

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("vo", vo);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/atcl_write";
    }

    /*****************************************************
     * 게시글 수정 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/home/atcl_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/atclEdit.do")
    public String atclEdit(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = SessionInfo.getOrgId(request);
        String bbsId = vo.getBbsId();
        String atclId = request.getParameter("atclId");
        String atclEditAuth = "N"; // 글수정 권한

        String langCd = SessionInfo.getLocaleKey(request);
        vo.setLangCd(langCd);

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setLangCd(langCd);
        bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판

        if(!isAdmin) {
            bbsInfoVO.setUseYn("Y");
        }

        bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

        if(bbsInfoVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        // 게시글 조회
        BbsAtclVO bbsAtclVO = new BbsAtclVO();
        bbsAtclVO.setOrgId(orgId);
        bbsAtclVO.setBbsId(bbsId);
        bbsAtclVO.setAtclId(atclId);
        bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

        if(bbsAtclVO == null) {
            // 게시글 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
        }

        atclEditAuth = BbsAuthUtil.getAtclEditAuth(request, bbsInfoVO, bbsAtclVO);

        // 첨부 파일 조회
        if(bbsAtclVO.getAtchFileCnt() > 0) {
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("BBS");
            fileVO.setFileBindDataSn(bbsAtclVO.getAtclId());
            ProcessResultVO<FileVO> resultVO = (ProcessResultVO<FileVO>) sysFileService.list(fileVO);
            List<FileVO> fileList = resultVO.getReturnList();
            bbsAtclVO.setFileList(fileList);
        }

        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("atclEditAuth", atclEditAuth);
        model.addAttribute("vo", vo);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/atcl_write";
    }

    /*****************************************************
     * 게시글 목록 조회 (구) --> bbsAtclList 로 변경
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listAtcl.do")
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> listAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsIds = request.getParameter("bbsIds"); // 게시판 id ',' 구분자
        String univGbns = request.getParameter("univGbns"); // 대학구분 ',' 구분자
        String langCd = SessionInfo.getLocaleKey(request);

        try {
            vo.setOrgId(orgId);
            vo.setLangCd(langCd);

            // 게시판 id ',' 구분자로 들어온 경우
            if(ValidationUtils.isNotEmpty(bbsIds)) {
                List<String> bbsIdList = Arrays.asList(bbsIds.split(","));
                vo.setBbsIdList(bbsIdList);
                vo.setBbsId(null);
            }
            vo.setCrsCreCd(null);
            vo.setVwerId(userId);

            if(isAdmin) {
                vo.setUnivGbn(null);
                vo.setUnivGbnList(null);
            } else {
                vo.setLockYn("N");
                vo.setLearnerViewModeYn("Y");

                List<String> univGbnList = new ArrayList<>();
                univGbnList.add("ALL");

                if(ValidationUtils.isNotEmpty(univGbns)) {
                    for(String univGbn : univGbns.split(",")) {
                        if(!"".equals(StringUtil.nvl(univGbn))) {
                            univGbnList.add(univGbn);
                        }
                    }
                }

                vo.setUnivGbnList(univGbnList.toArray(new String[univGbnList.size()]));
            }

            resultVO = bbsAtclService.listBbsAtclPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 게시글 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addAtcl.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> addAtcl(@Valid BbsAtclVO vo, BindingResult bindingResult, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

    	ProcessResultVO<BbsAtclVO> error = ValidateUtil.validate(bindingResult);
    	if (error != null) return error;

        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId = vo.getBbsId();
        String parAtclId = vo.getUpAtclId();

        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        vo.setOrgId(orgId);
        vo.setRgtrId(userId);

        try {
            // 로그인 체크
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }

            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판

            if(!isAdmin) {
                bbsInfoVO.setUseYn("Y");
            }

            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 답글인 경우
            if(ValidationUtils.isNotEmpty(parAtclId)) {
                // 답글 쓰기권한 체크
                String answerWriteAuth = BbsAuthUtil.getAnswerAtclWriteAuth(request, bbsInfoVO);

                if(!"Y".equals(answerWriteAuth)) {
                    // 접근 권한이 없습니다.
                    throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
                }

                // 게시글 정보 조회
                BbsAtclVO bbsAtclVO = new BbsAtclVO();
                bbsAtclVO.setOrgId(orgId);
                bbsAtclVO.setBbsId(bbsId);
                bbsAtclVO.setAtclId(parAtclId);
                bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

                if(bbsAtclVO == null) {
                    // 게시글 정보를 찾을 수 없습니다.
                    throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
                }

                // 부모글 타이틀 세팅
                vo.setAtclTtl("RE : " + bbsAtclVO.getAtclTtl());
            } else {
                String getWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsInfoVO);

                if(!"Y".equals(getWriteAuth)) {
                    // 접근 권한이 없습니다.
                    throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
                }
            }

            vo.setBbsId(bbsInfoVO.getBbsId());
            vo.setCrsCreCd(null);

            bbsAtclService.insertBbsAtcl(vo);

            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch(MediopiaDefineException e) {
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

    /*****************************************************
     * 게시글 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editAtcl.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> editAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId = vo.getBbsId();
        String atclId = vo.getAtclId();

        String uploadFiles  = vo.getUploadFiles();
        String uploadPath   = vo.getUploadPath();

        vo.setOrgId(orgId);
        vo.setMdfrId(userId);

        try {
            // 로그인 체크
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }

            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판

            if(!isAdmin) {
                bbsInfoVO.setUseYn("Y");
            }

            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시글 정보 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 글수정 권한체크
            String atclEditAuth = BbsAuthUtil.getAtclEditAuth(request, bbsInfoVO, bbsAtclVO);

            if(!"Y".equals(atclEditAuth)) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            vo.setBbsId(bbsInfoVO.getBbsId());
            vo.setCrsCreCd(null);

            bbsAtclService.updateBbsAtcl(vo);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch(MediopiaDefineException e) {
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

    /*****************************************************
     * 게시글 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/removeAtcl.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> removeAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String bbsId = vo.getBbsId();
        String atclId = vo.getAtclId();
        String langCd = userCtx.getLangCd();

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        String userId = SessionInfo.getUserId(request);
        vo.setMdfrId(userId);

        try {
            // 로그인 체크
            if(ValidationUtils.isEmpty(userId)) {
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }

            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsVO bbsVO = new BbsVO();
            bbsVO.setOrgId(orgId);
            bbsVO.setBbsId(bbsId);
            bbsVO.setLangCd(langCd);
            bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

            if(bbsVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시글 정보 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO == null) {
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            String atclDeleteAuth = BbsAuthUtil.getAtclDeleteAuth(request, bbsVO, bbsAtclVO);

            if(!"Y".equals(atclDeleteAuth)) {
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            bbsAtclService.deleteBbsAtcl(vo);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("bbs.alert.success_delete")); // 정상적으로 삭제되었습니다.
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
     * 게시글 좋아요 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editGoodCnt.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> editGoodCnt(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId  = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId  = vo.getBbsId();
        String atclId = vo.getAtclId();

        vo.setRgtrId(userId);

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판

            if(!isAdmin) {
                bbsInfoVO.setUseYn("Y");
            }

            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 좋아요 사용여부 체크
            if(!"Y".equals(bbsInfoVO.getGoodUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 정보 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 좋아요 사용여부 체크
            if(!"Y".equals(bbsAtclVO.getGoodUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 삭제여부 체크
            if(!"N".equals(bbsAtclVO.getDelYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 전체 좋아요 수
            bbsAtclVO = bbsAtclService.updateBbsAtclGoodCnt(vo);

            resultVO.setReturnVO(bbsAtclVO);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 답글 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listAnswerAtcl.do")
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> listAnswerAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String userId = SessionInfo.getUserId(request);
        String bbsId = vo.getBbsId();
        String parAtclId = vo.getUpAtclId();

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        try {
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(parAtclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판

            if(!isAdmin) {
                bbsInfoVO.setUseYn("Y");
            }

            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 답글 사용여부 체크
            if(!"Y".equals(bbsInfoVO.getAnsrUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 정보 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(parAtclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 게시글 삭제여부 체크
            if(!"N".equals(bbsAtclVO.getDelYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 비밀글 본인여부 체크
            if(!isAdmin && "SECRET".equals(bbsInfoVO.getBbsId()) && !userId.equals(bbsAtclVO.getRgtrId())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            List<BbsAtclVO> list = bbsAtclService.listBbsAtclAnswer(vo);

            bbsAtclService.listBbsAtclAnswer(vo);
            resultVO.setReturnList(list);
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

    /** 게시판 END **/


    /** 댓글 START **/

    /*****************************************************
     * 댓글 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/cmntList.do")
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> cmntList(BbsCmntVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId = request.getParameter("bbsId");
        String atclId = vo.getAtclId();

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판

            if(!isAdmin) {
                bbsInfoVO.setUseYn("Y");
            }

            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시판 댓글 사용여부 체크
            /*
            if(!"Y".equals(bbsInfoVO.getCmntUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }
            */

            // 게시글 정보 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 게시글 댓글 사용여부 체크
            if(!"Y".equals(bbsAtclVO.getCmntUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 삭제여부 체크
            if(!"N".equals(bbsAtclVO.getDelYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 삭제된 댓글 제외 리스트 조회
            if(!isAdmin) {
                vo.setNoDeleteViewModeYn("Y");
            }
            vo.setViewerNo(userId);

            resultVO = bbsCmntService.listBbsCmntPagingWithAuth(request, bbsInfoVO, bbsAtclVO, vo);
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
     * 댓글 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/cmntInfo.do")
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> cmntInfo(BbsCmntVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = SessionInfo.getOrgId(request);
        String bbsId = request.getParameter("bbsId");
        String atclId = vo.getAtclId();
        String cmntId = vo.getCmntId();

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId) || ValidationUtils.isEmpty(cmntId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판

            if(!isAdmin) {
                bbsInfoVO.setUseYn("Y");
            }

            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시판 댓글 사용여부 체크
            /*
            if(!"Y".equals(bbsInfoVO.getCmntUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }
            */

            // 게시글 정보 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 게시글 댓글 사용여부 체크
            if(!"Y".equals(bbsAtclVO.getCmntUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 삭제여부 체크
            if(!"N".equals(bbsAtclVO.getDelYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            BbsCmntVO bbsCmntVO = bbsCmntService.selectBbsCmnt(vo);

            resultVO.setReturnVO(bbsCmntVO);
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
     * 댓글 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addCmnt.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> addCmnt(BbsCmntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String userId = SessionInfo.getUserId(request);
        String orgId = SessionInfo.getOrgId(request);
        String bbsId = request.getParameter("bbsId");
        String atclId = vo.getAtclId();
        String langCd = SessionInfo.getLocaleKey(request);

        String commentWriteAuth = "N";

        vo.setRgtrId(userId);

        try {
            // 로그인 체크
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }

            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setLangCd(langCd);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판

            if(!isAdmin) {
                bbsInfoVO.setUseYn("Y");
            }

            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시판 댓글 사용여부 체크
            if(!"Y".equals(bbsInfoVO.getCmntUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO.setLangCd(langCd);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO  == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 댓글 쓰기권한 체크
            commentWriteAuth = BbsAuthUtil.getCommentWriteAuth(request, bbsInfoVO, bbsAtclVO);

            if(!"Y".equals(commentWriteAuth)) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            bbsCmntService.insertBbsCmnt(vo);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
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
     * 댓글 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editCmnt.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> editCmnt(BbsCmntVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId = request.getParameter("bbsId");
        String atclId = vo.getAtclId();
        String cmntId = vo.getCmntId();
        String langCd = SessionInfo.getLocaleKey(request);

        String commentEditAuth = "N";

        vo.setMdfrId(userId);

        try {
            // 로그인 체크
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }

            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId) || ValidationUtils.isEmpty(cmntId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setLangCd(langCd);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판

            if(!isAdmin) {
                bbsInfoVO.setUseYn("Y");
            }

            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시글 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO.setLangCd(langCd);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO  == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            BbsCmntVO bbsCmntVO = new BbsCmntVO();
            bbsCmntVO.setAtclId(atclId);
            bbsCmntVO.setCmntId(cmntId);
            bbsCmntVO = bbsCmntService.selectBbsCmnt(bbsCmntVO);

            if(bbsCmntVO == null) {
                // 댓글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_comment"));
            }

            // 댓글 수정권한 체크
            commentEditAuth = BbsAuthUtil.getCommentEditAuth(request, bbsInfoVO, bbsAtclVO, bbsCmntVO);

            if(!"Y".equals(commentEditAuth)) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            bbsCmntService.updateBbsCmnt(vo);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
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
     * 댓글 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/removeCmnt.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> removeCmnt(BbsCmntVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId = request.getParameter("bbsId");
        String atclId = vo.getAtclId();
        String cmntId = vo.getCmntId();
        String langCd = SessionInfo.getLocaleKey(request);

        String commentDeleteAuth = "N";

        try {
            // 로그인 체크
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }

            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId) || ValidationUtils.isEmpty(cmntId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setLangCd(langCd);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시글 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO  == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            BbsCmntVO bbsCmntVO = new BbsCmntVO();
            bbsCmntVO.setAtclId(atclId);
            bbsCmntVO.setCmntId(cmntId);
            bbsCmntVO = bbsCmntService.selectBbsCmnt(bbsCmntVO);

            if(bbsCmntVO == null) {
                // 댓글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_comment"));
            }

            // 댓글 삭제권한 체크
            commentDeleteAuth = BbsAuthUtil.getCommentDeleteAuth(request, bbsInfoVO, bbsAtclVO, bbsCmntVO);

            if(!"Y".equals(commentDeleteAuth)) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            bbsCmntService.updateBbsCmntDelY(vo);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("bbs.alert.success_delete")); // 정상적으로 삭제되었습니다.
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

    /** 댓글 END **/

    /*****************************************************
     * 게시판 정보 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsInfo.do")
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> bbsInfo(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        String orgId  = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        try {
            vo.setUseYn("Y");

            BbsInfoVO bbsInfoVO = bbsInfoService.selectBbsInfo(vo);

            resultVO.setReturnVO(bbsInfoVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 게시글 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/atclInfo.do")
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> atclInfo(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        String orgId  = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        try {
            BbsAtclVO bbsAtclVO = bbsAtclService.selectBbsAtcl(vo);

            if(bbsAtclVO != null) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("BBS");
                fileVO.setFileBindDataSn(bbsAtclVO.getAtclId());
                ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);

                for(FileVO fvo : fileList.getReturnList()) {
                    fvo.setFileId(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")));
                }
                bbsAtclVO.setFileList(fileList.getReturnList());
            }

            resultVO.setReturnVO(bbsAtclVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 게시판 언어 정보 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoLangVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsInfoLang.do")
    @ResponseBody
    public ProcessResultVO<BbsInfoLangVO> bbsInfoLang(BbsInfoLangVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<BbsInfoLangVO> resultVO = new ProcessResultVO<>();

        String bbsId = vo.getBbsId();
        String langCd = vo.getLangCd();

        try {
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(langCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            BbsInfoLangVO bbsInfoLangVO = bbsInfoLangService.selectBbsInfoLang(vo);
            resultVO.setReturnVO(bbsInfoLangVO);
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





    /*
    TODO 새로 생성되거나 명칭 변경해서 작업하는 메쏘드는 여기 아래에......
    */






    /*****************************************************
     * 게시판 게시글 목록 조회 화면
     * @param vo
     * @param model
     * @param request
     * @return "bbs/bbs_atcl_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclListView.do")
    public String bbsAtclListView(BbsVO bbsVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

    	boolean isAdmin = BbsAuthUtil.isAdmin(request);

		if(ValidationUtils.isEmpty(bbsVO.getBbsId())) {
			throw new BadRequestUrlException(getMessage("common.system.error"));
		}

		bbsVO.setOrgId(userCtx.getOrgId());
		bbsVO.setLangCd(userCtx.getLangCd());
		bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

		if(bbsVO == null) { // 게시판 정보를 찾을 수 없습니다.
			throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
		}

		if(BbsAuthUtil.isStudent(request)) {
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.CONN_BBS, bbsVO.getBbsnm() + " 내용확인");
        }

        // 게시판정보에 파라메터값 재설정 (게시판정보 조회에서 초기화돼서 재설정)
        setEparamToVO(bbsVO);

        String atclWriteAuth = "N"; // 글쓰기 권한

        //atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsVO);

        // 파라메터 설정
        addEparam("bbsId", bbsVO.getBbsId());
        addEparam("bbsTycd", bbsVO.getBbsTycd());

        // 조회필터옵션 세팅
    	EgovMap filterOptions = bbsFacadeService.loadFilterOptions(userCtx);
    	model.addAttribute("filterOptions", filterOptions);

		model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/bbs_atcl_list_view";
    }


    /*****************************************************
     * 게시판게시글목록조회(Ajax)
     * @param bbsAtclVO
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclListAjax.do")
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> bbsAtclListAjax(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String langCd = SessionInfo.getLocaleKey(request);

        String bbsIds = request.getParameter("bbsIds"); // 게시판 id ',' 구분자
        String upAtclId = request.getParameter("upAtclId");

        try {
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setLangCd(langCd);

            // 게시판 id ',' 구분자로 들어온 경우
            if(ValidationUtils.isNotEmpty(bbsIds)) {
                List<String> bbsIdList = Arrays.asList(bbsIds.split(","));
                bbsAtclVO.setBbsIdList(bbsIdList);
                bbsAtclVO.setBbsId(null);
            }
            bbsAtclVO.setVwerId(userId);
            bbsAtclVO.setUpAtclId(upAtclId);
            bbsAtclVO.setAtclLv(1);

            resultVO = bbsAtclService.selectBbsAtclList(bbsAtclVO);
            resultVO.setResult(1);
            resultVO.setEparam(getEparam());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 게시글 보기
     * @param bbsAtclVO
     * @param model
     * @param request
     * @return "bbs/bbs_atcl_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclView.do")
    public String bbsAtclView(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String atclEditAuth = "Y";      // 글수정 권한
        String atclDeleteAuth  = "Y";   // 글삭제 권한
        String answerWriteAuth = "N";   // 답글쓰기 권한
        String commentWriteAuth = "N";  // 댓글쓰기 권한

        String bbsId = bbsAtclVO.getBbsId();
        String gubun = bbsAtclVO.getGubun();
        String atclId = bbsAtclVO.getAtclId();

        String orgId = userCtx.getOrgId();
        String langCd = userCtx.getLangCd();

        if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(bbsAtclVO)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsVO bbsVO = new BbsVO();
        bbsVO.setBbsId(bbsId);
        bbsVO.setOrgId(orgId);
		bbsVO.setLangCd(langCd);
		bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

        if(bbsVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        if(BbsAuthUtil.isStudent(request)) {
         // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.CONN_BBS, bbsVO.getBbsnm() + " 내용확인");
        }

        if(!isAdmin) {
            bbsAtclVO.setLockYn("N");
            bbsAtclVO.setLearnerViewModeYn("Y");
        }
        if(CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
            bbsAtclVO.setHaksaYear(bbsAtclVO.getHaksaYear());
            bbsAtclVO.setHaksaTerm(bbsAtclVO.getHaksaTerm());
        }

        // 게시글 조회
        bbsAtclVO.setAtclId(atclId);
        bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

        if(bbsAtclVO  == null) {
            // 게시글 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
        }

        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("atclEditAuth", atclEditAuth);
        model.addAttribute("atclDeleteAuth", atclDeleteAuth);
        model.addAttribute("answerWriteAuth", answerWriteAuth);
        model.addAttribute("commentWriteAuth", commentWriteAuth);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        String url = "bbs/bbs_atcl_view";

        // 수정화면
        if ("edit".equals(gubun)) {
        	// 첨부파일저장소 설정
            bbsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_BBS, bbsId));

        	url = "bbs/bbs_atcl_write";
        }

        return url;
    }

    /*****************************************************
     * 게시글 쓰기
     * @param BbsAtclVO
     * @param model
     * @param request
     * @return "bbs/bbs_atcl_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclWrite.do")
    public String bbsAtclWrite(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = userCtx.getOrgId();
        String langCd = userCtx.getLangCd();

        String bbsId = bbsAtclVO.getBbsId();

        String atclWriteAuth = "Y"; // 글쓰기 권한

        // 게시판 정보 조회
        BbsVO bbsVO = new BbsVO();
        bbsVO.setBbsId(bbsId);
        bbsVO.setOrgId(orgId);
		bbsVO.setLangCd(langCd);
		bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

        if(bbsVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        // 페이지/검색 파라메터 삭제
        delEparamPageSearch();

        // 첨부파일저장소 설정
        bbsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_BBS, bbsId));

        // 글쓰기 권한 체크
        //atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsVO);

        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/bbs_atcl_write";
    }


    /*****************************************************
     * 게시글 저장(등록)
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclSave.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> bbsAtclSave(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);
        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();

        String atclId = bbsAtclVO.getAtclId();
        String bbsId = bbsAtclVO.getBbsId();

        String uploadFiles = bbsAtclVO.getUploadFiles();
        String uploadPath = bbsAtclVO.getUploadPath();

        bbsAtclVO.setOrgId(orgId);
        bbsAtclVO.setAtclId(atclId);
        bbsAtclVO.setRgtrId(userId);
        bbsAtclVO.setMdfrId(userId);
        bbsAtclVO.setRgtrnm(SessionInfo.getUserNm(request));

        try {
            // 로그인 체크
            if(ValidationUtils.isEmpty(userId)) {
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }

            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId)) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsVO bbsVO = new BbsVO();
            bbsVO.setOrgId(orgId);
            bbsVO.setBbsId(bbsId);
            bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

            if(bbsVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            if ("edit".equals(bbsAtclVO.getGubun())) {
            	// 게시글 수정
                bbsAtclService.updateBbsAtcl(bbsAtclVO);
            }
            else {
                // 게시글 저장
                bbsAtclService.insertBbsAtcl(bbsAtclVO);
            }

            resultVO.setReturnVO(bbsAtclVO);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch(MediopiaDefineException e) {
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


    /*****************************************************
     * 게시글 수정 화면
     * @param bbsAtclVO
     * @param model
     * @param request
     * @return "bbs/bbs_atcl_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclEditWrite.do")
    public String bbsAtclEditWrite(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

    	boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();

        String bbsId = bbsAtclVO.getBbsId();
        String atclId = bbsAtclVO.getAtclId();

        String atclEditAuth = "N";      // 글수정 권한
        String atclDeleteAuth  = "N";   // 글삭제 권한
        String answerWriteAuth = "N";   // 답글쓰기 권한
        String commentWriteAuth = "N";  // 댓글쓰기 권한

        if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(bbsAtclVO)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsVO bbsVO = new BbsVO();
        bbsVO.setOrgId(orgId);
        bbsVO.setBbsId(bbsId);
        bbsVO.setLangCd(langCd);

        bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);
        if(bbsVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        if(BbsAuthUtil.isStudent(request)) {
         // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME, bbsVO.getBbsnm() + " 내용확인");
        }

        // 게시글 조회
        BbsAtclVO bbsSearchVO = new BbsAtclVO();
        bbsSearchVO.setAtclId(atclId);

        if(!isAdmin) {
        	bbsSearchVO.setLockYn("N");
            bbsSearchVO.setLearnerViewModeYn("Y");
        }
        if(CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
        	bbsSearchVO.setHaksaYear(bbsAtclVO.getHaksaYear());
            bbsSearchVO.setHaksaTerm(bbsAtclVO.getHaksaTerm());
        }

        bbsSearchVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

        if(bbsSearchVO  == null) {
            // 게시글 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
        }

        // 첨부파일저장소 설정
        bbsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_BBS, bbsId));

        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("atclEditAuth", atclEditAuth);
        model.addAttribute("atclDeleteAuth", atclDeleteAuth);
        model.addAttribute("answerWriteAuth", answerWriteAuth);
        model.addAttribute("commentWriteAuth", commentWriteAuth);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/bbs_atcl_view";
    }

    /*****************************************************
     * 게시판 게시글 답변 조회(Ajax)
     * @param bbsAtclVO
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclRspnsListAjax.do")
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> bbsAtclRspnsListAjax(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsIds = request.getParameter("bbsIds"); // 게시판 id ',' 구분자
        String langCd = SessionInfo.getLocaleKey(request);
        String upAtclId = request.getParameter("upAtclId");

        try {
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setLangCd(langCd);

            // 게시판 id ',' 구분자로 들어온 경우
            if(ValidationUtils.isNotEmpty(bbsIds)) {
                List<String> bbsIdList = Arrays.asList(bbsIds.split(","));
                bbsAtclVO.setBbsIdList(bbsIdList);
                bbsAtclVO.setBbsId(null);
            }
            bbsAtclVO.setCrsCreCd(null);
            bbsAtclVO.setVwerId(userId);
            bbsAtclVO.setUpAtclId(upAtclId);

            resultVO = bbsAtclService.selectBbsAtclRspnsList(bbsAtclVO);
            resultVO.setResult(1);
            resultVO.setEparam(getEparam());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 게시판 게시글 댓글 목록조회(Ajax)
     * @param bbsAtclVO
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclCmntListAjax.do")
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> bbsAtclCmntListAjax(BbsCmntVO bbsCmntVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        String orgId = userCtx.getOrgId();
        String atclId = request.getParameter("atclId");
        String userId = userCtx.getUserId();

        try {
        	bbsCmntVO.setOrgId(orgId);
        	bbsCmntVO.setAtclId(atclId);
        	bbsCmntVO.setUserId(userId);

            resultVO = bbsCmntService.selectBbsAtclCmntList(bbsCmntVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 메인 > 글로벌메뉴 > 과목공지
     * @param vo
     * @param model
     * @param request
     * @return "bbs/bbs_sbjct_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsSbjctListView.do")
    public String bbsSbjctListView(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

    	boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = userCtx.getOrgId();
        String langCd = userCtx.getLangCd();
        String bbsId = bbsAtclVO.getBbsId();
        String atclWriteAuth = "N"; // 글쓰기 권한

        if(ValidationUtils.isEmpty(bbsAtclVO.getBbsId())) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsVO bbsVO = new BbsVO();
        bbsVO.setOrgId(orgId);
        bbsVO.setBbsId(bbsId);
        bbsVO.setLangCd(langCd);
        bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

        if(bbsVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        if(BbsAuthUtil.isStudent(request)) {
           // 게시판 활동 로그 등록
           logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.CONN_BBS, bbsVO.getBbsnm() + " 내용확인");
        }

        // 글쓰기 권한 체크
        atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsAtclVO);

        // 파라메터 설정
        addEparam("bbsId", bbsAtclVO.getBbsId());
        addEparam("bbsTycd", bbsAtclVO.getBbsTycd());

        // 조회필터옵션 세팅
    	EgovMap filterOptions = bbsFacadeService.loadFilterOptions(userCtx);
    	model.addAttribute("filterOptions", filterOptions);

        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/bbs_sbjct_list_view";
    }

    /*****************************************************
     * 공지사항 > 과목공지 > 상세보기
     * @param bbsAtclVO
     * @param model
     * @param request
     * @return "bbs/bbs_lctr_qna_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsSbjctView.do")
    public String bbsSbjctView(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

    	boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = userCtx.getOrgId();
        String langCd = userCtx.getLangCd();
        String bbsId = bbsAtclVO.getBbsId();

        String atclEditAuth = "N";      // 글수정 권한
        String atclDeleteAuth  = "N";   // 글삭제 권한
        String answerWriteAuth = "N";   // 답글쓰기 권한
        String commentWriteAuth = "N";  // 댓글쓰기 권한

        if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(bbsAtclVO)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsVO bbsVO = new BbsVO();
        bbsVO.setOrgId(orgId);
        bbsVO.setBbsId(bbsId);
        bbsVO.setLangCd(langCd);
        bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

        if(bbsVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        if(BbsAuthUtil.isStudent(request)) {
            // 게시판 활동 로그 등록
        	logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.CONN_BBS, bbsVO.getBbsnm() + " 내용확인");
        }

        if(!isAdmin) {
        	bbsAtclVO.setLockYn("N");
        	bbsAtclVO.setLearnerViewModeYn("Y");
        }

        bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

        if(bbsAtclVO  == null) {
            // 게시글 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
        }

        // 임시작업용
        atclEditAuth = "Y";      // 글수정 권한
        atclDeleteAuth  = "Y";   // 글삭제 권한
        answerWriteAuth = "Y";   // 답글쓰기 권한
        commentWriteAuth = "Y";  // 댓글쓰기 권한

        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("atclEditAuth", atclEditAuth);
        model.addAttribute("atclDeleteAuth", atclDeleteAuth);
        model.addAttribute("answerWriteAuth", answerWriteAuth);
        model.addAttribute("commentWriteAuth", commentWriteAuth);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/bbs_sbjct_view";
    }

    /*****************************************************
     * 메인 > 글로벌메뉴 > 과목공지 등록
     * @param vo
     * @param model
     * @param request
     * @return "bbs/bbs_sbjct_regist_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsSbjctRegistView.do")
    public String bbsSbjctRegistView(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();

        String bbsId = bbsAtclVO.getBbsId();
        String mode = request.getParameter("mode");

        String atclWriteAuth = "N"; // 글쓰기 권한

        if(ValidationUtils.isEmpty(bbsAtclVO.getBbsId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsVO bbsVO = new BbsVO();
        bbsVO.setOrgId(orgId);
        bbsVO.setBbsId(bbsId);
        bbsVO.setLangCd(langCd);
        bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

        bbsAtclVO.setUserId(userId);

        if(bbsVO == null) {
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        if(BbsAuthUtil.isStudent(request)) {
            // 게시판 활동 로그 등록
        	logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.CONN_BBS, bbsVO.getBbsnm() + " 내용확인");
        }

        // 조회필터옵션 세팅
    	EgovMap filterOptions = bbsFacadeService.loadFilterOptions(userCtx);
    	model.addAttribute("filterOptions", filterOptions);

        model.addAttribute("mode", mode);
        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/bbs_sbjct_regist_view";
    }

    /*****************************************************
     * 과목공지 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclSbjctRegist.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> bbsAtclSbjctRegist(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

    	ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();

        String bbsId = bbsAtclVO.getBbsId();
		/*
		 * String atclId = bbsAtclVO.getAtclId(); String atclOptnId =
		 * bbsAtclVO.getAtclOptnId();
		 *
		 * bbsAtclVO.setAtclId(atclId); bbsAtclVO.setAtclOptnId(atclOptnId);
		 * bbsAtclVO.setRgtrId(userId);
		 */

        try {
            // 로그인 체크
            if(ValidationUtils.isEmpty(userId)) {
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }

            // 게시판 정보 조회
            BbsVO bbsVO = new BbsVO();
            bbsVO.setOrgId(orgId);
            bbsVO.setBbsId(bbsId);
            bbsVO.setLangCd(langCd);
            bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

            if(bbsVO == null) {
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            bbsAtclService.bbsAtclSbjctRegist(bbsAtclVO);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
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
     * 메인 > 글로벌메뉴 > 강의QNA
     * @param vo
     * @param model
     * @param request
     * @return "bbs/bbs_lctr_qna_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsLctrQnaListView.do")
    public String bbsLctrQnaListView(BbsVO bbsVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();
        String atclWriteAuth = "N"; // 글쓰기 권한

        if(ValidationUtils.isEmpty(bbsVO.getBbsId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        bbsVO.setOrgId(orgId);
        bbsVO.setUserId(userId);
        bbsVO.setLangCd(langCd);
        bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

        if(bbsVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        if(BbsAuthUtil.isStudent(request)) {
            // 게시판 활동 로그 등록
        	logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.CONN_BBS, bbsVO.getBbsnm() + " 내용확인");
        }

        // 파라메터 설정
        addEparam("bbsId", bbsVO.getBbsId());
        addEparam("bbsTycd", bbsVO.getBbsTycd());

        // 조회필터옵션 세팅
    	EgovMap filterOptions = bbsFacadeService.loadFilterOptions(userCtx);
    	model.addAttribute("filterOptions", filterOptions);

        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/bbs_lctr_qna_list_view";
    }

    /*****************************************************
     * 게시글 보기
     * @param bbsAtclVO
     * @param model
     * @param request
     * @return "bbs/bbs_lctr_qna_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsLctrQnaView.do")
    public String bbsLctrQnaView(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = userCtx.getOrgId();
        String langCd = userCtx.getLangCd();

        String bbsId = bbsAtclVO.getBbsId();
        String atclId = bbsAtclVO.getAtclId();

        String atclEditAuth = "N";      // 글수정 권한
        String atclDeleteAuth  = "N";   // 글삭제 권한
        String answerWriteAuth = "N";   // 답글쓰기 권한
        String commentWriteAuth = "N";  // 댓글쓰기 권한

        if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(bbsAtclVO)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsVO bbsVO = new BbsVO();
        bbsVO.setOrgId(orgId);
        bbsVO.setBbsId(bbsId);
        bbsVO.setLangCd(langCd);
        bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

        if(bbsVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        if(BbsAuthUtil.isStudent(request)) {
         // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME, bbsVO.getBbsnm() + " 내용확인");
        }

        bbsAtclVO.setAtclId(atclId);

        if(!isAdmin) {
        	bbsAtclVO.setLockYn("N");
        	bbsAtclVO.setLearnerViewModeYn("Y");
        }
        if(CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
        	bbsAtclVO.setHaksaYear(bbsAtclVO.getHaksaYear());
        	bbsAtclVO.setHaksaTerm(bbsAtclVO.getHaksaTerm());
        }
        bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

        if(bbsAtclVO  == null) {
            // 게시글 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
        }

        // 임시작업용
        atclEditAuth = "Y";      // 글수정 권한
        atclDeleteAuth  = "Y";   // 글삭제 권한
        answerWriteAuth = "Y";   // 답글쓰기 권한
        commentWriteAuth = "Y";  // 댓글쓰기 권한

        // 조회필터옵션 세팅
    	EgovMap filterOptions = bbsFacadeService.loadFilterOptions(userCtx);
    	model.addAttribute("filterOptions", filterOptions);

        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("atclEditAuth", atclEditAuth);
        model.addAttribute("atclDeleteAuth", atclDeleteAuth);
        model.addAttribute("answerWriteAuth", answerWriteAuth);
        model.addAttribute("commentWriteAuth", commentWriteAuth);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/bbs_lctr_qna_view";
    }

    /*****************************************************
     * 메인 > 글로벌 메뉴 > 1:1상담
     * @param vo
     * @param model
     * @param request
     * @return "bbs/bbs_dscsn_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsDscsnListView.do")
    public String bbsDscsnListView(BbsVO bbsVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        boolean isAdmin = BbsAuthUtil.isAdmin(request);
        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();
        String atclWriteAuth = "N"; // 글쓰기 권한

        if(ValidationUtils.isEmpty(bbsVO.getBbsId())) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        bbsVO.setOrgId(orgId);
        bbsVO.setLangCd(langCd);
        bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

        if(bbsVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        if(BbsAuthUtil.isStudent(request)) {
            // 게시판 활동 로그 등록
        	logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.CONN_BBS, bbsVO.getBbsnm() + " 내용확인");
        }

        // 파라메터 설정
        addEparam("bbsId", bbsVO.getBbsId());
        addEparam("bbsTycd", bbsVO.getBbsTycd());

        // 조회필터옵션 세팅
    	EgovMap filterOptions = bbsFacadeService.loadFilterOptions(userCtx);
    	model.addAttribute("filterOptions", filterOptions);

        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/bbs_dscsn_list_view";
    }


    /*****************************************************
     * 게시글 보기
     * @param bbsAtclVO
     * @param model
     * @param request
     * @return "bbs/bbs_lctr_qna_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsDscsnView.do")
    public String bbsDscsnView(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();

        String bbsId = bbsAtclVO.getBbsId();
        String atclId = bbsAtclVO.getAtclId();

        String atclEditAuth = "N";      // 글수정 권한
        String atclDeleteAuth  = "N";   // 글삭제 권한
        String answerWriteAuth = "N";   // 답글쓰기 권한
        String commentWriteAuth = "N";  // 댓글쓰기 권한

        if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(bbsAtclVO)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsVO bbsVO = new BbsVO();
        bbsVO.setOrgId(orgId);
        bbsVO.setBbsId(bbsId);
        bbsVO.setLangCd(langCd);
        bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

        if(bbsVO == null) {
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        if(BbsAuthUtil.isStudent(request)) {
         // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME, bbsVO.getBbsnm() + " 내용확인");
        }

        // 게시글 조회
        bbsAtclVO.setAtclId(atclId);

        if(!isAdmin) {
        	bbsAtclVO.setLockYn("N");
        	bbsAtclVO.setLearnerViewModeYn("Y");
        }

        bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

        if(bbsAtclVO  == null) {
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
        }

        atclEditAuth = "Y";      // 글수정 권한
        atclDeleteAuth  = "Y";   // 글삭제 권한
        answerWriteAuth = "Y";   // 답글쓰기 권한
        commentWriteAuth = "Y";  // 댓글쓰기 권한

        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("atclEditAuth", atclEditAuth);
        model.addAttribute("atclDeleteAuth", atclDeleteAuth);
        model.addAttribute("answerWriteAuth", answerWriteAuth);
        model.addAttribute("commentWriteAuth", commentWriteAuth);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/bbs_dscsn_view";
    }

    /*****************************************************
     * 답변 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclRspnsRegist.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> bbsAtclRspnsRegist(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

    	ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();

        String bbsId = bbsAtclVO.getBbsId();
        String atclId = bbsAtclVO.getAtclId();

        String commentWriteAuth = "N";

        try {
            // 로그인 체크
            if(ValidationUtils.isEmpty(userId)) {
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }

            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsVO bbsVO = new BbsVO();
            bbsVO.setOrgId(orgId);
            bbsVO.setBbsId(bbsId);
            bbsVO.setLangCd(langCd);
            bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

            if(bbsVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시판 댓글 사용여부 체크
			/*
			 * if(!"Y".equals(bbsInfoVO.getCmntUseYn())) { // 접근 권한이 없습니다. throw new
			 * BadRequestUrlException(getMessage("bbs.error.no_auth")); }
			 */

            // 댓글 쓰기권한 체크
			/*
			 * commentWriteAuth = BbsAuthUtil.getCommentWriteAuth(request, bbsInfoVO,
			 * bbsAtclVO);
			 *
			 * if(!"Y".equals(commentWriteAuth)) { // 접근 권한이 없습니다. throw new
			 * AccessDeniedException(getMessage("bbs.error.no_auth")); }
			 */
            bbsAtclVO.setUserId(userId);
            bbsAtclVO.setUpAtclId(atclId);
            bbsAtclVO.setAtclLv(2); // 댓글

            bbsAtclService.bbsAtclRspnsRegist(bbsAtclVO);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
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
     * 댓글 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclCmntRegist.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> bbsAtclCmntRegist(BbsCmntVO bbsCmntVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();

        String bbsId = request.getParameter("bbsId");
        String atclCmntCts = request.getParameter("atclCmntCts");
        String rgtrId = request.getParameter("userId");
        String atclId = request.getParameter("atclId");

        String upAtclCmntId = bbsCmntVO.getUpAtclCmntId();

        String commentWriteAuth = "N";

        bbsCmntVO.setRgtrId(userId);

        try {
            // 로그인 체크
            if(ValidationUtils.isEmpty(userId)) {
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }

            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsVO bbsVO = new BbsVO();
            bbsVO.setOrgId(orgId);
            bbsVO.setBbsId(bbsId);
            bbsVO.setLangCd(langCd);
            bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

            if(bbsVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시글 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO.setUserId(userId);
			bbsAtclVO.setLangCd(langCd);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);
            bbsAtclVO.setUserId(userId);
            if(bbsAtclVO  == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 댓글 쓰기권한 체크
			//commentWriteAuth = BbsAuthUtil.getCommentWriteAuth(request, bbsVO, bbsAtclVO);

			// 접근 권한이 없습니다.
			/*
			 * if(!"Y".equals(commentWriteAuth)) { throw new
			 * AccessDeniedException(getMessage("bbs.error.no_auth")); }
			 */

			bbsCmntVO.setRgtrId(userId);
			bbsCmntVO.setAtclCmntCts(atclCmntCts);
			bbsCmntVO.setUpAtclCmntId(upAtclCmntId);
			bbsCmntVO.setAtclId(atclId);

            bbsCmntService.bbsAtclCmntRegist(bbsCmntVO);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
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
     * 게시글 > 댓글 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclCmntDelete.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> bbsAtclCmntDelete(BbsCmntVO bbsCmntVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String atclCmntId = bbsCmntVO.getAtclCmntId();
        String bbsId = bbsCmntVO.getBbsId();

        String atclId = request.getParameter("atclId");

        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();

        try {
            // 로그인 체크
            if(ValidationUtils.isEmpty(userId)) {
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }

            // 파라미터 체크
            if (/* ValidationUtils.isEmpty(bbsId) || */ ValidationUtils.isEmpty(atclCmntId)) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsVO bbsVO = new BbsVO();
            bbsVO.setOrgId(orgId);
            bbsVO.setBbsId(bbsId);
            bbsVO.setLangCd(langCd);
            bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

            if(bbsVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시글 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO.setUserId(userId);
			bbsAtclVO.setLangCd(langCd);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            bbsAtclVO.setUserId(userId);
            if(bbsAtclVO  == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            //String atclDeleteAuth = BbsAuthUtil.getAtclDeleteAuth(request, bbsInfoVO, bbsAtclVO);

			/*
			 * if(!"Y".equals(atclDeleteAuth)) { // 접근 권한이 없습니다. throw new
			 * BadRequestUrlException(getMessage("bbs.error.no_auth")); }
			 */

            bbsCmntService.bbsAtclCmntDelete(bbsCmntVO);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("bbs.alert.success_delete")); // 정상적으로 삭제되었습니다.
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
     * 게시판 > 과목공지 > 상세
     * @param bbsAtclVO
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclSbjctDtlView.do")
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> bbsAtclSbjctDtlView(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        // 세션 및 기본 정보 추출
        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();

        try {
            // 1. 단일 조회를 위한 파라미터 세팅
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setLangCd(langCd);
            bbsAtclVO.setVwerId(userId); // 조회자 ID

            bbsAtclVO.setBbsIdList(null);

            // 2. 서비스 호출 (단일 VO 객체를 반환하는 로직)
            resultVO = bbsAtclService.selectBbsSbjctDtlView(bbsAtclVO);
            // 성공 결과 설정
            resultVO.setResult(1);

        } catch(Exception e) {
            LOGGER.error("게시글 상세 조회 중 오류 발생: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }

        return resultVO;
    }

    /*****************************************************
     * 과목공지 > 그룹 공지사항
     * @param bbsAtclVO
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclGrpNtcList.do")
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> bbsAtclGrpNtcList(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String langCd = SessionInfo.getLocaleKey(request);

        try {
            bbsAtclVO.setOrgId(orgId);
			resultVO = bbsAtclService.selectBbsAtclGrpNtcList(bbsAtclVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 과목공지 > 그룹 공지사항
     * @param bbsAtclVO
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclGrpNtcPopView.do")
    public String bbsAtclGrpNtcPopView(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();

        String bbsId = bbsAtclVO.getBbsId();
        String atclId = bbsAtclVO.getAtclId();

		/*
		 * bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);
		 */
        model.addAttribute("bbsAtclVO", bbsAtclVO);

        return "bbs/popup/bbs_sbjct_grp_ntc_popview";
    }
}

