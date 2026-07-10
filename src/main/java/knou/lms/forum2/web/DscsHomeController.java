package knou.lms.forum2.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import knou.lms.log2.user.service.LogLrnActvService;
import knou.lms.log2.user.vo.LogLrnActvInqHstryVO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.RepoInfo;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.lms.user.CurrentUser;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.service.DscsAccessService;
import knou.lms.forum2.service.DscsAtclService;
import knou.lms.forum2.service.DscsCmntService;
import knou.lms.forum2.service.DscsFdbkService;
import knou.lms.forum2.service.DscsJoinUserService;
import knou.lms.forum2.service.DscsLearnerService;
import knou.lms.forum2.service.DscsService;
import knou.lms.forum2.vo.DscsAtclVO;
import knou.lms.forum2.vo.DscsCmntVO;
import knou.lms.forum2.vo.DscsFdbkVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsListVO;
import knou.lms.forum2.vo.DscsVO;
import knou.lms.team.service.TeamGrpMgrService;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

/**
 * 학습자 토론방 화면 및 학습자 토론 참여 기능을 처리한다.
 */
@Controller
@RequestMapping(value="/forum2/forumHome")
public class DscsHomeController extends DscsControllerBase {

    @Resource(name="dscsService")
    private DscsService dscsService;

    @Resource(name="dscsAccessService")
    private DscsAccessService dscsAccessService;

    @Resource(name="dscsAtclService")
    private DscsAtclService dscsAtclService;

    @Resource(name="dscsCmntService")
    private DscsCmntService dscsCmntService;

    @Resource(name="dscsJoinUserService")
    private DscsJoinUserService dscsJoinUserService;

    @Resource(name="dscsFdbkService")
    private DscsFdbkService dscsFdbkService;

    @Resource(name="dscsLearnerService")
    private DscsLearnerService dscsLearnerService;

    @Resource(name="teamGrpMgrService")
    private TeamGrpMgrService teamGrpMgrService;

    @Resource(name="logLrnActvService")
    private LogLrnActvService logLrnActvService;

    private String test_sbjctId = "SBJCT_OFRNG_ID1";

