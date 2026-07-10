package knou.lms.bbs.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

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
import knou.lms.bbs.service.BbsService;
import knou.lms.bbs.service.BbsViewService;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.bbs.vo.BbsCmntVO;
import knou.lms.bbs.vo.BbsInfoLangVO;
import knou.lms.bbs.vo.BbsVO;
import knou.lms.bbs.vo.BbsViewVO;
import knou.lms.bbs.web.util.BbsAuthUtil;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.CurrentUser;
import knou.lms.user.service.UsrDeptCdService;

@Controller
@RequestMapping(value = "/bbs/bbsHome")
public class BbsHomeController extends ControllerBase {

	private static final Logger log = LoggerFactory.getLogger(BbsHomeController.class);
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

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Resource(name = "logUserConnService")
	private LogUserConnService logUserConnService;

	@Resource(name = "sysFileService")
	private SysFileService sysFileService;

	@Resource(name = "logLessonActnHstyService")
	private LogLessonActnHstyService logLessonActnHstyService;

	@Resource(name = "orgCodeService")
	private OrgCodeService orgCodeService;

	@Resource(name = "bbsViewService")
	private BbsViewService bbsViewService;

	@Resource(name = "semesterService")
	private SemesterService semesterService;

	@Resource(name = "orgInfoService")
	private OrgInfoService orgInfoService;

	@Resource(name = "usrDeptCdService")
	private UsrDeptCdService usrDeptCdService;

	@Resource(name = "sbjctService")
	private SbjctService sbjctService;

	@Resource(name = "bbsFacadeService")
	private BbsFacadeService bbsFacadeService;

	@Resource(name = "bbsService")
	private BbsService bbsService;

	// 게시판 유형 코드 상수
	private static final String BBS_TYPE_NTC  = "NTC";
	private static final String BBS_TYPE_DATARM  = "DATARM";
	private static final String BBS_TYPE_QNA  = "QNA";
	private static final String BBS_TYPE_1ON1 = "1ON1";
	private static final String BBS_REF_TYPE_ORG = "ORG";

	/** 게시판 START **/

