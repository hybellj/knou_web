package knou.lms.forum2.web;

import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.user.CurrentUser;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.service.DscsAtclService;
import knou.lms.forum2.service.DscsEzGraderService;
import knou.lms.forum2.service.DscsFdbkService;
import knou.lms.forum2.service.DscsJoinUserService;
import knou.lms.forum2.service.DscsService;
import knou.lms.forum2.vo.DscsAtclVO;
import knou.lms.forum2.vo.DscsEzGraderRsltVO;
import knou.lms.forum2.vo.DscsEzGraderVO;
import knou.lms.forum2.vo.DscsFdbkVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;
import knou.lms.forum2.vo.DscsVO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping(value = "/forum2/ezgPop")
public class DscsEzGraderLectController extends DscsControllerBase {

    // EZ-Grader
    @Resource(name="dscsEzGraderService")
    private DscsEzGraderService dscsEzGraderService;
    
    // 토론 정보
    @Resource(name="dscsService")
    private DscsService dscsService;

    @Resource(name = "dscsAtclService")
    private DscsAtclService dscsAtclService;
    
    // 토론 참여자
    @Resource(name = "dscsJoinUserService")
    private DscsJoinUserService dscsJoinUserService;
    
    @Resource(name = "dscsFdbkService")
    private DscsFdbkService dscsFdbkService;
    
    // EZ-Grader 메인
    @RequestMapping(value = "/ezgMainForm.do")
    public String getEzgMainView(DscsEzGraderVO vo, ModelMap model, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        String orgId = StringUtil.nvl(userCtx.getOrgId());
        String userId = StringUtil.nvl(userCtx.getUserId());
        String sbjctId = StringUtil.nvl(vo.getSbjctId());
        String initialStdId = StringUtil.nvl(vo.getStdId());
        String initialTeamId = StringUtil.nvl(vo.getTeamId());
        
        // EZ-Grader 화면과 include JSP에서 공통으로 사용할 토론 기본 정보를 조회
        DscsVO dscsVO = new DscsVO();
        dscsVO.setOrgId(orgId);
        dscsVO.setRgtrId(userId);
        dscsVO.setSbjctId(sbjctId);
        dscsVO.setDscsId(vo.getDscsId());
        DscsVO loadedDscsVO = dscsService.selectDscs(dscsVO);
        if (loadedDscsVO == null) {
            loadedDscsVO = dscsVO;
        }
        loadedDscsVO.setOrgId(orgId);
        loadedDscsVO.setSbjctId(StringUtil.nvl(loadedDscsVO.getSbjctId(), sbjctId));

        model.addAttribute("dscsVO", loadedDscsVO);
        model.addAttribute("initialStdId", initialStdId);
        model.addAttribute("initialTeamId", initialTeamId);
        
        return "forum2/ezgPop/ezg_main_form";
    }

    // 토론 제출 대상 리스트 조회
    @RequestMapping(value = "/joinUserList.do")
    public String getForumJoinUserListForEzg(
            DscsVO dscsVO,
            ModelMap model,
            HttpServletRequest request,
            HttpServletResponse response,
            @CurrentUser UserContext userCtx) {

        String orgId = StringUtil.nvl(userCtx.getOrgId());

        dscsVO.setOrgId(orgId);
        String searchKey = StringUtil.nvl(dscsVO.getSearchKey());
        String searchSort = StringUtil.nvl(dscsVO.getSearchSort());
        String stdId = StringUtil.nvl(dscsVO.getStdId());
        String teamId = StringUtil.nvl(dscsVO.getTeamId());

        dscsVO = dscsService.selectDscs(dscsVO);
        dscsVO.setSearchKey(searchKey);
        dscsVO.setSearchSort(searchSort);
        dscsVO.setStdId(stdId);
        dscsVO.setTeamId(teamId);

        DscsJoinUserVO paramVO = new DscsJoinUserVO();
        paramVO.setDscsId(dscsVO.getDscsId());
        paramVO.setSbjctId(dscsVO.getSbjctId());
        paramVO.setSearchKey(searchKey);
        paramVO.setSearchSort(searchSort);
        paramVO.setDscsUnitTycd(dscsVO.getDscsUnitTycd());

        String viewNm = "";
        // 개인/팀 조회 결과의 학습자 필드는 DscsJoinUserVO 기준으로 통일한다.
        if ("TEAM".equals(dscsVO.getDscsUnitTycd())) {
            List<DscsEzGraderTeamVO> resultList= dscsEzGraderService.listDscsJoinTeam(paramVO);
            model.addAttribute("resultList", resultList);
            viewNm = "forum2/ezgPop/ezg_join_team_list";
        } else {
            List<DscsJoinUserVO> resultList= dscsEzGraderService.listDscsJoinUser(paramVO);
            model.addAttribute("resultList", resultList);
            viewNm = "forum2/ezgPop/ezg_join_user_list";
        }

        model.addAttribute("dscsVO", dscsVO);

        return viewNm;
    }