    /**
     * 학습자 토론 목록 화면으로 이동한다.
     *
     * @param dscsListVO
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/Form/forumList.do")
    public String forumListView(
            DscsListVO dscsListVO,
            ModelMap model,
            HttpServletRequest request) throws Exception {

        model.addAttribute("dscsListVO", dscsListVO);

        // TODO : Test Code 값 추후 수정 예정.(setSbjctId, setTeamGrpId)
        if(dscsListVO.getSbjctId() == null) {
            addEncParam("sbjctId", test_sbjctId);
        }

        return "forum2/lect/stdnt_dscs_list_view";
    }

    /**
     * 학습자 토론 목록을 조회한다.
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/forumList.do")
    @ResponseBody
    public ProcessResultVO<DscsListVO> forumList(
            DscsListVO vo,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        ProcessResultVO<DscsListVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        vo.setLangCd(userCtx.getLangCd());
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        resultVO = dscsService.selectStdntDscsList(vo);
        resultVO.setResult(1);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 학습자 참여현황 화면으로 이동한다.
     *
     * @param dscsVO
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/Form/stdntPtcpStatusView.do")
    public String stdntPtcpStatusView(
            DscsVO dscsVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        DscsVO loadedVO = loadLearnerDscsForView(dscsVO, request, userCtx);
        // 화면 진입 권한을 검증한다.
        // 참여현황은 참여기간 이후에도 조회 가능하되, 참여기간 전 진입은 차단한다.
        ProcessResultVO<DscsVO> accessResultVO = dscsAccessService.validateLearnerPtcpStatusAccess(loadedVO.getDscsId());
        if(accessResultVO.getResult() < 0) {
            setResultFail(accessResultVO.getMessage());
            return redirectToSafeReferer(request, "/forum2/forumHome/Form/forumList.do");
        }

        // 학습활동조회이력 저장
        if(userCtx.isStudent()) {
            logLrnActvService.lrnActvInqHstryRegist(new LogLrnActvInqHstryVO("DSCS", loadedVO.getDscsId(), userCtx.getLoginUser().getUserId()), userCtx);
        }

        setupLearnerDscsViewModel(model, request, loadedVO, userCtx);
        return "forum2/lect/stdnt_ptcp_status_view";
    }

    /**
     * 학습자 토론방 화면으로 이동한다.
     *
     * @param dscsVO
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/Form/stdntBbsView.do")
    public String stdntBbsView(
            DscsVO dscsVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        DscsVO loadedVO = loadLearnerDscsForView(dscsVO, request, userCtx);
        // 화면 진입 권한을 검증한다.
        ProcessResultVO<DscsVO> accessResultVO = dscsAccessService.validateLearnerEnterAccess(loadedVO.getDscsId());
        if(accessResultVO.getResult() < 0) {
            setResultFail(accessResultVO.getMessage());
            return redirectToSafeReferer(request, "/forum2/forumHome/Form/forumList.do");
        }

        // 학습활동조회이력 저장
        if(userCtx.isStudent()) {
            logLrnActvService.lrnActvInqHstryRegist(new LogLrnActvInqHstryVO("DSCS", loadedVO.getDscsId(), userCtx.getLoginUser().getUserId()), userCtx);
        }

        setupLearnerDscsViewModel(model, request, loadedVO, userCtx);
        return "forum2/lect/stdnt_dscs_bbs_view";
    }

    /**
     * 학습자 토론방 게시글 목록을 조회한다.
     *
     * @param dscsVO
     * @param request
     * @return
     */
    @RequestMapping(value="/Form/forumBbsViewList.do")
    @ResponseBody
    public ProcessResultVO<DscsAtclVO> forumBbsViewList(
            DscsVO dscsVO,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        // 목록 AJAX도 service 계층에서 기간을 검증해 URL 우회를 막는다.
        ProcessResultVO<DscsVO> accessResultVO = dscsAccessService.validateLearnerEnterAccess(dscsVO.getDscsId());
        if(accessResultVO.getResult() < 0) {
            return new ProcessResultVO<DscsAtclVO>().setResultFailed(accessResultVO.getMessage());
        }
        return dscsAtclService.stdntAtclList(dscsVO, StringUtil.nvl(userCtx.getUserId()));
    }