	/*****************************************************
	 * 게시글 목록 이동
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return "bbs/atcl_list"
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/atclList.do")
	public String atclListForm(BbsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
		boolean isAdmin = BbsAuthUtil.isAdmin(request);
		String orgId = SessionInfo.getOrgId(request);
		String bbsId = vo.getBbsId();
		String langCd = SessionInfo.getLocaleKey(request);
		String atclWriteAuth = "N"; // 글쓰기 권한

		if (ValidationUtils.isEmpty(bbsId)) {
			// 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게
			// 문의하세요.
			throw new BadRequestUrlException(getMessage("common.system.error"));
		}

		// 게시판 정보 조회
		BbsVO bbsVO = new BbsVO();
		bbsVO.setOrgId(orgId);
		bbsVO.setBbsId(bbsId);
		bbsVO.setLangCd(langCd);
		bbsVO.setSysUseYn("Y"); // 시스템 게시판

		if (!isAdmin) {
			bbsVO.setUseYn("Y");
		}

		bbsVO = bbsInfoService.selectBbsInfo(bbsVO);

		if (bbsVO == null) {
			// 게시판 정보를 찾을 수 없습니다.
			throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
		}

		if (BbsAuthUtil.isStudent(request)) {
			// 강의실 활동 로그 등록
			logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME,
					StringUtil.nvl(bbsVO.getBbsnm()) + " 목록");
		}

		// 글쓰기 권한 체크
		atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsVO);

		////////////////////////////
		addEncParam("bbsId", bbsVO.getBbsId());
		addEncParam("bbsTycd", bbsVO.getBbsTycd());

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

		model.addAttribute("bbsVO", bbsVO);
		model.addAttribute("atclWriteAuth", atclWriteAuth);
		model.addAttribute("vo", vo);
		model.addAttribute("templateUrl", TEMPLATE_URL);

		return "bbs/atcl_list";
	}

	/*****************************************************
	 * TODO 게시글 보기 이동 (구) -- 삭제 예정
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return "bbs/atcl_view"
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/Form/atclView.do")
	public String atclView(BbsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
		// 사용자 접속상태 저장
		// logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

		boolean isAdmin = BbsAuthUtil.isAdmin(request);
		boolean isVirtualLogin = SessionInfo.isVirtualLogin(request);

		String orgId = SessionInfo.getOrgId(request);
		String userId = SessionInfo.getUserRprsId(request);
		String bbsId = vo.getBbsId();
		String atclId = request.getParameter("atclId");
		String langCd = SessionInfo.getLocaleKey(request);

		String atclEditAuth = "N"; // 글수정 권한
		String atclDeleteAuth = "N"; // 글삭제 권한
		String answerWriteAuth = "N"; // 답글쓰기 권한
		String commentWriteAuth = "N"; // 댓글쓰기 권한

		if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
			// 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게
			// 문의하세요.
			throw new BadRequestUrlException(getMessage("common.system.error"));
		}

		// 게시판 정보 조회
		BbsVO bbsVO = new BbsVO();
		bbsVO.setOrgId(orgId);
		bbsVO.setBbsId(bbsId);
		bbsVO.setLangCd(langCd);
		bbsVO.setSysUseYn("Y"); // 시스템 게시판

		if (!isAdmin) {
			bbsVO.setUseYn("Y");
		}

		bbsVO = bbsInfoService.selectBbsInfo(bbsVO);

		if (bbsVO == null) {
			// 게시판 정보를 찾을 수 없습니다.
			throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
		}

		if (BbsAuthUtil.isStudent(request)) {
			// 강의실 활동 로그 등록
			logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.ACTN_HSTY_COURSE_HOME,
					bbsVO.getBbsnm() + " 내용확인");
		}

		// 게시글 조회
		BbsAtclVO bbsAtclVO = new BbsAtclVO();
		bbsAtclVO.setOrgId(orgId);
		bbsAtclVO.setBbsId(bbsId);
		bbsAtclVO.setAtclId(atclId);
		bbsAtclVO.setVwerId(userId); // 조회자
		bbsAtclVO.setLangCd(langCd);

		if (!isAdmin) {
			bbsAtclVO.setLockYn("N");
			bbsAtclVO.setLearnerViewModeYn("Y");
		}
		if (CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
			bbsAtclVO.setHaksaYear(vo.getHaksaYear());
			bbsAtclVO.setHaksaTerm(vo.getHaksaTerm());
		}
		bbsAtclVO = bbsAtclService.viewBbsAtcl(bbsAtclVO);

		if (bbsAtclVO == null) {
			// 게시글 정보를 찾을 수 없습니다.
			throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
		}

		// 조회 정보 등록
		if (!isVirtualLogin) {
			try {
				BbsViewVO bbsViewVO = new BbsViewVO();
				bbsViewVO.setOrgId(orgId);
				bbsViewVO.setAtclId(atclId);
				bbsViewVO.setUserId(userId);
				BbsViewVO bbsViewInfo = bbsViewService.selectBbsView(bbsViewVO);

				if (bbsViewInfo == null) {
					bbsViewService.insertBbsView(bbsViewVO);
				} else {
					bbsViewService.updateBbsView(bbsViewVO);
				}

				int cnt = bbsViewService.countBbsView(bbsViewVO);

				BbsAtclVO updateHitVO = new BbsAtclVO();
				updateHitVO.setAtclId(atclId);
				updateHitVO.setInqCnt(cnt);
				// bbsAtclService.updateBbsAtclHits(updateHitVO);

				// 답글이 있는경우 답글 viewer 세팅
				int answerAtclCnt = bbsAtclVO.getAnswerAtclCnt();

				if (answerAtclCnt > 0) {
					BbsAtclVO bbsAtclVO2 = new BbsAtclVO();
					bbsAtclVO2.setOrgId(orgId);
					bbsAtclVO2.setBbsId(vo.getBbsId());
					bbsAtclVO2.setUpAtclId(bbsAtclVO.getAtclId());

					List<BbsAtclVO> listAnswerAtcl = bbsAtclService.listBbsAtclAnswer(bbsAtclVO2);

					for (BbsAtclVO answerAtclVO : listAnswerAtcl) {
						bbsViewVO = new BbsViewVO();
						bbsViewVO.setAtclId(answerAtclVO.getAtclId());
						bbsViewVO.setUserId(userId);

						bbsViewInfo = bbsViewService.selectBbsView(bbsViewVO);

						if (bbsViewInfo == null) {
							bbsViewService.insertBbsView(bbsViewVO);
						} else {
							bbsViewService.updateBbsView(bbsViewVO);
						}
					}
				}
			} catch (Exception e) {
				log.debug("e: ", e);
			}
		}

		// 비공개글 접근 체크
		if (!isAdmin && !("N".equals(bbsAtclVO.getLockYn()) || userId.equals(bbsAtclVO.getRgtrId()))) {
			// 접근 권한이 없습니다.
			throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
		}

		// 글수정, 삭제, 답글, 댓글쓰기 권한체크
		atclEditAuth = BbsAuthUtil.getAtclEditAuth(request, bbsVO, bbsAtclVO);
		// atclDeleteAuth = BbsAuthUtil.getAtclDeleteAuth(request, bbsVO, bbsAtclVO);
		answerWriteAuth = BbsAuthUtil.getAnswerAtclWriteAuth(request, bbsVO);
		commentWriteAuth = BbsAuthUtil.getCommentWriteAuth(request, bbsVO, bbsAtclVO);

		model.addAttribute("bbsVO", bbsVO);
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
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return "bbs/atcl_write"
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/Form/atclWrite.do")
	public String atclWrite(BbsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
		// 사용자 접속상태 저장
		// logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

		boolean isAdmin = BbsAuthUtil.isAdmin(request);

		String orgId = SessionInfo.getOrgId(request);
		String bbsId = vo.getBbsId();
		String atclWriteAuth = "Y"; // 글쓰기 권한

		String langCd = SessionInfo.getLocaleKey(request);
		vo.setLangCd(langCd);

		// 게시판 정보 조회
		BbsVO bbsVO = new BbsVO();
		bbsVO.setOrgId(orgId);
		bbsVO.setBbsId(bbsId);
		bbsVO.setLangCd(langCd);
		bbsVO.setSysUseYn("Y"); // 시스템 게시판

		if (!isAdmin) {
			bbsVO.setUseYn("Y");
		}

		bbsVO = bbsInfoService.selectBbsInfo(bbsVO);

		if (bbsVO == null) {
			// 게시판 정보를 찾을 수 없습니다.
			throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
		}

		// 글쓰기 권한 체크
		atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsVO);

		TermVO termVO = new TermVO();
		termVO.setOrgId(SessionInfo.getOrgId(request));
		termVO = termService.selectCurrentTerm(termVO);
		model.addAttribute("termVO", termVO);
		model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
		model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
		model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

		model.addAttribute("bbsVO", bbsVO);
		model.addAttribute("atclWriteAuth", atclWriteAuth);
		model.addAttribute("vo", vo);
		model.addAttribute("templateUrl", TEMPLATE_URL);

		return "bbs/atcl_write";
	}

	/*****************************************************
	 * 게시글 수정 이동
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return "bbs/home/atcl_write"
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/Form/atclEdit.do")
	public String atclEdit(BbsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
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
		BbsVO bbsVO = new BbsVO();
		bbsVO.setOrgId(orgId);
		bbsVO.setBbsId(bbsId);
		bbsVO.setLangCd(langCd);
		bbsVO.setSysUseYn("Y"); // 시스템 게시판

		if (!isAdmin) {
			bbsVO.setUseYn("Y");
		}

		bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

		if (bbsVO == null) {
			// 게시판 정보를 찾을 수 없습니다.
			throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
		}

		// 게시글 조회
		BbsAtclVO bbsAtclVO = new BbsAtclVO();
		bbsAtclVO.setOrgId(orgId);
		bbsAtclVO.setBbsId(bbsId);
		bbsAtclVO.setAtclId(atclId);
		bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

		if (bbsAtclVO == null) {
			// 게시글 정보를 찾을 수 없습니다.
			throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
		}

		atclEditAuth = BbsAuthUtil.getAtclEditAuth(request, bbsVO, bbsAtclVO);

		// 첨부 파일 조회
		if (bbsAtclVO.getAtchFileCnt() > 0) {
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

		model.addAttribute("bbsVO", bbsVO);
		model.addAttribute("bbsAtclVO", bbsAtclVO);
		model.addAttribute("atclEditAuth", atclEditAuth);
		model.addAttribute("vo", vo);
		model.addAttribute("templateUrl", TEMPLATE_URL);

		return "bbs/atcl_write";
	}

	/*****************************************************
	 * 게시글 목록 조회 (구) --> bbsAtclList 로 변경
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/listAtcl.do")
	@ResponseBody
	public ProcessResultVO<BbsAtclVO> listAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request)
			throws Exception {
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
			if (ValidationUtils.isNotEmpty(bbsIds)) {
				List<String> bbsIdList = Arrays.asList(bbsIds.split(","));
				vo.setBbsIdList(bbsIdList);
				vo.setBbsId(null);
			}
			vo.setCrsCreCd(null);
			vo.setVwerId(userId);

			if (isAdmin) {
				vo.setUnivGbn(null);
				vo.setUnivGbnList(null);
			} else {
				vo.setLockYn("N");
				vo.setLearnerViewModeYn("Y");

				List<String> univGbnList = new ArrayList<>();
				univGbnList.add("ALL");

				if (ValidationUtils.isNotEmpty(univGbns)) {
					for (String univGbn : univGbns.split(",")) {
						if (!"".equals(StringUtil.nvl(univGbn))) {
							univGbnList.add(univGbn);
						}
					}
				}

				vo.setUnivGbnList(univGbnList.toArray(new String[univGbnList.size()]));
			}

			resultVO = bbsAtclService.listBbsAtclPaging(vo);
			resultVO.setResult(1);
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/*****************************************************
	 * 게시글 등록
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/addAtcl.do", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResultVO<BbsAtclVO> addAtcl(@Valid BbsAtclVO vo, BindingResult bindingResult, ModelMap model,
			HttpServletRequest request) throws Exception {
		// 사용자 접속상태 저장
		// logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

		ProcessResultVO<BbsAtclVO> error = ValidateUtil.validate(bindingResult);
		if (error != null)
			return error;

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
			if (ValidationUtils.isEmpty(userId)) {
				// 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
				throw new SessionBrokenException(getMessage("common.system.no_auth"));
			}

			// 파라미터 체크
			if (ValidationUtils.isEmpty(bbsId)) {
				// 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게
				// 문의하세요.
				throw new BadRequestUrlException(getMessage("common.system.error"));
			}

			// 게시판 정보 조회
			BbsVO bbsVO = new BbsVO();
			bbsVO.setOrgId(orgId);
			bbsVO.setBbsId(bbsId);
			bbsVO.setSysUseYn("Y"); // 시스템 게시판

			if (!isAdmin) {
				bbsVO.setUseYn("Y");
			}

			bbsVO = bbsInfoService.selectBbsInfo(bbsVO);

			if (bbsVO == null) {
				// 게시판 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
			}

			// 답글인 경우
			if (ValidationUtils.isNotEmpty(parAtclId)) {
				// 답글 쓰기권한 체크
				String answerWriteAuth = BbsAuthUtil.getAnswerAtclWriteAuth(request, bbsVO);

				if (!"Y".equals(answerWriteAuth)) {
					// 접근 권한이 없습니다.
					throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
				}

				// 게시글 정보 조회
				BbsAtclVO bbsAtclVO = new BbsAtclVO();
				bbsAtclVO.setOrgId(orgId);
				bbsAtclVO.setBbsId(bbsId);
				bbsAtclVO.setAtclId(parAtclId);
				bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

				if (bbsAtclVO == null) {
					// 게시글 정보를 찾을 수 없습니다.
					throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
				}

				// 부모글 타이틀 세팅
				vo.setAtclTtl("RE : " + bbsAtclVO.getAtclTtl());
			} else {
				String getWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsVO);

				if (!"Y".equals(getWriteAuth)) {
					// 접근 권한이 없습니다.
					throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
				}
			}

			vo.setBbsId(bbsVO.getBbsId());
			vo.setCrsCreCd(null);

			bbsAtclService.insertBbsAtcl(vo);

			resultVO.setReturnVO(vo);
			resultVO.setResult(1);
			resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
		} catch (MediopiaDefineException e) {
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());

			if (ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
				FileUtil.delUploadFileList(uploadFiles, uploadPath);
			}
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!

			if (ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
				FileUtil.delUploadFileList(uploadFiles, uploadPath);
			}
		}
		return resultVO;
	}

	/*****************************************************
	 * 게시글 수정
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/editAtcl.do", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResultVO<BbsAtclVO> editAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request)
			throws Exception {
		// 사용자 접속상태 저장
		// logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

		ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

		boolean isAdmin = BbsAuthUtil.isAdmin(request);

		String orgId = SessionInfo.getOrgId(request);
		String userId = SessionInfo.getUserId(request);
		String bbsId = vo.getBbsId();
		String atclId = vo.getAtclId();

		String uploadFiles = vo.getUploadFiles();
		String uploadPath = vo.getUploadPath();

		vo.setOrgId(orgId);
		vo.setMdfrId(userId);

		try {
			// 로그인 체크
			if (ValidationUtils.isEmpty(userId)) {
				// 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
				throw new SessionBrokenException(getMessage("common.system.no_auth"));
			}

			// 파라미터 체크
			if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
				// 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게
				// 문의하세요.
				throw new BadRequestUrlException(getMessage("common.system.error"));
			}

			// 게시판 정보 조회
			BbsVO bbsVO = new BbsVO();
			bbsVO.setOrgId(orgId);
			bbsVO.setBbsId(bbsId);
			bbsVO.setSysUseYn("Y"); // 시스템 게시판

			if (!isAdmin) {
				bbsVO.setUseYn("Y");
			}

			bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

			if (bbsVO == null) {
				// 게시판 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
			}

			// 게시글 정보 조회
			BbsAtclVO bbsAtclVO = new BbsAtclVO();
			bbsAtclVO.setOrgId(orgId);
			bbsAtclVO.setBbsId(bbsId);
			bbsAtclVO.setAtclId(atclId);
			bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

			if (bbsAtclVO == null) {
				// 게시글 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
			}

			// 글수정 권한체크
			String atclEditAuth = BbsAuthUtil.getAtclEditAuth(request, bbsVO, bbsAtclVO);

			if (!"Y".equals(atclEditAuth)) {
				// 접근 권한이 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
			}

			vo.setBbsId(bbsVO.getBbsId());
			vo.setCrsCreCd(null);

			bbsAtclService.updateBbsAtcl(vo);

			resultVO.setResult(1);
			resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
		} catch (MediopiaDefineException e) {
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());

			if (ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
				FileUtil.delUploadFileList(uploadFiles, uploadPath);
			}
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!

			if (ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
				FileUtil.delUploadFileList(uploadFiles, uploadPath);
			}
		}

		return resultVO;
	}

	/*****************************************************
	 * 게시글 삭제
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/removeAtcl.do", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResultVO<BbsAtclVO> removeAtcl(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx, ModelMap model,
			HttpServletRequest request) throws Exception {

		ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

		boolean isAdmin = BbsAuthUtil.isAdmin(request);

		String bbsId = bbsAtclVO.getBbsId();
		String atclId = bbsAtclVO.getAtclId();
		String bbsTycd = bbsAtclVO.getBbsTycd();
		String langCd = userCtx.getLangCd();

		String orgId = SessionInfo.getOrgId(request);
		bbsAtclVO.setOrgId(orgId);

		String userId = SessionInfo.getUserId(request);
		bbsAtclVO.setMdfrId(userId);

		try {
			// 로그인 체크
			if (ValidationUtils.isEmpty(userId)) {
				throw new SessionBrokenException(getMessage("common.system.no_auth"));
			}

			// 파라미터 체크
			if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
				throw new BadRequestUrlException(getMessage("common.system.error"));
			}

			// 게시판 정보 조회
			BbsVO bbsVO = new BbsVO();
			bbsVO.setOrgId(orgId);
			bbsVO.setBbsId(bbsId);
			bbsVO.setBbsTycd(bbsTycd);
			bbsVO.setLangCd(langCd);
			bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

			if (bbsVO == null) {
				// 게시판 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
			}

			// 게시글 정보 조회
			bbsAtclVO.setOrgId(orgId);
			bbsAtclVO.setBbsId(bbsId);
			bbsAtclVO.setAtclId(atclId);
			bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

			if (bbsAtclVO == null) {
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
			}

			String atclDeleteAuth = BbsAuthUtil.getAtclDeleteAuth(request, bbsVO, bbsAtclVO);

			if (!"Y".equals(atclDeleteAuth)) {
				throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
			}

			bbsAtclService.deleteBbsAtcl(bbsAtclVO);

			resultVO.setResult(1);
			resultVO.setMessage(getMessage("bbs.alert.success_delete")); // 정상적으로 삭제되었습니다.
		} catch (MediopiaDefineException e) {
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/*****************************************************
	 * 게시글 좋아요 수정
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/editGoodCnt.do", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResultVO<BbsAtclVO> editGoodCnt(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request)
			throws Exception {
		ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

		boolean isAdmin = BbsAuthUtil.isAdmin(request);

		String orgId = SessionInfo.getOrgId(request);
		String userId = SessionInfo.getUserId(request);
		String bbsId = bbsAtclVO.getBbsId();
		String atclId = bbsAtclVO.getAtclId();

		bbsAtclVO.setRgtrId(userId);

		try {
			// 파라미터 체크
			if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
				// 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게
				// 문의하세요.
				throw new BadRequestUrlException(getMessage("common.system.error"));
			}

			// 게시판 정보 조회
			BbsVO bbsVO = new BbsVO();
			bbsVO.setOrgId(orgId);
			bbsVO.setBbsId(bbsId);
			bbsVO.setSysUseYn("Y"); // 시스템 게시판

			if (!isAdmin) {
				bbsVO.setUseYn("Y");
			}

			bbsVO = bbsInfoService.selectBbsInfo(bbsVO);

			if (bbsVO == null) {
				// 게시판 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
			}

			// 좋아요 사용여부 체크
			if (!"Y".equals(bbsVO.getGoodUseYn())) {
				// 접근 권한이 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
			}

			// 게시글 정보 조회
			bbsAtclVO.setOrgId(orgId);
			bbsAtclVO.setBbsId(bbsId);
			bbsAtclVO.setAtclId(atclId);
			bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

			if (bbsAtclVO == null) {
				// 게시글 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
			}

			// 좋아요 사용여부 체크
			if (!"Y".equals(bbsAtclVO.getGoodUseYn())) {
				// 접근 권한이 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
			}

			// 게시글 삭제여부 체크
			if (!"N".equals(bbsAtclVO.getDelYn())) {
				// 접근 권한이 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
			}

			// 전체 좋아요 수
			bbsAtclVO = bbsAtclService.updateBbsAtclGoodCnt(bbsAtclVO);

			resultVO.setReturnVO(bbsAtclVO);
			resultVO.setResult(1);
			resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/*****************************************************
	 * 답글 목록 조회
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/listAnswerAtcl.do")
	@ResponseBody
	public ProcessResultVO<BbsAtclVO> listAnswerAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request)
			throws Exception {

		ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

		boolean isAdmin = BbsAuthUtil.isAdmin(request);

		String userId = SessionInfo.getUserId(request);
		String bbsId = vo.getBbsId();
		String parAtclId = vo.getUpAtclId();

		String orgId = SessionInfo.getOrgId(request);
		vo.setOrgId(orgId);

		try {
			if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(parAtclId)) {
				// 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게
				// 문의하세요.
				throw new BadRequestUrlException(getMessage("common.system.error"));
			}

			// 게시판 정보 조회
			BbsVO bbsVO = new BbsVO();
			bbsVO.setOrgId(orgId);
			bbsVO.setBbsId(bbsId);
			bbsVO.setSysUseYn("Y"); // 시스템 게시판

			if (!isAdmin) {
				bbsVO.setUseYn("Y");
			}

			bbsVO = bbsInfoService.selectBbsInfo(bbsVO);

			if (bbsVO == null) {
				// 게시판 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
			}

			// 답글 사용여부 체크
			if (!"Y".equals(bbsVO.getAnsrUseYn())) {
				// 접근 권한이 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
			}

			// 게시글 정보 조회
			BbsAtclVO bbsAtclVO = new BbsAtclVO();
			bbsAtclVO.setOrgId(orgId);
			bbsAtclVO.setBbsId(bbsId);
			bbsAtclVO.setAtclId(parAtclId);
			bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

			if (bbsAtclVO == null) {
				// 게시글 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
			}

			// 게시글 삭제여부 체크
			if (!"N".equals(bbsAtclVO.getDelYn())) {
				// 접근 권한이 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
			}

			// 비밀글 본인여부 체크
			if (!isAdmin && "SECRET".equals(bbsVO.getBbsId()) && !userId.equals(bbsAtclVO.getRgtrId())) {
				// 접근 권한이 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
			}

			List<BbsAtclVO> list = bbsAtclService.listBbsAtclAnswer(vo);

			bbsAtclService.listBbsAtclAnswer(vo);
			resultVO.setReturnList(list);
			resultVO.setResult(1);
		} catch (MediopiaDefineException e) {
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/** 게시판 END **/

