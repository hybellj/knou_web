package knou.lms.forum.web;

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

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.SessionBrokenException;
import knou.framework.util.IdGenerator;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.bbs.service.BbsAtclService;
import knou.lms.bbs.service.BbsInfoService;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.bbs.vo.BbsInfoVO;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum.dao.ForumCmntDAO;
import knou.lms.forum.service.ForumAtclService;
import knou.lms.forum.service.ForumCmntService;
import knou.lms.forum.service.ForumJoinUserService;
import knou.lms.forum.service.ForumMutService;
import knou.lms.forum.service.ForumService;
import knou.lms.forum.vo.ForumAtclVO;
import knou.lms.forum.vo.ForumCmntVO;
import knou.lms.forum.vo.ForumJoinUserVO;
import knou.lms.forum.vo.ForumMutVO;
import knou.lms.forum.vo.ForumVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.recom.service.LogRecomService;
import knou.lms.log.recom.vo.LogRecomVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.std.service.StdService;
import knou.lms.team.service.TeamCtgrService;
import knou.lms.team.service.TeamMemberService;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamMemberVO;

@Controller
@RequestMapping(value="/forum/forumHome")
public class ForumHomeController extends ControllerBase {

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    // 토론 정보
    @Resource(name="forumService")
    private ForumService forumService;

    // 토론 게시글
    @Resource(name="forumAtclService")
    private ForumAtclService forumAtclService;

    // 상호평가
    @Resource(name="forumMutService")
    private ForumMutService forumMutService;

    @Resource(name="teamCtgrService")
    private TeamCtgrService teamCtgrService;

    @Resource(name="teamMemberService")
    private TeamMemberService teamMemberService;

    @Resource(name="forumCmntService")
    private ForumCmntService forumCmntService;

