package knou.lms.forum2.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.RepoInfo;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.service.DscsAccessService;
import knou.lms.forum2.service.DscsAtclService;
import knou.lms.forum2.service.DscsCmntService;
import knou.lms.forum2.service.DscsFdbkService;
import knou.lms.forum2.service.DscsJoinUserService;
import knou.lms.forum2.service.DscsScoreService;
import knou.lms.forum2.service.DscsService;
import knou.lms.forum2.vo.DscsAtclVO;
import knou.lms.forum2.vo.DscsCmntVO;
import knou.lms.forum2.vo.DscsFdbkVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsListVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import knou.lms.forum2.vo.DscsVO;
import knou.lms.forum2.web.validation.DscsSaveValidator;
import knou.lms.team.service.TeamCtgrService;
import knou.lms.team.service.TeamMemberService;
import knou.lms.team.service.TeamService;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.team.vo.TeamVO;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value = "/forum2/forumLect")
public class DscsLectController extends DscsControllerBase {
    private static final Logger LOGGER = LoggerFactory.getLogger(DscsLectController.class);

    // Validator 오류 메시지 변환
    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name = "dscsService")
    private DscsService dscsService;

    @Resource(name = "dscsAccessService")
    private DscsAccessService dscsAccessService;

    @Resource(name = "dscsAtclService")
    private DscsAtclService dscsAtclService;

    @Resource(name = "dscsCmntService")
    private DscsCmntService dscsCmntService;

    @Resource(name="dscsJoinUserService")
    private DscsJoinUserService dscsJoinUserService;

    @Resource(name="dscsFdbkService")
    private DscsFdbkService dscsFdbkService;

    @Resource(name="dscsScoreService")
    private DscsScoreService dscsScoreService;

    // 토론 저장 검증
    @Resource(name="dscsSaveValidator")
    private DscsSaveValidator dscsSaveValidator;

    @Resource(name="teamService")
    private TeamService teamService;

    @Resource(name="teamCtgrService")
    private TeamCtgrService teamCtgrService;

    @Resource(name="teamMemberService")
    private TeamMemberService teamMemberService;

    private String test_sbjctId = "SBJCT_OFRNG_ID1";

    /**
     * 토론목록화면이동
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumListView.do")
    public String profForumListView(
            DscsListVO dscsListVO,
            ModelMap model,
            HttpServletRequest request) throws Exception {


        // TODO : Test Code 값 추후 수정 예정.(setSbjctId, setTeamGrpId)
        if (dscsListVO.getSbjctId() == null) {
            addEncParam("sbjctId", test_sbjctId);
        }

        model.addAttribute("dscsListVO", dscsListVO);

        return "forum2/lect/prof_dscs_list_view";
    }

    /**
     * 토론작성화면이동
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profDscsWriteView.do")
    public String profDscsWriteView(
            DscsVO dscsVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {


        List<DscsVO> dvclasList = dscsService.selectDscsDvclasList(dscsVO);
        model.addAttribute("dvclasList", dvclasList);

        dscsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));
        // 등록 or 수정 구분 - I : 등록, E : 수정
        model.addAttribute("mode", "I");
        model.addAttribute("dscsVO", dscsVO);

        dscsVO.setOrgId(userCtx.getOrgId());
        dscsVO.setLangCd(userCtx.getLangCd());
        dscsVO.setUserId(userCtx.getUserId());
        dscsVO.setRgtrId(userCtx.getUserId());
        dscsVO.setMdfrId(userCtx.getUserId());

        return "forum2/lect/prof_dscs_write_view";
    }
    
    /**
     * 토론목록조회
     * @param vo
     * @param request
     * @return
     */
    @RequestMapping(value = "/bySubjectDscsList.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> bySubjectDscsList(
            DscsVO vo,
            @CurrentUser UserContext usrCtx,
            HttpServletRequest request) {

        return new ProcessResultVO<EgovMap>().setReturnList(dscsService.bySubjectDscsList(vo)).setResultSuccess();
    }

    /**
     * 토론목록조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profDscsList.do")
    @ResponseBody
    public ProcessResultVO<DscsListVO> profDscsList(
            DscsListVO vo,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        ProcessResultVO<DscsListVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        vo.setLangCd(userCtx.getLangCd());
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        resultVO = dscsService.selectProfDscsList(vo);
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 토론저장
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profDscsRegist.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> profDscsRegist(
            DscsVO vo,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        applyDscsAudit(vo, userCtx);

        // 토론 등록 입력값 검증
        BindingResult bindingResult = new BeanPropertyBindingResult(vo, "dscsVO");
        dscsSaveValidator.validateForRegist(vo, bindingResult);
        String validationMessage = getValidationMessage(bindingResult, request);
        if (validationMessage != null) {
            return resultVO.setResultFailed(validationMessage);
        }

        resultVO = dscsService.saveDscs(vo);
        // 저장 실패 시 서비스 결과 반환
        if (resultVO.getResult() <= 0) {
            return withFailMessage(resultVO);
        }
        resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 토론수정화면이동
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profDscsEditView.do")
    public String profDscsEditView(
            DscsVO dscsVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {


        // 등록 or 수정 구분 - I : 등록, E : 수정
        model.addAttribute("mode", "E");

        if (!StringUtil.isNull(dscsVO.getDscsId())) {
            dscsVO.setOrgId(userCtx.getOrgId());
            dscsVO.setLangCd(userCtx.getLangCd());
            dscsVO.setUserId(userCtx.getUserId());
            dscsVO.setRgtrId(userCtx.getUserId());
            dscsVO.setMdfrId(userCtx.getUserId());

            dscsVO = dscsService.selectDscs(dscsVO);
            // 화면 진입 권한 검증한다.
            ProcessResultVO<DscsVO> accessResultVO = dscsAccessService.validateProfessorEditAccess(dscsVO.getDscsId());
            if (accessResultVO.getResult() < 0) {
                // 토론 목록 화면으로 이동한다.
                setResultFail(accessResultVO.getMessage());
                return redirectToSafeReferer(request, "/forum2/forumLect/profForumListView.do");
            }
            // 첨부파일저장소 설정
            dscsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

            // 분반 목록 조회 (teamForumDiv 렌더링용 — sbjctId 는 selectForum 에서 반환됨)
            List<DscsVO> dvclasList = dscsService.selectDscsDvclasList(dscsVO);
            model.addAttribute("dvclasList", dvclasList);

            model.addAttribute("dscsVO", dscsVO);
        }

        return "forum2/lect/prof_dscs_write_view";
    }

    /**
     * 토론수정
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profDscsModify.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> profDscsModify(
            DscsVO vo,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        applyDscsAudit(vo, userCtx);

        // 토론 수정 입력값 검증
        BindingResult bindingResult = new BeanPropertyBindingResult(vo, "dscsVO");
        dscsSaveValidator.validateForModify(vo, bindingResult);
        String validationMessage = getValidationMessage(bindingResult, request);
        if (validationMessage != null) {
            return resultVO.setResultFailed(validationMessage);
        }

        resultVO = dscsService.saveDscs(vo);
        // 저장 실패 시 서비스 결과 반환
        if (resultVO.getResult() <= 0) {
            return withFailMessage(resultVO);
        }
        resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        resultVO.setResultSuccess();

        return withFailMessage(resultVO);
    }

    /**
     * 토론 저장/수정 시 공통으로 필요한 사용자 감사 정보를 설정한다.
     * @param vo
     * @param userCtx
     */
    private void applyDscsAudit(DscsVO vo, UserContext userCtx) {

        vo.setOrgId(userCtx.getOrgId());
        vo.setLangCd(userCtx.getLangCd());
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
    }

    /**
     * Validator 오류 중 첫 번째 메시지를 현재 요청 locale 기준으로 반환한다.
     * @param bindingResult
     * @param request
     * @return
     */
    private String getValidationMessage(BindingResult bindingResult, HttpServletRequest request) {

        if (!bindingResult.hasErrors()) {
            return null;
        }

        ObjectError error = bindingResult.getAllErrors().get(0);
        return messageSource.getMessage(error, LocaleUtil.getLocale(request));
    }

    // 이전 토론 가져오기 팝업
    @RequestMapping(value="/Form/forumCopyPop.do")
    public String dscsCopyPop(DscsVO dscsVO, ModelMap model) {

        // 대표교수의 과목이 있는 학기기수 목록 조회
        List<EgovMap> smstrChrtList = dscsService.selectProfSmstrChrtList(dscsVO);

        model.addAttribute("dscsVO", dscsVO);
        model.addAttribute("smstrChrtList", smstrChrtList);

        return "forum2/popup/prof_dscs_copy_popview";
    }

    // 교수학기기수별과목목록 조회 ajax (토론 복사 팝업용)
    @RequestMapping(value="/Form/smstrChrtSbjctListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> smstrChrtSbjctListAjax(DscsVO vo, HttpServletRequest request) {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        resultVO.setReturnList(dscsService.selectProfSmstrChrtSbjctList(vo));
        resultVO.setResult(1);

        return resultVO;

    }

    // 이전 토론 가져오기 리스트 ajax
    @RequestMapping(value="/Form/dscsCopyList.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> dscsCopyList(
            @RequestBody DscsVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        String orgId = userCtx.getOrgId();
        String userId = StringUtil.nvl(userCtx.getUserId());

        vo.setUserId(userId);
        vo.setOrgId(orgId);
        resultVO = dscsService.selectProfSbjctDscsList(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    // 이전 토론 가져오기 ajax
    @RequestMapping(value="/Form/dscsCopy.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> dscsCopy(DscsVO dscsVO, ModelMap model, HttpServletRequest request) {

        ProcessResultVO<DscsVO> returnVO = new ProcessResultVO<DscsVO>();

        dscsVO = dscsService.selectDscs(dscsVO);
        // 복사시 이전 토론 ID 는 제거한다.
        dscsVO.setDscsId("");

        returnVO.setReturnVO(dscsVO);
        returnVO.setResult(1);

        return returnVO;
    }

    /**
     * 팀그룹 팀 목록 조회 (팀 토론 부주제 설정용)
     */
    @RequestMapping(value = "/profDscsTeamGrpTeamListAjax.do")
    @ResponseBody
    public ProcessResultVO<DscsTeamDscsVO> profDscsTeamGrpTeamListAjax(
            DscsTeamDscsVO vo, HttpServletRequest request) {

        ProcessResultVO<DscsTeamDscsVO> resultVO = new ProcessResultVO<>();

        resultVO = dscsService.selectDscsTeamGrpTeamList(vo);
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 토론 성적공개여부 수정
     * @param vo
     * @param request
     * @return
     */
    @RequestMapping(value = "/profDscsMrkOynModify.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> profDscsMrkOynModify(DscsVO vo, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(vo.getDscsId())) {
            resultVO.setResultFailed("dscsId is required");
            return resultVO;
        }

        String mrkOyn = StringUtil.nvl(vo.getMrkOyn());

        mrkOyn = mrkOyn.toUpperCase();

        if (!"Y".equals(mrkOyn) && !"N".equals(mrkOyn)) {
            resultVO.setResultFailed("수정 중 에러가 발생하였습니다.");
            return resultVO;
        }

        vo.setOrgId(userCtx.getOrgId());
        vo.setLangCd(userCtx.getLangCd());
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        vo.setMrkOyn(mrkOyn);
        resultVO = dscsService.modifyDscsMrkOyn(vo);

        return resultVO;
    }

    /**
     * 토론 성적반영비율 수정
     * @param list
     * @param request
     * @return
     */
    @RequestMapping(value = "/forumMrkRfltrtModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> dscsMrkRfltrtModifyAjax(
            @RequestBody List<DscsVO> list,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        String userId = StringUtil.nvl(userCtx.getUserId());
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        for (DscsVO vo : list) {
            vo.setOrgId(userCtx.getOrgId());
            vo.setLangCd(userCtx.getLangCd());
            vo.setUserId(userCtx.getUserId());
            vo.setRgtrId(userCtx.getUserId());
            vo.setMdfrId(userCtx.getUserId());
            vo.setMdfrId(userId);
        }
        dscsService.updateDscsMrkRfltrt(list);
        resultVO.setResultSuccess();

        return resultVO;
    }
    
    /**
     * 토론삭제
     * @param vo
     * @param request
     * @return
     */
    @RequestMapping(value = "/profDscsDelete.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> profDscsDelete(@RequestBody DscsVO vo, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        vo.setLangCd(userCtx.getLangCd());
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        resultVO = dscsService.deleteDscs(vo);

        if (resultVO.getResult() == 0) {
            // 성적반영여부(SCORE_APLY_YN)가 Y인 경우에 성적반영 비율 100% 기준으로 1/N 자동 계산하여 성적반영비율 필더(SCORE_RATIO)에 저장
            dscsService.setScoreRatio(vo);

            resultVO.setResultSuccess();
        }

        return withFailMessage(resultVO);
    }

    /**
     * 토론방
     * @param dscsVO
     * @param request
     * @throws Exception
     */
    @RequestMapping(value = "/Form/bbsManage.do")
    public String bbsManage(
            DscsVO dscsVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        /**
         * selectDscs 필수값 : dscsId, sbjctId
         */
        dscsVO = dscsService.selectDscs(dscsVO);

        // 첨부파일저장소 설정
        dscsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

        model.addAttribute("userTypecd", userCtx.getUserTycd());
        model.addAttribute("userId", StringUtil.nvl(userCtx.getUserId()));
        model.addAttribute("userName", StringUtil.nvl(SessionInfo.getUserNm(request)));
        model.addAttribute("dscsVO", dscsVO);

        return "forum2/lect/prof_dscs_bbs_manage";
    }

    @RequestMapping(value = "/Form/forumBbsViewList.do")
    @ResponseBody
    public ProcessResultVO<DscsAtclVO> dscsBbsViewList(DscsVO dscsVO, HttpServletRequest request) {

        return dscsAtclService.profAtclList(dscsVO);
    }

    /**
     * 토론방게시글저장
     * @param vo
     * @param request
     * @return
     */
    @RequestMapping(value = "/Form/addAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addAtcl(
            DscsAtclVO dscsAtclVO,
            @RequestParam(value = "teamId", required = false) String teamId,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsAtclService.profAtclRegist(dscsAtclVO, teamId, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 토론게시글수정
     * @param dscsAtclVO
     * @param request
     * @return
     */
    @RequestMapping(value = "/Form/editAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editAtcl(DscsAtclVO dscsAtclVO, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsAtclService.profAtclModify(dscsAtclVO, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 토론게시글삭제
     * @param dscsAtclVO
     * @param request
     * @return
     */
    @RequestMapping(value = "/Form/delAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delAtcl(DscsAtclVO dscsAtclVO, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsAtclService.profAtclDelete(dscsAtclVO, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 참여글 숨김
     * @param dscsAtclVO
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/Form/hideAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> hideAtcl(DscsAtclVO dscsAtclVO, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsAtclService.profAtclHide(dscsAtclVO, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 토론댓글등록
     * @param dscsCmntVO
     * @param request
     * @return
     */
    @RequestMapping(value = "/Form/addCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addCmnt(DscsCmntVO dscsCmntVO, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsCmntService.profCmntRegist(dscsCmntVO, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 토론댓글수정
     * @param dscsVO
     * @param request
     * @return
     */
    @RequestMapping(value = "/Form/editCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editCmnt(DscsCmntVO dscsCmntVO, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsCmntService.profCmntModify(dscsCmntVO, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 토론방댓글삭제
     * @param dscsCmntVO
     * @param request
     * @return
     */
    @RequestMapping(value = "/Form/delCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delCmnt(DscsCmntVO dscsCmntVO, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsCmntService.profCmntDelete(dscsCmntVO, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 댓글 숨김
     * @param dscsCmntVO
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/Form/hideCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> hideCmnt(DscsCmntVO dscsCmntVO, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        return withFailMessage(dscsCmntService.profCmntHide(dscsCmntVO, StringUtil.nvl(userCtx.getUserId())));
    }

    /**
     * 팀토론토론방OPEN여부 수정
     * @param vo
     * @param request
     * @return
     */
    @RequestMapping(value = "/profTeamDscsOynModify.do")
    @ResponseBody
    public ProcessResultVO<DscsTeamDscsVO> profTeamDscsOynModify(
            DscsTeamDscsVO vo,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        ProcessResultVO<DscsTeamDscsVO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(vo.getDscsId())) {
            resultVO.setResultFailed("dscsId is required");
            return resultVO;
        }

        String mrkOyn = StringUtil.nvl(vo.getTeamDscsOyn());

        mrkOyn = mrkOyn.toUpperCase();

        if (!"Y".equals(mrkOyn) && !"N".equals(mrkOyn)) {
            resultVO.setResultFailed("수정 중 에러가 발생하였습니다.");
            return resultVO;
        }
        String userId = StringUtil.nvl(userCtx.getUserId());
        vo.setMdfrId(userId);
        vo.setTeamDscsOyn(mrkOyn);
        resultVO = dscsService.modifyTeamDscsOyn(vo);

        return resultVO;
    }

    /**
     * 팀토론 토론방 팀리스트
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/listTeamJson.do")
    @ResponseBody
    public ProcessResultVO<TeamVO> listTeamJson(
            TeamCtgrVO vo,
            ModelMap model,
            HttpServletRequest request) throws Exception {

        ProcessResultVO<TeamVO> returnVO = new ProcessResultVO<>();

        String teamCtgrCd = vo.getTeamCtgrCd();

        if(ValidationUtils.isNotEmpty(teamCtgrCd)) {
            TeamVO teamVO = new TeamVO();
            teamVO.setTeamCtgrCd(teamCtgrCd);
            List<TeamVO> list = teamService.teamList(teamVO);
            returnVO.setReturnList(list);
        }

        returnVO.setResult(1);

        return returnVO;
    }

    /**
     * 팀 구성원 보기
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/teamMemberList.do")
    public String teamMemberList(TeamCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        List<TeamCtgrVO> teamCtgrList = teamCtgrService.teamList(vo);
        model.addAttribute("teamCtgrList", teamCtgrList);

        return "forum/popup/team_member_list_pop";
    }

    /**
     * 팀 구성원 ajax
     * @param vo
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/teamMember.do")
    @ResponseBody
    public ProcessResultVO<TeamMemberVO> listTeam(
            TeamVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        ProcessResultVO<TeamMemberVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(userCtx.getUserId());
        vo.setUserId(userId);

        // List<TeamMemberVO> list = teamService.list(vo);
        List<TeamMemberVO> list = teamMemberService.selectTeamMemberList(vo);
        resultVO.setReturnList(list);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 성적평가
     * @param dscsVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/Form/scoreManage.do")
    public String scoreManage(
            DscsVO dscsVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        // 토론 기본 정보 조회
        dscsVO = dscsService.selectDscs(dscsVO);

        // 26.5.7:평가전 미참여자도 PTCP_ID 가 미리 들어가 있어야 평가를 할 수 있음.
        // 모든 토론 참여자를 토론 참여자 테이블에 삽입
        dscsScoreService.ensureScoreManageJoinUsers(dscsVO, StringUtil.nvl(userCtx.getUserId()));

        // 찬반현황 차트용
        dscsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));
        model.addAttribute("dscsVO", dscsVO);
        if ("TEAM".equals(dscsVO.getDscsUnitTycd())) {
            model.addAttribute("teamList", dscsVO.getTeamDscsList());
        }
        model.addAttribute("authrtCd", userCtx.getAuthrtCd());
        model.addAttribute("userTypecd", userCtx.getUserTycd());

        return "forum2/lect/prof_dscs_score_manage";
    }

    /**
     * 토론 참여 사용자 리스트 가져오기 ajax
     * @param dscsJoinUserVO
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value="/dscsJoinUserList.do")
    @ResponseBody
    public ProcessResultVO<DscsJoinUserVO> dscsJoinUserList(
            DscsJoinUserVO dscsJoinUserVO,
            ModelMap model,
            HttpServletRequest request) {

        return dscsScoreService.listScoreJoinUsers(dscsJoinUserVO);
    }

    /**
     * 토론 참여자 성적 변경 ajax
     * @param dscsJoinUserVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/updateDscsJoinUserScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateDscsJoinUserScore(
            DscsJoinUserVO dscsJoinUserVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        return dscsScoreService.updateScore(dscsJoinUserVO, StringUtil.nvl(userCtx.getUserId()));
    }

    /**
     * 토론 참여자 글자수로 점수 주기(ajax)
     * @param dscsJoinUserVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/updateDscsJoinUserLenScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateDscsJoinUserLenScore(
            DscsJoinUserVO dscsJoinUserVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        return dscsScoreService.updateLenScore(dscsJoinUserVO, StringUtil.nvl(userCtx.getUserId()));
    }

    /**
     * 토론 성적평가 엑셀 다운로드
     * @param dscsJoinUserVO
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value="/forumScoreExcelDown.do")
    public String dscsScoreExcelDown(
            DscsJoinUserVO dscsJoinUserVO,
            ModelMap model,
            HttpServletRequest request) {

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        dscsJoinUserVO.setPagingYn("N");
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적평가리스트");
        map.put("sheetName", "성적평가리스트");
        map.put("excelGrid", dscsJoinUserVO.getExcelGrid());
        map.put("list", dscsJoinUserService.listPaging(dscsJoinUserVO).getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("outFileName", "성적평가리스트_" + date.format(today));
        modelMap.put("workbook", excelUtilPoi.simpleBigGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /**
     * 교수>토론평가>토론참여현황차트Ajax
     * @param vo
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value="/ptcpSummaryChartAjax.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> ptcpSummaryChartAjax(DscsVO dscsVO, ModelMap model, HttpServletRequest request) {

        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        resultVO.setReturnVO(dscsService.selectDscs(dscsVO));
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 교수>토론평가>성적분포현황차트Ajax
     * @param vo
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value="/scoreSummaryChartAjax.do")
    @ResponseBody
    public ProcessResultVO<HashMap<String, Object>> scoreSummaryChartAjax(DscsVO dscsVO, ModelMap model, HttpServletRequest request) {

        return dscsScoreService.scoreSummaryChart(dscsVO);
    }

    /**
     * 교수 메모 팝업창 정보
     * @param dscsJoinUserVO
     * @param model
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/dscsProfMemoPop.do")
    public String dscsProfMemoPop(
            DscsJoinUserVO dscsJoinUserVO,
            ModelMap model,
            @CurrentUser UserContext userCtx) {

        model.addAttribute("dscsId", dscsJoinUserVO.getDscsId());
        model.addAttribute("stdId", dscsJoinUserVO.getStdId());

        dscsJoinUserVO.setUserId(userCtx.getUserId());
        dscsJoinUserVO = dscsJoinUserService.selectProfMemo(dscsJoinUserVO);
        model.addAttribute("dscsJoinUserVO", dscsJoinUserVO);

        return "forum2/popup/prof_memo_popview";
    }

    /**
     * 교수 메모 수정
     * @param vo
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/editDscsProfMemo.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editDscsProfMemo(
            DscsJoinUserVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        String userId = StringUtil.nvl(userCtx.getUserId());
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        vo.setMdfrId(userId);
        dscsJoinUserService.editDscsProfMemo(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 피드백 팝업 화면 이동
     * @param vo
     * @param model
     * @param request
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/dscsFdbkPop.do")
    public String dscsFdbkPop(
            DscsVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) throws Exception {

        vo.setTeamId(StringUtil.nvl(vo.getTeamId()));
        vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
        dscsJoinUserVO.setDscsId(vo.getDscsId());
        dscsJoinUserVO.setStdId(vo.getStdId());
        dscsJoinUserVO.setUserId(StringUtil.nvl(userCtx.getUserId()));

        model.addAttribute("stdId", vo.getStdId());
        model.addAttribute("authrtGrpcd", userCtx.getAuthrtGrpcd());
        model.addAttribute("dscsJoinUserVO", dscsJoinUserService.selectProfMemo(dscsJoinUserVO));
        model.addAttribute("dscsVO", vo);

        return "forum2/popup/feedback_popview";
    }

    /**
     * 피드백 목록 조회
     * @param dscsFdbkVO
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value="/getFdbk.do")
    @ResponseBody
    public ProcessResultVO<DscsFdbkVO> getFdbk(
            DscsFdbkVO dscsFdbkVO,
            ModelMap model,
            HttpServletRequest request) {

        // 피드백 리스트
        ProcessResultVO<DscsFdbkVO> resultVO = new ProcessResultVO<>();

        List<DscsFdbkVO> list = dscsFdbkService.selectFdbk(dscsFdbkVO);
        resultVO.setReturnList(list);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 피드백 저장
     * @param vo
     * @param model
     * @param request
     * @param response
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/Form/regFdbk.do")
    @ResponseBody
    public ProcessResultVO<DscsFdbkVO> regFdbk(
            DscsFdbkVO vo,
            ModelMap model,
            HttpServletRequest request,
            HttpServletResponse response,
            @CurrentUser UserContext userCtx) {

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());
        vo.setTeamId(StringUtil.nvl(vo.getTeamId()));

        // 피드백 저장
        ProcessResultVO<DscsFdbkVO> resultVO = dscsFdbkService.insertFdbk(vo);

        /*sendFeedbackMessage(request, vo, stdArr);*/

        return resultVO;
    }

    /**
     * 피드백 쪽지 발송 대상 학생 ID 목록을 생성한다.
     * stdIds가 있으면 해당 값을 우선 사용하고, 없으면 stdId 단일값을 사용한다.
     * @param vo
     * @return
     */
    private String[] getFeedbackTargetStdIds(DscsFdbkVO vo) {

        String stdIds = StringUtil.nvl(vo.getStdIds());
        if ("".equals(stdIds)) {
            stdIds = StringUtil.nvl(vo.getStdId());
        }

        List<String> targetStdIds = new ArrayList<>();
        if (!"".equals(stdIds)) {
            for (String stdId : stdIds.split(",")) {
                String targetStdId = StringUtil.nvl(stdId).trim();
                if (!"".equals(targetStdId) && !targetStdIds.contains(targetStdId)) {
                    targetStdIds.add(targetStdId);
                }
            }
        }

        return targetStdIds.toArray(new String[targetStdIds.size()]);
    }

    /**
     * 피드백 수정
     * @param vo
     * @param model
     * @param request
     * @param response
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/edtFdbk.do")
    @ResponseBody
    public ProcessResultVO<DscsFdbkVO> edtFdbk(
            DscsFdbkVO vo,
            ModelMap model,
            HttpServletRequest request,
            HttpServletResponse response,
            @CurrentUser UserContext userCtx) {

        vo.setUserId(userCtx.getUserId());

        return dscsFdbkService.updateFdbk(vo);
    }

    /**
     * 피드백 삭제
     * @param vo
     * @param model
     * @param request
     * @param response
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/delFdbk.do")
    @ResponseBody
    public ProcessResultVO<DscsFdbkVO> delFdbk(
            DscsFdbkVO vo,
            ModelMap model,
            HttpServletRequest request,
            HttpServletResponse response,
            @CurrentUser UserContext userCtx) {

        vo.setUserId(userCtx.getUserId());

        return dscsFdbkService.deleteFdbk(vo);
    }

    /**
     * 엑셀성적등록팝업 화면 이동
     * @param dscsVO
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/forumScoreExcelUploadPop.do")
    public String dscsScoreExcelUploadPop(
            DscsVO dscsVO,
            ModelMap model,
            HttpServletRequest request) throws Exception {

        dscsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

        model.addAttribute("dscsVO", dscsVO);

        return "forum2/popup/prof_score_excel_upload_popview";
    }

    /**
     * 엑셀 성적 등록 샘플 엑셀 다운로드
     * @param dscsVO
     * @param model
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value="/forumScoreSampleDownload.do")
    public String dscsScoreSampleDownload(
            DscsVO dscsVO,
            ModelMap model,
            HttpServletRequest request,
            HttpServletResponse response) {

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();

        dscsJoinUserVO.setSbjctId(dscsVO.getSbjctId());
        dscsJoinUserVO.setDscsId(dscsVO.getDscsId());

        dscsJoinUserVO.setSearchValue(dscsVO.getSearchValue());
        dscsJoinUserVO.setPageIndex(dscsVO.getPageIndex());
        dscsJoinUserVO.setListScale(1000);
        dscsJoinUserVO.setDscsUnitTycd(dscsVO.getDscsUnitTycd());
        ProcessResultVO<DscsJoinUserVO> resultList = dscsJoinUserService.listPaging(dscsJoinUserVO);
        model.addAttribute("dscsJoinUserList", resultList.getReturnList());
        model.addAttribute("pageInfo", resultList.getPageInfo());

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적등록_학습자목록");
        map.put("sheetName", "성적등록_학습자목록");
        map.put("excelGrid", dscsVO.getExcelGrid());

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

    /**
     * 업로드된 점수 엑셀 파일을 읽어 토론 참여자 점수에 반영한다.
     * @param dscsJoinUserVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/uploadDscsScoreExcel.do")
    @ResponseBody
    public ProcessResultVO<DscsJoinUserVO> uploadDscsScoreExcel(
            DscsJoinUserVO dscsJoinUserVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        ProcessResultVO<DscsJoinUserVO> resultVO = dscsScoreService.uploadScoreExcel(dscsJoinUserVO, userCtx);
        if (resultVO.getResult() < 0 && StringUtil.isNull(resultVO.getMessage())) {
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /**
     * 성적평가 리스트 엑셀 다운로드
     * @param dscsVO
     * @param model
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value="/listScoreExcel.do")
    public String listScoreExcel(
            DscsVO dscsVO,
            ModelMap model,
            HttpServletRequest request,
            HttpServletResponse response) {

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();

        dscsJoinUserVO.setSbjctId(dscsVO.getSbjctId());
        dscsJoinUserVO.setDscsId(dscsVO.getDscsId());
        dscsJoinUserVO.setSearchValue(dscsVO.getSearchValue());
        dscsJoinUserVO.setPageIndex(dscsVO.getPageIndex());
        // dscsJoinUserVO.setListScale(dscsVO.getListScale());
        dscsJoinUserVO.setListScale(1000);

        ProcessResultVO<DscsJoinUserVO> resultList = dscsJoinUserService.listPaging(dscsJoinUserVO);
        model.addAttribute("dscsJoinUserList", resultList.getReturnList());
        model.addAttribute("pageInfo", resultList.getPageInfo());

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적평가리스트");
        map.put("sheetName", "성적평가리스트");
        map.put("excelGrid", dscsVO.getExcelGrid());

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


    /**
     * 참여형 일괄평가
     * @param vo
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/participateScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> participateScore(
            DscsJoinUserVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        return dscsScoreService.participateScore(vo, StringUtil.nvl(userCtx.getUserId()));
    }

    /**
     * 개별 평가점수
     * @param vo
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/setScoreRatio.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> setScoreRatio(
            DscsJoinUserVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        return dscsScoreService.setScoreRatio(vo, StringUtil.nvl(userCtx.getUserId()));
    }

    /**
     * 토론 현황 차트 팝업 화면을 구성한다.
     * @param vo
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value="/forumChartViewPop.do")
    public String dscsChartViewPop(DscsVO vo, ModelMap model, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        String sbjctId = vo.getSbjctId();
        String orgId = StringUtil.nvl(userCtx.getOrgId());

        model.addAllAttributes(dscsScoreService.calculateScoreSummary(vo.getDscsId()));

        /*vo = dscsService.selectDscs(vo);*/
        DscsVO param = new DscsVO();
        param.setSbjctId(vo.getSbjctId());
        param.setDscsId(vo.getDscsId());
        DscsVO loadedDscsVO = dscsService.selectDscs(param);
        vo = loadedDscsVO;
        // 찬반현황 차트용
        vo.setOrgId(orgId);
        vo.setSbjctId(sbjctId);

        model.addAttribute("dscsVO", vo);

        return "forum2/popup/prof_chart_popview";
    }

    /**
     * 피드백 등록 후 학습자에게 쪽지를 발송한다.
     * 향후 쪽지 연동 재개를 위해 현재는 구현 골격을 보존한다.
     * @param request
     * @param vo
     * @param stdNoArr
     */
    private void sendFeedbackMessage(HttpServletRequest request, DscsFdbkVO vo, String[] stdNoArr) {

        // 쪽지발송 처리
        /*if("Y".equals(CommConst.FEEDBACK_MESSAGE_SEND_YN)) {
            String orgId = userCtx.getOrgId();

            // 과목정보
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsVO = crecrsService.selectCreCrs(creCrsVO);

            // 토론정보
            DscsVO dscsVO = new DscsVO();
            dscsVO.setDscsId(vo.getDscsId());
            dscsVO = forumService.selectDscs(dscsVO);

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
                String msgCtnt = "<b>[" + creCrsVO.getCrsCreNm() + "] 과목, [" + dscsVO.getDscsTtl() + "] 교수님 피드백입니다.</b><br>";
                msgCtnt += vo.getDscsFdbkCts();

                ErpMessageMsgVO erpMessageMsgVO = new ErpMessageMsgVO();
                erpMessageMsgVO.setUsrUserInfoList(listUserRecvInfo);
                erpMessageMsgVO.setCtnt(msgCtnt);
                erpMessageMsgVO.setCrsCreCd(vo.getCrsCreCd());

                // 쪽지발송 저장
                erpService.insertSysMessageMsg(request, erpMessageMsgVO, "토론 피드백 쪽지 발송");
            }
        }*/
    }

}


