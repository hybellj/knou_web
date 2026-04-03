package knou.lms.forum2.web;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.IdPrefixType;
import knou.framework.common.RepoInfo;
import knou.framework.common.SessionInfo;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.forum.vo.ForumAtclVO;
import knou.lms.forum.vo.ForumCmntVO;
import knou.lms.forum.vo.ForumFdbkVO;
import knou.lms.forum.vo.ForumJoinUserVO;
import knou.lms.forum.vo.ForumVO;
import knou.lms.forum.web.ForumLectController;
import knou.lms.forum2.service.ForumAtclService;
import knou.lms.forum2.service.ForumCmntService;
import knou.lms.forum2.service.ForumFdbkService;
import knou.lms.forum2.service.ForumJoinUserService;
import knou.lms.forum2.service.ForumService;
import knou.lms.forum2.vo.Forum2ListVO;
import knou.lms.forum2.vo.Forum2TeamDscsVO;
import knou.lms.forum2.vo.Forum2VO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.team.service.TeamCtgrService;
import knou.lms.team.service.TeamMemberService;
import knou.lms.team.service.TeamService;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.team.vo.TeamVO;

@Controller
@RequestMapping(value = "/forum2/forumLect")
public class Forum2LectController extends ControllerBase {
    private static final Logger LOGGER = LoggerFactory.getLogger(ForumLectController.class);

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name = "forum2Service")
    private ForumService forum2Service;
    @Resource(name = "forum2AtclService")
    private ForumAtclService forum2AtclService;
    @Resource(name = "forum2CmntService")
    private ForumCmntService forum2CmntService;

    @Resource(name="forum2JoinUserService")
    private ForumJoinUserService forum2JoinUserService;

    @Resource(name="forum2FdbkService")
    private ForumFdbkService forum2FdbkService;

    @Resource(name="termService")
    private TermService termService;


    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name = "sysFileService")
    private SysFileService sysFileService;

    @Resource(name="attachFileService")
    private AttachFileService attachFileService;

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
        model.addAttribute("orgId", forum2ListVO.getOrgId());
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        // TODO : Test Code 값 추후 수정 예정.(setSbjctId, setLrnGrpId)
        // - 필수값 체크 : 과목 ID 가 없을 경우 (잘못된 접근)
        forum2ListVO.setSbjctId(forum2ListVO.getSbjctId() != null ? forum2ListVO.getSbjctId() : test_sbjctId);
        forum2ListVO.setLrnGrpId(forum2ListVO.getLrnGrpId() != null ? forum2ListVO.getLrnGrpId() : test_lrnGrpId);

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
        List<Forum2VO> dvclasList = forum2Service.selectForumDvclasList(forum2VO);
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
        vo.setViewAll("PROF".equals(userType)); // 교수 화면은 삭제여부 관계없이 조회되도록함.
        vo.setUserId(userId);

        try {
            setCommonSessionValue(vo, request);
            resultVO = forum2Service.selectForumList(vo);
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
            resultVO = forum2Service.saveForum(vo);
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

            forum2VO = forum2Service.selectForum(forum2VO);
            // 첨부파일저장소 설정
            forum2VO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

            // 분반 목록 조회 (teamForumDiv 렌더링용 — sbjctId 는 selectForum 에서 반환됨)
            List<Forum2VO> dvclasList = forum2Service.selectForumDvclasList(forum2VO);
            model.addAttribute("dvclasList", dvclasList);

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
            resultVO = forum2Service.saveForum(vo);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
            resultVO.setResultSuccess();
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    // 이전 토론 가져오기 팝업
    @RequestMapping(value="/Form/forumCopyPop.do")
    public String forumCopyPop(Forum2VO forum2VO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String orgId = SessionInfo.getOrgId(request);
        String sbjctId = forum2VO.getSbjctId();

        // 강의실 대표교수 정보 조회
        // TODO : 26.3.26 임시 막음 처리.
       /* CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.selectTchCreCrs(creCrsVO);

        String repUserId = creCrsVO.getUserId();*/
        String repUserId = StringUtil.nvl(SessionInfo.getUserId(request));

        // 대표교수의 과목이 있는 학기기수 목록 조회
        Forum2VO forumVO = new Forum2VO();
        forumVO.setSbjctId(sbjctId);
        List<EgovMap> smstrChrtList = forum2Service.selectProfSmstrChrtList(forumVO);

        model.addAttribute("forum2VO", forum2VO);
        model.addAttribute("smstrChrtList", smstrChrtList);
        model.addAttribute("repUserId", repUserId);

        return "forum2/popup/prof_forum_copy";
    }

    // 교수학기기수별과목목록 조회 ajax (토론 복사 팝업용)
    @RequestMapping(value="/Form/smstrChrtSbjctListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> smstrChrtSbjctListAjax(Forum2VO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        try {
            resultVO.setReturnList(forum2Service.selectProfSmstrChrtSbjctList(vo));
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error");
        }
        return resultVO;
    }

    // 이전 토론 가져오기 리스트 ajax
    @RequestMapping(value="/Form/forumCopyList.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> fourmCopyList(@RequestBody Forum2VO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setUserId(userId);
            vo.setOrgId(orgId);
            resultVO = forum2Service.selectProfSbjctForumList(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    // 이전 토론 가져오기 ajax
    @RequestMapping(value="/Form/forumCopy.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> forumCopy(Forum2VO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<Forum2VO> returnVO = new ProcessResultVO<Forum2VO>();

        try {
            Forum2VO forumVO = new Forum2VO();
            forumVO = forum2Service.selectForum(vo);
            // 복사시 이전 토론 ID 는 제거한다.
            forumVO.setDscsId("");

            returnVO.setReturnVO(forumVO);
            returnVO.setResult(1);
        } catch(Exception e) {
            returnVO.setResult(-1);
            returnVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return returnVO;
    }

    /**
     * 학습그룹 팀 목록 조회 (팀 토론 부주제 설정용)
     */
    @RequestMapping(value = "/profForumLrnGrpTeamListAjax.do")
    @ResponseBody
    public ProcessResultVO<Forum2TeamDscsVO> profForumLrnGrpTeamListAjax(
            Forum2TeamDscsVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2TeamDscsVO> resultVO = new ProcessResultVO<>();
        try {
            resultVO = forum2Service.selectForumLrnGrpTeamList(vo);
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

            setCommonSessionValue(vo, request);
            vo.setMrkOyn(mrkOyn);
            resultVO = forum2Service.modifyForumMrkOyn(vo);
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
                setCommonSessionValue(vo, request);
                vo.setMdfrId(userId);
            }
            forum2Service.updateForumMrkRfltrt(list);
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
            resultVO = forum2Service.deleteForum(vo);

            if (resultVO.getResult() == 0) {
                // 성적반영여부(SCORE_APLY_YN)가 Y인 경우에 성적반영 비율 100% 기준으로 1/N 자동 계산하여 성적반영비율 필더(SCORE_RATIO)에 저장
                forum2Service.setScoreRatio(vo);

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

        ProcessResultVO<Forum2VO> forumRs = forum2Service.selectForum(param);
        Forum2VO dscs = forumRs.getReturnVO();
        */
        // TODO : 26.4.1(sbjctId 필수값이어야 함.)
        param.setSbjctId(forumVO.getSbjctId());
        param.setDscsId(forumVO.getForumCd());

        Forum2VO tempForum2VO = forum2Service.selectForum(param);
        forumVO = convertForum2VOtoForumVO(tempForum2VO) ;

        // 첨부파일저장소 설정
        forumVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", forumVO.getCrsCreCd());
        model.addAttribute("userId", StringUtil.nvl(SessionInfo.getUserId(request)));
        model.addAttribute("userName", StringUtil.nvl(SessionInfo.getUserNm(request)));
        model.addAttribute("forumVO", forumVO);

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

        forumAtclVO.setViewAll(true);// 교수 화면은 삭제여부 관계없이 조회되도록함.
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
        String atclSn = IdGenerator.getNewId(IdPrefixType.DSATC.getCode());
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

    /**
     * 토론방게시글저장
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/Form/addAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addAtcl(ForumVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String atclSn = IdGenerator.getNewId(IdPrefixType.DSATC.getCode());
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
            forum2AtclService.insertAtcl(forumAtclVO, vo.getTeamCd());
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 토론게시글수정
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
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

    /**
     * 토론게시글삭제
     * @param forumVO
     * @param request
     * @return
     * @throws Exception
     */
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

    // 참여글 숨김
    @RequestMapping(value = "/Form/hideAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> hideAtcl(ForumVO forumVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            ForumAtclVO forumAtclVO = new ForumAtclVO();
            forumAtclVO.setForumCd(forumVO.getForumCd());
            forumAtclVO.setAtclSn(request.getParameter("atclSn"));
            forumAtclVO.setMdfrId(StringUtil.nvl(SessionInfo.getUserId(request)));
            forum2AtclService.hideAtcl(forumAtclVO);
            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    /**
     * 토론댓글등록
     * @param forumVO
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/Form/addCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addCmnt(ForumVO forumVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            String userId = StringUtil.nvl(SessionInfo.getUserId(request));
            ForumCmntVO forumCmntVO = new ForumCmntVO();
            forumCmntVO.setCmntSn(IdGenerator.getNewId(IdPrefixType.DSCMT.getCode()));
            forumCmntVO.setForumCd(forumVO.getForumCd());
            forumCmntVO.setAtclSn(request.getParameter("atclSn"));
            forumCmntVO.setParCmntSn(request.getParameter("parCmntSn"));
            forumCmntVO.setCmntCts(request.getParameter("cmntCts"));
            forumCmntVO.setAnsReqYn(StringUtil.nvl(request.getParameter("ansReqYn"), "N"));
            forumCmntVO.setRgtrId(userId);
            forumCmntVO.setMdfrId(userId);
            forum2CmntService.insertCmnt(forumCmntVO);

            // TODO: 26.3.19 : 학습자만 체크할 수 있음.
            /*
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
            */

            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    /**
     * 토론댓글수정
     * @param forumVO
     * @param request
     * @return
     * @throws Exception
     */
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

    /**
     * 토론방댓글삭제
     * @param forumVO
     * @param request
     * @return
     * @throws Exception
     */
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

    // 댓글 숨김
    @RequestMapping(value = "/Form/hideCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> hideCmnt(ForumVO forumVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            ForumCmntVO forumCmntVO = new ForumCmntVO();
            forumCmntVO.setCmntSn(request.getParameter("cmntSn"));
            forumCmntVO.setMdfrId(StringUtil.nvl(SessionInfo.getUserId(request)));
            forum2CmntService.hideCmnt(forumCmntVO);
            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    /**
     * 팀토론토론방OPEN여부 수정
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profTeamDscsOynModify.do")
    @ResponseBody
    public ProcessResultVO<Forum2TeamDscsVO> profTeamDscsOynModify(Forum2TeamDscsVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2TeamDscsVO> resultVO = new ProcessResultVO<>();

        try {
            if (StringUtil.isNull(vo.getDscsId())) {
                resultVO.setResultFailed("dscsId is required");
                return resultVO;
            }

            String mrkOyn = StringUtil.nvl(vo.getTeamDscsOyn());
            if (StringUtil.isNull(mrkOyn)) {
                mrkOyn = StringUtil.nvl(request.getParameter("mrkOyn"));
            }
            mrkOyn = mrkOyn.toUpperCase();

            if (!"Y".equals(mrkOyn) && !"N".equals(mrkOyn)) {
                resultVO.setResultFailed("수정 중 에러가 발생하였습니다.");
                return resultVO;
            }
            String userId = StringUtil.nvl(SessionInfo.getUserId(request));
            vo.setMdfrId(userId);
            vo.setTeamDscsOyn(mrkOyn);
            resultVO = forum2Service.modifyTeamDscsOyn(vo);
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
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

    // 성적평가
    @RequestMapping(value="/Form/scoreManage.do")
    public String scoreManage(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        model.addAttribute("tab", request.getParameter("tab"));
        String rltnCd = request.getParameter("rltnCd");

        String crsCreCd = forumVO.getCrsCreCd();

        if(rltnCd == null || rltnCd.equals("")) {
        } else {
            forumVO.setForumCd(rltnCd);
            forumVO.setOrgId(orgId);
        }

        // TODO : 26.3.18 (임시로 복사 처리함)
        Forum2VO param = new Forum2VO();
        param.setDscsId(forumVO.getForumCd());
        param.setSbjctId(forumVO.getSbjctId());
        Forum2VO tempForum2VO = forum2Service.selectForum(param);
        forumVO = convertForum2VOtoForumVO(tempForum2VO);
        // TODO : 26.3.18 (임시로 복사 처리함)
        crsCreCd = test_sbjctId;
        model.addAttribute("crsCreCd", crsCreCd);

        /*  강의실에서 토론 진입시 교수자ID */
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /* 강의실에서 토론 진입시 교수자이름 */
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", forumVO.getCrsCreCd());

        model.addAttribute("userId", userId);
        model.addAttribute("userName", userName);

        if("PTCP_FULL_SCR".equals(StringUtil.nvl(forumVO.getEvalCtgr()))) {
            // 모든 토론 참여자를 토론 참여자 테이블에 삽입
            ForumVO fvo = new ForumVO();
            fvo.setRgtrId(userId);
            fvo.setCrsCreCd(forumVO.getCrsCreCd());
            fvo.setForumCd(forumVO.getForumCd());
            forum2JoinUserService.insertJoinUser(fvo);

            // TODO : 26.3.20(기획 요청에 따라 먼저 평가를 하지 않고 목록에서 일괄 평가식으로 처리함.)
            /*
            ForumJoinUserVO joinUserVO = new ForumJoinUserVO();
            joinUserVO.setSearchMenu("ONCE");
            joinUserVO.setRgtrId(userId);
            joinUserVO.setForumCd(forumVO.getForumCd());
            joinUserVO.setSearchKey("JOIN");
            forum2JoinUserService.participateScore(joinUserVO);
            //joinUserVO.setSearchKey("NOTJOIN");
            //forumJoinUserService.participateScore(joinUserVO);
            */
        }
        ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
        forumJoinUserVO.setForumCd(forumVO.getForumCd());

        // 성적분포현황차트
        List<?> forumJoinUserList = forum2JoinUserService.forumJoinUserList(forumJoinUserVO);
        int minScore = 0;
        int maxScore = 0;
        int totalScore = 0;
        int score = 0;
        int avgScore = 0;

        if(forumJoinUserList.size() > 0) {
            for(int i = 0; i < forumJoinUserList.size(); i++) {
                EgovMap egovMap = (EgovMap) forumJoinUserList.get(i);

                // long tmpScore = (long)egovMap.get("score");
                // score = Long.valueOf(tmpScore).intValue();
                BigDecimal tmpScore = (BigDecimal) egovMap.get("score");
                long befScore = tmpScore.longValue();
                score = Long.valueOf(befScore).intValue();

                if(i == 0) {
                    minScore = score;
                    maxScore = score;
                } else {
                    if(minScore > score) {
                        minScore = score;
                    }

                    if(maxScore < score) {
                        maxScore = score;
                    }
                }
                totalScore = totalScore + score;
            }
            avgScore = totalScore / forumJoinUserList.size();
        }

        model.addAttribute("minScore", minScore);
        model.addAttribute("maxScore", maxScore);
        model.addAttribute("avgScore", avgScore);

        // 찬반현황 차트용
        forumVO.setOrgId(orgId);
        // TODO : 26.3.16 (앞에서 읽었는데 또 다시 읽어야 하나?-joinUserCount 가 달라지는가?)
        /*
        forumVO = forum2Service.selectForum(param);
         */
        forumVO.setCrsCreCd(crsCreCd);

        forumVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));
        model.addAttribute("forumVO", forumVO);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        // TODO : 26.3.18 불필요한 코드(필요시 test_sbjctId 로 변경할 것)
        //creCrsVO = crecrsService.select(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);

        return "forum2/lect/forum_score_manage";
    }

    /*****************************************************
     * 토론 참여 사용자 리스트 가져오기 ajax
     * @param ForumJoinUserVO
     * @return ProcessResultVO<ForumJoinUserVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/forumJoinUserList.do")
    @ResponseBody
    public ProcessResultVO<ForumJoinUserVO> forumJoinUserList(ForumJoinUserVO vo,
            @RequestParam(value="byteamDscsUseyn", required=false, defaultValue="") String byteamDscsUseyn,
            ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<ForumJoinUserVO> resultVO = new ProcessResultVO<>();
        try {
            resultVO = forum2JoinUserService.listPaging(vo, byteamDscsUseyn);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 토론 참여자 성적 변경 ajax
     * @param ExamStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateForumJoinUserScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateForumJoinUserScore(ForumJoinUserVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String teamCtgrCd = request.getParameter("teamCtgrCd");

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setTeamCd(teamCtgrCd);

            forum2JoinUserService.updateForumJoinUserScore(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 토론 참여자 글자수로 점수 주기(ajax)
     * @param ExamStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateForumJoinUserLenScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateForumJoinUserLenScore(ForumJoinUserVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String teamCtgrCd = request.getParameter("teamCtgrCd");

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setTeamCd(teamCtgrCd);

            forum2JoinUserService.updateForumJoinUserLenScore(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 토론 성적평가 엑셀 다운로드
     * @param ForumJoinUserVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/forumScoreExcelDown.do")
    public String forumScoreExcelDown(ForumJoinUserVO vo,
            @RequestParam(value="byteamDscsUseyn", required=false, defaultValue="") String byteamDscsUseyn,
            ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        vo.setPagingYn("N");
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적평가리스트");
        map.put("sheetName", "성적평가리스트");
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", forum2JoinUserService.listPaging(vo, byteamDscsUseyn).getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("outFileName", "성적평가리스트_" + date.format(today));
        modelMap.put("workbook", excelUtilPoi.simpleBigGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    // 상호평가 토론방 리스트
    @RequestMapping(value="/evalForumBbsViewList.do")
    public String evalForumBbsViewList(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        request.setAttribute("tab", request.getParameter("tab"));

        String crsCreCd = forumVO.getCrsCreCd();

        String stdList = forumVO.getStdList();

        /*토론 게시글*/
        ForumAtclVO forumAtclVO = new ForumAtclVO();

        String rltnCd = request.getParameter("rltnCd");
        if(rltnCd != null) {
            forumAtclVO.setForumCd(rltnCd);
            forumVO.setForumCd(rltnCd);
        } else {
            forumAtclVO.setForumCd(forumVO.getForumCd());
        }

        forumAtclVO.setSearchKey(forumVO.getSearchKey());
        forumAtclVO.setSearchValue(forumVO.getSearchValue());
        forumAtclVO.setPageIndex(forumVO.getPageIndex());
        //int listScale = 2; //forumAtclVO.getListScale()
        forumAtclVO.setListScale(forumVO.getListScale());
        forumAtclVO.setStdList(stdList);
        forumAtclVO.setCrsCreCd(crsCreCd);
        forumAtclVO.setViewAll(true);// 교수 화면은 삭제여부 관계없이 조회되도록함.

        ProcessResultVO<ForumAtclVO> resultList = forum2AtclService.listPageing(forumAtclVO);

        request.setAttribute("forumAtclList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());
        request.setAttribute("forumVo", forumVO);
        request.setAttribute("konanCopyScoreUrl", CommConst.KONAN_COPY_SCORE_URL);

        return "forum2/lect/forum_bbs_view_eval";
    }

    // 토론 성적평가 > 피드백
    @RequestMapping(value="/forumScoreEvalFeedBack.do")
    public String forumScoreEvalFeedBack(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        /*참여자 정보*/
        if(!"EZG".equals(forumVO.getSearchMenu())) {
            ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
            forumJoinUserVO.setForumCd(forumVO.getForumCd());
            forumJoinUserVO.setStdId(forumVO.getStdId());

            forumJoinUserVO = forum2JoinUserService.selectForumJoinUser(forumJoinUserVO);
            request.setAttribute("forumJoinUserVo", forumJoinUserVO);
        }

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumCd(forumVO.getForumCd());
        forumFdbkVO.setStdId(forumVO.getStdId());

        if(forumVO.getTeamCd() != null || forumVO.getTeamCd() != "") {
            forumFdbkVO.setTeamCd(forumVO.getTeamCd());
        }

        /* 피드백 list */
        List<?> forumFdbkList = forum2FdbkService.forumFdbkList(forumFdbkVO);

        int fdbkSize = forumFdbkList.size();

        request.setAttribute("fdbkSize", fdbkSize);
        request.setAttribute("forumFdbkList", forumFdbkList);
        request.setAttribute("forumVo", forumVO);

        return "forum2/lect/forum_score_eval_feedBack";
    }

    // 성적분포현황 BarChart
    @RequestMapping(value="/viewScoreChart.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> viewScoreChart(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            // TODO : 26.3.20 : to-be vo 변경에 따른 처리.
            /*vo = forum2Service.selectForum(vo);*/
            Forum2VO param = new Forum2VO();
            param.setSbjctId(vo.getSbjctId());
            param.setDscsId(vo.getForumCd());
            EgovMap scoreMap = forum2Service.viewScoreChart(param);

            resultVO.setReturnVO(scoreMap);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 교수 메모 팝업창 정보
    @RequestMapping(value="/forumProfMemoPop.do")
    public String forumProfMemoPop(ForumJoinUserVO forumJoinUserVO, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(forumJoinUserVO.getCrsCreCd());
        // TODO : 26.3.23 : AS-IS code TO-BE 필요시 적용.
        /*creCrsVO = crecrsService.infoCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);*/
        request.setAttribute("forumCd", forumJoinUserVO.getForumCd());
        request.setAttribute("stdId", forumJoinUserVO.getStdId());

        forumJoinUserVO.setUserId(SessionInfo.getUserId(request));
        forumJoinUserVO = forum2JoinUserService.selectProfMemo(forumJoinUserVO);
        request.setAttribute("forumJoinUserVO", forumJoinUserVO);

        return "forum2/popup/forum_prof_memo";
    }

    // 교수 메모 수정
    @RequestMapping(value="/editForumProfMemo.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editForumProfMemo(ForumJoinUserVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        try {
            vo.setMdfrId(userId);
            forum2JoinUserService.editForumProfMemo(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    // 피드백
    @RequestMapping(value="/forumFdbkPop.do")
    public String forumFeedBack(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        // TODO : 26.3.23 : AS-IS code TO-BE 필요시 적용.
        /*creCrsVO = crecrsService.infoCreCrs(creCrsVO);*/
        request.setAttribute("creCrsVO", creCrsVO);

        String forumCd = vo.getForumCd();
        String stdId = vo.getStdId();
        String teamCd = vo.getTeamCd();

        request.setAttribute("forumCd", forumCd);
        request.setAttribute("stdId", stdId);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
        forumJoinUserVO.setForumCd(forumCd);
        forumJoinUserVO.setStdId(stdId);
        forumJoinUserVO.setUserId(userId);
        forumJoinUserVO = forum2JoinUserService.selectProfMemo(forumJoinUserVO);

        request.setAttribute("forumJoinUserVO", forumJoinUserVO);

        // String userType = StringUtil.nvl(SessionInfo.getClassUserType(request));
        String userType = "CLASS_PROFESSOR";

        /*
        if(!"EZG".equals(vo.getSearchMenu())) {
            forumJoinUserVO = forumJoinUserService.selectForumJoinUser(forumJoinUserVO);
            request.setAttribute("forumJoinUserVo", forumJoinUserVO);
        }
        */

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumCd(forumCd);
        forumFdbkVO.setStdId(stdId);

        if(teamCd != null || teamCd != "") {
            forumFdbkVO.setTeamCd(teamCd);
        }

        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName);
        request.setAttribute("userType", userType);

        String student = (SessionInfo.getAuthrtGrpcd(request).contains("USR")) ? "STD" : "";
        request.setAttribute("student", student);

        request.setAttribute("forumVo", vo);
        request.setAttribute("PAGE_FILE_UPLOAD", request.getContextPath() + CommConst.PAGE_FILE_UPLOAD);

        return "forum2/popup/forum_feedback";
    }

    // 피드백 조회
    @RequestMapping(value="/getFdbk.do")
    @ResponseBody
    public ProcessResultVO<ForumFdbkVO> getFdbk(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String fdbkCts = request.getParameter("fdbkCts");
        String parForumFdbkCd = request.getParameter("parForumFdbkCd");
        String stdId = vo.getStdId();

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumFdbkCd(IdGenerator.getNewId("FFDBK"));
        if(parForumFdbkCd == null || parForumFdbkCd.equals("")) {
            forumFdbkVO.setParForumFdbkCd(null);
        } else {
            forumFdbkVO.setParForumFdbkCd(parForumFdbkCd);
        }
        forumFdbkVO.setForumCd(vo.getForumCd());
        forumFdbkVO.setFdbkCts(fdbkCts);
        forumFdbkVO.setStdId(stdId);

        if(vo.getTeamCd() != null || vo.getTeamCd() != "") {
            forumFdbkVO.setTeamCd(vo.getTeamCd());
        }

        // 피드백 리스트
        ProcessResultVO<ForumFdbkVO> resultVO = new ProcessResultVO<>();
        try {
            List<ForumFdbkVO> list = forum2FdbkService.selectFdbk(forumFdbkVO);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    // 피드백 작성
    @RequestMapping(value="/addFdbkCts.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addFockCts(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String fdbkCts = request.getParameter("fdbkCts");
        String parForumFdbkCd = request.getParameter("parForumFdbkCd");
        String stdId = vo.getStdId();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumFdbkCd(IdGenerator.getNewId("FFDBK"));
        if(parForumFdbkCd == null || parForumFdbkCd.equals("")) {
            forumFdbkVO.setParForumFdbkCd(null);
        } else {
            forumFdbkVO.setParForumFdbkCd(parForumFdbkCd);
        }
        forumFdbkVO.setForumCd(vo.getForumCd());
        forumFdbkVO.setFdbkCts(fdbkCts);
        forumFdbkVO.setStdId(stdId);

        forumFdbkVO.setRgtrId(userId);
        forumFdbkVO.setRgtrnm(userName);
        forumFdbkVO.setMdfrId(userId);

        if(vo.getTeamCd() != null || vo.getTeamCd() != "") {
            forumFdbkVO.setTeamCd(vo.getTeamCd());
        }

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            forum2FdbkService.insertForumFdbk(forumFdbkVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    // 피드백 수정
    @RequestMapping(value="/editFdbkCts.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editFdbkCts(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String forumFdbkCd = request.getParameter("forumFdbkCd");
        String fdbkCts = request.getParameter("fdbkCts");
        String stdId = vo.getStdId();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumFdbkCd(forumFdbkCd);
        forumFdbkVO.setForumCd(vo.getForumCd());
        forumFdbkVO.setFdbkCts(fdbkCts);
        forumFdbkVO.setStdId(stdId);

        forumFdbkVO.setRgtrId(userId);
        forumFdbkVO.setMdfrId(userId);

        if(vo.getTeamCd() != null || vo.getTeamCd() != "") {
            forumFdbkVO.setTeamCd(vo.getTeamCd());
        }

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            forum2FdbkService.updateForumFdbk(forumFdbkVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }

        return resultVO;
    }

    // 피드백 삭제
    @RequestMapping(value="/delFdbkCts.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delFdbkCts(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String forumFdbkCd = request.getParameter("forumFdbkCd");
        String fdbkCts = request.getParameter("fdbkCts");
        String stdId = vo.getStdId();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumFdbkCd(forumFdbkCd);
        forumFdbkVO.setForumCd(vo.getForumCd());
        forumFdbkVO.setFdbkCts(fdbkCts);
        forumFdbkVO.setStdId(stdId);

        forumFdbkVO.setRgtrId(userId);
        forumFdbkVO.setMdfrId(userId);

        if(vo.getTeamCd() != null || vo.getTeamCd() != "") {
            forumFdbkVO.setTeamCd(vo.getTeamCd());
        }

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            forum2FdbkService.deleteForumFdbk(forumFdbkVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    // 일괄 피드백 팝업
    @RequestMapping(value="/allForumFdbkPop.do")
    public String allForumFdbkPop(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String forumCd = vo.getForumCd();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        // 모든 토론 참여자를 토론 참여자 테이블에 삽입
        vo.setRgtrId(userId);
        forum2JoinUserService.insertJoinUser(vo);

        request.setAttribute("forumCd", forumCd);
        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName);

        return "forum/popup/forum_all_feedback";
    }

    // 일괄 피드백 작성
    @RequestMapping(value="/allAddFdbkCts.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> allAddFdbkCts(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String fdbkCts = request.getParameter("fdbkCts");

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();

        forumFdbkVO.setForumCd(vo.getForumCd());
        forumFdbkVO.setFdbkCts(fdbkCts);

        forumFdbkVO.setRgtrId(userId);
        forumFdbkVO.setRgtrnm(userName);
        forumFdbkVO.setMdfrId(userId);

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            forum2FdbkService.insertForumAllFdbk(forumFdbkVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }


    // 학습자 활동공간
    @RequestMapping(value="/listTeamStdSumm.do")
    public String listTeamStdSumm(TeamVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        List<TeamVO> stdList = teamService.listStd(vo);
        request.setAttribute("stdList", stdList);
        request.setAttribute("vo", vo);

        return "forum/lect/team_std_list_summ";
    }

    // 학습자 활동공간
    @RequestMapping(value="/listTeamStdJson.do")
    @ResponseBody
    public ProcessResultVO<TeamVO> listTeamStdJson(TeamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<TeamVO> resultVO = new ProcessResultVO<>();

        try {
            List<TeamVO> stdList = teamService.listStd(vo);

            resultVO.setReturnList(stdList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 피드백 저장
    @RequestMapping(value="/Form/regFdbk.do")
    @ResponseBody
    public ProcessResultVO<ForumFdbkVO> regFdbk(ForumFdbkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        // 쪽지발송을 위한 목록
        String[] stdArr = vo.getStdId().split(",");

        // 피드백 저장
        ProcessResultVO<ForumFdbkVO> resultVO = forum2FdbkService.insertFdbk(vo);

        // TODO : 26.3.20 : to-be 임시 막음 처리함.
        // 피드백 쪽지 발송
        /*sendFeedbackMessage(request, vo, stdArr);*/

        return resultVO;
    }

    // 피드백 수정
    @RequestMapping(value="/edtFdbk.do")
    @ResponseBody
    public ProcessResultVO<ForumFdbkVO> edtFdbk(ForumFdbkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        vo.setUserId(SessionInfo.getUserId(request));

        return forum2FdbkService.updateFdbk(vo);
    }

    // 피드백 삭제
    @RequestMapping(value="/delFdbk.do")
    @ResponseBody
    public ProcessResultVO<ForumFdbkVO> delFdbk(ForumFdbkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        vo.setUserId(SessionInfo.getUserId(request));

        return forum2FdbkService.deleteFdbk(vo);
    }



    // 엑셀 성적 등록 팝업
    @RequestMapping(value="/forumScoreExcelUploadPop.do")
    public String forumScoreExcelUploadPop(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        forumVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

        model.addAttribute("forumVO", forumVO);
        model.addAttribute("userId", userId);

        return "forum2/popup/forum_score_excel_upload";
    }

    // 엑셀 성적 등록 샘플 엑셀 다운로드
    @RequestMapping(value="/forumScoreSampleDownload.do")
    public String forumScoreSampleDownload(ForumVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();

        forumJoinUserVO.setCrsCreCd(vo.getCrsCreCd());
        forumJoinUserVO.setForumCd(vo.getForumCd());

        forumJoinUserVO.setSearchValue(vo.getSearchValue());
        forumJoinUserVO.setPageIndex(vo.getPageIndex());
        forumJoinUserVO.setListScale(1000);
        forumJoinUserVO.setForumCtgrCd(vo.getForumCtgrCd());
        ProcessResultVO<ForumJoinUserVO> resultList = forum2JoinUserService.listPaging(forumJoinUserVO, vo.getByteamDscsUseyn());
        request.setAttribute("forumJoinUserList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적등록_학습자목록");
        map.put("sheetName", "성적등록_학습자목록");
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", resultList.getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", "토론_성적등록_학습자목록_" + date.format(today));

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        // Cookie cookie = new Cookie("fileDownloadToken", "TRUE");
        // response.addCookie(cookie);

        return "excelView";
    }

    // 엑셀 성적등록 엑셀 업로드
    @RequestMapping(value="/uploadForumScoreExcel.do")
    @ResponseBody
    public ProcessResultVO<ForumJoinUserVO> uploadForumScoreExcel(ForumJoinUserVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);

        String forumCtgrCd = request.getParameter("forumCtgrCd");

        ProcessResultVO<ForumJoinUserVO> resultVO = new ProcessResultVO<>();
        try {
            /*List<FileVO> fileList = FileUtil.getUploadFileList(uploadFiles);
            FileVO fileVO = null;

            if(fileList != null && !fileList.isEmpty() && fileList.size() > 0) {
                fileVO = fileList.get(0);

                String fileExt = FileUtil.getFileExtention(fileVO.getFileNm());
                fileVO.setFilePath(uploadPath);
                fileVO.setFileSaveNm(fileVO.getFileSaveNm() + "." + fileExt);
            }*/
            List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);
            List<String> fileIdList = new ArrayList<>();

            // 첨부파일
            if (uploadFileList.size() > 0) {
                for (AtflVO atflVO : uploadFileList) {
                    atflVO.setRefId(vo.getForumCd());
                    atflVO.setRgtrId(vo.getRgtrId());
                    atflVO.setMdfrId(vo.getMdfrId());
                    atflVO.setAtflRepoId(CommConst.REPO_DSCS);
                    fileIdList.add(atflVO.getAtflId());
                }

                // 첨부파일 저장
                attachFileService.insertAtflList(uploadFileList);
            }

            AtflVO atflVO = uploadFileList.get(0);

            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("startRaw", 4);
            map.put("excelGrid", vo.getExcelGrid());
            map.put("atflVO", atflVO);
            map.put("searchKey", "excelUpload");

            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<?> list = excelUtilPoi.simpleReadGrid(map);

            forum2JoinUserService.updateExampleExcelScore(vo, list, forumCtgrCd);

            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        } finally {
            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }
        return resultVO;
    }

    // 성적평가 리스트 엑셀 다운로드
    @RequestMapping(value="/listScoreExcel.do")
    public String listScoreExcel(ForumVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();

        forumJoinUserVO.setCrsCreCd(vo.getCrsCreCd());
        forumJoinUserVO.setForumCd(vo.getForumCd());
        forumJoinUserVO.setSearchValue(vo.getSearchValue());
        forumJoinUserVO.setPageIndex(vo.getPageIndex());
        // forumJoinUserVO.setListScale(vo.getListScale());
        forumJoinUserVO.setListScale(1000);

        ProcessResultVO<ForumJoinUserVO> resultList = forum2JoinUserService.listPaging(forumJoinUserVO, vo.getByteamDscsUseyn());
        request.setAttribute("forumJoinUserList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적평가리스트");
        map.put("sheetName", "성적평가리스트");
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", resultList.getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", "성적평가리스트_" + date.format(today));

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        // Cookie cookie = new Cookie("fileDownloadToken", "TRUE");
        // response.addCookie(cookie);

        return "excelView";
    }


    // 참여형 일괄평가
    @RequestMapping(value="/participateScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> participateScore(ForumJoinUserVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setSearchKey("JOIN");
            forum2JoinUserService.participateScore(vo);
            vo.setSearchKey("NOTJOIN");
            forum2JoinUserService.participateScore(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 개별 평가점수
    @RequestMapping(value="/setScoreRatio.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> setScoreRatio(ForumJoinUserVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String teamCtgrCd = request.getParameter("teamCtgrCd");

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setTeamCd(teamCtgrCd);
            vo.setUserId(userId);

            forum2JoinUserService.setScoreRatio(vo);

            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 토론현황보기
    @RequestMapping(value="/forumChartViewPop.do")
    public String forumChartViewPop(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        // 성적분포현황차트
        ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
        forumJoinUserVO.setForumCd(vo.getForumCd());

        List<?> forumJoinUserList = forum2JoinUserService.forumJoinUserList(forumJoinUserVO);
        int minScore = 0;
        int maxScore = 0;
        int totalScore = 0;
        int score = 0;
        int avgScore = 0;

        if(forumJoinUserList.size() > 0) {
            for(int i = 0; i < forumJoinUserList.size(); i++) {
                EgovMap egovMap = (EgovMap) forumJoinUserList.get(i);
                /*
                 * long tmpScore = (long)egovMap.get("score"); score =
                 * Long.valueOf(tmpScore).intValue();
                 */

                BigDecimal tmpScore = (BigDecimal) egovMap.get("score");
                long befScore = tmpScore.longValue();
                score = Long.valueOf(befScore).intValue();

                if(i == 0) {
                    minScore = score;
                    maxScore = score;
                } else {
                    if(minScore > score) {
                        minScore = score;
                    }

                    if(maxScore < score) {
                        maxScore = score;
                    }
                }
                totalScore = totalScore + score;
            }
            avgScore = totalScore / forumJoinUserList.size();
        }

        request.setAttribute("minScore", minScore);
        request.setAttribute("maxScore", maxScore);
        request.setAttribute("avgScore", avgScore);


        // TODO : 26.3.20 : to-be vo 변경에 따른 처리.
        /*vo = forum2Service.selectForum(vo);*/
        Forum2VO param = new Forum2VO();
        param.setSbjctId(vo.getSbjctId());
        param.setDscsId(vo.getForumCd());
        Forum2VO tempForum2VO = forum2Service.selectForum(param);
        vo = convertForum2VOtoForumVO(tempForum2VO);
        // 찬반현황 차트용
        vo.setOrgId(orgId);
        vo.setCrsCreCd(crsCreCd);

        request.setAttribute("forumVo", vo);

        return "forum2/popup/forum_chart_view";
    }


    // 피드백 쪽지 발송
    private void sendFeedbackMessage(HttpServletRequest request, ForumFdbkVO vo, String[] stdNoArr) throws Exception {
        // 쪽지발송 처리
        /*if("Y".equals(CommConst.FEEDBACK_MESSAGE_SEND_YN)) {
            String orgId = SessionInfo.getOrgId(request);

            // 과목정보
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsVO = crecrsService.selectCreCrs(creCrsVO);

            // 토론정보
            ForumVO forumVO = new ForumVO();
            forumVO.setForumCd(vo.getForumCd());
            forumVO = forumService.selectForum(forumVO);

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
                String msgCtnt = "<b>[" + creCrsVO.getCrsCreNm() + "] 과목, [" + forumVO.getForumTitle() + "] 교수님 피드백입니다.</b><br>";
                msgCtnt += vo.getFdbkCts();

                ErpMessageMsgVO erpMessageMsgVO = new ErpMessageMsgVO();
                erpMessageMsgVO.setUsrUserInfoList(listUserRecvInfo);
                erpMessageMsgVO.setCtnt(msgCtnt);
                erpMessageMsgVO.setCrsCreCd(vo.getCrsCreCd());

                // 쪽지발송 저장
                erpService.insertSysMessageMsg(request, erpMessageMsgVO, "토론 피드백 쪽지 발송");
            }
        }*/
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

    // TODO : 26.3.24 : 임시 변환용(추후 삭제 예정)
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
        dest.setByteamDscsUseyn(src.getByteamDscsUseyn()); // 팀별부토론사용여부
        dest.setDscsGrpnm(src.getDscsGrpnm());          // 학습그룹이름.
        dest.setEvalCtgr(src.getEvlScrTycd());          // 평가점수유형코드
        dest.setTeamCd(src.getTeamId());                // 팀아이디.

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
        dest.setTeamDscsList(src.getTeamDscsList());

        // 필요 시 추가 매핑
        return dest;
    }
}