	/** 댓글 START **/

	/*****************************************************
	 * 댓글 목록 조회
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsCmntVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/cmntList.do")
	@ResponseBody
	public ProcessResultVO<BbsCmntVO> cmntList(BbsCmntVO vo, ModelMap model, HttpServletRequest request)
			throws Exception {

		ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

		boolean isAdmin = BbsAuthUtil.isAdmin(request);

		String orgId = SessionInfo.getOrgId(request);
		String userId = SessionInfo.getUserId(request);
		String bbsId = request.getParameter("bbsId");
		String atclId = vo.getAtclId();

		try {
			// 파라미터 체크
			if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
				// 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게
				// 문의하세요.
				throw new BadRequestUrlException(getMessage("common.system.error"));
			}

			// 게시판 정보 조회
			BbsVO bbsVO = new BbsVO();
			bbsVO.setOrgId(orgId);
			bbsVO.setBbsId(bbsId);
			bbsVO.setSysUseYn("Y"); // 시스템 게시판

			if (!isAdmin) {
				bbsVO.setUseYn("Y");
			}

			bbsVO = bbsInfoService.selectBbsInfo(bbsVO);

			if (bbsVO == null) {
				// 게시판 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
			}

			// 게시판 댓글 사용여부 체크
			/*
			 * if(!"Y".equals(bbsVO.getCmntUseYn())) { // 접근 권한이 없습니다. throw new
			 * BadRequestUrlException(getMessage("bbs.error.no_auth")); }
			 */

			// 게시글 정보 조회
			BbsAtclVO bbsAtclVO = new BbsAtclVO();
			bbsAtclVO.setOrgId(orgId);
			bbsAtclVO.setBbsId(bbsId);
			bbsAtclVO.setAtclId(atclId);
			bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

			if (bbsAtclVO == null) {
				// 게시글 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
			}

			// 게시글 댓글 사용여부 체크
			if (!"Y".equals(bbsAtclVO.getCmntUseYn())) {
				// 접근 권한이 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
			}

			// 게시글 삭제여부 체크
			if (!"N".equals(bbsAtclVO.getDelYn())) {
				// 접근 권한이 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
			}

			// 삭제된 댓글 제외 리스트 조회
			if (!isAdmin) {
				vo.setNoDeleteViewModeYn("Y");
			}
			vo.setViewerNo(userId);