    // EZ-Grader 토론 활동 목록 조회
    @RequestMapping(value = "/dscsActivityList.do")
    @ResponseBody
    public ProcessResultVO<Map<String, Object>> dscsActivityList(DscsVO dscsVO, HttpServletRequest request) {

        DscsAtclVO atclVO = new DscsAtclVO();
        atclVO.setDscsId(dscsVO.getDscsId());
        atclVO.setSbjctId(dscsVO.getSbjctId());
        atclVO.setStdId(dscsVO.getStdId());
        atclVO.setStdList(dscsVO.getStdList());
        atclVO.setViewAll(true);

        ProcessResultVO<Map<String, Object>> resultVO = dscsAtclService.listEzgActivity(atclVO);
        Map<String, Object> meta = new HashMap<String, Object>();
        meta.put("isProsConsForum", "Y".equals(StringUtil.nvl(dscsVO.getOknokStngyn())));
        meta.put("dscsUnitTycd", dscsVO.getDscsUnitTycd());
        resultVO.setReturnVO(meta);
        return withFailMessage(resultVO);
    }

    // EZ-Grader 점수 입력 화면 로드
    @RequestMapping(value = "/ezgScoreView.do")
    public String getScoreView(DscsEzGraderVO vo, ModelMap model, HttpServletRequest request, @CurrentUser UserContext userCtx) {

        String orgId = StringUtil.nvl(userCtx.getOrgId());
        String userId = StringUtil.nvl(userCtx.getUserId());

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);
        if(vo.getStdId() != null) { 
            DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
            dscsJoinUserVO.setDscsId(vo.getDscsId());
            dscsJoinUserVO.setStdId(vo.getStdId());
        
            dscsJoinUserVO = dscsJoinUserService.selectDscsJoinUser(dscsJoinUserVO);
            model.addAttribute("dscsJoinUserVO",dscsJoinUserVO);
        }

        model.addAttribute("vo", vo);
        return "forum2/ezgPop/ezg_score";
    }

    // 점수 저장 처리
    @RequestMapping(value = "/saveScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> saveScore(
            DscsEzGraderRsltVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        String orgId = StringUtil.nvl(userCtx.getOrgId());
        String userId = StringUtil.nvl(userCtx.getUserId());

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        returnVo = dscsEzGraderService.saveScore(vo, request);

        return withFailMessage(returnVo);
    }

    // 점수 삭제 처리
    @RequestMapping(value = "/deleteScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> deleteScore(
            DscsEzGraderRsltVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        String orgId = StringUtil.nvl(userCtx.getOrgId());
        String userId = StringUtil.nvl(userCtx.getUserId());

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        returnVo = dscsEzGraderService.deleteScore(vo, request);

        return withFailMessage(returnVo);
    }

    // 토론 성적평가 > 피드백
    @RequestMapping(value = "/forumScoreEvalFeedBack.do")
    public String forumScoreEvalFeedBack(DscsVO dscsVO, ModelMap model, HttpServletRequest request) {

        /*참여자 정보*/
        if(!"EZG".equals(dscsVO.getSearchMenu())) {
            DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
            dscsJoinUserVO.setDscsId(dscsVO.getDscsId());
            dscsJoinUserVO.setStdId(dscsVO.getStdId());
        
            dscsJoinUserVO = dscsJoinUserService.selectDscsJoinUser(dscsJoinUserVO);
            model.addAttribute("dscsJoinUserVO",dscsJoinUserVO);
        }

        DscsFdbkVO dscsFdbkVO = new DscsFdbkVO();
        dscsFdbkVO.setDscsId(dscsVO.getDscsId());
        dscsFdbkVO.setStdId(dscsVO.getStdId());
        
        if(dscsVO.getTeamId() != null || dscsVO.getTeamId() != "") {
            dscsFdbkVO.setTeamId(dscsVO.getTeamId());
        }
        
        // 피드백 갯수
        int cntFdbk = dscsFdbkService.cntFdbk(dscsFdbkVO);
        
        // 메모
        DscsJoinUserVO mVO = dscsJoinUserService.getMemo(dscsVO);
        
        model.addAttribute("cntFdbk", cntFdbk);
        model.addAttribute("dscsVO", dscsVO);
        model.addAttribute("mVO", mVO);
        
        return "forum2/ezgPop/ezg_score_eval_feedback";
    }

}