    /**
     * 현재 학습자의 토론 참여상태를 조회한다.
     *
     * @param dscsVO
     * @param request
     * @return
     */
    @RequestMapping(value="/myJoinStatus.do")
    @ResponseBody
    public ProcessResultVO<DscsJoinUserVO> myJoinStatus(
            DscsVO dscsVO,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        ProcessResultVO<DscsJoinUserVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(userCtx.getUserId());
        DscsVO loadedVO = dscsService.selectDscs(dscsVO);
        DscsJoinUserVO joinUserVO = dscsLearnerService.buildMyJoinUser(loadedVO, userId);
        resultVO.setReturnVO(joinUserVO);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 학습자 토론 참여자 목록을 조회한다.
     *
     * @param dscsVO
     * @param request
     * @return
     */
    @RequestMapping(value="/dscsJoinUserList.do")
    @ResponseBody
    public ProcessResultVO<DscsJoinUserVO> dscsJoinUserList(DscsVO dscsVO, HttpServletRequest request) {

        ProcessResultVO<DscsJoinUserVO> resultVO = new ProcessResultVO<>();

        DscsVO loadedVO = dscsService.selectDscs(dscsVO);
        DscsJoinUserVO joinUserVO = new DscsJoinUserVO();
        joinUserVO.setSbjctId(loadedVO.getSbjctId());
        joinUserVO.setDscsId(loadedVO.getDscsId());
        joinUserVO.setTeamId(StringUtil.nvl(dscsVO.getTeamId()));
        joinUserVO.setSearchValue(dscsVO.getSearchValue());
        joinUserVO.setPageIndex(dscsVO.getPageIndex() > 0 ? dscsVO.getPageIndex() : 1);
        joinUserVO.setListScale(dscsVO.getListScale() > 0 ? dscsVO.getListScale() : 1000);
        joinUserVO.setDscsUnitTycd(loadedVO.getDscsUnitTycd());
        resultVO = dscsJoinUserService.listPaging(joinUserVO);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 현재 학습자의 찬반토론 본인 게시글 작성 상태를 조회한다.
     *
     * @param dscsVO
     * @param request
     * @return
     */
    @RequestMapping(value="/myAtclStatus.do")
    @ResponseBody
    public ProcessResultVO<DscsAtclVO> myAtclStatus(DscsVO dscsVO, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        ProcessResultVO<DscsAtclVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(userCtx.getUserId());
        DscsVO loadedVO = dscsService.selectDscs(dscsVO);

        DscsAtclVO paramVO = new DscsAtclVO();
        paramVO.setDscsId(loadedVO.getDscsId());
        paramVO.setSbjctId(loadedVO.getSbjctId());
        paramVO.setUserId(userId);

        DscsAtclVO returnVO = dscsAtclService.selectMyAtclStatus(paramVO);
        if(returnVO == null) {
            returnVO = new DscsAtclVO();
        }
        resultVO.setReturnVO(returnVO);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 피드백 화면
     *
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/dscsFdbkPop.do")
    public String dscsFdbkPop(
            DscsVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        DscsVO loadedVO = dscsService.selectDscs(vo);
        loadedVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));
        loadedVO.setTeamId(dscsLearnerService.sanitizeLearnerTeamId(loadedVO, vo.getTeamId(), StringUtil.nvl(userCtx.getUserId())));

        String userId = StringUtil.nvl(userCtx.getUserId());
        String stdId = userId;

        model.addAttribute("stdId", stdId);
        model.addAttribute("authrtGrpcd", userCtx.getAuthrtGrpcd());
        model.addAttribute("dscsVO", loadedVO);
        model.addAttribute("dscsJoinUserVO", dscsLearnerService.buildJoinUserForStd(loadedVO, stdId, userId));

        return "forum2/popup/feedback_popview";
    }

    /**
     * 피드백 목록 조회
     *
     * @param vo
     * @param request
     * @return
     */
    @RequestMapping(value="/getFdbk.do")
    @ResponseBody
    public ProcessResultVO<DscsFdbkVO> getFdbk(
            DscsVO vo,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        ProcessResultVO<DscsFdbkVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(userCtx.getUserId());
        DscsFdbkVO dscsFdbkVO = new DscsFdbkVO();
        dscsFdbkVO.setDscsId(vo.getDscsId());
        dscsFdbkVO.setStdId(userId);
        resultVO.setReturnList(dscsFdbkService.selectFdbk(dscsFdbkVO));
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 게시글 등록
     *
     * @param vo
     * @param request
     * @return
     */
    @RequestMapping(value="/Form/addAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addAtcl(
            DscsAtclVO dscsAtclVO,
            @RequestParam(value="teamId", required=false) String teamId,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsAtclService.stdntAtclRegist(dscsAtclVO, teamId, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 게시글 수정
     *
     * @param vo
     * @param request
     * @return
     */
    @RequestMapping(value="/Form/editAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editAtcl(
            DscsAtclVO dscsAtclVO,
            @RequestParam(value="teamId", required=false) String teamId,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsAtclService.stdntAtclModify(dscsAtclVO, teamId, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 게시글 삭제
     *
     * @param vo
     * @param request
     * @return
     */
    @RequestMapping(value="/Form/delAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delAtcl(
            DscsAtclVO dscsAtclVO,
            @RequestParam(value="teamId", required=false) String teamId,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsAtclService.stdntAtclDelete(dscsAtclVO, teamId, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 댓글 등록
     *
     * @param dscsVO
     * @param request
     * @return
     */
    @RequestMapping(value="/Form/addCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addCmnt(
            DscsCmntVO dscsCmntVO,
            @RequestParam(value="teamId", required=false) String teamId,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsCmntService.stdntCmntRegist(dscsCmntVO, teamId, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 댓글 수정
     *
     * @param dscsVO
     * @param request
     * @return
     */
    @RequestMapping(value="/Form/editCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editCmnt(
            DscsCmntVO dscsCmntVO,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsCmntService.stdntCmntModify(dscsCmntVO, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 댓글 삭제
     *
     * @param dscsVO
     * @param request
     * @return
     */
    @RequestMapping(value="/Form/delCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delCmnt(
            DscsCmntVO dscsCmntVO,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsCmntService.stdntCmntDelete(dscsCmntVO, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 팀 구성원 조회화면
     *
     * @param vo
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value="/teamMemberList.do")
    public String teamMemberList(
            DscsVO vo,
            ModelMap model,
            HttpServletRequest request) {

        List<EgovMap> teamMemberList = teamGrpMgrService.listTeamMembers(vo.getTeamId());
        model.addAttribute("teamMemberList", teamMemberList);
        return "forum2/popup/team_member_list_popview";
    }

    /**
     * 학습자 화면 공통 모델 속성을 설정한다.
     *
     * @param model
     * @param userCtx
     */
    private void populateCommonModel(ModelMap model, UserContext userCtx) {

        model.addAttribute("userTypecd", userCtx.getUserTycd());
    }

    /**
     * 학습자 토론 화면 공통 모델 속성을 설정한다.
     *
     * @param model
     * @param request
     * @param loadedVO
     */
    private void setupLearnerDscsViewModel(
            ModelMap model,
            HttpServletRequest request,
            DscsVO loadedVO,
            UserContext userCtx) {

        populateCommonModel(model, userCtx);
        String userId = StringUtil.nvl(userCtx.getUserId());
        String learnerTeamId = dscsLearnerService.getLearnerTeamId(loadedVO, userId);
        String learnerTargetDscsId = dscsLearnerService.resolveLearnerTargetDscsId(loadedVO, learnerTeamId);
        DscsJoinUserVO myJoinUserVO = dscsLearnerService.buildMyJoinUser(loadedVO, userId, learnerTargetDscsId);
        model.addAttribute("userId", userId);
        model.addAttribute("userName", StringUtil.nvl(SessionInfo.getUserNm(request)));
        model.addAttribute("dscsVO", loadedVO);
        model.addAttribute("myJoinUserVO", myJoinUserVO);
        model.addAttribute("learnerJoined", dscsLearnerService.hasLearnerJoined(myJoinUserVO));
        model.addAttribute("learnerTeamId", learnerTeamId);
        model.addAttribute("learnerFeedbackDscsId", learnerTargetDscsId);
    }

    /**
     * 학습자 토론 정보를 조회하고 업로드 경로와 팀 식별자를 정리한다.
     *
     * @param requestVO
     * @param request
     * @return
     * @throws Exception
     */
    private DscsVO loadLearnerDscsForView(
            DscsVO requestVO,
            HttpServletRequest request,
            UserContext userCtx) throws Exception {

        requestVO.setOrgId(userCtx.getOrgId());
        requestVO.setLangCd(userCtx.getLangCd());
        requestVO.setUserId(userCtx.getUserId());
        requestVO.setRgtrId(userCtx.getUserId());
        requestVO.setMdfrId(userCtx.getUserId());
        DscsVO loadedVO = dscsService.selectDscs(requestVO);
        loadedVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));
        loadedVO.setTeamId(dscsLearnerService.sanitizeLearnerTeamId(loadedVO, requestVO.getTeamId(), StringUtil.nvl(userCtx.getUserId())));
        return loadedVO;
    }

}