			resultVO = bbsCmntService.listBbsCmntPagingWithAuth(request, bbsVO, bbsAtclVO, vo);
			resultVO.setResult(1);
		} catch (MediopiaDefineException e) {
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/*****************************************************
	 * 댓글 조회
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsCmntVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/cmntInfo.do")
	@ResponseBody
	public ProcessResultVO<BbsCmntVO> cmntInfo(BbsCmntVO vo, ModelMap model, HttpServletRequest request)
			throws Exception {

		ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

		boolean isAdmin = BbsAuthUtil.isAdmin(request);

		String orgId = SessionInfo.getOrgId(request);
		String bbsId = request.getParameter("bbsId");
		String atclId = vo.getAtclId();
		String cmntId = vo.getCmntId();

		try {
			// 파라미터 체크
			if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId) || ValidationUtils.isEmpty(cmntId)) {
				// 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게
				// 문의하세요.
				throw new BadRequestUrlException(getMessage("common.system.error"));
			}

			// 게시판 정보 조회
			BbsVO bbsVO = new BbsVO();
			bbsVO.setOrgId(orgId);
			bbsVO.setBbsId(bbsId);
			bbsVO.setSysUseYn("Y"); // 시스템 게시판

			if (!isAdmin) {
				bbsVO.setUseYn("Y");
			}

			bbsVO = bbsInfoService.selectBbsInfo(bbsVO);

			if (bbsVO == null) {
				// 게시판 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
			}

			// 게시판 댓글 사용여부 체크
			/*
			 * if(!"Y".equals(bbsVO.getCmntUseYn())) { // 접근 권한이 없습니다. throw new
			 * BadRequestUrlException(getMessage("bbs.error.no_auth")); }
			 */

			// 게시글 정보 조회
			BbsAtclVO bbsAtclVO = new BbsAtclVO();
			bbsAtclVO.setOrgId(orgId);
			bbsAtclVO.setBbsId(bbsId);
			bbsAtclVO.setAtclId(atclId);
			bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

			if (bbsAtclVO == null) {
				// 게시글 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
			}

			// 게시글 댓글 사용여부 체크
			if (!"Y".equals(bbsAtclVO.getCmntUseYn())) {
				// 접근 권한이 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
			}

			// 게시글 삭제여부 체크
			if (!"N".equals(bbsAtclVO.getDelYn())) {
				// 접근 권한이 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
			}

			BbsCmntVO bbsCmntVO = bbsCmntService.selectBbsCmnt(vo);

			resultVO.setReturnVO(bbsCmntVO);
			resultVO.setResult(1);
		} catch (MediopiaDefineException e) {
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/*****************************************************
	 * 댓글 등록
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsCmntVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/addCmnt.do", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResultVO<BbsCmntVO> addCmnt(BbsCmntVO vo, ModelMap model, HttpServletRequest request)
			throws Exception {
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
			if (ValidationUtils.isEmpty(userId)) {
				// 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
				throw new SessionBrokenException(getMessage("common.system.no_auth"));
			}

			// 파라미터 체크
			if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
				// 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게
				// 문의하세요.
				throw new BadRequestUrlException(getMessage("common.system.error"));
			}

			// 게시판 정보 조회
			BbsVO bbsVO = new BbsVO();
			bbsVO.setOrgId(orgId);
			bbsVO.setBbsId(bbsId);
			bbsVO.setLangCd(langCd);
			bbsVO.setSysUseYn("Y"); // 시스템 게시판

			if (!isAdmin) {
				bbsVO.setUseYn("Y");
			}

			bbsVO = bbsInfoService.selectBbsInfo(bbsVO);

			if (bbsVO == null) {
				// 게시판 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
			}

			// 게시판 댓글 사용여부 체크
			if (!"Y".equals(bbsVO.getCmntUseYn())) {
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

			if (bbsAtclVO == null) {
				// 게시글 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
			}

			// 댓글 쓰기권한 체크
			commentWriteAuth = BbsAuthUtil.getCommentWriteAuth(request, bbsVO, bbsAtclVO);

			if (!"Y".equals(commentWriteAuth)) {
				// 접근 권한이 없습니다.
				throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
			}

			bbsCmntService.insertBbsCmnt(vo);

			resultVO.setResult(1);
			resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
		} catch (MediopiaDefineException e) {
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/*****************************************************
	 * 댓글 수정
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsCmntVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/editCmnt.do", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResultVO<BbsCmntVO> editCmnt(BbsCmntVO vo, ModelMap model, HttpServletRequest request)
			throws Exception {

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
			if (ValidationUtils.isEmpty(userId)) {
				// 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
				throw new SessionBrokenException(getMessage("common.system.no_auth"));
			}

			// 파라미터 체크
			if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId) || ValidationUtils.isEmpty(cmntId)) {
				// 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게
				// 문의하세요.
				throw new BadRequestUrlException(getMessage("common.system.error"));
			}

			// 게시판 정보 조회
			BbsVO bbsVO = new BbsVO();
			bbsVO.setOrgId(orgId);
			bbsVO.setBbsId(bbsId);
			bbsVO.setLangCd(langCd);
			bbsVO.setSysUseYn("Y"); // 시스템 게시판

			if (!isAdmin) {
				bbsVO.setUseYn("Y");
			}

			bbsVO = bbsInfoService.selectBbsInfo(bbsVO);

			if (bbsVO == null) {
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

			if (bbsAtclVO == null) {
				// 게시글 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
			}

			BbsCmntVO bbsCmntVO = new BbsCmntVO();
			bbsCmntVO.setAtclId(atclId);
			bbsCmntVO.setCmntId(cmntId);
			bbsCmntVO = bbsCmntService.selectBbsCmnt(bbsCmntVO);

			if (bbsCmntVO == null) {
				// 댓글 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_comment"));
			}

			// 댓글 수정권한 체크
			commentEditAuth = BbsAuthUtil.getCommentEditAuth(request, bbsVO, bbsAtclVO, bbsCmntVO);

			if (!"Y".equals(commentEditAuth)) {
				// 접근 권한이 없습니다.
				throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
			}

			bbsCmntService.updateBbsCmnt(vo);
			resultVO.setResult(1);
			resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
		} catch (MediopiaDefineException e) {
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/*****************************************************
	 * 댓글 삭제
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsCmntVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/removeCmnt.do", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResultVO<BbsCmntVO> removeCmnt(BbsCmntVO vo, ModelMap model, HttpServletRequest request)
			throws Exception {

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
			if (ValidationUtils.isEmpty(userId)) {
				// 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
				throw new SessionBrokenException(getMessage("common.system.no_auth"));
			}

			// 파라미터 체크
			if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId) || ValidationUtils.isEmpty(cmntId)) {
				// 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게
				// 문의하세요.
				throw new BadRequestUrlException(getMessage("common.system.error"));
			}

			// 게시판 정보 조회
			BbsVO bbsVO = new BbsVO();
			bbsVO.setOrgId(orgId);
			bbsVO.setBbsId(bbsId);
			bbsVO.setLangCd(langCd);
			bbsVO.setSysUseYn("Y"); // 시스템 게시판
			bbsVO = bbsInfoService.selectBbsInfo(bbsVO);

			if (bbsVO == null) {
				// 게시판 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
			}

			// 게시글 조회
			BbsAtclVO bbsAtclVO = new BbsAtclVO();
			bbsAtclVO.setOrgId(orgId);
			bbsAtclVO.setBbsId(bbsId);
			bbsAtclVO.setAtclId(atclId);
			bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

			if (bbsAtclVO == null) {
				// 게시글 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
			}

			BbsCmntVO bbsCmntVO = new BbsCmntVO();
			bbsCmntVO.setAtclId(atclId);
			bbsCmntVO.setCmntId(cmntId);
			bbsCmntVO = bbsCmntService.selectBbsCmnt(bbsCmntVO);

			if (bbsCmntVO == null) {
				// 댓글 정보를 찾을 수 없습니다.
				throw new BadRequestUrlException(getMessage("bbs.error.not_exists_comment"));
			}

			// 댓글 삭제권한 체크
			commentDeleteAuth = BbsAuthUtil.getCommentDeleteAuth(request, bbsVO, bbsAtclVO, bbsCmntVO);

			if (!"Y".equals(commentDeleteAuth)) {
				// 접근 권한이 없습니다.
				throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
			}

			bbsCmntService.updateBbsCmntDelY(vo);
			resultVO.setResult(1);
			resultVO.setMessage(getMessage("bbs.alert.success_delete")); // 정상적으로 삭제되었습니다.
		} catch (MediopiaDefineException e) {
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/** 댓글 END **/

	/*****************************************************
	 * 게시판 정보 조회
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsInfo.do")
	@ResponseBody
	public ProcessResultVO<BbsVO> bbsInfo(BbsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

		ProcessResultVO<BbsVO> resultVO = new ProcessResultVO<>();

		String orgId = SessionInfo.getOrgId(request);
		vo.setOrgId(orgId);

		try {
			vo.setUseYn("Y");

			BbsVO bbsVO = bbsInfoService.selectBbsInfo(vo);

			resultVO.setReturnVO(bbsVO);
			resultVO.setResult(1);
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}

		return resultVO;
	}

	/*****************************************************
	 * 게시글 조회
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/atclInfo.do")
	@ResponseBody
	public ProcessResultVO<BbsVO> atclInfo(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {

		ProcessResultVO<BbsVO> resultVO = new ProcessResultVO<>();

		String orgId = SessionInfo.getOrgId(request);
		vo.setOrgId(orgId);

		try {
			BbsAtclVO bbsAtclVO = bbsAtclService.selectBbsAtcl(vo);

			if (bbsAtclVO != null) {
				FileVO fileVO = new FileVO();
				fileVO.setRepoCd("BBS");
				fileVO.setFileBindDataSn(bbsAtclVO.getAtclId());
				ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);

				for (FileVO fvo : fileList.getReturnList()) {
					fvo.setFileId(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")));
				}
				bbsAtclVO.setFileList(fileList.getReturnList());
			}

			resultVO.setReturnVO(bbsAtclVO);
			resultVO.setResult(1);
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/*****************************************************
	 * 게시판 언어 정보 조회
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsInfoLangVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsInfoLang.do")
	@ResponseBody
	public ProcessResultVO<BbsInfoLangVO> bbsInfoLang(BbsInfoLangVO vo, ModelMap model, HttpServletRequest request)
			throws Exception {

		ProcessResultVO<BbsInfoLangVO> resultVO = new ProcessResultVO<>();

		String bbsId = vo.getBbsId();
		String langCd = vo.getLangCd();

		try {
			if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(langCd)) {
				// 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게
				// 문의하세요.
				throw new BadRequestUrlException(getMessage("common.system.error"));
			}

			BbsInfoLangVO bbsInfoLangVO = bbsInfoLangService.selectBbsInfoLang(vo);
			resultVO.setReturnVO(bbsInfoLangVO);
			resultVO.setResult(1);
		} catch (MediopiaDefineException e) {
			resultVO.setResult(-1);
			resultVO.setMessage(e.getMessage());
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/*
	 * TODO 새로 생성되거나 명칭 변경해서 작업하는 메쏘드는 여기 아래에......
	 */

	/*****************************************************
	 * 게시판 게시글 목록 조회 화면
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return "bbs/bbs_atcl_list_view"
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = {"/bbsAtclListView.do"})
	public String bbsAtclListView(BbsVO bbsVO, @CurrentUser UserContext userCtx, ModelMap model,
	        HttpServletRequest request) throws Exception {

	    boolean isAdmin = BbsAuthUtil.isAdmin(request);

	    String orgId      = userCtx.getOrgId();
	    String bbsTycd    = bbsVO.getBbsTycd();
	    String sbjctId    = bbsVO.getSbjctId();
	    String bbsRefTycd = request.getParameter("bbsRefTycd");

	    // bbsId가 없으면 유형에 따라 생성
	    String bbsId = (bbsVO.getBbsId() != null)
	            ? bbsVO.getBbsId()
	            : resolveBbsId(orgId, bbsTycd, bbsRefTycd);

	    bbsVO.setOrgId(orgId);
	    bbsVO.setBbsId(bbsId);
	    bbsVO.setBbsTycd(bbsTycd);
	    bbsVO.setSbjctId(sbjctId);
	    bbsVO.setLangCd(userCtx.getLangCd());

	    bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

	    // 게시판 정보가 없으면 기본 게시판을 생성 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>..  파라미터 값들이 널일 경우 체크하지 않았습니다. --- by jinkoon 20260702
	    if (bbsVO == null) {
	        bbsVO = createDefaultBbs(orgId, bbsId, sbjctId, bbsTycd, bbsRefTycd, userCtx.getUserId());
	        bbsInfoService.bbsInfoRegist(bbsVO);      // TB_LMS_BBS 데이터 생성
	        bbsInfoService.bbsInfoOptnRegist(bbsVO);  // TB_LMS_BBS_OPTN 데이터 생성
	    }

	    String atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsVO);

	    addEncParam("orgId", orgId);
	    addEncParam("bbsId", bbsId);
	    addEncParam("bbsTycd", bbsTycd);

	    applyListSearchDefaults(bbsVO, userCtx, true);

	    // 조회필터옵션 세팅
	    //model.addAttribute("filterOptions", bbsFacadeService.loadFilterOptions(bbsVO));
	    if (bbsVO.getSearchYr() == null || bbsVO.getSearchYr().isEmpty()) {
	    	bbsVO.setSearchYr(String.valueOf(java.time.Year.now().getValue()));
	    }

	    model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));           // 연도
	    model.addAttribute("smstrChrtList", bbsInfoService.selectBbsTermList(bbsVO));  // 학기
	    model.addAttribute("orgList", bbsInfoService.selectBbsOrgList(bbsVO));         // 기관
	    model.addAttribute("subjectList", bbsInfoService.selectBbsSubjectList(bbsVO)); // 과목
	    model.addAttribute("bbsVO", bbsVO);
	    model.addAttribute("templateUrl", TEMPLATE_URL);

	    return "bbs/bbs_atcl_list_view";
	}

	/**
	 * 게시판 유형에 따라 bbsId를 생성한다.
	 * QNA / 1ON1 / DATARM 은 orgId_유형, 그 외는 orgId_유형_참조유형
	 */
	private String resolveBbsId(String orgId, String bbsTycd, String bbsRefTycd) {
	    if (BBS_TYPE_QNA.equals(bbsTycd)
	            || BBS_TYPE_1ON1.equals(bbsTycd)
	            || BBS_TYPE_DATARM.equals(bbsTycd)) {
	        return orgId + "_" + bbsTycd;
	    }
	    return orgId + "_" + bbsTycd + "_" + bbsRefTycd;
	}

	/**
	 * 게시판 정보가 없을 때 유형별 기본값으로 BbsVO를 구성한다.
	 */
	private BbsVO createDefaultBbs(String orgId, String bbsId, String sbjctId,
	        String bbsTycd, String bbsRefTycd, String userId) {

	    BbsVO bbsVO = new BbsVO();
	    bbsVO.setOrgId(orgId);
	    bbsVO.setBbsId(bbsId);
	    bbsVO.setSbjctId(sbjctId);
	    bbsVO.setBbsTycd(bbsTycd);
	    bbsVO.setBbsRefTycd(bbsRefTycd);
	    bbsVO.setLangCd("ko");
	    bbsVO.setUserId(userId);

	    switch (bbsTycd) {
	    case BBS_TYPE_NTC:    // 공지
	        // bbsRefTycd 분기 추가
	        switch (bbsRefTycd) {
	            case BBS_REF_TYPE_ORG:   // TODO: 실제 상수로 교체
	                bbsVO.setBbsNm("공지사항");
	                bbsVO.setBbsEnnm("Notice");
	                bbsVO.setBbsExpln("공지사항 게시판");
	                break;
	            default:
	                bbsVO.setBbsNm("공지사항");
	                bbsVO.setBbsEnnm("Notice");
	                bbsVO.setBbsExpln("과목 공지사항 게시판");
	                break;
	        }
	        bbsVO.setOptnCdList(optnList("NTC"));
	        break;
		    case BBS_TYPE_DATARM:    // 공지
	            bbsVO.setBbsNm("강의자료실");
	            bbsVO.setBbsEnnm("Notice");
	            bbsVO.setBbsExpln("과목 강의자료실 게시판");
	            bbsVO.setOptnCdList(optnList("NTC"));
	            break;
	        case BBS_TYPE_QNA:    // 공지, 댓글
	            bbsVO.setBbsNm("강의Q&A");
	            bbsVO.setBbsEnnm("Notice");
	            bbsVO.setBbsExpln("과목 강의Q&A 게시판");
	            bbsVO.setOptnCdList(optnList("NTC", "RSPNS"));
	            break;
	        case BBS_TYPE_1ON1:   // 답변, 댓글
	            bbsVO.setBbsNm("1:1상담");
	            bbsVO.setBbsEnnm("Notice");
	            bbsVO.setBbsExpln("과목 1:1상담 게시판");
	            bbsVO.setOptnCdList(optnList("RSPNS", "CMNT"));
	            break;
	        default:
	            break;
	    }
	    return bbsVO;
	}

	/** 옵션 코드 리스트 생성 (수정 가능한 ArrayList 반환) */
	private List<String> optnList(String... codes) {
	    return new ArrayList<>(Arrays.asList(codes));
	}

	// 컨트롤러 내부에서 새로운 이름으로 정의된 private 메서드
	private void validateBbsAccess(String bbsId, UserContext userCtx) throws Exception {
		bbsService.checkBbsAccessWithAuth(bbsId, userCtx);
	}

	/*****************************************************
	 * 게시판게시글목록조회(Ajax)
	 *
	 * @param bbsAtclVO
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsAtclListAjax.do")
	@ResponseBody
	public ProcessResultVO<BbsAtclVO> homeBbsAtclListAjax(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx,
			ModelMap model, HttpServletRequest request) throws Exception {
		ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

		String userId = SessionInfo.getUserId(request);
		String langCd = SessionInfo.getLocaleKey(request);

		String bbsIds = request.getParameter("bbsIds"); // 게시판 id ',' 구분자
		String upAtclId = request.getParameter("upAtclId");

		int atclLv = bbsAtclVO.getAtclLv();

		try {
			bbsAtclVO.setLangCd(langCd);

			// 게시판 id ',' 구분자로 들어온 경우
			if (ValidationUtils.isNotEmpty(bbsIds)) {
				List<String> bbsIdList = Arrays.asList(bbsIds.split(","));
				bbsAtclVO.setBbsIdList(bbsIdList);
				bbsAtclVO.setBbsId(null);
			}
			bbsAtclVO.setVwerId(userId);
			bbsAtclVO.setUpAtclId(upAtclId);
			bbsAtclVO.setAtclLv(atclLv);

			bbsAtclVO.setProfessorYn(BbsAuthUtil.isProfessor(request) ? "Y" : "N");

			resultVO = bbsAtclService.selectBbsAtclList(bbsAtclVO);
			resultVO.setResult(1);
			resultVO.setEncParams(getEncParams());
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/*****************************************************
	 * 게시글 보기
	 *
	 * @param bbsAtclVO
	 * @param userCtx
	 * @param model
	 * @param request
	 * @return "bbs/bbs_atcl_view" (수정 모드인 경우 "bbs/bbs_atcl_write")
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsAtclView.do")
	public String bbsAtclView(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx, ModelMap model,
	        HttpServletRequest request) throws Exception {

	    boolean isAdmin = BbsAuthUtil.isAdmin(request);

	    String bbsId   = bbsAtclVO.getBbsId();
	    String gubun   = bbsAtclVO.getGubun();
	    String atclId  = bbsAtclVO.getAtclId();
	    String bbsTycd = bbsAtclVO.getBbsTycd();

	    String orgId  = userCtx.getOrgId();
	    String userId = userCtx.getUserId();
	    String langCd = userCtx.getLangCd();

	    if (ValidationUtils.isEmpty(bbsTycd)) {
	        throw new BadRequestUrlException(getMessage("common.system.error"));
	    }

	    // 게시판 정보 조회 및 유효성 검증
	    BbsVO bbsVO = new BbsVO();
	    bbsVO.setOrgId(orgId);
	    bbsVO.setBbsId(bbsId);
	    bbsVO.setBbsTycd(bbsTycd);
	    bbsVO.setLangCd(langCd);
	    bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

	    if (bbsVO == null) {
	        // 게시판 정보를 찾을 수 없습니다.
	        throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
	    }

	    // 학습자(학생)인 경우 강의실 활동 로그 등록
	    if (BbsAuthUtil.isStudent(request)) {
	        logLessonActnHstyService.saveLessonActnHsty(
	                request, "", CommConst.CONN_BBS, bbsVO.getBbsnm() + " 내용확인");
	    }

	    // 비관리자 조회 옵션
	    if (!isAdmin) {
	        bbsAtclVO.setLockYn("N");
	        bbsAtclVO.setLearnerViewModeYn("Y");
	    }

	    // 게시글 조회
	    bbsAtclVO.setOrgId(orgId);
	    bbsAtclVO.setBbsId(bbsId);
	    bbsAtclVO.setBbsTycd(bbsTycd);
	    bbsAtclVO.setAtclId(atclId);
	    bbsAtclVO.setUserId(userId);
	    bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

	    if (bbsAtclVO == null) {
	        // 게시글 정보를 찾을 수 없습니다.
	        throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
	    }

	    // 권한 체크 (글수정 / 삭제 / 답글 / 댓글)
	    String atclEditAuth     = BbsAuthUtil.getAtclEditAuth(request, bbsVO, bbsAtclVO);
	    String atclDeleteAuth   = BbsAuthUtil.getAtclDeleteAuth(request, bbsVO, bbsAtclVO);
	    String answerWriteAuth  = BbsAuthUtil.getAnswerAtclWriteAuth(request, bbsVO);
	    String commentWriteAuth = BbsAuthUtil.getCommentWriteAuth(request, bbsVO, bbsAtclVO);

	    model.addAttribute("filterOptions", bbsFacadeService.loadFilterOptions(userCtx));
	    model.addAttribute("bbsVO", bbsVO);
	    model.addAttribute("bbsAtclVO", bbsAtclVO);
	    model.addAttribute("atclEditAuth", atclEditAuth);
	    model.addAttribute("atclDeleteAuth", atclDeleteAuth);
	    model.addAttribute("answerWriteAuth", answerWriteAuth);
	    model.addAttribute("commentWriteAuth", commentWriteAuth);

	    addEncParam("bbsId",   bbsAtclVO.getBbsId());
	    addEncParam("bbsTycd", bbsAtclVO.getBbsTycd());
	    addEncParam("atclId",  bbsAtclVO.getAtclId());

	    model.addAttribute("templateUrl", TEMPLATE_URL);

	    // 수정 모드인 경우 글쓰기 화면으로
	    if ("edit".equals(gubun)) {
	        // 첨부파일 저장소 설정
	        bbsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_BBS, bbsId));

	        if (bbsVO.getSearchYr() == null || bbsVO.getSearchYr().isEmpty()) {
	            bbsVO.setSearchYr(String.valueOf(java.time.Year.now().getValue()));
	            bbsVO.setUserId(userId);
	        }

	        List<OrgInfoVO> orgList = bbsInfoService.selectBbsOrgList(bbsVO);

	        model.addAttribute("orgList", bbsInfoService.selectBbsOrgList(bbsVO));
	        model.addAttribute("subjectList", bbsInfoService.selectBbsSubjectList(bbsVO));

	        return "bbs/bbs_atcl_write";
	    }

	    return "bbs/bbs_atcl_view";
	}

	/*****************************************************
	 * 게시글 쓰기
	 *
	 * @param BbsAtclVO
	 * @param model
	 * @param request
	 * @return "bbs/bbs_atcl_write"
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsAtclWrite.do")
	public String bbsAtclWrite(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx, ModelMap model,
	        HttpServletRequest request) throws Exception {

	    boolean isAdmin = BbsAuthUtil.isAdmin(request);

	    String langCd  = userCtx.getLangCd();
	    String orgId   = bbsAtclVO.getOrgId();
	    if (ValidationUtils.isEmpty(orgId)) {
	        orgId = userCtx.getOrgId();
	    }
	    String bbsId   = bbsAtclVO.getBbsId();
	    String bbsTycd = bbsAtclVO.getBbsTycd();

	    // 게시판 정보 조회 및 유효성 검증
	    BbsVO bbsVO = new BbsVO();
	    bbsVO.setBbsId(bbsId);
	    bbsVO.setOrgId(orgId);
	    bbsVO.setLangCd(langCd);
	    bbsVO.setBbsTycd(bbsTycd);
	    bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

	    if (bbsVO == null) {
	        // 게시판 정보를 찾을 수 없습니다.
	        throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
	    }

	    // 페이지/검색 파라메터 삭제
	    delEncParamPageSearch();

	    // 첨부파일 저장소 설정
	    bbsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_BBS, bbsId));

	    // 글쓰기 권한 체크
	    //String atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsVO);

	    if (bbsVO.getSearchYr() == null || bbsVO.getSearchYr().isEmpty()) {
	    	bbsVO.setSearchYr(String.valueOf(java.time.Year.now().getValue()));
	    	bbsVO.setUserId(userCtx.getUserId());
	    }

	    model.addAttribute("filterOptions", bbsFacadeService.loadFilterOptions(userCtx));
	    model.addAttribute("orgList", bbsInfoService.selectBbsOrgList(bbsVO));         // 기관
	    model.addAttribute("subjectList", bbsInfoService.selectBbsSubjectList(bbsVO)); // 과목
	    //model.addAttribute("atclWriteAuth", atclWriteAuth);
	    model.addAttribute("bbsVO", bbsVO);
	    model.addAttribute("bbsAtclVO", bbsAtclVO);
	    model.addAttribute("templateUrl", TEMPLATE_URL);

	    return "bbs/bbs_atcl_write";
	}

	/*****************************************************
	 * 게시글 저장(등록)
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsAtclSave.do", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResultVO<BbsAtclVO> bbsAtclSave(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx, ModelMap model,
	        HttpServletRequest request) throws Exception {

	    ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

	    boolean isAdmin = BbsAuthUtil.isAdmin(request);
	    String orgId  = request.getParameter("searchOrgId");
	    String userId = userCtx.getUserId();

	    String bbsTycd = bbsAtclVO.getBbsTycd();
	    String bbsRefTycd = bbsAtclVO.getBbsRefTycd();

	    String bbsId = resolveBbsId(orgId, bbsTycd, bbsRefTycd);

	    String uploadFiles = bbsAtclVO.getUploadFiles();
	    String uploadPath  = bbsAtclVO.getUploadPath();

	    bbsAtclVO.setOrgId(orgId);
	    bbsAtclVO.setUserId(userId);
	    bbsAtclVO.setRgtrId(userId);
	    bbsAtclVO.setMdfrId(userId);
	    bbsAtclVO.setRgtrnm(SessionInfo.getUserNm(request));

	    try {
	        // 로그인 체크
	        if (ValidationUtils.isEmpty(userId)) {
	            throw new SessionBrokenException(getMessage("common.system.no_auth"));
	        }

	        // 파라미터 체크
	        if (ValidationUtils.isEmpty(bbsId)) {
	            throw new BadRequestUrlException(getMessage("common.system.error"));
	        }

	        // 게시판 정보 조회 및 유효성 검증
	        BbsVO bbsVO = new BbsVO();
	        bbsVO.setOrgId(orgId);
	        bbsVO.setBbsId(bbsId);
	        bbsVO.setBbsTycd(bbsTycd);
	        bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

	        if (bbsVO == null) {
	            // 게시판 정보를 찾을 수 없습니다.
	            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
	        }

	        if ("edit".equals(bbsAtclVO.getGubun())) {
	            // 게시글 수정
	            bbsAtclService.updateBbsAtcl(bbsAtclVO);
	        } else {
	            // 게시글 저장
	            bbsAtclService.insertBbsAtcl(bbsAtclVO);
	        }

	        resultVO.setReturnVO(bbsAtclVO);
	        resultVO.setResult(1);
	        resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.

	    } catch (MediopiaDefineException e) {
	        resultVO.setResult(-1);
	        resultVO.setMessage(e.getMessage());
	        delUploadedFiles(uploadFiles, uploadPath);

	    } catch (Exception e) {
	        log.debug("e: ", e);
	        resultVO.setResult(-1);
	        resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
	        delUploadedFiles(uploadFiles, uploadPath);
	    }

	    return resultVO;
	}

	/** 저장 실패 시 업로드된 첨부파일 정리 */
	private void delUploadedFiles(String uploadFiles, String uploadPath) {
	    if (ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
	        try {
	            FileUtil.delUploadFileList(uploadFiles, uploadPath);
	        } catch (Exception e) {
	            log.debug("delUploadedFiles error: ", e);
	        }
	    }
	}

	/*****************************************************
	 * 게시글 수정 화면
	 *
	 * @param bbsAtclVO
	 * @param model
	 * @param request
	 * @return "bbs/bbs_atcl_view"
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsAtclEditWrite.do")
	public String bbsAtclEditWrite(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx, ModelMap model,
	        HttpServletRequest request) throws Exception {

	    boolean isAdmin = BbsAuthUtil.isAdmin(request);

	    String orgId  = userCtx.getOrgId();
	    String langCd = userCtx.getLangCd();
	    String bbsId  = bbsAtclVO.getBbsId();

	    if (ValidationUtils.isEmpty(bbsId)) {
	        throw new BadRequestUrlException(getMessage("common.system.error"));
	    }

	    // 게시판 정보 조회 및 유효성 검증
	    BbsVO bbsVO = new BbsVO();
	    bbsVO.setOrgId(orgId);
	    bbsVO.setBbsId(bbsId);
	    bbsVO.setLangCd(langCd);
	    bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

	    if (bbsVO == null) {
	        throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
	    }

	    // 학습자(학생)인 경우 강의실 활동 로그 등록
	    if (BbsAuthUtil.isStudent(request)) {
	        logLessonActnHstyService.saveLessonActnHsty(
	                request, "", CommConst.ACTN_HSTY_COURSE_HOME, bbsVO.getBbsnm() + " 내용확인");
	    }

	    // 게시글 조회
	    if (!isAdmin) {
	        bbsAtclVO.setLockYn("N");
	        bbsAtclVO.setLearnerViewModeYn("Y");
	    }
	    bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

	    if (bbsAtclVO == null) {
	        throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
	    }

	    String atclEditAuth = BbsAuthUtil.getAtclEditAuth(request, bbsVO, bbsAtclVO);

	    // 첨부파일 저장소 설정
	    bbsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_BBS, bbsId));

	    model.addAttribute("bbsVO", bbsVO);
	    model.addAttribute("bbsAtclVO", bbsAtclVO);
	    model.addAttribute("atclEditAuth", atclEditAuth);
	    model.addAttribute("templateUrl", TEMPLATE_URL);

	    return "bbs/bbs_atcl_view";
	}

	/*****************************************************
	 * 게시판 게시글 답변 조회(Ajax)
	 *
	 * @param bbsAtclVO
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsAtclRspnsListAjax.do")
	@ResponseBody
	public ProcessResultVO<BbsAtclVO> bbsAtclRspnsListAjax(BbsAtclVO bbsAtclVO, ModelMap model,
	        HttpServletRequest request) throws Exception {
	    ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

	    String orgId    = SessionInfo.getOrgId(request);
	    String userId   = SessionInfo.getUserId(request);
	    String langCd   = SessionInfo.getLocaleKey(request);
	    String bbsIds   = request.getParameter("bbsIds");   // 게시판 id ',' 구분자
	    String upAtclId = request.getParameter("upAtclId");

	    try {
	        bbsAtclVO.setOrgId(orgId);
	        bbsAtclVO.setLangCd(langCd);

	        // 게시판 id가 ',' 구분자로 들어온 경우
	        if (ValidationUtils.isNotEmpty(bbsIds)) {
	            bbsAtclVO.setBbsIdList(Arrays.asList(bbsIds.split(",")));
	            bbsAtclVO.setBbsId(null);
	        }
	        bbsAtclVO.setVwerId(userId);
	        bbsAtclVO.setUpAtclId(upAtclId);

	        resultVO = bbsAtclService.selectBbsAtclRspnsList(bbsAtclVO);
	        resultVO.setResult(1);
	        resultVO.setEncParams(getEncParams());
	    } catch (Exception e) {
	        log.debug("e: ", e);
	        resultVO.setResult(-1);
	        resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
	    }
	    return resultVO;
	}

	/*****************************************************
	 * 답변 등록
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsAtclRspnsRegist.do", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResultVO<BbsAtclVO> bbsAtclRspnsRegist(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx,
	        ModelMap model, HttpServletRequest request) throws Exception {
	    ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

	    boolean isAdmin = BbsAuthUtil.isAdmin(request);

	    String orgId   = userCtx.getOrgId();
	    String userId  = userCtx.getUserId();
	    String langCd  = userCtx.getLangCd();
	    String bbsId   = bbsAtclVO.getBbsId();
	    String bbsTycd = bbsAtclVO.getBbsTycd();
	    String atclId  = bbsAtclVO.getAtclId();

	    try {
	        // 로그인 체크
	        if (ValidationUtils.isEmpty(userId)) {
	            throw new SessionBrokenException(getMessage("common.system.no_auth"));
	        }

	        // 파라미터 체크
	        if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
	            throw new BadRequestUrlException(getMessage("common.system.error"));
	        }

	        // 게시판 정보 조회 및 유효성 검증
	        BbsVO bbsVO = new BbsVO();
	        bbsVO.setOrgId(orgId);
	        bbsVO.setBbsId(bbsId);
	        bbsVO.setBbsTycd(bbsTycd);
	        bbsVO.setLangCd(langCd);
	        bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

	        if (bbsVO == null) {
	            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
	        }

	        // 답변 쓰기권한 체크
	        String answerWriteAuth = BbsAuthUtil.getAnswerAtclWriteAuth(request, bbsVO);
	        if (!"Y".equals(answerWriteAuth)) {
	            throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
	        }

	        bbsAtclVO.setUserId(userId);
	        bbsAtclVO.setUpAtclId(atclId);
	        bbsAtclVO.setAtclLv(2); // 답변

	        bbsAtclService.bbsAtclRspnsRegist(bbsAtclVO);

	        resultVO.setResult(1);
	        resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
	    } catch (MediopiaDefineException e) {
	        resultVO.setResult(-1);
	        resultVO.setMessage(e.getMessage());
	    } catch (Exception e) {
	        log.debug("e: ", e);
	        resultVO.setResult(-1);
	        resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
	    }
	    return resultVO;
	}


	/*****************************************************
	 * 게시판 게시글 댓글 목록조회(Ajax)
	 *
	 * @param bbsAtclVO
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsAtclCmntListAjax.do")
	@ResponseBody
	public ProcessResultVO<BbsCmntVO> bbsAtclCmntListAjax(BbsCmntVO bbsCmntVO, @CurrentUser UserContext userCtx,
	        ModelMap model, HttpServletRequest request) throws Exception {

	    ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

	    String orgId  = userCtx.getOrgId();
	    String userId = userCtx.getUserId();
	    String atclId = request.getParameter("atclId");

	    try {
	        bbsCmntVO.setOrgId(orgId);
	        bbsCmntVO.setAtclId(atclId);
	        bbsCmntVO.setUserId(userId);

	        resultVO = bbsCmntService.selectBbsAtclCmntList(bbsCmntVO);
	        resultVO.setResult(1);
	    } catch (Exception e) {
	        log.debug("e: ", e);
	        resultVO.setResult(-1);
	        resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
	    }
	    return resultVO;
	}

	/*****************************************************
	 * 댓글 등록
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsCmntVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsAtclCmntRegist.do", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResultVO<BbsCmntVO> bbsAtclCmntRegist(BbsCmntVO bbsCmntVO, @CurrentUser UserContext userCtx,
	        ModelMap model, HttpServletRequest request) throws Exception {

	    ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

	    boolean isAdmin = BbsAuthUtil.isAdmin(request);

	    String orgId   = userCtx.getOrgId();
	    String userId  = userCtx.getUserId();
	    String langCd  = userCtx.getLangCd();
	    String bbsId   = bbsCmntVO.getBbsId();
	    String bbsTycd = bbsCmntVO.getBbsTycd();

	    String atclCmntCts  = request.getParameter("atclCmntCts");
	    String atclId       = request.getParameter("atclId");
	    String upAtclCmntId = bbsCmntVO.getUpAtclCmntId();

	    try {
	        // 로그인 체크
	        if (ValidationUtils.isEmpty(userId)) {
	            throw new SessionBrokenException(getMessage("common.system.no_auth"));
	        }

	        // 파라미터 체크
	        if (ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
	            throw new BadRequestUrlException(getMessage("common.system.error"));
	        }

	        // 게시판 정보 조회 및 유효성 검증
	        BbsVO bbsVO = new BbsVO();
	        bbsVO.setOrgId(orgId);
	        bbsVO.setBbsId(bbsId);
	        bbsVO.setBbsTycd(bbsTycd);
	        bbsVO.setLangCd(langCd);
	        bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

	        if (bbsVO == null) {
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

	        if (bbsAtclVO == null) {
	            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
	        }

	        // 댓글 쓰기권한 체크
	        String commentWriteAuth = BbsAuthUtil.getCommentWriteAuth(request, bbsVO, bbsAtclVO);
	        if (!"Y".equals(commentWriteAuth)) {
	            throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
	        }

	        bbsCmntVO.setRgtrId(userId);
	        bbsCmntVO.setAtclCmntCts(atclCmntCts);
	        bbsCmntVO.setUpAtclCmntId(upAtclCmntId);
	        bbsCmntVO.setAtclId(atclId);

	        bbsCmntService.bbsAtclCmntRegist(bbsCmntVO);

	        resultVO.setResult(1);
	        resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
	    } catch (MediopiaDefineException e) {
	        resultVO.setResult(-1);
	        resultVO.setMessage(e.getMessage());
	    } catch (Exception e) {
	        log.debug("e: ", e);
	        resultVO.setResult(-1);
	        resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
	    }
	    return resultVO;
	}

	/*****************************************************
	 * 게시글 > 댓글 삭제
	 *
	 * @param vo
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsAtclCmntDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResultVO<BbsCmntVO> bbsAtclCmntDelete(BbsCmntVO bbsCmntVO, @CurrentUser UserContext userCtx,
	        ModelMap model, HttpServletRequest request) throws Exception {

	    ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

	    boolean isAdmin = BbsAuthUtil.isAdmin(request);

	    String orgId      = userCtx.getOrgId();
	    String userId     = userCtx.getUserId();
	    String langCd     = userCtx.getLangCd();
	    String bbsId      = bbsCmntVO.getBbsId();
	    String bbsTycd    = bbsCmntVO.getBbsTycd();
	    String atclId     = request.getParameter("atclId");
	    String atclCmntId = bbsCmntVO.getAtclCmntId();

	    try {
	        // 로그인 체크
	        if (ValidationUtils.isEmpty(userId)) {
	            throw new SessionBrokenException(getMessage("common.system.no_auth"));
	        }

	        // 파라미터 체크
	        if (ValidationUtils.isEmpty(atclCmntId)) {
	            throw new BadRequestUrlException(getMessage("common.system.error"));
	        }

	        // 게시판 정보 조회 및 유효성 검증
	        BbsVO bbsVO = new BbsVO();
	        bbsVO.setOrgId(orgId);
	        bbsVO.setBbsId(bbsId);
	        bbsVO.setBbsTycd(bbsTycd);
	        bbsVO.setLangCd(langCd);
	        bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

	        if (bbsVO == null) {
	            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
	        }

	        // 게시글 조회 (게시글 작성자 rgtrId 확보)
	        BbsAtclVO bbsAtclVO = new BbsAtclVO();
	        bbsAtclVO.setOrgId(orgId);
	        bbsAtclVO.setBbsId(bbsId);
	        bbsAtclVO.setAtclId(atclId);
	        bbsAtclVO.setUserId(userId);
	        bbsAtclVO.setLangCd(langCd);
	        bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

	        if (bbsAtclVO == null) {
	            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
	        }

	        // 삭제 대상 댓글 조회 (댓글 작성자 rgtrId 확보)
	        //   ※ 기존 댓글수정/삭제(1453/1549 라인)와 동일한 패턴: setAtclId + setCmntId → selectBbsCmnt
	        BbsCmntVO delCmntVO = new BbsCmntVO();
	        delCmntVO.setAtclId(atclId);
	        delCmntVO.setCmntId(atclCmntId);
	        delCmntVO = bbsCmntService.selectBbsCmnt(delCmntVO);

	        if (delCmntVO == null) {
	            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_comment"));
	        }

	        // 댓글 삭제 권한 체크 (본인 게시글의 댓글 OR 본인이 쓴 댓글)
	        //   ※ 기존 getAtclDeleteAuth(게시글 작성자 기준) → getCommentDeleteAuth(댓글 기준) 로 변경
	        String commentDeleteAuth = BbsAuthUtil.getCommentDeleteAuth(request, bbsVO, bbsAtclVO, delCmntVO);

	        if (!"Y".equals(commentDeleteAuth)) {
	            throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
	        }

	        bbsCmntService.bbsAtclCmntDelete(bbsCmntVO);

	        resultVO.setResult(1);
	        resultVO.setMessage(getMessage("bbs.alert.success_delete")); // 정상적으로 삭제되었습니다.
	    } catch (MediopiaDefineException e) {
	        resultVO.setResult(-1);
	        resultVO.setMessage(e.getMessage());
	    } catch (Exception e) {
	        log.debug("e: ", e);
	        resultVO.setResult(-1);
	        resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
	    }
	    return resultVO;
	}

	/*****************************************************
	 * 과목공지 > 그룹 공지사항
	 *
	 * @param bbsAtclVO
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsAtclGrpNtcList.do")
	@ResponseBody
	public ProcessResultVO<BbsAtclVO> bbsAtclGrpNtcList(BbsAtclVO bbsAtclVO, ModelMap model, HttpServletRequest request)
			throws Exception {
		ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

		String orgId = SessionInfo.getOrgId(request);
		String userId = SessionInfo.getUserId(request);
		String langCd = SessionInfo.getLocaleKey(request);

		try {
			bbsAtclVO.setOrgId(orgId);
			resultVO = bbsAtclService.selectBbsAtclGrpNtcList(bbsAtclVO);
			resultVO.setResult(1);
		} catch (Exception e) {
			log.debug("e: ", e);
			resultVO.setResult(-1);
			resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
		}
		return resultVO;
	}

	/*****************************************************
	 * 과목공지 > 그룹 공지사항
	 *
	 * @param bbsAtclVO
	 * @param model
	 * @param request
	 * @return ProcessResultVO<BbsAtclVO>
	 * @throws Exception
	 ******************************************************/
	@RequestMapping(value = "/bbsAtclGrpNtcPopView.do")
	public String bbsAtclGrpNtcPopView(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx, ModelMap model,
			HttpServletRequest request) throws Exception {

		model.addAttribute("filterOptions", bbsFacadeService.loadFilterOptions(userCtx));
		model.addAttribute("bbsAtclVO", bbsAtclVO);

		return "bbs/popup/bbs_grp_ntc_popview";
	}

	private void applyListSearchDefaults(BbsVO vo, UserContext userCtx, boolean defaultCurrentTerm) throws Exception {
        if (userCtx == null) {
            return;
        }

        vo.setUserId(userCtx.getUserId());

        SmstrChrtVO currentSemester = getCurrentSemester(userCtx.getOrgId());
        if (ValidationUtils.isEmpty(vo.getSearchYr())) {
            if (currentSemester != null && !ValidationUtils.isEmpty(currentSemester.getDgrsYr())) {
                vo.setSearchYr(currentSemester.getDgrsYr());
            } else {
                vo.setSearchYr(String.valueOf(java.time.Year.now().getValue()));
            }
        }

        if (defaultCurrentTerm
                && ValidationUtils.isEmpty(vo.getSearchSmstrCd())
                && currentSemester != null
                && vo.getSearchYr().equals(currentSemester.getDgrsYr())) {
            vo.setSearchSmstrCd(currentSemester.getDgrsSmstrChrt());
        }
    }

	private SmstrChrtVO getCurrentSemester(String orgId) throws Exception {
        SmstrChrtVO searchVO = new SmstrChrtVO();
        searchVO.setOrgId(orgId);
        return semesterService.selectCurrentSemester(searchVO);
    }

	/**
     * 운영과목 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectBbsSubjectList.do")
    @ResponseBody
    public ProcessResultVO<BbsVO> selectClsStsSubjectList(BbsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsVO> resultVO = new ProcessResultVO<>();
        applyListSearchDefaults(vo, userCtx, false);
        resultVO.setReturnList(bbsInfoService.selectBbsSubjectList(vo));
        resultVO.setResultSuccess();
        return resultVO;
    }

    /**
     * 교수 운영 기관 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<OrgInfoVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectBbsOrgList.do")
    @ResponseBody
    public ProcessResultVO<OrgInfoVO> selectClsStsOrgList(BbsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<OrgInfoVO> resultVO = new ProcessResultVO<>();
        applyListSearchDefaults(vo, userCtx, false);
        resultVO.setReturnList(bbsInfoService.selectBbsOrgList(vo));
        resultVO.setResultSuccess();
        return resultVO;
    }

    /**
     * 교수 운영 학기 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<SmstrChrtVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectBbsTermList.do")
    @ResponseBody
    public ProcessResultVO<SmstrChrtVO> selectClsStsTermList(BbsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<SmstrChrtVO> resultVO = new ProcessResultVO<>();
        applyListSearchDefaults(vo, userCtx, false);
        resultVO.setReturnList(bbsInfoService.selectBbsTermList(vo));
        resultVO.setResultSuccess();
        return resultVO;
    }
}
