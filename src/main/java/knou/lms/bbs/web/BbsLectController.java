package knou.lms.bbs.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
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
import knou.framework.common.IdPrefixType;
import knou.framework.common.MenuInfo;
import knou.framework.common.RepoInfo;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.exception.SessionBrokenException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.bbs.facade.BbsFacadeService;
import knou.lms.bbs.service.BbsAtclService;
import knou.lms.bbs.service.BbsCmntService;
import knou.lms.bbs.service.BbsInfoService;
import knou.lms.bbs.service.BbsViewService;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.bbs.vo.BbsCmntVO;
import knou.lms.bbs.vo.BbsInfoVO;
import knou.lms.bbs.vo.BbsVO;
import knou.lms.bbs.vo.BbsViewVO;
import knou.lms.bbs.web.util.BbsAuthUtil;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsTchRltnVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.erp.service.ErpService;
import knou.lms.erp.vo.ErpMessagePushVO;
import knou.lms.lesson.service.LessonService;
import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.subject.dto.SubjectParam;
import knou.lms.subject.service.SubjectFacadeService;
import knou.lms.subject.web.view.SubjectViewModel;
import knou.lms.user.CurrentUser;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrUserInfoVO;

import knou.lms.common.dto.BaseParam;
@Controller
@RequestMapping(value = "/bbs/bbsLect")
public class BbsLectController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(BbsLectController.class);
    private static final String TEMPLATE_URL = "bbsLect";

    @Resource(name = "bbsInfoService")
    private BbsInfoService bbsInfoService;

    @Resource(name = "bbsAtclService")
    private BbsAtclService bbsAtclService;

    @Resource(name = "bbsCmntService")
    private BbsCmntService bbsCmntService;

    @Resource(name = "orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name = "termService")
    private TermService termService;

    @Resource(name = "crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name="lessonService")
    private LessonService lessonService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name = "bbsViewService")
    private BbsViewService bbsViewService;

    @Resource(name = "logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    @Resource(name = "stdService")
    private StdService stdService;

    @Resource(name = "usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;

    @Resource(name = "erpService")
    private ErpService erpService;

    @Resource(name = "semesterService")
    private SemesterService semesterService;

    @Resource(name="bbsFacadeService")
	private BbsFacadeService bbsFacadeService;

    @Resource(name="subjectFacadeService")
    private SubjectFacadeService subjectFacadeService;
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
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        boolean isStudent = BbsAuthUtil.isStudent(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsId = vo.getBbsId();
        String langCd = SessionInfo.getLocaleKey(request);
        String tabCd = StringUtil.nvl(request.getParameter("tab"));
        String viewAllYn = "N";

        String atclWriteAuth = "N"; // 글쓰기 권한

		/*
		 * if(ValidationUtils.isEmpty(crsCreCd)) { // 시스템 오류가 발생하였거나 비정상적인
		 * 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요. throw new
		 * BadRequestUrlException(getMessage("common.system.error")); }
		 */

		/*
		 * CreCrsVO creCrsVO = new CreCrsVO(); creCrsVO.setCrsCreCd(crsCreCd); creCrsVO
		 * = crecrsService.select(creCrsVO);
		 *
		 * boolean isBbsUsePeriod = BbsAuthUtil.isBbsUsePeriod(request,
		 * creCrsVO.getCreYear(), creCrsVO.getCreTerm(), creCrsVO.getCrsCd());
		 */


		/*
		 * if (ValidationUtils.isEmpty(bbsId)) { // 시스템 오류가 발생하였거나 비정상적인
		 * 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요. throw new
		 * BadRequestUrlException(getMessage("common.system.error")); }
		 */

        // bbsId가 파라미터로 들어온 경우 [ALARM(알림터), TEAM(팀)]
        if("ALARM".equals(bbsId) || "TEAM".equals(bbsId)) {
            if("ALARM".equals(bbsId)) {
                if(ValidationUtils.isEmpty(bbsId) && isStudent) {
                    // 강의실 활동 로그 등록
                    logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_NOTIFICATION, "통합게시판 목록");
                }
            }

            else if("TEAM".equals(bbsId)) {
                // 파라미터로 받은 팀 카테고리 코드
                String teamCtgrCd = vo.getTeamCtgrCd();

                // 1.팀 게시판 목록 조회
                BbsInfoVO bbsInfoVO;
                bbsInfoVO = new BbsInfoVO();
                bbsInfoVO.setOrgId(orgId);
                bbsInfoVO.setCrsCreCd(crsCreCd);

                if(ValidationUtils.isNotEmpty(teamCtgrCd)) {
                    bbsInfoVO.setTeamCtgrCd(teamCtgrCd);
                }

                if(isStudent) {
                    bbsInfoVO.setUserId(userId);
                }

                List<BbsInfoVO> listTeamBbsId = bbsInfoService.listTeamBbsId(bbsInfoVO);

                // 2.팀게시판 id ',' 구분자 세팅
                if(listTeamBbsId != null && listTeamBbsId.size() > 0) {
                    String teamBbsIds = null;
                    List<String> bbsIdList = new ArrayList<>();

                    for(BbsInfoVO teamBbsInfo : listTeamBbsId) {
                        if(ValidationUtils.isNotEmpty(teamBbsInfo.getBbsId())) {
                            bbsIdList.add(teamBbsInfo.getBbsId());
                        }
                    }

                    if(bbsIdList.size() > 0) {
                        teamBbsIds = String.join(",", bbsIdList.toArray(new String[bbsIdList.size()]));
                    }

                    model.addAttribute("teamBbsIds", teamBbsIds);
                }

                // 3.팀 카테고리 조회
                bbsInfoVO = new BbsInfoVO();
                bbsInfoVO.setOrgId(orgId);
                bbsInfoVO.setCrsCreCd(crsCreCd);

                if(isStudent) {
                    bbsInfoVO.setUserId(userId);
                }

                List<BbsInfoVO> listTeamCtgr = bbsInfoService.listBbsInfoTeamCtgr(bbsInfoVO);
                model.addAttribute("listTeamCtgr", listTeamCtgr);

                // 4.팀 Select 리스트 조회
                if(ValidationUtils.isNotEmpty(teamCtgrCd)) {
                    model.addAttribute("listTeamBbsId", listTeamBbsId);
                }

                // 4.팀 게시판 글쓰기 권한
				/*
				 * if(listTeamBbsId != null && listTeamBbsId.size() > 0) { atclWriteAuth = "Y";
				 *
				 * // 이전과목이면 불가 if(!isBbsUsePeriod) { atclWriteAuth = "N"; } } else {
				 * atclWriteAuth = "N"; }
				 */

                // 강의실 활동 로그 등록
                if(isStudent) {
                    logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_NOTIFICATION, "팀게시판 목록");
                }
            }
        }

        if(ValidationUtils.isNotEmpty(bbsId)) {
            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setLangCd(langCd);

            // 강의실 게시판 체크
            if(!CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                bbsInfoVO.setCrsCreCd(crsCreCd);
                bbsInfoVO.setSysUseYn("N");
            }

            if(isStudent) {
                bbsInfoVO.setUseYn("Y");
            }

            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 학생 접근권한 체크
            if(isStudent) {
                if(!"Y".equals(StringUtil.nvl(bbsInfoVO.getUseYn())) || !"Y".equals(StringUtil.nvl(bbsInfoVO.getStdViewYn()))) {
                    // 접근 권한이 없습니다.
                    throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
                }
            }

            if(!"TEAM".equals(bbsInfoVO.getBbsId())) {
                // 글쓰기 권한 체크
                atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsInfoVO);

                if(isStudent) {
                    StdVO stdVO = new StdVO();
                    stdVO.setUserId(userId);
                    stdVO.setCrsCreCd(crsCreCd);
                    stdVO = stdService.selectStd(stdVO);
                    if(stdVO != null) {
                        // 청강생 글쓰기 제외
                        if("Y".equals(StringUtil.nvl(stdVO.getAuditYn()))) atclWriteAuth = "N";
                    }
                    // 강의실 활동 로그 등록
                    logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_NOTIFICATION, StringUtil.nvl(bbsInfoVO.getBbsnm())+" 목록");
                }
            }

            // 전체공지 글쓰기 불가
            if(CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                atclWriteAuth = "N";
            }

            // 문의현황 조회 (교수만)
            if(("QNA".equals(bbsInfoVO.getBbsId()) || "SECRET".equals(bbsInfoVO.getBbsId())) && BbsAuthUtil.isProfessor(request)) {
                BbsInfoVO bbsInfoVO2 = new BbsInfoVO();
                bbsInfoVO2.setOrgId(orgId);
                bbsInfoVO2.setCrsCreCd(crsCreCd);
                bbsInfoVO2.setBbsId(bbsInfoVO.getBbsId());

                /*
                if(isStudent) {
                    bbsInfoVO2.setRgtrId(userId);
                }
                */

                //List<EgovMap> listQnaSecretCountByLsnOdr = bbsInfoService.listQnaSecretCountByLsnOdr(bbsInfoVO2);
                //model.addAttribute("listQnaSecretCountByLsnOdr", listQnaSecretCountByLsnOdr);
            }

            model.addAttribute("bbsInfoVO", bbsInfoVO);

            // 학생 강의 공지 탭
            if(isStudent && "NOTICE".equals(bbsInfoVO.getBbsId())) {
                BbsInfoVO studentTabVO = new BbsInfoVO();
                studentTabVO.setOrgId(orgId);
                studentTabVO.setLangCd(langCd);
                studentTabVO.setBbsId(CommConst.BBS_ID_SYSTEM_NOTICE);
                studentTabVO.setCrsCreCd(crsCreCd);

                List<EgovMap> tabList = bbsInfoService.listBbsInfoCourseStudentTab(studentTabVO);
                String tab = "0";

                if(bbsId.equals(CommConst.BBS_ID_SYSTEM_NOTICE)) {
                    tab = "1";
                }

                model.addAttribute("tab", tab);
                model.addAttribute("tabList", tabList);
            }
        }

        // 교수자 탭 목록 조회
		/*
		 * if(!isStudent) { List<EgovMap> tabList =
		 * bbsInfoService.listBbsInfoCourseTab(request); String tab =
		 * bbsInfoService.getSelectedTab(request, tabList);
		 *
		 * if("ALARM".equals(StringUtil.nvl(vo.getBbsId()))) { // 메뉴를 눌러 들어온 경우 첫번째 탭 선택
		 * if("".equals(tabCd) && tabList.size() > 1 && ValidationUtils.isEmpty(bbsId))
		 * { tab = "1"; }
		 *
		 * model.addAttribute("alarmBbsIds",
		 * tabList.get(Integer.valueOf(tab)).get("bbsId")); }
		 *
		 * model.addAttribute("tab", tab); model.addAttribute("tabList", tabList);
		 *
		 * // 알림터 전체보기 탭 if("ALARM".equals(bbsId) && ValidationUtils.isEmpty(bbsId)) {
		 * viewAllYn = "Y";
		 *
		 * // 알림터 전체보기 탭에서 글쓰기 권한 체크 (이전과목이면 불가) if(isBbsUsePeriod) { for(EgovMap
		 * egovMap : tabList) { String sysUseYn =
		 * StringUtil.nvl(egovMap.get("sysUseYn")); String tabBbsCd =
		 * StringUtil.nvl(egovMap.get("bbsCd"));
		 *
		 * if("N".equals(sysUseYn) && ("NOTICE".equals(tabBbsCd) ||
		 * "PDS".equals(tabBbsCd))) { atclWriteAuth = "Y"; break; } } } } }
		 */

		/*
		 * model.addAttribute("defaultYear", creCrsVO.getCreYear());
		 * model.addAttribute("defaultTerm", creCrsVO.getCreTerm());
		 * model.addAttribute("courseUnivGbn", creCrsVO.getUnivGbn());
		 */
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("viewAllYn", viewAllYn);
        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("vo", vo);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        return "/bbs/notice_subject_list";
    }

    /*****************************************************
     * 게시글 보기 이동
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

        boolean isStudent = BbsAuthUtil.isStudent(request);
        boolean isVirtualLogin = SessionInfo.isVirtualLogin(request);

        String orgId = SessionInfo.getOrgId(request);
        String userAcntId = SessionInfo.getUserRprsId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsId    = vo.getBbsId();
        String atclId   = request.getParameter("atclId");
        String bbsCd;
        String langCd   = SessionInfo.getLocaleKey(request);

        String atclViewAuth = "N";      // 글보기 권한
        String atclEditAuth = "N";      // 글수정 권한
        String atclDeleteAuth  = "N";   // 글삭제 권한
        String answerWriteAuth = "N";   // 답글쓰기 권한
        String commentWriteAuth = "N";  // 댓글쓰기 권한

        if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setLangCd(langCd);

        // 강의실 게시판 체크
        if(!CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
            bbsInfoVO.setCrsCreCd(crsCreCd);
            bbsInfoVO.setSysUseYn("N");
        }

        if(isStudent) {
            bbsInfoVO.setUseYn("Y");
        }

        bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

        if(bbsInfoVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        bbsCd = bbsInfoVO.getBbsId();

        // 게시글 조회
        BbsAtclVO bbsAtclVO = new BbsAtclVO();
        bbsAtclVO.setOrgId(orgId);
        bbsAtclVO.setBbsId(bbsId);
        bbsAtclVO.setAtclId(atclId);
        bbsAtclVO.setVwerId(userAcntId); // 조회자
        bbsAtclVO.setLangCd(langCd);
        if(isStudent) {
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

        // 글보기 권한 체크
        atclViewAuth = BbsAuthUtil.getAtclViewAuth(request, bbsInfoVO, bbsAtclVO);
        if("N".equals(atclViewAuth)) {
            // 접근 권한이 없습니다.
            throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
        }

        // 조회 정보 등록
        if(!isVirtualLogin && !("tmpuser".equals(StringUtil.nvl(userAcntId)) || "mediadmin".equals(StringUtil.nvl(userAcntId)))) {
            try {
                BbsViewVO bbsViewVO = new BbsViewVO();
                bbsViewVO.setOrgId(orgId);
                bbsViewVO.setAtclId(atclId);
                bbsViewVO.setUserId(userAcntId);
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
                        bbsViewVO.setUserId(userAcntId);

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

        // 글수정, 삭제, 답글, 댓글쓰기 권한체크
        atclEditAuth = BbsAuthUtil.getAtclEditAuth(request, bbsInfoVO, bbsAtclVO);
        //atclDeleteAuth = BbsAuthUtil.getAtclDeleteAuth(request, bbsInfoVO, bbsAtclVO);
        answerWriteAuth = BbsAuthUtil.getAnswerAtclWriteAuth(request, bbsInfoVO);
        commentWriteAuth = BbsAuthUtil.getCommentWriteAuth(request, bbsInfoVO, bbsAtclVO);

        // 전체공지는 강의실에서 수정, 삭제 불가능
        if(CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
            atclEditAuth = "N";
            atclDeleteAuth = "N";
        }

        // 팀원 여부 조회
        if(isStudent && "TEAM".equals(bbsCd)) {
            String teamCtgrCd = bbsAtclVO.getTeamCtgrCd();
            String teamCd = bbsAtclVO.getTeamCd();

            EgovMap countTeamMap = new EgovMap();
            countTeamMap.put("orgId", orgId);
            countTeamMap.put("crsCreCd", crsCreCd);
            countTeamMap.put("teamCtgrCd", teamCtgrCd);
            countTeamMap.put("teamCd", teamCd);
            countTeamMap.put("userId", userAcntId);

            int count = bbsInfoService.countTeamBbsMember(countTeamMap);

            if(count != 1) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }
        }

        // 교수자 탭 목록 조회
        if(!isStudent) {
            List<EgovMap> tabList = bbsInfoService.listBbsInfoCourseTab(request);
            String tab = bbsInfoService.getSelectedTab(request, tabList);

            if("ALARM".equals(StringUtil.nvl(vo.getBbsId()))) {
                model.addAttribute("alarmBbsIds", tabList.get(Integer.valueOf(tab)).get("bbsId"));
            }

            model.addAttribute("tab", tab);
            model.addAttribute("tabList", tabList);
        }

        if(isStudent) {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_NOTIFICATION, bbsInfoVO.getBbsnm() + " 내용확인");
        }

        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("atclEditAuth", atclEditAuth);
        model.addAttribute("atclDeleteAuth", atclDeleteAuth);
        model.addAttribute("answerWriteAuth", answerWriteAuth);
        model.addAttribute("commentWriteAuth", commentWriteAuth);
        model.addAttribute("vo", vo);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());
        model.addAttribute("userId", userAcntId);

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

        boolean isStudent = BbsAuthUtil.isStudent(request);

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String userId = vo.getUserId();
        String bbsId = vo.getBbsId();
        String bbsCd = vo.getBbsId();
        String langCd = SessionInfo.getLocaleKey(request);

        String atclWriteAuth = "Y"; // 글쓰기 권한

        vo.setLangCd(langCd);

        if(!"TEAM".equals(StringUtil.nvl(bbsCd))) {
            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setLangCd(langCd);

            // 강의실 게시판 체크
            if(!CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                bbsInfoVO.setCrsCreCd(crsCreCd);
                bbsInfoVO.setSysUseYn("N");
            }

            if(isStudent) {
                bbsInfoVO.setUseYn("Y");
            }

            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 글쓰기 권한 체크
            atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsInfoVO);

            StdVO stdVO = new StdVO();
            stdVO.setUserId(userId);
            stdVO.setCrsCreCd(crsCreCd);
            stdVO = stdService.selectStd(stdVO);
            if(stdVO != null) {
                // 청강생 글쓰기 제외
                if("Y".equals(StringUtil.nvl(stdVO.getAuditYn()))) atclWriteAuth = "N";
            }
            model.addAttribute("bbsInfoVO", bbsInfoVO);
        }

        // 교수자 탭 목록 조회
        if(!isStudent) {
            List<EgovMap> tabList = bbsInfoService.listBbsInfoCourseTab(request);
            String tab = bbsInfoService.getSelectedTab(request, tabList);

            if("ALARM".equals(StringUtil.nvl(vo.getBbsId()))) {
                model.addAttribute("alarmBbsIds", tabList.get(Integer.valueOf(tab)).get("bbsId"));
            }

            model.addAttribute("tab", tab);
            model.addAttribute("tabList", tabList);
        }

        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("vo", vo);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        return "bbs/atcl_write";
    }

    /*****************************************************
     * 게시글 수정 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/atcl_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/atclEdit.do")
    public String atclEdit(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        boolean isStudent = BbsAuthUtil.isStudent(request);


        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsId    = vo.getBbsId();
        String atclId   = request.getParameter("atclId");
        String langCd   = SessionInfo.getLocaleKey(request);

        String atclEditAuth = "N"; // 글수정 권한

        vo.setLangCd(langCd);

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setLangCd(langCd);

        // 강의실 게시판 체크
        if(!CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
            bbsInfoVO.setCrsCreCd(crsCreCd);
            bbsInfoVO.setSysUseYn("N");
        }

        if(isStudent) {
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

        // 교수자 탭 목록 조회
        if(!isStudent) {
            List<EgovMap> tabList = bbsInfoService.listBbsInfoCourseTab(request);
            String tab = bbsInfoService.getSelectedTab(request, tabList);

            if("ALARM".equals(StringUtil.nvl(vo.getBbsId()))) {
                model.addAttribute("alarmBbsIds", tabList.get(Integer.valueOf(tab)).get("bbsId"));
            }

            model.addAttribute("tab", tab);
            model.addAttribute("tabList", tabList);
        }

        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("atclEditAuth", atclEditAuth);
        model.addAttribute("vo", vo);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        return "bbs/atcl_write";
    }

    /*****************************************************
     * 게시글 목록 조회
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
        boolean isStudent = BbsAuthUtil.isStudent(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsId = vo.getBbsId();
        String bbsIds = request.getParameter("bbsIds"); // 게시판 id ',' 구분자
        String langCd = SessionInfo.getLocaleKey(request);

        vo.setOrgId(orgId);
        vo.setLangCd(langCd);

        try {
            if(ValidationUtils.isEmpty(crsCreCd) || !(ValidationUtils.isNotEmpty(bbsId) || ValidationUtils.isNotEmpty(bbsIds))) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 id ',' 구분자로 들어온 경우
            if(ValidationUtils.isNotEmpty(bbsIds)) {
                List<String> bbsIdList = Arrays.asList(bbsIds.split(","));
                vo.setBbsIdList(bbsIdList);
                vo.setBbsId(null);
                vo.setCrsCreCd(null);
            }
            // 전체공지 학부, 대학원 구분용
            vo.setVwerId(userId);

            if(isStudent) {
                vo.setLearnerViewModeYn("Y");
            }

            resultVO = bbsAtclService.listBbsAtclPaging(vo);
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

    	if (bindingResult.hasErrors()) {
	        // 유효성 검사 실패 처리
	        ProcessResultVO<BbsAtclVO> result = new ProcessResultVO<>();
	        result.setSuccess(false);
	        result.setMessage(bindingResult.getAllErrors().get(0).getDefaultMessage());
	        return result;
	    }

        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isProfessor = BbsAuthUtil.isProfessor(request);

        String orgId  = SessionInfo.getOrgId(request);
        String userId  = SessionInfo.getUserId(request);
        String userNm  = SessionInfo.getUserNm(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsId = vo.getBbsId();
        String parAtclId = vo.getUpAtclId();

        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        vo.setOrgId(orgId);
        vo.setRgtrId(userId);

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setCrsCreCd(crsCreCd);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("N"); // 강의실 게시판

            if(!isProfessor) {
                bbsInfoVO.setUseYn("Y");
            }

            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            String bbsCd = bbsInfoVO.getBbsId();

            BbsAtclVO parBbsAtclVO = null;
            // 답글인 경우
            if(ValidationUtils.isNotEmpty(parAtclId)) {
                // 답글 쓰기권한 체크
                String answerWriteAuth = BbsAuthUtil.getAnswerAtclWriteAuth(request, bbsInfoVO);

                if(!"Y".equals(answerWriteAuth)) {
                    // 접근 권한이 없습니다.
                    throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
                }

                // 게시글 정보 조회
                parBbsAtclVO = new BbsAtclVO();
                parBbsAtclVO.setOrgId(orgId);
                parBbsAtclVO.setBbsId(bbsId);
                parBbsAtclVO.setAtclId(parAtclId);
                parBbsAtclVO = bbsAtclService.selectBbsAtcl(parBbsAtclVO);

                if(parBbsAtclVO == null) {
                    // 게시글 정보를 찾을 수 없습니다.
                    throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
                }

                // 1:1 상담교수 체크
                //String councelProf = bbsAtclVO.getCouncelProf();
                //if("SECRET".equals(bbsCd) && !councelProf.equals(userId)) {
                // // 접근 권한이 없습니다.
                // throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
                //}

                // 부모글 타이틀 세팅
                vo.setAtclTtl("RE : " + parBbsAtclVO.getAtclTtl());
            } else {
                String getWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsInfoVO);

                //String councelProf = vo.getCouncelProf();
                //
                //if("SECRET".equals(bbsCd) && ValidationUtils.isEmpty(councelProf)) {
                //    // 일대일상담을 선택한경우, 상담교수는 필수 항목입니다. 다시 확인 바랍니다.
                //    throw new BadRequestUrlException(getMessage("bbs.alert.no_select_councel_prof"));
                //}

                if(!"Y".equals(getWriteAuth)) {
                    // 접근 권한이 없습니다.
                    throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
                }

                // 강의실 활동 로그 등록
                logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_NOTIFICATION, bbsInfoVO.getBbsnm() + " 글쓰기");
            }

            vo.setBbsId(bbsInfoVO.getBbsId());

            bbsAtclService.insertBbsAtcl(vo);

            // 한사대만 가능
            if(SessionInfo.isKnou(request)) {
                // ERP PUSH 발송
                try {
                    // 교수 답글단 경우 문의자에게 PUSH 발송
                    if(ValidationUtils.isNotEmpty(parAtclId)) {
                        if("QNA".equals(bbsCd) || "SECRET".equals(bbsCd)) {
                            // 발송대상자 조회
                            UsrUserInfoVO userResvInfoVO = new UsrUserInfoVO();
                            userResvInfoVO.setOrgId(orgId);
                            userResvInfoVO.setUserId(parBbsAtclVO.getRgtrId());
                            userResvInfoVO = usrUserInfoService.selectUserRecvInfo(userResvInfoVO);

                            if(userResvInfoVO != null && ValidationUtils.isNotEmpty(userResvInfoVO.getMobileNo())) {
                                String crsCreNm = StringUtil.nvl(parBbsAtclVO.getCrsCreNm());

                                if(!"".equals(crsCreNm)) {
                                    crsCreNm = crsCreNm + " (" + StringUtil.nvl(parBbsAtclVO.getDeclsNo()) + ")반";
                                }

                                String bbsNm = parBbsAtclVO.getBbsnm();

                                // [{0}], [{1}], [답변] 등록되었습니다.
                                String[] subjectArgu = {crsCreNm, bbsNm};
                                String subject = getMessage("bbs.push.template.qna.secret.answer", subjectArgu);
                                String ctnt = StringUtil.removeTag(vo.getAtclCts());

                                ErpMessagePushVO erpMessagePushVO = new ErpMessagePushVO();
                                erpMessagePushVO.setUserId(userResvInfoVO.getUserId());
                                erpMessagePushVO.setUserNm(userResvInfoVO.getUserNm());
                                erpMessagePushVO.setRcvPhoneNo(userResvInfoVO.getMobileNo());
                                erpMessagePushVO.setSubject(subject);
                                erpMessagePushVO.setCtnt(ctnt);
                                erpMessagePushVO.setCrsCreCd(crsCreCd);

                                erpService.insertSysMessagePush(request, erpMessagePushVO, "알림터 답변 등록 PUSH 발송");
                            }
                        }
                    } else {
                        if("QNA".equals(bbsCd) || "SECRET".equals(bbsCd)) {
                            /* 문의 or 상담 등록시 교수에게 PUSH 발송 */
                            CreCrsVO creCrsVO = new CreCrsVO();
                            creCrsVO.setCrsCreCd(crsCreCd);
                            List<CreCrsTchRltnVO> listCrecrsTch = crecrsService.listCrecrsTch(creCrsVO);
                            List<String> userIdList = new ArrayList<>();

                            for(CreCrsTchRltnVO creCrsTchRltnVO : listCrecrsTch) {
                                // 상담게시판은 교수에게만 전송. (교수만 답변담)
                                if("SECRET".equals(bbsCd) && !"PROF".equals(creCrsTchRltnVO.getTchType())) {
                                    continue;
                                }

                                userIdList.add(creCrsTchRltnVO.getUserId());
                            }

                            // 발송대상자 조회
                            UsrUserInfoVO userResvInfoVO = new UsrUserInfoVO();
                            userResvInfoVO.setOrgId(orgId);
                            userResvInfoVO.setSqlForeach(userIdList.toArray(new String[userIdList.size()]));
                            List<UsrUserInfoVO> listUserRecvInfo = usrUserInfoService.listUserRecvInfo(userResvInfoVO);

                            if(listUserRecvInfo.size() > 0) {
                                // 강의실 정보 조회
                                creCrsVO = crecrsService.select(creCrsVO);

                                String crsCreNm = StringUtil.nvl(creCrsVO.getCrsCreNm());

                                if(!"".equals(crsCreNm)) {
                                    crsCreNm = crsCreNm + " (" + StringUtil.nvl(creCrsVO.getDeclsNo()) + ")반";
                                }

                                String bbsNm = bbsInfoVO.getBbsnm();

                                // [{0}], [{1}, {2}], [{3}] 등록되었습니다.
                                String[] subjectArgu = {crsCreNm, userId, userNm, bbsNm};
                                String subject = getMessage("bbs.push.template.qna.secret.regist", subjectArgu);
                                String ctnt = StringUtil.removeTag(vo.getAtclCts());

                                ErpMessagePushVO erpMessagePushVO = new ErpMessagePushVO();
                                erpMessagePushVO.setUsrUserInfoList(listUserRecvInfo);
                                erpMessagePushVO.setSubject(subject);
                                erpMessagePushVO.setCtnt(ctnt);
                                erpMessagePushVO.setCrsCreCd(crsCreCd);

                                if("QNA".equals(bbsCd)) {
                                    erpService.insertSysMessagePush(request, erpMessagePushVO, "알림터 문의 등록 PUSH 발송");
                                } else {
                                    erpService.insertSysMessagePush(request, erpMessagePushVO, "알림터 상담 등록 PUSH 발송");
                                }
                            }
                        } /*else if("NOTICE".equals(bbsCd) && !CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                            // 강의공지 등록시 교수자, 학생 PUSH 발송

                            List<String> userIdList = new ArrayList<>();
                            CreCrsVO creCrsVO = new CreCrsVO();
                            creCrsVO.setCrsCreCd(crsCreCd);
                            // 교수자 조회

//                            List<CreCrsTchRltnVO> listCrecrsTch = crecrsService.listCrecrsTch(creCrsVO);
//
//                            for(CreCrsTchRltnVO creCrsTchRltnVO : listCrecrsTch) {
//                                // 글쓴 본인은 제외
//                                if(SessionInfo.getUserId(request).equals(creCrsTchRltnVO.getUserId())) {
//                                    continue;
//                                }
//
//                                userIdList.add(creCrsTchRltnVO.getUserId());
//                            }

                            // 수강생 조회 (청강생 포함)
                            StdVO stdVO = new StdVO();
                            stdVO.setCrsCreCd(crsCreCd);
                            List<StdVO> listStd = stdService.list(stdVO);

                            for(StdVO stdVO2 : listStd) {
                                userIdList.add(stdVO2.getUserId());
                            }

                            // 발송대상자 조회
                            UsrUserInfoVO userResvInfoVO = new UsrUserInfoVO();
                            userResvInfoVO.setOrgId(orgId);
                            userResvInfoVO.setSqlForeach(userIdList.toArray(new String[userIdList.size()]));
                            List<UsrUserInfoVO> listUserRecvInfo = usrUserInfoService.listUserRecvInfo(userResvInfoVO);

                            if(listUserRecvInfo.size() > 0) {
                                // 강의실 정보 조회
                                creCrsVO = crecrsService.select(creCrsVO);

                                String crsCreNm = StringUtil.nvl(creCrsVO.getCrsCreNm());

                                if(!"".equals(crsCreNm)) {
                                    crsCreNm = crsCreNm + " (" + StringUtil.nvl(creCrsVO.getDeclsNo()) + ")반";
                                }

                                // [{0}], [공지]가 등록되었습니다.
                                String[] subjectArgu = {crsCreNm};
                                String subject = getMessage("bbs.push.template.notice.regist", subjectArgu);
                                String ctnt = StringUtil.removeTag(vo.getAtclCts());

                                ErpMessagePushVO erpMessagePushVO = new ErpMessagePushVO();
                                erpMessagePushVO.setUsrUserInfoList(listUserRecvInfo);
                                erpMessagePushVO.setSubject(subject);
                                erpMessagePushVO.setCtnt(ctnt);
                                erpMessagePushVO.setCrsCreCd(crsCreCd);
                                erpService.insertSysMessagePush(request, erpMessagePushVO, "알림터 강의공지 등록 PUSH 발송");
                            }
                        }*/
                    }
                } catch (Exception e) {

                }
            }

            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch(EgovBizException | MediopiaDefineException e) {
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
        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isProfessor = BbsAuthUtil.isProfessor(request);


        String orgId        = SessionInfo.getOrgId(request);
        String userId       = SessionInfo.getUserId(request);
        String crsCreCd     = vo.getCrsCreCd();
        String bbsId        = vo.getBbsId();
        String atclId       = vo.getAtclId();

        String uploadFiles  = vo.getUploadFiles();
        String uploadPath   = vo.getUploadPath();

        vo.setOrgId(orgId);
        vo.setMdfrId(userId);

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setCrsCreCd(crsCreCd);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("N"); // 강의실 게시판

            if(!isProfessor) {
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
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            vo.setBbsId(bbsInfoVO.getBbsId());
            vo.setDvclasRegAtclId(bbsAtclVO.getDvclasRegAtclId());

            bbsAtclService.updateBbsAtcl(vo);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch(EgovBizException | MediopiaDefineException e) {
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
    public ProcessResultVO<BbsAtclVO> removeAtcl(BbsAtclVO vo, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isProfessor = BbsAuthUtil.isProfessor(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId   = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsId    = vo.getBbsId();
        String atclId   = vo.getAtclId();
        String bbsTycd   = vo.getBbsTycd();
        String langCd = userCtx.getLangCd();

        vo.setOrgId(orgId);
        vo.setMdfrId(userId);

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsVO bbsVO = new BbsVO();
            bbsVO.setOrgId(orgId);
            bbsVO.setBbsId(bbsId);
            bbsVO.setLangCd(langCd);
            bbsVO.setBbsTycd(bbsTycd);
            bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isProfessor);

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
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            String atclDeleteAuth = BbsAuthUtil.getAtclDeleteAuth(request, bbsVO, bbsAtclVO);

            if(!"Y".equals(atclDeleteAuth)) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
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

        boolean isProfessor = BbsAuthUtil.isProfessor(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsId = vo.getBbsId();
        String atclId = vo.getAtclId();

        vo.setRgtrId(userId);

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);

            // 강의실 게시판 체크
            if(!CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                bbsInfoVO.setCrsCreCd(crsCreCd);
                bbsInfoVO.setSysUseYn("N"); // 강의실 게시판
            }

            if(!isProfessor) {
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
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
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
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 삭제여부 체크
            if(!"N".equals(bbsAtclVO.getDelYn())) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
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

        boolean isProfessor = BbsAuthUtil.isProfessor(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId  = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsId = vo.getBbsId();
        String parAtclId = vo.getUpAtclId();

        vo.setOrgId(orgId);

        try {
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(parAtclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);

            // 강의실 게시판 체크
            if(!CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                bbsInfoVO.setCrsCreCd(crsCreCd);
                bbsInfoVO.setSysUseYn("N"); // 강의실 게시판
            }

            if(!isProfessor) {
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
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
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
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            // 비밀글 본인여부 체크
            if(!isProfessor && "SECRET".equals(bbsInfoVO.getBbsId()) && !userId.equals(bbsAtclVO.getRgtrId())) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            List<BbsAtclVO> list = bbsAtclService.listBbsAtclAnswer(vo);

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

        boolean isProfessor = BbsAuthUtil.isProfessor(request);


        String orgId = SessionInfo.getOrgId(request);
        String userId   = SessionInfo.getUserId(request);
        String crsCreCd = request.getParameter("crsCreCd");
        String bbsId    = request.getParameter("bbsId");
        String atclId   = vo.getAtclId();

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);

            // 강의실 게시판 체크
            if(!CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                bbsInfoVO.setCrsCreCd(crsCreCd);
                bbsInfoVO.setSysUseYn("N"); // 강의실 게시판
            }

            if(!isProfessor) {
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
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
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
            /*
            if(!"Y".equals(bbsAtclVO.getCmntUseYn())) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }
            */
            // 게시글 삭제여부 체크
            if(!"N".equals(bbsAtclVO.getDelYn())) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            // 삭제된 댓글 제외 리스트 조회
            if(!isProfessor) {
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

        boolean isProfessor = BbsAuthUtil.isProfessor(request);

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = request.getParameter("crsCreCd");
        String bbsId    = request.getParameter("bbsId");
        String atclId   = vo.getAtclId();
        String cmntId   = vo.getCmntId();

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId) || ValidationUtils.isEmpty(cmntId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);

            // 강의실 게시판 체크
            if(!CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                bbsInfoVO.setCrsCreCd(crsCreCd);
                bbsInfoVO.setSysUseYn("N"); // 강의실 게시판
            }

            if(!isProfessor) {
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
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
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
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 삭제여부 체크
            if(!"N".equals(bbsAtclVO.getDelYn())) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
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

        boolean isProfessor = BbsAuthUtil.isProfessor(request);


        String userId       = SessionInfo.getUserId(request);
        String orgId        = SessionInfo.getOrgId(request);
        String crsCreCd     = request.getParameter("crsCreCd");
        String bbsId        = request.getParameter("bbsId");
        String atclId       = vo.getAtclId();
        //String feedbackYN   = request.getParameter("feedbackYN");
        String langCd       = SessionInfo.getLocaleKey(request);

        //String atclWriteAuth = "N";
        String commentWriteAuth = "N";

        vo.setRgtrId(userId);

        try {
            // 로그인 체크
            if(ValidationUtils.isEmpty(userId)) {
                // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
                throw new SessionBrokenException(getMessage("common.system.no_auth"));
            }

            // 파라미터 체크
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setLangCd(langCd);

            // 강의실 게시판 체크
            if(!CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                bbsInfoVO.setCrsCreCd(crsCreCd);
                bbsInfoVO.setSysUseYn("N"); // 강의실 게시판
            }

            if(!isProfessor) {
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
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
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

            /*
            // 게시글 쓰기 권한
            atclWriteAuth = BbsAuthUtil.getWriteAuth(request, bbsInfoVO);

            if("Y".equals(StringUtil.nvl(feedbackYN))) {
                if("QNA".equals(bbsInfoVO.getBbsCd())) {
                    if("Y".equals(atclWriteAuth)) {
                        bbsCmntService.insertWithFeedback(vo, bbsAtclVO);
                    } else {
                        // 피드백 문의로 등록할 수 없습니다.
                        throw new BadRequestUrlException(getMessage("bbs.error.no_auth_feedback_qna"));
                    }
                } else {
                    // 피드백 문의로 등록할 수 없습니다.
                    throw new BadRequestUrlException(getMessage("bbs.error.no_auth_feedback_qna"));
                }
            } else {
                bbsCmntService.insert(vo);
            }
            */

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

        boolean isProfessor = BbsAuthUtil.isProfessor(request);

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = request.getParameter("crsCreCd");
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
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId) || ValidationUtils.isEmpty(cmntId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setLangCd(langCd);

            // 강의실 게시판 체크
            if(!CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                bbsInfoVO.setCrsCreCd(crsCreCd);
                bbsInfoVO.setSysUseYn("N"); // 강의실 게시판
            }

            if(!isProfessor) {
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

        boolean isProfessor = BbsAuthUtil.isProfessor(request);

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = request.getParameter("crsCreCd");
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
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId) || ValidationUtils.isEmpty(cmntId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setLangCd(langCd);

            // 강의실 게시판 체크
            if(!CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                bbsInfoVO.setCrsCreCd(crsCreCd);
                bbsInfoVO.setSysUseYn("N"); // 강의실 게시판
            }

            if(!isProfessor) {
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


    /** 게시판 관리 START **/

    /*****************************************************
     * 게시판 관리 목록 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/lect/info_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/infoList.do")
    public String infoListForm(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        boolean isProfessor = BbsAuthUtil.isProfessor(request);
        String lectBbsWriteAuth = BbsAuthUtil.getLectBbsWriteAuth(request);
        String lectBbsEditAuth = BbsAuthUtil.getLectBbsEditAuth(request);

        String crsCreCd = vo.getCrsCreCd();

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        if(!isProfessor) {
            // 접근 권한이 없습니다.
            throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
        }

        model.addAttribute("vo", vo);
        model.addAttribute("lectBbsWriteAuth", lectBbsWriteAuth);
        model.addAttribute("lectBbsEditAuth", lectBbsEditAuth);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        return "bbs/lect/info_list";
    }

    /*****************************************************
     * 게시판 관리 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listInfo.do")
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> listInfo(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        boolean isProfessor = BbsAuthUtil.isProfessor(request);

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String langCd = SessionInfo.getLocaleKey(request);

        vo.setOrgId(orgId);
        vo.setLangCd(langCd);

        try {
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            if(!isProfessor) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            vo.setSysUseYn("N"); // 강의실 게시판

            resultVO = bbsInfoService.listBbsInfoPaging(vo);
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
     * 게시판 관리 등록 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/lect/info_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/infoWrite.do")
    public String infoWriteForm(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        boolean isProfessor = BbsAuthUtil.isProfessor(request);

        String crsCreCd = vo.getCrsCreCd();

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        if(!isProfessor) {
            // 접근 권한이 없습니다.
            throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
        }

        List<OrgCodeVO> langCdList = orgCodeService.listCode("LANG_CD", true);
        List<OrgCodeVO> bbsCdList = orgCodeService.listCode("BBS_CD", true);
        List<OrgCodeVO> bbsTypeCdList = orgCodeService.listCode("BBS_TYPE_CD", true);

        model.addAttribute("langCdList", langCdList);
        model.addAttribute("bbsCdList", bbsCdList);
        model.addAttribute("bbsTypeCdList", bbsTypeCdList);
        model.addAttribute("bbsInfoVO", null);
        model.addAttribute("vo", vo);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        return "bbs/lect/info_write";
    }

    /*****************************************************
     * 게시판 관리 수정 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/lect/info_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/infoEdit.do")
    public String infoEditForm(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        boolean isProfessor = BbsAuthUtil.isProfessor(request);

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsId    = vo.getBbsId();
        String langCd   = SessionInfo.getLocaleKey(request);

        if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        if(!isProfessor) {
            // 접근 권한이 없습니다.
            throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
        }

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setCrsCreCd(crsCreCd);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setLangCd(langCd);
        bbsInfoVO.setSysUseYn("N"); // 강의실 게시판
        bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

        if(bbsInfoVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        List<OrgCodeVO> langCdList = orgCodeService.listCode("LANG_CD", true);
        List<OrgCodeVO> bbsCdList = orgCodeService.listCode("BBS_CD", true);
        List<OrgCodeVO> bbsTypeCdList = orgCodeService.listCode("BBS_TYPE_CD", true);

        model.addAttribute("langCdList", langCdList);
        model.addAttribute("bbsCdList", bbsCdList);
        model.addAttribute("bbsTypeCdList", bbsTypeCdList);
        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("vo", vo);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        return "bbs/lect/info_write";
    }

    /*****************************************************
     * 게시판 관리 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addInfo.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> addInfo(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        String lectBbsWriteAuth = BbsAuthUtil.getLectBbsWriteAuth(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsCd = vo.getBbsId();

        vo.setOrgId(orgId);
        vo.setRgtrId(userId);

        try {
            if(ValidationUtils.isEmpty(crsCreCd) || "TEAM".equals(StringUtil.nvl(bbsCd))) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            if(!"Y".equals(lectBbsWriteAuth)) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            vo.setSysUseYn("N");        // 시스템 사용여부
            vo.setSysDefaultYn("N");    // 시스템 기본 제공 여부

            // vo.setCmntUseYn("Y");       // 댓글
            // vo.setLockUseYn("Y");       // 비밀글 사용여부

            if("PDS".equals(bbsCd)) {
                vo.setGoodUseYn("Y");   // 좋아요
            } else {
                vo.setGoodUseYn("N");   // 좋아요
            }

            bbsInfoService.insertBbsInfo(vo);

            // 강의실 메뉴정보 초기화
            if(CommConst.REDIS_USE) {
                MenuInfo.increaseCourseBbsVersion(crsCreCd);
            }

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
     * 게시판 관리 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editInfo.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> editInfo(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        String lectBbsEditAuth = BbsAuthUtil.getLectBbsEditAuth(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsId = vo.getBbsId();

        vo.setOrgId(orgId);
        vo.setMdfrId(userId);

        try {
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            if(!"Y".equals(lectBbsEditAuth)) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setCrsCreCd(crsCreCd);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("N"); // 강의실 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            bbsInfoService.updateBbsInfo(vo);

            // 강의실 메뉴정보 초기화
            if(CommConst.REDIS_USE) {
                MenuInfo.increaseCourseBbsVersion(crsCreCd);
            }

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
     * 게시판 관리 사용여부 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editUseYn.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> editUseYn(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        String lectBbsEditAuth = BbsAuthUtil.getLectBbsEditAuth(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsId = vo.getBbsId();
        String useYn = vo.getUseYn();

        vo.setMdfrId(userId);

        try {
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(useYn)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            if(!"Y".equals(lectBbsEditAuth)) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setCrsCreCd(crsCreCd);
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("N"); // 강의실 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            bbsInfoService.updateBbsInfoUseYn(vo);

            // 강의실 메뉴정보 초기화
            if(CommConst.REDIS_USE) {
                MenuInfo.increaseCourseBbsVersion(crsCreCd);
            }

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
     * 게시판 학생 공개 여부 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editStdViewYn.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> editStdViewYn(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        String lectBbsEditAuth = BbsAuthUtil.getLectBbsEditAuth(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsId = vo.getBbsId();
        String stdViewYn = vo.getStdViewYn();

        vo.setMdfrId(userId);

        try {
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(stdViewYn)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            if(!"Y".equals(lectBbsEditAuth)) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setCrsCreCd(crsCreCd);
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("N"); // 강의실 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            bbsInfoService.updateBbsInfoStdViewYn(vo);

            // 강의실 메뉴정보 초기화
            if(CommConst.REDIS_USE) {
                MenuInfo.increaseCourseBbsVersion(crsCreCd);
            }

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

    /** 게시판 관리 END **/


    /*****************************************************
     * 강의실 기본 게시판 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listCourseDefaultBbs.do")
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> listCourseDefaultBbs(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();


        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String langCd = SessionInfo.getLocaleKey(request);

        vo.setOrgId(orgId);

        try {
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            vo.setSysDefaultYn("Y");
            vo.setSysUseYn("N");
            vo.setUseYn("Y");
            vo.setLangCd(langCd);

            List<BbsInfoVO> list = bbsInfoService.listBbsInfo(vo);

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

    /*****************************************************
     * 팀 게시판 팀 카테고리 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<bbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listTeamCtgr.do")
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> listTeamCtgr(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();
        boolean isStudent = BbsAuthUtil.isStudent(request);


        String orgId = SessionInfo.getOrgId(request);
        String userId   = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();

        try {
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            vo.setOrgId(orgId);

            if(isStudent) {
                vo.setUserId(userId);
            }

            List<BbsInfoVO> list = bbsInfoService.listBbsInfoTeamCtgr(vo);

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

    /*****************************************************
     * 팀 게시판 아이디 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<bbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listTeamBbsId.do")
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> listTeamBbsId(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        boolean isStudent = BbsAuthUtil.isStudent(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String teamCtgrCd = request.getParameter("teamCtgrCd");

        try {
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setCrsCreCd(crsCreCd);
            bbsInfoVO.setTeamCtgrCd(teamCtgrCd);

            if(isStudent) {
                bbsInfoVO.setUserId(userId);
            }

            List<BbsInfoVO> list = bbsInfoService.listTeamBbsId(bbsInfoVO);

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

    /*****************************************************
     * 1:1문의 게시판 상담교수 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/councelProflist.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> councelPfoflist(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        String crsCreCd = vo.getCrsCreCd();

        try {
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            resultVO.setReturnList(bbsInfoService.listBbsInfoCouncelProf(vo));
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
     * 분반 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/declsList.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> declsList(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String crsCreCd = vo.getCrsCreCd();
        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        try {
            if(ValidationUtils.isEmpty(crsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            resultVO.setReturnList(bbsInfoService.listBbsInfoDecls(vo));
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
     * 학습자 강의 Q&A 등록 팝업
     * @param vo
     * @param model
     * @param request
     * @return "bbs/lect/popup/qna_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/popup/qnaWrite.do")
    public String qnaWrite(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String bbsCd = vo.getBbsId();
        String langCd = SessionInfo.getLocaleKey(request);

        String atclWriteAuth = "Y"; // 글쓰기 권한
        vo.setLangCd(langCd);

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setBbsId(bbsCd);
        bbsInfoVO.setLangCd(langCd);
        bbsInfoVO.setCrsCreCd(crsCreCd);
        bbsInfoVO.setSysUseYn("N");
        bbsInfoVO.setUseYn("Y");

        bbsInfoVO = bbsInfoService.selectBbsInfoByOldRegDttm(bbsInfoVO);

        if(bbsInfoVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        // 글쓰기 권한 체크
        atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsInfoVO);

        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setLessonScheduleId(StringUtil.nvl(request.getParameter("lessonScheduleId")));
        lessonCntsVO.setLessonCntsId(StringUtil.nvl(request.getParameter("lessonCntsId")));
        lessonCntsVO.setCrsCreCd(StringUtil.nvl(request.getParameter("crsCreCd")));

        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("vo", vo);
        model.addAttribute("templateUrl", TEMPLATE_URL);
        model.addAttribute("lessonVO", lessonService.selectLessonCnts(lessonCntsVO));

        return "bbs/lect/popup/qna_write";
    }

    /*****************************************************
     * 팀 게시판 자동 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/checkAndCreateTeamBbs.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> checkAndCreateTeamBbs(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String teamCd = vo.getTeamCd();

        vo.setOrgId(orgId);
        vo.setRgtrId(userId);

        try {
            if(ValidationUtils.isEmpty(teamCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            BbsInfoVO bbsInfoVO = bbsInfoService.selectTeamBbsInfo(vo);

            if(bbsInfoVO == null) {
                bbsInfoVO = new BbsInfoVO();
                bbsInfoVO.setTeamCd(teamCd);
                bbsInfoVO.setOrgId(orgId);
                bbsInfoVO.setUserId(userId);
                bbsInfoVO = bbsInfoService.insertTeamBbs(vo);
            }

            resultVO.setReturnVO(bbsInfoVO);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
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

    /*****************************************************
     * 조회자 목록 팝업 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/lect/popup/viewer_list_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/popup/viewerList.do")
    public String viewerList(BbsViewVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String atclId = vo.getAtclId();

        if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(atclId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        BbsAtclVO bbsAtclVO = new BbsAtclVO();
        bbsAtclVO.setOrgId(orgId);
        bbsAtclVO.setAtclId(vo.getAtclId());
        bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

        if(bbsAtclVO  == null) {
            // 게시글 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
        }

        int totalCnt = bbsViewService.countBbsView(vo);

        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("totalCnt", totalCnt);
        model.addAttribute("vo", vo);

        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        return "bbs/lect/popup/viewer_list_pop";
    }

    /*****************************************************
     * 조회자 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsViewVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listViewer.do")
    @ResponseBody
    public ProcessResultVO<BbsViewVO> listViewer(BbsViewVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsViewVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String atclId = vo.getAtclId();

        try {
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            vo.setOrgId(orgId);
            List<BbsViewVO> list = bbsViewService.listBbsView(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 조회자 목록 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewerListExcelDown.do")
    public String excelStudentList(BbsViewVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        String atclId = vo.getAtclId();

        // 파라미터 체크
        if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(atclId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        BbsAtclVO bbsAtclVO = new BbsAtclVO();
        bbsAtclVO.setOrgId(orgId);
        bbsAtclVO.setAtclId(atclId);
        bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

        if(bbsAtclVO  == null) {
            // 게시글 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
        }

        // 조회조건
        String[] searchValues = {getMessage("bbs.label.form_title") + " : " + StringUtil.nvl(bbsAtclVO.getAtclTtl())};
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        vo.setOrgId(orgId);
        List<BbsViewVO> list = bbsViewService.listBbsViewStd(vo);

        String title = getMessage("bbs.label.viewr_list"); // 조회자 목록

        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);

        // 엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /*****************************************************
     * 분반 게시글 정보 목록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listDeclsAtcl.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listDeclsAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        String crsCreCd = vo.getCrsCreCd();
        String declsAtclIds = vo.getDvclasRegAtclId();

        try {
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(declsAtclIds)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            String[] sqlForeach = declsAtclIds.split(",");
            vo.setSqlForeach(sqlForeach);

            resultVO.setReturnList(bbsAtclService.listDeclsBbsAtcl(vo));
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
     * 이전 게시글 선택 팝업 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/lect/popup/prev_atcl_list_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/popup/prevAtclList.do")
    public String prevAtclList(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();

        // 강의실 대표교수 정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.selectTchCreCrs(creCrsVO);

        if(creCrsVO == null) {
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_rep_prof")); // 강의실 대표교수 정보를 찾을 수 없습니다.
        }

        String repUserId = creCrsVO.getUserId();

        // 대표교수의 과목이 있는 학기 목록 조회
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO.setCrsCreCd(crsCreCd);
        List<TermVO> termList = termService.listTermByProf(termVO);

        model.addAttribute("vo", vo);
        model.addAttribute("termList", termList);
        model.addAttribute("repUserId", repUserId);

        return "bbs/lect/popup/prev_atcl_list_pop";
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
    public String bbsAtclListView(BbsVO bbsVO, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {

    	String orgId = bbsVO.getOrgId();
    	String bbsTycd = request.getParameter("bbsTycd");
    	String sbjctId = bbsVO.getSbjctId();
    	String returnUrl = "";

    	boolean isAdmin = BbsAuthUtil.isAdmin(request);

		if(ValidationUtils.isEmpty(bbsVO.getBbsTycd())) {
			throw new BadRequestUrlException(getMessage("common.system.error"));
		}

		// 메인페이지의 게시판 메뉴 제외
		String[] suffixArray = {"NTC", "NOTICE", "QNA", "1ON1"};
		List<String> excludeBbsIdList = new ArrayList<>();

		if (orgId != null && !orgId.isEmpty()) {
		    for (String suffix : suffixArray) {
		        excludeBbsIdList.add(orgId + "_" + suffix);
		    }
		}
		bbsVO.setBbsIdList(excludeBbsIdList);

		bbsVO.setOrgId(orgId);
		bbsVO.setBbsTycd(bbsTycd);
		bbsVO.setSbjctId(sbjctId);
		bbsVO = bbsInfoService.isValidBbsLectInfo(bbsVO, isAdmin);

		if(bbsVO == null) { // 게시판 정보를 찾을 수 없습니다.
			bbsVO = new BbsVO();

			bbsVO.setOrgId(userCtx.getOrgId());
			bbsVO.setSbjctId(sbjctId);

			if("NTC".equals(bbsTycd)) {
				bbsVO.setBbsNm("공지사항");
				bbsVO.setBbsEnnm("Notice");
				bbsVO.setBbsExpln("과목 공지사항 게시판");
				bbsVO.setBbsTycd("NTC");

				List<String> optnCdList = new ArrayList<>(); // 공지
				optnCdList.add("NTC");
				bbsVO.setOptnCdList(optnCdList);
			} else if("DATARM".equals(bbsTycd)) {
				bbsVO.setBbsNm("강의자료실");
				bbsVO.setBbsEnnm("Notice");
				bbsVO.setBbsExpln("과목 강의자료실 게시판");
				bbsVO.setBbsTycd("DATARM");

				List<String> optnCdList = new ArrayList<>(); // 공지
				optnCdList.add("NTC");
				bbsVO.setOptnCdList(optnCdList);
			} else if("QNA".equals(bbsTycd)) {
				bbsVO.setBbsNm("강의Q&A");
				bbsVO.setBbsEnnm("Notice");
				bbsVO.setBbsExpln("과목 강의Q&A 게시판");
				bbsVO.setBbsTycd("QNA");

				List<String> optnCdList = new ArrayList<>(); // 공지, 첨부, 댓글
				optnCdList.add("NTC");
				optnCdList.add("RSPNS");
				bbsVO.setOptnCdList(optnCdList);
			} else if("1ON1".equals(bbsTycd)) {
				bbsVO.setBbsNm("1:1상담");
				bbsVO.setBbsEnnm("Notice");
				bbsVO.setBbsExpln("과목 1:1상담 게시판");
				bbsVO.setBbsTycd("1ON1");

				List<String> optnCdList = new ArrayList<>(); // 공지, 첨부, 댓글
				optnCdList.add("RSPNS");
				optnCdList.add("CMNT");
				bbsVO.setOptnCdList(optnCdList);
			}

			bbsVO.setLangCd("ko");
			bbsVO.setUserId(userCtx.getUserId());

			// TB_LMS_BBS 데이터 생성
			bbsInfoService.bbsInfoRegist(bbsVO);
			// TB_LMS_BBS_OPTN 데이터 생성
			bbsInfoService.bbsInfoOptnRegist(bbsVO);
		}

		if(BbsAuthUtil.isStudent(request)) {
            logLessonActnHstyService.saveLessonActnHsty(request, "", CommConst.CONN_BBS, bbsVO.getBbsnm() + " 내용확인");
        }

        // 게시판정보에 파라메터값 재설정 (게시판정보 조회에서 초기화돼서 재설정)
		setEncParamsToVO(bbsVO);

        String atclWriteAuth = "N"; // 글쓰기 권한

        //atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsVO);

        // 파라메터 설정
        addEncParam("bbsId", bbsVO.getBbsId());
        addEncParam("bbsTycd", bbsVO.getBbsTycd());

        // 조회필터옵션 세팅
    	EgovMap filterOptions = bbsFacadeService.loadFilterOptions(userCtx);
    	model.addAttribute("filterOptions", filterOptions);

        if("DATARM".equals(bbsTycd)) {
			returnUrl = "bbs/lect/bbs_lctr_datarm_list_view";
		} else if("QNA".equals(bbsTycd)) {
			returnUrl = "bbs/lect/bbs_lctr_qna_list_view";
		} else if("1ON1".equals(bbsTycd)) {
			returnUrl = "bbs/lect/bbs_dscsn_list_view";
		} else {
			returnUrl = "bbs/lect/bbs_atcl_list_view";
		}

        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return returnUrl;
    }

    /*****************************************************
     * 게시판 게시글 목록조회(Ajax)
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

        String bbsId = request.getParameter("bbsId");
        String upAtclId = request.getParameter("upAtclId");

        String bbsTycd = request.getParameter("bbsTycd");
        if (ValidationUtils.isEmpty(bbsTycd)) {
            bbsTycd = bbsAtclVO.getBbsTycd();
        }

        try {
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setLangCd(langCd);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setBbsTycd(bbsTycd);

            // 게시판 id ',' 구분자로 들어온 경우
			/*
			 * if(ValidationUtils.isNotEmpty(bbsIds)) { List<String> bbsIdList =
			 * Arrays.asList(bbsIds.split(",")); bbsAtclVO.setBbsIdList(bbsIdList);
			 * bbsAtclVO.setBbsId(null); }
			 */
			/* bbsAtclVO.setVwerId(userId); */
            bbsAtclVO.setUpAtclId(upAtclId);
            bbsAtclVO.setAtclLv(1);

            resultVO = bbsAtclService.selectBbsAtclList(bbsAtclVO);
            resultVO.setResult(1);
            resultVO.setEncParams(getEncParams());
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
    public String bbsAtclView(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String atclEditAuth = "Y";      // 글수정 권한
        String atclDeleteAuth  = "Y";   // 글삭제 권한
        String answerWriteAuth = "N";   // 답글쓰기 권한
        String commentWriteAuth = "N";  // 댓글쓰기 권한

		/* String bbsId = bbsAtclVO.getBbsId(); */
        String bbsId = request.getParameter("bbsId");
        if (bbsId == null || bbsId.trim().isEmpty()) {
    	    bbsId = bbsAtclVO.getBbsId();
    	}

        String sbjctId = bbsAtclVO.getSbjctId();
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
		bbsVO.setSbjctId(sbjctId);
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

        //SubjectViewModel subjectVM = new SubjectViewModel();

        BaseParam param = new SubjectParam(bbsVO.getSbjctId(), userCtx, 3);

        // subjectVM = subjectFacadeService.getSubjectViewModel(userCtx, param);
        // model.addAttribute("subjectVM", subjectVM);

        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("atclEditAuth", atclEditAuth);
        model.addAttribute("atclDeleteAuth", atclDeleteAuth);
        model.addAttribute("answerWriteAuth", answerWriteAuth);
        model.addAttribute("commentWriteAuth", commentWriteAuth);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        String url = "bbs/lect/bbs_atcl_view";

        if ("edit".equals(gubun)) {
            bbsAtclVO.setGubun("edit"); // JSP에서 구분하기 위해 값 세팅

            // 첨부파일 저장소 재설정
            bbsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_BBS, bbsId));

            url = "bbs/lect/bbs_atcl_write";
        }

        model.addAttribute("bbsAtclVO", bbsAtclVO);

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
    public String bbsAtclWrite(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        String orgId = userCtx.getOrgId();
        String langCd = userCtx.getLangCd();
        String bbsId = bbsAtclVO.getBbsId();
        String sbjctId = bbsAtclVO.getSbjctId();
        String atclWriteAuth = "Y"; // 글쓰기 권한

        // 게시판 정보 조회
        BbsVO bbsVO = new BbsVO();
        bbsVO.setOrgId(orgId);
        bbsVO.setBbsId(bbsId);
        bbsVO.setSbjctId(sbjctId);
		bbsVO.setLangCd(langCd);
		bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

        if(bbsVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        // 페이지/검색 파라메터 삭제
        delEncParamPageSearch();

        // 첨부파일저장소 설정
        bbsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_BBS, bbsId));

        // 글쓰기 권한 체크
        //atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsVO);

        BaseParam param = new SubjectParam(bbsVO.getSbjctId(), userCtx, 3);

        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/lect/bbs_atcl_write";
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
    public ProcessResultVO<BbsAtclVO> bbsAtclSave(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        boolean isAdmin = BbsAuthUtil.isAdmin(request);
        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String langCd = userCtx.getLangCd();

        String sbjctId = bbsAtclVO.getSbjctId();

        String bbsId = bbsAtclVO.getBbsId();

        String uploadFiles = bbsAtclVO.getUploadFiles();
        String uploadPath = bbsAtclVO.getUploadPath();

        bbsAtclVO.setOrgId(orgId);
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
            bbsVO.setSbjctId(sbjctId);
            bbsVO.setLangCd(langCd);
            bbsVO = bbsInfoService.isValidBbsInfo(bbsVO, isAdmin);

            if(bbsVO == null) {
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
    public String bbsAtclEditWrite(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {

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
            resultVO.setEncParams(getEncParams());
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
    public ProcessResultVO<BbsCmntVO> bbsAtclCmntListAjax(BbsCmntVO bbsCmntVO, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        String orgId = userCtx.getOrgId();
        String userId = userCtx.getUserId();
        String atclId = request.getParameter("atclId");

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
     * 댓글 등록
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
    public ProcessResultVO<BbsCmntVO> bbsAtclCmntDelete(BbsCmntVO bbsCmntVO, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {

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
     * 답변 등록
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
     * 게시판 > 과목공지 > 상세
     * @param bbsAtclVO
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsAtclDtlView.do")
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> bbsAtclDtlView(BbsAtclVO bbsAtclVO, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {

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

    @RequestMapping(value = "/bbsMngListView.do")
    public String bbsMngListView(BbsVO bbsVO, ModelMap model, HttpServletRequest request) throws Exception {

        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/lect/bbs_mng_list_view";
    }

    /*****************************************************
     * 게시판 관리 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsMngList.do")
    @ResponseBody
    public ProcessResultVO<BbsVO> bbsMngListView2(BbsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String langCd = SessionInfo.getLocaleKey(request);

        vo.setOrgId(orgId);
        vo.setLangCd(langCd);

        try {
            resultVO = bbsInfoService.bbsMngList(vo);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 게시글 쓰기
     * @param BbsAtclVO
     * @param model
     * @param request
     * @return "bbs/bbs_atcl_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsMngAdd.do")
    public String bbsMngAdd(BbsVO bbsVO, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {

    	String userId = userCtx.getUserId();
    	bbsVO.setUserId(userId);

        boolean isAdmin = BbsAuthUtil.isAdmin(request);

        setEncParamsToVO(bbsVO);

        String atclWriteAuth = "Y"; // 글쓰기 권한

        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("bbsVO", bbsVO);
        model.addAttribute("templateUrl", TEMPLATE_URL);

        return "bbs/lect/bbs_mng_add";
    }

    /*****************************************************
     * 게시판 관리 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/bbsMngInfoRegist.do")
    @ResponseBody
    public ProcessResultVO<BbsVO> bbsMngInfoRegist(BbsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);

        vo.setOrgId(orgId);
        vo.setRgtrId(userId);

        try {
            bbsInfoService.bbsMngInfoRegist(vo);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

}