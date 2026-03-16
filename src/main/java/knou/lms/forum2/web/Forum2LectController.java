package knou.lms.forum2.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import java.util.List;
import java.util.Locale;

import knou.framework.common.CommConst;
import knou.framework.common.RepoInfo;
import knou.framework.util.LocaleUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.forum.web.ForumLectController;
import knou.lms.forum2.service.impl.ForumServiceImpl;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.team.service.TeamCtgrService;
import knou.lms.team.service.TeamMemberService;
import knou.lms.team.service.TeamService;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.team.vo.TeamVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.service.ForumAtclService;
import knou.lms.forum2.service.ForumCmntService;
import knou.lms.forum2.service.ForumService;
import knou.lms.forum.vo.ForumAtclVO;
import knou.lms.forum.vo.ForumCmntVO;
import knou.lms.forum.vo.ForumVO;
import knou.lms.forum2.vo.Forum2ListVO;
import knou.lms.forum2.vo.Forum2VO;

@Controller
@RequestMapping(value = "/forum2/forumLect")
public class Forum2LectController extends ControllerBase {
    private static final Logger LOGGER = LoggerFactory.getLogger(ForumLectController.class);

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name = "forum2Service")
    private ForumService forumService;
    @Resource(name = "forum2AtclService")
    private ForumAtclService forum2AtclService;
    @Resource(name = "forum2CmntService")
    private ForumCmntService forum2CmntService;
    @Resource(name = "sysFileService")
    private SysFileService sysFileService;

    @Resource(name="teamService")
    private TeamService teamService;

    @Resource(name="teamCtgrService")
    private TeamCtgrService teamCtgrService;

    @Resource(name="teamMemberService")
    private TeamMemberService teamMemberService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    private String test_sbjctId = "SBJCT_OFRNG_ID1";
    private String test_lrnGrpId = "LRN_GRP_01";
    private String test_DscsId = "DSCS_bdjqfhfbhij34db3e2d";

    /**
     * 토론목록화면이동
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumListView.do")
    public String profForumListView(Forum2ListVO forum2ListVO, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        // TODO : Test Code 값 추후 수정 예정.(setSbjctId, setLrnGrpId)
        // - 필수값 체크 : 과목 ID 가 없을 경우 (잘못된 접근)
        forum2ListVO.setSbjctId(test_sbjctId);
        forum2ListVO.setLrnGrpId("LRN_GRP_01");

        model.addAttribute("forum2ListVO", forum2ListVO);

        return "forum2/lect/prof_forum_list_view";
    }

    /**
     * 토론작성화면이동
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumWriteView.do")
    public String profForumWriteView(Forum2VO forum2VO, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        // TODO : Test Code 값 추후 수정 예정.(setSbjctId, setLrnGrpId)
        model.addAttribute("sbjctId", test_sbjctId);
        model.addAttribute("lrnGrpId", test_lrnGrpId);

        // TODO : Test Code 값 추후 수정 예정.(setSbjctId, setLrnGrpId)
        forum2VO.setSbjctId(test_sbjctId);
        List<Forum2VO> dvclasList = forumService.selectForumDvclasList(forum2VO);
        model.addAttribute("dvclasList", dvclasList);

        forum2VO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));
        // 등록 or 수정 구분 - I : 등록, E : 수정
        model.addAttribute("mode", "I");
        model.addAttribute("forum2VO", forum2VO);

        setCommonSessionValue(forum2VO, request);

        return "forum2/lect/prof_forum_write_view";
    }

    /**
     * 토론목록조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumList.do")
    @ResponseBody
    public ProcessResultVO<Forum2ListVO> profForumList(Forum2ListVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2ListVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        // 현 사용자의 구분(학생, 교수)
        String userType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        vo.setSearchKeyNm(userType);
        vo.setUserId(userId);

        try {
            setCommonSessionValue(vo, request);
            resultVO = forumService.selectForumList(vo);
            if (resultVO.getResult() == 0) {
                resultVO.setResultSuccess();
            }
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론저장
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumRegist.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> profForumRegist(Forum2VO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            setCommonSessionValue(vo, request);
            resultVO = forumService.saveForum(vo);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
            resultVO.setResultSuccess();
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론수정화면이동
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumEditView.do")
    public String profForumEditView(Forum2VO forum2VO, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        // 등록 or 수정 구분 - I : 등록, E : 수정
        model.addAttribute("mode", "E");

        if (!StringUtil.isNull(forum2VO.getDscsId())) {
            setCommonSessionValue(forum2VO, request);

            forum2VO = forumService.selectForum(forum2VO);
            // 첨부파일저장소 설정
            forum2VO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

            model.addAttribute("forum2VO", forum2VO);
        }

        return "forum2/lect/prof_forum_write_view";
    }

    /**
     * 토론수정
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumModify.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> profForumModify(Forum2VO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            setCommonSessionValue(vo, request);
            resultVO = forumService.saveForum(vo);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
            resultVO.setResultSuccess();
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론 성적공개여부 수정
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumMrkOynModify.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> profForumMrkOynModify(Forum2VO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            if (StringUtil.isNull(vo.getDscsId())) {
                resultVO.setResultFailed("dscsId is required");
                return resultVO;
            }

            String mrkOyn = StringUtil.nvl(vo.getMrkOyn());
            if (StringUtil.isNull(mrkOyn)) {
                mrkOyn = StringUtil.nvl(request.getParameter("mrkOyn"));
            }
            mrkOyn = mrkOyn.toUpperCase();

            if (!"Y".equals(mrkOyn) && !"N".equals(mrkOyn)) {
                resultVO.setResultFailed("수정 중 에러가 발생하였습니다.");
                return resultVO;
            }

            vo.setMrkOyn(mrkOyn);
            resultVO = forumService.modifyForumMrkOyn(vo);
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론 성적반영비율 수정
     * @param list
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/forumMrkRfltrtModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> forumMrkRfltrtModifyAjax(@RequestBody List<Forum2VO> list, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            for (Forum2VO vo : list) {
                vo.setMdfrId(userId);
            }
            forumService.updateForumMrkRfltrt(list);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }
    
    /**
     * 토론삭제
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumDelete.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> profForumDelete(@RequestBody Forum2VO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            setCommonSessionValue(vo, request);
            resultVO = forumService.deleteForum(vo);
            if (resultVO.getResult() == 0) {
                resultVO.setResultSuccess();
            }
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론복사
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumCopy.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> profForumCopy(Forum2VO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            setCommonSessionValue(vo, request);

            if (StringUtil.isNull(vo.getSourceDscssId())) {
                resultVO.setResultFailed("sourceDscssId is required");
                return resultVO;
            }

            resultVO = forumService.copyForum(vo);
            if (resultVO.getResult() == 0) {
                resultVO.setResultSuccess();
            }
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론방
     * @param vo
     * @param request
     */
    @RequestMapping(value = "/Form/bbsManage.do")
    public String bbsManage(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        Forum2VO param = new Forum2VO();
        // TODO : 26.3.10(AS-IS Listform parameter 를 vo 로 넘김(
        /*
        // Ref.>lect/form_list.jsp
        <form name="forumListForm" id="forumListForm" action="" method="POST">
            <input type="hidden" id="forumCd" name="forumCd" />
            <input type="hidden" id="crsCreCd" name="crsCreCd" value="${forumVO.crsCreCd}"/>
            <input type="hidden" id="userId" name="userId" value="${userId}"/>
            <input type="hidden" id="userName" name="userName" value="${userName}"/>
            <input type="hidden" id="mode" name="mode" value="L"/>
        </form>
         */
        /*

        ProcessResultVO<Forum2VO> forumRs = forumService.selectForum(param);
        Forum2VO dscs = forumRs.getReturnVO();
        */
        // TODO : 26.3.10 test value 삭제 예정.
//        param.setDscsId(test_DscsId);
        param.setDscsId(forumVO.getForumCd());
        Forum2VO tempForum2VO = forumService.selectForum(param);
        forumVO = convertForum2VOtoForumVO(tempForum2VO) ;

        // 첨부파일저장소 설정
        forumVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", forumVO.getCrsCreCd());
        model.addAttribute("userId", StringUtil.nvl(SessionInfo.getUserId(request)));
        model.addAttribute("userName", StringUtil.nvl(SessionInfo.getUserNm(request)));
        model.addAttribute("forumVo", forumVO);

        return "forum2/lect/forum_bbs_manage";
    }

    @RequestMapping(value = "/Form/forumBbsViewList.do")
    @ResponseBody
    public ProcessResultVO<ForumAtclVO> forumBbsViewList(ForumVO forumVO, HttpServletRequest request) throws Exception {
        ForumAtclVO forumAtclVO = new ForumAtclVO();
        forumAtclVO.setForumCd(forumVO.getForumCd());
        forumAtclVO.setSearchValue(forumVO.getSearchValue());
        forumAtclVO.setPageIndex(forumVO.getPageIndex());
        forumAtclVO.setListScale(forumVO.getListScale());
        forumAtclVO.setCrsCreCd(forumVO.getCrsCreCd());

        ProcessResultVO<ForumAtclVO> resultVO = new ProcessResultVO<>();
        try {
            resultVO = forum2AtclService.listPageing(forumAtclVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    @RequestMapping(value = "/Form/addForumBbs.do")
    public String addForumBbs(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));
        String atclSn = IdGenerator.getNewId("ATCL");
        model.addAttribute("userId", userId);
        model.addAttribute("userName", userName);
        model.addAttribute("atclSn", atclSn);
        model.addAttribute("forumVo", forumVO);
        return "forum2/lect/forum_bbs_view_write";
    }

    @RequestMapping(value = "/Form/editForumBbs.do")
    public String editForumBbs(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        String atclSn = request.getParameter("atclSn");
        ForumAtclVO forumAtclVO = new ForumAtclVO();
        forumAtclVO.setForumCd(forumVO.getForumCd());
        forumAtclVO.setAtclSn(atclSn);
        forumAtclVO = forum2AtclService.selectAtcl(forumAtclVO);

        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("FORUM");
        fileVO.setFileBindDataSn(atclSn);
        ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);

        model.addAttribute("fileList", fileList.getReturnList());
        model.addAttribute("atclSn", atclSn);
        model.addAttribute("forumVo", forumVO);
        model.addAttribute("forumAtclVO", forumAtclVO);
        model.addAttribute("userId", StringUtil.nvl(SessionInfo.getUserId(request)));
        model.addAttribute("userName", StringUtil.nvl(SessionInfo.getUserNm(request)));
        return "forum2/lect/forum_bbs_view_write";
    }

    @RequestMapping(value = "/Form/addAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addAtcl(ForumVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();


        String atclSn = IdGenerator.getNewId("ATCL");

        try {
            String userId = StringUtil.nvl(SessionInfo.getUserId(request));

            ForumAtclVO forumAtclVO = new ForumAtclVO();
            forumAtclVO.setForumCd(vo.getForumCd());
            forumAtclVO.setAtclSn(atclSn);
            forumAtclVO.setProsConsTypeCd(request.getParameter("prosConsTypeCd"));
            forumAtclVO.setAtclTypeCd(request.getParameter("atclTypeCd"));
            forumAtclVO.setCts(request.getParameter("cts"));
            forumAtclVO.setTitle("");
            forumAtclVO.setCrsCreCd(vo.getCrsCreCd());
            forumAtclVO.setRgtrId(userId);
            forumAtclVO.setMdfrId(userId);
            forumAtclVO.setUserId(userId);
            forumAtclVO.setAtclOdr(0);
            forumAtclVO.setUploadFiles(vo.getUploadFiles());
            forumAtclVO.setUploadPath(vo.getUploadPath());
            forumAtclVO.setRepoCd(vo.getRepoCd());
            forum2AtclService.insertAtcl(forumAtclVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    @RequestMapping(value = "/Form/editAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editAtcl(ForumVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            String userId = StringUtil.nvl(SessionInfo.getUserId(request));
            ForumAtclVO forumAtclVO = new ForumAtclVO();
            forumAtclVO.setForumCd(vo.getForumCd());
            forumAtclVO.setAtclSn(request.getParameter("atclSn"));
            forumAtclVO.setProsConsTypeCd(request.getParameter("prosConsTypeCd"));
            forumAtclVO.setCts(request.getParameter("cts"));
            forumAtclVO.setTitle("");
            forumAtclVO.setMdfrId(userId);
            forumAtclVO.setUserId(userId);
            forumAtclVO.setUploadFiles(vo.getUploadFiles());
            forumAtclVO.setUploadPath(vo.getUploadPath());
            forumAtclVO.setRepoCd(vo.getRepoCd());
            forum2AtclService.updateAtcl(forumAtclVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    @RequestMapping(value = "/Form/delAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delAtcl(ForumVO forumVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            ForumAtclVO forumAtclVO = new ForumAtclVO();
            forumAtclVO.setForumCd(forumVO.getForumCd());
            forumAtclVO.setAtclSn(request.getParameter("atclSn"));
            forumAtclVO.setMdfrId(StringUtil.nvl(SessionInfo.getUserId(request)));
            forum2AtclService.deleteAtcl(forumAtclVO);
            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    @RequestMapping(value = "/Form/addCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addCmnt(ForumVO forumVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            String userId = StringUtil.nvl(SessionInfo.getUserId(request));
            ForumCmntVO forumCmntVO = new ForumCmntVO();
            forumCmntVO.setCmntSn(IdGenerator.getNewId("CMNT"));
            forumCmntVO.setForumCd(forumVO.getForumCd());
            forumCmntVO.setAtclSn(request.getParameter("atclSn"));
            forumCmntVO.setParCmntSn(request.getParameter("parCmntSn"));
            forumCmntVO.setCmntCts(request.getParameter("cmntCts"));
            forumCmntVO.setAnsReqYn(StringUtil.nvl(request.getParameter("ansReqYn"), "N"));
            forumCmntVO.setRgtrId(userId);
            forumCmntVO.setMdfrId(userId);
            forum2CmntService.insertCmnt(forumCmntVO);
            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    @RequestMapping(value = "/Form/editCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editCmnt(ForumVO forumVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            ForumCmntVO forumCmntVO = new ForumCmntVO();
            forumCmntVO.setCmntSn(request.getParameter("cmntSn"));
            forumCmntVO.setCmntCts(request.getParameter("cmntCts"));
            forumCmntVO.setAnsReqYn(request.getParameter("ansReqYn"));
            forumCmntVO.setMdfrId(StringUtil.nvl(SessionInfo.getUserId(request)));
            forum2CmntService.updateCmnt(forumCmntVO);
            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    // 토론방 댓글 삭제
    @RequestMapping(value = "/Form/delCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delCmnt(ForumVO forumVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            ForumCmntVO forumCmntVO = new ForumCmntVO();
            forumCmntVO.setCmntSn(request.getParameter("cmntSn"));
            forumCmntVO.setMdfrId(StringUtil.nvl(SessionInfo.getUserId(request)));
            forum2CmntService.deleteCmnt(forumCmntVO);
            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    // 팀토론 토론방 팀리스트
    @RequestMapping(value="/listTeamJson.do")
    @ResponseBody
    public ProcessResultVO<TeamVO> listTeamJson(TeamCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        ProcessResultVO<TeamVO> returnVO = new ProcessResultVO<>();
        try {
            String teamCtgrCd = vo.getTeamCtgrCd();

            if(ValidationUtils.isNotEmpty(teamCtgrCd)) {
                TeamVO teamVO = new TeamVO();
                teamVO.setTeamCtgrCd(teamCtgrCd);
                List<TeamVO> list = teamService.teamList(teamVO);
                returnVO.setReturnList(list);
            }

            returnVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            returnVO.setResult(-1);
        }
        return returnVO;
    }

    // 팀 구성원 보기
    @RequestMapping(value="/teamMemberList.do")
    public String teamMemberList(TeamCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        List<TeamCtgrVO> teamCtgrList = teamCtgrService.teamList(vo);
        request.setAttribute("teamCtgrList", teamCtgrList);

        return "forum/popup/team_member_list_pop";
    }

    // 팀 구성원 ajax
    @RequestMapping(value="/teamMember.do")
    @ResponseBody
    public ProcessResultVO<TeamMemberVO> listTeam(TeamVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<TeamMemberVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setUserId(userId);

        try {
            // List<TeamMemberVO> list = teamService.list(vo);
            List<TeamMemberVO> list = teamMemberService.selectTeamMemberList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    // 팀토론 일경우 검색 조건 추가
    @RequestMapping(value="/teamSelectList.do")
    @ResponseBody
    public ProcessResultVO<TeamVO> teamSelectList(TeamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<TeamVO> resultVO = new ProcessResultVO<>();
        Locale locale = LocaleUtil.getLocale(request);

        try {
            List<TeamVO> list = teamService.list(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("forum.common.error", null, locale)); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    private void setCommonSessionValue(Forum2ListVO vo, HttpServletRequest request) {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setLangCd(SessionInfo.getLocaleKey(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setRgtrId(SessionInfo.getUserId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));
    }

    /**
     * 저장용세션공통값주입
     * @param vo
     * @param request
     */
    private void setCommonSessionValue(Forum2VO vo, HttpServletRequest request) {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setLangCd(SessionInfo.getLocaleKey(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setRgtrId(SessionInfo.getUserId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));
    }

    private ForumVO convertForum2VOtoForumVO(Forum2VO src) throws Exception {
        ForumVO dest = new ForumVO();

        if (src == null) {
            return dest;
        }

        BeanUtils.copyProperties(src, dest);

        dest.setForumCd(src.getDscsId());                // 토론ID -> forumCd
        dest.setCrsCreCd(src.getSbjctId());              // 예: 과목ID
        dest.setForumTitle(src.getDscsTtl());            // 예: 토론명
        dest.setForumArtl(src.getDscsCts());                // 토론내용
        dest.setForumCtgrCd(src.getDscsUnitTycd());      // 예: 토론유형
        dest.setForumStartDttm(src.getDscsSdttm());      // 토론 시작일시
        dest.setForumEndDttm(src.getDscsEdttm());        // 토론 종료일시
        dest.setScoreAplyYn(src.getMrkRfltyn());         // 성적반영여부
        dest.setScoreRatio(src.getMrkRfltrt());          // 성적반영비율
        dest.setScoreOpenYn(src.getMrkOyn());           // 성적공개여부
        dest.setDelYn(src.getDelyn());                  // 삭제여부
        dest.setDeclsNo(src.getDvclsNo());              // 분반번호
        dest.setForumCtgrCd(src.getDscsUnitTycd());     // TEAM or GNRL
        dest.setProsConsForumCfg(src.getOknokStngyn()); // 찬반토론 설정 여부.(찬반)
        dest.setProsConsRateOpenYn(src.getOknokrtOyn());// 찬반 비율 공개(찬반)
        dest.setRegOpenYn(src.getOknokRgtrOyn());       // 작성자 공개(찬반)
        dest.setMultiAtclYn(src.getMltOpnnRegyn());     // 의견글 복수 등록(찬반)
        dest.setProsConsModYn(src.getOknokModyn());     // 의견 변경(찬반)
        dest.setByteamSubdscsUseyn(src.getByteamSubdscsUseyn()); // 팀별부토론사용여부
        dest.setDscsGrpnm(src.getDscsGrpnm());          // 학습그룹이름.

        // DB 외 변수들
        dest.setForumAtclCnt(src.getForumAtclCnt());
        dest.setForumCmntCnt(src.getForumCmntCnt());
        dest.setForumMyAtclCnt(src.getForumMyAtclCnt());
        dest.setForumMyCmntCnt(src.getForumMyCmntCnt());
        dest.setForumAtclPorsCnt(src.getForumAtclPorsCnt());
        dest.setForumAtclConsCnt(src.getForumAtclConsCnt());
        dest.setForumUserTotalCnt(src.getForumUserTotalCnt());
        dest.setForumJoinUserCnt(src.getForumJoinUserCnt());
        dest.setForumMyScore(src.getForumMyScore());
        dest.setForumMyFdbk(src.getForumMyFdbk());
        dest.setForumEvalCnt(src.getForumEvalCnt());
        dest.setTeamForumDtlList(src.getTeamForumDtlList());

        // 필요 시 추가 매핑
        return dest;
    }
}