    @Resource(name="forumJoinUserService")
    private ForumJoinUserService forumJoinUserService;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="stdService")
    private StdService stdService;

    /** 좋아요,추천 service */
    @Resource(name = "logRecomService")
    private LogRecomService logRecomService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name="bbsInfoService")
    private BbsInfoService bbsInfoService;

    @Resource(name="bbsAtclService")
    private BbsAtclService bbsAtclService;

    @Resource(name="forumCmntDAO")
    private ForumCmntDAO forumCmntDAO;

    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    // 토론 목록 페이지
    @RequestMapping(value="/Form/forumList.do")
    public String forumListForm(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String crsCreCd = vo.getCrsCreCd();

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));
        String auditYn = StringUtil.nvl(SessionInfo.getAuditYn(request));

        model.addAttribute("auditYn", auditYn);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        vo.setUserId(userId);
        vo.setCrsCreCd(crsCreCd);

        String stdNo = forumService.selectStdNo(vo);
        model.addAttribute("gStdNo", stdNo);
        model.addAttribute("crsCreCd", crsCreCd);
        model.addAttribute("userId",userId);
        model.addAttribute("userName",userName);
        model.addAttribute("vo",vo);

        if(!SessionInfo.getAuthrtGrpcd(request).contains("PROF")) {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_FORUM, "토론 목록");
        }

        return "forum/home/forum_list";
    }

    // 토론 목록 가져오기 ajax
    @RequestMapping(value="/forumList.do")
    @ResponseBody
    public ProcessResultVO<ForumVO> formList(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ForumVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        // 현 사용자의 구분(학생, 교수)
        String userType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        vo.setSearchKeyNm(userType);
        vo.setUserId(userId);

        int totalCount = 0;
        int listScale = vo.getListScale();

        if(!"".equals(userId) && ("0".equals(listScale) || listScale == 0)) {
        	totalCount = forumService.count(vo);
        	vo.setListScale(totalCount);
        }

        try {
            resultVO = forumService.list(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            // 오류가 발생했습니다!
            resultVO.setMessage(getMessage("forum.common.error"));
        }

        return resultVO;
    }

    // 학습자 토론방(일반토론)
    @RequestMapping(value = "/Form/forumView.do")
    public String forumView(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        request.setAttribute("tab", request.getParameter("tab"));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));
        String crsCreCd = vo.getCrsCreCd();
        vo.setUserId(userId);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());

        String stdNo = vo.getStdId();

        /*토론정보*/
        vo = forumService.selectForum(vo);

        // 본인의 토론글 등록 갯수
        ForumAtclVO forumAtclVO = new ForumAtclVO();
        forumAtclVO.setForumCd(vo.getForumCd());
        forumAtclVO.setCrsCreCd(crsCreCd);
        forumAtclVO.setUserId(userId);
        int myAtclCnt = forumAtclService.myAtclCnt(forumAtclVO);

        if(!"".equals(StringUtil.nvl(vo.getTeamCtgrCd())) && "Y".equals(StringUtil.nvl(vo.getTeamForumCfgYn()))) {
            TeamMemberVO teamMemberVO = new TeamMemberVO();
            teamMemberVO.setCrsCreCd(crsCreCd);
            teamMemberVO.setUserId(userId);
            teamMemberVO.setTeamCtgrCd(vo.getTeamCtgrCd());

            // 해당 토론의 소속팀 가져오기
            String meTeamNm = teamMemberService.getMeTeamNm(teamMemberVO);
            request.setAttribute("meTeamNm", meTeamNm);

            // 팀 목록 가져오기
            TeamCtgrVO teamCtgrVO = new TeamCtgrVO();
            teamCtgrVO.setTeamCtgrCd(vo.getTeamCtgrCd());
            List<TeamCtgrVO> teamCtgrList = teamCtgrService.teamList(teamCtgrVO);
            request.setAttribute("teamCtgrList", teamCtgrList);
        }

        request.setAttribute("myAtclCnt", myAtclCnt);
        request.setAttribute("userId", userId);
        request.setAttribute("userId", userId);
        request.setAttribute("stdNo", stdNo);
        request.setAttribute("userName", userName);
        request.setAttribute("vo",vo);

        String prosConsForumCfg = vo.getProsConsForumCfg();
        String url = "";
        int count = 0;
        if(prosConsForumCfg.equals("Y")) {
            // 찬반 토론
            forumAtclVO = new ForumAtclVO();
            forumAtclVO.setForumCd(vo.getForumCd());

            //forumCmntVO.setRgtrId(UserBroker.getUserId(request));
            forumAtclVO.setRgtrId(userId);

        	// 토론 작성글 갯수
            count = forumAtclService.forumAtclCount(forumAtclVO);

            url = "forum/home/forum_pc_view";
        } else {
            // 찬반 이외 토론
            url = "forum/home/forum_view";
        }
        request.setAttribute("count", count);

        ForumMutVO forumMutVO = new ForumMutVO();
        forumMutVO.setCrsCreCd(crsCreCd);
        forumMutVO.setUserId(userId);
        forumMutVO.setStdId(userId);
        forumMutVO.setForumCd(vo.getForumCd());

        // 나의 상호평가 결과
        forumMutVO = forumMutService.selectMutResult(forumMutVO);
        request.setAttribute("forumMutVO", forumMutVO);

        if(!SessionInfo.getAuthrtGrpcd(request).contains("PROF")) {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_FORUM, "["+vo.getForumTitle()+"] 토론방 접속");
        }
        return url;
    }

    // 토론 글쓰기 팝업
    @RequestMapping(value = "/forumWritePop.do")
    public String forumWritePop(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        request.setAttribute("tab", request.getParameter("tab"));
        request.setAttribute("type", request.getParameter("type"));

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /* 강의실에서 토론 진입시 교수자이름 */
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        String atclSn = IdGenerator.getNewId("ATCL");

        request.setAttribute("stdNo", SessionInfo.getUserId(request));
        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName);
        request.setAttribute("atclSn", atclSn);

        request.setAttribute("forumVo",vo);

        return "forum/home/forumWritePop";
    }

    // 토론방 글 등록 ajax
    @RequestMapping(value = "/Form/addAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addAtcl(ForumVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String prosConsTypeCd = request.getParameter("prosConsTypeCd");
        String atclTypeCd = request.getParameter("atclTypeCd");
        String cts = request.getParameter("cts");
        String crsCreCd = vo.getCrsCreCd();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /* 강의실에서 토론 진입시 교수자이름 */
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        // 로그인 체크
        if(ValidationUtils.isEmpty(userId)) {
            // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            throw new SessionBrokenException(getMessage("common.system.no_auth"));
        }

        // String userType = "CLASS_PROFESSOR";
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String atclOdr = request.getParameter("atclOdr");

        ForumAtclVO forumAtclVO = new ForumAtclVO();
        forumAtclVO.setForumCd(vo.getForumCd());
        forumAtclVO.setAtclSn(IdGenerator.getNewId("ATCL"));
        forumAtclVO.setProsConsTypeCd(prosConsTypeCd);
        forumAtclVO.setAtclTypeCd(atclTypeCd);
        forumAtclVO.setCts(cts);
        forumAtclVO.setCrsCreCd(vo.getCrsCreCd());
        // forumAtclVO.setAttachFileSns(forumVO.getAttachFileSns());

        // forumCmntVO.setRgtrId(UserBroker.getUserId(request));
        forumAtclVO.setRgtrId(userId);
        forumAtclVO.setRgtrnm(userName);
        forumAtclVO.setMdfrId(userId);
        forumAtclVO.setStdId(userId);
        forumAtclVO.setUserId(userId);

        forumAtclVO.setUploadFiles(vo.getUploadFiles());
        forumAtclVO.setUploadPath(vo.getUploadPath());
        forumAtclVO.setRepoCd(vo.getRepoCd());

        if(userType.equals("CLASS_LEARNER")) {
            forumAtclVO.setAtclOdr(Integer.parseInt(atclOdr));
        } else {
            forumAtclVO.setAtclOdr(0);
        }

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            forumAtclService.insertAtcl(forumAtclVO);
            if(!SessionInfo.getAuthrtGrpcd(request).contains("PROF")) {
                // 강의실 활동 로그 등록
                ForumVO fvo = forumService.select(vo);
                logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_FORUM, "["+fvo.getForumTitle()+"] 토론 글 작성");
            }
            returnVo.setResult(1);
        } catch(Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }
        return returnVo;
    }

    // 토론방 리스트 ajax
    @RequestMapping(value = "/Form/forumBbsViewList.do")
    @ResponseBody
    public ProcessResultVO<ForumAtclVO> forumBbsViewList(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ForumAtclVO> resultVO = new ProcessResultVO<>();

        String stdList = vo.getStdList();
        String crsCreCd = vo.getCrsCreCd();
        String forumCd = vo.getForumCd();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            // 토론 정보 조회
            ForumVO forumVO = new ForumVO();
            forumVO.setForumCd(forumCd);
            forumVO = forumService.select(forumVO);

            if("Y".equals(StringUtil.nvl(forumVO.getOtherViewYn()))) {
                // 참여글 체크
                ForumAtclVO forumAtclVO = new ForumAtclVO();
                forumAtclVO.setCrsCreCd(crsCreCd);
                forumAtclVO.setForumCd(forumCd);
                forumAtclVO.setUserId(userId);
                int joinCnt = forumAtclService.myAtclCnt(forumAtclVO);

                if(joinCnt == 0) {
                    PagingInfo pagingInfo = new PagingInfo();
                    pagingInfo.setCurrentPageNo(vo.getPageIndex());
                    pagingInfo.setRecordCountPerPage(vo.getListScale());
                    pagingInfo.setPageSize(vo.getPageScale());
                    pagingInfo.setTotalRecordCount(0);

                    resultVO.setPageInfo(pagingInfo);
                    resultVO.setResult(1);
                    return resultVO;
                }
            }

            /* 토론 게시글 */
            ForumAtclVO forumAtclVO = new ForumAtclVO();
            forumAtclVO.setForumCd(vo.getForumCd());
            forumAtclVO.setStdList(stdList);
            forumAtclVO.setSearchValue(vo.getSearchValue());
            forumAtclVO.setPageIndex(vo.getPageIndex());
            // int listScale = 2; //forumAtclVO.getListScale()
            forumAtclVO.setListScale(vo.getListScale());
            forumAtclVO.setCrsCreCd(crsCreCd);
            // forumAtclVO.setForumCtgrCd(vo.getForumCtgrCd());

            // 팀토론일 경우 팀원 목록 가져오기
            if("TEAM".equals(vo.getForumCtgrCd())) {
                TeamMemberVO teamMemberVO = new TeamMemberVO();
                teamMemberVO.setCrsCreCd(crsCreCd);
                teamMemberVO.setUserId(userId);
                teamMemberVO.setTeamCtgrCd(vo.getTeamCtgrCd());

                if(!"".equals(StringUtil.nvl(vo.getTeamNm()))) {
                    teamMemberVO.setTeamNm(StringUtil.nvl(vo.getTeamNm()));
                } else {
                    // 해당 토론의 소속팀 가져오기
                    String meTeamNm = teamMemberService.getMeTeamNm(teamMemberVO);
                    teamMemberVO.setTeamNm(meTeamNm);
                }

                // 팀원 리스트
                String[] teamMemberList = teamMemberService.getTeamMemberList(teamMemberVO);
                int i = 0;
                String stdMemberList = "";
                for(String stdNo : teamMemberList) {
                    if(i == 0) {
                        stdMemberList += stdNo;
                    } else {
                        stdMemberList += ","+ stdNo;
                    }
                    i++;
                }
                forumAtclVO.setStdList(stdMemberList);
            }

            resultVO = forumAtclService.listPageing(forumAtclVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 팀 구성원 보기
    @RequestMapping(value = "/teamMemberList.do")
    public String teamMemberList(TeamCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));
    	String student = (SessionInfo.getAuthrtGrpcd(request).contains("USR")) ? "STD" : "";
    	request.setAttribute("student", student);

		TeamMemberVO teamMemberVO = new TeamMemberVO();
		teamMemberVO.setUserId(userId);
		teamMemberVO.setTeamCtgrCd(vo.getTeamCtgrCd());

		// 해당 토론의 소속팀 가져오기
		String meTeamNm = teamMemberService.getMeTeamNm(teamMemberVO);
		request.setAttribute("meTeamNm", meTeamNm);

        List<TeamCtgrVO> teamCtgrList = teamCtgrService.teamList(vo);
        request.setAttribute("teamCtgrList", teamCtgrList);

        return "forum/popup/team_member_list_pop";
    }

    // 토론 상호평가 팝업
    @RequestMapping(value = "/evalStar.do")
    public String evalStarPop(ForumMutVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String mutSn = vo.getMutSn();
        String userId = vo.getUserId();

        request.setAttribute("mutSn", mutSn);

        if(mutSn != null && !mutSn.equals("")) {
            vo = forumMutService.selectMut(vo);
            vo.setUserId(userId);
            vo.setMutSn(mutSn);
        }

        request.setAttribute("vo", vo);
        vo.setUserId(userId);

        List<ForumAtclVO> atclUserList = forumAtclService.selectAtclUserList(vo);

        request.setAttribute("atclUserList", atclUserList);

        return "forum/home/evalStar";
    }

    // 토론 등록 폼
    @RequestMapping(value = "/Form/forumAdd.do")
    public String addForum(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName);

        request.setAttribute("forumVo", forumVO);

        // 강의실 > 학습요소 추가 > 이전 데이터 가져오기
        String gubun =  StringUtil.nvl(request.getParameter("gubun"));
        request.setAttribute("gubun", gubun);

        return "forum/lect/forum_add";
    }

    @RequestMapping(value = "/myAtclCount.do")
    @ResponseBody
    public ProcessResultVO<ForumVO> myAtclCount(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ForumVO> resultVO = new ProcessResultVO<>();
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String forumCd = vo.getForumCd();
        String crsCreCd = vo.getCrsCreCd();

        try {
            ForumAtclVO forumAtclVO = new ForumAtclVO();
            forumAtclVO.setCrsCreCd(crsCreCd);
            forumAtclVO.setForumCd(forumCd);
            forumAtclVO.setUserId(userId);
            int count = forumAtclService.myAtclCnt(forumAtclVO);

            ForumVO forumVO = new ForumVO();
            forumVO.setTotalCnt(count);

            resultVO.setReturnVO(forumVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 토론방 댓글 등록
    @RequestMapping(value = "/Form/addCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addCmnt(ForumVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String atclSn = request.getParameter("atclSn");
        String ansReqYn = request.getParameter("ansReqYn");
        String parCmntSn = request.getParameter("parCmntSn");
        String cmntCts = request.getParameter("cmntCts");
        String crsCreCd = request.getParameter("crsCreCd");
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        /* 강의실에서 토론 진입시 교수자이름 */
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        ForumCmntVO forumCmntVO = new ForumCmntVO();
        forumCmntVO.setCmntSn(IdGenerator.getNewId("CMNT"));
        if(parCmntSn == null || parCmntSn.equals("")) {
            forumCmntVO.setParCmntSn(null);
        } else {
            forumCmntVO.setParCmntSn(parCmntSn);
        }
        forumCmntVO.setForumCd(vo.getForumCd());
        forumCmntVO.setAtclSn(atclSn);
        forumCmntVO.setAnsReqYn(ansReqYn);
        forumCmntVO.setCmntCts(cmntCts);
        forumCmntVO.setCrsCreCd(vo.getCrsCreCd());

        // forumCmntVO.setRgtrId(UserBroker.getUserId(request));
        forumCmntVO.setRgtrId(userId);
        forumCmntVO.setRgtrnm(userName);
        forumCmntVO.setMdfrId(userId);
        forumCmntVO.setStdId(userId);

        // String userType = SessionInfo.getUserType(request)
        String userType = "CLASS_PROFESSOR";
        if(userType.equals("CLASS_LEARNER")) {
            // forumCmntVO.setStdId(UserBroker.getStdId(request));
            forumCmntVO.setStdId("");
        }

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            forumCmntService.insertCmnt(forumCmntVO);
            // 답변 요청 체크시 QnA 게시판에 등록
            String orgId = SessionInfo.getOrgId(request);
            if("Y".equals(forumCmntVO.getAnsReqYn())) {
                BbsInfoVO bbsInfoVO = new BbsInfoVO();
                bbsInfoVO.setCrsCreCd(crsCreCd);
                bbsInfoVO.setOrgId(orgId);
                bbsInfoVO.setBbsId("QNA");
                bbsInfoVO.setSysDefaultYn("Y");
                bbsInfoVO.setSysUseYn("N");

                bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

                if(bbsInfoVO != null) {
                    int cmntCtsLen = 0;

                    if(!"".equals(StringUtil.nvl(cmntCts))) {
                        cmntCtsLen = cmntCts.length();
                    }

                    // 최대 20자
                    if(cmntCtsLen > 20) {
                        cmntCtsLen = 20;
                    }

                    BbsAtclVO feedBackAtclVO = new BbsAtclVO();
                    feedBackAtclVO.setCrsCreCd(crsCreCd);
                    feedBackAtclVO.setBbsId(bbsInfoVO.getBbsId());
                    feedBackAtclVO.setAtclTtl(StringUtil.substring(cmntCts, 0, cmntCtsLen));
                    feedBackAtclVO.setAtclCts(cmntCts);
                    feedBackAtclVO.setRgtrId(userId);

                    bbsAtclService.insertBbsAtcl(feedBackAtclVO);
                }
            }

            if(!SessionInfo.getAuthrtGrpcd(request).contains("PROF")) {
                // 강의실 활동 로그 등록
                ForumVO fvo = forumService.select(vo);
                logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_FORUM, "["+fvo.getForumTitle()+"] 토론 댓글 작성");
            }
            returnVo.setResult(1);
        } catch(Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }
        return returnVo;
    }

    // 토론방 수정 팝업
    @RequestMapping(value = "/Form/editForumBbs.do")
    public String editForumBbs(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        request.setAttribute("tab", request.getParameter("tab"));
        request.setAttribute("type", request.getParameter("type"));
        String atclSn = request.getParameter("atclSn");

      String userId = StringUtil.nvl(SessionInfo.getUserId(request));
      /* 강의실에서 토론 진입시 교수자이름 */
      String userName =StringUtil.nvl(SessionInfo.getUserNm(request));

      request.setAttribute("userId", userId);
      request.setAttribute("userName", userName);

      if(!"".equals(StringUtil.nvl(atclSn))) {
          ForumAtclVO forumAtclVO = new ForumAtclVO();
          forumAtclVO.setAtclSn(atclSn);
          forumAtclVO.setForumCd(vo.getForumCd());
          forumAtclVO = forumAtclService.selectAtcl(forumAtclVO);
          request.setAttribute("forumAtclVO",forumAtclVO);

          FileVO fileVO = new FileVO();
          fileVO.setRepoCd("FORUM");
          fileVO.setFileBindDataSn(atclSn);
          ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);
          for(FileVO fvo : fileList.getReturnList()) {
              fvo.setFileId((fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf("."))));
          }
          request.setAttribute("fileList", fileList.getReturnList());
      }
      request.setAttribute("forumVo",  vo);
      request.setAttribute("atclSn",  atclSn);

      return "forum/home/forumWritePop";
    }

    // 토론방 글  수정 ajax
    @RequestMapping(value = "/Form/editAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editAtcl(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String atclSn = request.getParameter("atclSn");
        String cts = request.getParameter("cts");
        String crsCreCd = vo.getCrsCreCd();

        /* 강의실에서 토론 진입시 교수자정보 */
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        // 로그인 체크
        if(ValidationUtils.isEmpty(userId)) {
            // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            throw new SessionBrokenException(getMessage("common.system.no_auth"));
        }

        String prosConsTypeCd = request.getParameter("prosConsTypeCd");

        ForumAtclVO forumAtclVO = new ForumAtclVO();
        forumAtclVO.setForumCd(vo.getForumCd());
        forumAtclVO.setProsConsTypeCd(prosConsTypeCd);
        forumAtclVO.setAtclSn(atclSn);
        forumAtclVO.setCts(cts);
        forumAtclVO.setUploadFiles(vo.getUploadFiles());
        forumAtclVO.setUploadPath(vo.getUploadPath());
        forumAtclVO.setRepoCd(vo.getRepoCd());
        forumAtclVO.setDelFileIds(vo.getDelFileIds());
        forumAtclVO.setRgtrId(userId);
        forumAtclVO.setMdfrId(userId);

        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));

        if(userType.equals("CLASS_LEARNER")) {
            forumAtclVO.setStdId(SessionInfo.getStdNo(request));
        }

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            forumAtclService.updateAtcl(forumAtclVO);
            if(!SessionInfo.getAuthrtGrpcd(request).contains("PROF")) {
                // 강의실 활동 로그 등록
                ForumVO fvo = forumService.select(vo);
                logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_FORUM, "["+fvo.getForumTitle()+"] 토론 글 수정");
            }
            returnVo.setResult(1);
        } catch(Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }
        return returnVo;
    }

    // 토론방 게시글  삭제 ajax
    @RequestMapping(value = "/Form/delAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delAtcl(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String atclSn = request.getParameter("atclSn");

        /* 강의실에서 토론 진입시 교수자정보 */
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String crsCreCd = vo.getCrsCreCd();

        ForumAtclVO forumAtclVO = new ForumAtclVO();
        forumAtclVO.setForumCd(vo.getForumCd());
        forumAtclVO.setAtclSn(atclSn);

        // forumCmntVO.setRgtrId(UserBroker.getUserId(request));
        forumAtclVO.setMdfrId(userId);

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            forumAtclService.deleteAtcl(forumAtclVO);
            if(!SessionInfo.getAuthrtGrpcd(request).contains("PROF")) {
                // 강의실 활동 로그 등록
                ForumVO fvo = forumService.select(vo);
                logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_FORUM, "["+fvo.getForumTitle()+"] 토론 글 삭제");
            }
            returnVo.setResult(1);
        } catch(Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }
        return returnVo;
    }

    // 토론방 댓글 수정
    @RequestMapping(value="/Form/editCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editCmnt(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String cmntSn = request.getParameter("cmntSn");
        String cmntCts = request.getParameter("cmntCts");
        String ansReqYn = request.getParameter("ansReqYn");
        String crsCreCd = vo.getCrsCreCd();

        ForumCmntVO forumCmntVO = new ForumCmntVO();
        forumCmntVO.setCmntSn(cmntSn);
        forumCmntVO.setCmntCts(cmntCts);
        forumCmntVO.setAnsReqYn(ansReqYn);
        // String userType = UserBroker.getClassUserType(request);
         String userType = "";
         if(userType.equals("CLASS_LEARNER")) {
             // forumCmntVO.setStdId(UserBroker.getStdId(request));
             forumCmntVO.setStdId("");
         }

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            forumCmntService.updateCmnt(forumCmntVO);
            if(!SessionInfo.getAuthrtGrpcd(request).contains("PROF")) {
                // 강의실 활동 로그 등록
                ForumCmntVO fcvo = forumCmntService.forumCmntSelect(forumCmntVO);
                ForumVO fvo = new ForumVO();
                fvo.setForumCd(fcvo.getForumCd());
                fvo = forumService.select(fvo);
                logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_FORUM, "["+fvo.getForumTitle()+"] 토론 댓글 수정");
            }
            returnVo.setResult(1);
        } catch(Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }
        return returnVo;
    }

    // 토론방 댓글 삭제
    @RequestMapping(value = "/Form/delCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delCmnt(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String cmntSn = request.getParameter("cmntSn");
        String crsCreCd = vo.getCrsCreCd();

        ForumCmntVO forumCmntVO = new ForumCmntVO();
        forumCmntVO.setCmntSn(cmntSn);

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            forumCmntService.deleteCmnt(forumCmntVO);
            if(!SessionInfo.getAuthrtGrpcd(request).contains("PROF")) {
                // 강의실 활동 로그 등록
                ForumCmntVO fcvo = forumCmntService.forumCmntSelect(forumCmntVO);
                ForumVO fvo = new ForumVO();
                fvo.setForumCd(fcvo.getForumCd());
                fvo = forumService.select(fvo);
                logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_FORUM, "["+fvo.getForumTitle()+"] 토론 댓글 삭제");
            }
            returnVo.setResult(1);
        } catch(Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }
        return returnVo;
    }

    // 평가 대상자 목록 ajax
    @RequestMapping(value = "/forumJoinUserList.do")
    @ResponseBody
    public ProcessResultVO<ForumJoinUserVO> forumJoinUserLst(ForumJoinUserVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ForumJoinUserVO> resultVO = new ProcessResultVO<>();
        Locale locale = LocaleUtil.getLocale(request);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setUserId(userId);
            List<ForumJoinUserVO> list = forumJoinUserService.list(vo);

            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("forum.common.error", null, locale)); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    // 상호평가 등록 ajax
    @RequestMapping(value = "/forumMutInsert.do")
    @ResponseBody
    public ProcessResultVO<ForumMutVO> forumMutInsert(ForumMutVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ForumMutVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String mutSn = vo.getMutSn();

        vo.setMutSn(mutSn);
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);

        try {
            if(mutSn != null && !mutSn.equals("")) { // 수정
                mutSn = vo.getMutSn();
                forumMutService.forumMutUpdate(vo);
            } else {
                // 등록
                mutSn = IdGenerator.getNewId("MUT");
                vo.setMutSn(mutSn);
                // 참여자가 없을 때 토론 참여자 테이블 삽입
                forumJoinUserService.chkStdNoInsert(vo);
                forumMutService.forumMutInsert(vo);
            }

            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 학습자 찬반토론 토론글 리스트
    @RequestMapping(value = "/forumStuViewList.do")
    public String forumStuViewList(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String crsCreCd = vo.getCrsCreCd();
        String forumCd = vo.getForumCd();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String viewYn = "Y";

        vo.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));

        // 토론정보 조회
        ForumVO forumVO = forumService.selectForum(vo);
        forumVO.setCrsCreCd(crsCreCd);

        String otherViewYn = forumVO.getOtherViewYn();

        if("Y".equals(StringUtil.nvl(otherViewYn))) {
            // 참여글 체크
            ForumAtclVO forumAtclVO = new ForumAtclVO();
            forumAtclVO.setCrsCreCd(crsCreCd);
            forumAtclVO.setForumCd(forumCd);
            forumAtclVO.setUserId(userId);
            int joinCnt = forumAtclService.myAtclCnt(forumAtclVO);

            if(joinCnt == 0) {
                viewYn = "N";
            }
        }

        if("Y".equals(viewYn)) {
            // 토론 게시글
            ForumAtclVO forumAtclVO = new ForumAtclVO();
            forumAtclVO.setForumCd(forumCd);
            forumAtclVO.setStdId(userId);
            forumAtclVO.setRgtrId(userId);
            List<ForumAtclVO> forumAtclList = forumAtclService.forumAtclList(forumAtclVO);

            List<ForumCmntVO> cmntList = null;
            if(forumAtclList != null) {
                for(ForumAtclVO vo1 : forumAtclList) {
                    cmntList = forumCmntDAO.cmntList(vo1);
                    vo1.setCmntList(cmntList);
                }
            }

            model.addAttribute("forumAtclList", forumAtclList);
        }

        model.addAttribute("userId", userId);
        model.addAttribute("forumVo", forumVO);
        model.addAttribute("viewYn", viewYn);

        return "forum/home/forum_pc_view_list";
    }

    // 사용자 게시글 좋아요/추천
    @RequestMapping(value = "/Form/recom.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> recom(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String atclSn = request.getParameter("atclSn");
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String recomStatus =  forumVO.getRecomStatus();

        LogRecomVO logRecomVO = new LogRecomVO();
        logRecomVO.setRecomCd(IdGenerator.getNewId("RECOM"));
        logRecomVO.setRltnType("FORUM");
        logRecomVO.setRltnCd(atclSn);
        logRecomVO.setRgtrId(userId);

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {

            if(recomStatus.equals("N")) {
                logRecomService.insert(logRecomVO);
            } else {
                logRecomService.delete(logRecomVO);
            }
            returnVo.setResult(1);

        } catch(Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }
        return returnVo;
    }

    // 사용자 게시글 리스트
    @RequestMapping(value = "/atclList.do")
    @ResponseBody
    public ProcessResultVO<ForumAtclVO> atclList(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);
        ProcessResultVO<ForumAtclVO> returnVo = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            ForumAtclVO forumAtclVO = new ForumAtclVO();
            forumAtclVO.setForumCd(forumVO.getForumCd());
            forumAtclVO.setRgtrId(userId);

            List<ForumAtclVO> forumAtclList = forumAtclService.forumAtclList(forumAtclVO);

            returnVo.setReturnList(forumAtclList);
            returnVo.setResult(1);
        } catch(Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }

        return returnVo;
    }

    /*****************************************************
     * 상호평가 내역 보기 팝업
     * @param  ForumMutVO
     * @return "forum/popup/stu_forum_mut_eval_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/mutEvalViewPop.do")
    public String mutEvalViewPop(ForumMutVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        model.addAttribute("vo", vo);

        return "forum/popup/stu_forum_mut_eval_view_pop";
    }
}
